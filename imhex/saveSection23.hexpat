/******************************************************************************\
================================== Section 23 ==================================
\******************************************************************************/

// Possibly elections related?
// Setting the local_01 value to FF and loading resulted in election starting

// No idea where the actual constructor is yet...
// This is already present within the game object
struct fn_004bbd30 {
    u8 fn_004bbd30_0x00;
    u8 fn_004bbd30_0x01;
    u8 local_01; 
    u8 fn_004bbd30_0x08 = local_01 & 0x7f [[export]];
    u32 fn_004bbd30_0x04 = (local_01 & 0x80) != 0 [[export]];  
    u8 fn_004bbd30_0x24[0x18];
};

// Section handling starts @ 0x00657e6f
struct section23 {
    fn_004bbd30 mgobj_0x2554;
};

section23 section23_at_0x00 @ 0x00;