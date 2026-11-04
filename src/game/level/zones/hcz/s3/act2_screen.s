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
                bhs.s   S3HCZ2Screen_InitNormalBg
                cmpi.w  #$500,(Camera_Y_pos_copy).w
                blo.s   S3HCZ2Screen_InitNormalBg
                move.w  #4,(Events_routine_bg).w        ; Special deformation occurs when camera X is less than $C00 and camera Y is greater than $500
                jsr     HCZ2_WallMove(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                jsr     Refresh_PlaneFull(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

S3HCZ2Screen_InitNormalBg:
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
                bne.s   S3HCZ2Screen_ConsumeWallEndSignal
                jsr     HCZ2_WallMove(pc)
                jsr     DrawBGAsYouMove(pc)
                jsr     PlainDeformation(pc)
                jsr     ShakeScreen_Setup(pc)
                jsr     Get_BGActualEffectiveDiff(pc)
                clr.b   (Background_collision_flag).w
                move.w  (Player_1+x_pos).w,d0
                cmpi.w  #$3F0,d0
                blo.s   S3HCZ2Screen_WallBgReturn
                cmpi.w  #$C10,d0
                bhs.s   S3HCZ2Screen_WallBgReturn
                move.w  (Player_1+y_pos).w,d0
                cmpi.w  #$600,d0
                blo.s   S3HCZ2Screen_WallBgReturn
                cmpi.w  #$840,d0
                bhs.s   S3HCZ2Screen_WallBgReturn
                st      (Background_collision_flag).w   ; Only enable BG tile collision if player is within above parameters

S3HCZ2Screen_WallBgReturn:
                rts
; ---------------------------------------------------------------------------

S3HCZ2Screen_ConsumeWallEndSignal:
                clr.w   (Events_fg_5).w
                tst.w   (Screen_shake_flag).w
                bpl.s   S3HCZ2Screen_BeginWallExitRedraw
                clr.w   (Screen_shake_flag).w           ; Disable screen shaking if still constant

S3HCZ2Screen_BeginWallExitRedraw:
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
                bra.s   S3HCZ2Screen_RefreshNormalBgAndDraw
; ---------------------------------------------------------------------------

HCZ2BGE_NormalRefresh:
                jsr     HCZ2_Deform(pc)

S3HCZ2Screen_RefreshNormalBgAndDraw:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.s   S3HCZ2Screen_DrawNormalBg
                addq.w  #4,(Events_routine_bg).w
                bra.s   S3HCZ2Screen_DrawNormalBg
; ---------------------------------------------------------------------------

HCZ2BGE_Normal:
                jsr     HCZ2_Deform(pc)

S3HCZ2Screen_DrawNormalBg:
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
                bhs.s   S3HCZ2Screen_SetWallBgPosition  ; If player is dead, don't bother
                move.l  #$E000,d0
                cmpi.w  #$A88,(Player_1+x_pos).w
                blo.s   S3HCZ2Screen_CheckWallTravel
                move.l  #$14000,d0                      ; Speed up if player has passed the end already

S3HCZ2Screen_CheckWallTravel:
                move.w  (Events_bg+$00).w,d1
                beq.s   S3HCZ2Screen_TryStartWallMotion
                cmpi.w  #-$600,d1
                bgt.s   S3HCZ2Screen_StepWallAndTryRumble
                tst.w   (Screen_shake_flag).w           ; When wall has travelled $600 pixels
                bpl.s   S3HCZ2Screen_SetWallBgPosition
                move.w  #$E,(Screen_shake_flag).w       ; Set screen shake to timed
                moveq   #signextendB(sfx_Crash),d0
                jsr     (Play_SFX).l                    ; Play final crashing sound
                bra.s   S3HCZ2Screen_SetWallBgPosition
; ---------------------------------------------------------------------------

S3HCZ2Screen_TryStartWallMotion:
                cmpi.w  #$680,(Player_1+x_pos).w
                blo.s   S3HCZ2Screen_SetWallBgPosition  ; If wall hasn't started moving and player hasn't moved far enough, end
                st      (Screen_shake_flag).w           ; Begin constant screen shake movement

S3HCZ2Screen_StepWallAndTryRumble:
                sub.l   d0,(Events_bg+$00).w            ; Subtract speed from BG X offset
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   S3HCZ2Screen_SetWallBgPosition
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l                    ; Play the screen shake sound every 16th frame

S3HCZ2Screen_SetWallBgPosition:
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

S3HCZ2Screen_ReadBgScatterCount:
                move.b  (a5)+,d3
                bmi.s   S3HCZ2Screen_StoreBgScrollDeltas
                ext.w   d3
                swap    d0

S3HCZ2Screen_ScatterBgOffset:
                move.b  (a5)+,d2
                move.w  d0,(a1,d2.w)
                dbf     d3,S3HCZ2Screen_ScatterBgOffset
                swap    d0
                sub.l   d1,d0
                bra.s   S3HCZ2Screen_ReadBgScatterCount
; ---------------------------------------------------------------------------

S3HCZ2Screen_StoreBgScrollDeltas:
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
