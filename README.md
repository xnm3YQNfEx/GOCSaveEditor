# GOCSaveEditor
Gangsters Organized Crime Save and Scenario Editor

This is an attempt at reversing the save file format for the 1998 classic Gangsters Organized Crime. 
Very much a work in progress, will likely be bugs, and likely a project that will be abandoned when I get bored.

## Main goals
- Save decompresson
- Save recompression
- Analysis of the data structures within the save file
- Deserialization of game save into another data structure, maybe json?
- Reserialization of the json back to bytes

## Current Status
- Save decompression appears to be working, but I've only tried with a handful of saves, no real testing done yet
- Save compression does work, but only if you use an existing huffman tree from a save, this is my next goal to get working
- Unknown about any further processing that is required though there are a few weird data formatting issues in strings, though that could also be a bug in my code

## High level details of how the saves work
- Saves are not encrypted using anything like the xtx data files were.
- Saves use a combination of an RLE style compression first, afterwards they use [huffman coding](https://en.wikipedia.org/wiki/Huffman_coding) to compress the save file further
- When looking at the compressed save:
    - First 1532 bytes of the save is a huffman tree
    - The tree is a set of nested nodes, and the tree has exactly 256 leaf nodes (nodes with no children)
    - The first byte indicates the number of children a node has (will either be 0x00 for a leaf node, or 0x02 for an inner node)
        - If the first node is 0x02, the following byte will be a "direction" indicating whether the following data is for the left child node or right child node.
        - 0x4c or "L" is used for left node
        - 0x52 or "R" is usde for right node
        - After the direction marker, the following bytes immediately after are for the child node
    - The final byte will be the "symbol" value of the node
        - Inner nodes will still read in a byte, just the byte will always be 0x00 (there is one leaf node that will have a symbol of 0x00 as well)
- The tree is used to decode the remainder of the bytes before RLE decoding.
- The RLE scheme is pretty simple, and just compresses repeated bytes, which will mostly be null byte values
    - Read in a byte representing a length
    - If positive, read n bytes from the input into the output
    - If negative, insert the following byte into the output inverse n (making it positive) times
- Afterwards, the data is then used to construct various structs and objects for the games state
