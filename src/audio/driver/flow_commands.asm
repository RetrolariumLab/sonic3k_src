; Modulation, track stop, PSG noise, loops, calls and FM3 settings
; Original driver statements retain their assembly order

                CPU     Z80
                listing purecode
cfModulation:
                ld      (ix+zTrack.ModulationPtrLow), e  ; Store low byte of modulation data pointer
                ld      (ix+zTrack.ModulationPtrHigh), d  ; Store high byte of modulation data pointer
                ld      (ix+zTrack.ModulationCtrl), 80h  ; Toggle modulation on
                inc     de                              ; Advance pointer
                inc     de                              ; ... again
                inc     de                              ; ... and again
                ret

; =============== S U B R O U T I N E =======================================
; Sets modulation status according to parameter bytes
;
; Has 2 1-byte parameters: the first byte is the new modulation state for PSG
; tracks, while the second byte is the new modulation state for FM tracks
;
; loc_D7B
cfAlterModulation:
                inc     de                              ; Advance track pointer
                bit     7, (ix+zTrack.VoiceControl)     ; Is this a PSG track?
                jr      nz, cfSetModulation             ; Branch if yes
                ld      a, (de)                         ; Get new modulation status

; =============== S U B R O U T I N E =======================================
; Sets modulation status
;
; Has one parameter byte, the new modulation status
;
; loc_D83
cfSetModulation:
                ld      (ix+zTrack.ModulationCtrl), a   ; Set modulation status
                ret

; =============== S U B R O U T I N E =======================================
; Stops the current track
;
; Technically, it has a parameter byte, but it is irrelevant and unused
;
; loc_D87
cfStopTrack:
                res     7, (ix+zTrack.PlaybackControl)  ; Clear 'track playing' flag
                ld      a, 1Fh                          ; a = 1Fh
                ld      (zDriverRetained_StopTrackWriteOnlyLatch), a  ; Set otherwise unused location to 1Fh
                call    zKeyOffIfActive                 ; Send key off for track channel
                ld      c, (ix+zTrack.VoiceControl)     ; c = voice control bits
                push    ix                              ; Save track pointer
                call    zGetSFXChannelPointers          ; ix = track pointer, hl = overridden track pointer
                ld      a, (zUpdatingSFX)               ; Get flag
                or      a                               ; Are we updating SFX?
                if      SonicDriverVer==3
                jr      z, zStopCleanExit               ; Exit if not
                else
                jp      z, zStopCleanExit               ; Exit if not
                endif
                xor     a                               ; a = 0
                ld      (zFadeSFXCleanupByte), a        ; Set otherwise unused value to zero
                push    hl                              ; Save hl
                ld      hl, (zVoiceTblPtr)              ; hl = pointer to voice table
                pop     ix                              ; ix = overridden track's pointer
                res     2, (ix+zTrack.PlaybackControl)  ; Clear 'SFX is overriding' bit
                bit     7, (ix+zTrack.VoiceControl)     ; Is this a PSG channel?
                jr      nz, zStopPSGTrack               ; Branch if yes
                bit     7, (ix+zTrack.PlaybackControl)  ; Is 'track playing' bit set?
                jr      z, zStopCleanExit               ; Exit if not
                ld      a, 2                            ; a = 2 (FM3)
                cp      (ix+zTrack.VoiceControl)        ; Is this track for FM3?
                jr      nz, .not_fm3                    ; Branch if not
                ld      a, 4Fh                          ; FM3 settings: special mode, enable and load A/B
                bit     0, (ix+zTrack.PlaybackControl)  ; Is FM3 in special mode?
                jr      nz, .do_fm3_settings            ; Branch if yes
                and     0Fh                             ; FM3 settings: normal mode, enable and load A/B

                .do_fm3_settings:
                call    zWriteFM3Settings               ; Set the above FM3 settings

                .not_fm3:
                ld      a, (ix+zTrack.VoiceIndex)       ; Get FM instrument
                or      a                               ; Is it positive?
                jp      p, .switch_to_music             ; Branch if yes
                call    zSetVoiceUploadAlter            ; Upload the voice from another song's voice bank
                jr      .send_ssg_eg
; ---------------------------------------------------------------------------
                .switch_to_music:
                ld      b, a                            ; b = FM instrument
                push    hl                              ; Save hl
                if      SonicDriverVer==3
                ld      hl, zBankRegister
                ld      a, (zSongBank)
                bankswitchToMusicS3                     ; Bank switch to song bank
                else
                bankswitchToMusic                       ; Bank switch to song bank
                endif
                pop     hl                              ; Restore hl
                call    zGetFMInstrumentOffset          ; hl = pointer to instrument data
                call    zSendFMInstrument               ; Send FM instrument
                bankswitchToSFX
                ld      a, (ix+zTrack.HaveSSGEGFlag)    ; Get custom SSG-EG flag
                or      a                               ; Does track have custom SSG-EG data?
                jp      p, zStopCleanExit               ; Exit if not
                ld      e, (ix+zTrack.SSGEGPointerLow)  ; e = low byte of pointer to SSG-EG data
                ld      d, (ix+zTrack.SSGEGPointerHigh)  ; d = high byte of pointer to SSG-EG data

                .send_ssg_eg:
                call    zSendSSGEGData                  ; Upload custom SSG-EG data

; loc_E22
zStopCleanExit:
                pop     ix                              ; Restore ix
                pop     hl                              ; Pop return value from stack
                pop     hl                              ; Pop another return value from stack
                ret
; ---------------------------------------------------------------------------
; loc_E27
zStopPSGTrack:
                bit     0, (ix+zTrack.PlaybackControl)  ; Is this a noise channel?
                jr      z, zStopCleanExit               ; Exit if not
                ld      a, (ix+zTrack.PSGNoise)         ; Get track's PSG noise setting
                or      a                               ; Is it an actual noise?
                jp      p, .skip_command                ; Branch if not
                ld      (zPSG), a                       ; Send it to PSG

                .skip_command:
                jr      zStopCleanExit

; =============== S U B R O U T I N E =======================================
; Change PSG noise to parameter, and silences PSG3 channel
;
; Has one parameter byte: if zero, the channel is changed back to a normal PSG
; channel and the noise is silenced; if non-zero, it must be in the 0E0h-0E7h
; range, and sets the noise type to use (and sets the channel as being a noise
; channel)
;
; loc_E39
cfSetPSGNoise:
                bit     2, (ix+zTrack.VoiceControl)     ; Is this a channel bound for part II (FM4, FM5, FM6/DAC)?
                ret     nz                              ; Return if yes
                ld      a, 0DFh                         ; Command to silence PSG3
                ld      (zPSG), a                       ; Execute it
                ld      a, (de)                         ; Get PSG noise value
                ld      (ix+zTrack.PSGNoise), a         ; Store to track RAM
                set     0, (ix+zTrack.PlaybackControl)  ; Mark PSG track as being noise
                or      a                               ; Test noise value
                jr      nz, .skip_noise_silence         ; If nonzero, branch
                res     0, (ix+zTrack.PlaybackControl)  ; Otherwise, mark track as not being a noise channel
                ld      a, 0FFh                         ; Command to silence the noise channel
                .skip_noise_silence:
                ld      (zPSG), a                       ; Send command to PSG
                ret

; =============== S U B R O U T I N E =======================================
; Set PSG tone
;
; Has one parameter byte, the new PSG tone to use
;
; loc_E58
; cfSetPSGTone
cfSetPSGVolEnv:
                bit     7, (ix+zTrack.VoiceControl)     ; Is this a PSG track?
                ret     z                               ; Return if not

; loc_E5D
cfStoreNewVoice:
                ld      (ix+zTrack.VoiceIndex), a       ; Store voice
                ret

; =============== S U B R O U T I N E =======================================
; Jump to specified location
;
; Has a 2-byte parameter, indicating target location for jump
;
; loc_E61
cfJumpTo:
                ex      de, hl                          ; Exchange de and hl
                ld      e, (hl)                         ; e = low byte of target location
                inc     hl                              ; Advance pointer
                ld      d, (hl)                         ; d = high byte of target location
                dec     de                              ; Put destination byte back
                ret

; =============== S U B R O U T I N E =======================================
; Loop section of music
;
; Has four parameter bytes: a loop counter index (exactly like coord. flag 0EBh),
; a repeat count, and a 2-byte jump target
;
; loc_E67
cfRepeatAtPos:
                inc     de                              ; Advance track pointer
                add     a, zTrack.LoopCounters          ; Add offset into loop counters
                ld      c, a                            ; c = offset of current loop counter
                ld      b, 0                            ; bc = sign-extended offset to current loop counter
                push    ix                              ; Save track RAM pointer
                pop     hl                              ; hl = pointer to track RAM
                add     hl, bc                          ; hl = pointer in RAM to current loop counter
                ld      a, (hl)                         ; a = value of current loop counter
                or      a                               ; Is loop counter zero?
                jr      nz, .run_counter                ; Branch if not
                ld      a, (de)                         ; Get repeat counter
                ld      (hl), a                         ; Reset loop counter to it

                .run_counter:
                inc     de                              ; Advance track pointer
                dec     (hl)                            ; Decrement loop counter
                jp      nz, cfJumpTo                    ; Loop if it is nonzero
                inc     de                              ; Advance track pointer
                ret

; =============== S U B R O U T I N E =======================================
; Call subroutine. Stores current location on track-specific stack so that
; coord. flag 0F9h can be used to return to current location
;
; Has one 2-byte parameter, the target subroutine's address
;
; loc_E7E
cfJumpToGosub:
                ld      c, a                            ; c = low byte of target address
                inc     de                              ; Advance track pointer
                ld      a, (de)                         ; a = high byte of target address
                ld      b, a                            ; bc = target address
                push    bc                              ; Save bc
                push    ix                              ; Save ix
                pop     hl                              ; hl = pointer to track RAM
                dec     (ix+zTrack.StackPointer)        ; Decrement track stack pointer
                ld      c, (ix+zTrack.StackPointer)     ; c = track stack pointer
                dec     (ix+zTrack.StackPointer)        ; Decrement track stack pointer again
                ld      b, 0                            ; b = 0
                add     hl, bc                          ; hl = offset of high byte of return address
                ld      (hl), d                         ; Store high byte of return address
                dec     hl                              ; Move pointer to target location
                ld      (hl), e                         ; Store low byte of return address
                pop     de                              ; de = jump target address
                dec     de                              ; Put back the byte
                ret

; =============== S U B R O U T I N E =======================================
; Returns from subroutine call. Does NOT check for stack overflows!
;
; Has no parameter bytes
;
; loc_E98
cfJumpReturn:
                push    ix                              ; Save track RAM address
                pop     hl                              ; hl = pointer to track RAM
                ld      c, (ix+zTrack.StackPointer)     ; c = offset to top of return stack
                ld      b, 0                            ; b = 0
                add     hl, bc                          ; hl = pointer to top of return stack
                ld      e, (hl)                         ; e = low byte of return address
                inc     hl                              ; Advance pointer
                ld      d, (hl)                         ; de = return address
                inc     (ix+zTrack.StackPointer)        ; Pop byte from return stack
                inc     (ix+zTrack.StackPointer)        ; Pop byte from return stack
                ret

; =============== S U B R O U T I N E =======================================
; Clears sign bit of modulation control, disabling normal modulation
;
; Has no parameter bytes
;
; loc_EAB
cfDisableModulation:
                res     7, (ix+zTrack.ModulationCtrl)   ; Clear bit 7 of modulation control
                dec     de                              ; Put byte back
                ret

; =============== S U B R O U T I N E =======================================
; Adds a signed value to channel key displacement
;
; Has one parameter byte, the change in channel key displacement
;
; loc_EB1 cfAddKey
cfChangeTransposition:
                add     a, (ix+zTrack.Transpose)        ; Add current transposition to parameter
                ld      (ix+zTrack.Transpose), a        ; Store result as new transposition
                ret

; =============== S U B R O U T I N E =======================================
; If a continuous SFX is playing, it will continue playing from target address
; A loop counter is decremented (it is initialized to number of SFX tracks)
; for continuous SFX; if the result is zero, the continuous SFX will be flagged
; to stop
; Non-continuous SFX do not loop
;
; Has a 2-byte parameter, the jump target address
;
; loc_EB8
cfLoopContinuousSFX:
                ld      a, (zContinuousSFXFlag)         ; Get 'continuous sound effect' flag
                cp      80h                             ; Is it equal to 80h?
                jp      z, .run_counter                 ; Branch if yes
                xor     a                               ; a = 0
                ld      (zContinuousSFX), a             ; Clear last continuous SFX played
                ld      (zContinuousSFXFlag), a         ; Clear continuous sound effect flag (redundant; zContinuousSFXFlag will always be 0 at this point)
                inc     de                              ; Skip a byte
                ret
; ---------------------------------------------------------------------------
                .run_counter:
                ld      a, (zContSFXLoopCnt)            ; Get number loops to perform
                dec     a                               ; Decrement it
                ld      (zContSFXLoopCnt), a            ; ... and store it back
                jp      nz, cfJumpTo                    ; If result is non-zero, jump to target address
                xor     a                               ; a = 0
                ld      (zContinuousSFXFlag), a         ; Clear continuous sound effect flag
                jp      cfJumpTo                        ; Jump to target address

; =============== S U B R O U T I N E =======================================
; Toggles alternate frequency mode according to parameter
;
; Has a single byte parameter: is 1, enables alternate frequency mode, otherwise
; disables it
;
; loc_EDA
; cfToggleAlternateSMPS
cfToggleAltFreqMode:
                cp      1                               ; Is parameter equal to 1?
                jr      nz, .stop_altfreq_mode          ; Branch if not
                set     3, (ix+zTrack.PlaybackControl)  ; Start alternate frequency mode for track
                ret
; ---------------------------------------------------------------------------
                .stop_altfreq_mode:
                res     3, (ix+zTrack.PlaybackControl)  ; Stop alternate frequency mode for track
                ret

; =============== S U B R O U T I N E =======================================
; If current track is FM3, it is put into special mode. The function is weird,
; and may not work correctly (subject to verification)
;
; It has 4 1-byte parameters: all of them are indexes into a lookup table of
; unknown purpose, and must be in the 0-7 range. It is possible that this
; lookup table held frequencies (or frequency shifts) for FM3 and its operators
; in special mode
;
; loc_EE8
cfFM3SpecialMode:
                ld      a, (ix+zTrack.VoiceControl)     ; Get track's voice control
                cp      2                               ; Is this FM3?
                jr      nz, zTrackSkip3bytes            ; Branch if not
                set     0, (ix+zTrack.PlaybackControl)  ; Put FM3 in special mode
                ex      de, hl                          ; Exchange de and hl
                call    zGetSpecialFM3DataPointer       ; de = pointer to saved FM3 frequency shifts
                ld      b, 4                            ; Loop counter: 4 parameter bytes

; DANGER! The following code will trash the Z80 code due to failed
; initialization of de. At the start of the function, hl was a pointer
; to the coord. flag switch table entry that had the address of this
; function; after 'ex de, hl', now de is this pointer
; After the code below, the targets of the last few coord. flag handlers
; will be overwritten by the nonsensical numbers at the lookup table
                .loop:
                push    bc                              ; Save bc
                ld      a, (hl)                         ; Get parameter byte
                inc     hl                              ; Advance pointer
                push    hl                              ; Save hl
                ld      hl, zFM3FreqShiftTable          ; hl = pointer to lookup table
                add     a, a                            ; Multiply a by 2
                ld      c, a                            ; c = a
                ld      b, 0                            ; b = 0
                add     hl, bc                          ; hl = offset into lookup table
                ldi                                     ; *de++ = *hl++
                ldi                                     ; *de++ = *hl++
                pop     hl                              ; Restore hl
                pop     bc                              ; Restore bc
                djnz    .loop                           ; Loop for all parameters

                ex      de, hl                          ; Exchange back de and hl
                dec     de                              ; Put back last byte
                ld      a, 4Fh                          ; FM3 settings: special mode, enable and load A/B

; =============== S U B R O U T I N E =======================================
; Set up FM3 special settings
;
; Input:   a    Settings for FM3
; Output:  c    Damaged
; sub_F11
zWriteFM3Settings:
                ld      (zFM3Settings), a               ; Save FM3 settings
                ld      c, a                            ; c = FM3 settings
                ld      a, 27h                          ; Write data to FM3 settings register
                call    zWriteFMI                       ; Do it
                ret
; End of function zWriteFM3Settings

; =============== S U B R O U T I N E =======================================
; Eats 3 bytes from the song
zTrackSkip3bytes:
                inc     de                              ; Advance pointer
                inc     de                              ; ... again
                inc     de                              ; ... and again
                ret
; ---------------------------------------------------------------------------
; Frequency shift data used in cfFM3SpecialMode, above. That function, as well
; as zFMSendFreq, use invalid addresses for read and write (respectively), so
; that this data is improperly used
; loc_F1F
zFM3FreqShiftTable:
                dw      0, 132h, 18Eh, 1E4h, 234h, 27Eh, 2C2h, 2F0h

; =============== S U B R O U T I N E =======================================
; Meta coordination flag: the first parameter byte is an index into an extra
; coord. flag handler table
;
; Has at least one parameter byte, the index into the jump table
;
; loc_F2F
