; Owner: game/level/zones/hcz/sk
; Responsibility: Hydrocity act-two screen and background initialization, events, deformation and wall actor
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
                cmpi.w  #$C00,(Camera_X_pos).w
                bhs.s   loc_50ED0
                cmpi.w  #$500,(Camera_Y_pos).w
                blo.s   loc_50ED0
                move.w  #4,(Events_routine_bg).w        ; Special deformation occurs when camera X is less than $C00 and
                jsr     (AllocateObject).l              ; camera Y is greater than $500
                bne.s   loc_50EC0
                move.l  #Obj_HCZ2Wall,(a1)

loc_50EC0:
                jsr     HCZ2_WallMove(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                jsr     Refresh_PlaneFull(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

loc_50ED0:
                move.w  #$10,(Events_routine_bg).w      ; Normal deformation
                jsr     HCZ2_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                lea     (HCZ2_BGDeformArray).l,a4
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
                jsr     (AllocateObject).l
                bne.s   loc_50F1C
                move.l  #Obj_HCZ2Wall,(a1)

loc_50F1C:
                addq.w  #4,(Events_routine_bg).w

HCZ2BGE_WallMove:
                tst.w   (Events_fg_5).w
                bne.s   loc_50F64
                jsr     HCZ2_WallMove(pc)
                jsr     DrawBGAsYouMove(pc)
                jsr     PlainDeformation(pc)
                jsr     ShakeScreen_Setup(pc)
                jsr     Get_BGActualEffectiveDiff(pc)
                clr.b   (Background_collision_flag).w
                move.w  (Player_1+x_pos).w,d0
                cmpi.w  #$3F0,d0
                blo.s   locret_50F62
                cmpi.w  #$C10,d0
                bhs.s   locret_50F62
                move.w  (Player_1+y_pos).w,d0
                cmpi.w  #$600,d0
                blo.s   locret_50F62
                cmpi.w  #$840,d0
                bhs.s   locret_50F62
                st      (Background_collision_flag).w   ; Only enable BG tile collision if player is within above parameters

locret_50F62:
                rts
; ---------------------------------------------------------------------------

loc_50F64:
                clr.w   (Events_fg_5).w
                tst.w   (Screen_shake_flag).w
                bpl.s   loc_50F72
                clr.w   (Screen_shake_flag).w           ; Disable screen shaking if still constant

loc_50F72:
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
                bra.s   loc_50FB8
; ---------------------------------------------------------------------------

HCZ2BGE_NormalRefresh:
                jsr     HCZ2_Deform(pc)

loc_50FB8:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.s   loc_50FCE
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_50FCE
; ---------------------------------------------------------------------------

HCZ2BGE_Normal:
                jsr     HCZ2_Deform(pc)

loc_50FCE:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                lea     (HCZ2_BGDeformArray).l,a4
                lea     (HScroll_table).w,a5
                jsr     ApplyDeformation(pc)
                jmp     ShakeScreen_Setup(pc)

; =============== S U B R O U T I N E =======================================

HCZ2_WallMove:
                cmpi.b  #6,(Player_1+routine).w
                bhs.s   loc_51052                       ; If player is dead, don't bother
                move.l  #$E000,d0
                cmpi.w  #$A88,(Player_1+x_pos).w
                blo.s   loc_5100C
                move.l  #$14000,d0                      ; Speed up if player has passed the end already

loc_5100C:
                move.w  (Events_bg+$00).w,d1
                beq.s   loc_5102E
                cmpi.w  #-$600,d1
                bgt.s   loc_5103A
                tst.w   (Screen_shake_flag).w           ; When wall has travelled $600 pixels
                bpl.s   loc_51052
                move.w  #$E,(Screen_shake_flag).w       ; Set screen shake to timed
                moveq   #signextendB(sfx_Crash),d0
                jsr     (Play_SFX).l                    ; Play final crashing sound
                bra.s   loc_51052
; ---------------------------------------------------------------------------

loc_5102E:
                cmpi.w  #$680,(Player_1+x_pos).w
                blo.s   loc_51052                       ; If wall hasn't started moving and player hasn't moved far enough, end
                st      (Screen_shake_flag).w           ; Begin constant screen shake movement

loc_5103A:
                sub.l   d0,(Events_bg+$00).w            ; Subtract speed from BG X offset
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   loc_51052
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l                    ; Play the screen shake sound every 16th frame

loc_51052:
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
                move.w  (Screen_shake_offset).w,d1
                sub.w   d1,d0
                asr.w   #2,d0
                add.w   d1,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d1
                asr.l   #3,d1
                lea     (HScroll_table).w,a1
                lea     (HCZ2_BGDeformIndex).l,a5
                moveq   #0,d2

loc_5109C:
                move.b  (a5)+,d3
                bmi.s   loc_510B4
                ext.w   d3
                swap    d0

loc_510A4:
                move.b  (a5)+,d2
                move.w  d0,(a1,d2.w)
                dbf     d3,loc_510A4
                swap    d0
                sub.l   d1,d0
                bra.s   loc_5109C
; ---------------------------------------------------------------------------

loc_510B4:
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

Obj_HCZ2Wall:
                cmpi.w  #4,(Events_routine_bg).w
                beq.s   loc_510E8
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_510E8:
                move.w  (Events_bg+$00).w,d4
                neg.w   d4
                addi.w  #$5BE,d4
                move.w  d4,x_pos(a0)
                move.w  #$700,y_pos(a0)
                move.b  #$40,width_pixels(a0)
                bset    #7,status(a0)
                moveq   #$4B,d1
                move.w  #$100,d2
                move.w  #$100,d3
                jmp     (SolidObjectFull2).l
