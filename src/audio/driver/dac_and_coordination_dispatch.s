; DAC track updates, coordination command dispatch and panning
; Original driver statements retain their assembly order

                CPU     Z80
                listing purecode
zUpdateDACTrack:
                call    zTrackRunTimer                  ; Advance track duration timer
                ret     nz                              ; Return if note is still going
                ld      e, (ix+zTrack.DataPointerLow)   ; e = low byte of track data pointer
                ld      d, (ix+zTrack.DataPointerHigh)  ; d = high byte of track data pointer

; loc_BA2
zUpdateDACTrack_cont:
                ld      a, (de)                         ; Get next byte from track
                inc     de                              ; Advance pointer
                cp      FirstCoordFlag                  ; Is it a coordination flag?
                jp      nc, zHandleDACCoordFlag         ; Branch if yes
                or      a                               ; Is it a note?
                jp      m, .got_sample                  ; Branch if yes
                dec     de                              ; We got a duration, so go back to it
                ld      a, (ix+zTrack.SavedDAC)         ; Reuse previous DAC sample

                .got_sample:
                ld      (ix+zTrack.SavedDAC), a         ; Store new DAC sample
                cp      NoteRest                        ; Is it a rest?
                jp      z, zUpdateDACTrack_GetDuration  ; Branch if yes
                res     7, a                            ; Clear bit 7
                push    de                              ; Save de
                ex      af, af'                         ; Save af
                call    zKeyOffIfActive                 ; Kill note (will do nothing if 'do not attack' is on)
                call    zFM3NormalMode                  ; Set FM3 to normal mode
                ex      af, af'                         ; Restore af
                ld      ix, zSongFM6_DAC                ; ix = pointer to DAC track data
                bit     2, (ix+zTrack.PlaybackControl)  ; Is SFX overriding DAC channel?
                jp      nz, .dont_play                  ; Branch if yes
                ld      (zDACIndex), a                  ; Queue DAC sample

                .dont_play:
                pop     de                              ; Restore de

zUpdateDACTrack_GetDuration:
                ld      a, (de)                         ; Get note duration
                inc     de                              ; Advance pointer
                or      a                               ; Is it a duration?
                jp      p, zStoreDuration               ; Branch if yes
                dec     de                              ; Put the byte back to the stream
                ld      a, (ix+zTrack.SavedDuration)    ; Reuse last duration (zFinishTrackUpdate should do it...)
                ld      (ix+zTrack.DurationTimeout), a  ; Set new duration timeout (zFinishTrackUpdate should do it...)
                jp      zFinishTrackUpdate
; ---------------------------------------------------------------------------
; loc_BE3
zHandleDACCoordFlag:
                ld      hl, loc_BE9                     ; hl = desired return address
                jp      zHandleCoordFlag
; ---------------------------------------------------------------------------
loc_BE9:
                inc     de                              ; Advance to next byte in track
                jp      zUpdateDACTrack_cont            ; Continue processing DAC track
; ---------------------------------------------------------------------------
; loc_BED
zHandleFMorPSGCoordFlag:
                ld      hl, loc_BF9                     ; hl = desired return address

; loc_BF0
zHandleCoordFlag:
                push    hl                              ; Set return location (ret) to location stored in hl
                sub     FirstCoordFlag                  ; Make it a zero-based index
                ld      hl, zCoordFlagSwitchTable       ; Load switch table into hl
                rst     PointerTableOffset              ; hl = pointer to target location
                ld      a, (de)                         ; a = coordination flag parameter
                jp      (hl)                            ; Indirect jump to coordination flag handler
; End of function zUpdateDACTrack
; ---------------------------------------------------------------------------
loc_BF9:
                inc     de                              ; Advance to next byte in track
                jp      zGetNextNote_cont               ; Continue processing FM/PSG track
; ---------------------------------------------------------------------------
; loc_BFD
zCoordFlagSwitchTable:
                dw      cfPanningAMSFMS                 ; 0E0h
                dw      cfDetune                        ; 0E1h
                dw      cfFadeInToPrevious              ; 0E2h
                dw      cfSilenceStopTrack              ; 0E3h
                dw      cfSetVolume                     ; 0E4h
                dw      cfChangeVolume2                 ; 0E5h
                dw      cfChangeVolume                  ; 0E6h
                dw      cfPreventAttack                 ; 0E7h
                dw      cfNoteFill                      ; 0E8h
                dw      cfSpindashRev                   ; 0E9h
                dw      cfPlayDACSample                 ; 0EAh
                dw      cfConditionalJump               ; 0EBh
                dw      cfChangePSGVolume               ; 0ECh
                dw      cfSetKey                        ; 0EDh
                dw      cfSendFMI                       ; 0EEh
                dw      cfSetVoice                      ; 0EFh
                dw      cfModulation                    ; 0F0h
                dw      cfAlterModulation               ; 0F1h
                dw      cfStopTrack                     ; 0F2h
                dw      cfSetPSGNoise                   ; 0F3h
                dw      cfSetModulation                 ; 0F4h
                dw      cfSetPSGVolEnv                  ; 0F5h
                dw      cfJumpTo                        ; 0F6h
                dw      cfRepeatAtPos                   ; 0F7h
                dw      cfJumpToGosub                   ; 0F8h
                dw      cfJumpReturn                    ; 0F9h
                dw      cfDisableModulation             ; 0FAh
                dw      cfChangeTransposition           ; 0FBh
                dw      cfLoopContinuousSFX             ; 0FCh
                dw      cfToggleAltFreqMode             ; 0FDh
                dw      cfFM3SpecialMode                ; 0FEh
                dw      cfMetaCF                        ; 0FFh
; loc_C3D
zExtraCoordFlagSwitchTable:
                dw      cfSetTempo                      ; 0FFh 00h
                dw      cfPlaySoundByIndex              ; 0FFh 01h
                dw      cfHaltSound                     ; 0FFh 02h
                dw      cfCopyData                      ; 0FFh 03h
                dw      cfSetTempoDivider               ; 0FFh 04h
                dw      cfSetSSGEG                      ; 0FFh 05h
                dw      cfFMVolEnv                      ; 0FFh 06h
                dw      cfResetSpindashRev              ; 0FFh 07h
; =============== S U B R O U T I N E =======================================
; Sets a new DAC sample for play
;
; Has one parameter, the index (1-based) of the DAC sample to play
;
; sub_C4D
cfPlayDACSample:
                ld      (zDACIndex), a                  ; Set next DAC sample to the parameter byte
                ret
; End of function cfPlayDACSample

; =============== S U B R O U T I N E =======================================
; Sets panning for track. By accident, you can sometimes set AMS and FMS
; flags -- but only if the bits in question were zero
;
; Has one parameter byte, the AMS/FMS/panning bits
;
; sub_C51
cfPanningAMSFMS:
                ld      c, 3Fh                          ; Mask for all but panning

zDoChangePan:
                ld      a, (ix+zTrack.AMSFMSPan)        ; Get current AMS/FMS/panning
                and     c                               ; Mask out L+R
                push    de                              ; Store de
                ex      de, hl                          ; Exchange de and hl
                or      (hl)                            ; Mask in the new panning; may also add AMS/FMS
                ld      (ix+zTrack.AMSFMSPan), a        ; Store new value in track RAM
                ld      c, a                            ; c = new AMS/FMS/panning
                ld      a, 0B4h                         ; a = YM2612 register to write to
                call    zWriteFMIorII                   ; Set new panning/AMS/FMS
                pop     de                              ; Restore de
                ret
; End of function cfPanningAMSFMS

; =============== S U B R O U T I N E =======================================
; Performs an escalating transposition ("revving") of the track
;
; The saved value for the spindash rev is reset to zero every time a "normal"
; SFX is played (i.e., not a continuous SFX and not the spindash sound)
; Every time this function is called, the spindash rev value is added to the
; track key offset; unless this sum is exactly 10h, then the spindash rev is
; further increased by 1 for future calls
;
; Has no parameter bytes
;
; sub_C65
