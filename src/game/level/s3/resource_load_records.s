; Owner: game/level/s3
; Responsibility: Zone and act graphics, block, chunk and palette load records, including original unused level slots
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
; 1st PLC        palette           2nd 8x8 data       2nd 16x16 data         2nd 128x128 data
; 2nd PLC   1st 8x8 data     1st 16x16 data         1st 128x128 data
LevelLoadBlock:
                levartptrs PLCID_0B, PLCID_0B, PalID_AIZIntro, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Primary_Kos,   AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; ANGEL ISLAND ZONE ACT 1
                levartptrs PLCID_0C, PLCID_0C, PalID_AIZFire, AIZ2_8x8_Primary_KosM, AIZ2_8x8_Secondary_KosM, AIZ2_16x16_Primary_Kos,   AIZ2_16x16_Secondary_Kos, AIZ2_128x128_Kos,        AIZ2_128x128_Kos  ; ANGEL ISLAND ZONE ACT 2
                levartptrs PLCID_0E, PLCID_0F, PalID_HCZ1, HCZ_8x8_Primary_KosM,  HCZ1_8x8_Secondary_KosM, HCZ_16x16_Primary_Kos,    HCZ1_16x16_Secondary_Kos, HCZ_128x128_Primary_Kos, HCZ1_128x128_Secondary_Kos  ; HYDROCITY ZONE ACT 1
                levartptrs PLCID_10, PLCID_11, PalID_HCZ2, HCZ_8x8_Primary_KosM,  HCZ2_8x8_Secondary_KosM, HCZ_16x16_Primary_Kos,    HCZ2_16x16_Secondary_Kos, HCZ_128x128_Primary_Kos, HCZ2_128x128_Secondary_Kos  ; HYDROCITY ZONE ACT 2
                levartptrs PLCID_12, PLCID_12, PalID_MGZ1, MGZ_8x8_Primary_KosM,  MGZ1_8x8_Secondary_KosM, MGZ_16x16_Primary_Kos,    MGZ1_16x16_Secondary_Kos, MGZ_128x128_Primary_Kos, MGZ1_128x128_Secondary_Kos  ; MARBLE GARDEN ZONE ACT 1
                levartptrs PLCID_14, PLCID_14, PalID_MGZ2, MGZ_8x8_Primary_KosM,  MGZ2_8x8_Secondary_KosM, MGZ_16x16_Primary_Kos,    MGZ2_16x16_Secondary_Kos, MGZ_128x128_Primary_Kos, MGZ2_128x128_Secondary_Kos  ; MARBLE GARDEN ZONE ACT 2
                levartptrs PLCID_16, PLCID_17, PalID_CNZ1, CNZ_8x8_KosM,          CNZ_8x8_KosM,            CNZ_16x16_Kos,            CNZ_16x16_Kos,            CNZ_128x128_Kos,         CNZ_128x128_Kos  ; CARNIVAL NIGHT ZONE ACT 1
                levartptrs PLCID_18, PLCID_19, PalID_CNZ2, CNZ_8x8_KosM,          CNZ_8x8_KosM,            CNZ_16x16_Kos,            CNZ_16x16_Kos,            CNZ_128x128_Kos,         CNZ_128x128_Kos  ; CARNIVAL NIGHT ZONE ACT 2
                levartptrs PLCID_1A, PLCID_1A, PalID_FBZ1, FBZ1_8x8_KosM,         FBZ1_8x8_KosM,           FBZ1_16x16_Kos,           FBZ1_16x16_Kos,           FBZ1_128x128_Kos,        FBZ1_128x128_Kos  ; FLYING BATTERY ZONE ACT 1 (unused)
                levartptrs PLCID_1C, PLCID_1C, PalID_FBZ2, FBZ2_8x8_KosM,         FBZ2_8x8_KosM,           FBZ2_16x16_Kos,           FBZ2_16x16_Kos,           FBZ2_128x128_Kos,        FBZ2_128x128_Kos  ; FLYING BATTERY ZONE ACT 2 (unused)
                levartptrs PLCID_1E, PLCID_1E, PalID_ICZ1, ICZ_8x8_Primary_KosM,  ICZ1_8x8_Secondary_KosM, ICZ_16x16_Primary_Kos,    ICZ1_16x16_Secondary_Kos, ICZ_128x128_Primary_Kos, ICZ1_128x128_Secondary_Kos  ; ICECAP ZONE ACT 1
                levartptrs PLCID_20, PLCID_20, PalID_ICZ2, ICZ_8x8_Primary_KosM,  ICZ2_8x8_Secondary_KosM, ICZ_16x16_Primary_Kos,    ICZ2_16x16_Secondary_Kos, ICZ_128x128_Primary_Kos, ICZ2_128x128_Secondary_Kos  ; ICECAP ZONE ACT 2
                levartptrs PLCID_22, PLCID_22, PalID_LBZ1, LBZ_8x8_Primary_KosM,  LBZ1_8x8_Secondary_KosM, LBZ_16x16_Primary_Kos,    LBZ1_16x16_Secondary_Kos, LBZ1_128x128_Kos,        LBZ1_128x128_Kos  ; LAUNCH BASE ZONE ACT 1
                levartptrs PLCID_24, PLCID_25, PalID_LBZ2, LBZ_8x8_Primary_KosM,  LBZ2_8x8_Secondary_KosM, LBZ_16x16_Primary_Kos,    LBZ2_16x16_Secondary_Kos, LBZ2_128x128_Kos,        LBZ2_128x128_Kos  ; LAUNCH BASE ZONE ACT 2
                levartptrs PLCID_26, PLCID_26, PalID_MHZ1, ArtKosM_MHZ,           ArtKosM_MHZ,             MHZ_16x16_Kos,            MHZ_16x16_Kos,            MHZ_128x128_Kos,         MHZ_128x128_Kos  ; MUSHROOM HILL ZONE ACT 1 (unused)
                levartptrs PLCID_28, PLCID_28, PalID_MHZ2, ArtKosM_MHZ,           ArtKosM_MHZ,             MHZ_16x16_Kos,            MHZ_16x16_Kos,            MHZ_128x128_Kos,         MHZ_128x128_Kos  ; MUSHROOM HILL ZONE ACT 2 (unused)
                levartptrs PLCID_0B, PLCID_0B, PalID_AIZIntro, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; SANDOPOLIS ZONE ACT 1 (unused)
                levartptrs PLCID_0C, PLCID_0C, PalID_AIZFire, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; SANDOPOLIS ZONE ACT 2 (unused)
                levartptrs PLCID_2E, PLCID_2E, PalID_LRZ1, ArtKosM_LRZ,           ArtKosM_LRZ,             LRZ_16x16_Kos,            LRZ_16x16_Kos,            LRZ_128x128_Kos,         LRZ_128x128_Kos  ; LAVA REEF ZONE ACT 1 (unused)
                levartptrs PLCID_30, PLCID_30, PalID_LRZ2, ArtKosM_LRZ,           ArtKosM_LRZ,             LRZ_16x16_Kos,            LRZ_16x16_Kos,            LRZ_128x128_Kos,         LRZ_128x128_Kos  ; LAVA REEF ZONE ACT 2 (unused)
                levartptrs PLCID_0B, PLCID_0B, PalID_AIZIntro, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; SKY SANCTUARY ZONE (SONIC/TAILS) (unused)
                levartptrs PLCID_0C, PLCID_0C, PalID_AIZFire, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; SKY SANCTUARY ZONE (KNUCKLES) (unused)
                levartptrs PLCID_0B, PLCID_0B, PalID_AIZIntro, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; DEATH EGG ZONE ACT 1 (unused)
                levartptrs PLCID_0C, PLCID_0C, PalID_AIZFire, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; DEATH EGG ZONE ACT 2 (unused)
                levartptrs PLCID_0B, PLCID_0B, PalID_AIZIntro, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; DOOMSDAY ZONE (unused)
                levartptrs PLCID_0C, PLCID_0C, PalID_AIZFire, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; DOOMSDAY ZONE (unused)

                levartptrs PLCID_0B, PLCID_0B, PalID_AIZ, AIZ1_8x8_Primary_KosM, AIZ1_8x8_MainLevel_KosM, AIZ1_16x16_Primary_Kos,   AIZ1_16x16_MainLevel_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; SONIC/TAILS INTRO (unused)
                levartptrs PLCID_0C, PLCID_0C, PalID_AIZFire, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; SONIC/TAILS ENDING (unused)

                levartptrs PLCID_42, PLCID_42, PalID_ALZ, ALZ_8x8_KosM,          ALZ_8x8_KosM,            ALZ_16x16_Kos,            ALZ_16x16_Kos,            ALZ_128x128_Kos,         ALZ_128x128_Kos  ; AZURE LAKE ZONE
                levartptrs PLCID_42, PLCID_42, PalID_ALZ_2, ALZ_8x8_KosM,          ALZ_8x8_KosM,            ALZ_16x16_Kos,            ALZ_16x16_Kos,            ALZ_128x128_Kos,         ALZ_128x128_Kos  ; AZURE LAKE ZONE (unused)
                levartptrs PLCID_43, PLCID_43, PalID_BPZ, BPZ_8x8_KosM,          BPZ_8x8_KosM,            BPZ_16x16_Kos,            BPZ_16x16_Kos,            BPZ_128x128_Kos,         BPZ_128x128_Kos  ; BALLOON PARK ZONE
                levartptrs PLCID_43, PLCID_43, PalID_BPZ_2, BPZ_8x8_KosM,          BPZ_8x8_KosM,            BPZ_16x16_Kos,            BPZ_16x16_Kos,            BPZ_128x128_Kos,         BPZ_128x128_Kos  ; BALLOON PARK ZONE (unused)
                levartptrs PLCID_44, PLCID_44, PalID_DPZ, DPZ_8x8_KosM,          DPZ_8x8_KosM,            DPZ_16x16_Kos,            DPZ_16x16_Kos,            DPZ_128x128_Kos,         DPZ_128x128_Kos  ; DESERT PALACE ZONE
                levartptrs PLCID_44, PLCID_44, PalID_DPZ, DPZ_8x8_KosM,          DPZ_8x8_KosM,            DPZ_16x16_Kos,            DPZ_16x16_Kos,            DPZ_128x128_Kos,         DPZ_128x128_Kos  ; DESERT PALACE ZONE (unused)
                levartptrs PLCID_45, PLCID_45, PalID_CGZ, CGZ_8x8_KosM,          CGZ_8x8_KosM,            CGZ_16x16_Kos,            CGZ_16x16_Kos,            CGZ_128x128_Kos,         CGZ_128x128_Kos  ; CHROME GADGET ZONE
                levartptrs PLCID_45, PLCID_45, PalID_CGZ, CGZ_8x8_KosM,          CGZ_8x8_KosM,            CGZ_16x16_Kos,            CGZ_16x16_Kos,            CGZ_128x128_Kos,         CGZ_128x128_Kos  ; CHROME GADGET ZONE (unused)
                levartptrs PLCID_46, PLCID_46, PalID_EMZ, EMZ_8x8_KosM,          EMZ_8x8_KosM,            EMZ_16x16_Kos,            EMZ_16x16_Kos,            EMZ_128x128_Kos,         EMZ_128x128_Kos  ; ENDLESS MINE ZONE
                levartptrs PLCID_46, PLCID_46, PalID_EMZ, EMZ_8x8_KosM,          EMZ_8x8_KosM,            EMZ_16x16_Kos,            EMZ_16x16_Kos,            EMZ_128x128_Kos,         EMZ_128x128_Kos  ; ENDLESS MINE ZONE (unused)

                levartptrs PLCID_47, PLCID_47, PalID_Gumball_Special, Gumball_8x8_KosM,      Gumball_8x8_KosM,        Gumball_16x16_Kos,        Gumball_16x16_Kos,        Gumball_128x128_Kos,     Gumball_128x128_Kos  ; GUMBALL
                levartptrs PLCID_47, PLCID_47, PalID_Gumball_Special, Gumball_8x8_KosM,      Gumball_8x8_KosM,        Gumball_16x16_Kos,        Gumball_16x16_Kos,        Gumball_128x128_Kos,     Gumball_128x128_Kos  ; GUMBALL (unused)
                levartptrs PLCID_47, PLCID_47, PalID_Pachinko_Special, ArtKosM_Pachinko,      ArtKosM_Pachinko,        Pachinko_16x16_Kos,       Pachinko_16x16_Kos,       Pachinko_128x128_Kos,    Pachinko_128x128_Kos  ; PACHINKO (unused)
                levartptrs PLCID_47, PLCID_47, PalID_Pachinko_Special, ArtKosM_Pachinko,      ArtKosM_Pachinko,        Pachinko_16x16_Kos,       Pachinko_16x16_Kos,       Pachinko_128x128_Kos,    Pachinko_128x128_Kos  ; PACHINKO (unused)
                levartptrs PLCID_47, PLCID_47, PalID_Slot_Special, ArtKosM_Slots,         ArtKosM_Slots,           Slots_16x16_Kos,          Slots_16x16_Kos,          Slots_128x128_Kos,       Slots_128x128_Kos  ; SLOTS (unused)
                levartptrs PLCID_47, PLCID_47, PalID_Slot_Special, ArtKosM_Slots,         ArtKosM_Slots,           Slots_16x16_Kos,          Slots_16x16_Kos,          Slots_128x128_Kos,       Slots_128x128_Kos  ; SLOTS (unused)

                levartptrs PLCID_0B, PLCID_0B, PalID_AIZIntro, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; LAVA REEF ZONE BOSS (unused)
                levartptrs PLCID_0C, PLCID_0C, PalID_AIZFire, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; HIDDEN PALACE ZONE (unused)
                levartptrs PLCID_0B, PLCID_0B, PalID_AIZIntro, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; SONIC/TAILS FINAL BOSS (unused)
                levartptrs PLCID_0C, PLCID_0C, PalID_AIZFire, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Secondary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,        AIZ1_128x128_Kos  ; SPECIAL STAGE HUB (unused)
