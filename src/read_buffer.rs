// This "ReadBuffer" is just used to maintain it's own index when being passed
// through the recursive calls to build the huffman tree.

#[derive(Debug)]
pub struct ReadBuffer {
    pub data: Vec<u8>,
    pub read_pos: usize,
}

impl ReadBuffer {
    pub fn new(data: Vec<u8>) -> Self {
        Self {
            data: data,
            read_pos: 0
        }
    }

    // Returns the current byte, and increments the position
    // If already at end, returns nothing!
    pub fn read_byte(&mut self) -> Option<u8> {
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
    pub fn remaining_bits(&self) -> Vec<bool> {
        let mut bits = Vec::new();
        for &byte in &self.data[self.read_pos..] {
            for i in 0..8 {
                bits.push((byte >> (7 - i)) & 1 == 1);
            }
        }
        bits
    }
}
