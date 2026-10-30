; Owner: rendering/s3
; Responsibility: Zone enemy-art selection, decompression queue dispatch and product-specific pattern-load catalogs
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

LoadEnemyArt:
                lea     Offs_LoadEnemyArt(pc),a6
                move.w  (Apparent_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #6,d0
                adda.w  (a6,d0.w),a6
                move.w  (a6)+,d6
                bmi.s   .return

                .loop:
                movea.l (a6)+,a1
                move.w  (a6)+,d2
                jsr     (Queue_Kos_Module).l
                dbf     d6,.loop

                .return:
                rts
; End of function LoadEnemyArt

; ---------------------------------------------------------------------------
Offs_LoadEnemyArt:
                dc.w    PLCKosM_AIZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_AIZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_HCZ1-Offs_LoadEnemyArt
                dc.w    PLCKosM_HCZ2-Offs_LoadEnemyArt
                dc.w    PLCKosM_MGZ1-Offs_LoadEnemyArt
                dc.w    PLCKosM_MGZ2-Offs_LoadEnemyArt
                dc.w    PLCKosM_CNZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_CNZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_FBZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_FBZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_ICZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_ICZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_LBZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_LBZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_LBZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_LBZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_LBZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_LBZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_LBZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_LBZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_LBZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_LBZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_LBZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_LBZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_LBZ-Offs_LoadEnemyArt
                dc.w    PLCKosM_LBZ-Offs_LoadEnemyArt

PLCKosM_AIZ:    plrlistheader
                plreq   ArtTile_MonkeyDude, ArtKosM_AIZ_MonkeyDude
                plreq   ArtTile_Bloominator, ArtKosM_AIZ_Bloominator
                plreq   ArtTile_CaterkillerJr, ArtKosM_AIZ_CaterkillerJr
PLCKosM_AIZ_End:

PLCKosM_HCZ1:   plrlistheader
                plreq   ArtTile_Blastoid, ArtKosM_Blastoid
                plreq   ArtTile_TurboSpiker, ArtKosM_TurboSpiker
                plreq   ArtTile_MegaChopper, ArtKosM_MegaChopper
                plreq   ArtTile_Pointdexter, ArtKosM_Pointdexter
PLCKosM_HCZ1_End:

PLCKosM_HCZ2:   plrlistheader
                plreq   ArtTile_Jawz, ArtKosM_Jawz
                plreq   ArtTile_TurboSpiker, ArtKosM_TurboSpiker
                plreq   ArtTile_MegaChopper, ArtKosM_MegaChopper
                plreq   ArtTile_Pointdexter, ArtKosM_Pointdexter
PLCKosM_HCZ2_End:

PLCKosM_MGZ1:   plrlistheader
                plreq   ArtTile_Spiker, ArtKosM_Spiker
                plreq   ArtTile_MGZMiniboss, ArtKosM_MGZMiniboss
                plreq   ArtTile_MGZMiniBossDebris, ArtKosM_MGZEndBossDebris
PLCKosM_MGZ1_End:

PLCKosM_MGZ2:   plrlistheader
                plreq   ArtTile_Spiker, ArtKosM_Spiker
                plreq   ArtTile_Mantis, ArtKosM_Mantis
PLCKosM_MGZ2_End:

PLCKosM_CNZ:    plrlistheader
                plreq   ArtTile_Sparkle, ArtKosM_Sparkle
                plreq   ArtTile_Batbot, ArtKosM_Batbot
                plreq   ArtTile_Clamer+$70, ArtKosM_ClamerShot
                plreq   ArtTile_CNZBalloon, ArtKosM_CNZBalloon
PLCKosM_CNZ_End:

PLCKosM_FBZ:    plrlistheader
                plreq   ArtTile_Blaster-6, ArtKosM_Blaster
                plreq   ArtTile_Technosqueek-6, ArtKosM_Technosqueek
PLCKosM_FBZ_End:

PLCKosM_ICZ:    plrlistheader
                plreq   ArtTile_ICZSnowdust, ArtKosM_ICZSnowdust
                plreq   ArtTile_StarPointer, ArtKosM_StarPointer
PLCKosM_ICZ_End:

PLCKosM_LBZ:    plrlistheader
                plreq   ArtTile_SnaleBlaster, ArtKosM_SnaleBlaster
                plreq   ArtTile_Orbinaut, ArtKosM_Orbinaut
                plreq   ArtTile_Ribot, ArtKosM_Ribot
                plreq   ArtTile_Corkey, ArtKosM_Corkey
PLCKosM_LBZ_End:
