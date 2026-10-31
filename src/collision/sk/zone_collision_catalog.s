; Owner: collision/sk
; Responsibility: Zone collision index mode, pointers and complete extracted collision resource bindings
; Source provenance and ranges: config/reconstruction/source_layout.json
Noninterleaved_Solid_Flag   EQU     0

SolidIndexes:
                dc.l    Solid_AIZ1+1+Noninterleaved_Solid_Flag
                dc.l    Solid_AIZ2+1+Noninterleaved_Solid_Flag
                dc.l    Solid_HCZ1+1+Noninterleaved_Solid_Flag
                dc.l    Solid_HCZ2+1+Noninterleaved_Solid_Flag
                dc.l    Solid_MGZ1+1+Noninterleaved_Solid_Flag
                dc.l    Solid_MGZ2+1+Noninterleaved_Solid_Flag
                dc.l    Solid_CNZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_CNZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_FBZ
                dc.l    Solid_FBZ
                dc.l    Solid_ICZ1+1+Noninterleaved_Solid_Flag
                dc.l    Solid_ICZ2+1+Noninterleaved_Solid_Flag
                dc.l    Solid_LBZ1+1+Noninterleaved_Solid_Flag
                dc.l    Solid_LBZ2+1+Noninterleaved_Solid_Flag
                dc.l    Solid_MHZ
                dc.l    Solid_MHZ
                dc.l    Solid_SOZ
                dc.l    Solid_SOZ
                dc.l    Solid_LRZ1
                dc.l    Solid_LRZ2
                dc.l    Solid_SSZ1
                dc.l    Solid_SSZ2
                dc.l    Solid_DEZ
                dc.l    Solid_DEZ
                dc.l    Solid_DDZ
                dc.l    Solid_DDZ
                dc.l    Solid_Pachinko_Special
                dc.l    Solid_Pachinko_Special
                dc.l    Solid_ALZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_ALZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_BPZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_BPZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_DPZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_DPZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_CGZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_CGZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_EMZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_EMZ+1+Noninterleaved_Solid_Flag
                dc.l    Solid_Gumball_Special+1+Noninterleaved_Solid_Flag
                dc.l    Solid_Gumball_Special+1+Noninterleaved_Solid_Flag
                dc.l    Solid_Pachinko_Special
                dc.l    Solid_Pachinko_Special
                dc.l    Solid_Slots_Special
                dc.l    Solid_Slots_Special
                dc.l    Solid_LRZBoss
                dc.l    Solid_HPZ
                dc.l    Solid_HPZ
                dc.l    Solid_HPZ
Solid_FBZ:
                binclude "data/Levels/FBZ/Collision/1.bin"
                even
Solid_MHZ:
                binclude "data/Levels/MHZ/Collision/1.bin"
                even
Solid_Unknown:
                binclude "data/Levels/Misc/Unknown Collision.bin"
                even
Solid_SOZ:
                binclude "data/Levels/SOZ/Collision/1.bin"
                even
Solid_LRZ1:
                binclude "data/Levels/LRZ/Collision/1.bin"
                even
Solid_LRZ2:
                binclude "data/Levels/LRZ/Collision/2.bin"
                even
Solid_SSZ1:
                binclude "data/Levels/SSZ/Collision/1.bin"
                even
Solid_SSZ2:
                binclude "data/Levels/SSZ/Collision/2.bin"
                even
Solid_DEZ:
                binclude "data/Levels/DEZ/Collision/1.bin"
                even
Solid_DDZ:
                binclude "data/Levels/DDZ/Collision/1.bin"
                even
Solid_Pachinko_Special:
                binclude "data/Levels/Pachinko/Collision/1.bin"
                even
Solid_Slots_Special:
                binclude "data/Levels/Slots/Collision/1.bin"
                even

Solid_LRZBoss:
                binclude "data/Levels/LRZ/Collision/3.bin"
                even
Solid_HPZ:
                binclude "data/Levels/HPZ/Collision/1.bin"
                even
