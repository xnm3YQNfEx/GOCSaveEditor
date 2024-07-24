use GOCSaveEditor;


fn main() {
    GOCSaveEditor::decompress_file("./data/tests/03_SOTR1_huffmanencoded.bin", "./data/output/decompressed.01");
    GOCSaveEditor::compress_file("./data/tests/01_SOTR1_originalgamestate.bin", "./data/output/compressed.01");
    GOCSaveEditor::output_save_sections("./data/output/decompressed.01", "./data/output/decompressed.01")
}
