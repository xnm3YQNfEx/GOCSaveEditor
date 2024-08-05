struct section25 {
    u8 data1 [40]; // Read into 0x24a8 offset 
    bool hasDescription; 
    if (hasDescription) {
        u32 descriptionLength;
        char descriptionStr[descriptionLength]; // Read into heap with pointer stored at 0x86d8 offset
    }
    bool hasPath;
        if (hasPath) {
        u32 pathLength;
        char pathStr[pathLength]; // Read into heap with pointer stored at 0x86dc
    }
};

section25 section25_at_0x00 @ 0x00;