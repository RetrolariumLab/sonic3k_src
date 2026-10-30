; Owner: game/special_stage/s3
; Responsibility: Special stage palette pointer families and product-specific colour asset storage
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
SS_Pal_Map_Ptrs:
                dc.l    MapUnc_SStageLayout
                dc.l    Pal_SStage_1
                dc.l    MapUnc_SStageLayout+$8C0
                dc.l    Pal_SStage_1
                dc.l    MapUnc_SStageLayout
                dc.l    Pal_SStage_2
                dc.l    MapUnc_SStageLayout+$8C0
                dc.l    Pal_SStage_2
                dc.l    MapUnc_SStageLayout
                dc.l    Pal_SStage_3
                dc.l    MapUnc_SStageLayout+$8C0
                dc.l    Pal_SStage_3
                dc.l    MapUnc_SStageLayout
                dc.l    Pal_SStage_4
                dc.l    MapUnc_SStageLayout+$8C0
                dc.l    Pal_SStage_4
                dc.l    MapUnc_SStageLayout
                dc.l    Pal_SStage_5
                dc.l    MapUnc_SStageLayout+$8C0
                dc.l    Pal_SStage_5
                dc.l    MapUnc_SStageLayout
                dc.l    Pal_SStage_6
                dc.l    MapUnc_SStageLayout+$8C0
                dc.l    Pal_SStage_6
                dc.l    MapUnc_SStageLayout
                dc.l    Pal_SStage_7
                dc.l    MapUnc_SStageLayout+$8C0
                dc.l    Pal_SStage_7
                dc.l    MapUnc_SStageLayout
                dc.l    Pal_SStage_8
                dc.l    MapUnc_SStageLayout+$8C0
                dc.l    Pal_SStage_8
                dc.l    MapUnc_SStageLayout+$4600
                dc.l    Pal_SStage_1
                dc.l    MapUnc_SStageLayout+$3D40
                dc.l    Pal_SStage_1
                dc.l    MapUnc_SStageLayout+$3480
                dc.l    Pal_SStage_1
                dc.l    MapUnc_SStageLayout+$2BC0
                dc.l    Pal_SStage_1
                dc.l    MapUnc_SStageLayout+$2300
                dc.l    Pal_SStage_1
                dc.l    MapUnc_SStageLayout+$1A40
                dc.l    Pal_SStage_1
                dc.l    MapUnc_SStageLayout+$1180
                dc.l    Pal_SStage_1
Pal_SStage_Main:
                binclude "data/General/Special Stage/Palettes/Main.bin"
                even
Pal_SStage_1:
                binclude "data/General/Special Stage/Palettes/3-1.bin"
                even
Pal_SStage_2:
                binclude "data/General/Special Stage/Palettes/3-2.bin"
                even
Pal_SStage_3:
                binclude "data/General/Special Stage/Palettes/3-3.bin"
                even
Pal_SStage_4:
                binclude "data/General/Special Stage/Palettes/3-4.bin"
                even
Pal_SStage_5:
                binclude "data/General/Special Stage/Palettes/3-5.bin"
                even
Pal_SStage_6:
                binclude "data/General/Special Stage/Palettes/3-6.bin"
                even
Pal_SStage_7:
                binclude "data/General/Special Stage/Palettes/3-7.bin"
                even
Pal_SStage_8:
                binclude "data/General/Special Stage/Palettes/3-8 S3.bin"
                even

; =============== S U B R O U T I N E =======================================
