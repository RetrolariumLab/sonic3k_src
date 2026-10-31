; ---------------------------------------------------------------------------
; ===========================================================================
; |                                                                         |
; |                             SONIC&K SOUND DRIVER                        |
; |                         Modified SMPS Z80 Type 2 DAC                    |
; |                                                                         |
; ===========================================================================
; Disassembled by MarkeyJester
; Routines, pointers and stuff by Linncaki
; Thoroughly commented and improved (including optional bugfixes) by Flamewing
; ===========================================================================
; Constants
; ===========================================================================

z80_SoundDriverStart:

; ---------------------------------------------------------------------------
                include "src/audio/driver/ram_layout.s"
; ---------------------------------------------------------------------------
                !org    z80_SoundDriverStart            ; Rewind the ROM address to where we were earlier (allocating the RAM above messes with it)
; z80_SoundDriver:
Z80_SoundDriver:
                org     Z80_SoundDriver+Size_of_Snd_driver_guess  ; This 'org' inserts some padding that we can paste the compressed sound driver over later (see the 's3p2bin' tool)

                save
                !org    0                               ; z80 Align, handled by the build process
                CPU     Z80
                listing purecode
; ---------------------------------------------------------------------------
                include "src/audio/driver/banking_helpers.s"
                include "src/audio/driver/interrupts_and_bootstrap.s"
                include "src/audio/driver/music_track_update.s"
                include "src/audio/driver/fm_modulation_and_instruments.s"
                include "src/audio/driver/sound_loading.s"
                include "src/audio/driver/pause_fades_and_pcm_dispatch.s"
                include "src/audio/driver/frequency_and_bank_tables.s"
                include "src/audio/driver/dac_and_coordination_dispatch.s"
                include "src/audio/driver/coordination_volume_and_instruments.s"
                include "src/audio/driver/coordination_modulation_and_flow.s"
                include "src/audio/driver/coordination_meta_and_tempo.s"
                include "src/audio/driver/psg_track_update.s"
                include "src/audio/driver/digital_sample_playback.s"
                if      $ > 1300h
                fatal   "Your Z80 code won't fit before its tables. It's \{$-1300h}h bytes past the start of music data \{1300h}h"
                endif

                restore
                padding off
                !org    Z80_SoundDriver+Size_of_Snd_driver_guess  ; The assembler still thinks we're in Z80 memory, so use an 'org' to switch back to the cartridge

; Z80_Snd_Driver2:
Z80_SoundDriverData:
                org     Z80_SoundDriverData+Size_of_Snd_driver2_guess  ; Once again, create some padding that we can paste the compressed data over later
; ---------------------------------------------------------------------------
                save
                CPU     Z80
                listing purecode
                !org    1300h                           ; z80 Align, handled by the build process
; ---------------------------------------------------------------------------
                include "src/audio/driver/driver_pointer_tables.s"
; ===========================================================================
                restore
                padding off
                !org    Z80_SoundDriverData+Size_of_Snd_driver2_guess  ; The assembler still thinks we're in Z80 memory, so use an 'org' to switch back to the cartridge
