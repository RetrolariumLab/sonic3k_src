; PSG track processing, volume envelopes, note release and silence
; Original driver statements retain their assembly order

                CPU     Z80
                listing purecode
zUpdatePSGTrack:
                call    zTrackRunTimer                  ; Run note timer
                jr      nz, .note_going                 ; Branch if note hasn't expired yet
                call    zGetNextNote                    ; Get next note for PSG track
                bit     4, (ix+zTrack.PlaybackControl)  ; Is track resting?
                ret     nz                              ; Return if yes
                call    zPrepareModulation              ; Initialize modulation
                jr      .skip_fill
; ---------------------------------------------------------------------------
                .note_going:
                ld      a, (ix+zTrack.NoteFillTimeout)  ; Get note fill
                or      a                               ; Has timeout expired?
                jr      z, .skip_fill                   ; Branch if yes
                dec     (ix+zTrack.NoteFillTimeout)     ; Update note fill
                jp      z, zRestTrack                   ; Put PSG track at rest if needed

                .skip_fill:
                call    zUpdateFreq                     ; Add frequency displacement to frequency
                call    zDoModulation                   ; Do modulation
                bit     2, (ix+zTrack.PlaybackControl)  ; Is SFX overriding this track?
                ret     nz                              ; Return if yes
                ld      c, (ix+zTrack.VoiceControl)     ; c = voice control byte
                ld      a, l                            ; a = low byte of new frequency
                and     0Fh                             ; Get only lower nibble
                or      c                               ; OR in PSG channel bits
                ld      (zPSG), a                       ; Send to PSG, latching register
                ld      a, l                            ; a = low byte of new frequency
                and     0F0h                            ; Get high nibble now
                or      h                               ; OR in the high byte of the new frequency
; Swap nibbles
                rrca
                rrca
                rrca
                rrca
                ld      (zPSG), a                       ; Send to PSG, to latched register
                ld      a, (ix+zTrack.VoiceIndex)       ; Get PSG tone
                or      a                               ; Test if it is zero
                ld      c, 0                            ; c = 0
                jr      z, .no_volenv                   ; Branch if no PSG tone
                dec     a                               ; Make it into a 0-based index
                ld      c, zID_VolEnvPointers           ; Value for volume envelope pointer table
                rst     GetPointerTable                 ; hl = pointer to volume envelope table
                rst     PointerTableOffset              ; hl = pointer to volume envelope for track
                call    zDoVolEnv                       ; Get new volume envelope
                ld      c, a                            ; c = new volume envelope

                .no_volenv:
                bit     4, (ix+zTrack.PlaybackControl)  ; Is track resting?
                ret     nz                              ; Return if yes
                ld      a, (ix+zTrack.Volume)           ; Get track volume
                add     a, c                            ; Add volume envelope to it
                bit     4, a                            ; Is bit 4 set?
                jr      z, .no_underflow                ; Branch if not
                ld      a, 0Fh                          ; Set silence on PSG track

                .no_underflow:
                or      (ix+zTrack.VoiceControl)        ; Mask in the PSG channel bits
                add     a, 10h                          ; Flag to latch volume
                bit     0, (ix+zTrack.PlaybackControl)  ; Is this a noise channel?
                jr      nz, .set_noise                  ; Branch if yes
                ld      (zPSG), a                       ; Set PSG volume
                ret
; ---------------------------------------------------------------------------
                .set_noise:
                add     a, 20h                          ; Change to noise channel
                ld      (zPSG), a                       ; Set noise channel volume
                ret
; ---------------------------------------------------------------------------
; loc_1037
; zDoFlutterSetValue
zDoVolEnvSetValue:
                ld      (ix+zTrack.VolEnv), a           ; Set new value for PSG envelope index and fall through

; =============== S U B R O U T I N E =======================================
; Get next PSG volume envelope value
;
; Input:   ix    Pointer to track RAM
; hl    Pointer to current PSG volume envelope
; Output:  a     New volume envelope value
; bc    Trashed
;
; sub_103A
; zDoFlutter
zDoVolEnv:
                push    hl                              ; Save hl
                ld      c, (ix+zTrack.VolEnv)           ; Get current PSG envelope index
                ld      b, 0                            ; b = 0
                add     hl, bc                          ; Offset into PSG envelope table
                ld      a, (hl)                         ; a = PSG flutter value
                pop     hl                              ; Restore hl
                bit     7, a                            ; Is it a terminator?
                jr      z, zDoVolEnvAdvance             ; Branch if not
                cp      83h                             ; Is it a command to put PSG channel to rest?
                jr      z, zDoVolEnvFullRest            ; Branch if yes
                cp      81h                             ; Is it a command to set rest flag on PSG channel?
                jr      z, zDoVolEnvRest                ; Branch if yes
                cp      80h                             ; Is it a command to reset envelope?
                jr      z, zDoVolEnvReset               ; Branch if yes

                inc     bc                              ; Increment envelope index
; DANGER! Will read data from code segment and use it as if it were valid!
; In order to get here, the flutter value would have to be:
; (1) negative;
; (2) not 80h, 81h or 83h
; VolEnv_0B contains such a value, but luckily isn't used by any songs or sounds
                ld      a, (bc)                         ; Get value from wherever the hell bc is pointing to
                jr      zDoVolEnvSetValue               ; Use this as new envelope index
; ---------------------------------------------------------------------------
; loc_1057
; zDoFlutterFullRest
zDoVolEnvFullRest:
                set     4, (ix+zTrack.PlaybackControl)  ; Set 'track is resting' bit (zRestTrack already does this)
                pop     hl                              ; Pop return value from stack (causes a 'ret' to return to caller of zUpdatePSGTrack)
                jp      zRestTrack                      ; Put track at rest
; ---------------------------------------------------------------------------
; loc_105F
; zDoFlutterReset
zDoVolEnvReset:
                xor     a                               ; a = 0
                jr      zDoVolEnvSetValue
; ---------------------------------------------------------------------------
; loc_1062
; zDoFlutterRest
zDoVolEnvRest:
                pop     hl                              ; Pop return value from stack (causes a 'ret' to return to caller of zUpdatePSGTrack)
                set     4, (ix+zTrack.PlaybackControl)  ; Set 'track is resting' bit
                ret                                     ; Do NOT silence PSG channel
; ---------------------------------------------------------------------------
; loc_1068
; zDoFlutterAdvance
zDoVolEnvAdvance:
                inc     (ix+zTrack.VolEnv)              ; Advance envelope
                ret
; End of function zDoVolEnv

; =============== S U B R O U T I N E =======================================
;
; sub_106C
zRestTrack:
                set     4, (ix+zTrack.PlaybackControl)  ; Set 'track is resting' bit
                bit     2, (ix+zTrack.PlaybackControl)  ; Is SFX overriding this track?
                ret     nz                              ; Return if so
; End of function zRestTrack

; =============== S U B R O U T I N E =======================================
;
; sub_1075
zSilencePSGChannel:
                ld      a, 1Fh                          ; Set volume to zero on PSG channel
                add     a, (ix+zTrack.VoiceControl)     ; Add in the PSG channel selector
                or      a                               ; Is it an actual PSG channel?
                ret     p                               ; Return if not
                ld      (zPSG), a                       ; Silence this channel
; This does not work as intended: since this function is called when
; a new channel is starting, this bit will almost inevitably be 0
; and the noise channel will not be silenced
                bit     0, (ix+zTrack.PlaybackControl)  ; Is this a noise channel?
                ret     z                               ; Return if not
                ld      a, 0FFh                         ; Command to silence Noise channel
                ld      (zPSG), a                       ; Do it
                ret
; End of function zSilencePSGChannel

; =============== S U B R O U T I N E =======================================
;
; Plays digital audio on the DAC, if any is queued. The z80 will be stuck in
; this function unless an interrupt occurs (that is, V-Int); after the V-Int
; is processed, the z80 will return back here
; loc_108A
