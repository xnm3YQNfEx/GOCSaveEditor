use GOCSaveEditor;


fn main() {
    GOCSaveEditor::decompress_file("./data/saves/SampleSave.01", "./data/output/decompressed.01");
    GOCSaveEditor::compress_file("./data/output/decompressed.01", "./data/output/compressed.01");
    GOCSaveEditor::decompress_file("./data/output/compressed.01", "./data/output/decompressed.02");
}
