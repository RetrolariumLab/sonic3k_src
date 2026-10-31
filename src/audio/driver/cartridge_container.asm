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
                include "src/audio/driver/ram_layout.asm"
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
                include "src/audio/driver/banking_helpers.asm"
                include "src/audio/driver/interrupts_and_bootstrap.asm"
                include "src/audio/driver/music_track_update.asm"
                include "src/audio/driver/fm_parameters.asm"
                include "src/audio/driver/sound_loading.asm"
                include "src/audio/driver/playback_control.asm"
                include "src/audio/driver/frequency_tables.asm"
                include "src/audio/driver/dac_dispatch.asm"
                include "src/audio/driver/instrument_commands.asm"
                include "src/audio/driver/flow_commands.asm"
                include "src/audio/driver/meta_commands.asm"
                include "src/audio/driver/psg_track_update.asm"
                include "src/audio/driver/digital_sample_playback.asm"
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
                include "src/audio/driver/driver_pointer_tables.asm"
; ===========================================================================
                restore
                padding off
                !org    Z80_SoundDriverData+Size_of_Snd_driver2_guess  ; The assembler still thinks we're in Z80 memory, so use an 'org' to switch back to the cartridge
