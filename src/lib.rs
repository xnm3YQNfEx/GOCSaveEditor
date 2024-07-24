use std::fs;
use std::io::Write;


pub mod compression;
pub mod goc_save;

// input_path - Path to existing decompressed save file, including filename
// output_path - Path and filename for outputting the compressed save. directories must exist already!
// Mostly an example of how to use the compress and decompress 
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

// input_path - Path to existing compressed save file, including filename
// output_path - Path and filename for outputting the decompressed save. directories must exist already!
// Mostly an example of how to use the compress and decompress 
pub fn compress_file(input_path: &str, output_path: &str) {
    let mut data = fs::read( input_path )
        .expect("Should have been able to read the file");

    data = compression::compress(&data);
    let mut outfile = fs::File::create(output_path).expect("Failed to create file!");
    outfile.write_all(&data).expect("Should have been able to write!");
}

// input_path - reference to existing decompressed save data
// output_path - Path and base file name for outputting the save sections. directories must exist already!
// Creates many files, with a file extension that matches the section id/type. Used for debugging and analysis of the save structure.
pub fn output_save_sections(input_path: &str, output_path: &str)  {
    let data = fs::read(input_path);

    if data.is_ok() {
        let sections = goc_save::parse_save_sections(data.unwrap());
        for section in sections.iter() {
            let section_filename = format!("{}.{}", output_path, section.index);
            let mut section_file = fs::File::create(section_filename).expect("Should have been able to create file");
            section_file.write_all(&section.data).expect("Should have been able to write out section data!");
        }
    } else {
        println!("Failed to load save data!");
    }
}