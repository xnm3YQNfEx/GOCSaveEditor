# GOCSaveEditor
Gangsters Organized Crime Save and Scenario Editor

This is an attempt at reversing the save file format for the 1998 classic Gangsters Organized Crime. 
Very much a work in progress, will likely be bugs, and likely a project that will be abandoned when I get bored.

## Building
- Starting with an existing Rust development environment
- Run `cargo build`

## Running
- Currently there is no CLI or GUI interface, no arguments, nothing aside from some hard coded paths in main.rs
- Some examples of how to do compression and decompression are already present, just update as needed first.
- Save and then run `cargo run`

## Main goals
- Save decompresson
- Save recompression
- Analysis of the data structures within the save file
- Deserialization of game save into another data structure, maybe json?
- Reserialization of the json back to bytes

## Updates
### 2024-10-12
- Got a little burned out trying to do a deep dive into the Gang data section.
- Good progress on it but needed to take a break for a bit.

### 2024-07-24
- Initial refactor mostly done, need to add unit tests still
- Starting to work on save parsing, added function to split the decompressed save into individual sections
    - Also added function to dump each section to a different file for further analysis
- Currently evaluating possible Rust GUI frameworks. 
    - Ideally cross platform (mostly as a learning opportunity for use in future projects)
    - Choices are GTK3, GTK4, FLTK, and Tauri

### 2024-07-14
- Decompression and compression are both working.
- Need to do a clean up of the code a bit, after that going to look into using python for a basic front end
- Looking into save format now, some details now added below

### 2024-07-10 
- Decompression appears to be working, but I've only tried with a handful of saves, no real testing done yet
- Compression isn't complete, currently the compressed saves will be corrupted due to not using proper RLE encoding as the first step, should be added soon!

# Save File Details
## High level details of how the compression works
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
    - Can have multiple chunks that are the same type in a row, with maximum length of a chunk being 126
- Afterwards, the data is then used to construct various structs and objects for the games state

## Save file structure
- first dword appears to be a count of objects, so far it's always been 0x19 for both saves and scenarios.
- from there it loads the save data into a set of structs creating a linked list in a for loop using the previous dword as the limit
    - Game then reads in a byte for the id or index of the first object. Stores it at offset 0x00. Game does check to see if multiple sections have the same value, likely to some exception handler.
    - Reads in a dword, unknown what it's for, and always seems to be 0x00000000.
    - Reads in the size of the data as a dword, likely usize datatype. stores this at 0x10
    - Allocates memory, and reads in the data into allocation


```
| Offset | Size  | Description                                          |
| ------ | ----- | ---------------------------------------------------- |
| 0x00   | byte  | some index or id value                               |
| 0x04   | dword | pointer to data on heap                              |
| 0x08   | dword | unknown, haven't seen it used yet                    |
| 0x0c   | dword | size of allocation on heap                           |
| 0x10   | dword | size of data in save                                 | 
| 0x14   | dword | unknown, generally 0x00000000 read in from save data |
| 0x18   | dword | pointer to next item in list                         |
```

Here's how the base structure of the decompressed South of the River scenario looks, the saves use the same structure

![image](https://github.com/user-attachments/assets/ddd673d3-35d7-429c-90dd-7246c49cdffa)
![image](https://github.com/user-attachments/assets/9bb6917b-0be9-4719-ac0b-7a54472a21e4)

Here's one of the sections for one of the gangs

![image](https://github.com/user-attachments/assets/877c8801-4de5-478e-bc09-78e15340c244)

And their starting money:

![image](https://github.com/user-attachments/assets/f22b214c-7653-4abf-b589-b6186ead74cb)


## Sections

Section numbers here are integer values rather than the hex representation. Only sections with some findings are listed below.

### 1 - Economy Data
Section is mostly just the same data found in xtx data files. The game doesn't read in this data from xtx files when loading a save/scenario with the exception of the strings from economics.xtx and illegal economics.xtx. Assumption is they are more so a template to make localisation easy. When starting a new game from a scenario, the number of businesses within the two xtx files that strings are read from must match the number of businesses in the scenario. It does appear to be possible to change the number of businesses if you don't use scenarios, and start a new game. There's 69 bytes of data (nice) that I'm still not sure what it's for. I think 64 bytes are related to Economics.xtx in some way. Appears to be 16 u32 values?

0, 117, 150, 152, 151, 153, 156, 170, 2, 2, 2, 2, 79, 30, 33, 23

```
Hex View  00 01 02 03 04 05 06 07  08 09 0A 0B 0C 0D 0E 0F
 
00000000  00 00 00 00 75 00 00 00  96 00 00 00 98 00 00 00  ....u...........
00000010  97 00 00 00 99 00 00 00  9C 00 00 00 AA 00 00 00  ................
00000020  02 00 00 00 02 00 00 00  02 00 00 00 02 00 00 00  ................
00000030  4F 00 00 00 1E 00 00 00  21 00 00 00 17 00 00 00  O.......!.......
```

Contains data from these files:
- Economics.xtx
- Running Costs.xtx
- Income Groups.xtx
- Empty Land Cost.xtx
- Market Share.xtx
- Land Value Reductions.xtx
- Illegal Economics.xtx
- Illegal Profit.xtx

### 6 
- Possibly red gang, or player gang?

### 7 
- Gang data, maybe green?

### 8
- Gang data, maybe blue?

### 9
- Gang data, maybe orange?

### 13
- Street names

### 17
- Don't know, haven't come across this in a save yet

### 18
- Last week report data
- 785 bytes unaccounted for, with mostly null values

### 24
- Contains a string with the version of the game that produced the save/scenario.
- String seems to be both null terminated and have a length?
- GOG Release uses "V1.0b2r291098-01(E)"
- Have yet to review, I'm assuming it's checked before rest of save is parsed? 

### 25
- Contains some info about scenario used to start game
- Have yet to look more into it, so unknown really what it's used for
