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

// ============
// Huffman Node
// ============

#[derive(Debug, Eq, PartialEq)]
pub struct HuffmanNode {
    pub symbol: Option<u8>,
    pub frequency: usize,
    pub left: Option<Box<HuffmanNode>>, // Not sure if having it in a box is really worth it?
    pub right: Option<Box<HuffmanNode>>,
}

// Used when merging nodes in the tree when compressing data
impl Ord for HuffmanNode {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        other
            .frequency
            .cmp(&self.frequency)
            .then(self.symbol.cmp(&other.symbol))
    }
}

// Used when merging nodes in the tree when compressing data
impl PartialOrd for HuffmanNode {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(&other))
    }
}

// Node constructors
impl HuffmanNode {
    // Leafs contain no children, and only contain a symbol
    fn create_leaf_node(symbol: u8, frequency: usize) -> Self {
        Self {
            symbol: Some(symbol),
            frequency,
            left: None,
            right: None,
        }
    }

    // Nodes contain only two children, and don't have a symbol
    fn create_inner_node(frequency: usize, left: HuffmanNode, right: HuffmanNode) -> Self {
        Self {
            symbol: None,
            frequency,
            left: Some(Box::new(left)),
            right: Some(Box::new(right)),
        }
    }
}

impl HuffmanNode {
    // Used in compressing data to construct the huffman tree for encoding
    pub fn from_frequencies(frequencies: [usize; 256]) -> Option<Box<Self>> {
        let mut queue = BinaryHeap::new();

        for i in 0..256 {
            if frequencies[i] > 0 {
                queue.push(Self::create_leaf_node(i as u8, frequencies[i]))
            }
        }

        while queue.len() > 1 {
            if let (Some(left), Some(right)) = (queue.pop(), queue.pop()) {
                queue.push(Self::create_inner_node(left.frequency + right.frequency, left, right))
            }
        }

        match queue.pop() {
            None => None,
            Some(root) => Some(Box::new(root)),
        }
    }

    // Used to read in the huffman tree from a compressed save file for decoding
    fn from_stream(stream: &mut impl Iterator<Item = u8>) -> Option<Box<Self>> {
        let iterator_ref = stream.by_ref();

        let children = iterator_ref.next()?;
        let mut left: Option<Box<HuffmanNode>> = None;
        let mut right: Option<Box<HuffmanNode>> = None;

        if children > 0 {
            for _i in 0..children {
                let direction = iterator_ref.next()?;
                match direction {
                    0x4c => left = HuffmanNode::from_stream(iterator_ref),
                    0x52 => right = HuffmanNode::from_stream(iterator_ref),
                    _ => return None, 

                }
            }
        }

        let symbol= iterator_ref.next()?;
        if let (Some(left), Some(right)) = (left, right) {
            Some(Box::new(HuffmanNode::create_inner_node(0, *left, *right)))
        } else {
            Some(Box::new(HuffmanNode::create_leaf_node(symbol, 0)))
        }
    }
}

// ============
// Huffman Code
// ============

#[derive(Debug, Clone, Eq, PartialEq)]
pub struct HuffmanCode {
    pub symbol: u8,
    pub frequency: usize,
    pub length: usize,
    pub bits: u128,
}

impl HuffmanCode {
    // Construct the Codes Vector starting with the root of the tree
    // Organized by doing a depth first traversal, following the left node first.
    pub fn from_tree(tree: &Option<Box<HuffmanNode>>) -> Vec<Self> {
        fn collect(
            output: &mut Vec<HuffmanCode>,
            node: &Option<Box<HuffmanNode>>,
            indent: usize,
            bits: u128,
        ) {
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

    pub fn as_array(codes: &Vec<Self>) -> [&Self; 256] {
        const DEFAULT: HuffmanCode = HuffmanCode {
            symbol: 0,
            frequency: 0,
            length: 0,
            bits: 0,
        };

        let mut output_array: [&Self; 256] = [&DEFAULT; 256];

        for code in codes.iter() {
            output_array[code.symbol as usize] = code;
        }

        output_array
    }
}

#[derive(Debug)]
pub struct Huffman {}

impl Huffman {
    fn encode_tree(root: &HuffmanNode) -> Vec<u8> {
        let mut encoded_tree: Vec<u8> = Vec::new();
        Huffman::serialize_node(root, &mut encoded_tree);
        encoded_tree
    }

    fn serialize_node(node: &HuffmanNode, encoded_tree: &mut Vec<u8>) {
        if let Some(symbol) = node.symbol {
            encoded_tree.push(0); // 0 children
            encoded_tree.push(symbol);
        } else {
            encoded_tree.push(2); // 2 children
            if let Some(left) = &node.left {
                encoded_tree.push(0x4c);
                Huffman::serialize_node(left, encoded_tree);
            }
            if let Some(right) = &node.right {
                encoded_tree.push(0x52);
                Huffman::serialize_node(right, encoded_tree);
            }
            encoded_tree.push(0x00); // symbol for node variant
        }
    }

    pub fn encode(data: &Vec<u8>) -> Vec<u8> {
        let mut byte: u8 = 0;
        let mut bits_written = 0;

        let mut frequencies = [0; 256];
        for key in data.iter() {
            frequencies[*key as usize] += 1;
        }
    
        // Construct the tree based off of the frequencies
        let tree = HuffmanNode::from_frequencies(frequencies);
        let codes = HuffmanCode::from_tree(&tree);
        let codes_array = HuffmanCode::as_array(&codes);
    
        let mut encoded_data = Huffman::encode_tree(&tree.unwrap());

        for &symbol in data.iter() {
            let code = codes_array[symbol as usize];
            for i in 0..code.length {
                let bit = (code.bits >> (code.length - 1 - i)) & 1 == 1;
                byte |= (bit as u8) << (7 - (bits_written));
                bits_written += 1;

                if bits_written == 8 {
                    encoded_data.push(byte);
                    byte = 0;
                    bits_written = 0;
                }
            }
        }

        if bits_written > 0 {
            encoded_data.push(byte);
        }

        encoded_data
    }

    // Takes in the root node of a table, along with a bit vector of compressed data
    // Outputs the decompressed data, or nothing if it failed to decode.
    pub fn decode(data: &Vec<u8>) -> Option<Vec<u8>> {
        let mut data_iterator = data.iter().copied();
        let root = HuffmanNode::from_stream(&mut data_iterator)?;
        let mut decoded_data = Vec::new();
        let mut current_node = &root;

        let mut bits = Vec::new();
        for byte in data_iterator {
            for i in 0..8 {
                bits.push((byte >> (7 - i)) & 1 == 1);
            }
        }

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
                current_node = &root;
            }
        }
        Some(decoded_data)
    }
}
