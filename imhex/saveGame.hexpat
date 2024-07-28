struct saveSection {
    u8 sectionId;
    u32 unknown;
    u32 sectionLength;
    char sectionData[sectionLength];
};

struct saveGame {
    u32 sectionCount;
    saveSection sections[sectionCount];
};

saveGame savegame_at_0x00 @ 0x00;