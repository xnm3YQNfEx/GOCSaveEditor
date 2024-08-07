/******************************************************************************\
================================== Section 13 ==================================
\******************************************************************************/

// Street names!
// Loading this section is dependent on other city data loaded earlier
// Uses values in main game object to know how many horizontal and vertical streets
// Seems to generally have 29 vertical streets, and 21 horizontal streets

/* 
    ToDo
        - Determine where the mgobj_0x02c8 and mgobj_0x02cc are set (likely section 1)
        - Determine if other map dimensions are possible
*/

struct u8indexedStr {
    u8 length;
    char string[length];
};


// Section handling starts @ 0x0065cb6b
struct section13 {
    // Does some validation on mgobj_0x02c8 first
    // Uses it as the limit on a for loop
    // Loads strings onto the heap
    // Pointers go at (i * 4) + 0x156c in mgobj, where i is the current loop index
    // Does free memory if already has ptr at the offset
    // Allocates one extra byte for each string, and will set last byte to 0x00
    u8indexedStr vertical_streets[0x29]; // Placeholder count of 25 for now
    
    
    // Does some validation on mgobj_0x02cc first like above
    // Pointers go at (i * 4) + 0x14e8 in mgobj, where i is the current loop index 
    u8indexedStr horizontal_streets[0x21];
    
};
section13 section13_at_0x00 @ 0x00;