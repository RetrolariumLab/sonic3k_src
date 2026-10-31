; Owner: memory/shared
; Responsibility: Odd-address SRAM save allocations and backup strides
; Source provenance and ranges: config/reconstruction/source_layout.json

                padding off

; SRAM addresses
; Notes: SRAM in Sonic 3 Alone and Sonic 3 & Knuckles is 1KB in size
; Both games use odd 8-bit addresses for saving
; This means that even addresses cannot be used unless SRAM is set to use them
; Therefore, this is phased in word to skip the even bytes

SRAM_competition_size:  equ     $15*4                   ; $54 bytes
SRAM_S3game_size:       equ     $D*4                    ; $34 bytes
SRAM_SKgame_size:       equ     $15*4                   ; $54 bytes

                phase   $200001
SRAM_start:     equ     *
                ds.w    8                               ; unused
SRAM_competition:   ds.w    SRAM_competition_size       ; $54 bytes
                ds.w    2                               ; unused
SRAM_competition_backup:    ds.w    SRAM_competition_size  ; $54 bytes
                ds.w    2                               ; unused
SRAM_S3game:    ds.w    SRAM_S3game_size                ; $34 bytes
                ds.w    $12                             ; unused
SRAM_S3game_backup: ds.w    SRAM_S3game_size            ; $34 bytes
                ds.w    $12                             ; unused
SRAM_SKgame:    ds.w    SRAM_SKgame_size                ; $54 bytes
                ds.w    2                               ; unused
SRAM_SKgame_backup: ds.w    SRAM_SKgame_size            ; $54 bytes
                ds.w    $15                             ; unused
SRAM_end:       equ     *
                dephase
