# GOCSaveEditor
Gangsters Organized Crime Save and Scenario Editor

This is an attempt at reversing the save file format for the 1998 classic Gangsters Organized Crime. 
Very much a work in progress, and likely a project that will be abandoned when I get bored.

## Main goals
- Save decompresson
- Save recompression
- Analysis of the data structures within the save file
- Deserialization of game save into another data structure, maybe json?
- Reserialization of the json back to bytes

## Current Status
- Save decompression is working
- Save compression does work, but only if you use an existing huffman tree from a save, this is my next goal to get working

## High level details of how the saves work
- Saves are not encrypted using anything like the xtx data files were.
- Saves use some variant of [huffman coding](https://en.wikipedia.org/wiki/Huffman_coding) to compress the save file
- First 1532 bytes of the save is a huffman tree
- How to parse the tree is difficult for me to explain, but check the PoC python script for the parse_save_tree function
- The tree is used to decode the remainder of the bytes
