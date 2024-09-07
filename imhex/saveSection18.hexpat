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

ToDo
  - Trace through case 2 to see if fn_004367f0_0x08 is overwritten
  - Finish Cases
    - 4
    - 6
    - 7
    - 12
    - 13
    - 21
  - Finish tail end of fn_00437740
  - Step through loading game saves as validation that structs and offsets are correct

*/

struct u32indexedStr {
    u32 length;
    char string[length];
};


// Case handling for fn_004367f0

// Values can be 0 - 21
// 5 is a default case, and results in a false value returned by the function
// See match statement below for mapping between cases and objects as several
// case statements use similar structures in separate handlers, or have multiple
// cases with no break that fall through to a single handler.

struct empty {
};

struct fn_004367f0_case_01 {
    u8 fn_004367f0_0x0d;
    u8 fn_004367f0_0x0e;
};


struct fn_004120b0 {
    u32 fn_004120b0_0x04;
    u32 fn_004120b0_0x08;
    u32 fn_004120b0_0x0c;
    // Allocates memory on heap using value @ 0x0c as len
    // ptr stored @ 0x00
    u8 fn_004120b0_0x00[fn_004120b0_0x0c];
};

struct fn_006062f0 {
      u16 fn_006062f0_0x00;
      u16 fn_006062f0_0x02;
      u8  fn_006062f0_0x04;
      u8  fn_006062f0_0x05;
};

// Used in Case 2
// Constructed @ 0x00566900
// Read in @ 0x00566c60
struct fn_00566c60 {
    // uses fn_00411c90 to construct two objects
    // Nothing read during construction    
    
    u8 local_01;
    u8 maybe_local_02;
    u16 fn_00566c60_0x00;
    u16 fn_00566c60_0x02;
    u16 global_0079d59c;
    u16 fn_00566c60_0x04;
    u8 fn_00566c60_0x0c;
    u8 fn_00566c60_0x0d;
    u32 fn_00566c60_0x1c;
    u8 fn_00566c60_0x20;
    u8 fn_00566c60_0x45;
    u8 fn_00566c60_0x44;
    u8 fn_00566c60_0x0e;
    fn_004120b0 fn_00566c60_0x24;
    fn_004120b0 fn_00566c60_0x34;
    fn_006062f0 fn_00566c60_0x10;
    fn_006062f0 fn_00566c60_0x46;
};

struct fn_004367f0_case_02 {

    // Allocates 8 bytes on the heap
    // Stores pointer @ fn_004367f0_0x08
    // Sets all 8 bytes to 0x00
    u32 local_01;
    if (local_01 != 0) {
        // Allocates 0x4c bytes
        // thunk_FUN_00566900(0,1);     
        // Stores pointer @ fn_004367f0_0x08 ??? Does it overwrite?
        // uVar1 = thunk_FUN_00566c60(param_1);
        fn_00566c60 fn_004367f0_0x08;
        
    }
    u32 fn_004367f0_0x08;   // Possibly signed? Cast as int?
    u8  fn_004367f0_0x0d;
    u8  fn_004367f0_0x0e;
};

struct fn_004367f0_case_03 {
    u32 fn_004367f0_0x08;
    u8  fn_004367f0_0x0d;
    u8  fn_004367f0_0x0e;
};

struct fn_004367f0_case_04 {
/*
    puVar3 = (undefined4 *)operator_new(4);
    *(undefined4 **)(param_1_00 + 8) = puVar3;
    *puVar3 = 0;
    local_1c = operator_new(0x4c);
    uVar4 = 0;
    local_8 = 2;
    if (local_1c != (void *)0x0) {
      uVar4 = thunk_FUN_00566900(0,1);
    }
    local_8 = 0xffffffff;
    **(undefined4 **)(param_1_00 + 8) = uVar4;
    uVar1 = thunk_FUN_00566c60(param_1);
*/
    u8  fn_004367f0_0x0d;
    u8  fn_004367f0_0x0e;
};

// Case 5 is also the default case
// Doesn't read anything, and returns a failure/false result

struct fn_004367f0_case_06 {

    // Allocates 0x20 bytes on heap
    // Constructs @ 0x005a48f0

    local_1c = operator_new(0x20);
    local_8 = 3;
    if (local_1c == (void *)0x0) {
      local_18 = (byte *)0x0;
    }
    else {
      local_18 = (byte *)thunk_FUN_005a48f0();
    }
    local_8 = 0xffffffff;
    *(byte **)(param_1_00 + 8) = local_18;
    uVar1 = (**(code **)(*param_1 + 0x10))(&local_11,1);
    *local_18 = (*local_18 ^ local_11) & 0x7f ^ *local_18;
    uVar20 = (**(code **)(*param_1 + 0x10))(&local_11,1);
    *local_18 = *local_18 & 0x7f ^ local_11 << 7;
    uVar19 = (**(code **)(*param_1 + 0x10))(local_18 + 1,1);
    uVar5 = (**(code **)(*param_1 + 0x10))(local_18 + 2,1);
    uVar6 = (**(code **)(*param_1 + 0x10))(local_18 + 3,1);
    uVar7 = (**(code **)(*param_1 + 0x10))(local_18 + 4,1);
    uVar8 = (**(code **)(*param_1 + 0x10))(local_18 + 5,1);
    uVar9 = (**(code **)(*param_1 + 0x10))(local_18 + 8,4);
    uVar10 = (**(code **)(*param_1 + 0x10))(&local_11,1);
    *(uint *)(local_18 + 0xc) =
         ((uint)local_11 ^ *(uint *)(local_18 + 0xc)) & 0x3f ^ *(uint *)(local_18 + 0xc);
    uVar11 = (**(code **)(*param_1 + 0x10))(&local_11,1);
    *(uint *)(local_18 + 0xc) =
         ((uint)local_11 << 6 ^ *(uint *)(local_18 + 0xc)) & 0xc0 ^ *(uint *)(local_18 + 0xc);
    uVar12 = (**(code **)(*param_1 + 0x10))(&local_11,1);
    *(uint *)(local_18 + 0xc) =
         ((uint)local_11 << 8 ^ *(uint *)(local_18 + 0xc)) & 0x700 ^ *(uint *)(local_18 + 0xc);
    uVar13 = (**(code **)(*param_1 + 0x10))(&local_11,1);
    *(uint *)(local_18 + 0xc) =
         ((uint)local_11 << 0xb ^ *(uint *)(local_18 + 0xc)) & 0x800 ^ *(uint *)(local_18 + 0xc);
    uVar14 = (**(code **)(*param_1 + 0x10))(&local_11,1);
    *(uint *)(local_18 + 0xc) =
         ((uint)local_11 << 0xc ^ *(uint *)(local_18 + 0xc)) & 0x7000 ^ *(uint *)(local_18 + 0xc);
    uVar15 = (**(code **)(*param_1 + 0x10))(&local_11,1);
    *(uint *)(local_18 + 0xc) =
         ((uint)local_11 << 0xf ^ *(uint *)(local_18 + 0xc)) & 0x8000 ^ *(uint *)(local_18 + 0xc);
*/
    u8  fn_004367f0_0x0d;
    u8  fn_004367f0_0x0e;
/*
    uVar18 = (**(code **)(*param_1 + 0x10))(&local_24,4);
    uVar2 = uVar2 & uVar1 & uVar20 & uVar19 & uVar5 & uVar6 & uVar7 & uVar8 & uVar9 & uVar10 &
            uVar11 & uVar12 & uVar13 & uVar14 & uVar15 & uVar16 & uVar17 & uVar18;
    if (local_24 != 0) {
      uVar1 = (**(code **)(*param_1 + 0x10))(&local_11,1);
      iVar22 = *(int *)(param_1_00 + 8);
      pvVar21 = operator_new((uint)local_11);
      *(void **)(iVar22 + 0x14) = pvVar21;
      uVar20 = (**(code **)(*param_1 + 0x10))(*(undefined4 *)(iVar22 + 0x14),local_11);
      uVar19 = (**(code **)(*param_1 + 0x10))(&local_11,1);
      pvVar21 = operator_new((uint)local_11);
      *(void **)(iVar22 + 0x18) = pvVar21;
      uVar5 = (**(code **)(*param_1 + 0x10))(*(undefined4 *)(iVar22 + 0x18),local_11);
      uVar6 = (**(code **)(*param_1 + 0x10))(&local_11,1);
      pvVar21 = operator_new((uint)local_11);
      *(void **)(iVar22 + 0x1c) = pvVar21;
      uVar7 = (**(code **)(*param_1 + 0x10))(*(undefined4 *)(iVar22 + 0x1c),local_11);
      uVar2 = uVar2 & uVar1 & uVar20 & uVar19 & uVar5 & uVar6 & uVar7;
    }
    break;
*/
};

struct fn_004367f0_case_07 {
/*
    puVar3 = (undefined4 *)operator_new(0x10);
    *(undefined4 **)(param_1_00 + 8) = puVar3;
    *puVar3 = 0;
    puVar3[1] = 0;
    puVar3[2] = 0;
    puVar3[3] = 0;
    local_1c = operator_new(0x4c);
    local_8 = 0;
    if (local_1c == (void *)0x0) {
      uVar4 = 0;
    }
    else {
      uVar4 = thunk_FUN_00566900(0,1);
    }
    local_8 = 0xffffffff;
    **(undefined4 **)(param_1_00 + 8) = uVar4;
    uVar1 = thunk_FUN_00566c60(param_1);
    uVar20 = (**(code **)(*param_1 + 0x10))(*(int *)(param_1_00 + 8) + 4,4);
    local_20 = (int *)(*(int *)(param_1_00 + 8) + 8);
    uVar19 = (**(code **)(*param_1 + 0x10))(local_20,4);
    local_20 = (int *)(*local_20 << 3);
    pvVar21 = operator_new((uint)local_20);
    *(void **)(*(int *)(param_1_00 + 8) + 0xc) = pvVar21;
    uVar5 = (**(code **)(*param_1 + 0x10))(pvVar21,local_20);
    uVar6 = (**(code **)(*param_1 + 0x10))(param_1_00 + 0xd,1);
    uVar7 = (**(code **)(*param_1 + 0x10))(param_1_00 + 0xe,1);
    uVar2 = uVar2 & uVar1 & uVar20 & uVar19 & uVar5 & uVar6 & uVar7;
    break;
*/
};

struct fn_004367f0_case_08 {
    u8 fn_004367f0_0x08;
    u8 fn_004367f0_0x0d;
    u8 fn_004367f0_0x0e;
};

struct fn_004367f0_case_09 {
    // In game, it's allocated as 8 bytes on the heap
    // 4 bytes are read into the heap
    // Pointer is what's actually stored at 0x80
    // Simplified here it to just be the u32.
    u32 fn_004367f0_0x08; 
};

struct fn_004367f0_case_12 {
/*
    pvVar21 = operator_new(8);
    *(void **)(param_1_00 + 8) = pvVar21;
    uVar1 = (**(code **)(*param_1 + 0x10))(pvVar21,1);
    uVar20 = (**(code **)(*param_1 + 0x10))((int)pvVar21 + 4,4);
    uVar2 = uVar2 & uVar1 & uVar20;
    break;
*/
};

struct fn_004367f0_case_13 {
/*
    pvVar21 = operator_new(1);
    *(void **)(param_1_00 + 8) = pvVar21;
    uVar1 = (**(code **)(*param_1 + 0x10))(param_1_00 + 0xd,1);
    uVar20 = (**(code **)(*param_1 + 0x10))(param_1_00 + 0xe,1);
    uVar19 = (**(code **)(*param_1 + 0x10))(*(undefined4 *)(param_1_00 + 8),1);
*/
};



// Case 15, 16, 17, and 18 have different case handling in game, but all the same
// Simplified here to all just use the same case
struct fn_004367f0_case_15 {
    // In game, it's allocated as 1 byte on the heap
    // 1 bytes are read into the heap
    // Pointer is what's actually stored at 0x80
    // Simplified here it to just be the u8.
    u8 fn_004367f0_0x08;     
};

struct fn_004367f0_case_19 {

};

struct fn_004367f0_case_21 {
/*
    local_18 = (byte *)operator_new(0x4c);
    iVar22 = 0;
    local_8 = 4;
    if (local_18 != (byte *)0x0) {
      iVar22 = thunk_FUN_00566900(0,1);
    }
    local_8 = 0xffffffff;
    if (iVar22 != 0) {
      thunk_FUN_00566a50();
      FreeWrapper(iVar22);
    }
*/
};




struct fn_004367f0 {
    u32 fn_004367f0_0x04;
    u32 fn_004367f0_0x00;
    
    match (fn_004367f0_0x04) {      
        
        (0|7):
            // Case 0 falls through to same handler as 7
            fn_004367f0_case_07;
            
        (1|14):
            // Case 1 and 14 have different handlers but read in same data structure from save
            fn_004367f0_case_01;
            
        (2):
            fn_004367f0_case_02;
            
        (3):
            fn_004367f0_case_03;
            
        (4):
            fn_004367f0_case_04;;
            
        (_):
            // Default case is 5, returns 0 as a result
            empty;
            
        (6):
            fn_004367f0_case_06;
            
        (8):
            fn_004367f0_case_08;
        
        (9):
            fn_004367f0_case_09;
            
        (10|11|20):
            // Empty cases, leaves result as is;
            empty;
            
        (12):
            fn_004367f0_case_12;
            
        (13):
            fn_004367f0_case_13;
            
        (15|16|17|18):
        // Case 15, 16, 17, and 18 have different case handling in game, but all the same
        // Simplified here to all just use the same case
            fn_004367f0_case_15;
            
        (19):
            // Doesn't do any reads
            // Allocates 8 bytes on the stack and stores a pointer at 0x08
            empty;
        (21):
            fn_004367f0_case_21;
    }
};


// Struct is the main loop that reads in the last week events
// is just a part of the fn @ 00437740. Separated here as imhex pattern dsl
// doesn't support any for loops from what I can tell
// This section does construct another struct in place, rather than using a separate constructor though
// That struct is then read in using the fn @ 0x004367f0
struct fn_00437740_loop_01 {
    fn_004367f0;
};

// Constructed using fn @ 004372c0
// Doesn't appear to have a vtable
struct fn_00437740 {
    u32indexedStr mgobj_0x3f4[0xd]; //Array of string pointers
    u32 local_01;
    if (local_01 != 0) {
        u32 local_02;
        if (local_02 < local_01) {
            u32 local_03;
        } else {
            u32 local_03 = 0x16;
        }
        fn_00437740_loop_01 foobar[11];
        /*
              if (*(int *)(param_1_00 + 0x43c) == 0) {
        *(undefined4 **)(param_1_00 + 0x43c) = puVar4;
        *(undefined4 **)(param_1_00 + 0x430) = puVar4;
      }
      else {
        iVar5 = *(int *)(param_1_00 + 0x440);
        puVar4[6] = iVar5;
        *(undefined4 **)(iVar5 + 0x14) = puVar4;
      }
      iVar5 = puVar4[1];
      *(undefined4 **)(param_1_00 + 0x440) = puVar4;
      *(int *)(param_1_00 + 0x428) = *(int *)(param_1_00 + 0x428) + 1;
      if (iVar5 == local_24) {
        if (*(int *)(param_1_00 + 0x444) == 0) {
          *(undefined4 **)(param_1_00 + 0x430) = puVar4;
          *(undefined4 **)(param_1_00 + 0x444) = puVar4;
        }
        iVar5 = *(int *)(param_1_00 + 0x448);
        if (iVar5 != 0) {
          *(undefined4 **)(iVar5 + 0x1c) = puVar4;
        }
        puVar4[8] = iVar5;
        *(undefined4 **)(param_1_00 + 0x448) = puVar4;
        *(int *)(param_1_00 + 0x42c) = *(int *)(param_1_00 + 0x42c) + 1;
*/
    }
    /*
        // for s18_01 reads in data using 0x004367f0
        // Don't have a save with this yet!
        // This is likely the 'last week' data
    }
    u32 s18_04_count;
    u64 s18_04[s18_04_count];
    u32 s18_05;
    u32 s18_06;
    u8 s18_07[0x300];*/
};

// Section handling starts @ 0x006586b3
struct section18 {
    fn_00437740 global_007c0038;
};
section18 section18_at_0x00 @ 0x00;