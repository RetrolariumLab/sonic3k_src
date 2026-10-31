; Driver pointer arrays and checked private envelope and instrument resources
; Original driver statements retain their assembly order

                CPU     Z80
                listing purecode
; ===========================================================================
; Pointers
; ===========================================================================

z80_SoundDriverPointers:
                dw      z80_MusicPointers               ; This would be the priority array in other drivers
                dw      z80_UniVoiceBank                ; In other drivers, this is a pointer to special SFX table instead
                dw      z80_MusicPointers
                dw      z80_SFXPointers
                dw      z80_ModEnvPointers
                dw      z80_VolEnvPointers
                dw      mus__End                        ; This is the song limit; it is never used in any driver
; ---------------------------------------------------------------------------
; ===========================================================================
; Modulation Envelope Pointers
; ===========================================================================
; z80_FreqFlutterPointers
z80_ModEnvPointers:
                dw      ModEnv_00
                dw      ModEnv_01
                dw      ModEnv_02
                dw      ModEnv_03
                dw      ModEnv_04
                dw      ModEnv_05
                dw      ModEnv_06
                dw      ModEnv_07

ModEnv_01:
                binclude "data/Sound/Driver/Payloads/shared/modenv_01.bin"
ModEnv_00:
                binclude "data/Sound/Driver/Payloads/shared/modenv_00.bin"
ModEnv_02:
                binclude "data/Sound/Driver/Payloads/shared/modenv_02.bin"
ModEnv_03:
                binclude "data/Sound/Driver/Payloads/shared/modenv_03.bin"
ModEnv_04:
                binclude "data/Sound/Driver/Payloads/shared/modenv_04.bin"
ModEnv_05:
                binclude "data/Sound/Driver/Payloads/shared/modenv_05.bin"
ModEnv_06:
                binclude "data/Sound/Driver/Payloads/shared/modenv_06.bin"
ModEnv_07:
                binclude "data/Sound/Driver/Payloads/shared/modenv_07.bin"

; ---------------------------------------------------------------------------
; ===========================================================================
; Volume Envelope Pointers
; ===========================================================================
; z80_PSGTonePointers
z80_VolEnvPointers:
                dw      VolEnv_01,VolEnv_02,VolEnv_03,VolEnv_04,VolEnv_05,VolEnv_06
                dw      VolEnv_07,VolEnv_08,VolEnv_09,VolEnv_0A,VolEnv_0B,VolEnv_0C
                dw      VolEnv_0D,VolEnv_0E,VolEnv_0F,VolEnv_10,VolEnv_11,VolEnv_12
                dw      VolEnv_13,VolEnv_14,VolEnv_15,VolEnv_16,VolEnv_17,VolEnv_18
                dw      VolEnv_19,VolEnv_1A,VolEnv_1B,VolEnv_1C,VolEnv_1D,VolEnv_1E
                dw      VolEnv_1F,VolEnv_20,VolEnv_21,VolEnv_22,VolEnv_23,VolEnv_24
                dw      VolEnv_25,VolEnv_26,VolEnv_27

VolEnv_01:
                binclude "data/Sound/Driver/Payloads/shared/volenv_01.bin"
VolEnv_02:
                binclude "data/Sound/Driver/Payloads/shared/volenv_02.bin"
VolEnv_03:
                binclude "data/Sound/Driver/Payloads/shared/volenv_03.bin"
VolEnv_04:
                binclude "data/Sound/Driver/Payloads/shared/volenv_04.bin"
VolEnv_05:
                binclude "data/Sound/Driver/Payloads/shared/volenv_05.bin"
VolEnv_06:
                binclude "data/Sound/Driver/Payloads/shared/volenv_06.bin"
VolEnv_07:
                binclude "data/Sound/Driver/Payloads/shared/volenv_07.bin"
VolEnv_08:
                binclude "data/Sound/Driver/Payloads/shared/volenv_08.bin"
VolEnv_09:
                binclude "data/Sound/Driver/Payloads/shared/volenv_09.bin"
VolEnv_0A:
                binclude "data/Sound/Driver/Payloads/shared/volenv_0a.bin"
; The -10h in this FM volume envelope appears to be erroneous:
; negative volume attenuations aren't supported, and instead
; trigger the code intended for byte 82h
; This envelope appears in many SMPS Z80 Type 2 DAC drivers,
; suggesting it was some kind of poorly-thought-out example
; Oddly, this same envelope appears in Ristar (whose driver
; *does* support negative attenuations), despite SMPS 68k not
; supporting FM volume envelopes
VolEnv_0B:
                binclude "data/Sound/Driver/Payloads/shared/volenv_0b.bin"
VolEnv_0C:
                binclude "data/Sound/Driver/Payloads/shared/volenv_0c.bin"
VolEnv_0D:
                binclude "data/Sound/Driver/Payloads/shared/volenv_0d.bin"
VolEnv_0E:
                binclude "data/Sound/Driver/Payloads/shared/volenv_0e.bin"
VolEnv_0F:
                binclude "data/Sound/Driver/Payloads/shared/volenv_0f.bin"
VolEnv_10:
                binclude "data/Sound/Driver/Payloads/shared/volenv_10.bin"
VolEnv_11:
                binclude "data/Sound/Driver/Payloads/shared/volenv_11.bin"
VolEnv_12:
                binclude "data/Sound/Driver/Payloads/shared/volenv_12.bin"
VolEnv_13:
                binclude "data/Sound/Driver/Payloads/shared/volenv_13.bin"
VolEnv_14:
                binclude "data/Sound/Driver/Payloads/shared/volenv_14.bin"
VolEnv_15:
                binclude "data/Sound/Driver/Payloads/shared/volenv_15.bin"
VolEnv_16:
                binclude "data/Sound/Driver/Payloads/shared/volenv_16.bin"
VolEnv_17:
                binclude "data/Sound/Driver/Payloads/shared/volenv_17.bin"
VolEnv_18:
                binclude "data/Sound/Driver/Payloads/shared/volenv_18.bin"
VolEnv_19:
                binclude "data/Sound/Driver/Payloads/shared/volenv_19.bin"
VolEnv_1A:
                binclude "data/Sound/Driver/Payloads/shared/volenv_1a.bin"
VolEnv_1B:
                binclude "data/Sound/Driver/Payloads/shared/volenv_1b.bin"
VolEnv_1C:
                binclude "data/Sound/Driver/Payloads/shared/volenv_1c.bin"
VolEnv_1D:
                binclude "data/Sound/Driver/Payloads/shared/volenv_1d.bin"
VolEnv_1E:
                binclude "data/Sound/Driver/Payloads/shared/volenv_1e.bin"
VolEnv_1F:
                binclude "data/Sound/Driver/Payloads/shared/volenv_1f.bin"
VolEnv_20:
                binclude "data/Sound/Driver/Payloads/shared/volenv_20.bin"
VolEnv_21:
                binclude "data/Sound/Driver/Payloads/shared/volenv_21.bin"
VolEnv_22:
                binclude "data/Sound/Driver/Payloads/shared/volenv_22.bin"
VolEnv_23:
                binclude "data/Sound/Driver/Payloads/shared/volenv_23.bin"
VolEnv_24:
                binclude "data/Sound/Driver/Payloads/shared/volenv_24.bin"
VolEnv_25:
                binclude "data/Sound/Driver/Payloads/shared/volenv_25.bin"
VolEnv_26:
                if      SonicDriverVer==3
                binclude "data/Sound/Driver/Payloads/s3/volenv_26.bin"
                else
                binclude "data/Sound/Driver/Payloads/sk/volenv_26.bin"
                endif
VolEnv_27:
                binclude "data/Sound/Driver/Payloads/shared/volenv_27.bin"

; ---------------------------------------------------------------------------
; ===========================================================================
; Music Pointers
; ===========================================================================

zmake68kPtrs    macro
                    irp     op,ALLARGS
                    dw      zmake68kPtr(op)
                endm
                endm

z80_MusicPointers:
                zmake68kPtrs Snd_AIZ1, Snd_AIZ2, Snd_HCZ1, Snd_HCZ2
                zmake68kPtrs Snd_MGZ1, Snd_MGZ2, Snd_CNZ1, Snd_CNZ2
                zmake68kPtrs Snd_FBZ1, Snd_FBZ2, Snd_ICZ1, Snd_ICZ2
                zmake68kPtrs Snd_LBZ1, Snd_LBZ2, Snd_MHZ1, Snd_MHZ2

                zmake68kPtrs Snd_SOZ1, Snd_SOZ2, Snd_LRZ1, Snd_LRZ2
                zmake68kPtrs Snd_SSZ, Snd_DEZ1, Snd_DEZ2, Snd_Minib_SK
                zmake68kPtrs Snd_Boss, Snd_DDZ, Snd_PachBonus, Snd_SpecialS
                zmake68kPtrs Snd_SlotBonus, Snd_GumBonus, Snd_Knux, Snd_ALZ

                zmake68kPtrs Snd_BPZ, Snd_DPZ, Snd_CGZ, Snd_EMZ
                zmake68kPtrs Snd_Title, Snd_S3Credits, Snd_GameOver, Snd_Continue
                zmake68kPtrs Snd_Results, Snd_1UP, Snd_Emerald, Snd_Invic
                zmake68kPtrs Snd_2PMenu
                if      SonicDriverVer==3
                zmake68kPtrs Snd_Minib
                else
                zmake68kPtrs Snd_Minib_SK
                endif
                zmake68kPtrs Snd_Menu, Snd_FinalBoss, Snd_Drown, Snd_PresSega
                if      SonicDriverVer<>3
                zmake68kPtrs Snd_SKCredits
                endif
; ---------------------------------------------------------------------------
; ===========================================================================
; SFX Pointers
; ===========================================================================

z80_SFXPointers:
                zmake68kPtrs Sound_33, Sound_34, Sound_35, Sound_36
                zmake68kPtrs Sound_37, Sound_38, Sound_39, Sound_3A
                zmake68kPtrs Sound_3B, Sound_3C, Sound_3D, Sound_3E
                zmake68kPtrs Sound_3F

                zmake68kPtrs Sound_40, Sound_41, Sound_42, Sound_43
                zmake68kPtrs Sound_44, Sound_45, Sound_46, Sound_47
                zmake68kPtrs Sound_48, Sound_49, Sound_4A, Sound_4B
                zmake68kPtrs Sound_4C, Sound_4D, Sound_4E, Sound_4F

                zmake68kPtrs Sound_50, Sound_51, Sound_52, Sound_53
                zmake68kPtrs Sound_54, Sound_55, Sound_56, Sound_57
                zmake68kPtrs Sound_58, Sound_59, Sound_5A, Sound_5B
                zmake68kPtrs Sound_5C, Sound_5D, Sound_5E, Sound_5F

                zmake68kPtrs Sound_60, Sound_61, Sound_62, Sound_63
                zmake68kPtrs Sound_64, Sound_65, Sound_66, Sound_67
                zmake68kPtrs Sound_68, Sound_69, Sound_6A, Sound_6B
                zmake68kPtrs Sound_6C, Sound_6D, Sound_6E, Sound_6F

                zmake68kPtrs Sound_70, Sound_71, Sound_72, Sound_73
                zmake68kPtrs Sound_74, Sound_75, Sound_76, Sound_77
                zmake68kPtrs Sound_78, Sound_79, Sound_7A, Sound_7B
                zmake68kPtrs Sound_7C, Sound_7D, Sound_7E, Sound_7F

                zmake68kPtrs Sound_80, Sound_81, Sound_82, Sound_83
                zmake68kPtrs Sound_84, Sound_85, Sound_86, Sound_87
                zmake68kPtrs Sound_88, Sound_89, Sound_8A, Sound_8B
                zmake68kPtrs Sound_8C, Sound_8D, Sound_8E, Sound_8F

                zmake68kPtrs Sound_90, Sound_91, Sound_92, Sound_93
                zmake68kPtrs Sound_94, Sound_95, Sound_96, Sound_97
                zmake68kPtrs Sound_98, Sound_99, Sound_9A, Sound_9B
                zmake68kPtrs Sound_9C, Sound_9D, Sound_9E, Sound_9F

                zmake68kPtrs Sound_A0, Sound_A1, Sound_A2, Sound_A3
                zmake68kPtrs Sound_A4, Sound_A5, Sound_A6, Sound_A7
                zmake68kPtrs Sound_A8, Sound_A9, Sound_AA, Sound_AB
                zmake68kPtrs Sound_AC, Sound_AD, Sound_AE, Sound_AF

                zmake68kPtrs Sound_B0, Sound_B1, Sound_B2, Sound_B3
                zmake68kPtrs Sound_B4, Sound_B5, Sound_B6, Sound_B7
                zmake68kPtrs Sound_B8, Sound_B9, Sound_BA, Sound_BB
                zmake68kPtrs Sound_BC, Sound_BD, Sound_BE, Sound_BF

                zmake68kPtrs Sound_C0, Sound_C1, Sound_C2, Sound_C3
                zmake68kPtrs Sound_C4, Sound_C5, Sound_C6, Sound_C7
                zmake68kPtrs Sound_C8, Sound_C9, Sound_CA, Sound_CB
                zmake68kPtrs Sound_CC, Sound_CD, Sound_CE, Sound_CF

                zmake68kPtrs Sound_D0, Sound_D1, Sound_D2, Sound_D3
                zmake68kPtrs Sound_D4, Sound_D5, Sound_D6, Sound_D7
                zmake68kPtrs Sound_D8, Sound_D9, Sound_DA, Sound_DB
                zmake68kPtrs Sound_DB, Sound_DB, Sound_DB, Sound_DB
; ---------------------------------------------------------------------------
; ===========================================================================
; FM Universal Voice Bank
; ===========================================================================

z80_UniVoiceBank:
                binclude "data/Sound/Driver/Payloads/shared/z80_univoicebank.bin"
                if      $ > zDataStart
                fatal   "Your Z80 tables won't fit before its variables. It's \{$-zDataStart}h bytes past the start of the variables, at \{zDataStart}h"
                endif

; ---------------------------------------------------------------------------
; ===========================================================================
; END OF SOUND DRIVER
