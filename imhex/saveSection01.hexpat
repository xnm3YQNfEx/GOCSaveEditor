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


struct sectionHeader {
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
    sectionHeader header;
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

struct section01Data {
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

section01Data section01Data_at_0x00 @ 0x00;