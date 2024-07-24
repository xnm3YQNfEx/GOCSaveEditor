use crate::compression::huffman::Huffman;
use crate::compression::rle::RLE;

mod huffman;
mod rle;

pub fn compress(data: &Vec<u8>) -> Vec<u8> {
    let rle_data = RLE::encode(&data);
    let compressed_data = Huffman::encode(&rle_data);
    compressed_data
}

pub fn decompress(data: &Vec<u8>) -> Option<Vec<u8>> {
    if let Some(rle_data) = Huffman::decode(data) {
        let decompressed_data = RLE::decode(&rle_data);
        return decompressed_data;
    }
    None
}
