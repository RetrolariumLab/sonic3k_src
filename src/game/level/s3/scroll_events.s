; Owner: game/level/s3
; Responsibility: Tile-offset reset, camera scroll state, special events, screen shake and transition offsets with private wave tables
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Reset_TileOffsetPositionActual:
                move.w  (Camera_X_pos_copy).w,d0
                move.w  d0,d1
                andi.w  #$FFF0,d0
                move.w  d0,(Camera_X_pos_rounded).w
                move.w  (Camera_Y_pos_copy).w,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Camera_Y_pos_rounded).w
                rts
; End of function Reset_TileOffsetPositionActual

; =============== S U B R O U T I N E =======================================

Reset_TileOffsetPositionEff:
                move.w  (Camera_X_pos_BG_copy).w,d0
                move.w  d0,d1
                andi.w  #$FFF0,d0
                move.w  d0,d2
                move.w  d0,(Camera_X_pos_BG_rounded).w
                move.w  (Camera_Y_pos_BG_copy).w,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Camera_Y_pos_BG_rounded).w
                rts
; End of function Reset_TileOffsetPositionEff

; =============== S U B R O U T I N E =======================================

Update_CameraPositionP2:
                move.w  (Camera_X_pos_P2).w,(Camera_X_pos_P2_copy).w
                move.w  (Camera_Y_pos_P2).w,(Camera_Y_pos_P2_copy).w
                rts
; End of function Update_CameraPositionP2

; ---------------------------------------------------------------------------

Update_VScrollValueP2:
                move.w  (Camera_Y_pos_P2_copy).w,d0
                subi.w  #$70,d0
                move.w  d0,(V_scroll_value_P2).w
                move.w  (Camera_Y_pos_P2_BG_copy).w,d0
                subi.w  #$70,d0
                move.w  d0,(V_scroll_value_BG_P2).w
                rts

; =============== S U B R O U T I N E =======================================

SpecialEvents:
                cmpi.b  #6,(Player_1+routine).w
                bhs.s   locret_3A07E
                move.w  (Special_events_routine).w,d0
                movea.l SpecialEvents_Index(pc,d0.w),a0
                jmp     (a0)
; ---------------------------------------------------------------------------
SpecialEvents_Index:
                dc.l    locret_3A07E
                dc.l    AIZ2_DoShipLoop
; ---------------------------------------------------------------------------

locret_3A07E:
                rts
; End of function SpecialEvents

; =============== S U B R O U T I N E =======================================

Adjust_BGDuringLoop:
                move.w  (a1),d1
                move.w  d0,(a1)+
                sub.w   d1,d0
                bpl.s   loc_3A094
                neg.w   d0
                cmp.w   d2,d0
                blo.s   loc_3A090
                sub.w   d3,d0

loc_3A090:
                sub.w   d0,(a1)+
                rts
; ---------------------------------------------------------------------------

loc_3A094:
                cmp.w   d2,d0
                blo.s   loc_3A09A
                sub.w   d3,d0

loc_3A09A:
                add.w   d0,(a1)+
                rts
; End of function Adjust_BGDuringLoop

; =============== S U B R O U T I N E =======================================

Get_BGActualEffectiveDiff:
                move.w  (Camera_X_pos_copy).w,d0
                sub.w   (Camera_X_pos_BG_copy).w,d0
                move.w  d0,(Camera_X_diff).w
                move.w  (Camera_Y_pos_copy).w,d0
                sub.w   (Camera_Y_pos_BG_copy).w,d0
                move.w  d0,(Camera_Y_diff).w
                rts
; End of function Get_BGActualEffectiveDiff

; =============== S U B R O U T I N E =======================================

ShakeScreen_Setup:
                move.w  (Screen_shake_offset).w,(Screen_shake_last_offset).w
                cmpi.b  #6,(Player_1+routine).w
                bhs.s   loc_3A0F2
                move.w  (Screen_shake_flag).w,d0
                beq.s   loc_3A0F2
                bmi.s   loc_3A0E0
                subq.w  #1,d0                           ; If EECC is positive, then it's a timed screen shake
                move.w  d0,(Screen_shake_flag).w
                move.b  ScreenShakeArray(pc,d0.w),d0
                ext.w   d0
                move.w  d0,(Screen_shake_offset).w
                rts
; ---------------------------------------------------------------------------

loc_3A0E0:
                move.w  (Level_frame_counter).w,d0      ; If EECC is negative, it's a constant screen shake
                andi.w  #$3F,d0
                move.b  ScreenShakeArray2(pc,d0.w),d0
                move.w  d0,(Screen_shake_offset).w
                rts
; ---------------------------------------------------------------------------

loc_3A0F2:
                clr.w   (Screen_shake_offset).w
                rts
; End of function ShakeScreen_Setup

; =============== S U B R O U T I N E =======================================

Offset_ObjectsDuringTransition:
                lea     (Dynamic_object_RAM+object_size).w,a1
                moveq   #((Breathing_bubbles)-(Dynamic_object_RAM+object_size))/object_size-1,d2

loc_3A0FE:
                tst.l   (a1)
                beq.s   loc_3A112
                btst    #2,render_flags(a1)
                beq.s   loc_3A112
                sub.w   d0,x_pos(a1)
                sub.w   d1,y_pos(a1)

loc_3A112:
                lea     next_object(a1),a1
                dbf     d2,loc_3A0FE
                rts
; End of function Offset_ObjectsDuringTransition

; ---------------------------------------------------------------------------
ScreenShakeArray:
                dc.b    1, -1,  1, -1,  2, -2,  2, -2,  3, -3,  3, -3,  4, -4,  4, -4
                dc.b    5, -5,  5, -5
ScreenShakeArray2:
                dc.b    1,  2,  1,  3,  1,  2,  2,  1,  2,  3,  1,  2,  1,  2,  0,  0
                dc.b    2,  0,  3,  2,  2,  3,  2,  2,  1,  3,  0,  0,  1,  0,  1,  3
                dc.b    1,  2,  1,  3,  1,  2,  2,  1,  2,  3,  1,  2,  1,  2,  0,  0
                dc.b    2,  0,  3,  2,  2,  3,  2,  2,  1,  3,  0,  0,  1,  0,  1,  3
                even
AIZ1_WaterFGDeformDelta:
                dc.w    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0
                dc.w    0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
                dc.w    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0
                dc.w    0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1
                dc.w    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0
                dc.w    0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
                dc.w    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0
                dc.w    0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1
                dc.w    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0
                dc.w    0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
                dc.w    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0
                dc.w    0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1
                dc.w    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0
                dc.w    0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
                dc.w    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0
                dc.w    0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1
                dc.w    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0
                dc.w    0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
AIZ1_WaterBGDeformDelta:
                dc.w    0,  0, -1, -1, -1, -1, -1, -1,  0,  0,  0,  1,  1,  1,  1,  1
                dc.w    1,  0,  0,  0, -1, -1, -1, -1, -1, -1,  0,  0,  0,  1,  1,  1
                dc.w    1,  1,  1,  0,  0,  0, -1, -1, -1, -1, -1, -1,  0,  0,  0,  1
                dc.w    1,  1,  1,  1,  1,  0, -1, -2, -2, -1,  0,  2,  2,  2,  2,  0
                dc.w    0,  0, -1, -1, -1, -1, -1, -1,  0,  0,  0,  1,  1,  1,  1,  1
                dc.w    1,  0,  0,  0, -1, -1, -1, -1, -1, -1,  0,  0,  0,  1,  1,  1
LBZ_WaterWaveArray2:
                dc.w    1,  1,  1,  0,  0,  0, -1, -1, -1, -1, -1, -1,  0,  0,  0,  1
                dc.w    1,  1,  1,  1,  1,  0, -1, -2, -2, -1,  0,  2,  2,  2,  2,  0
                dc.w    0,  0, -1, -1, -1, -1, -1, -1,  0,  0,  0,  1,  1,  1,  1,  1
                dc.w    1,  0,  0,  0, -1, -1, -1, -1, -1, -1,  0,  0,  0,  1,  1,  1
                dc.w    1,  1,  1,  0,  0,  0, -1, -1, -1, -1, -1, -1,  0,  0,  0,  1
                dc.w    1,  1,  1,  1,  1,  0, -1, -2, -2, -1,  0,  2,  2,  2,  2,  0
                dc.w    0,  0, -1, -1, -1, -1, -1, -1,  0,  0,  0,  1,  1,  1,  1,  1
                dc.w    1,  0,  0,  0, -1, -1, -1, -1, -1, -1,  0,  0,  0,  1,  1,  1
LBZ_WaterWaveArray:
                dc.w    1,  1,  1,  0,  0,  0, -1, -1, -1, -1, -1, -1,  0,  0,  0,  1
                dc.w    1,  1,  1,  1,  1,  0, -1, -2, -2, -1,  0,  2,  2,  2,  2,  0
                dc.w    0,  0, -1, -1, -1, -1, -1, -1,  0,  0,  0,  1,  1,  1,  1,  1
                dc.w    1,  0,  0,  0, -1, -1, -1, -1, -1, -1,  0,  0,  0,  1,  1,  1
