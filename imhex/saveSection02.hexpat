#pragma pattern_limit 100000000000
#pragma array_limit 1000000000000
#include <std/string.pat>
#include <std/io.pat>
#include <std/core.pat>
// I believe this is data for the city. Tiles, businesses, etc?
// Naming is an absolute mess as I have no clue what any values actually do, though the structure should be mostly correct.
// Data types are unknown but the bit sizes should be correct.
// Need to finish up Case 5 and Case 6 structs, need sample data first before I trace through them

// Also, all structs are purely based off of the save data. The way they are organized in the in game memory is nothing like in the save.


// Unknown Struct 01
struct s02_us01 { // Read in like a tuple at 0x00658239
    u32 s02us01_1;
    u32 s02us01_2;
};


// Unknown Struct 02
struct s02_us02 { // Read in at 0x006062f0
    u16 s02us02_1;
    u16 s02us02_2;
    u8 s02us02_3;
    u8 s02us02_4;
};

// Unknown Struct 03, sub struct 01
struct s02_us03_sub01 {
    u8 s02us03s01_1;
    u8 s02us03s01_2;    
};


// Unknown Struct 03
struct s02_us03 {

    u32 s02us03_01;
    if (s02us03_01 !=0) {
        u8 s02us03_02;
        u8 s02us03_03;
        u8 s02us03_04;
        u8 s02us03_05;
        s02_us03_sub01 s02us03_06[4];
    }
};

struct obj_007815a8 {
    u8 obj_007815a8_01;
    u8 obj_007815a8_02;
    u8 obj_007815a8_03;
    u16 obj_007815a8_04;
    u8 obj_007815a8_05;
    u8 obj_007815a8_06;
    s02_us02 obj_007815a8_07;
};

struct obj_00780890 {
    u8 obj_00780890_01;
    u8 col;
    u8 row;
    u8 obj_00780890_04;
    u32 obj_00780890_05;
    obj_007815a8 obj_00780890_06[obj_00780890_05];
    u8 obj_00780890_07;
    // Following is read in by separate function 0x00726430
    u8 floors_count;
    u16 floors_idx[floors_count];
    u8 floors_up_level[floors_count];
    u16 tile_grp_idx;
    u16 med_floor_idx;
    u16 basement_idx;
    u8 obj_00780890_14;
};

// Case 0 and local 30 is 0
struct obj_00782040 : obj_00780890 {
    u8 obj_00782040_01;
    u8 obj_00782040_02;
    u8 obj_00782040_03;
    u8 obj_00782040_04;
    u8 obj_00782040_05;
};

// Case 0 and local 30 is not 0
struct obj_00780eb8 : obj_00782040 {
    u16 obj_00780eb8_01;
};

// Case 1
struct obj_0077f710 : obj_00780890 {
    u8 obj_0077f710_01;
    u8 obj_0077f710_02;
    u8 obj_0077f710_03;
    u16 obj_0077f710_04;
    u8 obj_0077f710_05;
    u16 obj_0077f710_06;
    u16 obj_0077f710_07;
    u8 obj_0077f710_08;
    u8 obj_0077f710_09;
};

//Case 2
struct obj_00781600 : obj_0077f710 {
    u8 obj_00781600_01;
    u8 obj_00781600_02;
    u16 obj_00781600_03;
    u32 obj_00781600_04;
    u32 obj_00781600_05;
    u32 obj_00781600_06;
    s02_us02 obj_00781600_07;
    u8 obj_00781600_08;
    u8 obj_00781600_09;
    u16 obj_00781600_10;
    u8 obj_00781600_11;
    u16 obj_00781600_12;
    u16 obj_00781600_13;
    u16 obj_00781600_14;
    u16 obj_00781600_15;
    u16 obj_00781600_16;
    u16 obj_00781600_17;
    u16 obj_00781600_18;
    u32 obj_00781600_19;;
};

// Case 3 and a value is -1
struct obj_00780ac0 : obj_0077f710 {
    u8 obj_00780ac0_01;
    u16 obj_00780ac0_02;
    u16 obj_00780ac0_03;
    u8 obj_00780ac0_04;
    u8 obj_00780ac0_05;
    u16 obj_00780ac0_06;
    u8 obj_00780ac0_07;
    u16 obj_00780ac0_08;
    u16 obj_00780ac0_09;
    u16 obj_00780ac0_10;
    u16 obj_00780ac0_11;
    u8 obj_00780ac0_12;
    u32 obj_00780ac0_13;
    u16 obj_00780ac0_14;
    u16 obj_00780ac0_15;
    u16 obj_00780ac0_16;
    u32 obj_00780ac0_17;
};

// Case 3 when a value isn't -1, and also used by case 9 when it's value isn't -1
struct obj_00781260 : obj_00780ac0 {
    // Struct doesn't add any new members, likely just virtual function changes
};

// Case 4
// Haven't seen this in a save yet, though very simple so likely correct

struct obj_00781b58 : obj_00781600 {
    u8 obj_00781b58_01;
    u8 obj_00781b58_02;
    u8 obj_00781b58_03;
};

// Case 5
// Haven't seen this yet, and it's very confusing to follow
// I'm going to wait until I have a save with this in it.


// Case 6

struct obj_0077f8b0 : obj_0077f710 {
    u16 obj_0077f8b0_01;   
    u16 obj_0077f8b0_02;
    u16 obj_0077f8b0_03; 
    u32 obj_0077f8b0_04;
    u32 obj_0077f8b0_05;
    
    // NOT COMPLETE, continues on based off of value in obj_0077f8b0_05 but it's always been 0 so far...
    // 0x0052c4f2 is where it does the check
    // Again, like Case 5, it's too confusing to follow without some sample data
};


// Case 7
struct obj_0077fac8 : obj_0077f710 {
    u32 obj_0077fac8_01;
    u32 obj_0077fac8_02;
    u32 obj_0077fac8_03;
};

// Case 8

struct obj_00781a10 : obj_0077f710 {
    u8 obj_00781a10_01;    
};

// Case 9
struct obj_0077ff68 : obj_00780ac0 {
    u32 obj_0077ff68_01;
};


//Case 10
struct obj_007801b0 : obj_0077f710 {
};

// Unknown struct 04, sub struct 01
struct s02_us04_s01 {
    u8 s02us04s01_01;  // Some sort of type enum maybe? Cases for 0 to 13? except no 11???
    s32 s02us04s01_02;
    u32 s02us04s01_03;
    u32 marker = u16(s02us04s01_02);
    marker += (u16(s02us04s01_03) << 16);
    //std::print("{:x}", marker);
    match (s02us04s01_01,s02us04s01_03, s16(s02us04s01_02)) {
        (0, 0, _):
            obj_00782040;
        (0, 1, _):
            obj_00780eb8;
        (1,_,_):
            obj_0077f710;
        (2,_,_):
            obj_00781600;
        (3,_,-1):
            obj_00780ac0; 
        (3,_,0 ... 32767):    
            obj_00781260;
        (6,_,_):
            obj_0077f8b0;
        (7,_,_):
            obj_0077fac8;
        (8,_,_):
            obj_00781a10;
        (9,_,-1):
            obj_0077ff68;
        (9,_,0 ... 32767): // I tried to use a wildcard, but it kept saying it was ambiguous...
            obj_00781260;
        (10,_,_):
            obj_007801b0;
        (12|13,_,_):
            obj_00780890;
    }
};

// Unknown Struct 04
// Possible constructor at 0x00645890
// Read in  at 0x0054ee90
// This is a bit confusing to follow with switch statements and more fun stuff
struct map_tiles {


    u16 id = std::core::array_index();
    
    std::print("{}", id);
    u8 s02us04_01;
    u8 s02us04_02;
    u8 s02us04_03;
    u8 s02us04_04;
    u32 little_map_idx;
    u32 s02us04_06;
    u8 s02us04_07;
    u32 s02us04_08;
    // I don't understand the logic around this yet, it reads in 5, and then based off of the ptr address of the "marker", it will loop again?
    
    
    s02_us04_s01 line_1[5];
    s02_us04_s01 line_2[5];
    s02_us04_s01 line_3[5];    
    s02_us04_s01 line_4[5];
    s02_us04_s01 line_5[5];    
};

struct s02_us05_s02 {
    u8 s02us05s02_01;
    u8 s02us05s02_02;
    u8 s02us05s02_03;
    u8 s02us05s02_04;
};

struct s02_us05_s01 {
    u8 s02us05s01_01_count;
    u8 s02us05s01_02_count;
    u8 s02us05s01_03_count;
    u8 s02us05s01_04_count;
    
    s02_us05_s02 s02us05s02_01[s02us05s01_01_count];
    s02_us05_s02 s02us05s02_02[s02us05s01_02_count];
    s02_us05_s02 s02us05s02_03[s02us05s01_03_count];
    s02_us05_s02 s02us05s02_04[s02us05s01_04_count];
};


// Constructed at 004645e0
struct s02_us05 {
    u32 s02us05_count;
    s02_us05_s01 s02us05_01[s02us05_count];
};    



struct section02 { // Constructed in main section handling around 0x0065809a
    u32 unknown1; // Used to set globals 0x009008e4 and 0x009008e0
    u32 unknown2;   
    u32 width;
    u32 height;
    u32 unknown5;
    u32 unknown6;
    u8 unknown7;
    u8 unknown8;
    u32 unknown9;
    u32 unknown10;
    u32 unknown11;
    u32 unknown12;
    u32 unknown13;
    u32 unknown14;
    u32 unknown15;
    u128 unknown16;
    s02_us01 unknown17[4];
    s02_us02 unknown18;
    s02_us02 unknown19;
    s02_us02 unknown20;
    s02_us02 unknown21;
    s02_us02 unknown22;
    s02_us02 unknown23;
    s02_us02 unknown24;
    s02_us02 unknown25[4];    
    s02_us02 unknown26[6];    
    s02_us02 unknown27[4];    
    s02_us02 unknown28[4];    
    s02_us02 unknown29[4];
    s02_us02 unknown30;                    
    s02_us02 unknown31[4];
    s02_us02 unknown32;
    s02_us02 unknown33;
    s02_us02 unknown34;
    s02_us03 unknown35[0x549];
    map_tiles littlemapidx[width * height];
    s02_us05 unknown37;
};

section02 section02_at_0x00 @ 0x00;
