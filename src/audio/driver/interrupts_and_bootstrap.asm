; Restart vectors, vertical interrupt, startup, YM register I/O and DAC bank table
; Original driver statements retain their assembly order

                CPU     Z80
                listing purecode
; ===========================================================================

; EntryPoint:
                di                                      ; Disable interrupts
                di                                      ; Disable interrupts
                im      1                               ; set interrupt mode 1
                jp      zInitAudioDriver
; ---------------------------------------------------------------------------
                if      SonicDriverVer<>3
                db      0F2h                            ; Filler; broken jp p,loc?
                endif

; =============== S U B R O U T I N E =======================================
;
; Gets the correct pointer to pointer table for the data type in question
; (music, sfx, voices, etc.)
;
; Input:  c    ID for data type
; Output: hl   Master pointer table for index
; af'  Trashed
; b    Trashed

; sub_8
                align   8
GetPointerTable:    rsttarget
                ld      hl, (ptrMasterIndex)            ; Read pointer to (pointer to pointer table) table
                ld      b, 0                            ; b = 0
                add     hl, bc                          ; Add offset into pointer table
                ex      af, af'                         ; Back up af
                ld      a, (hl)                         ; Read low byte of pointer into a
                inc     hl
                ld      h, (hl)                         ; Read high byte of pointer into h
                ld      l, a                            ; Put low byte of pointer into l
                ex      af, af'                         ; Restore af
                ret
; End of function GetPointerTable

; ---------------------------------------------------------------------------
; word_15
ptrMasterIndex:
                dw      z80_SoundDriverPointers

; =============== S U B R O U T I N E =======================================
;
; Reads an offset into a pointer table and returns dereferenced pointer
;
;
; Input:  a    Index into pointer table
; hl   Pointer to pointer table
; Output: hl   Selected pointer in pointer table
; bc   Trashed

; sub_18
                align   8
PointerTableOffset: rsttarget
                ld      c, a                            ; c = index into pointer table
                ld      b, 0                            ; b = 0
                add     hl, bc                          ; hl += bc
                add     hl, bc                          ; hl += bc
                nop                                     ; 12 clock cycles, 3 bytes
                nop
                nop
; End of function PointerTableOffset

; =============== S U B R O U T I N E =======================================
;
; Dereferences a pointer
;
; Input:  hl Pointer
; output: hl Equal to what that was being pointed to by hl

; loc_20
                align   8
ReadPointer:    rsttarget
                ld      a, (hl)                         ; Read low byte of pointer into a
                inc     hl
                ld      h, (hl)                         ; Read high byte of pointer into h
                ld      l, a                            ; Put low byte of pointer into l
                ret
; End of function PointerTableOffset

; ---------------------------------------------------------------------------
; There is room for two more 'rsttarget's here
; ---------------------------------------------------------------------------
                align   38h
; =============== S U B R O U T I N E =======================================
;
; This subroutine is called every V-Int. After it is processed, the z80
; returns to the digital audio loop to continue playing DAC samples
;
; If the SEGA PCM is being played, it disables interrupts -- this means that
; this procedure will NOT be called while the SEGA PCM is playing
;
; zsub_38
zVInt:          rsttarget
                di                                      ; Disable interrupts
                push    af                              ; Save af
                push    iy                              ; Save iy
                exx                                     ; Save bc,de,hl

                .doupdate:
                ld      a, r                            ; Get memory refresh register
                ld      (zRefreshRegSnapshot), a        ; Save it
                call    zUpdateEverything               ; Update all tracks
                ld      a, (zPalFlag)                   ; Get PAL flag
                or      a                               ; Is it set?
                jr      z, .not_pal                     ; Branch if not (NTSC)
                ld      a, (zPalDblUpdCounter)          ; Get PAL double-update timeout counter
                or      a                               ; Is it zero?
                jr      nz, .pal_timer                  ; Branch if not
                if      SonicDriverVer==3
; This is wrong, making music too slow on PAL consoles
                ld      a, 6                            ; Set it back to 6
                else
                ld      a, 5                            ; Set it back to 5
                endif
                ld      (zPalDblUpdCounter), a          ; ... and save it
                jp      .doupdate                       ; Go again

                .pal_timer:
                dec     a                               ; Decrease PAL double-update timeout counter
                ld      (zPalDblUpdCounter), a          ; Store it

                .not_pal:
                if      SonicDriverVer==3
; Clear this write-only byte after track updates in both PAL and NTSC
                xor     a
                ld      (zV3UpdateClearByte), a
                endif

                ld      a, (zDACIndex)                  ; Get index of playing DAC sample
                and     7Fh                             ; Strip 'DAC playing' bit
                ld      c, a                            ; c = a
                ld      b, 0                            ; Sign extend c to bc
                ld      hl, DAC_Banks                   ; Make hl point to DAC bank table
                add     hl, bc                          ; Offset into entry for current sample
                ld      a, (hl)                         ; Get bank index
                bankswitch1                             ; Switch to current DAC sample's bank
                exx                                     ; Restore bc,de,hl
                pop     iy                              ; Restore iy
                pop     af                              ; Restore af
                ld      b, 1                            ; b = 1
                ret
; ---------------------------------------------------------------------------
; loc_85
zInitAudioDriver:
                ld      sp, z80_stack                   ; set the stack pointer to 0x2000 (end of z80 RAM)
    ; The following instruction block keeps the z80 in a tight loop
                ld      c, 0                            ; c = 0

                .loop:
                ld      b, 0                            ; b = 0
                djnz    $                               ; Loop in this instruction, decrementing b each iteration, until b = 0
                dec     c                               ; c--
                jr      z, .loop                        ; Loop if c = 0

                call    zStopAllSound                   ; Stop all music
                if      SonicDriverVer==3
; Nonsensical junk values
                ld      a, 80h
                ld      a, zmakeSongBank(0B0000h)       ; Leftover set song bank to first music bank from the Nov 3rd 1993 Prototype
                else
                ld      a, zmakeSongBank(Snd_Bank2_Start)  ; Set song bank to second music bank (default value)
                endif
                ld      (zSongBank), a                  ; Store it
                xor     a                               ; a = 0
                ld      (zSpindashRev), a               ; Reset spindash rev
                ld      (zDACIndex), a                  ; Clear current DAC sample index
                ld      (PlaySegaPCMFlag), a            ; Clear the Sega sound flag
                ld      (zRingSpeaker), a               ; Make rings play on left speaker
                ld      a, 5                            ; Set PAL double-update counter to 5
                ld      (zPalDblUpdCounter), a          ; (that is, do not double-update for 5 frames)
                ei                                      ; Enable interrupts
                jp      zPlayDigitalAudio               ; Start digital audio loop

; =============== S U B R O U T I N E =======================================
;
; Writes a reg/data pair to part I or II
;
; Input:  a    Value for register
; c    Value for data
; ix   Pointer to track RAM

; sub_AF
zWriteFMIorII:
                bit     7, (ix+zTrack.VoiceControl)     ; Is this a PSG track?
                ret     nz                              ; Is so, quit
                bit     2, (ix+zTrack.PlaybackControl)  ; Is SFX overriding this track?
                ret     nz                              ; Return if yes
                add     a, (ix+zTrack.VoiceControl)     ; Add the channel bits to the register address
                bit     2, (ix+zTrack.VoiceControl)     ; Is this the DAC channel or FM4 or FM5 or FM6?
                jr      nz, zWriteFMII_reduced          ; If yes, write reg/data pair to part II;
        ; otherwise, write reg/data pair as is to part I
; End of function zWriteFMIorII

; =============== S U B R O U T I N E =======================================
;
; Writes a reg/data pair to part I
;
; Input:  a    Value for register
; c    Value for data

; sub_C2
zWriteFMI:
                ld      (zYM2612_A0), a                 ; Select YM2612 register
; Pointless, since there's no need to delay between writing to the address port and the data port
                nop                                     ; Wait
                ld      a, c                            ; a = data to send
                ld      (zYM2612_D0), a                 ; Send data to register
                ret
; End of function zWriteFMI
; ---------------------------------------------------------------------------

; loc_CB
zWriteFMII_reduced:
                sub     4                               ; Strip 'bound to part II regs' bit
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================
;
; Writes a reg/data pair to part II
;
; Input:  a    Value for register
; c    Value for data

; sub_CD
zWriteFMII:
                ld      (zYM2612_A1), a                 ; Select YM2612 register
; Pointless, since there's no need to delay between writing to the address port and the data port
                nop                                     ; Wait
                ld      a, c                            ; a = data to send
                ld      (zYM2612_D1), a                 ; Send data to register
                ret
; End of function zWriteFMII

; ---------------------------------------------------------------------------
; ===========================================================================
; DAC BANKS
; ===========================================================================
zmake68kBanks   macro
                    irp     op,ALLARGS
                    db      zmake68kBank(op)
                endm
                endm
; Note: this table has a dummy first entry for the case when there is no DAC
; sample being played -- the code still results in a valid bank switch, and
; does not need to worry about special cases
DAC_Banks:
                zmake68kBanks DacBank1               , DAC_81_Data            , DAC_82_83_84_85_Data   , DAC_82_83_84_85_Data
                zmake68kBanks DAC_82_83_84_85_Data   , DAC_82_83_84_85_Data   , DAC_86_Data            , DAC_87_Data
                zmake68kBanks DAC_88_Data            , DAC_89_Data            , DAC_8A_8B_Data         , DAC_8A_8B_Data
                zmake68kBanks DAC_8C_Data            , DAC_8D_8E_Data         , DAC_8D_8E_Data         , DAC_8F_Data
                zmake68kBanks DAC_90_91_92_93_Data   , DAC_90_91_92_93_Data   , DAC_90_91_92_93_Data   , DAC_90_91_92_93_Data
                zmake68kBanks DAC_94_95_96_97_Data   , DAC_94_95_96_97_Data   , DAC_94_95_96_97_Data   , DAC_94_95_96_97_Data
                zmake68kBanks DAC_98_99_9A_Data      , DAC_98_99_9A_Data      , DAC_98_99_9A_Data      , DAC_9B_Data
                zmake68kBanks DAC_9C_Data            , DAC_9D_Data            , DAC_9E_Data            , DAC_9F_Data
                zmake68kBanks DAC_A0_Data            , DAC_A1_Data            , DAC_A2_Data            , DAC_A3_Data
                zmake68kBanks DAC_A4_Data            , DAC_A5_Data            , DAC_A6_Data            , DAC_A7_Data
                zmake68kBanks DAC_A8_Data            , DAC_A9_Data            , DAC_AA_Data            , DAC_AB_Data
                zmake68kBanks DAC_AC_Data            , DAC_AD_AE_Data         , DAC_AD_AE_Data         , DAC_AF_B0_Data
                zmake68kBanks DAC_AF_B0_Data         , DAC_B1_Data            , DAC_B2_B3_Data         , DAC_B2_B3_Data
                zmake68kBanks DAC_B4_C1_C2_C3_C4_Data, DAC_B5_Data            , DAC_B6_Data            , DAC_B7_Data
                zmake68kBanks DAC_B8_B9_Data         , DAC_B8_B9_Data         , DAC_BA_Data            , DAC_BB_Data
                zmake68kBanks DAC_BC_Data            , DAC_BD_Data            , DAC_BE_Data            , DAC_BF_Data
                zmake68kBanks DAC_C0_Data            , DAC_B4_C1_C2_C3_C4_Data, DAC_B4_C1_C2_C3_C4_Data, DAC_B4_C1_C2_C3_C4_Data
                zmake68kBanks DAC_B4_C1_C2_C3_C4_Data

; =============== S U B R O U T I N E =======================================
;
; sub_11B
