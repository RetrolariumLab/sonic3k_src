; Music tick scheduling, track decoding, frequency and note duration updates
; Original driver statements retain their assembly order

                CPU     Z80
                listing purecode
zUpdateEverything:
                call    zPauseUnpause                   ; Pause/unpause according to M68K input
                call    zUpdateSFXTracks                ; Do SFX tracks

; loc_121
zUpdateMusic:
                call    TempoWait                       ; Delay song tracks as appropriate for main tempo mod
                call    zDoMusicFadeOut                 ; Check if music should be faded out and fade if needed
                call    zDoMusicFadeIn                  ; Check if music should be faded in and fade if needed
                ld      a, (zFadeToPrevFlag)            ; Get fade-to-prev flag
                cp      mus_ExtraLife-mus__First        ; Is it still 1-Up?
                jr      nz, .check_fade_in              ; Branch if not
                ld      a, (zMusicNumber)               ; Get next music to play
                cp      mus_ExtraLife                   ; Is it another 1-Up?
                jr      z, .clr_queue                   ; Branch if yes
                cp      mus__End-mus__First             ; Is it music (except credits song)?
                jr      c, .clr_sfx                     ; Branch if not

                .clr_queue:
                xor     a                               ; a = 0
                ld      (zMusicNumber), a               ; Clear queue entry

                .clr_sfx:
                xor     a                               ; a = 0
                ld      (zSFXNumber0), a                ; Clear first queued SFX
                ld      (zSFXNumber1), a                ; Clear second queued SFX
                jr      .update_music

; loc_149
                .check_fade_in:
; Redundant; 'a' already holds this value
                ld      a, (zFadeToPrevFlag)            ; Get fade-to-previous flag
                cp      0FFh                            ; Is it 0FFh?
                jr      z, .update_music                ; Branch if yes
                ld      hl, zMusicNumber                ; Point hl to M68K input
                ld      e, (hl)                         ; e = next song to play
                inc     hl                              ; Advance pointer
                ld      d, (hl)                         ; d = next SFX to play
                inc     hl                              ; Advance pointer
                ld      a, (hl)                         ; a = next SFX to play
                or      d                               ; Combine bits of a and d
                or      e                               ; Is anything in the play queue?
                jr      z, .update_music                ; Branch if not
                call    zFillSoundQueue                 ; Transfer M68K input
                call    zCycleSoundQueue                ; Cycle queue and play first entry
                call    zCycleSoundQueue                ; Cycle queue and play second entry
                call    zCycleSoundQueue                ; Cycle queue and play third entry

                .update_music:
                if      SonicDriverVer==3
                ld      hl, zBankRegister
                ld      a, (zSongBank)                  ; Get bank ID for music
                bankswitchToMusicS3
                else
                ld      a, (zSongBank)                  ; Get bank ID for music
                bankswitch2                             ; Bank switch to it
                endif
                xor     a                               ; a = 0
                ld      (zUpdatingSFX), a               ; Updating music
                ld      a, (zFadeToPrevFlag)            ; Get fade-to-previous flag
                cp      0FFh                            ; Is it 0FFh?
                call    z, zFadeInToPrevious            ; Fade to previous if yes
                ld      ix, zSongFM6_DAC                ; ix = FM6/DAC track RAM
                bit     7, (ix+zTrack.PlaybackControl)  ; Is FM6/DAC track playing?
                call    nz, zUpdateDACTrack             ; Branch if yes
                ld      b, (zTracksEnd-zSongFM1)/zTrack.len  ; Number of tracks
                ld      ix, zSongFM1                    ; ix = FM1 track RAM
                jr      zTrackUpdLoop                   ; Play all tracks

; =============== S U B R O U T I N E =======================================
;
; sub_19E
zUpdateSFXTracks:
                ld      a, 1                            ; a = 1
                ld      (zUpdatingSFX), a               ; Updating SFX
                bankswitchToSFX
                ld      ix, zTracksSFXStart             ; ix = start of SFX track RAM
                ld      b, (zTracksSFXEnd-zTracksSFXStart)/zTrack.len  ; Number of channels

zTrackUpdLoop:
                push    bc                              ; Save bc
                bit     7, (ix+zTrack.PlaybackControl)  ; Is track playing?
                call    nz, zUpdateFMorPSGTrack         ; Call routine if yes
                ld      de, zTrack.len                  ; Spacing between tracks
                add     ix, de                          ; Advance to next track
                pop     bc                              ; Restore bc
                djnz    zTrackUpdLoop                   ; Loop for all tracks

; This code is ran by both zUpdateSFXTracks and zUpdateMusic,
; causing it to execute multiple times per frame
                ld      a, (zTempoSpeedup)              ; Get tempo speed-up value
                or      a                               ; Is music sped up?
                ret     z                               ; Return if not
                ld      a, (zSpeedupTimeout)            ; Get extra tempo timeout
                or      a                               ; Has it expired?
                jp      nz, .no_dbl_update              ; Branch if not
                ld      a, (zTempoSpeedup)              ; Get master tempo speed-up value
                ld      (zSpeedupTimeout), a            ; Reset extra tempo timeout to it
                jp      zUpdateMusic                    ; Update music again
; ---------------------------------------------------------------------------
                .no_dbl_update:
                dec     a                               ; Decrement timeout
                ld      (zSpeedupTimeout), a            ; ... then store new value
                ret
; End of function zUpdateSFXTracks

; =============== S U B R O U T I N E =======================================
; Updates FM or PSG track
;
; sub_1E9
zUpdateFMorPSGTrack:
                bit     7, (ix+zTrack.VoiceControl)     ; Is this a PSG channel?
                jp      nz, zUpdatePSGTrack             ; Branch if yes
                call    zTrackRunTimer                  ; Run note timer
                jr      nz, .note_going                 ; Branch if note hasn't expired yet
                call    zGetNextNote                    ; Get next note for FM track
                bit     4, (ix+zTrack.PlaybackControl)  ; Is track resting?
                ret     nz                              ; Return if yes
                call    zPrepareModulation              ; Initialize modulation
                call    zUpdateFreq                     ; Add frequency displacement to frequency
                call    zDoModulation                   ; Apply modulation
                call    zFMSendFreq                     ; Send frequency to YM2612
                jp      zFMNoteOn                       ; Note on on all operators
; ---------------------------------------------------------------------------
                .note_going:
                bit     4, (ix+zTrack.PlaybackControl)  ; Is track resting?
                ret     nz                              ; Return if yes
                call    zDoFMVolEnv                     ; Do FM volume envelope effects for track
                ld      a, (ix+zTrack.NoteFillTimeout)  ; Get note fill timeout
                or      a                               ; Is timeout either not running or expired?
                jr      z, .keep_going                  ; Branch if yes
                dec     (ix+zTrack.NoteFillTimeout)     ; Update note fill timeout
                jp      z, zKeyOffIfActive              ; Send key off if needed

                .keep_going:
                call    zUpdateFreq                     ; Add frequency displacement to frequency
                bit     6, (ix+zTrack.PlaybackControl)  ; Is 'sustain frequency' bit set?
                ret     nz                              ; Return if yes
                call    zDoModulation                   ; Apply modulation then fall through
; Fall through to next function
; End of function zUpdateFMorPSGTrack

; =============== S U B R O U T I N E =======================================
; Uploads track's frequency to YM2612
;
; Input:   ix    Pointer to track RAM
; hl    Frequency to upload
; de    For FM3 in special mode, pointer to extra FM3 frequency data (never correctly set)
; Output:  a     Trashed
; bc    Trashed
; hl    Trashed
; de    Increased by 8
;
; sub_22B
zFMSendFreq:
                bit     2, (ix+zTrack.PlaybackControl)  ; Is SFX overriding this track?
                ret     nz                              ; Return if yes
                bit     0, (ix+zTrack.PlaybackControl)  ; Is track in special mode (FM3 only)?
                jp      nz, .special_mode               ; Branch if yes

                .not_fm3:
                ld      a, 0A4h                         ; Command to update frequency MSB
                ld      c, h                            ; High byte of frequency
                call    zWriteFMIorII                   ; Send it to YM2612
                ld      a, 0A0h                         ; Command to update frequency LSB
                ld      c, l                            ; Low byte of frequency
                call    zWriteFMIorII                   ; Send it to YM2612
                ret
; ---------------------------------------------------------------------------
                .special_mode:
                ld      a, (ix+zTrack.VoiceControl)     ; a = voice control byte
                cp      2                               ; Is this FM3?
                jr      nz, .not_fm3                    ; Branch if not
                ld      b, zSpecialFreqCommands_End-zSpecialFreqCommands  ; Number of entries
                ld      hl, zSpecialFreqCommands        ; Lookup table

; DANGER! de is unset here, and could be pointing anywhere! Luckily,
; only reads are performed from it
                .loop:
                push    bc                              ; Save bc
                ld      a, (hl)                         ; a = register selector
                inc     hl                              ; Advance pointer
                push    hl                              ; Save hl
                ex      de, hl                          ; Exchange de and hl
                ld      c, (hl)                         ; Get byte from whatever the hell de was pointing to
                inc     hl                              ; Advance pointer
                ld      b, (hl)                         ; Get byte from whatever the hell de was pointing to
                inc     hl                              ; Advance pointer
                ex      de, hl                          ; Exchange de and hl
                ld      l, (ix+zTrack.FreqLow)          ; l = low byte of track frequency
                ld      h, (ix+zTrack.FreqHigh)         ; h = high byte of track frequency
                add     hl, bc                          ; hl = full frequency for operator
                push    af                              ; Save af
                ld      c, h                            ; High byte of frequency
                call    zWriteFMI                       ; Sent it to YM2612
                pop     af                              ; Restore af
                sub     4                               ; Move on to frequency LSB
                ld      c, l                            ; Low byte of frequency
                call    zWriteFMI                       ; Sent it to YM2612
                pop     hl                              ; Restore hl
                pop     bc                              ; Restore bc
                djnz    .loop                           ; Loop for all operators
                ret
; End of function zFMSendFreq

; ---------------------------------------------------------------------------
; loc_272
zSpecialFreqCommands:
                db      0ADh                            ; Operator 4 frequency MSB
                db      0AEh                            ; Operator 3 frequency MSB
                db      0ACh                            ; Operator 2 frequency MSB
                db      0A6h                            ; Operator 1 frequency MSB
zSpecialFreqCommands_End:

; =============== S U B R O U T I N E =======================================
;
zGetSpecialFM3DataPointer:
                ret
; End of function zGetSpecialFM3DataPointer

; =============== S U B R O U T I N E =======================================
; Gets next note from the track's data stream. If any coordination flags are
; found, they are handled and then the function keeps looping until a note is
; found
;
; Input:   ix    Pointer to track's RAM
; Output:  de    Pointer to current position on track data
; hl    Note frequency
; All others possibly trashed due to coordination flags
;
; sub_277
zGetNextNote:
                ld      e, (ix+zTrack.DataPointerLow)   ; e = low byte of track data pointer
                ld      d, (ix+zTrack.DataPointerHigh)  ; d = high byte of track data pointer
                res     1, (ix+zTrack.PlaybackControl)  ; Clear 'do not attack next note' flag
                res     4, (ix+zTrack.PlaybackControl)  ; Clear 'track is at rest' flag

; loc_285
zGetNextNote_cont:
                ld      a, (de)                         ; Get next byte from track
                inc     de                              ; Advance pointer
                cp      FirstCoordFlag                  ; Is it a coordination flag?
                jp      nc, zHandleFMorPSGCoordFlag     ; Branch if yes
                ex      af, af'                         ; Save af
                call    zKeyOffIfActive                 ; Kill note
                ex      af, af'                         ; Restore af
                bit     3, (ix+zTrack.PlaybackControl)  ; Is alternate frequency mode flag set?
                jp      nz, zAltFreqMode                ; Branch if yes
                or      a                               ; Is this a duration?
                jp      p, zStoreDuration               ; Branch if yes
                sub     81h                             ; Make the note into a 0-based index
                jp      p, .got_note                    ; Branch if it is a note and not a rest
                call    zRestTrack                      ; Put track at rest
                jr      zGetNoteDuration
; ---------------------------------------------------------------------------
                .got_note:
                add     a, (ix+zTrack.Transpose)        ; Add in transposition
                ld      hl, zPSGFrequencies             ; PSG frequency lookup table
                push    af                              ; Save af
                rst     PointerTableOffset              ; hl = frequency value for note
                pop     af                              ; Restore af
                bit     7, (ix+zTrack.VoiceControl)     ; Is this a PSG track?
                jr      nz, zGotNoteFreq                ; Branch if yes
                push    de                              ; Save de
                ld      d, 8                            ; Each octave above the first adds this to frequency high bits
                ld      e, 0Ch                          ; 12 notes per octave
                ex      af, af'                         ; Exchange af with af'
                xor     a                               ; Clear a (which will clear a')

                .loop:
                ex      af, af'                         ; Exchange af with af'
                sub     e                               ; Subtract 1 octave from the note
                jr      c, .got_displacement            ; If this is less than zero, we are done
                ex      af, af'                         ; Exchange af with af'
                add     a, d                            ; One octave up
                jr      .loop                           ; Loop
; ---------------------------------------------------------------------------
                ex      af, af'                         ; Exchange af with af' (dead code)
; ---------------------------------------------------------------------------
                .got_displacement:
                add     a, e                            ; Add 1 octave back (so note index is positive)
                ld      hl, zFMFrequencies              ; FM first octave frequency lookup table
                rst     PointerTableOffset              ; hl = frequency of the note on the first octave
                ex      af, af'                         ; Exchange af with af'
                or      h                               ; a = high bits of frequency (including octave bits, which were in a)
                ld      h, a                            ; h = high bits of frequency (including octave bits)
                pop     de                              ; Restore de

; loc_2CE
zGotNoteFreq:
                ld      (ix+zTrack.FreqLow), l          ; Store low byte of note frequency
                ld      (ix+zTrack.FreqHigh), h         ; Store high byte of note frequency

; loc_2D4
zGetNoteDuration:
                ld      a, (de)                         ; Get duration from the track
                or      a                               ; Is it an actual duration?
                jp      p, zGotNoteDuration             ; Branch if yes
                ld      a, (ix+zTrack.SavedDuration)    ; Get saved duration (zFinishTrackUpdate should do it...)
                ld      (ix+zTrack.DurationTimeout), a  ; Set it as next timeout duration (zFinishTrackUpdate should do it...)
                jr      zFinishTrackUpdate
; ---------------------------------------------------------------------------
zApplyPitchSlide:
; Unused/dead code in S3/S&K/S3D; this is code for pitch slides
; in the Battletoads sound driver
                ld      a, (de)                         ; Get new pitch slide value from track
                inc     de                              ; Advance pointer
                ld      (ix+zTrack.Unk11h), a           ; Store pitch slide
                jr      zGetRawDuration
; ---------------------------------------------------------------------------
; loc_2E8
; zAlternateSMPS
zAltFreqMode:
; Setting bit 3 on zTrack.PlaybackControl puts the song in a weird mode
;
; This weird mode has literal frequencies and durations on the track
; Each byte on the track is either a coordination flag (0E0h to 0FFh) or
; the high byte of a frequency. For the latter case, the following byte
; is then the low byte of this same frequency
; If the frequency is nonzero, the (sign extended) key displacement is
; simply *added* to this frequency
; After the frequency, there is then a byte that is unused
; Finally, there is a raw duration byte following
;
; To put the track in this mode, coord. flag 0FDh can be used; if the
; parameter byte is 1, the mode is toggled on. To turn the mode off,
; coord. flag 0FDh can be used with a parameter != 1
                ld      h, a                            ; h = byte from track
                ld      a, (de)                         ; a = next byte from track
                inc     de                              ; Advance pointer
                ld      l, a                            ; l = last byte read from track
                or      h                               ; Is hl nonzero?
                jr      z, .got_zero                    ; Branch if not
                ld      a, (ix+zTrack.Transpose)        ; a = transposition
                ld      b, 0                            ; b = 0
                or      a                               ; Is a negative?
                jp      p, .did_sign_extend             ; Branch if not
                dec     b                               ; Set b to -1

                .did_sign_extend:
                ld      c, a                            ; bc = sign extension of key displacement
                add     hl, bc                          ; hl += key displacement

                .got_zero:
                ld      (ix+zTrack.FreqLow), l          ; Store low byte of note frequency
                ld      (ix+zTrack.FreqHigh), h         ; Store high byte of note frequency
                ld      a, (de)                         ; Get pitch slide value from the track
                inc     de                              ; Advance to next byte in track
                ld      (ix+zTrack.Unk11h), a           ; Store pitch slide
; loc_306
zGetRawDuration:
                ld      a, (de)                         ; Get raw duration from track

; loc_307
zGotNoteDuration:
                inc     de                              ; Advance to next byte in track

; loc_308
zStoreDuration:
                call    zComputeNoteDuration            ; Multiply note by tempo divider
                ld      (ix+zTrack.SavedDuration), a    ; Store it for next note

; loc_30E
zFinishTrackUpdate:
                ld      (ix+zTrack.DataPointerLow), e   ; Save low byte of current location in song
                ld      (ix+zTrack.DataPointerHigh), d  ; Save high byte of current location in song
                ld      a, (ix+zTrack.SavedDuration)    ; Get current saved duration
                ld      (ix+zTrack.DurationTimeout), a  ; Set it as duration timeout
                bit     1, (ix+zTrack.PlaybackControl)  ; Is 'do not attack next note' flag set?
                ret     nz                              ; Return if yes
                xor     a                               ; Clear a
                ld      (ix+zTrack.ModEnvIndex), a      ; Clear modulation envelope index
                ld      (ix+zTrack.ModEnvSens), a       ; Clear modulation envelope multiplier
                ld      (ix+zTrack.VolEnv), a           ; Reset volume envelope
                ld      a, (ix+zTrack.NoteFillMaster)   ; Get master note fill
                ld      (ix+zTrack.NoteFillTimeout), a  ; Set note fill timeout
                ret
; End of function zGetNextNote

; =============== S U B R O U T I N E =======================================
; This routine multiplies the note duration by the tempo divider. This can
; easily overflow, as the result is stored in a byte
;
; Input:   a    Note duration
; Output:  a    Final note duration
; b    zero
; c    Damaged
; sub_330
zComputeNoteDuration:
                ld      b, (ix+zTrack.TempoDivider)     ; Get tempo divider for this track
                dec     b                               ; Make it into a loop counter
                ret     z                               ; Return if it was 1
                ld      c, a                            ; c = a

                .loop:
                add     a, c                            ; a += c
                djnz    .loop                           ; Loop
                ret
; End of function zComputeNoteDuration

; =============== S U B R O U T I N E =======================================
; Reduces note duration timeout for current track
;
; Input:   ix   Track data
; Output:  a    New duration
; sub_33A
zTrackRunTimer:
; This is absurdly inefficient, since 'dec' can be ran directly on memory
                ld      a, (ix+zTrack.DurationTimeout)  ; Get track duration timeout
                dec     a                               ; Decrement it
                ld      (ix+zTrack.DurationTimeout), a  ; ... and save new value
                ret
; End of function zTrackRunTimer

; ---------------------------------------------------------------------------
; loc_342
zFMNoteOn:
                ld      a, (ix+zTrack.FreqLow)          ; Get low byte of note frequency
                or      (ix+zTrack.FreqHigh)            ; Is the note frequency zero?
                ret     z                               ; Return if yes
                ld      a, (ix+zTrack.PlaybackControl)  ; Get playback control byte for track
                and     6                               ; Is either bit 1 ("do not attack next note") or 2 ("SFX overriding this track") set?
                ret     nz                              ; Return if yes
                ld      a, (ix+zTrack.VoiceControl)     ; Get voice control byte from track
                or      0F0h                            ; We want only the FM channel assignment bits
                ld      c, a                            ; Key on for all operators
                ld      a, 28h                          ; Select key on/of register
                call    zWriteFMI                       ; Send command to YM2612
                ret
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================
; Writes reg/data pair to register 28h (key on/off) if track active
;
; Input:   ix   Track data
; Output:  a    Damaged
; c    Damaged
; sub_35B
zKeyOffIfActive:
                ld      a, (ix+zTrack.PlaybackControl)  ; Get playback control byte for track
                and     6                               ; Is either bit 1 ("do not attack next note") or 2 ("SFX overriding this track") set?
                ret     nz                              ; Return if yes
; End of function zKeyOffIfActive

; =============== S U B R O U T I N E =======================================
; Writes reg/data pair to register 28h (key on/off)
;
; Input:   ix   Track data
; Output:  a    Damaged
; c    Damaged
; loc_361
zKeyOff:
                ld      c, (ix+zTrack.VoiceControl)     ; Get voice control byte for track (this will turn off all operators as high nibble = 0)
                bit     7, c                            ; Is this a PSG track?
                ret     nz                              ; Return if yes
; End of function zKeyOff

; =============== S U B R O U T I N E =======================================
; Writes reg/data pair to register 28h (key on/off)
;
; Input:   c    Data to write
; Output:  a    Damaged
; loc_367
zKeyOnOff:
                ld      a, 28h                          ; Write to KEY ON/OFF port
                call    zWriteFMI                       ; Send it
                ret
; End of function zKeyOnOff

; =============== S U B R O U T I N E =======================================
; Performs volume envelope effects in FM channels
;
; Input:   ix    Pointer to track RAM
; Output:  a     Trashed
; bc    Trashed
; de    Trashed
; hl    Trashed
;
; sub_36D
; zDoFMFlutter
