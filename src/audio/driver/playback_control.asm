; Pause handling, volume fades, sound queues and Sega PCM dispatch
; Original driver statements retain their assembly order

                CPU     Z80
                listing purecode
zPauseUnpause:
                ld      hl, zPauseFlag                  ; hl = pointer to pause flag
                ld      a, (hl)                         ; a = pause flag
                or      a                               ; Is sound driver paused?
                ret     z                               ; Return if not
                jp      m, .unpause                     ; Branch if pause flag is negative (unpause)
                pop     de                              ; Pop return value from the stack, so that a 'ret' will go back to zVInt
                dec     a                               ; Decrease a
                ret     nz                              ; Return if nonzero
                ld      (hl), 2                         ; Set pause flag to 2 (i.e., stay paused but don't pause again)
                jp      zPauseAudio                     ; Pause all but FM6/DAC
; ---------------------------------------------------------------------------
                .unpause:
                xor     a                               ; a = 0
                ld      (hl), a                         ; Clear pause flag
                ld      a, (zFadeOutTimeout)            ; Get fade timeout
                or      a                               ; Is it zero?
                jp      nz, zStopAllSound               ; Stop all music if not
                ld      ix, zSongFM1                    ; Start with FM1 track
; DANGER! This treats a PSG channel as if it were an FM channel. This
; will break AMS/FMS/pan for FM1

                ld      b, (zSongPSG2-zSongFM1)/zTrack.len  ; Number of FM tracks +1

                .fm_loop:
                ld      a, (zHaltFlag)                  ; Get halt flag
                or      a                               ; Is song halted?
                jr      nz, .set_pan                    ; Branch if yes
                bit     7, (ix+zTrack.PlaybackControl)  ; Is track playing?
                jr      z, .skip_fm_track               ; Branch if not

                .set_pan:
                ld      c, (ix+zTrack.AMSFMSPan)        ; Get track AMS/FMS/panning
                ld      a, 0B4h                         ; Command to select AMS/FMS/panning register
                call    zWriteFMIorII                   ; Write data to YM2612

                .skip_fm_track:
                ld      de, zTrack.len                  ; Spacing between tracks
                add     ix, de                          ; Advance to next track
                djnz    .fm_loop                        ; Loop for all tracks

; DANGER! This code goes past the end of Z80 RAM and into reserved territory!
; By luck, it only *reads* from these areas

                ld      ix, zTracksSFXEnd               ; Start at the END of SFX track data (?)
                ld      b, 7                            ; But loop for 7 tracks (??)
                .psg_loop:
                bit     7, (ix+zTrack.PlaybackControl)  ; Is track playing?
                jr      z, .skip_psg_track              ; Branch if not
                bit     7, (ix+zTrack.VoiceControl)     ; Is this a PSG track?
                jr      nz, .skip_psg_track             ; Branch if yes
                ld      c, (ix+zTrack.AMSFMSPan)        ; Get track AMS/FMS/panning
                ld      a, 0B4h                         ; Command to select AMS/FMS/panning register
                call    zWriteFMIorII                   ; Write data to YM2612

                .skip_psg_track:
                ld      de, zTrack.len                  ; Spacing between tracks
                add     ix, de                          ; Go to next track
                djnz    .psg_loop                       ; Loop for all tracks

                ret
; End of function zPauseUnpause

; =============== S U B R O U T I N E =======================================
; Fades out music
; sub_85C
zFadeOutMusic:
                ld      a, 28h                          ; a = 28h
                ld      (zFadeOutTimeout), a            ; Set fade timeout to this (start fading out music)
                ld      a, 6                            ; a = 6
                ld      (zFadeDelayTimeout), a          ; Set fade delay timeout
                ld      (zFadeDelay), a                 ; Set fade delay and fall through

; =============== S U B R O U T I N E =======================================
; Halts FM6/DAC, PSG1, PSG2, PSG3
; sub_869
zHaltDACPSG:
                xor     a                               ; a = 0
                ld      (zSongFM6_DAC), a               ; Halt FM6/DAC
                ld      (zSongPSG3), a                  ; Halt PSG3
                ld      (zSongPSG1), a                  ; Halt PSG1
                ld      (zSongPSG2), a                  ; Halt PSG2
                jp      zPSGSilenceAll
; End of function zHaltDACPSG

; =============== S U B R O U T I N E =======================================
; Fade out music slowly
;
; sub_879
zDoMusicFadeOut:
                ld      hl, zFadeOutTimeout             ; hl = pointer to fade timeout
                ld      a, (hl)                         ; a = fade counter
                or      a                               ; Is fade counter zero?
                ret     z                               ; Return if yes
                call    m, zHaltDACPSG                  ; Kill DAC and PSG channels if negative
                res     7, (hl)                         ; Clear sign bit
                ld      a, (zFadeDelayTimeout)          ; Get fade delay timeout
                dec     a                               ; Decrement it
                jr      z, .timer_expired               ; Branch if it zero now
                ld      (zFadeDelayTimeout), a          ; Store it back
                ret
; ---------------------------------------------------------------------------
                .timer_expired:
                ld      a, (zFadeDelay)                 ; Get fade delay
                ld      (zFadeDelayTimeout), a          ; Restore counter to initial value
                ld      a, (zFadeOutTimeout)            ; a = fade timeout
                dec     a                               ; Decrement it
                ld      (zFadeOutTimeout), a            ; Then store it back
                jp      z, zStopAllSound                ; Stop all music if it is zero
                ld      a, (zSongBank)                  ; a = current music bank ID
                if      SonicDriverVer==3
                ld      hl, zBankRegister
                bankswitchToMusicS3
                else
                bankswitch2                             ; Bank switch to music bank
                endif
                ld      ix, zTracksStart                ; ix = pointer to track RAM
                ld      b, (zSongPSG1-zTracksStart)/zTrack.len  ; Number of FM+DAC tracks

                .loop:
                inc     (ix+zTrack.Volume)              ; Decrease volume
                jp      p, .chk_change_volume           ; If still positive, branch
                dec     (ix+zTrack.Volume)              ; Increase it back to minimum volume (127)
                jr      .next_track
; ---------------------------------------------------------------------------
                .chk_change_volume:
                bit     7, (ix+zTrack.PlaybackControl)  ; Is track still playing?
                jr      z, .next_track                  ; Branch if not
                bit     2, (ix+zTrack.PlaybackControl)  ; Is SFX overriding track?
                jr      nz, .next_track                 ; Branch if yes
                push    bc                              ; Save bc
                call    zSendTL                         ; Send new volume
                pop     bc                              ; Restore bc

                .next_track:
                ld      de, zTrack.len                  ; Spacing between tracks
                add     ix, de                          ; Advance to next track
                djnz    .loop                           ; Loop for all tracks
                ret
; End of function zDoMusicFadeOut

; =============== S U B R O U T I N E =======================================
; Fades music in
;
; sub_8DF
zDoMusicFadeIn:
                ld      a, (zFadeInTimeout)             ; Get fading timeout
                or      a                               ; Is music being faded?
                ret     z                               ; Return if not
                ld      a, (zSongBank)                  ; Get current music bank
                if      SonicDriverVer==3
                ld      hl, zBankRegister
                bankswitchToMusicS3
                else
                bankswitch2                             ; Bank switch to music
                endif
                ld      a, (zFadeDelay)                 ; Get fade delay
                dec     a                               ; Decrement it
                ld      (zFadeDelay), a                 ; Store it back
                ret     nz                              ; Return if it is not yet zero
                ld      a, (zFadeDelayTimeout)          ; Get current fade delay timeout
                ld      (zFadeDelay), a                 ; Reset to starting fade delay
                ld      b, (zSongPSG1-zSongFM1)/zTrack.len  ; Number of FM tracks
                ld      ix, zSongFM1                    ; ix = start of FM1 RAM
                ld      de, zTrack.len                  ; Spacing between tracks

                .fm_loop:
                ld      a, (ix+zTrack.Volume)           ; Get track volume
                dec     a                               ; Increase it
                ld      (ix+zTrack.Volume), a           ; Then store it back
                push    bc                              ; Save bc
                call    zSendTL                         ; Send new volume
                pop     bc                              ; Restore bc
                add     ix, de                          ; Advance to next track
                djnz    .fm_loop                        ; Loop for all tracks

                ld      a, (zFadeInTimeout)             ; Get fading timeout
                dec     a                               ; Decrement it
                ld      (zFadeInTimeout), a             ; Then store it back
                ret     nz                              ; Return if still fading
                ld      b, (zTracksEnd-zSongPSG1)/zTrack.len  ; Number of PSG tracks
                ld      ix, zSongPSG1                   ; ix = start of PSG RAM
                ld      de, zTrack.len                  ; Spacing between tracks

                .psg_loop:
                res     2, (ix+zTrack.PlaybackControl)  ; Clear 'SFX is overriding' bit
                add     ix, de                          ; Advance to next track
                djnz    .psg_loop                       ; Loop for all tracks

                ld      ix, zSongFM6_DAC                ; ix = start of DAC/FM6 RAM
                res     2, (ix+zTrack.PlaybackControl)  ; Clear 'SFX is overriding' bit
                ret
; End of function zDoMusicFadeIn

; =============== S U B R O U T I N E =======================================
; Wipes music data and fades all FM, PSG and DAC channels
; sub_944 zMusicFade
zStopAllSound:
; The following block sets to zero the z80 RAM from 1C0Dh to 1FD4h
                ld      hl, zTempVariablesStart         ; Starting source address for copy
                ld      de, zTempVariablesStart+1       ; Starting destination address for copy
                ld      bc, zTempVariablesEnd-zTempVariablesStart-1+34h  ; Length of copy
                ld      (hl), 0                         ; Initial value of zero
                ldir                                    ; while (--length) *de++ = *hl++

                xor     a                               ; a = 0
                ld      (zTempoSpeedup), a              ; Fade in normal speed

                ld      ix, zFMDACInitBytes             ; Initialization data for channels
                ld      b, 6                            ; Number of FM channels

                .loop:
                push    bc                              ; Save bc for loop

                call    zFMSilenceChannel               ; Silence track's channel

                call    zFMClearSSGEGOps                ; Clears the SSG-EG operators for this channel
                inc     ix                              ; Go to next channel byte
                inc     ix                              ; But skip the 80h
                pop     bc                              ; Restore bc for loop counter
                djnz    .loop                           ; Loop while b > 0

                ld      b, 7                            ; Unused
                xor     a                               ; a = 0
                ld      (zFadeOutTimeout), a            ; Set fade timeout to zero... again
                call    zPSGSilenceAll                  ; Silence PSG
                ld      c, 0                            ; Write a zero
                ld      a, 2Bh                          ; ... to DAC enable register
                call    zWriteFMI                       ; Disable DAC

; loc_979
zFM3NormalMode:
                xor     a                               ; a = 0 (is 0Fh in Z80 Type 1)
                ld      (zFM3Settings), a               ; Save FM3 settings
                ld      c, a                            ; FM3 mode: normal mode
                ld      a, 27h                          ; FM3 special settings
                call    zWriteFMI                       ; Set it
                jp      zClearNextSound
; End of function zStopAllSound

; =============== S U B R O U T I N E =======================================
; Sets the SSG-EG registers (90h+) for all operators on this track to 0
;
; Input:  ix    Pointer to track RAM
; Output: a     Damaged
; b     Damaged
; c     Damaged
; sub_986
zFMClearSSGEGOps:
                ld      a, 90h                          ; Set SSG-EG registers
                ld      c, 0                            ; ... set to zero (as docs say it should)
                jp      zFMOperatorWriteLoop            ; ... for all operators of this track's channel
; End of function zFMClearSSGEGOps

; =============== S U B R O U T I N E =======================================
; Pauses all audio
; loc_98D
zPauseAudio:
                call    zPSGSilenceAll                  ; Redundant, as function falls-through to it anyway
                push    bc                              ; Save bc
                push    af                              ; Save af
                ld      b, (zSongFM4-zSongFM1)/zTrack.len  ; FM1/FM2/FM3
                ld      a, 0B4h                         ; Command to select AMS/FMS/panning register (FM1)
                ld      c, 0                            ; AMS=FMS=panning=0

                .loop1:
                push    af                              ; Save af
                call    zWriteFMI                       ; Write reg/data pair to YM2612
                pop     af                              ; Restore af
                inc     a                               ; Advance to next channel
                djnz    .loop1                          ; Loop for all channels

                ld      b, (zSongPSG1-zSongFM4)/zTrack.len  ; FM4 and FM5, but not FM6
                ld      a, 0B4h                         ; Command to select AMS/FMS/panning register

                .loop2:
                push    af                              ; Save af
                call    zWriteFMII                      ; Write reg/data pair to YM2612
                pop     af                              ; Restore af
                inc     a                               ; Advance to next channel
                djnz    .loop2                          ; Loop for all channels

                ld      c, 0                            ; Note off for all operators
                ld      b, (zSongPSG1-zSongFM1)/zTrack.len+1  ; 5 FM channels + 1 gap between FM3 and FM4
                ld      a, 28h                          ; Command to send note on/off

                .loop3:
                push    af                              ; Save af
                call    zWriteFMI                       ; Write reg/data pair to YM2612
                inc     c                               ; Next channel
                pop     af                              ; Restore af
                djnz    .loop3                          ; Loop for all channels

                pop     af                              ; Restore af
                pop     bc                              ; restore bc and fall through

; =============== S U B R O U T I N E =======================================
; Silences all PSG channels, including the noise channel
;
; Output: a    Damaged
; sub_9BC
zPSGSilenceAll:
                push    bc                              ; Save bc
                ld      b, 4                            ; Loop 4 times: 3 PSG channels + noise channel
                ld      a, 9Fh                          ; Command to silence PSG1

                .loop:
                ld      (zPSG), a                       ; Write command
                add     a, 20h                          ; Next channel
                djnz    .loop                           ; Loop for all PSG channels
                pop     bc                              ; Restore bc
                jp      zClearNextSound
; End of function zPSGSilenceAll

; =============== S U B R O U T I N E =======================================
; Tempo works as divisions of the 60Hz clock (there is a fix supplied for
; PAL that "kind of" keeps it on track.) Every time the internal music clock
; does NOT overflow, it will update. So a tempo of 80h will update every
; other frame, or 30 times a second
; sub_9CC:
TempoWait:
                ld      a, (zCurrentTempo)              ; Get current tempo value
                ld      hl, zTempoAccumulator           ; hl = pointer to tempo accumulator
                add     a, (hl)                         ; a += tempo accumulator
                ld      (hl), a                         ; Store it as new accumulator value
                ret     nc                              ; If the addition did not overflow, return
                ld      hl, zTracksStart+zTrack.DurationTimeout  ; Duration timeout of first track
                ld      de, zTrack.len                  ; Spacing between tracks
                ld      b, (zTracksEnd-zTracksStart)/zTrack.len  ; Number of tracks

                .loop:
                inc     (hl)                            ; Delay notes another frame
                add     hl, de                          ; Advance to next track
                djnz    .loop                           ; Loop for all channels
                ret
; End of function TempoWait

; =============== S U B R O U T I N E =======================================
; Copies over M68K input to the sound queue and clears the input variables
; sub_9E2
zFillSoundQueue:
                ld      hl, zMusicNumber                ; M68K input
                ld      de, zSoundQueue0                ; Sound queue
                ldi                                     ; *de++ = *hl++
                ldi                                     ; *de++ = *hl++
                ldi                                     ; *de++ = *hl++

zClearSoundQueue:
                xor     a                               ; a = 0
                dec     hl                              ; Point to zSFXNumber1
                ld      (hl), a                         ; Clear it
                dec     hl                              ; Point to zSFXNumber0
                ld      (hl), a                         ; Clear it
                dec     hl                              ; Point to zMusicNumber
                ld      (hl), a                         ; Clear it
                ret
; End of function zFillSoundQueue

; =============== S U B R O U T I N E =======================================
; Sets D1L to minimum, RR to maximum and TL to minimum amplitude for all
; operators on this track's channel, then sends note off for the same channel
;
; Input:  ix    Pointer to track RAM
; Output: a     Damaged
; b     Damaged
; c     Damaged
; sub_9F6
zFMSilenceChannel:
                call    zSetMaxRelRate
                ld      a, 40h                          ; Set total level
                ld      c, 7Fh                          ; ... to minimum envelope amplitude
                call    zFMOperatorWriteLoop            ; ... for all operators of this track's channel
                ld      c, (ix+zTrack.VoiceControl)     ; Send key off
                jp      zKeyOnOff                       ; This does not safeguard against PSG tracks, making cfSilenceStopTrack dangerous (and zStopSFX even more so)
; End of function zFMSilenceChannel

; =============== S U B R O U T I N E =======================================
; Sets D1L to minimum and RR to maximum for all operators on this track's
; channel
;
; Input:  ix    Pointer to track RAM
; Output: a     Damaged
; b     Damaged
; c     Damaged
; sub_A06
; zSetFMMinD1LRR
zSetMaxRelRate:
                ld      a, 80h                          ; Set D1L to minimum and RR to maximum
                ld      c, 0FFh                         ; ... for all operators on this track's channel (fall through)
; End of function zSetMaxRelRate

; =============== S U B R O U T I N E =======================================
; Loops through all of a channel's operators and sets them to the desired value
;
; Input:  ix    Pointer to track RAM
; a     YM2612 register to write to
; c     Value to write to register
; Output: b     Damaged
; sub_A0A
zFMOperatorWriteLoop:
                ld      b, 4                            ; Loop 4 times

                .loop:
                push    af                              ; Save af
                call    zWriteFMIorII                   ; Write to part I or II, as appropriate
                pop     af                              ; Restore af
                add     a, 4                            ; a += 4
                djnz    .loop                           ; Loop
                ret
; End of function zFMOperatorWriteLoop
; ---------------------------------------------------------------------------
; loc_A16
zPlaySegaSound:
                call    zStopAllSound                   ; Fade music before playing the sound
                ld      a, 1                            ; a = 1
                ld      (PlaySegaPCMFlag), a            ; Set flag to play SEGA sound
                pop     hl                              ; Don't return to caller of zCycleSoundQueue
                ret

; =============== S U B R O U T I N E =======================================
; Performs massive restoration and starts fade in of previous music
;
; sub_A20
zFadeInToPrevious:
                xor     a                               ; a = 0
                ld      (zFadeToPrevFlag), a            ; Clear fade-to-prev flag
                ld      a, (zCurrentTempoSave)          ; Get saved current tempo
                ld      (zCurrentTempo), a              ; Restore it
                ld      a, (zTempoSpeedupSave)          ; Get saved tempo speed-up
                ld      (zTempoSpeedup), a              ; Restore it
                ld      hl, (zVoiceTblPtrSave)          ; Get saved voice pointer
                ld      (zVoiceTblPtr), hl              ; Restore it
                if      SonicDriverVer==3
                ld      hl, zBankRegister
                ld      a, (zSongBankSave)              ; Get saved song bank ID
                ld      (zSongBank), a                  ; Restore it
                bankswitchToMusicS3
                else
                ld      a, (zSongBankSave)              ; Get saved song bank ID
                ld      (zSongBank), a                  ; Restore it
                bankswitch2                             ; Bank switch to previous song's bank
                endif
                ld      hl, zTracksSaveStart            ; Start of saved track data
                ld      de, zTracksStart                ; Start of track data
                ld      bc, zTracksSaveEnd-zTracksSaveStart  ; Number of bytes to copy
                ldir                                    ; while (bc-- > 0) *de++ = *hl++;
                ld      a, (zSongFM6_DAC.PlaybackControl)  ; a = FM6/DAC track playback control
                or      84h                             ; Set 'track is playing' and 'track is resting' flags
                ld      (zSongFM6_DAC.PlaybackControl), a  ; Set new value
                ld      ix, zSongFM1                    ; ix = pointer to FM1 track RAM
                ld      b, (zTracksEnd-zSongFM1)/zTrack.len  ; Number of FM+PSG tracks

                .loop:
                ld      a, (ix+zTrack.PlaybackControl)  ; a = track playback control
                or      84h                             ; Set 'track is playing' and 'track is resting' flags
                ld      (ix+zTrack.PlaybackControl), a  ; Set new value
                bit     7, (ix+zTrack.VoiceControl)     ; Is this a PSG track?
                jp      nz, .skip_track                 ; Branch if yes
                res     2, (ix+zTrack.PlaybackControl)  ; Clear 'SFX is overriding track' flag
                ld      a, (ix+zTrack.Volume)           ; Get track volume
                add     a, 40h                          ; Lower volume by 40h
                ld      (ix+zTrack.Volume), a           ; Store new volume
                ld      a, (ix+zTrack.VoiceIndex)       ; a = FM instrument
                push    bc                              ; Save bc
                ld      b, a                            ; b = FM instrument
                call    zGetFMInstrumentPointer         ; hl = pointer to instrument data
                call    zSendFMInstrument               ; Send instrument
                pop     bc                              ; Restore bc

                .skip_track:
                ld      de, zTrack.len                  ; Spacing between tracks
                add     ix, de                          ; ix = pointer to next track
                djnz    .loop                           ; Loop for all tracks

                ld      a, 40h                          ; a = 40h
                ld      (zFadeInTimeout), a             ; Start fade
                ld      a, 2                            ; a = 2
                ld      (zFadeDelayTimeout), a          ; Set fade delay timeout
                ld      (zFadeDelay), a                 ; Set fade delay
                ret
; End of function zFadeInToPrevious
; ---------------------------------------------------------------------------
