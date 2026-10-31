; Owner: game/lockon/sk
; Responsibility: Local Sonic 2 lock-on object placement records retained in the accepted cartridge; no Sonic 2 game profile is implied
; Source provenance and ranges: config/reconstruction/source_layout.json

; Local lists are preserved here; external Sonic 2 lists use their own fixed ABI names
; The Sonic 2 lock-on game profile is outside this repository's reconstruction scope
S2K_Sprite_Lists:
                dc.l    S2KSprite_EHZ1                  ; 0
                dc.l    S2KSprite_EHZ2                  ; 1
                dc.l    S2KSprite_NULL                  ; 2
                dc.l    S2KSprite_NULL                  ; 3
                dc.l    S2KSprite_NULL                  ; 4
                dc.l    S2KSprite_NULL                  ; 5
                dc.l    S2KSprite_NULL                  ; 6
                dc.l    S2KSprite_NULL                  ; 7
                dc.l    S2KSprite_MTZ1                  ; 8
                dc.l    S2KSprite_MTZ2                  ; 9
                dc.l    S2KSprite_MTZ3                  ; 10
                dc.l    S2KSprite_MTZ3                  ; 11
                dc.l    S2KSprite_WFZ1                  ; 12
                dc.l    S2KSprite_WFZ2                  ; 13
                dc.l    S2KSprite_HTZ1                  ; 14
                dc.l    S2KSprite_HTZ2                  ; 15
                dc.l    S2_External_Sprite_List_16      ; fixed Sonic 2 list 16
                dc.l    S2_External_Sprite_List_17      ; fixed Sonic 2 list 17
                dc.l    S2KSprite_NULL                  ; 18
                dc.l    S2KSprite_NULL                  ; 19
                dc.l    S2KSprite_OOZ1                  ; 20
                dc.l    S2KSprite_OOZ2                  ; 21
                dc.l    S2KSprite_MCZ1                  ; 22
                dc.l    S2KSprite_MCZ2                  ; 23
                dc.l    S2_External_Sprite_List_24      ; fixed Sonic 2 list 24
                dc.l    S2_External_Sprite_List_25      ; fixed Sonic 2 list 25
                dc.l    S2KSprite_CPZ1                  ; 26
                dc.l    S2KSprite_CPZ2                  ; 27
                dc.l    S2_External_Sprite_List_28      ; fixed Sonic 2 list 28
                dc.l    S2_External_Sprite_List_29      ; fixed Sonic 2 list 29
                dc.l    S2KSprite_ARZ1                  ; 30
                dc.l    S2KSprite_ARZ2                  ; 31
                dc.l    S2_External_Sprite_List_32      ; fixed Sonic 2 list 32
                dc.l    S2_External_Sprite_List_33      ; fixed Sonic 2 list 33
                dc.w    $FFFF, 0, 0
S2KSprite_EHZ1:
                binclude "data/Levels/Misc/S2K Object Pos/EHZ_1.bin"
                even
S2KSprite_EHZ2:
                binclude "data/Levels/Misc/S2K Object Pos/EHZ_2.bin"
                even
S2KSprite_MTZ1:
                binclude "data/Levels/Misc/S2K Object Pos/MTZ_1.bin"
                even
S2KSprite_MTZ2:
                binclude "data/Levels/Misc/S2K Object Pos/MTZ_2.bin"
                even
S2KSprite_MTZ3:
                binclude "data/Levels/Misc/S2K Object Pos/MTZ_3.bin"
                even
S2KSprite_WFZ1:
                binclude "data/Levels/Misc/S2K Object Pos/WFZ_1.bin"
                even
S2KSprite_WFZ2:
                binclude "data/Levels/Misc/S2K Object Pos/WFZ_2.bin"
                even
S2KSprite_HTZ1:
                binclude "data/Levels/Misc/S2K Object Pos/HTZ_1.bin"
                even
S2KSprite_HTZ2:
                binclude "data/Levels/Misc/S2K Object Pos/HTZ_2.bin"
                even
S2KSprite_OOZ1:
                binclude "data/Levels/Misc/S2K Object Pos/OOZ_1.bin"
                even
S2KSprite_OOZ2:
                binclude "data/Levels/Misc/S2K Object Pos/OOZ_2.bin"
                even
S2KSprite_MCZ1:
                binclude "data/Levels/Misc/S2K Object Pos/MCZ_1.bin"
                even
S2KSprite_MCZ2:
                binclude "data/Levels/Misc/S2K Object Pos/MCZ_2.bin"
                even
S2KSprite_CPZ1:
                binclude "data/Levels/Misc/S2K Object Pos/CPZ_1.bin"
                even
S2KSprite_CPZ2:
                binclude "data/Levels/Misc/S2K Object Pos/CPZ_2.bin"
                even
S2KSprite_ARZ1:
                binclude "data/Levels/Misc/S2K Object Pos/ARZ_1.bin"
                even
S2KSprite_ARZ2:
                binclude "data/Levels/Misc/S2K Object Pos/ARZ_2.bin"
                even
S2KSprite_NULL:
                dc.w    $FFFF, 0, 0
