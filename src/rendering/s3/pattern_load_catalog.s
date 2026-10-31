; Owner: rendering/s3
; Responsibility: Pattern-load identifiers, relative pointer macro and complete primary level and scene art request catalog
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

; Assembly macro to define PLC pointer entry
plcptr:         macro   plc,{INTLABEL}
__LABEL__:      label   (*-Offs_PLC)/2
                    dc.w    plc-Offs_PLC
                endm

Offs_PLC:
PLCID_00:       plcptr  PLC_00                          ; Sonic life icon/universal level graphics
PLCID_01:       plcptr  PLC_01                          ; Sonic life icon/universal level graphics
PLCID_02:       plcptr  PLC_02                          ; Explosions + Squirrel/Flicky (unused)
PLCID_03:       plcptr  PLC_03                          ; Game Over text
PLCID_04:       plcptr  PLC_04                          ; Signpost art (unused)
PLCID_05:       plcptr  PLC_05                          ; Spikes and springs (unused)
PLCID_06:       plcptr  PLC_06                          ; 2P mode-specific art
PLCID_07:       plcptr  PLC_07                          ; Tails life icon/universal level graphics
PLCID_08:       plcptr  PLC_08                          ; Monitor art only
PLCID_09:       plcptr  PLC_09                          ; Revolving spheres
PLCID_0A:       plcptr  PLC_0A                          ; AIZ intro graphics
PLCID_0B:       plcptr  PLC_0B                          ; AIZ1
PLCID_0C:       plcptr  PLC_0C_0D                       ; AIZ2
PLCID_0D:       plcptr  PLC_0C_0D                       ; AIZ2 (unused)
PLCID_0E:       plcptr  PLC_0E                          ; HCZ1 part 1
PLCID_0F:       plcptr  PLC_0F                          ; HCZ1 part 2
PLCID_10:       plcptr  PLC_10                          ; HCZ2 part 1
PLCID_11:       plcptr  PLC_11                          ; HCZ2 part 2
PLCID_12:       plcptr  PLC_12_13                       ; MGZ1
PLCID_13:       plcptr  PLC_12_13                       ; MGZ1 (unused)
PLCID_14:       plcptr  PLC_14_15                       ; MGZ2
PLCID_15:       plcptr  PLC_14_15                       ; MGZ2 (unused)
PLCID_16:       plcptr  PLC_16_17_18_19                 ; CNZ (used for act 1)
PLCID_17:       plcptr  PLC_16_17_18_19                 ; CNZ (used for act 1)
PLCID_18:       plcptr  PLC_16_17_18_19                 ; CNZ (used for act 2)
PLCID_19:       plcptr  PLC_16_17_18_19                 ; CNZ (used for act 2)
PLCID_1A:       plcptr  PLC_1A_1B_1C_1D                 ; FBZ (used for act 1)
PLCID_1B:       plcptr  PLC_1A_1B_1C_1D                 ; FBZ (act 1, unused)
PLCID_1C:       plcptr  PLC_1A_1B_1C_1D                 ; FBZ (used for act 2)
PLCID_1D:       plcptr  PLC_1A_1B_1C_1D                 ; FBZ (act 2, unused)
PLCID_1E:       plcptr  PLC_1E_1F                       ; ICZ1
PLCID_1F:       plcptr  PLC_1E_1F                       ; ICZ1 (unused)
PLCID_20:       plcptr  PLC_20_21                       ; ICZ2
PLCID_21:       plcptr  PLC_20_21                       ; ICZ2 (unused)
PLCID_22:       plcptr  PLC_22_23                       ; LBZ1
PLCID_23:       plcptr  PLC_22_23                       ; LBZ1 (unused)
PLCID_24:       plcptr  PLC_24                          ; LBZ2
PLCID_25:       plcptr  PLC_25                          ; LBZ2 misc art
PLCID_26:       plcptr  PLC_26_Through_2D               ; MHZ (used for act 1)
PLCID_27:       plcptr  PLC_26_Through_2D               ; MHZ (act 1, unused)
PLCID_28:       plcptr  PLC_26_Through_2D               ; MHZ (used for act 2)
PLCID_29:       plcptr  PLC_26_Through_2D               ; MHZ (act 2, unused)
PLCID_2A:       plcptr  PLC_26_Through_2D               ; MHZ (SOZ1, unused)
PLCID_2B:       plcptr  PLC_26_Through_2D               ; MHZ (SOZ1, unused)
PLCID_2C:       plcptr  PLC_26_Through_2D               ; MHZ (SOZ2, unused)
PLCID_2D:       plcptr  PLC_26_Through_2D               ; MHZ (SOZ2, unused)
PLCID_2E:       plcptr  PLC_2E_Through_41               ; LRZ (used for act 1)
PLCID_2F:       plcptr  PLC_2E_Through_41               ; LRZ (act 1, unused)
PLCID_30:       plcptr  PLC_2E_Through_41               ; LRZ (used for act 2)
PLCID_31:       plcptr  PLC_2E_Through_41               ; LRZ (act 2, unused)
PLCID_32:       plcptr  PLC_2E_Through_41               ; LRZ (SSZ1, unused)
PLCID_33:       plcptr  PLC_2E_Through_41               ; LRZ (SSZ1, unused)
PLCID_34:       plcptr  PLC_2E_Through_41               ; LRZ (SSZ2, unused)
PLCID_35:       plcptr  PLC_2E_Through_41               ; LRZ (SSZ2, unused)
PLCID_36:       plcptr  PLC_2E_Through_41               ; LRZ (DEZ1, unused)
PLCID_37:       plcptr  PLC_2E_Through_41               ; LRZ (DEZ1, unused)
PLCID_38:       plcptr  PLC_2E_Through_41               ; LRZ (DEZ2, unused)
PLCID_39:       plcptr  PLC_2E_Through_41               ; LRZ (DEZ2, unused)
PLCID_3A:       plcptr  PLC_2E_Through_41               ; LRZ (DDZ1, unused)
PLCID_3B:       plcptr  PLC_2E_Through_41               ; LRZ (DDZ1, unused)
PLCID_3C:       plcptr  PLC_2E_Through_41               ; LRZ (DDZ2, unused)
PLCID_3D:       plcptr  PLC_2E_Through_41               ; LRZ (DDZ2, unused)
PLCID_3E:       plcptr  PLC_2E_Through_41               ; LRZ (ending 1, unused)
PLCID_3F:       plcptr  PLC_2E_Through_41               ; LRZ (ending 1, unused)
PLCID_40:       plcptr  PLC_2E_Through_41               ; LRZ (ending 2, unused)
PLCID_41:       plcptr  PLC_2E_Through_41               ; LRZ (ending 2, unused)
PLCID_42:       plcptr  PLC_42                          ; ALZ
PLCID_43:       plcptr  PLC_43                          ; BPZ
PLCID_44:       plcptr  PLC_44                          ; DPZ
PLCID_45:       plcptr  PLC_45                          ; CGZ
PLCID_46:       plcptr  PLC_46                          ; EMZ
PLCID_47:       plcptr  PLC_47                          ; Gumball Bonus
PLCID_48:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_49:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_4A:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_4B:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_4C:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_4D:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_4E:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_4F:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_50:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_51:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_52:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_53:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_54:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_55:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_56:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_57:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_58:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_59:       plcptr  PLC_48_Through_5A               ; AIZ1 boss (unused)
PLCID_5A:       plcptr  PLC_48_Through_5A               ; AIZ1 boss
PLCID_5B:       plcptr  PLC_5B                          ; HCZ1 boss
PLCID_5C:       plcptr  PLC_5C_5D                       ; CNZ1 boss (unused)
PLCID_5D:       plcptr  PLC_5C_5D                       ; CNZ1 boss
PLCID_5E:       plcptr  PLC_5E                          ; FBZ1 boss
PLCID_5F:       plcptr  PLC_5F                          ; ICZ1 boss
PLCID_60:       plcptr  PLC_60                          ; LBZ1 Eggman
PLCID_61:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss (unused)
PLCID_62:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss (unused)
PLCID_63:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss (unused)
PLCID_64:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss (unused)
PLCID_65:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss (unused)
PLCID_66:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss (unused)
PLCID_67:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss (unused)
PLCID_68:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss (unused)
PLCID_69:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss (unused)
PLCID_6A:       plcptr  PLC_61_Through_6A               ; FBZ2 subboss
PLCID_6B:       plcptr  PLC_6B                          ; AIZ2 boss
PLCID_6C:       plcptr  PLC_6C                          ; HCZ2 boss
PLCID_6D:       plcptr  PLC_6D                          ; MGZ2 boss
PLCID_6E:       plcptr  PLC_6E                          ; CNZ2 boss
PLCID_6F:       plcptr  PLC_6F                          ; FBZ2 end boss
PLCID_70:       plcptr  PLC_70                          ; ICZ2 boss
PLCID_71:       plcptr  PLC_71                          ; LBZ2 final boss 1
PLCID_72:       plcptr  PLC_72_73_74_75_76_77           ; LBZ2 Eggman (unused)
PLCID_73:       plcptr  PLC_72_73_74_75_76_77           ; LBZ2 Eggman (unused)
PLCID_74:       plcptr  PLC_72_73_74_75_76_77           ; LBZ2 Eggman (unused)
PLCID_75:       plcptr  PLC_72_73_74_75_76_77           ; LBZ2 Eggman (unused)
PLCID_76:       plcptr  PLC_72_73_74_75_76_77           ; LBZ2 Eggman (unused)
PLCID_77:       plcptr  PLC_72_73_74_75_76_77           ; LBZ2 Eggman
PLCID_78:       plcptr  PLC_78_79_7A_7B                 ; Boss ship and explosion (unused)
PLCID_79:       plcptr  PLC_78_79_7A_7B                 ; Boss ship and explosion (unused)
PLCID_7A:       plcptr  PLC_78_79_7A_7B                 ; Boss ship and explosion (unused)
PLCID_7B:       plcptr  PLC_78_79_7A_7B                 ; Boss ship and explosion (unused)

PLC_00:         plrlistheader
                plreq   ArtTile_PlayerLifeIcon, ArtNem_SonicLifeIcon
                plreq   ArtTile_Ring, ArtNem_RingHUDText
                plreq   ArtTile_StarPost, ArtNem_EnemyPtsStarPost
                plreq   ArtTile_Monitors, ArtNem_Monitors
PLC_00_End:

PLC_01:         plrlistheader
                plreq   ArtTile_PlayerLifeIcon, ArtNem_SonicLifeIcon
                plreq   ArtTile_Monitors, ArtNem_Monitors
                plreq   ArtTile_Ring, ArtNem_RingHUDText
                plreq   ArtTile_StarPost, ArtNem_EnemyPtsStarPost
PLC_01_End:

PLC_02:         plrlistheader
                plreq   ArtTile_Explosion, ArtNem_Explosion
                plreq   ArtTile_Animals1, ArtNem_Squirrel
                plreq   ArtTile_Animals2, ArtNem_BlueFlicky
PLC_02_End:

PLC_03:         plrlistheader
                plreq   ArtTile_Shield, ArtNem_GameOver
PLC_03_End:

PLC_04:         plrlistheader
                plreq   ArtTile_S2Signpost, ArtNem_S2Signpost
PLC_04_End:

PLC_05:         plrlistheader
                plreq   ArtTile_SpikesSprings, ArtNem_SpikesSprings
PLC_05_End:

PLC_06:         plrlistheader
                plreq   ArtTile_2PArt_2, ArtNem_2PArt_2
                plreq   ArtTile_2PArt_1, ArtNem_2PArt_1
                plreq   ArtTile_2PArt_3, ArtNem_2PArt_3
PLC_06_End:

PLC_07:         plrlistheader
                plreq   ArtTile_PlayerLifeIcon, ArtNem_TailsLifeIcon
                plreq   ArtTile_Monitors, ArtNem_Monitors
                plreq   ArtTile_Ring, ArtNem_RingHUDText
                plreq   ArtTile_StarPost, ArtNem_EnemyPtsStarPost
PLC_07_End:

PLC_08:         plrlistheader
                plreq   ArtTile_Monitors, ArtNem_Monitors
PLC_08_End:

PLC_09:         plrlistheader
                plreq   ArtTile_SphereTest, ArtNem_SphereTest
PLC_09_End:

PLC_0A:         plrlistheader
                plreq   ArtTile_AIZIntroSprites, ArtNem_AIZIntroSprites
PLC_0A_End:

PLC_0B:         plrlistheader
                plreq   ArtTile_AIZSwingVine, ArtNem_AIZSwingVine
                plreq   ArtTile_AIZSlideRope, ArtNem_AIZSlideRope
                plreq   ArtTile_AIZMisc1, ArtNem_AIZMisc1
                plreq   ArtTile_AIZFallingLog, ArtNem_AIZFallingLog
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
                plreq   ArtTile_AIZFloatingPlatform, ArtNem_AIZCorkFloor
PLC_0B_End:

PLC_0C_0D:      plrlistheader
                plreq   ArtTile_AIZMisc2, ArtNem_AIZMisc2
                plreq   ArtTile_AIZSwingVine, ArtNem_AIZSwingVine
                plreq   ArtTile_AIZBackgroundTree, ArtNem_AIZBackgroundTree
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
                plreq   ArtTile_GrayButton, ArtNem_GrayButton
                plreq   ArtTile_AIZ2FloatingPlatform, ArtNem_AIZCorkFloor2
PLC_0C_0D_End:

PLC_0E:         plrlistheader
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
                plreq   ArtTile_HCZMisc, ArtNem_HCZMisc
                plreq   ArtTile_HCZButton, ArtNem_HCZButton
                plreq   ArtTile_HCZWaterRush, ArtNem_HCZWaterRush
                plreq   ArtTile_HCZWaveSplash, ArtNem_HCZWaveSplash
                plreq   ArtTile_HCZSpikeBall, ArtNem_HCZSpikeBall
PLC_0E_End:

PLC_0F:         plrlistheader
                plreq   ArtTile_Buggernaut, ArtNem_HCZDragonfly
PLC_0F_End:

PLC_10:         plrlistheader
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
                plreq   ArtTile_HCZMisc, ArtNem_HCZMisc
                plreq   ArtTile_HCZButton, ArtNem_HCZButton
                plreq   ArtTile_HCZWaveSplash, ArtNem_HCZWaveSplash
                plreq   ArtTile_HCZSpikeBall, ArtNem_HCZSpikeBall
                plreq   ArtTile_HCZ2Slide, ArtNem_HCZ2Slide
PLC_10_End:

PLC_11:         plrlistheader
                plreq   ArtTile_HCZ2KnuxWall, ArtNem_HCZ2KnuxWall
                plreq   ArtTile_HCZ2BlockPlat, ArtNem_HCZ2BlockPlat
                plreq   ArtTile_Buggernaut, ArtNem_HCZDragonfly
PLC_11_End:

PLC_12_13:      plrlistheader
                plreq   ArtTile_MGZMisc1, ArtNem_MGZMisc1
                plreq   ArtTile_MGZMisc2, ArtNem_MGZMisc2
                plreq   ArtTile_MGZSigns, ArtNem_MGZSigns
                plreq   ArtTile_MGZMHZDiagonalSpring, ArtNem_DiagonalSpring
PLC_12_13_End:

PLC_14_15:      plrlistheader
                plreq   ArtTile_MGZMisc1, ArtNem_MGZMisc1
                plreq   ArtTile_MGZMisc2, ArtNem_MGZMisc2
                plreq   ArtTile_MGZSigns, ArtNem_MGZSigns
                plreq   ArtTile_MGZMHZDiagonalSpring, ArtNem_DiagonalSpring
PLC_14_15_End:

PLC_16_17_18_19:    plrlistheader
                plreq   ArtTile_CNZMisc, ArtNem_CNZMisc
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
                plreq   ArtTile_CNZPlatform, ArtNem_CNZPlatform
PLC_16_17_18_19_End:

PLC_1A_1B_1C_1D:    plrlistheader
                plreq   ArtTile_DiagonalSpring, ArtNem_DiagonalSpring
PLC_1A_1B_1C_1D_End:

PLC_1E_1F:      plrlistheader
                plreq   ArtTile_SnowboardDust, ArtNem_SnowboardDust
                plreq   ArtTile_DiagonalSpring, ArtNem_DiagonalSpring
                plreq   ArtTile_GrayButton, ArtNem_GrayButton
                plreq   ArtTile_ICZMisc1, ArtNem_ICZMisc1
                plreq   ArtTile_ICZIntroSprites, ArtNem_ICZIntroSprites
PLC_1E_1F_End:

PLC_20_21:      plrlistheader
                plreq   ArtTile_DiagonalSpring, ArtNem_DiagonalSpring
                plreq   ArtTile_GrayButton, ArtNem_GrayButton
                plreq   ArtTile_ICZMisc1, ArtNem_ICZMisc1
                plreq   ArtTile_ICZMisc2, ArtNem_ICZMisc2
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
PLC_20_21_End:

PLC_22_23:      plrlistheader
                plreq   ArtTile_LBZMisc, ArtNem_LBZMisc
                plreq   ArtTile_LBZTubeTrans, ArtNem_LBZTubeTrans
PLC_22_23_End:

PLC_24:         plrlistheader
                plreq   ArtTile_LBZMisc, ArtNem_LBZMisc
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
PLC_24_End:

PLC_25:         plrlistheader
                plreq   ArtTile_LBZ2Misc, ArtNem_LBZ2Misc
PLC_25_End:

PLC_26_Through_2D:  plrlistheader
                plreq   ArtTile_DiagonalSpring, ArtNem_DiagonalSpring
                plreq   ArtTile_SpikesSprings, ArtNem_SpikesSprings
PLC_26_Through_2D_End:

PLC_2E_Through_41:  plrlistheader
                plreq   ArtTile_DiagonalSpring, ArtNem_DiagonalSpring
                plreq   ArtTile_SpikesSprings, ArtNem_SpikesSprings
PLC_2E_Through_41_End:

PLC_42:         plrlistheader
                plreq   ArtTile_DashDust, ArtNem_2PDashdust
                plreq   ArtTile_2PStartPost, ArtNem_2PStartPost
                plreq   ArtTile_2PLapNum, ArtNem_2PLapNum
                plreq   ArtTile_2PTime, ArtNem_2PTime
                plreq   ArtTile_2PPosIcon, ArtNem_2PPosIcon
                plreq   ArtTile_2PArt_2, ArtNem_2PArt_2
                plreq   ArtTile_2PArt_1, ArtNem_2PArt_1
                plreq   ArtTile_2PArt_3, ArtNem_2PArt_3
PLC_42_End:

PLC_43:         plrlistheader
                plreq   ArtTile_BPZMisc, ArtNem_BPZMisc
                plreq   ArtTile_DashDust, ArtNem_2PDashdust
                plreq   ArtTile_2PStartPost, ArtNem_2PStartPost
                plreq   ArtTile_2PLapNum, ArtNem_2PLapNum
                plreq   ArtTile_2PTime, ArtNem_2PTime
                plreq   ArtTile_2PPosIcon, ArtNem_2PPosIcon
                plreq   ArtTile_2PArt_2, ArtNem_2PArt_2
                plreq   ArtTile_2PArt_1, ArtNem_2PArt_1
                plreq   ArtTile_2PArt_3, ArtNem_2PArt_3
PLC_43_End:

PLC_44:         plrlistheader
                plreq   ArtTile_DPZMisc, ArtNem_DPZMisc
                plreq   ArtTile_DashDust, ArtNem_2PDashdust
                plreq   ArtTile_2PStartPost, ArtNem_2PStartPost
                plreq   ArtTile_2PLapNum, ArtNem_2PLapNum
                plreq   ArtTile_2PTime, ArtNem_2PTime
                plreq   ArtTile_2PPosIcon, ArtNem_2PPosIcon
                plreq   ArtTile_2PArt_2, ArtNem_2PArt_2
                plreq   ArtTile_2PArt_1, ArtNem_2PArt_1
                plreq   ArtTile_2PArt_3, ArtNem_2PArt_3
PLC_44_End:

PLC_45:         plrlistheader
                plreq   ArtTile_CGZMisc, ArtNem_CGZMisc
                plreq   ArtTile_DashDust, ArtNem_2PDashdust
                plreq   ArtTile_2PStartPost, ArtNem_2PStartPost
                plreq   ArtTile_2PLapNum, ArtNem_2PLapNum
                plreq   ArtTile_2PTime, ArtNem_2PTime
                plreq   ArtTile_2PPosIcon, ArtNem_2PPosIcon
                plreq   ArtTile_2PArt_2, ArtNem_2PArt_2
                plreq   ArtTile_2PArt_1, ArtNem_2PArt_1
                plreq   ArtTile_2PArt_3, ArtNem_2PArt_3
PLC_45_End:

PLC_46:         plrlistheader
                plreq   ArtTile_EMZMisc, ArtNem_EMZMisc
                plreq   ArtTile_DashDust, ArtNem_2PDashdust
                plreq   ArtTile_2PStartPost, ArtNem_2PStartPost
                plreq   ArtTile_2PLapNum, ArtNem_2PLapNum
                plreq   ArtTile_2PTime, ArtNem_2PTime
                plreq   ArtTile_2PPosIcon, ArtNem_2PPosIcon
                plreq   ArtTile_2PArt_2, ArtNem_2PArt_2
                plreq   ArtTile_2PArt_1, ArtNem_2PArt_1
                plreq   ArtTile_2PArt_3, ArtNem_2PArt_3
PLC_46_End:

PLC_47:         plrlistheader
                plreq   ArtTile_BonusStage, ArtNem_BonusStage
                plreq   ArtTile_SpikesSprings, ArtNem_SpikesSprings
PLC_47_End:

PLC_48_Through_5A:  plrlistheader
                plreq   ArtTile_AIZMiniboss, ArtNem_AIZMiniboss
                plreq   ArtTile_AIZMinibossSmall, ArtNem_AIZMinibossSmall
                plreq   ArtTile_AIZBossFire, ArtNem_AIZBossFire
                plreq   ArtTile_BossExplosion2, ArtNem_BossExplosion
PLC_48_Through_5A_End:

PLC_5B:         plrlistheader
                plreq   ArtTile_HCZMiniboss, ArtNem_HCZMiniboss
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_5B_End:

PLC_5C_5D:      plrlistheader
                plreq   ArtTile_CNZMiniboss, ArtNem_CNZMiniboss
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_5C_5D_End:

PLC_5E:         plrlistheader
                plreq   ArtTile_FBZMiniboss, ArtNem_FBZMiniboss
                plreq   ArtTile_EggCapsule-$46, ArtNem_EggCapsule
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
                plreq   ArtTile_FBZAnimals1, ArtNem_Squirrel
                plreq   ArtTile_FBZAnimals2, ArtNem_BlueFlicky
PLC_5E_End:

PLC_5F:         plrlistheader
                plreq   ArtTile_ICZMiniboss, ArtNem_ICZMiniboss
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_5F_End:

PLC_60:         plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_LBZKnuxBomb, ArtNem_LBZKnuxBomb
PLC_60_End:

PLC_61_Through_6A:  plrlistheader
                plreq   ArtTile_FBZ2Subboss, ArtNem_FBZ2Subboss
                plreq   ArtTile_FBZRobotnikStand, ArtNem_FBZRobotnikStand
                plreq   ArtTile_FBZRobotnikRun, ArtNem_FBZRobotnikRun
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_61_Through_6A_End:

PLC_6B:         plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_BossExplosion2, ArtNem_BossExplosion
PLC_6B_End:

PLC_6C:         plrlistheader
                plreq   ArtTile_HCZEndBoss, ArtNem_HCZEndBoss
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
                plreq   ArtTile_EggCapsule, ArtNem_EggCapsule
PLC_6C_End:

PLC_6D:         plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
                plreq   ArtTile_EggCapsule, ArtNem_EggCapsule
PLC_6D_End:

PLC_6E:         plrlistheader
                plreq   ArtTile_CNZEndBoss, ArtNem_CNZEndBoss
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
                plreq   ArtTile_EggCapsule, ArtNem_EggCapsule
PLC_6E_End:

PLC_6F:         plrlistheader
                plreq   ArtTile_FBZEndBoss-$20, ArtNem_FBZEndBoss
                plreq   ArtTile_FBZRobotnikHead-$20, ArtNem_FBZRobotnikHead
                plreq   ArtTile_FBZEndBossFlame+$4, ArtNem_FBZEndBossFlame
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
                plreq   ArtTile_EggCapsule, ArtNem_EggCapsule
PLC_6F_End:

PLC_70:         plrlistheader
                plreq   ArtTile_ICZEndBoss, ArtNem_ICZEndBoss
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
                plreq   ArtTile_EggCapsule, ArtNem_EggCapsule
PLC_70_End:

PLC_71:         plrlistheader
                plreq   ArtTile_LBZFinalBoss1, ArtNem_LBZFinalBoss1
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_71_End:

PLC_72_73_74_75_76_77:  plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_FBZRobotnikRun, ArtNem_FBZRobotnikRun
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_72_73_74_75_76_77_End:

PLC_78_79_7A_7B:    plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_78_79_7A_7B_End:
