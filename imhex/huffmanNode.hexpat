struct huffmanNode {
    u8 children;
    if (children > 0){
        u8 leftMarker;
        huffmanNode left;
        u8 rightMarker;
        huffmanNode right;
    }
    u8 symbol;
};

huffmanNode huffmannode_at_0x00 @ 0x00;