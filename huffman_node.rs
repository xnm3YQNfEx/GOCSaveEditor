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

use std::collections::BinaryHeap;
use crate::read_buffer::ReadBuffer;

// HuffmanNode is used to construct the binary tree
#[derive(Debug, Eq, PartialEq)]
pub struct HuffmanNode {
    pub symbol: Option<u8>,
    pub frequency: usize,
    pub left: Option<Box<HuffmanNode>>,
    pub right: Option<Box<HuffmanNode>>
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
                            left = HuffmanNode::from_stream(stream);
                        } else if direction == 0x52 {
                            right = HuffmanNode::from_stream(stream);
                        }
                    }
                }
            } 
            
            if let Some(symbol) = stream.read_byte() {
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