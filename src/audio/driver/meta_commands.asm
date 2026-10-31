; Meta commands, tempo changes, driver halt, memory copy and SSG-EG settings
; Original driver statements retain their assembly order

                CPU     Z80
                listing purecode
cfMetaCF:
                ld      hl, zExtraCoordFlagSwitchTable  ; Load extra coordination flag switch table
                rst     PointerTableOffset              ; hl = jump target for parameter
                inc     de                              ; Advance track pointer
                ld      a, (de)                         ; Get another parameter byte
                jp      (hl)                            ; Jump to coordination flag handler

; =============== S U B R O U T I N E =======================================
; Sets current tempo to parameter byte
;
; Has one parameter byte, the new value for current tempo
;
; loc_F36
cfSetTempo:
                ld      (zCurrentTempo), a              ; Set current tempo to parameter
                ret

; =============== S U B R O U T I N E =======================================
; Plays another song or SFX
;
; Has one parameter byte, the ID of what is to be played
;
; DO NOT USE THIS TO PLAY THE SEGA PCM! It tampers with the stack pointer, and
; will wreak havok with the track update
;
; loc_F3A:
cfPlaySoundByIndex:
                push    ix                              ; Save track pointer
                call    zPlaySoundByIndex               ; Play sound specified by parameter
                pop     ix                              ; Restore track pointer
                ret

; =============== S U B R O U T I N E =======================================
; Halts or resumes all tracks according to parameter
;
; Has one parameter byte, which is zero to resume all tracks and non-zero to
; halt them
;
; loc_F42
cfHaltSound:
                ld      (zHaltFlag), a                  ; Set new mute flag
                or      a                               ; Is it set now?
                jr      z, .resume                      ; Branch if not
                push    ix                              ; Save ix
                push    de                              ; Save de
                ld      ix, zTracksStart                ; Start of song RAM
                ld      b, (zTracksEnd-zTracksStart)/zTrack.len  ; Number of tracks
                ld      de, zTrack.len                  ; Spacing between tracks

                .loop1:
                res     7, (ix+zTrack.PlaybackControl)  ; Clear 'track is playing' bit
                call    zKeyOff                         ; Stop current note
                add     ix, de                          ; Advance to next track
                djnz    .loop1                          ; Loop for all tracks
                pop     de                              ; Restore de
                pop     ix                              ; Restore ix
                jp      zPSGSilenceAll
; ---------------------------------------------------------------------------
                .resume:
                push    ix                              ; Save ix
                push    de                              ; Save de
                ld      ix, zTracksStart                ; Start of song RAM
                ld      b, (zTracksEnd-zTracksStart)/zTrack.len  ; Number of tracks
                ld      de, zTrack.len                  ; Spacing between tracks

                .loop2:
                set     7, (ix+zTrack.PlaybackControl)  ; Set 'track is playing' bit
                add     ix, de                          ; Advance to next track
                djnz    .loop2                          ; Loop for all tracks
                pop     de                              ; Restore de
                pop     ix                              ; Restore ix
                ret

; =============== S U B R O U T I N E =======================================
; Copies data from selected location to current track. Playback will continue
; after the last byte copied
;
; Has 3 parameter bytes, a 2-byte pointer to data to be copied and a 1-byte
; number of bytes to copy. The data is copied to the track's byte stream,
; starting after the parameters of this coord. flag, and will overwrite the data
; that what was there before. This likely will not work unless the song/SFX was
; copied to Z80 RAM in the first place
;
; loc_F7D
cfCopyData:
                ex      de, hl                          ; Exchange de and hl
                ld      e, (hl)                         ; e = low byte of pointer to new song data
                inc     hl                              ; Advance track pointer
                ld      d, (hl)                         ; d = high byte of pointer to new song data
                inc     hl                              ; Advance track pointer
                ld      c, (hl)                         ; c = number of bytes to copy
                ld      b, 0                            ; b = 0
                inc     hl                              ; Advance track pointer
                ex      de, hl                          ; Exchange back de and hl
                ldir                                    ; while (bc-- > 0) *de++ = *hl++;
                dec     de                              ; Put back last byte
                ret

; =============== S U B R O U T I N E =======================================
; Sets tempo divider for all tracks. Does not take effect until the next note
; duration is set
;
; Has one parameter, the new tempo divider
;
; loc_F8B
cfSetTempoDivider:
                ld      b, (zTracksEnd-zTracksStart)/zTrack.len  ; Number of tracks
                ld      hl, zTracksStart+zTrack.TempoDivider  ; Want to change tempo dividers

                .loop:
                push    bc                              ; Save bc
                ld      bc, zTrack.len                  ; Spacing between tracks
                ld      (hl), a                         ; Set tempo divider for track
                add     hl, bc                          ; Advance to next track
                pop     bc                              ; Restore bc
                djnz    .loop
                ret

; =============== S U B R O U T I N E =======================================
; Sets SSG-EG data for current track
;
; Has 4 parameter bytes, the operator parameters for SSG-EG data desired
;
; loc_F9A
cfSetSSGEG:
                ld      (ix+zTrack.HaveSSGEGFlag), 80h  ; Set custom SSG-EG data flag
                ld      (ix+zTrack.SSGEGPointerLow), e  ; Save low byte of SSG-EG data pointer
                ld      (ix+zTrack.SSGEGPointerHigh), d  ; Save high byte of SSG-EG data pointer

; =============== S U B R O U T I N E =======================================
; Sends SSG-EG data pointed to by de to appropriate registers in YM2612
;
; sub_FA4
zSendSSGEGData:
; DANGER! The following code ignores the fact that SSG-EG mode must be
; used with maximum (1Fh) attack rate or output is officially undefined
; This has the potential effect of weird sound, even in real hardware
                ld      hl, zFMInstrumentSSGEGTable     ; hl = pointer to registers for SSG-EG data
                ld      b, zFMInstrumentSSGEGTable_End-zFMInstrumentSSGEGTable  ; Number of entries

                .loop:
                ld      a, (de)                         ; Get data to sent to SSG-EG register
                inc     de                              ; Advance pointer
                ld      c, a                            ; c = data to send
                ld      a, (hl)                         ; a = register to send to
                inc     hl                              ; Advance pointer
                call    zWriteFMIorII                   ; Send data to correct channel
                djnz    .loop                           ; Loop for all registers
                dec     de                              ; Rewind data pointer a bit
                ret
; End of function zSendSSGEGData

; =============== S U B R O U T I N E =======================================
; Starts or controls FM volume envelope effects, according to the parameters
;
; Has two parameter bytes: the first is a (1-based) index into the PSG envelope
; table indicating how the envelope should go, while the second is a bitmask
; indicating which operators should be affected (in the form %00004231) for
; the current channel
;
; loc_FB5
; cfFMFlutter
cfFMVolEnv:
                ld      (ix+zTrack.FMVolEnv), a         ; Store envelope index
                inc     de                              ; Advance track pointer
                ld      a, (de)                         ; Get envelope mask
                ld      (ix+zTrack.FMVolEnvMask), a     ; Store envelope bitmask
                ret

; =============== S U B R O U T I N E =======================================
; Resets spindash rev counter
;
; Has no parameter bytes
;
; loc_FBE
cfResetSpindashRev:
                xor     a                               ; a = 0
                ld      (zSpindashRev), a               ; Reset spindash rev
                dec     de                              ; Put byte back
                ret

; =============== S U B R O U T I N E =======================================
; Updates a PSG track
;
; Input:   ix    Pointer to track RAM
;
; loc_FC4
