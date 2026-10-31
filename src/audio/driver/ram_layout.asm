; Track structure, hardware ports, music and sound-effect RAM with explicit backup overlay
; Original driver statements retain their assembly order

                padding off
zTrack:         STRUCT  DOTS
; Playback control bits:
; 0 (01h)  Noise channel (PSG) or FM3 special mode (FM)
; 1 (02h)  Do not attack next note
; 2 (04h)  SFX is overriding this track
; 3 (08h)  'Alternate frequency mode' flag
; 4 (10h)  'Track is resting' flag
; 5 (20h)  'Pitch slide' flag
; 6 (40h)  'Sustain frequency' flag -- prevents frequency from changing again for the lifetime of the track
; 7 (80h)  Track is playing
                PlaybackControl: ds.b 1                 ; S&K: 0
; Voice control bits:
; 0-1      FM channel assignment bits (00 = FM1 or FM4, 01 = FM2 or FM5, 10 = FM3 or FM6/DAC, 11 = invalid)
; 2 (04h)  For FM/DAC channels, selects if reg/data writes are bound for part II (set) or part I (unset)
; 3 (08h)  Unknown/unused
; 4 (10h)  Unknown/unused
; 5-6      PSG Channel assignment bits (00 = PSG1, 01 = PSG2, 10 = PSG3, 11 = Noise)
; 7 (80h)  PSG track if set, FM or DAC track otherwise
                VoiceControl: ds.b 1                    ; S&K: 1
                TempoDivider: ds.b 1                    ; S&K: 2
                DataPointerLow: ds.b 1                  ; S&K: 3
                DataPointerHigh: ds.b 1                 ; S&K: 4
                Transpose: ds.b 1                       ; S&K: 5
                Volume: ds.b 1                          ; S&K: 6
                ModulationCtrl: ds.b 1                  ; S&K: 7 ; Modulation is on if nonzero. If only bit 7 is set, then it is normal modulation; otherwise, this-1 is index on modulation envelope pointer table
                VoiceIndex: ds.b 1                      ; S&K: 8 ; FM instrument/PSG voice
                StackPointer: ds.b 1                    ; S&K: 9 ; For call subroutine coordination flag
                AMSFMSPan: ds.b 1                       ; S&K: 0Ah
                DurationTimeout: ds.b 1                 ; S&K: 0Bh
                SavedDuration: ds.b 1                   ; S&K: 0Ch ; Already multiplied by timing divisor
; ---------------------------------
; Alternate names for same offset:
                SavedDAC:                               ; S&K: 0Dh ; For DAC channel
                FreqLow: ds.b 1                         ; S&K: 0Dh ; For FM/PSG channels
; ---------------------------------
                FreqHigh: ds.b 1                        ; S&K: 0Eh ; For FM/PSG channels
                VoiceSongID: ds.b 1                     ; S&K: 0Fh ; For using voices from a different song
                Detune: ds.b 1                          ; S&K: 10h ; In S&K, some places used 11h instead of 10h
                Unk11h: ds.b 1                          ; S&K: 11h
                ds.b    5                               ; S&K: 12h-16h ; Unused
                VolEnv: ds.b 1                          ; S&K: 17h ; Used for dynamic volume adjustments
; ---------------------------------
; Alternate names for same offsets:
                FMVolEnv:                               ; S&K: 18h
                HaveSSGEGFlag: ds.b 1                   ; S&K: 18h ; For FM channels, if track has SSG-EG data
                FMVolEnvMask:                           ; S&K: 19h
                SSGEGPointerLow: ds.b 1                 ; S&K: 19h ; For FM channels, custom SSG-EG data pointer
                PSGNoise:                               ; S&K: 1Ah
                SSGEGPointerHigh: ds.b 1                ; S&K: 1Ah ; For FM channels, custom SSG-EG data pointer
; ---------------------------------
                FeedbackAlgo: ds.b 1                    ; S&K: 1Bh
                TLPtrLow: ds.b 1                        ; S&K: 1Ch
                TLPtrHigh: ds.b 1                       ; S&K: 1Dh
                NoteFillTimeout: ds.b 1                 ; S&K: 1Eh
                NoteFillMaster: ds.b 1                  ; S&K: 1Fh
                ModulationPtrLow: ds.b 1                ; S&K: 20h
                ModulationPtrHigh: ds.b 1               ; S&K: 21h
; ---------------------------------
; Alternate names for same offset:
                ModulationValLow:                       ; S&K: 22h
                ModEnvSens: ds.b 1                      ; S&K: 22h
; ---------------------------------
                ModulationValHigh: ds.b 1               ; S&K: 23h
                ModulationWait: ds.b 1                  ; S&K: 24h
; ---------------------------------
; Alternate names for same offset:
                ModulationSpeed:                        ; S&K: 25h
                ModEnvIndex: ds.b 1                     ; S&K: 25h
; ---------------------------------
                ModulationDelta: ds.b 1                 ; S&K: 26h
                ModulationSteps: ds.b 1                 ; S&K: 27h
                LoopCounters: ds.b 2                    ; S&K: 28h ; Might overflow into the following data
                VoicesLow: ds.b 1                       ; S&K: 2Ah ; Low byte of pointer to track's voices, used only if zUpdatingSFX is set
                VoicesHigh: ds.b 1                      ; S&K: 2Bh ; High byte of pointer to track's voices, used only if zUpdatingSFX is set
                Stack_top: ds.b 4                       ; S&K: 2Ch-2Fh ; Track stack; can be used by LoopCounters
zTrack:         ENDSTRUCT
; ---------------------------------------------------------------------------
z80_stack:      equ     $2000
z80_stack_end:  equ     z80_stack-$60
; equates: standard (for Genesis games) addresses in the memory map
zYM2612_A0:     equ     $4000
zYM2612_D0:     equ     $4001
zYM2612_A1:     equ     $4002
zYM2612_D1:     equ     $4003
zBankRegister:  equ     $6000
zPSG:           equ     $7F11
zROMWindow:     equ     $8000
; ---------------------------------------------------------------------------
; z80 RAM:
zDataStart:     equ     $1C00
                phase   zDataStart
                ds.b    2                               ; unused
zPalFlag:       ds.b    1
                ds.b    1                               ; unused
zPalDblUpdCounter:  ds.b    1
zSoundQueue0:       ds.b    1
zSoundQueue1:       ds.b    1
zSoundQueue2:       ds.b    1
zTempoSpeedup:      ds.b    1
zNextSound:         ds.b    1
; The following 3 variables are used for M68K input
zMusicNumber:   ds.b    1                               ; Play_Sound
zSFXNumber0:    ds.b    1                               ; Play_Sound_2
zSFXNumber1:    ds.b    1                               ; Play_Sound_2

zTempVariablesStart:

zFadeOutTimeout:    ds.b    1
zFadeDelay:         ds.b    1
zFadeDelayTimeout:  ds.b    1
zPauseFlag:         ds.b    1
zHaltFlag:          ds.b    1
zFM3Settings:       ds.b    1                           ; Set twice, never read (is read in Z80 Type 1 for YM timer-related purposes)
zTempoAccumulator:  ds.b    1
                ds.b    1                               ; unused
unk_1C15:           ds.b    1                           ; Set twice, never read
zFadeToPrevFlag:    ds.b    1
unk_1C17:           ds.b    1                           ; Set once, never read
unk_1C18:           ds.b    1                           ; Set twice, never read
zUpdatingSFX:       ds.b    1
                ds.b    7                               ; unused
unk_1C21:       ds.b    1                               ; Set once, never read
                ds.b    2                               ; unused
zCurrentTempo:      ds.b    1
zContinuousSFX:     ds.b    1
zContinuousSFXFlag: ds.b    1
zSpindashRev:       ds.b    1
zRingSpeaker:       ds.b    1
zFadeInTimeout:     ds.b    1
zVoiceTblPtrSave:   ds.b    2                           ; For 1-up
zCurrentTempoSave:  ds.b    1                           ; For 1-up
zSongBankSave:      ds.b    1                           ; For 1-up
zTempoSpeedupSave:  ds.b    1                           ; For 1-up
zSpeedupTimeout:    ds.b    1
zDACIndex:          ds.b    1                           ; bit 7 = 1 if playing, 0 if not; remaining 7 bits are index into DAC tables (1-based)
zContSFXLoopCnt:    ds.b    1                           ; Used as a loop counter for continuous SFX
zSFXSaveIndex:      ds.b    1
zSongPosition:      ds.b    2
zTrackInitPos:      ds.b    2                           ; 2 bytes
zVoiceTblPtr:       ds.b    2                           ; 2 bytes
zSFXVoiceTblPtr:    ds.b    2                           ; 2 bytes
zSFXTempoDivider:   ds.b    1
                ds.b    2                               ; unused
zSongBank:          ds.b    1                           ; Bits 15 to 22 of M68K bank address
PlaySegaPCMFlag:    ds.b    1
; Now starts song and SFX z80 RAM
; Max number of music channels: 6 FM + 3 PSG or 1 DAC + 5 FM + 3 PSG
zTracksStart:
zSongFM6_DAC:   zTrack
zSongFM1:       zTrack
zSongFM2:       zTrack
zSongFM3:       zTrack
zSongFM4:       zTrack
zSongFM5:       zTrack
zSongPSG1:      zTrack
zSongPSG2:      zTrack
zSongPSG3:      zTrack
zTracksEnd:
; This is RAM for backup of songs (when 1-up jingle is playing)
; and for SFX channels. Note these two overlap
; Max number of SFX channels: 4 FM + 3 PSG
zTracksSFXStart:
zSFX_FM3:       zTrack
zSFX_FM4:       zTrack
zSFX_FM5:       zTrack
zSFX_FM6:       zTrack
zSFX_PSG1:      zTrack
zSFX_PSG2:      zTrack
zSFX_PSG3:      zTrack
zTracksSFXEnd:
                dephase

                phase   zTracksSFXStart
zTracksSaveStart:
zSaveSongDAC:   zTrack
zSaveSongFM1:   zTrack
zSaveSongFM2:   zTrack
zSaveSongFM3:   zTrack
zSaveSongFM4:   zTrack
zSaveSongFM5:   zTrack
zSaveSongPSG1:  zTrack
zSaveSongPSG2:  zTrack
zSaveSongPSG3:  zTrack
zTracksSaveEnd:

zTempVariablesEnd:
                if      * > z80_stack_end               ; Don't declare more space than the RAM can contain!
                fatal   "The RAM variable declarations are too large. It's \{*-z80_stack_end}h bytes past the start of the bottom of the stack, at \{z80_stack_end}h."
                endif
                dephase
