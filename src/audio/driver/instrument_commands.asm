; Coordination commands for volume, transposition and instrument upload
; Original driver statements retain their assembly order

                CPU     Z80
                listing purecode
cfSpindashRev:
                ld      hl, zSpindashRev                ; hl = pointer to escalating transposition
                ld      a, (hl)                         ; a = value of escalating transposition
                add     a, (ix+zTrack.Transpose)        ; Add in current track transposition
                ld      (ix+zTrack.Transpose), a        ; Store result as new track transposition
                cp      10h                             ; Is the current transposition 10h?
                jp      z, .skip_rev                    ; Branch if yes
                inc     (hl)                            ; Otherwise, increase escalating transposition

                .skip_rev:
                dec     de                              ; Put parameter byte back
                ret
; End of function cfSpindashRev

; =============== S U B R O U T I N E =======================================
; Sets frequency displacement (signed). The final note frequency is shifted
; by this value
;
; Has one parameter byte, the new frequency displacement
;
; sub_C77 cfAlterNoteFreq
cfDetune:
                ld      (ix+zTrack.Detune), a           ; Set detune
                ret
; End of function cfDetune

; =============== S U B R O U T I N E =======================================
; Fade in to previous song
;
; Has one parameter byte. If the parameter byte if FFh, the engine will fade
; to the previous song. If the parameter byte is equal to 29h (1-Up ID - 1),
; the driver will prevent new music or SFX from playing as long as the 1-Up
; music is playing (but will not clear the M68K queue). For all other values,
; the queue will work as normal, but no fade-in will be done
;
; sub_C7B
cfFadeInToPrevious:
                ld      (zFadeToPrevFlag), a
                ret
; End of function cfFadeInToPrevious

; =============== S U B R O U T I N E =======================================
; Silences FM channel and stops track. Expanded form of coord. flag 0F2h
;
; Technically, it has a parameter byte, but it is irrelevant and unused
;
; loc_C7F
cfSilenceStopTrack:
                call    zFMSilenceChannel
                jp      cfStopTrack
; End of function cfSilenceStopTrack

; =============== S U B R O U T I N E =======================================
; Sets track volume
;
; Has one parameter byte, the volume
;
; For FM tracks, this is a 7-bit value from 0 (lowest volume) to 127 (highest
; volume). The value is XOR'ed with 7Fh before being sent, then stripped of the
; sign bit. The volume change takes effect immediately
;
; For PSG tracks, this is a 4-bit value ranging from 8 (lowest volume) to 78h
; (highest volume). The value is shifted 3 bits to the right, XOR'ed with 0Fh
; and AND'ed with 0Fh before being uploaded, so the sign bit and the lower 3
; bits are discarded
;
; loc_C85
cfSetVolume:
                bit     7, (ix+zTrack.VoiceControl)     ; Is this a PSG channel?
                jr      z, .not_psg                     ; Branch if not
; The following code gets bits 3, 4, 5 and 6 from the parameter byte,
; puts them in positions 0 to 3 and inverts them, discarding all other
; bits in the parameter byte
; Shift the parameter byte 3 bits to the right
                srl     a
                srl     a
                srl     a
                xor     0Fh                             ; Invert lower nibble's bits
                and     0Fh                             ; Clear out high nibble
                jp      zStoreTrackVolume
; ---------------------------------------------------------------------------
                .not_psg:
                xor     7Fh                             ; Invert parameter byte (except irrelevant sign bit)
                and     7Fh                             ; Strip sign bit
                ld      (ix+zTrack.Volume), a           ; Set as new track volume
                jr      zSendTL                         ; Begin using new volume immediately

; =============== S U B R O U T I N E =======================================
; Change track volume for a FM track
;
; Has two parameter bytes: the first byte is ignored, the second is the signed
; change in volume. Positive lowers volume, negative increases it
;
; loc_CA1
cfChangeVolume2:
                inc     de                              ; Advance pointer
; Other drivers feature these two lines, causing the first parameter
; to be used by PSG tracks. In this driver, it is instead completely unused
; add a,(ix+zTrack.Volume)
; ld (ix+zTrack.Volume),a
                ld      a, (de)                         ; Get change in volume then fall-through

; =============== S U B R O U T I N E =======================================
; Change track volume for a FM track
;
; Has one parameter byte, the signed change in volume. Positive lowers volume,
; negative increases it
;
; loc_CA3
cfChangeVolume:
; S2 places this check further down (and S1 lacks it altogether),
; allowing PSG channels to change their volume. This means the
; likes of S2's SFX $F0 will sound different in this driver
                bit     7, (ix+zTrack.VoiceControl)     ; Is this a PSG track?
                ret     nz                              ; Return if yes
                add     a, (ix+zTrack.Volume)           ; Add in track's current volume
                jp      p, .set_vol                     ; Branch if result is still positive
                jp      pe, .underflow                  ; Branch if addition overflowed into more than 127 positive
                xor     a                               ; Set maximum volume
                jp      .set_vol
; ---------------------------------------------------------------------------
                .underflow:
                ld      a, 7Fh                          ; Set minimum volume

                .set_vol:
                ld      (ix+zTrack.Volume), a           ; Store new volume

; =============== S U B R O U T I N E =======================================
; Subroutine to send TL information to YM2612
;
; sub_CBA
zSendTL:
                push    de                              ; Save de
                ld      de, zFMInstrumentTLTable        ; de = pointer to FM TL register table
                ld      l, (ix+zTrack.TLPtrLow)         ; l = low byte of pointer to instrument's TL data
                ld      h, (ix+zTrack.TLPtrHigh)        ; h = high byte of pointer to instrument's TL data
                ld      b, zFMInstrumentTLTable_End-zFMInstrumentTLTable  ; Number of entries

                .loop:
                ld      a, (hl)                         ; a = register data
                or      a                               ; Is it positive?
                jp      p, .skip_track_vol              ; Branch if yes
                add     a, (ix+zTrack.Volume)           ; Add track's volume to it

                .skip_track_vol:
; Not actually needed
                and     7Fh                             ; Strip sign bit
                ld      c, a                            ; c = new volume for operator
                ld      a, (de)                         ; a = register write command
                call    zWriteFMIorII                   ; Send it to YM2612
                inc     de                              ; Advance pointer
                inc     hl                              ; Advance pointer
                djnz    .loop                           ; Loop

                pop     de                              ; Restore de
                ret
; End of function zSendTL

; =============== S U B R O U T I N E =======================================
; Prevents next note from attacking
;
; Has no parameter bytes
;
; loc_CDB
cfPreventAttack:
                set     1, (ix+zTrack.PlaybackControl)  ; Set flag to prevent attack
                dec     de                              ; Put parameter byte back
                ret

; =============== S U B R O U T I N E =======================================
; Sets the note fill
;
; Has one parameter byte, the new note fill. This value is multiplied by the
; tempo divider, and so may overflow
;
; loc_CE1
cfNoteFill:
                call    zComputeNoteDuration            ; Multiply note fill by tempo divider
                ld      (ix+zTrack.NoteFillTimeout), a  ; Store result into note fill timeout
                ld      (ix+zTrack.NoteFillMaster), a   ; Store master copy of note fill
                ret

; =============== S U B R O U T I N E =======================================
; Jump timeout. Shares the same loop counters as coord. flag 0E7h, so it has
; to be coordinated with these. Each time this coord. flag is encountered, it
; tests if the associated loop counter is 1. If it is, it will jump to the
; target location and the loop counter will be set to zero; otherwise, nothing
; happens
;
; Has 3 parameter bytes: a loop counter index (identical to that of coord. flag
; 0E7h), and a 2-byte jump target
;
; loc_CEB
cfConditionalJump:
                inc     de                              ; Advance track pointer
                add     a, zTrack.LoopCounters          ; Add offset into loop counters
                ld      c, a                            ; c = offset of current loop counter
                ld      b, 0                            ; bc = sign-extended offset to current loop counter
                push    ix                              ; Save track RAM pointer
                pop     hl                              ; hl = pointer to track RAM
                add     hl, bc                          ; hl = pointer in RAM to current loop counter
                ld      a, (hl)                         ; a = value of current loop counter
                dec     a                               ; Decrement loop counter (note: value is not saved!)
                jp      z, .do_jump                     ; Branch if result is zero
                inc     de                              ; Skip another byte
                ret
; ---------------------------------------------------------------------------
                .do_jump:
                xor     a                               ; a = 0
                ld      (hl), a                         ; Clear loop counter
                jp      cfJumpTo

; =============== S U B R O U T I N E =======================================
; Change PSG volume. Has no effect on FM or DAC channels
;
; Has one parameter byte, the change in volume. The value is signed, but any
; result greater than 0Fh (or lower than 0) will result in no output
;
; loc_D01
cfChangePSGVolume:
                bit     7, (ix+zTrack.VoiceControl)     ; Is this a PSG channel?
                ret     z                               ; Return if not
                res     4, (ix+zTrack.PlaybackControl)  ; Clear 'track is resting' flag
                dec     (ix+zTrack.VolEnv)              ; Decrement envelope index
                add     a, (ix+zTrack.Volume)           ; Add track's current volume
                cp      0Fh                             ; Is it 0Fh or more?
                jp      c, zStoreTrackVolume            ; Branch if not
                ld      a, 0Fh                          ; Limit to 0Fh (silence)

; loc_D17
zStoreTrackVolume:
                ld      (ix+zTrack.Volume), a           ; Store new volume
                ret

; =============== S U B R O U T I N E =======================================
; Changes the track's key displacement
;
; There is a single parameter byte, the new track key offset + 40h (that is,
; 40h is subtracted from the parameter byte before the key displacement is set)
;
; loc_D1B
cfSetKey:
                sub     40h                             ; Subtract 40h from key displacement
                ld      (ix+zTrack.Transpose), a        ; Store result as new transposition
                ret

; =============== S U B R O U T I N E =======================================
; Sends an FM command to the YM2612. The command is sent to part I, so not all
; registers can be set using this coord. flag (in particular, channels FM4,
; FM5 and FM6 cannot (in general) be affected)
;
; Has 2 parameter bytes: a 1-byte register selector and a 1-byte register data
;
; loc_D21
cfSendFMI:
                call    zGetFMParams                    ; Get parameters for FM command
                call    zWriteFMI                       ; Send it to YM2612
                ret

; loc_D28
zGetFMParams:
                ex      de, hl                          ; Exchange de and hl
                ld      a, (hl)                         ; Get YM2612 register selector
                inc     hl                              ; Advance pointer
                ld      c, (hl)                         ; Get YM2612 register data
                ex      de, hl                          ; Exchange back de and hl
                ret
; End of function cfSendFMI

; =============== S U B R O U T I N E =======================================
; Change current instrument (FM), tone (PSG) or sample (DAC)
;
; Has either a single positive parameter byte or a pair of parameter bytes of
; which the first is negative
;
; If positive, the first parameter byte is the index of voice to use
;
; If negative, and on a PSG track, then the first parameter byte is the index
; of voice to use while the second parameter byte is ignored
;
; If negative and on a FM or DAC track, the first parameter byte is 80h + index
; of voice to use, while the second parameter byte is 7Fh + index of song whose
; voice bank is to be used (here, the AIZ1 song is index 1, not zero)
;
; The uploading of an FM instrument is irrelevant for the DAC
;
; loc_D2E
cfSetVoice:
                bit     7, (ix+zTrack.VoiceControl)     ; Is this a PSG track?
                jr      nz, zSetVoicePSG                ; Branch if yes
                call    zSetMaxRelRate                  ; Set minimum D1L/RR for channel
                ld      a, (de)                         ; Get voice index
                ld      (ix+zTrack.VoiceIndex), a       ; Store to track RAM
                or      a                               ; Is it negative?
                jp      p, zSetVoiceUpload              ; Branch if not
                inc     de                              ; Advance pointer
                ld      a, (de)                         ; Get song ID whose bank is desired
                ld      (ix+zTrack.VoiceSongID), a      ; Store to track RAM and fall-through

; =============== S U B R O U T I N E =======================================
; Uploads the FM instrument from another song's voice bank
;
; sub_D44
zSetVoiceUploadAlter:
                push    de                              ; Save de
                ld      a, (ix+zTrack.VoiceSongID)      ; Get saved song ID for instrument data
                sub     81h                             ; Convert it to a zero-based index
                ld      c, zID_MusicPointers            ; Value for music pointer table
                rst     GetPointerTable                 ; hl = pointer to music pointer table
                rst     PointerTableOffset              ; hl = pointer to music data
                rst     ReadPointer                     ; hl = pointer to music voice data
                ld      a, (ix+zTrack.VoiceIndex)       ; Get voice index
                and     7Fh                             ; Strip sign bit
                ld      b, a                            ; b = voice index
                call    zGetFMInstrumentOffset          ; hl = pointer to voice data
                jr      zSetVoiceDoUpload
; ---------------------------------------------------------------------------
; loc_D5A
zSetVoiceUpload:
                push    de                              ; Save de
                ld      b, a                            ; b = instrument index
                call    zGetFMInstrumentPointer         ; hl = pointer to instrument data

zSetVoiceDoUpload:
                call    zSendFMInstrument               ; Upload instrument data to YM2612
                pop     de                              ; Restore de
                ret
; End of function cfSetVoice
; ---------------------------------------------------------------------------
; loc_D64:
zSetVoicePSG:
                or      a                               ; Is the voice index positive?
                jp      p, cfStoreNewVoice              ; Branch if yes
                inc     de                              ; Otherwise, advance song data pointer
                jp      cfStoreNewVoice
; ---------------------------------------------------------------------------
                ret                                     ; Dead code

; =============== S U B R O U T I N E =======================================
; Turns on modulation on the channel
;
; Has four 1-byte parameters: delay before modulation starts, modulation speed,
; modulation change per step, number of steps in modulation
;
; loc_D6D
