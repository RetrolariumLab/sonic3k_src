; DPCM and PCM playback with the extracted sixteen-byte delta codebook
; Original driver statements retain their assembly order

                CPU     Z80
                listing purecode
zPlayDigitalAudio:
                di                                      ; Disable interrupts
                ld      a, 2Bh                          ; DAC enable/disable register
                ld      c, 0                            ; Value to disable DAC
                call    zWriteFMI                       ; Send YM2612 command

                .dac_idle_loop:
                ei                                      ; Enable interrupts
                ld      a, (PlaySegaPCMFlag)            ; a = play SEGA PCM flag
                or      a                               ; Is SEGA sound being played?
                jp      nz, zPlaySEGAPCM                ; Branch if yes
                ld      a, (zDACIndex)                  ; a = DAC index/flag
                or      a                               ; Is DAC channel being used?
                jr      z, .dac_idle_loop               ; Loop if not
                ld      a, 2Bh                          ; DAC enable/disable register
                ld      c, 80h                          ; Value to enable DAC
                di                                      ; Disable interrupts
                call    zWriteFMI                       ; Send YM2612 command
                ei                                      ; Re-enable interrupts
                ld      iy, DecTable                    ; iy = pointer to jman2050 decode lookup table
                ld      hl, zDACIndex                   ; hl = pointer to DAC index/flag
                ld      a, (hl)                         ; a = DAC index
                dec     a                               ; a -= 1
                set     7, (hl)                         ; Set bit 7 to indicate that DAC sample is being played
                ld      hl, zROMWindow                  ; hl = pointer to ROM window
                rst     PointerTableOffset              ; hl = pointer to DAC data
                ld      c, 80h                          ; c is an accumulator below; this initializes it to 80h
                ld      a, (hl)                         ; a = DAC rate
                ld      (.sample1_rate+1), a            ; Store into following instruction (self-modifying code)
                ld      (.sample2_rate+1), a            ; Store into following instruction (self-modifying code)
                inc     hl                              ; hl = pointer to low byte of DAC sample's length
                ld      e, (hl)                         ; e = low byte of DAC sample's length
                inc     hl                              ; hl = pointer to high byte of DAC sample's length
                ld      d, (hl)                         ; d = high byte of DAC sample's length
                inc     hl                              ; hl = pointer to low byte of DAC sample's in-bank location
                ld      a, (hl)                         ; a = low byte of DAC sample's in-bank location
                inc     hl                              ; hl = pointer to high byte of DAC sample's in-bank location
                ld      h, (hl)                         ; h = high byte of DAC sample's in-bank location
                ld      l, a                            ; l = low byte of DAC sample's in-bank location
; hl is now pointer to DAC data, while de is the DAC sample's length

                .dac_playback_loop:
                .sample1_rate:
; According to Kabuto, the Z80 suffers a delay of approximately 3.3 cycles for each ROM access
; https://plutiedev.com/mirror/kabuto-hardware-notes#bus-system
                ld      b, 0Ah                          ; 7 ; self-modified code; b is set to DAC rate
                ei                                      ; 4 ; Enable interrupts
                djnz    $                               ; 8 ; Loop in this instruction, decrementing b each iteration, until b = 0

                di                                      ; 4 ; Disable interrupts
                ld      a, 2Ah                          ; 7 ; DAC channel register
                ld      (zYM2612_A0), a                 ; 13 ; Send to YM2612
                ld      a, (hl)                         ; 7+3 ; a = next byte of DAC sample
; Want only the high nibble now, so shift it into position
                rlca                                    ; 4
                rlca                                    ; 4
                rlca                                    ; 4
                rlca                                    ; 4
                and     0Fh                             ; 7 ; Get only low nibble (which was the high nibble originally)
                ld      (.sample1_index+2), a           ; 13 ; Store into following instruction (self-modifying code)
                ld      a, c                            ; 4 ; a = c

                .sample1_index:
                add     a, (iy+0)                       ; 19 ; Self-modified code: the index offset is not zero, but what was set above
                ld      (zYM2612_D0), a                 ; 13 ; Send byte to DAC
                ld      c, a                            ; 4 ; Set c to the new value of a

                .sample2_rate:
                ld      b, 0Ah                          ; 7 ; self-modified code; b is set to DAC rate
                ei                                      ; 4 ; Enable interrupts
                djnz    $                               ; 8 ; Loop in this instruction, decrementing b each iteration, until b = 0

                di                                      ; 4 ; Disable interrupts
                ld      a, 2Ah                          ; 7 ; DAC channel register
                ld      (zYM2612_A0), a                 ; 13 ; Send to YM2612
                ld      a, (hl)                         ; 7+3 ; a = next byte of DAC sample
                and     0Fh                             ; 7 ; Want only the low nibble
                ld      (.sample2_index+2), a           ; 13 ; Store into following instruction (self-modifying code)
                ld      a, c                            ; 4 ; a = c

                .sample2_index:
                add     a, (iy+0)                       ; 19 ; Self-modified code: the index offset is not zero, but what was set above
                ld      (zYM2612_D0), a                 ; 13 ; Send byte to DAC
                ei                                      ; 4 ; Enable interrupts
                ld      c, a                            ; 4 ; Set c to the new value of a
                ld      a, (zDACIndex)                  ; 13 ; a = DAC index/flag
                or      a                               ; 4 ; Is playing flag set?
                jp      p, .dac_idle_loop               ; 10 ; Branch if not

                inc     hl                              ; 6 ; Advance to next sample byte
                dec     de                              ; 6 ; Mark one byte as being done
                ld      a, d                            ; 4 ; a = d
                or      e                               ; 4 ; Is length zero?
                jp      nz, .dac_playback_loop          ; 10 ; Loop if not
        ; total: 7+4+8+4+7+13+7+3+4+4+4+4+7+13+4+19+13+4+7+4+8+4+7+13+7+3+7+13+4+19+13+4+4+13+4+10+6+6+4+4+10
                xor     a                               ; a = 0
                ld      (zDACIndex), a                  ; Mark DAC as being idle
                jp      zPlayDigitalAudio               ; Loop
; ---------------------------------------------------------------------------
; ===========================================================================
; JMan2050's DAC decode lookup table
; ===========================================================================
DecTable:
                binclude "data/Sound/DAC/deltas.bin"
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================
;
; Plays the SEGA PCM sound. The z80 will be "stuck" in this function (as it
; disables interrupts) until either of the following conditions hold:
;
; (1) The SEGA PCM is fully played
; (2) The next song to play is 0FEh (cmd_StopSEGA)
; loc_1126
zPlaySEGAPCM:
                di                                      ; Disable interrupts
                if      SonicDriverVer==3
                call    zFillSoundQueue
                else
                xor     a                               ; a = 0
                ld      (PlaySegaPCMFlag), a            ; Clear flag
                endif
                ld      a, 2Bh                          ; DAC enable/disable register
                ld      (zYM2612_A0), a                 ; Select the register
                nop                                     ; Delay
                ld      a, 80h                          ; Value to enable DAC
                ld      (zYM2612_D0), a                 ; Enable DAC
                ld      a, zmake68kBank(SEGA_PCM)       ; a = sound bank index
                bankswitch3                             ; Bank switch to sound bank
                ld      hl, zmake68kPtr(SEGA_PCM)       ; hl = pointer to SEGA PCM
                ld      de, SEGA_PCM.size               ; de = length of SEGA PCM
                ld      a, 2Ah                          ; DAC channel register
                ld      (zYM2612_A0), a                 ; Send to YM2612
                nop                                     ; Delay

                .loop:
; According to Kabuto, the Z80 suffers a delay of approximately 3.3 cycles for each ROM access
; https://plutiedev.com/mirror/kabuto-hardware-notes#bus-system
                ld      a, (hl)                         ; 7+3 ; a = next byte of SEGA PCM
                ld      (zYM2612_D0), a                 ; 13 ; Send to DAC
                ld      a, (zMusicNumber)               ; 13 ; Check next song number
                cp      cmd_StopSEGA                    ; 7 ; Is it the command to stop playing SEGA PCM?
                jr      z, .done                        ; 7 ; Break the loop if yes
                nop                                     ; 4
                nop                                     ; 4

                ld      b, pcmLoopCounter(SEGA_PCM.sample_rate)  ; 7 ; Loop counter
                djnz    $                               ; 8 ; Loop in this instruction, decrementing b each iteration, until b = 0

                inc     hl                              ; 6 ; Advance to next byte of SEGA PCM
                dec     de                              ; 6 ; Mark one byte as being done
                ld      a, d                            ; 4 ; a = d
                or      e                               ; 4 ; Is length zero?
                jr      nz, .loop                       ; 12 ; Loop if not
        ; total: 105

                .done:
                if      SonicDriverVer==3
                xor     a                               ; a = 0
                ld      (PlaySegaPCMFlag), a            ; Clear flag

                ld      hl, zSFXNumber1+1
                call    zClearSoundQueue
                endif
                jp      zPlayDigitalAudio               ; Go back to normal DAC code
; ---------------------------------------------------------------------------
                if      SonicDriverVer<>3
; Junk
                db      0
                endif
