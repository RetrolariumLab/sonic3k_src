; Owner: game/level/s3
; Responsibility: Switch reset and default empty screen, background and deformation handlers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Clear_Switches:
                lea     (Level_trigger_array).w,a1
                moveq   #bytesToLcnt($20),d0

                .loop:
                clr.l   (a1)+
                dbf     d0,.loop
                rts
; End of function Clear_Switches

; ---------------------------------------------------------------------------

NoScreenInit:
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

NoScreenEvent:
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

NoBackgroundInit:
                jsr     No_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                jsr     Refresh_PlaneFull(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

NoBackgroundEvent:
                jsr     No_Deform(pc)
                jsr     DrawBGAsYouMove(pc)
                jmp     PlainDeformation(pc)

; =============== S U B R O U T I N E =======================================

No_Deform:
                move.w  (Camera_X_pos_copy).w,d0
                asr.w   #3,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                move.w  (Camera_Y_pos_copy).w,d0
                asr.w   #3,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                rts
; End of function No_Deform
