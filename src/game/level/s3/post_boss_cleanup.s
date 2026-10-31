; Owner: game/level/s3
; Responsibility: Post-boss zone-specific cleanup dispatch and replacement graphics or palettes
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

AfterBoss_Cleanup:
                moveq   #0,d0
                lea     (Current_zone_and_act).w,a1
                move.b  (a1)+,d0
                add.b   d0,d0
                add.b   (a1)+,d0
                add.b   d0,d0
                move.w  AfterBoss_Index(pc,d0.w),d0
                jmp     AfterBoss_Index(pc,d0.w)
; End of function AfterBoss_Cleanup

; ---------------------------------------------------------------------------
AfterBoss_Index:
                dc.w    AfterBoss_AIZ1-AfterBoss_Index
                dc.w    AfterBoss_AIZ2-AfterBoss_Index
                dc.w    AfterBoss_HCZ-AfterBoss_Index
                dc.w    AfterBoss_HCZ-AfterBoss_Index
                dc.w    AfterBoss_MGZ-AfterBoss_Index
                dc.w    AfterBoss_MGZ-AfterBoss_Index
                dc.w    AfterBoss_CNZ-AfterBoss_Index
                dc.w    AfterBoss_CNZ-AfterBoss_Index
                dc.w    AfterBoss_FBZ-AfterBoss_Index
                dc.w    AfterBoss_FBZ-AfterBoss_Index
                dc.w    AfterBoss_ICZ1-AfterBoss_Index
                dc.w    AfterBoss_ICZ2-AfterBoss_Index
                dc.w    AfterBoss_LBZ-AfterBoss_Index
                dc.w    AfterBoss_LBZ-AfterBoss_Index
; ---------------------------------------------------------------------------

AfterBoss_AIZ1:
                lea     (Pal_AIZ).l,a1
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($60),d0

                .loop:
                move.l  (a1)+,(a2)+
                dbf     d0,.loop
                rts
; ---------------------------------------------------------------------------

AfterBoss_AIZ2:
                lea     (Pal_AIZFire).l,a1
                jsr     (PalLoad_Line1).l
                lea     PLC_AfterMiniboss_AIZ(pc),a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

AfterBoss_HCZ:
                rts
; ---------------------------------------------------------------------------

AfterBoss_MGZ:
                lea     PLC_MonitorsSpikesSprings(pc),a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

AfterBoss_CNZ:
AfterBoss_FBZ:
AfterBoss_ICZ1:
                rts
; ---------------------------------------------------------------------------

AfterBoss_ICZ2:
                lea     (Pal_ICZ2).l,a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

AfterBoss_LBZ:
                rts
