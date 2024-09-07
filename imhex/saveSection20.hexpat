/******************************************************************************\
================================== Section 20 ==================================
\******************************************************************************/

/*

This section hasn't been populated with anything but the null u32 value in all
saves or scenarios I've checked so far. The structs here haven't been verified
with any sample data as of yet, and are just based off of what's in the game.

Incomplete!

ToDo:
    - Find save where this is populated to trace through!
*/

// Possibly object without a vtable, or a method from the obj_0077f6b0 base class?
struct fn_0060c030 {
    u16 x00;
    u16 x02;
    u8  x04;
    u8  x05;
    u32 x08;
    u32 x0c;
    u32 x10;
    u32 x14;
};

// Possibly object without a vtable, or a method from the obj_0077f6b0 base class?
struct fn_00521580 {
    fn_0060c030;
    u32 x1c;
    u32 x20;
    u32 global_0079d000;
};

// Object with vtable @ 0x0077f6b0
// Constructed by fn @ 0x005212c0
// Doesn't appear to be derived
struct obj_0077f6b0 {
    fn_00521580;
};

// Object with a vtable @ 0x0077f6d0
// Constructed by fn @ 0x00521f90
// Possibly derived from obj_0077f6b0
struct obj_0077f6d0 {
    fn_00521580;
};

// Object with a vtable @ 0x0077f6f0
// Constructed by fn @ 0x005231b0
// Possibly derived from obj_0077f6b0
struct obj_0077f6f0 {
    fn_00521580;
};


// Constructed within main save loading code @ 0x00658743
struct s20_us01 {
    u8 local_01;
    
    match (local_01) {
        (0|3):
            obj_0077f6b0;
        (1):
            obj_0077f6d0;
        (2):
            obj_0077f6f0;
    }
    
    /*
    From here, offset 0x2a8 from main game object is checked starting around 0x006587e9
    Possibly a ptr to the start of a linked list
    Looks like if unset, will contiue constructing an object
    If set, adds it to the list?
    Waiting on finding a save where this section has data before I continue
    */
}; 

// Section handling starts @ 0x00658709
struct section20 {
    u32 s20_count;
};

section20 section20_at_0x00 @ 0x00;