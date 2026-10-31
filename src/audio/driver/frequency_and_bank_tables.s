; PSG and FM frequency conversion tables and music bank identifiers
; Original driver statements retain their assembly order

                CPU     Z80
                listing purecode
zMakePSGFrequency:  function frequency,min(3FFh,roundFloatToInteger(PSG_Sample_Rate/(frequency*2)))
zMakePSGFrequencies macro
                    irp     op,ALLARGS
                    dw      zMakePSGFrequency(op)
                endm
                endm

; loc_AA5
zPSGFrequencies:
; 7 octaves, each one begins with C and ends with B
; This table differs from the one in Sonic 1 and 2's drivers by
; having an extra octave at the start and two extra notes at
; the end, allowing it to span 7 octaves
; The first octave contains duplicate frequencies due to the
; PSG's frequency counter being limited to 3FFh
; The last octave's final two notes are set to the PSG's maximum
; frequency. These are typically used by the noise channel to
; create a sound that is similar to a hi-hat
                zMakePSGFrequencies 109.34,    109.34,    109.34,    109.34,    109.34,    109.34,    109.34,    109.34,    109.34,    110.20,    116.76,    123.73
                zMakePSGFrequencies 130.98,    138.78,    146.99,    155.79,    165.22,    174.78,    185.19,    196.24,    207.91,    220.63,    233.52,    247.47
                zMakePSGFrequencies 261.96,    277.56,    293.59,    311.58,    329.97,    349.56,    370.39,    392.49,    415.83,    440.39,    468.03,    494.95
                zMakePSGFrequencies 522.71,    556.51,    588.73,    621.44,    661.89,    699.12,    740.79,    782.24,    828.59,    880.79,    932.17,    989.91
                zMakePSGFrequencies 1045.42,   1107.52,   1177.47,   1242.89,   1316.00,   1398.25,   1491.47,   1575.50,   1669.55,   1747.82,   1864.34,   1962.46
                zMakePSGFrequencies 2071.49,   2193.34,   2330.42,   2485.78,   2601.40,   2796.51,   2943.69,   3107.23,   3290.01,   3495.64,   3608.40,   3857.25
                zMakePSGFrequencies 4142.98,   4302.32,   4660.85,   4863.50,   5084.56,   5326.69,   5887.39,   6214.47,   6580.02,   6991.28, 223721.56, 223721.56
; ---------------------------------------------------------------------------
zMakeFMFrequency:   function frequency,roundFloatToInteger(frequency*1024*1024*2/FM_Sample_Rate)
zMakeFMFrequencies  macro
                    irp     op,ALLARGS
                    dw      zMakeFMFrequency(op)
                endm
                endm

; loc_B4D
zFMFrequencies:
; This table spans only a single octave, as the octave frequency
; is calculated at run-time unlike in Sonic 1 and 2's drivers
; The first frequency is C, the last frequency is B
                zMakeFMFrequencies 16.35, 17.34, 18.36, 19.45, 20.64, 21.84, 23.13, 24.51, 25.98, 27.53, 29.15, 30.88
; ---------------------------------------------------------------------------
; ===========================================================================
; MUSIC BANKS
; ===========================================================================

zmakeSongBanks  macro
                    irp     op,ALLARGS
                    db      zmakeSongBank(op)
                endm
                endm

z80_MusicBanks:
                zmakeSongBanks Snd_AIZ1, Snd_AIZ2, Snd_HCZ1, Snd_HCZ2
                zmakeSongBanks Snd_MGZ1, Snd_MGZ2, Snd_CNZ1, Snd_CNZ2
                zmakeSongBanks Snd_FBZ1, Snd_FBZ2, Snd_ICZ1, Snd_ICZ2
                zmakeSongBanks Snd_LBZ1, Snd_LBZ2, Snd_MHZ1, Snd_MHZ2

                zmakeSongBanks Snd_SOZ1, Snd_SOZ2, Snd_LRZ1, Snd_LRZ2
                zmakeSongBanks Snd_SSZ, Snd_DEZ1, Snd_DEZ2, Snd_Minib_SK
                zmakeSongBanks Snd_Boss, Snd_DDZ, Snd_PachBonus, Snd_SpecialS
                zmakeSongBanks Snd_SlotBonus, Snd_GumBonus, Snd_Knux, Snd_ALZ

                zmakeSongBanks Snd_BPZ, Snd_DPZ, Snd_CGZ, Snd_EMZ
                zmakeSongBanks Snd_Title, Snd_S3Credits, Snd_GameOver, Snd_Continue
                zmakeSongBanks Snd_Results, Snd_1UP, Snd_Emerald, Snd_Invic
                zmakeSongBanks Snd_2PMenu
                if      SonicDriverVer==3
                zmakeSongBanks Snd_Minib
                else
                zmakeSongBanks Snd_Minib_SK
                endif
                zmakeSongBanks Snd_Menu, Snd_FinalBoss, Snd_Drown, Snd_PresSega
                if      SonicDriverVer<>3
                zmakeSongBanks Snd_SKCredits
                endif

; =============== S U B R O U T I N E =======================================
;
; sub_B98
