use huffman_node::HuffmanNode;
use huffman_code::HuffmanCode;
use read_buffer::ReadBuffer;
use std::fs;
use std::io::Write;

mod read_buffer;
mod huffman_node;
mod huffman_code;


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

    pub fn encode_tree(root: &HuffmanNode) -> Vec<u8> {
        let mut encoded_tree: Vec<u8> = Vec::new();
        HuffmanTable::serialize_node(root, &mut encoded_tree);
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
                HuffmanTable::serialize_node(left, encoded_tree);
            }
            if let Some(right) = &node.right {
                encoded_tree.push(0x52);
                HuffmanTable::serialize_node(right, encoded_tree);
            }
            encoded_tree.push(0x00); // symbol for node variant
        }
    }

    pub fn encode(codesheet: [&HuffmanCode; 256], data: Vec<u8>) -> Vec<u8>{

        let mut encoded_data: Vec<u8> = Vec::new();
        let mut byte: u8 = 0;
        let mut bits_written = 0;

        for &symbol in data.iter() {
            let code = codesheet[symbol as usize];
            //println!("{:b}\t{}", code.bits, code.length);
            for i in 0..code.length {
                let bit = (code.bits >> (code.length -1 - i)) & 1 == 1;
                // println!("Putting bit {:b} into the byte", bit as u8);
                byte |= (bit as u8) << (7 - (bits_written));
                bits_written += 1;

                if bits_written == 8 {
                    // println!("Writing {:08b}", byte);
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


pub fn compress(input_path: &str, output_path: &str){
    let mut frequencies = [0; 256]; // We known the save can have any byte value
    let content = fs::read( input_path )
        .expect("Should have been able to read the file");

    for key in content.iter() {
        frequencies[*key as usize] += 1;
    }

    // Construct the tree based off of the frequencies
    let tree = HuffmanNode::from_frequencies(frequencies);
    let codes = HuffmanCode::from_tree(&tree);
    let codes_array = HuffmanCode::as_array(&codes);
    let encoded_data: Vec<u8> = HuffmanTable::encode(codes_array, content);

    let tree_data = HuffmanTable::encode_tree(&tree.unwrap());
    
    let mut compressed_file = fs::File::create(output_path).expect("Failed to create file!");
    compressed_file.write_all(&tree_data).expect("Should have been able to write compressed file!");
    compressed_file.write_all(&encoded_data).expect("Should have been able to write encoded data!");
}

pub fn decompress(input_path: &str, output_path: &str) {
    let compressed = fs::read(input_path)
        .expect("Should have been able to read the file");

    let mut buf = ReadBuffer::new(compressed);
    let tree2 = HuffmanNode::from_stream(&mut buf);
    let bits = buf.remaining_bits();
    if let Some(root) = tree2 {
        let decompressed = HuffmanTable::decode(&root, bits);

        // Output path must exist or it will panic!
        let mut outfile = fs::File::create(output_path).expect("Failed to create file!");
        outfile.write_all(&decompressed).expect("Should have been able to write!");

    }
}
