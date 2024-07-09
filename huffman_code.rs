use crate::huffman_node::HuffmanNode;

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

// At the moment, this is only really used for debugging, displaying the mapping of symbol to huffman codes
#[derive(Debug, Clone, Eq, PartialEq)]
pub struct HuffmanCode {
    pub symbol: u8,
    pub frequency: usize,
    pub length: usize,
    pub bits: u128
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

    pub fn as_array(codes: &Vec<Self>) -> [&Self; 256] {
        const DEFAULT: HuffmanCode = HuffmanCode {
            symbol: 0,
            frequency: 0,
            length: 0,
            bits: 0
        };

        let mut output_array: [&Self; 256] = [&DEFAULT; 256];
        
        for code in codes.iter(){
            output_array[code.symbol as usize] = code;
        }

        output_array
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
