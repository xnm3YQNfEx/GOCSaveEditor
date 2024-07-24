use std::collections::VecDeque;
use byteorder::{ByteOrder, LittleEndian};


pub struct SaveSection {
    pub index: u8,
    unknown: u32,
    size: usize,
    pub data: Vec<u8>
}

impl SaveSection {
    pub fn new(index: u8, unknown: u32, size: usize, data: Vec<u8>) -> Self {
        Self {
            index: index,
            unknown: unknown,
            size: size,
            data: data
        }
    }
}

fn pop_u32(deque: &mut VecDeque<u8>) -> Option<u32> {
    if deque.len() >= 4 {
        let mut buf = [0; 4];
        for i in 0..4 {
            buf[i] = deque.pop_front().unwrap();
        }
        Some(LittleEndian::read_u32(&buf))
    } else {
        None
    }
}

pub fn parse_save_sections(data: Vec<u8>) -> Vec<SaveSection>{

    let mut data_queue: VecDeque<u8> = VecDeque::new();
    data_queue.extend(data);
    let mut result: Vec<SaveSection> = Vec::new();

    if let Some(value) = pop_u32(&mut data_queue) {
        let sections = value;
        println!("There are {} sections in the save file", sections);

        for _i in 0..sections {
            if data_queue.len() >= 9 {
                let index = data_queue.pop_front().unwrap();
                let unknown = pop_u32(&mut data_queue).unwrap();
                let size = pop_u32(&mut data_queue).unwrap() as usize;
                let data: Vec<u8> = data_queue.drain(..size).collect();

                println!("Section {}, Section Size {}", index, size);
                let section = SaveSection::new(index, unknown, size, data);
                result.push(section);
            } else {
                println!("Not enough data for section!");
            }
        }
        println!("Remaining Bytes: {}", data_queue.len());
    }
    result
}
