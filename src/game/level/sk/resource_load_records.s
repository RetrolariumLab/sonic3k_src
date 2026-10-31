; Owner: game/level/sk
; Responsibility: Zone and act graphics, block, chunk and palette load records, including original unused level slots
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
; 1st PLC  palette                          2nd 8x8 data                                     2nd 16x16 data                                      2nd 128x128 data
; 2nd PLC           1st 8x8 data                                    1st 16x16 data                                    1st 128x128 data
LevelLoadBlock:
                levartptrs PLCID_0B, PLCID_0B, PalID_AIZIntro, AIZ1_8x8_Primary_KosM, AIZ1_8x8_Secondary_KosM, AIZ1_16x16_Primary_Kos, AIZ1_16x16_Secondary_Kos, AIZ1_128x128_Kos,         AIZ1_128x128_Kos  ; ANGEL ISLAND ZONE ACT 1
                levartptrs PLCID_0C, PLCID_0C, PalID_AIZFire, AIZ2_8x8_Primary_KosM, AIZ2_8x8_Secondary_KosM, AIZ2_16x16_Primary_Kos, AIZ2_16x16_Secondary_Kos, AIZ2_128x128_Kos,         AIZ2_128x128_Kos  ; ANGEL ISLAND ZONE ACT 2
                levartptrs PLCID_0E, PLCID_0F, PalID_HCZ1, HCZ_8x8_Primary_KosM,  HCZ1_8x8_Secondary_KosM, HCZ_16x16_Primary_Kos,  HCZ1_16x16_Secondary_Kos, HCZ_128x128_Primary_Kos,  HCZ1_128x128_Secondary_Kos  ; HYDROCITY ZONE ACT 1
                levartptrs PLCID_10, PLCID_11, PalID_HCZ2, HCZ_8x8_Primary_KosM,  HCZ2_8x8_Secondary_KosM, HCZ_16x16_Primary_Kos,  HCZ2_16x16_Secondary_Kos, HCZ_128x128_Primary_Kos,  HCZ2_128x128_Secondary_Kos  ; HYDROCITY ZONE ACT 2
                levartptrs PLCID_12, PLCID_12, PalID_MGZ1, MGZ_8x8_Primary_KosM,  MGZ1_8x8_Secondary_KosM, MGZ_16x16_Primary_Kos,  MGZ1_16x16_Secondary_Kos, MGZ_128x128_Primary_Kos,  MGZ1_128x128_Secondary_Kos  ; MARBLE GARDEN ZONE ACT 1
                levartptrs PLCID_14, PLCID_14, PalID_MGZ2, MGZ_8x8_Primary_KosM,  MGZ2_8x8_Secondary_KosM, MGZ_16x16_Primary_Kos,  MGZ2_16x16_Secondary_Kos, MGZ_128x128_Primary_Kos,  MGZ2_128x128_Secondary_Kos  ; MARBLE GARDEN ZONE ACT 2
                levartptrs PLCID_16, PLCID_17, PalID_CNZ1, CNZ_8x8_KosM,          CNZ_8x8_KosM,            CNZ_16x16_Kos,          CNZ_16x16_Kos,            CNZ_128x128_Kos,          CNZ_128x128_Kos  ; CARNIVAL NIGHT ZONE ACT 1
                levartptrs PLCID_18, PLCID_19, PalID_CNZ2, CNZ_8x8_KosM,          CNZ_8x8_KosM,            CNZ_16x16_Kos,          CNZ_16x16_Kos,            CNZ_128x128_Kos,          CNZ_128x128_Kos  ; CARNIVAL NIGHT ZONE ACT 2
                levartptrs PLCID_1A, PLCID_1A, PalID_FBZ1, ArtKosM_FBZ,           ArtKosM_FBZ,             FBZ_16x16_Kos,          FBZ_16x16_Kos,            FBZ_128x128_Kos,          FBZ_128x128_Kos  ; FLYING BATTERY ZONE ACT 1
                levartptrs PLCID_1C, PLCID_1C, PalID_FBZ2, ArtKosM_FBZ,           ArtKosM_FBZ,             FBZ_16x16_Kos,          FBZ_16x16_Kos,            FBZ_128x128_Kos,          FBZ_128x128_Kos  ; FLYING BATTERY ZONE ACT 2
                levartptrs PLCID_1E, PLCID_1E, PalID_ICZ1, ICZ_8x8_Primary_KosM,  ICZ1_8x8_Secondary_KosM, ICZ_16x16_Primary_Kos,  ICZ1_16x16_Secondary_Kos, ICZ_128x128_Primary_Kos,  ICZ1_128x128_Secondary_Kos  ; ICECAP ZONE ACT 1
                levartptrs PLCID_20, PLCID_20, PalID_ICZ2, ICZ_8x8_Primary_KosM,  ICZ2_8x8_Secondary_KosM, ICZ_16x16_Primary_Kos,  ICZ2_16x16_Secondary_Kos, ICZ_128x128_Primary_Kos,  ICZ2_128x128_Secondary_Kos  ; ICECAP ZONE ACT 2
                levartptrs PLCID_22, PLCID_22, PalID_LBZ1, LBZ_8x8_Primary_KosM,  LBZ1_8x8_Secondary_KosM, LBZ_16x16_Primary_Kos,  LBZ1_16x16_Secondary_Kos, LBZ1_128x128_Kos,         LBZ1_128x128_Kos  ; LAUNCH BASE ZONE ACT 1
                levartptrs PLCID_24, PLCID_25, PalID_LBZ2, LBZ_8x8_Primary_KosM,  LBZ2_8x8_Secondary_KosM, LBZ_16x16_Primary_Kos,  LBZ2_16x16_Secondary_Kos, LBZ2_128x128_Kos,         LBZ2_128x128_Kos  ; LAUNCH BASE ZONE ACT 2
                levartptrs PLCID_26, PLCID_26, PalID_MHZ1, ArtKosM_MHZ_Primary,   ArtKosM_MHZ_Secondary,   MHZ_16x16_Primary_Kos,  MHZ_16x16_Secondary_Kos,  MHZ_128x128_Primary_Kos,  MHZ_128x128_Secondary_Kos  ; MUSHROOM HILL ZONE ACT 1
                levartptrs PLCID_28, PLCID_28, PalID_MHZ2, ArtKosM_MHZ_Primary,   ArtKosM_MHZ_Secondary,   MHZ_16x16_Primary_Kos,  MHZ_16x16_Secondary_Kos,  MHZ_128x128_Primary_Kos,  MHZ_128x128_Secondary_Kos  ; MUSHROOM HILL ZONE ACT 2
                levartptrs PLCID_2A, PLCID_2A, PalID_SOZ1, ArtKosM_SOZ_Primary,   ArtKosM_SOZ1_Secondary,  SOZ_16x16_Primary_Kos,  SOZ1_16x16_Secondary_Kos, SOZ_128x128_Kos,          SOZ_128x128_Kos  ; SANDOPOLIS ZONE ACT 1
                levartptrs PLCID_2C, PLCID_2C, PalID_SOZ2, ArtKosM_SOZ_Primary,   ArtKosM_SOZ2_Secondary,  SOZ_16x16_Primary_Kos,  SOZ2_16x16_Secondary_Kos, SOZ_128x128_Kos,          SOZ_128x128_Kos  ; SANDOPOLIS ZONE ACT 2
                levartptrs PLCID_2E, PLCID_2F, PalID_LRZ1, ArtKosM_LRZ_Primary,   ArtKosM_LRZ1_Secondary,  LRZ_16x16_Primary_Kos,  LRZ1_16x16_Secondary_Kos, LRZ_128x128_Primary_Kos,  LRZ1_128x128_Secondary_Kos  ; LAVA REEF ZONE ACT 1
                levartptrs PLCID_30, PLCID_30, PalID_LRZ2, ArtKosM_LRZ_Primary,   ArtKosM_LRZ2_Secondary,  LRZ_16x16_Primary_Kos,  LRZ2_16x16_Secondary_Kos, LRZ_128x128_Primary_Kos,  LRZ2_128x128_Secondary_Kos  ; LAVA REEF ZONE ACT 2
                levartptrs PLCID_32, PLCID_32, PalID_SSZ1, ArtKosM_SSZ1_Primary,  ArtKosM_SSZ1_Secondary,  SSZ1_16x16_Primary_Kos, SSZ1_16x16_Secondary_Kos, SSZ1_128x128_Primary_Kos, SSZ1_128x128_Secondary_Kos  ; SKY SANCTUARY ZONE (SONIC/TAILS)
                levartptrs PLCID_34, PLCID_34, PalID_SSZ2, ArtKosM_SSZ2,          ArtKosM_SSZ2,            SSZ2_16x16_Kos,         SSZ2_16x16_Kos,           SSZ2_128x128_Kos,         SSZ2_128x128_Kos  ; SKY SANCTUARY ZONE (KNUCKLES)
                levartptrs PLCID_36, PLCID_36, PalID_DEZ1, ArtKosM_DEZ_Primary,   ArtKosM_DEZ1_Secondary,  DEZ_16x16_Primary_Kos,  DEZ1_16x16_Secondary_Kos, DEZ_128x128_Kos,          DEZ_128x128_Kos  ; DEATH EGG ZONE ACT 1
                levartptrs PLCID_38, PLCID_38, PalID_DEZ2, ArtKosM_DEZ_Primary,   ArtKosM_DEZ2_Secondary,  DEZ_16x16_Primary_Kos,  DEZ2_16x16_Secondary_Kos, DEZ_128x128_Kos,          DEZ_128x128_Kos  ; DEATH EGG ZONE ACT 2
                levartptrs PLCID_3A, PLCID_3A, PalID_DDZ1, ArtKosM_DDZ,           ArtKosM_DDZ,             DDZ_16x16_Kos,          DDZ_16x16_Kos,            DDZ_128x128_Kos,          DDZ_128x128_Kos  ; DOOMSDAY ZONE
                levartptrs PLCID_3C, PLCID_3C, PalID_DDZ2, ArtKosM_DDZ,           ArtKosM_DDZ,             DDZ_16x16_Kos,          DDZ_16x16_Kos,            DDZ_128x128_Kos,          DDZ_128x128_Kos  ; DOOMSDAY ZONE (unused)

                levartptrs PLCID_0B, PLCID_0B, PalID_AIZ, AIZ1_8x8_Primary_KosM, AIZ1_8x8_MainLevel_KosM, AIZ1_16x16_Primary_Kos, AIZ1_16x16_MainLevel_Kos, AIZ1_128x128_Kos,         AIZ1_128x128_Kos  ; SONIC/TAILS INTRO
                levartptrs PLCID_40, PLCID_40, PalID_Ending2, ArtKosM_SSZ2,          ArtKosM_SSZ2,            SSZ2_16x16_Kos,         SSZ2_16x16_Kos,           SSZ2_128x128_Kos,         SSZ2_128x128_Kos  ; SONIC/TAILS ENDING

                levartptrs PLCID_42, PLCID_42, PalID_ALZ, ALZ_8x8_KosM,          ALZ_8x8_KosM,            ALZ_16x16_Kos,          ALZ_16x16_Kos,            ALZ_128x128_Kos,          ALZ_128x128_Kos  ; AZURE LAKE ZONE
                levartptrs PLCID_42, PLCID_42, PalID_ALZ_2, ALZ_8x8_KosM,          ALZ_8x8_KosM,            ALZ_16x16_Kos,          ALZ_16x16_Kos,            ALZ_128x128_Kos,          ALZ_128x128_Kos  ; AZURE LAKE ZONE (unused)
                levartptrs PLCID_43, PLCID_43, PalID_BPZ, BPZ_8x8_KosM,          BPZ_8x8_KosM,            BPZ_16x16_Kos,          BPZ_16x16_Kos,            BPZ_128x128_Kos,          BPZ_128x128_Kos  ; BALLOON PARK ZONE
                levartptrs PLCID_43, PLCID_43, PalID_BPZ_2, BPZ_8x8_KosM,          BPZ_8x8_KosM,            BPZ_16x16_Kos,          BPZ_16x16_Kos,            BPZ_128x128_Kos,          BPZ_128x128_Kos  ; BALLOON PARK ZONE (unused)
                levartptrs PLCID_44, PLCID_44, PalID_DPZ, DPZ_8x8_KosM,          DPZ_8x8_KosM,            DPZ_16x16_Kos,          DPZ_16x16_Kos,            DPZ_128x128_Kos,          DPZ_128x128_Kos  ; DESERT PALACE ZONE
                levartptrs PLCID_44, PLCID_44, PalID_DPZ, DPZ_8x8_KosM,          DPZ_8x8_KosM,            DPZ_16x16_Kos,          DPZ_16x16_Kos,            DPZ_128x128_Kos,          DPZ_128x128_Kos  ; DESERT PALACE ZONE (unused)
                levartptrs PLCID_45, PLCID_45, PalID_CGZ, CGZ_8x8_KosM,          CGZ_8x8_KosM,            CGZ_16x16_Kos,          CGZ_16x16_Kos,            CGZ_128x128_Kos,          CGZ_128x128_Kos  ; CHROME GADGET ZONE
                levartptrs PLCID_45, PLCID_45, PalID_CGZ, CGZ_8x8_KosM,          CGZ_8x8_KosM,            CGZ_16x16_Kos,          CGZ_16x16_Kos,            CGZ_128x128_Kos,          CGZ_128x128_Kos  ; CHROME GADGET ZONE (unused)
                levartptrs PLCID_46, PLCID_46, PalID_EMZ, EMZ_8x8_KosM,          EMZ_8x8_KosM,            EMZ_16x16_Kos,          EMZ_16x16_Kos,            EMZ_128x128_Kos,          EMZ_128x128_Kos  ; ENDLESS MINE ZONE
                levartptrs PLCID_46, PLCID_46, PalID_EMZ, EMZ_8x8_KosM,          EMZ_8x8_KosM,            EMZ_16x16_Kos,          EMZ_16x16_Kos,            EMZ_128x128_Kos,          EMZ_128x128_Kos  ; ENDLESS MINE ZONE (unused)

                levartptrs PLCID_47, PLCID_47, PalID_Gumball_Special, Gumball_8x8_KosM,      Gumball_8x8_KosM,        Gumball_16x16_Kos,      Gumball_16x16_Kos,        Gumball_128x128_Kos,      Gumball_128x128_Kos  ; GUMBALL
                levartptrs PLCID_47, PLCID_47, PalID_Gumball_Special, Gumball_8x8_KosM,      Gumball_8x8_KosM,        Gumball_16x16_Kos,      Gumball_16x16_Kos,        Gumball_128x128_Kos,      Gumball_128x128_Kos  ; GUMBALL (unused)
                levartptrs PLCID_50, PLCID_50, PalID_Pachinko_Special, ArtKosM_Pachinko,      ArtKosM_Pachinko,        Pachinko_16x16_Kos,     Pachinko_16x16_Kos,       Pachinko_128x128_Kos,     Pachinko_128x128_Kos  ; PACHINKO
                levartptrs PLCID_50, PLCID_50, PalID_Pachinko_Special, ArtKosM_Pachinko,      ArtKosM_Pachinko,        Pachinko_16x16_Kos,     Pachinko_16x16_Kos,       Pachinko_128x128_Kos,     Pachinko_128x128_Kos  ; PACHINKO (unused)
                levartptrs PLCID_51, PLCID_51, PalID_Slot_Special, ArtKosM_Slots,         ArtKosM_Slots,           Slots_16x16_Kos,        Slots_16x16_Kos,          Slots_128x128_Kos,        Slots_128x128_Kos  ; SLOTS
                levartptrs PLCID_51, PLCID_51, PalID_Slot_Special, ArtKosM_Slots,         ArtKosM_Slots,           Slots_16x16_Kos,        Slots_16x16_Kos,          Slots_128x128_Kos,        Slots_128x128_Kos  ; SLOTS (unused)

                levartptrs PLCID_48, PLCID_48, PalID_LRZBoss, ArtKosM_HPZ_Primary,   ArtKosM_LRZ3_Secondary,  HPZ_16x16_Primary_Kos,  LRZ3_16x16_Secondary_Kos, HPZ_128x128_Primary_Kos,  LRZ3_128x128_Secondary_Kos  ; LAVA REEF ZONE BOSS
                levartptrs PLCID_48, PLCID_48, PalID_HPZIntro, ArtKosM_HPZ_Primary,   ArtKosM_HPZ_Secondary,   HPZ_16x16_Primary_Kos,  HPZ_16x16_Secondary_Kos,  HPZ_128x128_Primary_Kos,  HPZ_128x128_Secondary_Kos  ; HIDDEN PALACE ZONE
                levartptrs PLCID_4C, PLCID_4C, PalID_DEZBoss, ArtKosM_DEZ3,          ArtKosM_DEZ3,            DEZ3_16x16_Kos,         DEZ3_16x16_Kos,           DEZ3_128x128_Kos,         DEZ3_128x128_Kos  ; SONIC/TAILS FINAL BOSS
                levartptrs PLCID_48, PLCID_48, PalID_HPZIntro, ArtKosM_HPZ_Primary,   ArtKosM_HPZ_Secondary,   HPZ_16x16_Primary_Kos,  HPZ_16x16_Secondary_Kos,  HPZ_128x128_Primary_Kos,  HPZ_128x128_Secondary_Kos  ; SPECIAL STAGE HUB
