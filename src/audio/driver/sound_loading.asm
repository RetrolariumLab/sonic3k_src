; Sound queue dispatch, music and effect loading and track initialization
; Original driver statements retain their assembly order

                CPU     Z80
                listing purecode
zCycleSoundQueue:
                ld      a, (zSoundQueue0)               ; Get first item in sound queue
                ld      (zNextSound), a                 ; Save into next sound variable
                ld      a, (zSoundQueue1)               ; Get second item in queue
                ld      (zSoundQueue0), a               ; Move to first spot
                ld      a, (zSoundQueue2)               ; Get third item in queue
                ld      (zSoundQueue1), a               ; Move to second spot
                xor     a                               ; a = 0
                ld      (zSoundQueue2), a               ; Clear third spot in queue
                ld      a, (zNextSound)                 ; a = next sound to play
; End of function zCycleSoundQueue

; ===========================================================================
; Type Check
; ===========================================================================
; 1-32, DC = Music
; 33-DB, DD-DF = SFX
; E1-E6 = Fade Effects
; FF = SEGA Scream

; TypeCheck:
; sub_4FB
zPlaySoundByIndex:
                if      SonicDriverVer<>3
                cp      mus_CreditsK                    ; Is this the credits music?
                jp      z, zPlayMusicCredits            ; Branch if yes
                endif
                cp      cmd_SEGA                        ; Is this the SEGA sound?
                jp      z, zPlaySegaSound               ; Branch if yes
                cp      mus__End                        ; Is this a music?
                jp      c, zPlayMusic                   ; Branch if yes
                cp      sfx__End                        ; Is this a sound effect?
                jp      c, zPlaySound_CheckRing         ; Branch if yes
                cp      cmd__First                      ; Is it before the first fade effect?
                jp      c, zStopAllSound                ; Branch if yes
                cp      cmd__End                        ; Is this after the last fade effect?
                jp      nc, zStopAllSound               ; Branch if yes
                sub     cmd__First                      ; If none of the checks passed, do fade effects
                ld      hl, zFadeEffects                ; hl = switch table pointer
                rst     PointerTableOffset              ; Get address of function that handles the fade effect
                xor     a                               ; Set a = 0
                ld      (zDriverRetained_FadeAndSfxCleanupWriteOnlyLatch), a  ; Set otherwise unused value to zero
                jp      (hl)                            ; Handle fade effect
; End of function zPlaySoundByIndex
; ---------------------------------------------------------------------------
; loc_524
zFadeEffects:
                dw      zFadeOutMusic                   ; E1h
                dw      zStopAllSound                   ; E2h
                dw      zPSGSilenceAll                  ; E3h
                dw      zStopSFX                        ; E4h
                dw      zFadeOutMusic                   ; E5h
; ---------------------------------------------------------------------------
; sub_52E
zStopSFX:
                ld      ix, zTracksSFXStart             ; ix = pointer to SFX track memory
                ld      b, (zTracksSFXEnd-zTracksSFXStart)/zTrack.len  ; Number of channels
                ld      a, 1                            ; a = 1
                ld      (zUpdatingSFX), a               ; Set flag to update SFX

                .loop:
                push    bc                              ; Save bc
                bit     7, (ix+zTrack.PlaybackControl)  ; Is track playing?
                call    nz, zSilenceStopTrack           ; Branch if yes
                ld      de, zTrack.len                  ; Spacing between tracks
                add     ix, de                          ; ix = pointer to next track
                pop     bc                              ; Restore bc
                djnz    .loop                           ; Loop for each track
                call    zClearNextSound
                ret

; =============== S U B R O U T I N E =======================================
; Writes hl to stack twice and stops track, silencing it. The two hl pushes
; will be counteracted by cfSilenceStopTrack
;
; sub_54D
zSilenceStopTrack:
                push    hl                              ; Save hl
                push    hl                              ; ... twice
                jp      cfSilenceStopTrack              ; Silence FM channel and stop track
; End of function zSilenceStopTrack
; ---------------------------------------------------------------------------
                if      SonicDriverVer<>3
; loc_552
zPlayMusicCredits:
                ld      a, 32h                          ; Credits music is the last entry on the music table
                push    af                              ; Save af
                jp      zPlayMusic_DoFade               ; Continue as music
                endif
; ---------------------------------------------------------------------------

; loc_558
zPlayMusic:
                sub     mus__First                      ; Remap index from 1h-32h to 0h-31h (see also credits music, above)
                ret     m                               ; Return if negative (id = 0)
                push    af                              ; Save af
                cp      mus_ExtraLife-mus__First        ; Is it the 1-up music?
                jp      nz, zPlayMusic_DoFade           ; Branch if not
                ld      a, (zFadeInTimeout)             ; Fading timeout
                or      a                               ; Is music being faded?
                jp      z, .no_fade                     ; Branch if not
                xor     a                               ; a = 0
                ld      (zMusicNumber), a               ; Clear M68K input queue
                ld      (zSFXNumber0), a                ; ... including SFX slot 0
                ld      (zSFXNumber1), a                ; ... and SFX slot 1
                ld      (zSoundQueue0), a               ; Also clear music queue entry 0
                ld      (zSoundQueue1), a               ; ... and entry 1
                ld      (zSoundQueue2), a               ; ... and entry 2
                ld      (zNextSound), a                 ; Clear currently selected song to play
                pop     af                              ; Restore af
                ret
; ---------------------------------------------------------------------------
                .no_fade:
                ld      a, (zFadeToPrevFlag)            ; Get fade-to-prev flag
                cp      mus_ExtraLife-mus__First        ; Was it triggered by the 1-up song?
                jp      z, zBGMLoad                     ; Branch if yes
                xor     a                               ; a = 0
                ld      (zMusicNumber), a               ; Clear M68K input queue
                ld      (zSFXNumber0), a                ; ... including SFX slot 0
                ld      (zSFXNumber1), a                ; ... and SFX slot 1
                ld      (zSoundQueue0), a               ; Also clear music queue entry 0
                ld      (zSoundQueue1), a               ; ... and entry 1
                ld      (zSoundQueue2), a               ; ... and entry 2
                ld      a, (zSongBank)                  ; Get song bank for extant track
                ld      (zSongBankSave), a              ; ... and save it
                ld      a, (zTempoSpeedup)              ; Get current tempo speed-up value
                ld      (zTempoSpeedupSave), a          ; ... and save it
                xor     a                               ; a = 0
                ld      (zTempoSpeedup), a              ; 1-Up should play on normal speed
                ld      hl, zTracksStart                ; hl = pointer to song RAM
                ld      de, zTracksSaveStart            ; de = pointer to RAM area to save the song data to
                ld      bc, zTracksSaveEnd-zTracksSaveStart  ; Number of bytes to copy
                ldir                                    ; while (bc-- > 0) *de++ = *hl++;
                ld      hl, zTracksSaveStart            ; hl = pointer to saved song's RAM area
                ld      de, zTrack.len                  ; Spacing between tracks
                ld      b, (zTracksSaveEnd-zTracksSaveStart)/zTrack.len  ; Number of tracks

                .loop:
                ld      a, (hl)                         ; Get playback control byte for song
                and     7Fh                             ; Strip the 'playing' bit
                set     2, (hl)                         ; Set bit 2 (SFX overriding)
                ld      (hl), a                         ; But then overwrite the whole thing
                add     hl, de                          ; Advance to next track
                djnz    .loop                           ; Loop for all tracks

                ld      a, mus_ExtraLife-mus__First     ; a = 1-up id-1
                ld      (zFadeToPrevFlag), a            ; Set fade-to-prev flag to it
                ld      a, (zCurrentTempo)              ; Get current tempo
                ld      (zCurrentTempoSave), a          ; Save it
                ld      hl, (zVoiceTblPtr)              ; Get voice table pointer
                ld      (zVoiceTblPtrSave), hl          ; Save it
                jp      zBGMLoad
; ---------------------------------------------------------------------------

zPlayMusic_DoFade:
                call    zStopAllSound                   ; Stop all music

; loc_5DE
zBGMLoad:
                pop     af                              ; Restore af
                push    af                              ; Then save it back again
                ld      hl, z80_MusicBanks              ; hl = table of music banks
; The following block adds the music index to the table address as a 16-bit offset
                add     a, l                            ; a += l
                ld      l, a                            ; l = low byte of offset into music entry
                adc     a, h                            ; a += h, plus 1 if a + l overflowed the 8-bit register
                sub     l                               ; Now, a = high byte of offset into music entry
                ld      h, a                            ; hl is the offset to the music bank
                ld      (zMusicLoad_ReadBankThroughPatchedAbsoluteOperand+1), hl  ; Store into next instruction (self-modifying code)
; The preceding write patches this instruction's 16-bit bank-table operand
zMusicLoad_ReadBankThroughPatchedAbsoluteOperand:
                ld      a, (z80_MusicBanks)             ; self-modified code; a is set to correct bank for the song to play
                ld      (zSongBank), a                  ; Save the song's bank
                if      SonicDriverVer==3
                ld      hl, zBankRegister
                bankswitchToMusicS3
                else
                bankswitch2                             ; ... then bank switch to it
                endif
                ld      a, 0B6h                         ; Set Panning / AMS / FMS
                ld      (zYM2612_A1), a                 ; Write destination address to YM2612 address register
                nop
                ld      a, 0C0h                         ; default Panning / AMS / FMS settings (only stereo L/R enabled)
                ld      (zYM2612_D1), a                 ; Write to YM2612 data register
                pop     af                              ; Restore af
                ld      c, zID_MusicPointers            ; c = 4 (music pointer table)
                rst     GetPointerTable                 ; hl = pointer table for music pointers
                rst     PointerTableOffset              ; hl = pointer to song data
                push    hl                              ; Save hl
                push    hl                              ; ... twice
                rst     ReadPointer                     ; Dereference pointer, so that hl = pointer to voice table
                ld      (zVoiceTblPtr), hl              ; Store voice table pointer
                pop     hl                              ; Restore hl to pointer to song data
                pop     iy                              ; Also set iy = pointer to song data
                ld      a, (iy+5)                       ; Main tempo value
                ld      (zTempoAccumulator), a          ; Set starting accumulator value
                ld      (zCurrentTempo), a              ; Store current song tempo
                ld      de, 6                           ; Offset into DAC pointer
                add     hl, de                          ; hl = pointer to DAC pointer
                ld      (zSongPosition), hl             ; Save it to RAM
                ld      hl, zFMDACInitBytes             ; Load pointer to init data
                ld      (zTrackInitPos), hl             ; Save it to RAM
                ld      de, zTracksStart                ; de = pointer to track RAM
                ld      b, (iy+2)                       ; b = number of FM + DAC channels
                ld      a, (iy+4)                       ; a = tempo divider

                .fm_dac_loop:
                push    bc                              ; Save bc (gets damaged by ldi instructions)
                ld      hl, (zTrackInitPos)             ; Restore saved position for init bytes
                ldi                                     ; *de++ = *hl++ (copy initial playback control)
                ldi                                     ; *de++ = *hl++ (copy channel assignment bits)
                ld      (de), a                         ; Copy tempo divider
                inc     de                              ; Advance pointer
                ld      (zTrackInitPos), hl             ; Save current position in channel assignment bits
                ld      hl, (zSongPosition)             ; Load current position in BGM data
                ldi                                     ; *de++ = *hl++ (copy track address low byte)
                ldi                                     ; *de++ = *hl++ (copy track address high byte)
                ldi                                     ; *de++ = *hl++ (default key offset)
                ldi                                     ; *de++ = *hl++ (track default volume)
                ld      (zSongPosition), hl             ; Store current position in BGM data
                call    zInitFMDACTrack                 ; Init the remainder of the track RAM
                pop     bc                              ; Restore bc
                djnz    .fm_dac_loop                    ; Loop for all tracks (stored in b)

                ld      a, (iy+3)                       ; Get number of PSG tracks
                or      a                               ; Do we have any PSG channels?
                jp      z, zClearNextSound              ; Branch if not
                ld      b, a                            ; b = number of PSG tracks
                ld      hl, zPSGInitBytes               ; Load pointer to init data
                ld      (zTrackInitPos), hl             ; Save it to RAM
                ld      de, zSongPSG1                   ; de = pointer to RAM for song PSG tracks
                ld      a, (iy+4)                       ; a = tempo divider

                .psg_loop:
                push    bc                              ; Save bc (gets damaged by ldi instructions)
                ld      hl, (zTrackInitPos)             ; Restore saved position for init bytes
                ldi                                     ; *de++ = *hl++
                ldi                                     ; *de++ = *hl++
                ld      (de), a                         ; Copy tempo divider
                inc     de                              ; Advance pointer
                ld      (zTrackInitPos), hl             ; Save current position in channel assignment bits
                ld      hl, (zSongPosition)             ; Load current position in BGM data
                ld      bc, 6                           ; Copy 6 bytes
                ldir                                    ; while (bc-- > 0) *de++ = *hl++; (copy track address, default key offset, default volume, modulation control, default PSG tone)
                ld      (zSongPosition), hl             ; Store current position in BGM data
                call    zZeroFillTrackRAM               ; Init the remainder of the track RAM
                pop     bc                              ; Restore bc
                djnz    .psg_loop                       ; Loop for all tracks (stored in b)

; =============== S U B R O U T I N E =======================================
; Clears next sound to play
; sub_690
zClearNextSound:
                xor     a
                ld      (zNextSound), a
                ret
; End of function zClearNextSound
; ---------------------------------------------------------------------------
; loc_695
; FM/DAC channel assignment bits
; The first byte in every pair (always 80h) is default value for playback control bits
; The second byte in every pair goes as follows:
; The first is for DAC; then 0, 1, 2 then 4, 5, 6 for the FM channels (the missing 3
; is the gap between part I and part II for YM2612 port writes)
zFMDACInitBytes:
                db      80h,   6
                db      80h,   0
                db      80h,   1
                db      80h,   2
                db      80h,   4
                db      80h,   5
                db      80h,   6                        ; FM6 music track (does not exist in this driver)
; loc_6A3
; Default values for PSG tracks
; The first byte in every pair (always 80h) is default value for playback control bits
; The second byte in every pair is the default values for PSG tracks
zPSGInitBytes:
                db      80h, 80h
                db      80h, 0A0h
                db      80h, 0C0h
; ---------------------------------------------------------------------------
; loc_6A9
zPlaySound_CheckRing:
                sub     sfx__First                      ; Make it a 0-based index
                or      a                               ; Is it the ring sound?
                jp      nz, zPlaySound_Bankswitch       ; Branch if not
                ld      a, (zRingSpeaker)               ; Get speaker on which ring sound is played
                xor     1                               ; Toggle bit 0
                ld      (zRingSpeaker), a               ; Save it

; loc_6B7
zPlaySound_Bankswitch:
                ex      af, af'                         ; Save af
                bankswitchToSFX
                xor     a                               ; a = 0
                ld      c, zID_SFXPointers              ; SFX table index
                ld      (zUpdatingSFX), a               ; Clear flag to update SFX
                ex      af, af'                         ; Restore af
                cp      sfx_Spindash-sfx__First         ; Is this the spindash sound?
                jp      z, zPlaySound                   ; Branch if yes
                cp      sfx__FirstContinuous-sfx__First  ; Is this before sound 0BCh?
                jp      c, zPlaySound_Normal            ; Branch if yes
                push    af                              ; Save af
                ld      b, a                            ; b = sound index
                ld      a, (zContinuousSFX)             ; Load last continuous SFX played
                sub     b                               ; Is this the same continuous sound that was playing?
                jp      nz, zPlaySound_NotCont          ; Branch if not
                ld      a, 80h                          ; a = 80h
                ld      (zContinuousSFXFlag), a         ; Flag continuous SFX as being extended
                rst     GetPointerTable                 ; hl = pointer to SFX data table
                pop     af                              ; Restore af
                ld      c, a                            ; c = SFX index; redundant, as PointerTableOffset does it already
                rst     PointerTableOffset              ; hl = pointer to SFX data
                inc     hl                              ; Skip low byte of voice pointer
                inc     hl                              ; Skip high byte of voice pointer
                inc     hl                              ; Skip timing divisor
                ld      a, (hl)                         ; Get number of SFX tracks
                ld      (zContSFXLoopCnt), a            ; Save it to RAM (loop counter for continuous SFX)
                jp      zClearNextSound
; ---------------------------------------------------------------------------
; loc_6FB
zPlaySound_NotCont:
                xor     a                               ; a = 0
                ld      (zContinuousSFXFlag), a         ; Clear continue continuous SFX flag
                pop     af                              ; Restore af
                ld      (zContinuousSFX), a             ; Store SFX index
                jp      zPlaySound
; ---------------------------------------------------------------------------
; loc_706
zPlaySound_Normal:
                push    af                              ; Save af
                xor     a                               ; a = 0
                ld      (zSpindashRev), a               ; Reset spindash rev
                pop     af                              ; Restore af

; loc_70C
zPlaySound:
                rst     GetPointerTable                 ; hl = pointer to SFX data table
                rst     PointerTableOffset              ; hl = pointer to SFX data
                push    hl                              ; Save hl
                rst     ReadPointer                     ; hl = voice table pointer
                ld      (zSFXVoiceTblPtr), hl           ; Save to RAM
                xor     a                               ; a = 0
                ld      (zDriverRetained_StopTrackWriteOnlyLatch), a  ; Set otherwise unused location to zero
                pop     hl                              ; hl = pointer to SFX data
                push    hl                              ; Save it again
                pop     iy                              ; iy = pointer to SFX data
                ld      a, (iy+2)                       ; a = tempo divider
                ld      (zSFXTempoDivider), a           ; Save to RAM
                ld      de, 4                           ; de = 4
                add     hl, de                          ; hl = pointer to SFX track data
                ld      b, (iy+3)                       ; b = number of tracks (FM + PSG) used by SFX
                ld      a, b                            ; Copy to a
                ld      (zContSFXLoopCnt), a            ; Save to RAM (loop counter for continuous SFX)

; loc_72C
zSFXTrackInitLoop:
                push    bc                              ; Save bc; damaged by ldi instructions below
                push    hl                              ; Save hl
                inc     hl                              ; hl = pointer to channel identifier
                ld      c, (hl)                         ; c = channel identifier
                call    zGetSFXChannelPointers          ; Get track pointers for track RAM (ix) and overridden song track (hl)
                set     2, (hl)                         ; Set 'SFX is overriding this track' bit
                push    ix                              ; Save pointer to SFX track data in RAM

                ld      a, (zUpdatingSFX)               ; Get flag
                or      a                               ; Are we updating SFX?
                jr      z, .normalsfx1                  ; Branch if not (hint: it was cleared just below the bank switch above so... always)

; Effectively dead code
; Analysis of the Battletoads sound driver confirms previous speculation:
; this code was meant for GHZ-like waterfall effects which were subsequently
; scrapped in favor of the continuous SFX system
; If this system were to be reimplemented, then, after the call to
; zGetSFXChannelPointers, we would have:
; * ix = pointer to the overriding SFX track data in RAM;
; * iy = pointer to the special SFX track data in RAM
; * hl = pointer to the overridden music track data in RAM;
; This code would then ensure that de points to the correct RAM area for
; the writes below
                pop     hl                              ; hl = pointer to SFX track data in RAM
                push    iy                              ; Save iy (pointer to SFX data)
                .normalsfx1:

                pop     de                              ; de = pointer to SFX track data in RAM (unless you consider the above effectively dead code)
                pop     hl                              ; hl = pointer to SFX track data
                ldi                                     ; *de++ = *hl++ (initial playback control)
                ld      a, (de)                         ; Get the voice control byte from track RAM (to deal with SFX already there)
                cp      2                               ; Is this FM3?
                call    z, zFM3NormalMode               ; Set FM3 to normal mode if so
                ldi                                     ; *de++ = *hl++ (copy channel identifier)
                ld      a, (zSFXTempoDivider)           ; Get SFX tempo divider
                ld      (de), a                         ; Store it to RAM
                inc     de                              ; Advance pointer
                ldi                                     ; *de++ = *hl++ (low byte of channel data pointer)
                ldi                                     ; *de++ = *hl++ (high byte of channel data pointer)
                ldi                                     ; *de++ = *hl++ (key displacement)
                ldi                                     ; *de++ = *hl++ (channel volume)
                call    zInitFMDACTrack                 ; Init the remainder of the track RAM

; Analysis of the Battletoads sound driver confirms previous speculation:
; this code was meant for GHZ-like waterfall effects which were subsequently
; scrapped in favor of the continuous SFX system
; If this system were to be reimplemented, then, after the call to
; zGetSFXChannelPointers, we would have:
; * ix = pointer to the overriding SFX track data in RAM;
; * iy = pointer to the special SFX track data in RAM
; * hl = pointer to the overridden music track data in RAM;
; The code would then be checking to see if the corresponding SFX track
; was playing, make sure the tracks refer to the same FM/PSG channel
; then, if needed, mark the special SFX track as being overridden by the
; SFX so as to not abruptly end the SFX
; With the system unimplemented, iy points to the current SFX track data,
; meaning that the second branch is never taken, resulting in an attempted
; write to ROM
                bit     7, (ix+zTrack.PlaybackControl)  ; Is the 'playing' bit set for this track?
                jr      z, .dontoverride                ; Branch if not (all SFX define it as 80h, so... never)
                ld      a, (ix+zTrack.VoiceControl)     ; Grab the voice control byte
                cp      (iy+zTrack.VoiceControl)        ; Is this equal to the one for the corresponding special SFX track?
                jr      nz, .dontoverride               ; Branch if not
                set     2, (iy+zTrack.PlaybackControl)  ; Set bit 2 of playback control ('SFX is overriding this track')
                .dontoverride:

                push    hl                              ; Save hl
                ld      hl, (zSFXVoiceTblPtr)           ; hl = pointer to voice data

                ld      a, (zUpdatingSFX)               ; Get flag
                or      a                               ; Are we updating SFX?
                jr      z, .normalsfx2                  ; Branch if not (hint: it was cleared just below the bank switch above so... always)

; Analysis of the Battletoads sound driver confirms previous speculation:
; this code was meant for GHZ-like waterfall effects which were subsequently
; scrapped in favor of the continuous SFX system
; If this system were to be reimplemented, then, after the call to
; zGetSFXChannelPointers, we would have:
; * ix = pointer to the overriding SFX track data in RAM;
; * iy = pointer to the special SFX track data in RAM
; * hl = pointer to the overridden music track data in RAM;
; This code would then make ix point to the correct track data for the
; function calls below
; Without it implemented, iy points to the current SFX track data
                push    iy                              ; Save iy
                pop     ix                              ; ix = pointer to special SFX data
                .normalsfx2:

                ld      (ix+zTrack.VoicesLow), l        ; Low byte of voice pointer
                ld      (ix+zTrack.VoicesHigh), h       ; High byte of voice pointer
                call    zKeyOffIfActive                 ; Kill channel notes
                call    zFMClearSSGEGOps                ; Clear SSG-EG operators for track's channels (even on PSG tracks!!!)
                pop     hl                              ; Restore hl
                pop     bc                              ; Restore bc
                djnz    zSFXTrackInitLoop               ; Loop for all SFX tracks
                jp      zClearNextSound

; =============== S U B R O U T I N E =======================================
;
; sub_78F
zGetSFXChannelPointers:
                bit     7, c                            ; Is this a PSG track?
                jr      nz, .is_psg                     ; Branch if yes
                ld      a, c                            ; a = c
                bit     2, a                            ; Is this FM4, FM5 or FM6?
                jr      z, .get_ptrs                    ; Branch if not
                dec     a                               ; Remove gap between FM3 and FM4+
                jr      .get_ptrs
; ---------------------------------------------------------------------------
                .is_psg:
                ld      a, 1Fh                          ; a = 1Fh (redundant, as this is the first instruction of the function)
                call    zSilencePSGChannel              ; Silence channel at ix
; The next two lines are here because zSilencePSGChannel does not do
; its job correctly. See the note there
                ld      a, 0FFh                         ; Command to silence Noise channel
                ld      (zPSG), a                       ; Silence it
                ld      a, c                            ; a = channel identifier
; The next 5 shifts are so that we can convert it to a table index
                srl     a
                srl     a
                srl     a
                srl     a
                srl     a
                add     a, 2                            ; Compensate for subtraction below

                .get_ptrs:
                sub     2                               ; Start table at FM3
                ld      (zSFXSaveIndex), a              ; Save index of overridden channel
                push    af                              ; Save af
                ld      hl, zSFXChannelData             ; Pointer table for track RAM
                rst     PointerTableOffset              ; hl = track RAM
                push    hl                              ; Save hl
                pop     ix                              ; ix = track RAM
                pop     af                              ; Restore af
; This is where there is code in other drivers to load the special SFX
; channel pointers to iy
                ld      hl, zSFXOverriddenChannel       ; Pointer table for the overridden music track
                rst     PointerTableOffset              ; hl = RAM destination to mark as overridden
                ret
; End of function zGetSFXChannelPointers

; =============== S U B R O U T I N E =======================================
;
; sub_7C5
zInitFMDACTrack:
                ex      af, af'                         ; Save af
                xor     a                               ; a = 0
                ld      (de), a                         ; Set modulation to inactive
                inc     de                              ; Advance to next byte
                ld      (de), a                         ; Set FM instrument/PSG tone to zero too
                inc     de                              ; Advance to next byte again
                ex      af, af'                         ; Restore af

; loc_7CC
zZeroFillTrackRAM:
                ex      de, hl                          ; Exchange the contents of de and hl
                ld      (hl), zTrack.len                ; Call subroutine stack pointer
                inc     hl                              ; Advance to next byte
                ld      (hl), 0C0h                      ; default Panning / AMS / FMS settings (only stereo L/R enabled)
                inc     hl                              ; Advance to next byte
                ld      (hl), 1                         ; Current note duration timeout

                ld      b, zTrack.len-zTrack.DurationTimeout-1  ; Loop counter

                .loop:
                inc     hl                              ; Advance to next byte
                ld      (hl), 0                         ; Put 0 into this byte
                djnz    .loop                           ; Loop until end of track

                inc     hl                              ; Make hl point to next track
                ex      de, hl                          ; Exchange the contents of de and hl
                ret
; End of function zInitFMDACTrack
; ---------------------------------------------------------------------------
; zloc_7DF
zSFXChannelData:
                dw      zSFX_FM3                        ; FM3
                dw      zSFX_FM4                        ; FM4
                dw      zSFX_FM5                        ; FM5
                dw      zSFX_FM6                        ; FM6 or DAC
                dw      zSFX_PSG1                       ; PSG1
                dw      zSFX_PSG2                       ; PSG2
                dw      zSFX_PSG3                       ; PSG3
                dw      zSFX_PSG3                       ; PSG3/Noise
; zloc_7EF
zSFXOverriddenChannel:
                dw      zSongFM3                        ; FM3
                dw      zSongFM4                        ; FM4
                dw      zSongFM5                        ; FM5
                dw      zSongFM6_DAC                    ; FM6 or DAC
                dw      zSongPSG1                       ; PSG1
                dw      zSongPSG2                       ; PSG2
                dw      zSongPSG3                       ; PSG3
                dw      zSongPSG3                       ; PSG3/Noise

; =============== S U B R O U T I N E =======================================
; Pauses/unpauses sound
;
; sub_7FF
