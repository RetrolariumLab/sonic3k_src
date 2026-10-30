; Owner: game/special_stage/sk
; Responsibility: Special stage palette pointer families and product-specific colour asset storage
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
SS_Pal_Map_Ptrs:
                dc.l    RAM_start+$5500
                dc.l    Pal_SStage_3_1
                dc.l    RAM_start+$5DC0
                dc.l    Pal_SStage_3_1
                dc.l    RAM_start+$5500
                dc.l    Pal_SStage_3_2
                dc.l    RAM_start+$5DC0
                dc.l    Pal_SStage_3_2
                dc.l    RAM_start+$5500
                dc.l    Pal_SStage_3_3
                dc.l    RAM_start+$5DC0
                dc.l    Pal_SStage_3_3
                dc.l    RAM_start+$5500
                dc.l    Pal_SStage_3_4
                dc.l    RAM_start+$5DC0
                dc.l    Pal_SStage_3_4
                dc.l    RAM_start+$5500
                dc.l    Pal_SStage_3_5
                dc.l    RAM_start+$5DC0
                dc.l    Pal_SStage_3_5
                dc.l    RAM_start+$5500
                dc.l    Pal_SStage_3_6
                dc.l    RAM_start+$5DC0
                dc.l    Pal_SStage_3_6
                dc.l    RAM_start+$5500
                dc.l    Pal_SStage_3_7
                dc.l    RAM_start+$5DC0
                dc.l    Pal_SStage_3_7
                dc.l    RAM_start+$5500
                dc.l    Pal_SStage_3_8
                dc.l    RAM_start+$5DC0
                dc.l    Pal_SStage_3_8
                dc.l    RAM_start+$9B00
                dc.l    Pal_SStage_3_1
                dc.l    RAM_start+$9240
                dc.l    Pal_SStage_3_1
                dc.l    RAM_start+$8980
                dc.l    Pal_SStage_3_1
                dc.l    RAM_start+$80C0
                dc.l    Pal_SStage_3_1
                dc.l    RAM_start+$7800
                dc.l    Pal_SStage_3_1
                dc.l    RAM_start+$6F40
                dc.l    Pal_SStage_3_1
                dc.l    RAM_start+$6680
                dc.l    Pal_SStage_3_1
Pal_SStage_Main:
                binclude "data/General/Special Stage/Palettes/Main.bin"
                even
Pal_SStage_Knux:
                binclude "data/General/Special Stage/Palettes/Knux Patch.bin"
                even
Pal_SStage_3_1:
                binclude "data/General/Special Stage/Palettes/3-1.bin"
                even
Pal_SStage_3_2:
                binclude "data/General/Special Stage/Palettes/3-2.bin"
                even
Pal_SStage_3_3:
                binclude "data/General/Special Stage/Palettes/3-3.bin"
                even
Pal_SStage_3_4:
                binclude "data/General/Special Stage/Palettes/3-4.bin"
                even
Pal_SStage_3_5:
                binclude "data/General/Special Stage/Palettes/3-5.bin"
                even
Pal_SStage_3_6:
                binclude "data/General/Special Stage/Palettes/3-6.bin"
                even
Pal_SStage_3_7:
                binclude "data/General/Special Stage/Palettes/3-7.bin"
                even
Pal_SStage_3_8:
                binclude "data/General/Special Stage/Palettes/3-8.bin"
                even
Pal_SStage_K_1:
                binclude "data/General/Special Stage/Palettes/K-1.bin"
                even
Pal_SStage_K_2:
                binclude "data/General/Special Stage/Palettes/K-2.bin"
                even
Pal_SStage_K_3:
                binclude "data/General/Special Stage/Palettes/K-3.bin"
                even
Pal_SStage_K_4:
                binclude "data/General/Special Stage/Palettes/K-4.bin"
                even
Pal_SStage_K_5:
                binclude "data/General/Special Stage/Palettes/K-5.bin"
                even
Pal_SStage_K_6:
                binclude "data/General/Special Stage/Palettes/K-6.bin"
                even
Pal_SStage_K_7:
                binclude "data/General/Special Stage/Palettes/K-7.bin"
                even
Pal_SStage_K_8:
                binclude "data/General/Special Stage/Palettes/K-8.bin"
                even

; =============== S U B R O U T I N E =======================================
