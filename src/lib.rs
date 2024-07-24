use std::fs;
use std::io::Write;

pub mod compression;

pub fn decompress_file(input_path: &str, output_path: &str) {
    let data = fs::read( input_path )
        .expect("Should have been able to read the file");

    if let Some(data) = compression::decompress(&data){
        let mut outfile = fs::File::create(output_path).expect("Failed to create file!");
        outfile.write_all(&data).expect("Should have been able to write!");
        
    } else {
        println!("Failed to decompress {}", input_path)
    }
}

pub fn compress_file(input_path: &str, output_path: &str) {
    let mut data = fs::read( input_path )
        .expect("Should have been able to read the file");

    data = compression::compress(&data);
    let mut outfile = fs::File::create(output_path).expect("Failed to create file!");
    outfile.write_all(&data).expect("Should have been able to write!");
}