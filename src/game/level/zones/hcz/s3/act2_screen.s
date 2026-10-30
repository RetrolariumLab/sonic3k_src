; Owner: game/level/zones/hcz/s3
; Responsibility: Hydrocity act-two screen and background initialization, events, deformation and private geometry
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

HCZ2_ScreenInit:
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

HCZ2_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

HCZ2_BackgroundInit:
                cmpi.w  #$C00,(Camera_X_pos_copy).w
                bhs.s   loc_3C5E8
                cmpi.w  #$500,(Camera_Y_pos_copy).w
                blo.s   loc_3C5E8
                move.w  #4,(Events_routine_bg).w        ; Special deformation occurs when camera X is less than $C00 and camera Y is greater than $500
                jsr     HCZ2_WallMove(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                jsr     Refresh_PlaneFull(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

loc_3C5E8:
                move.w  #$10,(Events_routine_bg).w      ; Normal deformation
                jsr     HCZ2_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                lea     HCZ2_BGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

HCZ2_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     HCZ2_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

HCZ2_BackgroundEvent_Index:
                bra.w   HCZ2BGE_WallMoveInit
; ---------------------------------------------------------------------------
                bra.w   HCZ2BGE_WallMove
; ---------------------------------------------------------------------------
                bra.w   HCZ2BGE_NormalTransition
; ---------------------------------------------------------------------------
                bra.w   HCZ2BGE_NormalRefresh
; ---------------------------------------------------------------------------
                bra.w   HCZ2BGE_Normal
; ---------------------------------------------------------------------------

HCZ2BGE_WallMoveInit:
                addq.w  #4,(Events_routine_bg).w

HCZ2BGE_WallMove:
                tst.w   (Events_fg_5).w
                bne.s   loc_3C66C
                jsr     HCZ2_WallMove(pc)
                jsr     DrawBGAsYouMove(pc)
                jsr     PlainDeformation(pc)
                jsr     ShakeScreen_Setup(pc)
                jsr     Get_BGActualEffectiveDiff(pc)
                clr.b   (Background_collision_flag).w
                move.w  (Player_1+x_pos).w,d0
                cmpi.w  #$3F0,d0
                blo.s   locret_3C66A
                cmpi.w  #$C10,d0
                bhs.s   locret_3C66A
                move.w  (Player_1+y_pos).w,d0
                cmpi.w  #$600,d0
                blo.s   locret_3C66A
                cmpi.w  #$840,d0
                bhs.s   locret_3C66A
                st      (Background_collision_flag).w   ; Only enable BG tile collision if player is within above parameters

locret_3C66A:
                rts
; ---------------------------------------------------------------------------

loc_3C66C:
                clr.w   (Events_fg_5).w
                tst.w   (Screen_shake_flag).w
                bpl.s   loc_3C67A
                clr.w   (Screen_shake_flag).w           ; Disable screen shaking if still constant

loc_3C67A:
                clr.b   (Background_collision_flag).w
                move.w  #$F0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w

HCZ2BGE_NormalTransition:
                move.w  #$400,d1
                moveq   #0,d2
                jsr     Draw_PlaneVertSingleBottomUp(pc)
                bpl.w   PlainDeformation
                jsr     HCZ2_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_3C6C0
; ---------------------------------------------------------------------------

HCZ2BGE_NormalRefresh:
                jsr     HCZ2_Deform(pc)

loc_3C6C0:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.s   loc_3C6D6
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_3C6D6
; ---------------------------------------------------------------------------

HCZ2BGE_Normal:
                jsr     HCZ2_Deform(pc)

loc_3C6D6:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                lea     HCZ2_BGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)

; =============== S U B R O U T I N E =======================================

HCZ2_WallMove:
                cmpi.b  #6,(Player_1+routine).w
                bhs.s   loc_3C754                       ; If player is dead, don't bother
                move.l  #$E000,d0
                cmpi.w  #$A88,(Player_1+x_pos).w
                blo.s   loc_3C70E
                move.l  #$14000,d0                      ; Speed up if player has passed the end already

loc_3C70E:
                move.w  (Events_bg+$00).w,d1
                beq.s   loc_3C730
                cmpi.w  #-$600,d1
                bgt.s   loc_3C73C
                tst.w   (Screen_shake_flag).w           ; When wall has travelled $600 pixels
                bpl.s   loc_3C754
                move.w  #$E,(Screen_shake_flag).w       ; Set screen shake to timed
                moveq   #signextendB(sfx_Crash),d0
                jsr     (Play_SFX).l                    ; Play final crashing sound
                bra.s   loc_3C754
; ---------------------------------------------------------------------------

loc_3C730:
                cmpi.w  #$680,(Player_1+x_pos).w
                blo.s   loc_3C754                       ; If wall hasn't started moving and player hasn't moved far enough, end
                st      (Screen_shake_flag).w           ; Begin constant screen shake movement

loc_3C73C:
                sub.l   d0,(Events_bg+$00).w            ; Subtract speed from BG X offset
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   loc_3C754
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l                    ; Play the screen shake sound every 16th frame

loc_3C754:
                move.w  (Camera_Y_pos_copy).w,d0        ; Get BG camera Y
                subi.w  #$500,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w     ; Offset it by $500 and put it in effective BG Y
                move.w  (Camera_X_pos_copy).w,d0
                subi.w  #$200,d0
                add.w   (Events_bg+$00).w,d0
                move.w  d0,(Camera_X_pos_BG_copy).w     ; Do the same with the BG Camera X, offsetting it by the wall movement amount
                rts
; End of function HCZ2_WallMove

; =============== S U B R O U T I N E =======================================

HCZ2_Deform:
                move.w  (Camera_Y_pos_copy).w,d0
                asr.w   #2,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d1
                asr.l   #3,d1
                lea     (HScroll_table).w,a1
                lea     HCZ2_BGDeformIndex(pc),a5
                moveq   #0,d2

loc_3C794:
                move.b  (a5)+,d3
                bmi.s   loc_3C7AC
                ext.w   d3
                swap    d0

loc_3C79C:
                move.b  (a5)+,d2
                move.w  d0,(a1,d2.w)
                dbf     d3,loc_3C79C
                swap    d0
                sub.l   d1,d0
                bra.s   loc_3C794
; ---------------------------------------------------------------------------

loc_3C7AC:
                move.w  $12(a1),d0
                sub.w   $A(a1),d0
                move.w  d0,(Events_bg+$10).w
                move.w  6(a1),d0
                sub.w   $12(a1),d0
                move.w  d0,(Events_bg+$12).w
                move.w  4(a1),d0
                sub.w   $12(a1),d0
                move.w  d0,(Events_bg+$14).w
                rts
; End of function HCZ2_Deform

; ---------------------------------------------------------------------------
HCZ2_BGDeformArray:
                dc.w    8,     8,   $90,   $10,     8,   $30,   $18,     8,     8,   $A8,   $30,   $18
                dc.w    8,     8,   $A8,   $30,   $18,     8,     8,   $B0,   $10,     8, $7FFF
HCZ2_BGDeformIndex:
                dc.b    4-1,  $A, $14, $1E, $2C
                dc.b    3-1,  $C, $16, $20
                dc.b    6-1,   0,   8,  $E, $18, $22, $2A
                dc.b    4-1,   2, $10, $1A, $24
                dc.b    2-1, $12, $1C
                dc.b    2-1,   6, $28
                dc.b    2-1,   4, $26
                dc.b    $FF
                even
