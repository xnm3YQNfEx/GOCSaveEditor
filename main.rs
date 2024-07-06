use std::io::Write;
use std::fs;
use std::collections::BinaryHeap;

// Huffman Implementation based off of following guide:
// https://levelup.gitconnected.com/learning-rust-huffman-coding-64acc812cda?gi=22f90bcab323
// https://github.com/amacal/learning-rust/

/* 
MIT License

Copyright (c) 2023 Adrian Macal

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

// Maybe other resource
// https://pramode.in/2016/09/26/huffman-coding-in-rust/


// This "ReadBuffer" is just used to maintain it's own index when being passed
// through the recursive calls to build the huffman tree.

#[derive(Debug)]
pub struct ReadBuffer {
    data: Vec<u8>,
    read_pos: usize,
}

impl ReadBuffer {
    fn new(data: Vec<u8>) -> Self {
        Self {
            data: data,
            read_pos: 0
        }
    }

    // Returns the current byte, and increments the position
    // If already at end, returns nothing!
    fn read_byte(&mut self) -> Option<u8> {
        let data_len = self.data.len();
        let new_pos = self.read_pos + 1;
        if new_pos > data_len {
            None
        } else {
            let value = self.data[self.read_pos];
            self.read_pos += 1;
            Some(value)
        }
    }

    // Returns the data from the current position to the end as a bool vector
    fn remaining_bits(&self) -> Vec<bool> {
        let mut bits = Vec::new();
        for &byte in &self.data[self.read_pos..] {
            for i in 0..8 {
                bits.push((byte >> (7 - i)) & 1 == 1);
            }
        }
        bits
    }
}



// HuffmanNode is used to construct the binary tree
#[derive(Debug, Eq, PartialEq)]
pub struct HuffmanNode {
    symbol: Option<u8>,
    frequency: usize,
    left: Option<Box<HuffmanNode>>,
    right: Option<Box<HuffmanNode>>
}

// Used when merging nodes in the tree when compressing data
impl Ord for HuffmanNode {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        other.frequency.cmp(&self.frequency).then(self.symbol.cmp(&other.symbol))
    }
}

// Used when merging nodes in the tree when compressing data
impl PartialOrd for HuffmanNode {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(&other))
    }
}

impl HuffmanNode {
    fn leaf(symbol: u8, frequency: usize) -> Self {
        Self { symbol: Some(symbol), frequency: frequency, left: None, right: None }
    }
    fn node(frequency: usize, left: HuffmanNode, right: HuffmanNode) -> Self {
        Self { symbol: None, frequency: frequency, left: Some(Box::new(left)), right: Some(Box::new(right)) }
    }
}

impl HuffmanNode {
    // This is only used when compressing data without an existing tree
    pub fn from_frequencies(frequencies: [usize; 256]) -> Option<Box<Self>> {
        let mut queue = BinaryHeap::new();
        
        for i in 0..256 {
            if frequencies[i] > 0 {
                queue.push(Self::leaf(i as u8, frequencies[i]))
            }
        }

        while queue.len() > 1 {
            if let (Some(left), Some(right)) = (queue.pop(), queue.pop()) {
                queue.push(Self::node(left.frequency + right.frequency, left, right))
            }
        }

        match queue.pop() {
            None => None,
            Some(root) => Some(Box::new(root))
        }
    }

    // Used to read in the huffman tree from a compressed save file
    pub fn from_stream(stream: &mut ReadBuffer) -> Option<Box<Self>> {
        let mut left: Option<Box<HuffmanNode>> = None;
        let mut right: Option<Box<HuffmanNode>> = None;

        if let Some(children) = stream.read_byte() {
            if children > 0 {
                for _i in 0..children{
                    if let Some(direction) = stream.read_byte() {
                        if direction == 0x4c {
                            println!("LeftNode");
                            left = HuffmanNode::from_stream(stream);
                        } else if direction == 0x52 {
                            println!("RightNode");
                            right = HuffmanNode::from_stream(stream);
                        }
                    }
                }
            } 
            
            if let Some(symbol) = stream.read_byte() {
                println!("Found symbol {:02x}", symbol);
                if left.is_none() || right.is_none() {
                    // If either left or right is None, create a leaf node
                    return Some(Box::new(HuffmanNode::leaf(symbol, 0)));
                } else {
                    // Create an internal node
                    return Some(Box::new(HuffmanNode::node(0, *left.unwrap(), *right.unwrap())));
                }
            }
        }
        None
    }
}


// At the moment, this is only really used for debugging, displaying the mapping of symbol to huffman codes
#[derive(Debug, Clone, Eq, PartialEq)]
pub struct HuffmanCode {
    symbol: u8,
    frequency: usize,
    length: usize,
    bits: u128
}

impl HuffmanCode {
    // Construct the Codes Vector starting with the root of the tree
    // Organized by doing a depth first traversal, following the left node first.
    pub fn from_tree(tree: &Option<Box<HuffmanNode>>) -> Vec<Self> {
        fn collect(output: &mut Vec<HuffmanCode>, node: &Option<Box<HuffmanNode>>, indent: usize, bits: u128) {
            if let Some(node) = node {
                if let Some(symbol) = node.symbol {
                    output.push(HuffmanCode {
                        symbol: symbol,
                        frequency: node.frequency,
                        length: indent,
                        bits: bits,
                    });
                }

                collect(output, &node.left, indent + 1, bits << 1);
                collect(output, &node.right, indent + 1, bits << 1 | 0x1);
            }
        }

        let mut result = Vec::with_capacity(256);
        collect(&mut result, &tree, 0, 0);
        result
    }

    // Creates a Vector organized by the depth of the symbol within the tree.
    // Shallower symbols (more frequent ones), will appear near the top of the list.
    pub fn as_canonical(codes: &Vec<Self>) -> Vec<Self> {
        let mut sorted: Vec<Self> = codes.iter().cloned().collect();

        sorted.sort();

        let mut bits = 0;
        let mut length = 0;

        for code in sorted.iter_mut() {
            while length < code.length {
                bits <<= 1;
                length += 1;
            }

             code.bits = bits;
             bits += 1;
        }

        sorted
    }

    // Used to output the codes in a tabular format
    pub fn describe(codes: &Vec<Self>) {
        for code in codes.iter() {
            println!(
                "{:>3}\t{}\t{}\t{:0width$b}",
                code.symbol,
                code.frequency,
                code.length,
                code.bits,
                width = code.length
            )
        }
    }
}


impl Ord for HuffmanCode {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.length.cmp(&other.length).then(self.symbol.cmp(&other.symbol))
    }
}

impl PartialOrd for HuffmanCode{
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(&other))
    }
}


// This table needs some work. Not sure I really care about maintaining lists of the counts and symbols
#[derive(Debug)]
pub struct HuffmanTable{
    counts: [u8; 16],
    symbols: [u8; 256],
}

impl HuffmanTable {
    // Not really sure what this is useful for, mostly debugging I guess.
    pub fn from_codes(codes: &Vec<HuffmanCode>) -> Self {
        let mut counts = [0; 16];
        let mut symbols = [0; 256];
        let mut offset = 0;
        
        for code in codes.iter() {
            counts[code.length as usize] += 1;
            symbols[offset] = code.symbol;
            offset += 1;
        }

        Self {
            counts: counts,
            symbols: symbols
        }
    }

    // Takes in the root node of a table, along with a bit vector of compressed data
    // Outputs the decompressed data, or panics.
    pub fn decode(root: &HuffmanNode, bits: Vec<bool>) -> Vec<u8> {
        let mut decoded_data = Vec::new();
        let mut current_node = root;

        for bit in bits {
            if bit {
                if let Some(ref right) = current_node.right {
                    current_node = right;
                }
            } else {
                if let Some(ref left) = current_node.left {
                    current_node = left;
                } else {
                    panic!("Invalid Huffman tree");
                }
            }

            if current_node.symbol.is_some() {
                decoded_data.push(current_node.symbol.unwrap());
                current_node = root;
            }
        }
        decoded_data
    }

    pub fn describe(&self) {
        println!("Counts: {:?}", self.counts);
        println!("Symbols: {:?}", self.symbols);
    }
}


fn main() {
    // Example of looking at reading in uncompressed data and making the table
    let mut frequencies = [0; 256]; // We known the save can have any byte value
    let content = fs::read("./data/saves/SampleSave_decompressedv2.01")
        .expect("Should have been able to read the file");

    for key in content.iter() {
        frequencies[*key as usize] += 1;
    }

    // Construct the tree based off of the frequencies
    let tree = HuffmanNode::from_frequencies(frequencies);

    // Output the codes
    let codes = HuffmanCode::from_tree(&tree);
    println!("\nCodes:\n=========");
    HuffmanCode::describe(&codes);

    let canonical = HuffmanCode::as_canonical(&codes);
    println!("\nCanonical:\n=========");
    HuffmanCode::describe(&canonical);

    let table = HuffmanTable::from_codes(&canonical);
    println!("\nTable:\n=========");
    table.describe();


    // Reading in a compressed file and decompressing it 
    let compressed = fs::read("./data/saves/SampleSave.01")
        .expect("Should have been able to read the file");

    let mut buf = ReadBuffer::new(compressed);
    let tree2 = HuffmanNode::from_stream(&mut buf);
    let bits = buf.remaining_bits();
    if let Some(root) = tree2 {
        let decompressed = HuffmanTable::decode(&root, bits);

        // Output path must exist or it will panic!
        let mut outfile = fs::File::create("./data/output/foo.01").expect("Failed to create file!");
        outfile.write_all(&decompressed).expect("Should have been able to write!");
    }   
}
