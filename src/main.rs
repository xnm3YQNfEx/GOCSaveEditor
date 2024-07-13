use GOCSaveEditor;


fn main() {
    GOCSaveEditor::decompress("./data/saves/SampleSave.01", "./data/output/decompressed.01");
    GOCSaveEditor::compress("./data/output/decompressed.01", "./data/output/compressed.01");
}
