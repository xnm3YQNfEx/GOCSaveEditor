/******************************************************************************\
================================== Section 25 ==================================
\******************************************************************************/

// Section appears to be either metadata or overall game settings?
// Contains strings if game was started from a scenario

/* 
    ToDo: 
        - Determine what the 40 bytes of data is used for
*/

// Section handling starts @ 0x00657ecb
struct section25 {
    u8 mgoobj_0x25a8 [40];
    bool hasDescription; 
    if (hasDescription) {
        u32 descriptionLength;
        char mgobj_0x86d8_descriptionStr[descriptionLength];
    }
    bool hasPath;
        if (hasPath) {
        u32 pathLength;
        char mgobj_0x0x86dc_pathStr[pathLength];
    }
};

section25 section25_at_0x00 @ 0x00;