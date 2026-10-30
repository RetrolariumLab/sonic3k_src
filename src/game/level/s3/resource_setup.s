; Owner: game/level/s3
; Responsibility: Level setup entry, descriptor loading and initial level resource dispatch
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

j_LevelSetup:
                jmp     (LevelSetup).l
; End of function j_LevelSetup

; =============== S U B R O U T I N E =======================================

LoadLevelLoadBlock2:
                move.w  (Current_zone_and_act).w,d0
                bne.s   loc_1A77A
                cmpi.w  #2,(Player_mode).w
                beq.s   loc_1A776
                tst.b   (Last_star_post_hit).w
                beq.s   loc_1A77A

loc_1A776:
                move.w  #$D00,d0

loc_1A77A:
                ror.b   #1,d0
                lsr.w   #4,d0
                andi.w  #$1F8,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                lea     (LevelLoadBlock).l,a2
                lea     (a2,d0.w),a2
                move.l  a2,-(sp)
                addq.w  #8,a2
                move.l  (a2)+,d0
                andi.l  #$FFFFFF,d0
                move.l  d0,d7
                movea.l d0,a0
                lea     (Block_table).w,a1
                jsr     (Kos_Decomp).l
                move.l  (a2)+,d0
                andi.l  #$FFFFFF,d0
                cmp.l   d0,d7
                beq.s   loc_1A7C0
                movea.l d0,a0
                jsr     (Kos_Decomp).l

loc_1A7C0:
                move.l  (a2)+,d0
                andi.l  #$FFFFFF,d0
                move.l  d0,d7
                movea.l d0,a0
                lea     (RAM_start).l,a1
                jsr     (Kos_Decomp).l
                move.l  (a2)+,d0
                andi.l  #$FFFFFF,d0
                cmp.l   d0,d7
                beq.s   loc_1A7EC
                movea.l d0,a0
                jsr     (Kos_Decomp).l

loc_1A7EC:
                bsr.w   Load_Level
                movea.l (sp)+,a2
                move.b  (a2),d1
                addq.w  #4,a2
                moveq   #0,d0
                move.b  (a2),d0
                beq.s   loc_1A806
                cmp.b   d0,d1
                beq.s   loc_1A806
                jsr     (Load_PLC).l

loc_1A806:
                addq.w  #4,a2
                moveq   #0,d0
                move.b  (a2),d0
                jsr     (LoadPalette).l
                rts
; End of function LoadLevelLoadBlock2

; =============== S U B R O U T I N E =======================================

Load_Level:
                moveq   #0,d0
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #5,d0
                andi.w  #$FC,d0
                lea     (LevelPtrs).l,a0
                movea.l (a0,d0.w),a0
                lea     (Level_layout_header).w,a1
                move.w  #bytesToWcnt($1000),d2

                .loop:
                move.w  (a0)+,(a1)+
                dbf     d2,.loop
                rts
; End of function Load_Level
