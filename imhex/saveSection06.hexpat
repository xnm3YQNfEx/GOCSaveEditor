import std.sys;
/******************************************************************************\
================================== Section 06 ==================================
\******************************************************************************/

// First pass at this is just checking the immediate reads
// Will need to do second pass to determine how the 'local' values are used

struct fn_006062f0 {
    u16 fn_006062f0_0x00;
    u16 fn_006062f0_0x02;
    u8  fn_006062f0_0x04;
    u8  fn_006062f0_0x05;
};

struct fn_004120b0 {
    u32 fn_004120b0_0x04;
    u32 fn_004120b0_0x08;
    u32 fn_004120b0_0x0c;
    u8 fn_004120b0_0x00[fn_004120b0_0x0c]; // Ptr to memory allocated on heap using
};

struct fn_00566c60 {
    u8 local_01; //used for a bunch of bitwise stuff
    u8 local_02; //again used for bitwise stuff
    u16 fn_00566c60_0x0000;
    u16 fn_00566c60_0x0002;
    u16 global_0079d59c;
    u16 fn_00566c60_0x0004;
    u8 fn_00566c60_0x000c;
    u8 fn_00566c60_0x000d;
    u32 fn_00566c60_0x001c;
    u8 fn_00566c60_0x0020;
    u8 fn_00566c60_0x0045;
    u8 fn_00566c60_0x0044;
    u8 fn_00566c60_0x000e;
    fn_004120b0 fn_00566c60_0x0024; 
    fn_004120b0 fn_00566c60_0x0034;
    fn_006062f0 fn_00566c60_0x0010;
    fn_006062f0 fn_00566c60_0x0046;
};

struct fn_00563230 {
    u16 fn_00563230_0x0004;
    if (fn_00563230_0x0004 != 0) {
        unimplemented();
        // Hard to follow some of the checks it does, put a breakpoint at 0x00563282
    }
};

// Constructed @ 00568670
// Also constructed @ 00569300 kinda?
// Maybe read by 00566c60
// Seems to also have a related obj_0077fc10 with ptr at 0x54?
// Also read in by fn_006687e0??
struct obj_0077fc14 {
    fn_00566c60;
    fn_00563230;
};

// Constructed @ 005f7ac0
// Read @ 005f7bd0
// Used in 00610430
struct fn_005f7ac0 {
    
    u8 fn_005f7ac0_0x00;
    
    if (fn_005f7ac0_0x00 == 0x02) {
        fn_006062f0 fn_005f7ac0_0x08;
        u8 local_01;
        // Above is read and used for a bunch of bitwise operations
        u8 local_02; 
        // Above is read and used for a bunch of bitwise operations
    }
};

// Read @ 007126d0
// Possibly related to other objs 007810e8 00781128 007821b0
struct obj_007815a8 {
    u8 obj_007815a8_0x000e;
    u8 obj_007815a8_0x0010;
    u8 obj_007815a8_0x000f;
    u16 obj_007815a8_0x000c;
    u8 obj_007815a8_0x0011;
    u8 obj_007815a8_0x000a;
    fn_006062f0 obj_007815a8_0x0004;
    // Does some stuff based off of above fn_006062f0 obj, though doesn't immediately result in any reads
    // Calls fn @ 00664d50
    // Seems to create a ptr or something, checks if not null, and then calls fn @ 0x30 offset from ptr passing in obj_007815a8 obj?
};

// Read @ 005a3140
struct obj_00780118 : obj_007815a8 {
    u8 obj_00780118_0x0044;
    u32 obj_00780118_0x0018;
    u32 obj_00780118_0x001c;
    u32 obj_00780118_0x0020;
    u8 obj_00780118_0x003c;
    u8 obj_00780118_0x003d;
    u32 obj_00780118_0x0040;
    u8 obj_00780118_0x003e;
    u8 obj_00780118_0x003f;
    
    // This bit is a little confusing, bunch of bitwise operations
    u8 local_01; // Gets XOR'd with current value @  obj_00780118_0x0024, AND with 0x3f, xored with the 0x0024 value again
    // Result replaces the vale at obj_00780118_0x0024 
    u8 local_02;
    u8 local_03;
    u8 local_04;
    u8 local_05;
    u8 local_06;
    u8 local_07;
    u8 local_08;
    u8 local_09;
    u8 local_10;
    u8 local_11;
    u8 local_12;
    u8 local_13;
    u8 obj_00780118_0x004c;
    u8 local_14;
};


// This one is a bit confusing, seems to be a vtable for obj_0077ea04, but also treated as one for obj_0077ea08
// Yet in code, it shows the vtable used is actually not a vtable? 0x004a1300??? I'm hella confuzzled.
// Read @ 004a44a0
struct obj_0077ea04 : obj_00780118 {
    u8 obj_0077ea04_0x0058;
    u8 obj_0077ea04_0x0059;
    u32 local_01;
    if (local_01 != 0)
    {
        obj_0077fc14 obj_0077ea04_0x0054;
        // constructs obj using fn @ 00568670
        // Does some reads using fn @ 005687e0, but need to find a save with this!
        // TODO!!!! 
    }
    
};


// Read @ 005d20c0
struct obj_007803c0 : obj_0077ea04 {
    u32 obj_007803c0_0x005c;
    u8 obj_007803c0_0x006c;
    u8 obj_007803c0_0x0060;
    u8 local_01;
    u8 local_02;
    u8 local_03;
    u8 local_04;
    u8 local_05;
    u8 local_06;
    u8 local_07;
    u8 local_08;
    u8 local_09;
    u8 local_10;
    u8 local_11;
    u8 local_12;
    // Like obj_00780118, the above locals are read and used with a bunch of bitwise ops that do get put into the obj
    // Will call some virtual fn's but doesn't appear to result in reads
    // More analysis is needed around 005d22e4
};

// Seems to mostly be a constructor for an array of obj_0077fc14
struct fn_00569300 {
    u32 local_01_count;
    if (local_01_count != 0){
        std::unimplemented();
    }
    // TODO!!!!
    // Need to find a save with this in it
    
};

struct fn_005f5ef0 {
    u32 local_01;
    
    if (local_01 > 0) {
        std::unimplemented();
        // TODO ! need to find a save with this!
    }

};

// Read @ 00460bd0
struct obj_0077e438 : obj_007803c0 {
    u8 local_01;
    u8 obj_0077e438_0x0070;
    u16 obj_0077e438_0x007c;
    u16 obj_0077e438_0x007e;
    u32 obj_0077e438_0x0084;
    u8 obj_0077e438_0x0080;
    u8 obj_0077e438_0x0098;
    u16 obj_0077e438_0x009a;
    u8 obj_0077e438_0x008c;
    u8 obj_0077e438_0x009d;
    u8 obj_0077e438_0x00a8;
    // Calls fn @ 00569300 to read obj @ 0x0088?
    fn_00569300 obj_0077e438_0x0088;
};

struct obj_00780780_loop_01 {
    // I'm being lazy here,  as its doing some weird stuff with offsets
    // Need to properly trace through and see what is going where...
    u8;
    u8;
    u8 local_01;
    u8;
    // Calls fn 00664d50 which uses global_007c0024. returns some ptr?
    // Checks the result and would call fn @ 0x20 offset from ptr result if present
    
};

// Read @ 0x00610430
// The derived by is just a placeholder
// The read fn is used by many objects... unsure which one it is?
struct obj_00780780 : obj_007815a8 {
    u8 obj_00780780_0x0048;
    u8 obj_00780780_0x0049;
    u8 obj_00780780_0x004a;
    u8 obj_00780780_0x004b;
    u8 obj_00780780_0x004c;
    u8 obj_00780780_0x004d;
    u8 obj_00780780_0x004e;
    u8 obj_00780780_0x004f;
    u8 obj_00780780_0x0050;
    u8 local_01;
    // Does some bitwise stuff with above value
    u16 obj_00780780_0x0058;
    u16 obj_00780780_0x005a;
    u16 obj_00780780_0x005c;
    u8 obj_00780780_0x005e;
    u8 local_02;
    // Does some bitwise stuff with above value
    u32 obj_00780780_0x0064;
    u32 obj_00780780_0x0068;
    u32 obj_00780780_0x006c;
    u32 obj_00780780_0x0070;
    u32 obj_00780780_0x0074;
    u32 obj_00780780_0x0078;
    u32 obj_00780780_0x007c;
    u32 obj_00780780_0x0080;
    // Grabs ptr to 0x0088
    // This bit is a pain to read
    obj_00780780_loop_01 obj_00780780_0x0088[0xc];
    
    // Following bit is technically still in a do while loop, but i think it executes only once?
    u32 obj_00780780_0x0128;
    // Calls fn 00664d50 which uses global_007c0024. returns some ptr?
    // Ptr is stored at 0x0124
    u8 obj_00780780_0x0018_size;
    // obj_00780780_0x0018_size bytes are allocated on the heap, and ptr is stored at obj_00780780_0x001c
    u8 obj_00780780_0x001c[obj_00780780_0x0018_size];
    // more bytes allocate same size
    u8 obj_00780780_0x0020[obj_00780780_0x0018_size];
    u8 obj_00780780_0x0024;
    fn_006062f0 obj_00780780_0x012c;
    u8 local_03;
    if (local_03 == 0) {
        u32 obj_00780780_0x013c = 0;
    } else {
        fn_005f7ac0 obj_00780780_0x013c;
    }
    u8 local_04;
    // Above is read and used for a bunch of bitwise operations for 0x0140
    u8 obj_00780780_0x0144;
    // Above is read and used for a bunch of bitwise operations
    fn_005f5ef0 obj_00780780_0x0114;

};

// Constructed @ 005fa0d0
// Read @ 005fa1d0
struct obj_00780560 {
    u8 obj_00780560_0x0164;
    obj_00780780 obj_00780560_0x0120;
    // Does some funky stuff with global_007c0024 and the u8 that was read in?
    // Global was something like 0x08400048
    // Now is 0x0840252e
    // Calls fn @ 0x00610430 which does a TON of reads...
    // Seems to be for an obj_00780780
    std::unimplemented();
    
};

// Constructed  @ 004bed80
// Read @ 004bf2a0
struct obj_0077ec80 : obj_0077e438 {
    u8  obj_0077ec80_0x00b0[0x40];
    u8  obj_0077ec80_0x00f0;
    u32 obj_0077ec80_0x010c;
    u8  obj_0077ec80_0x00f8;
    fn_00569300 obj_0077ec80_0x00fc;
    u32 local_01;
    if (local_01 != 0) {
        u8 local_02;
        if (local_02 == 0xc) {
            // Allocates 0x164 bytes
            // Constructs obj_00780728 using fn @ 00605eb0
            // TODO: Find a save with this case!
            std::unimplemented();
                        
        } else if (local_02 == 0xd) {
            obj_00780560 obj_0077ec80_0x00ac;
            // Allocates 0x168 bytes
            // Constructs obj_00780560 using fn @ 005fa0d0?
            // Stores in obj_0077ec80_0x00ac
            std::unimplemented();
        }
        // Uses fn @ 0x14 offset to read in the obj data
        break;
    }
};

struct fn_005f1af0 {
    u8 fn_005f1af0_0x04;
    s32 local_01;
    if (0 < local_01) {
        u8 fn_005f1af0_b1;
        std::unimplemented();
    }
    s32 local_02;
    if (0 < local_02) {
        u8 fn_005f1af0_b2;
        std::unimplemented();
    }
};


// Possibly obj 00781878 only?
struct fn_006f7d50 : obj_0077e438 {
    u8 fn_006f7d50_0x00ac[0xa];
    u8 local_01; //used in some bitwsie stuff
    u8 local_02; // used in some bitwise stuff
    u8 fn_006f7d50_0x00c4;
    u16 fn_006f7d50_0x00c6;
    u16 fn_006f7d50_0x00c8;
};


struct fn_004d7d40 : fn_005f1af0 {
    fn_006f7d50;
    u32 fn_004d7d40_0x0134;
    u32 fn_004d7d40_0x0138;
    u32 fn_004d7d40_0x013c;
    u32 fn_004d7d40_local_01;
    if (fn_004d7d40_local_01 > 0){
        std::unimplemented();
    }
    fn_00569300 fn_004d7d40_0x0140;
    u8 fn_004d7d40_local_02; //used in bitwise operations
       
};

// Constructed @ 006f1ac0
// Read @ 006f7d50
struct obj_00781878 {
    fn_006f7d50;
};

// Constructed @ 0048c950
// Read @ 00497a30
struct obj_0077e848 : fn_004d7d40 {
    s32 obj_0077e848_0x0240;
    u32 obj_0077e848_0x0244;
    if (obj_0077e848_0x0240 > 0){
        std::unimplemented();
    }
    u8 obj_0077e848_0x0178;
    u8 obj_0077e848_0x0179;
    u32 obj_0077e848_0x0174;
    u32 obj_0077e848_0x0184;
    u32 obj_0077e848_0x0188;
    u32 obj_0077e848_0x018c;
    u32 obj_0077e848_0x0190;
    u32 obj_0077e848_0x0194;
    u32 obj_0077e848_0x0198;
    u32 obj_0077e848_0x019c;
    u32 obj_0077e848_0x027c;
    
    fn_004120b0 obj_0077e848_0x0164;
    u32 obj_0077e848_local_01;
    
    if (obj_0077e848_local_01 > 0) {
        u8 obj_0077e848_0x0160[obj_0077e848_local_01];
    }
    u32 obj_0077e848_local_02;
    if (0 < obj_0077e848_local_02){
        fn_00566c60;
        std::unimplemented();
    }
    u32 obj_0077e848_local_03;
    if (0 < obj_0077e848_local_03){
        fn_00566c60;
        std::unimplemented();
    }
    u32 obj_0077e848_local_04;
    if (0 < obj_0077e848_local_04){
        obj_00781878;
        std::unimplemented();        
    }
};


// Constructed @ 006cab20
// Read @ 006ccd60
struct obj_00781428 {
    char obj_00781428_0x07f4[0xe]; // Null terminated string, will have trailing garbage
    char obj_00781428_0x0802[0xe]; // Null terminated string, will have trailing garbage
    char obj_00781428_0x0810[0xe]; // Null terminated string, will have trailing garbage
    fn_006062f0 obj_00781428_0x02d0;
    fn_006062f0 obj_00781428_0x02d6;
    u8 obj_00781428_0x0394[0xf4];
    u32 obj_00781428_0x032c;
    u32 obj_00781428_0x0330;
    u32 obj_00781428_0x0334;
    u32 obj_00781428_0x0338;
    u32 obj_00781428_0x033c;
    u32 obj_00781428_0x0340;
    u8 obj_00781428_0x051c;
    u32 obj_00781428_0x058c;
    u32 obj_00781428_0x0590;
    u8 obj_00781428_0x04cb;
    u8 obj_00781428_0x04cc;
    u8 obj_00781428_0x04cd;
    u32 obj_00781428_0x04d0;
    u32 obj_00781428_0x04d4;
    u32 obj_00781428_0x04d8;
    u32 obj_00781428_0x04dc;
    u32 obj_00781428_0x04e0;
    u32 obj_00781428_0x0830;
    u32 obj_00781428_0x04ec;
    u32 obj_00781428_0x04e8;
    u128 obj_00781428_0x0594;
    u32 local_01;
    if (local_01 != 0) {
        std::unimplemented();
        obj_0077ec80; // TODO, update with offset where this is stored
    }
    u32 local_02;
    if (local_02 != 0) {
        std::unimplemented();
        // Constructs obj_00782568 using fn @ 0075c450
    }
    u32 obj_00781428_0x0490;
    u32 obj_00781428_0x04bb;
    u32 obj_00781428_0x04bf;
    u32 obj_00781428_0x04c3;
    u32 obj_00781428_0x04c7;
    u8 obj_00781428_0x04b4;
    u8 obj_00781428_0x04b5;
    u8 obj_00781428_0x04b6;
    u8 obj_00781428_0x04b7;
    u8 obj_00781428_0x04b8;
    u8 obj_00781428_0x04b9;
    u8 obj_00781428_0x04ba;
    u32 obj_00781428_0x0514;
    u32 obj_00781428_0x0518;
    u32 obj_00781428_0x0528;
    u128 obj_00781428_0x052c;
    u32 obj_00781428_0x081e;
    u32 obj_00781428_0x04f0;
    u32 obj_00781428_0x04f4;
    u32 obj_00781428_0x04f8;
    u32 obj_00781428_0x04fc;
    u32 obj_00781428_0x0500;
    u32 obj_00781428_0x0508;
    u32 obj_00781428_0x050c;
    u32 obj_00781428_0x0510;
    u32 obj_00781428_0x0504;
    u32 obj_00781428_0x082c;
    u32 obj_00781428_0x0520;
    u32 obj_00781428_0x0524;
    u32 obj_00781428_0x0824;
    u32 obj_00781428_0x0828;
    fn_004120b0 obj_00781428_0x053c;
    fn_004120b0 obj_00781428_0x054c;
    fn_004120b0 obj_00781428_0x056c;
    u32 local_03;
    if (local_03 != 0) {
        std::unimplemented();
        // TODO, put breakpoint around 0x006cd4d3
    }
    u8 obj_00781428_0x02bc[0x14];
    fn_005f1af0; //need to determine where this is stored
    obj_0077e438; //need to determine where this is stored
    
    u8 obj_00781428_0x00f8;
    u32 local_04;
    if (local_04 > 0){
        obj_0077e848;
    }
        
};

struct section06 {
    u8 mgobj_0x0505; //Set as breakpoint as imhex remebers the last breakpoint stopped at
                   // It skips it on subsequent runs if it was the most recent one, at least by default
    u32 mgobj_0x0214;
    // Reads in 4 bytes, one at a time
    // Calls fn @ 0046c4d0 which checks if byte != 0
    // Stores bool result at 0x05fc with offset for the loop index, starting with 0;
    u8 mgobj_0x05fc[4];
    obj_00781428 mgobj_0x01fc;
    // TODO: Afterwards, also calls fn @ 00419b30 using mgobj_0x84a4 as ecx
    
};
section06 section06_at_0x00 @ 0x00;