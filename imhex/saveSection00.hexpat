/******************************************************************************\
================================== Section 00 ==================================
\******************************************************************************/

// Place holder nameing convetion
// Struct members are named based off of where/how they are used.
// mgobj_0x0000 -> Main game object, with offset where that value was read
// local_01 -> Local value that is used while reading in and constructing game state, but not stored in the game objects
// obj_00778899_0xfc -> Some other object with a vtable, with the offset where the value was stored
// fn_00778899_0xfc -> Some other object without a vtable, where the addr is just the constructor function, again also offset is provided
// global_00778899 -> Value is stored in a global at the address in the name


// Section handling starts @ 0x00657fa1
struct section00 {
    u8  mgobj_0x1398[0x140];
    u8  mgobj_0x14d8;
    u8  mgobj_0x14d9;
    u32 mgobj_0x02d8 = mgobj_0x14d8 / 5 [[export]];
    u32 mgobj_0x02dc;
};

section00 section00_at_0x00 @ 0x00;