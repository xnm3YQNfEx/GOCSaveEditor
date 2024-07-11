use GOCSaveEditor;


fn main() {
    // Example of compressing an uncompressed save, without a pre-existing huffman tree
    GOCSaveEditor::decompress("./data/saves/SampleSave.01", "./data/output/decompressed.01");
    GOCSaveEditor::compress("./data/output/decompressed.01", "./data/output/compressed.01");
        // Testing compression using known good decompressed data, along with the Huffman tree from the original compressed save
    // The final compressed.01 that is output should be identical to the Samplesave.01 input
    // let original_compressed_save = fs::read("./data/saves/SampleSave.01")
    //     .expect("Should have been able to read the compressed save!");
    // let mut buf = ReadBuffer::new(original_compressed_save);

    // let tree = HuffmanNode::from_stream(&mut buf);

    // // This decompressed data is a known good sample, that matches how it is loaded onto the heap by the game.
    // let uncompressed_data = fs::read("./data/saves/SampleSave_decompressedv2.01")
    //     .expect("Should have been able to read the uncompressed save!");

    // let codes = HuffmanCode::from_tree(&tree);
    // HuffmanCode::describe(&codes);
    // let codes_array = HuffmanCode::as_array(&codes);
    // let encoded_data: Vec<u8> = HuffmanTable::encode(codes_array, uncompressed_data);
    // let encoded_tree = HuffmanTable::encode_tree(&tree.unwrap());

    // let mut compressed_file = fs::File::create( "./data/output/compressed.02").expect("Failed to create file!");
    // compressed_file.write_all(&encoded_tree).expect("Should have been able to write compressed file!");
    // compressed_file.write_all(&encoded_data).expect("Should have been able to write encoded data!");
}
