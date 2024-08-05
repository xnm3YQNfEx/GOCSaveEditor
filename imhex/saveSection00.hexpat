struct section0 {
    u8 s0_data1[0x140];    //Stored at main object offset 0x1398
    u8 s0_data2;           //Stored at main object offset 0x14d8, also divided by 5 and result stored at 0x02d8?
    u8 s0_data3;           //Stored at main object offset 0x14d9
    u32 s0_data4;           //Stored at main object offset 0x02dc
};

section0 section0_at_0x00 @ 0x00;