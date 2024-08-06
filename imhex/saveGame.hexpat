#pragma pattern_limit 2000000

/* 

README:

Naming is an absolute mess as I have no clue what any values actually do,
though the structure should be mostly correct.
Data types are unknown but the bit sizes should be correct.
Also, all structs are purely based off of the save data. 
The way they are organized in the in game memory is nothing like in the save.

I'll be updating this with comments as I poke at how the data is used.

*/


/******************************************************************************\
================================== Section 00 ==================================
\******************************************************************************/

// Changes with new games, though seems static throughout playthrough

struct section00 {
    u8 s00_01[0x140];    //Stored at main object offset 0x1398
    u8 s00_02;           //Stored at main object offset 0x14d8, also divided by 5 and result stored at 0x02d8?
    u8 s00_03;           //Stored at main object offset 0x14d9
    u32 s00_04;          //Stored at main object offset 0x02dc
};

/******************************************************************************\
================================== Section 01 ==================================
\******************************************************************************/

// Economy Data

/*
Section is mostly the same data found in xtx data files. There does appear to
be other values that can change between game weeks. More analysis is required.
The game doesn't read in this data from xtx files when loading a save/scenario
with the exception of the strings from economics.xtx and illegal economics.xtx.
Assumption is they are more so a template to make localisation easy. When 
starting a new game from a scenario, the number of businesses within the two xtx
files that strings are read from must match the number of businesses in the
scenario. It does appear to be possible to change the number of businesses 
if you don't use scenarios, and start a new game.

Illegal business count is static, as the game is hard coded to have exactly 15.
*/


struct indexedStr {
    u8 length;
    char string[length];
};

struct businessType {
    indexedStr name;
    u8 incomeGroup;
    u8 runningCostGroup;
    u8 landValueMin;
    u8 landValueMax;
    u8 setupTime;
    u16 extortPay;
    u8 contents;
    u8 populace;
    u8 produceType;
    u8 businessType;
    u8 size;
    u8 clothes;
    u8 inherentCosts;
    u8 stockValue;
    u8 inherentProfit;
    u8 buildingReference;
    u8 unionType;
    u8 policeGuardMin;
    u8 policeGuardMax;
    u8 policePatrolMin;
    u8 policePatrolMax;
    u8 fbiGuard;
    u8 storageCapacity;
    u8 unknown6;
    u32 cityCapacityMax;
    u32 cityCapacityMin;
    u32 cityCapacityMaxAgain;
    u32 unknownMaybeNumberPresent;
    u32 floatMoney;
    u32 setupCosts;
    u64 unknown1;
    u64 unknown2;
    u8 liquor;
    u8 stolenGoods;
    u8 counterfeit;
    u8 isSupplier;
    u8 isConsumer;
    u8 policeOutsideMin;
    u8 policeOutsideMax;
    u8 unknown7;
    u8 unknown8;
    indexedStr anStr;
    indexedStr theStr;
    indexedStr atTheStr;
    indexedStr ofTheStr;
    indexedStr onTheStr;
};


struct economicsHeader {
    u32 totalTypes;
    u32 totalCommercial;
    u32 totalIndustrial;
    u32 totalEmpty;
    u32 totalResidential;
    u32 totalWarehouses;
    u32 totalCharity;
    u32 totalMunicipal;
    u32 totalTenement;
    u32 unknown1;
    u32 unknown2;
    u32 unknown3;
    u32 unknown4;
    u32 unknown5;
    u32 unknown6;
    u32 unknown7;
    u32 unknown8;
    u32 unknown9;
    u32 unknown10;
    u32 unknown11;
    u32 unknown12;
    u32 unknown13;
    u32 unknown14;
    u32 unknown15;
    u32 unknown16;
};

struct economicData {
    economicsHeader header;
    businessType commercialTypes[header.totalCommercial];
    businessType industrialTypes[header.totalIndustrial];
    businessType emptyTypes[header.totalEmpty];
    businessType residentialTypes[header.totalResidential];
    businessType warehouseTypes[header.totalWarehouses];
    businessType charityTypes[header.totalCharity];
    businessType municipalTypes[header.totalMunicipal];
    businessType tenementTypes[header.totalTenement];
};

struct runningCostsRow {
    u16 groupData[8]; //This is technically a variable length, based off of the groups value from the parent running costs
};

struct runningCostsData {
    u8 groups;
    runningCostsRow rowData [16];
};

struct incomeGroupsData {
    u8 columns; //I don't think this is variable, just a const
    u16 row1 [columns];
    u16 row2 [columns];
    u16 row3 [columns];
    u16 row4 [columns];
    u16 row5 [columns];
    u16 row6 [columns];
    u16 row7 [columns];
    u16 row8 [columns];
    u16 row9 [columns];
    u16 row10 [columns];
    u16 row11 [columns];
    u16 row12 [columns];
    u16 row13 [columns];
    u16 row14 [columns];
    u16 row15 [columns];
    u16 row16 [columns];
};

struct emptyLandCostData {
    u8 columns; //Should match number of empty land types in economics.txt
    u16 ELC_row1 [columns]; // different rows are used likely by land value for the block;
    u16 ELC_row2 [columns];
    u16 ELC_row3 [columns];
    u16 ELC_row4 [columns];
    u16 ELC_row5 [columns];
    u16 ELC_row6 [columns];
    u16 ELC_row7 [columns];
    u16 ELC_row8 [columns];
    u16 ELC_row9 [columns];
    u16 ELC_row10 [columns];
    u16 ELC_row11 [columns];
    u16 ELC_row12 [columns];
    u16 ELC_row13 [columns];
    u16 ELC_row14 [columns];
    u16 ELC_row15 [columns];
    u16 ELC_row16 [columns];
};

struct marketShareData {
    u8 count;
    u8 MarketShare_values[count];
};

struct landValueReductionsData {
    u8 fires;
    u8 bombs;
    u8 kills;
    u8 kidnaps;
    u8 robberies;
};


// Illegal business struct is just a best guess, need to actually confirm
struct illegalBusniessData {
    indexedStr name;
    u8 profitGroup;
    u8 cityCapacityGroup;
    u8 runningCostGroup;
    u8 lvMin;
    u8 lvMax;
    u8 time; //Setup time?
    u8 content;
    u8 populace;
    u8 inherentCosts;
    u8 stockValue;
    u8 size;
    u8 inherentProfit;
    u8 buildingRef;
    u8 unionType; // unknown, just guessing;
    u8 capacity;
    
    u64 unknown1;
    u64 unknown2;
    u16 setupCosts;
    u16 unknown3;
    u8 liquor;      
    u8 stolenGoods; 
    u8 counterfeit;
    u8 isSupplier;
    u8 isConsumer;

    indexedStr aStr;
    indexedStr theStr;
    indexedStr atTheStr;
    indexedStr ofTheStr;
    indexedStr onTheStr;
};

struct illegalEconomicsData {
    illegalBusniessData illegalBusinesses[15]; // This is hard coded in the game to only allow for 15 illegal businesses!
};

struct illegalProfitsData {
    u32 rows;
    u32 cols;
    u32 col1Data[rows];
    u32 col2Data[rows];
    u32 col3Data[rows];
    u32 col4Data[rows];
    u32 col5Data[rows];
};

struct section01 {
    economicData economic;
    u32 unknown;
    u8 unknown2;
    runningCostsData runningCosts;
    incomeGroupsData incomeGroups;
    emptyLandCostData emptyLandCost;
    marketShareData marketShare;
    landValueReductionsData landValueReductions;
    illegalEconomicsData illegalEconomics;
    illegalProfitsData illegalProfits;
};

/******************************************************************************\
================================== Section 02 ==================================
\******************************************************************************/

// I believe this is data for the city. Tiles, businesses, etc?
// Need to finish up Case 5 and Case 6 structs, need sample data first before I trace through them

// Unknown Struct 01
struct s02_us01 { // Read in like a tuple at 0x00658239
    u32 s02us01_1;
    u32 s02us01_2;
};


// Unknown Struct 02
struct s02_us02 { // Read in at 0x006062f0
    u16 s02us02_1;
    u16 s02us02_2;
    u8 s02us02_3;
    u8 s02us02_4;
};

// Unknown Struct 03, sub struct 01
struct s02_us03_sub01 {
    u8 s02us03s01_1;
    u8 s02us03s01_2;    
};


// Unknown Struct 03
struct s02_us03 {

    u32 s02us03_01;
    if (s02us03_01 !=0) {
        u8 s02us03_02;
        u8 s02us03_03;
        u8 s02us03_04;
        u8 s02us03_05;
        s02_us03_sub01 s02us03_06[4];
    }
};

struct obj_007815a8 {
    u8 obj_007815a8_01;
    u8 obj_007815a8_02;
    u8 obj_007815a8_03;
    u16 obj_007815a8_04;
    u8 obj_007815a8_05;
    u8 obj_007815a8_06;
    s02_us02 obj_007815a8_07;
};

struct obj_00780890 {
    u8 obj_00780890_01;
    u8 obj_00780890_02;
    u8 obj_00780890_03;
    u8 obj_00780890_04;
    u32 obj_00780890_05;
    obj_007815a8 obj_00780890_06[obj_00780890_05];
    u8 obj_00780890_07;
    // Following is read in by separate function 0x00726430
    u8 obj_00780890_08;
    u8 obj_00780890_09[obj_00780890_08 * 2];
    u8 obj_00780890_10[obj_00780890_08];
    u16 obj_00780890_11;
    u16 obj_00780890_12;
    u16 obj_00780890_13;
    u8 obj_00780890_14;
};

// Case 0 and local 30 is 0
struct obj_00782040 : obj_00780890 {
    u8 obj_00782040_01;
    u8 obj_00782040_02;
    u8 obj_00782040_03;
    u8 obj_00782040_04;
    u8 obj_00782040_05;
};

// Case 0 and local 30 is not 0
struct obj_00780eb8 : obj_00782040 {
    u16 obj_00780eb8_01;
};

// Case 1
struct obj_0077f710 : obj_00780890 {
    u8 obj_0077f710_01;
    u8 obj_0077f710_02;
    u8 obj_0077f710_03;
    u16 obj_0077f710_04;
    u8 obj_0077f710_05;
    u16 obj_0077f710_06;
    u16 obj_0077f710_07;
    u8 obj_0077f710_08;
    u8 obj_0077f710_09;
};

//Case 2
struct obj_00781600 : obj_0077f710 {
    u8 obj_00781600_01;
    u8 obj_00781600_02;
    u16 obj_00781600_03;
    u32 obj_00781600_04;
    u32 obj_00781600_05;
    u32 obj_00781600_06;
    s02_us02 obj_00781600_07;
    u8 obj_00781600_08;
    u8 obj_00781600_09;
    u16 obj_00781600_10;
    u8 obj_00781600_11;
    u16 obj_00781600_12;
    u16 obj_00781600_13;
    u16 obj_00781600_14;
    u16 obj_00781600_15;
    u16 obj_00781600_16;
    u16 obj_00781600_17;
    u16 obj_00781600_18;
    u32 obj_00781600_19;;
};

// Case 3 and a value is -1
struct obj_00780ac0 : obj_0077f710 {
    u8 obj_00780ac0_01;
    u16 obj_00780ac0_02;
    u16 obj_00780ac0_03;
    u8 obj_00780ac0_04;
    u8 obj_00780ac0_05;
    u16 obj_00780ac0_06;
    u8 obj_00780ac0_07;
    u16 obj_00780ac0_08;
    u16 obj_00780ac0_09;
    u16 obj_00780ac0_10;
    u16 obj_00780ac0_11;
    u8 obj_00780ac0_12;
    u32 obj_00780ac0_13;
    u16 obj_00780ac0_14;
    u16 obj_00780ac0_15;
    u16 obj_00780ac0_16;
    u32 obj_00780ac0_17;
};

// Case 3 when a value isn't -1, and also used by case 9 when it's value isn't -1
struct obj_00781260 : obj_00780ac0 {
    // Struct doesn't add any new members, likely just virtual function changes
};

// Case 4
// Haven't seen this in a save yet, though very simple so likely correct

struct obj_00781b58 : obj_00781600 {
    u8 obj_00781b58_01;
    u8 obj_00781b58_02;
    u8 obj_00781b58_03;
};

// Case 5
// Haven't seen this yet, and it's very confusing to follow
// I'm going to wait until I have a save with this in it.


// Case 6

struct obj_0077f8b0 : obj_0077f710 {
    u16 obj_0077f8b0_01;   
    u16 obj_0077f8b0_02;
    u16 obj_0077f8b0_03; 
    u32 obj_0077f8b0_04;
    u32 obj_0077f8b0_05;
    
    // NOT COMPLETE, continues on based off of value in obj_0077f8b0_05 but it's always been 0 so far...
    // 0x0052c4f2 is where it does the check
    // Again, like Case 5, it's too confusing to follow without some sample data
};


// Case 7
struct obj_0077fac8 : obj_0077f710 {
    u32 obj_0077fac8_01;
    u32 obj_0077fac8_02;
    u32 obj_0077fac8_03;
};

// Case 8

struct obj_00781a10 : obj_0077f710 {
    u8 obj_00781a10_01;    
};

// Case 9
struct obj_0077ff68 : obj_00780ac0 {
    u32 obj_0077ff68_01;
};


//Case 10
struct obj_007801b0 : obj_0077f710 {
};

// Unknown struct 04, sub struct 01
struct s02_us04_s01 {
    u8 s02us04s01_01;  // Some sort of type enum maybe? Cases for 0 to 13? except no 11???
    s32 s02us04s01_02;
    u32 s02us04s01_03;
    u32 marker = u16(s02us04s01_02);
    marker += (u16(s02us04s01_03) << 16);
    //std::print("{:x}", marker);
    match (s02us04s01_01,s02us04s01_03, s16(s02us04s01_02)) {
        (0, 0, _):
            obj_00782040;
        (0, 1, _):
            obj_00780eb8;
        (1,_,_):
            obj_0077f710;
        (2,_,_):
            obj_00781600;
        (3,_,-1):
            obj_00780ac0; 
        (3,_,0 ... 32767):    
            obj_00781260;
        (6,_,_):
            obj_0077f8b0;
        (7,_,_):
            obj_0077fac8;
        (8,_,_):
            obj_00781a10;
        (9,_,-1):
            obj_0077ff68;
        (9,_,0 ... 32767): // I tried to use a wildcard, but it kept saying it was ambiguous...
            obj_00781260;
        (10,_,_):
            obj_007801b0;
        (12|13,_,_):
            obj_00780890;
    }
};

// Unknown Struct 04
// Possible constructor at 0x00645890
// Read in  at 0x0054ee90
// This is a bit confusing to follow with switch statements and more fun stuff
struct s02_us04 {
    u8 s02us04_01;
    u8 s02us04_02;
    u8 s02us04_03;
    u8 s02us04_04;
    u32 s02us04_05;
    u32 s02us04_06;
    u8 s02us04_07;
    u32 s02us04_08;
    // I don't understand the logic around this yet, it reads in 5, and then based off of the ptr address of the "marker", it will loop again?
    
    
    s02_us04_s01 s02us04_09[5];
    s02_us04_s01 s02us04_10[5];
    s02_us04_s01 s02us04_11[5];    
    s02_us04_s01 s02us04_12[5];
    s02_us04_s01 s02us04_13[5];    
};

struct s02_us05_s02 {
    u8 s02us05s02_01;
    u8 s02us05s02_02;
    u8 s02us05s02_03;
    u8 s02us05s02_04;
};

struct s02_us05_s01 {
    u8 s02us05s01_01_count;
    u8 s02us05s01_02_count;
    u8 s02us05s01_03_count;
    u8 s02us05s01_04_count;
    
    s02_us05_s02 s02us05s02_01[s02us05s01_01_count];
    s02_us05_s02 s02us05s02_02[s02us05s01_02_count];
    s02_us05_s02 s02us05s02_03[s02us05s01_03_count];
    s02_us05_s02 s02us05s02_04[s02us05s01_04_count];
};


// Constructed at 004645e0
struct s02_us05 {
    u32 s02us05_count;
    s02_us05_s01 s02us05_01[s02us05_count];
};    



struct section02 { // Constructed in main section handling around 0x0065809a
    u32 unknown1; // Used to set globals 0x009008e4 and 0x009008e0
    u32 unknown2;   
    u32 unknown3;
    u32 unknown4;
    u32 unknown5;
    u32 unknown6;
    u8 unknown7;
    u8 unknown8;
    u32 unknown9;
    u32 unknown10;
    u32 unknown11;
    u32 unknown12;
    u32 unknown13;
    u32 unknown14;
    u32 unknown15;
    u128 unknown16;
    s02_us01 unknown17[4];
    s02_us02 unknown18;
    s02_us02 unknown19;
    s02_us02 unknown20;
    s02_us02 unknown21;
    s02_us02 unknown22;
    s02_us02 unknown23;
    s02_us02 unknown24;
    s02_us02 unknown25[4];    
    s02_us02 unknown26[6];    
    s02_us02 unknown27[4];    
    s02_us02 unknown28[4];    
    s02_us02 unknown29[4];
    s02_us02 unknown30;                    
    s02_us02 unknown31[4];
    s02_us02 unknown32;
    s02_us02 unknown33;
    s02_us02 unknown34;
    s02_us03 unknown35[0x549];
    s02_us04 unknown36[unknown3 * unknown4];
    s02_us05 unknown37;
};

struct section11 {
    u8 s11_data[0x178]; // Read into 0x1220 offset
};

/******************************************************************************\
================================== Section 18 ==================================
\******************************************************************************/

/*

Seems to be the last week data

Is allocated 0x44c bytes, that is then passed to constructor 0x004372c0
ptr is stored in global 0x007c0038
Save data read in by 0x00437740

Relatively empty at the start of the game for both scenarios and new games
Significant growth after just one week in game
appears to contain strings from LastWeekReport.xtx

*/

struct section18 {

};


/******************************************************************************\
================================== Section 21 ==================================
\******************************************************************************/


// NOTE! I haven't come across a file where this actually has data beyond the null byte yet
// This is untested, but hopefully correct

struct s21_us01_s1 {
    u8 s21us01s1_01;
    u8 s21us01s1_02;
    u8 s21us01s1_03;
    u8 s21us01s1_04;
    u8 s21us01s1_05;
    u8 s21us01s1_06;
    u8 s21us01s1_07;
    u8 s21us01s1_08;
};

struct s21_us01 {
    u8 s21us01_01;
    u8 s21us01_02;
    s21_us01_s1 s21us01_03[s21us01_02];
};

struct section21 {
    u8 s21_count;
    s21_us01 s21_data[s21_count];
};


/******************************************************************************\
================================== Section 23 ==================================
\******************************************************************************/

/*

- 27 bytes in total
- seems to be consistently null values across all saves so far...

*/

struct section23 {
    u8 s23_1;
    u8 s23_2;
    u8 s23_3;
    u8 s23_4[0x18];
};

/******************************************************************************\
================================== Section 24 ==================================
\******************************************************************************/

/*

Version info of game version that produced the save/scenario file.
Game doesn't appear to check this value at the time it's read, it just happily
reads the remainder of the save. More testing is needed.

*/

struct section24 {
    u32 versionLength;
    char versionStr[versionLength];
};

/******************************************************************************\
================================== Section 25 ==================================
\******************************************************************************/

/*
    Unknown what the 40 bytes are at the start.
    Rest of the data are strings for the scenario description, and scenario path
*/


struct section25 {
    u8 s25_01 [40]; // Read into 0x24a8 offset 
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

/******************************************************************************\
================================== Main Struct =================================
\******************************************************************************/

struct saveSection {
    u8 sectionId;
    u32 unknown;
    u32 sectionLength;
    
    match (sectionId) {
        (0):
            section00 section00;
        (1):
            section01 section01;
        (2):
            section02 section02;
        (11):
            section11 section11;
        (21):
            section21 section21;
        (23):
            section23 section23;
        (24):
            section24 section24;
        (25):
            section25 section25;
        (_):
            char sectionData[sectionLength];
    }
};

struct saveGame {
    u32 sectionCount;
    saveSection sections[sectionCount];
};

saveGame savegame_at_0x00 @ 0x00;