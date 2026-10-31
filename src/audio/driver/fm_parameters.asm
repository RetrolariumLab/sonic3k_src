; FM volume envelopes, pitch modulation and instrument register uploads
; Original driver statements retain their assembly order

                CPU     Z80
                listing purecode
zDoFMVolEnv:
                ld      a, (ix+zTrack.FMVolEnv)         ; Get FM volume envelope
                or      a                               ; Is it zero?
                ret     z                               ; Return if yes
                ret     m                               ; Return if it is actually the custom SSG-EG flag
                dec     a                               ; Make a into an index
                ld      c, zID_VolEnvPointers           ; Value for volume envelope pointer table
                rst     GetPointerTable                 ; hl = pointer to volume envelope table
                rst     PointerTableOffset              ; hl = pointer to volume envelope for track
                call    zDoVolEnv                       ; a = new volume envelope
                ld      h, (ix+zTrack.TLPtrHigh)        ; h = high byte to TL data pointer
                ld      l, (ix+zTrack.TLPtrLow)         ; l = low byte to TL data pointer
                ld      de, zFMInstrumentTLTable        ; de = pointer to FM TL register table
                ld      b, zFMInstrumentTLTable_End-zFMInstrumentTLTable  ; Number of entries
                ld      c, (ix+zTrack.FMVolEnvMask)     ; c = envelope bitmask

                .loop:
                push    af                              ; Save af
                sra     c                               ; Divide c by 2
                push    bc                              ; Save bc
                jr      nc, .skip_reg                   ; Branch if c bit shifted was zero
                add     a, (hl)                         ; Add TL value to volume envelope
; This isn't actually needed
                and     7Fh                             ; Strip sign bit
                ld      c, a                            ; c = TL + volume envelope
                ld      a, (de)                         ; a = YM2612 register
                call    zWriteFMIorII                   ; Send TL data to YM2612

                .skip_reg:
                pop     bc                              ; Restore bc
                inc     de                              ; Advance to next YM2612 register
                inc     hl                              ; Advance to next TL value
                pop     af                              ; Restore af
                djnz    .loop                           ; Loop for all registers
                ret
; End of function zDoFMVolEnv

; =============== S U B R O U T I N E =======================================
; Initializes normal modulation
;
; Input:   ix    Pointer to track's RAM
; Output:  de    If modulation control has bit 7 set and track is to attack next note, pointer to modulation steps in track RAM
; hl    If modulation control has bit 7 set and track is to attack next note, pointer to modulation steps in track data
;
; sub_39E
zPrepareModulation:
                bit     7, (ix+zTrack.ModulationCtrl)   ; Is modulation on?
                ret     z                               ; Return if not
                bit     1, (ix+zTrack.PlaybackControl)  ; Is 'do not attack next note' bit set?
                ret     nz                              ; Return if yes
                ld      e, (ix+zTrack.ModulationPtrLow)  ; e = low byte of pointer to modulation data
                ld      d, (ix+zTrack.ModulationPtrHigh)  ; d = high byte of pointer to modulation data
                push    ix                              ; Save ix
                pop     hl                              ; hl = pointer to track data
                ld      b, 0                            ; b = 0
                ld      c, zTrack.ModulationWait        ; c = offset in track RAM for modulation data
                add     hl, bc                          ; hl = pointer to modulation data in track RAM
                ex      de, hl                          ; Exchange de and hl
                ldi                                     ; *de++ = *hl++
                ldi                                     ; *de++ = *hl++
                ldi                                     ; *de++ = *hl++
                ld      a, (hl)                         ; a = number of modulation steps
                srl     a                               ; Divide by 2
                ld      (de), a                         ; Store in track RAM
                xor     a                               ; a = 0
                ld      (ix+zTrack.ModulationValLow), a  ; Clear low byte of accumulated modulation
                ld      (ix+zTrack.ModulationValHigh), a  ; Clear high byte of accumulated modulation
                ret
; End of function zPrepareModulation

; =============== S U B R O U T I N E =======================================
; Applies modulation
;
; Input:   ix    Pointer to track's RAM
; hl    Note frequency
; Output:
; If modulation control is 80h (normal modulation):
; hl    Final note frequency
; de    Pointer to modulation data in track RAM
; iy    Pointer to modulation data in track RAM
; bc    Unmodulated note frequency
;
; If modulation control is nonzero and not 80h (modulation envelope effects):
;
;
; sub_3C9
zDoModulation:
                ld      a, (ix+zTrack.ModulationCtrl)   ; Get modulation control byte
                or      a                               ; Is modulation active?
                ret     z                               ; Return if not
                cp      80h                             ; Is modulation control 80h?
                jr      nz, zDoModEnvelope              ; Branch if not
                dec     (ix+zTrack.ModulationWait)      ; Decrement modulation wait
                ret     nz                              ; Return if nonzero
                inc     (ix+zTrack.ModulationWait)      ; Increase it back to 1 for next frame
                push    hl                              ; Save hl
                ld      l, (ix+zTrack.ModulationValLow)  ; l = low byte of accumulated modulation
                ld      h, (ix+zTrack.ModulationValHigh)  ; h = high byte of accumulated modulation
; In non-Type 2 DAC versions of SMPS Z80, the following four instructions were below the 'jr nz'
; which could lead to a bug where iy isn't initialised, but still used as a pointer
                ld      e, (ix+zTrack.ModulationPtrLow)  ; e = low byte of modulation data pointer
                ld      d, (ix+zTrack.ModulationPtrHigh)  ; d = high byte of modulation data pointer
                push    de                              ; Save de
                pop     iy                              ; iy = pointer to modulation data
                dec     (ix+zTrack.ModulationSpeed)     ; Decrement modulation speed
                jr      nz, .mod_sustain                ; Branch if nonzero
                ld      a, (iy+1)                       ; Get original modulation speed
                ld      (ix+zTrack.ModulationSpeed), a  ; Reset modulation speed timeout
                ld      a, (ix+zTrack.ModulationDelta)  ; Get modulation delta per step
                ld      c, a                            ; c = modulation delta per step
                and     80h                             ; Get only sign bit
                rlca                                    ; Shift it into bit 0
                neg                                     ; Negate (so it is either 0 or -1)
                ld      b, a                            ; bc = sign extension of delta
                add     hl, bc                          ; hl += bc
                ld      (ix+zTrack.ModulationValLow), l  ; Store low byte of accumulated modulation
                ld      (ix+zTrack.ModulationValHigh), h  ; Store high byte of accumulated modulation

                .mod_sustain:
                pop     bc                              ; bc = note frequency
                add     hl, bc                          ; hl = modulated note frequency
                dec     (ix+zTrack.ModulationSteps)     ; Reduce number of modulation steps
                ret     nz                              ; Return if nonzero
                ld      a, (iy+3)                       ; Get number of steps from track data
                ld      (ix+zTrack.ModulationSteps), a  ; Reset modulation steps in track RAM
                ld      a, (ix+zTrack.ModulationDelta)  ; Load modulation delta
                neg                                     ; Change its sign
                ld      (ix+zTrack.ModulationDelta), a  ; Store it back
                ret
; ---------------------------------------------------------------------------
; loc_41A
; zDoFrequencyFlutter
zDoModEnvelope:
                dec     a                               ; Convert into pointer table index
                ex      de, hl                          ; Exchange de and hl; de = note frequency
                ld      c, zID_ModEnvPointers           ; Value for modulation envelope pointer table
                rst     GetPointerTable                 ; hl = pointer to modulation envelope pointer table
                rst     PointerTableOffset              ; hl = modulation envelope pointer for modulation control byte
                jr      zDoModEnvelope_cont
; ---------------------------------------------------------------------------
; zFreqFlutterSetIndex
zModEnvSetIndex:
                ld      (ix+zTrack.ModEnvIndex), a      ; Set new modulation envelope index

; loc_425
; zDoFrequencyFlutter_cont
zDoModEnvelope_cont:
                push    hl                              ; Save hl
                ld      c, (ix+zTrack.ModEnvIndex)      ; c = modulation envelope index
                ld      b, 0                            ; b = 0
                add     hl, bc                          ; Offset into modulation envelope table
                ld      a, (hl)                         ; a = new modulation envelope value
                pop     hl                              ; Restore hl
                bit     7, a                            ; Is modulation envelope negative?
                jp      z, zlocPositiveModEnvMod        ; Branch if not
                cp      82h                             ; Is it 82h?
                jr      z, zlocChangeModEnvIndex        ; Branch if yes
                cp      80h                             ; Is it 80h?
                jr      z, zlocResetModEnvMod           ; Branch if yes
                cp      84h                             ; Is it 84h?
                jr      z, zlocModEnvIncMultiplier      ; Branch if yes
                ld      h, 0FFh                         ; h = 0FFh
                jr      nc, zlocApplyModEnvMod          ; Branch if more than 84h
                set     6, (ix+zTrack.PlaybackControl)  ; Set 'sustain frequency' bit
                pop     hl                              ; Tamper with return location so as to not return to caller
                ret
; ---------------------------------------------------------------------------
; loc_449
; zlocChangeFlutterIndex
zlocChangeModEnvIndex:
                inc     bc                              ; Increment bc
; DANGER! Uses bc as a pointer, getting bytes from code region
; This happens for several frequency flutters, so you should avoid them
; unless you enable the driver bug fixes
                ld      a, (bc)                         ; Use it as a pointer??? Getting bytes from code region?
                jr      zModEnvSetIndex                 ; Set position to nonsensical value
; ---------------------------------------------------------------------------
; loc_44D
; zlocResetFlutterMod
zlocResetModEnvMod:
                xor     a                               ; a = 0
                jr      zModEnvSetIndex                 ; Reset position for modulation envelope
; ---------------------------------------------------------------------------
; loc_450
; zlocFlutterIncMultiplier
zlocModEnvIncMultiplier:
                inc     bc                              ; Increment bc
; DANGER! Uses bc as a pointer, getting bytes from code region
; Luckily, this does not happen for any of the existing frequency
; flutters
                ld      a, (bc)                         ; Use it as a pointer??? Getting bytes from code region?
                add     a, (ix+zTrack.ModEnvSens)       ; Add envelope sensibility to a
                ld      (ix+zTrack.ModEnvSens), a       ; ... then store new value
                inc     (ix+zTrack.ModEnvIndex)         ; Advance envelope modulation
                inc     (ix+zTrack.ModEnvIndex)         ; ... twice
                jr      zDoModEnvelope_cont
; ---------------------------------------------------------------------------
; loc_460
; zlocPositiveFlutterMod
zlocPositiveModEnvMod:
                ld      h, 0                            ; h = 0

; loc_462
; zlocApplyFlutterMod
zlocApplyModEnvMod:
                ld      l, a                            ; hl = sign extension of modulation value
                ld      b, (ix+zTrack.ModEnvSens)       ; Fetch envelope sensibility
                inc     b                               ; Increment it (minimum 1)
                ex      de, hl                          ; Swap hl and de; hl = note frequency

                .loop:
                add     hl, de                          ; hl += de
                djnz    .loop                           ; Make hl = note frequency + b * de
                inc     (ix+zTrack.ModEnvIndex)         ; Advance modulation envelope
                ret
; End of function zDoModulation

; =============== S U B R O U T I N E =======================================
; Adds the current frequency displacement (signed) to note frequency
;
; Input:   ix    Track RAM
; Output:  hl    Shifted frequency
; a     Damaged
; bc    Damaged
;
; sub_46F
; zDoPitchSlide
zUpdateFreq:
                ld      h, (ix+zTrack.FreqHigh)         ; h = high byte of note frequency
                ld      l, (ix+zTrack.FreqLow)          ; l = low byte of note frequency
                ld      b, 0                            ; b = 0
                ld      a, (ix+zTrack.Detune)           ; a = detune
                or      a                               ; Is a negative?
                jp      p, .did_sign_extend             ; Branch if not
                ld      b, 0FFh                         ; b = -1

                .did_sign_extend:
                ld      c, a                            ; bc = sign extension of frequency displacement
                add     hl, bc                          ; Add to frequency
                ret
; End of function zUpdateFreq

; =============== S U B R O U T I N E =======================================
; Gets offset for requested FM instrument
;
; sub_483
zGetFMInstrumentPointer:
                ld      hl, (zVoiceTblPtr)              ; hl = pointer to voice table
                ld      a, (zUpdatingSFX)               ; Get flag
                or      a                               ; Is this a SFX track?
                jr      z, zGetFMInstrumentOffset       ; Branch if not
                ld      l, (ix+zTrack.VoicesLow)        ; l = low byte of track's voice pointer
                ld      h, (ix+zTrack.VoicesHigh)       ; h = high byte of track's voice pointer

; loc_492
zGetFMInstrumentOffset:
                xor     a                               ; a = 0
                or      b                               ; Is FM instrument the first one (zero)?
                ret     z                               ; Return if so
                ld      de, 25                          ; Size of each FM instrument

                .loop:
                add     hl, de                          ; Advance pointer to next instrument
                djnz    .loop                           ; Loop until instrument offset is found
                ret
; End of function zGetFMInstrumentPointer

; ---------------------------------------------------------------------------
; loc_49C
zFMInstrumentRegTable:
                db      0B0h                            ; Feedback/Algorithm
zFMInstrumentOperatorTable:
                db      30h                             ; Detune/multiple operator 1
                db      38h                             ; Detune/multiple operator 3
                db      34h                             ; Detune/multiple operator 2
                db      3Ch                             ; Detune/multiple operator 4
zFMInstrumentRSARTable:
                db      50h                             ; Rate scaling/attack rate operator 1
                db      58h                             ; Rate scaling/attack rate operator 3
                db      54h                             ; Rate scaling/attack rate operator 2
                db      5Ch                             ; Rate scaling/attack rate operator 4
zFMInstrumentAMD1RTable:
                db      60h                             ; Amplitude modulation/first decay rate operator 1
                db      68h                             ; Amplitude modulation/first decay rate operator 3
                db      64h                             ; Amplitude modulation/first decay rate operator 2
                db      6Ch                             ; Amplitude modulation/first decay rate operator 4
zFMInstrumentD2RTable:
                db      70h                             ; Secondary decay rate operator 1
                db      78h                             ; Secondary decay rate operator 3
                db      74h                             ; Secondary decay rate operator 2
                db      7Ch                             ; Secondary decay rate operator 4
zFMInstrumentD1LRRTable:
                db      80h                             ; Secondary amplitude/release rate operator 1
                db      88h                             ; Secondary amplitude/release rate operator 3
                db      84h                             ; Secondary amplitude/release rate operator 2
                db      8Ch                             ; Secondary amplitude/release rate operator 4
zFMInstrumentOperatorTable_End:
; loc_4B1
zFMInstrumentTLTable:
                db      40h                             ; Total level operator 1
                db      48h                             ; Total level operator 3
                db      44h                             ; Total level operator 2
                db      4Ch                             ; Total level operator 4
zFMInstrumentTLTable_End:
; loc_4B5
zFMInstrumentSSGEGTable:
                db      90h                             ; SSG-EG operator 1
                db      98h                             ; SSG-EG operator 3
                db      94h                             ; SSG-EG operator 2
                db      9Ch                             ; SSG-EG operator 4
zFMInstrumentSSGEGTable_End:

; =============== S U B R O U T I N E =======================================
; Subroutine to send FM instrument data to YM2612 chip
;
; sub_4B9
zSendFMInstrument:
                ld      de, zFMInstrumentRegTable       ; de = pointer to register output table
                ld      c, (ix+zTrack.AMSFMSPan)        ; Send track AMS/FMS/panning
                ld      a, 0B4h                         ; Select AMS/FMS/panning register
                call    zWriteFMIorII                   ; Set track data
                call    zSendFMInstrData                ; Send data to register
                ld      (ix+zTrack.FeedbackAlgo), a     ; Save current feedback/algorithm

; DANGER! The following code ignores the fact that SSG-EG mode must be
; used with maximum (1Fh) attack rate or output is officially undefined
; Setting voices with SSG-EG enabled then has the potential effect of
; weird sound, even in real hardware

                ld      b, zFMInstrumentOperatorTable_End-zFMInstrumentOperatorTable  ; Number of commands to issue

                .loop:
                call    zSendFMInstrData                ; Send FM instrument data
                djnz    .loop                           ; Loop
                ld      (ix+zTrack.TLPtrLow), l         ; Save low byte of pointer to (not yet uploaded) TL data
                ld      (ix+zTrack.TLPtrHigh), h        ; Save high byte of pointer to (not yet uploaded) TL data
                jp      zSendTL                         ; Send TL data
; End of function zSendFMInstrument

; =============== S U B R O U T I N E =======================================
; Sends FM instrument data to YM2612
;
; Input:   ix    Track data
; hl    Pointer to instrument data
; de    Pointer to register selector table
; Output:   a    Value written to the register
; c    Value written to the register
;
; sub_4DA
zSendFMInstrData:
                ld      a, (de)                         ; Get register output
                inc     de                              ; Advance pointer
                ld      c, (hl)                         ; Get value from instrument RAM
                inc     hl                              ; Advance pointer
                call    zWriteFMIorII                   ; Write track data
                ret
; End of function zSendFMInstrData

; =============== S U B R O U T I N E =======================================
; Rotates sound queue and clears last entry. Then plays the popped sound from
; the queue
; loc_4E2
