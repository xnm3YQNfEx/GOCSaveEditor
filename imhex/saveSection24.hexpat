/******************************************************************************\
================================== Section 24 ==================================
\******************************************************************************/

// Contains version number of game exe that produced the save/scenario.
// Best I can tell, the versionStr is read into the heap, with a ptr on the stack
// Doesn't appear to be loaded into the main game object at all

// Section handling starts @ 0x00657e6f
struct section24 {
    u32 versionLength;
    char versionStr[versionLength];
};

section24 section24_at_0x00 @ 0x00;