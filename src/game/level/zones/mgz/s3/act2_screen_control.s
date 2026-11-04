; Owner: game/level/zones/mgz/s3
; Responsibility: Marble Garden act-two screen initialization, event control and level-collapse triggering
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

MGZ2_ScreenInit:
                clr.l   (Events_bg+$10).w
                clr.l   (Events_bg+$14).w
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

MGZ2_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                jsr     Do_ShakeSound(pc)
                move.w  (Events_routine_fg).w,d0
                jmp     MGZ2_ScreenEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

MGZ2_ScreenEvent_Index:
                bra.w   MGZ2SE_Normal
; ---------------------------------------------------------------------------
                bra.w   MGZ2SE_Collapse
; ---------------------------------------------------------------------------
                bra.w   MGZ2SE_MoveBG
; ---------------------------------------------------------------------------

MGZ2SE_Normal:
                tst.w   (Events_fg_4).w
                bne.s   S3MGZ2Screen_BeginFinalCollapse
                jsr     MGZ2_QuakeEvent(pc)
                jsr     MGZ2_ChunkEvent(pc)
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

S3MGZ2Screen_BeginFinalCollapse:
                clr.w   (Events_fg_4).w                 ; Clear background event
                st      (Events_bg+$16).w
                move.w  #$14,(Screen_shake_flag).w
                addq.w  #4,(Events_routine_fg).w

MGZ2SE_Collapse:
                jsr     MGZ2_LevelCollapse(pc)
                tst.w   (Screen_shake_flag).w
                bmi.s   S3MGZ2Screen_DrawDeformedCollapseFg
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

S3MGZ2Screen_DrawDeformedCollapseFg:
                lea     MGZ2_FGVScrollArray(pc),a4
                lea     (HScroll_table+$100).w,a5
                moveq   #$F,d6
                moveq   #$A,d5
                jmp     DrawTilesVDeform(pc)
; ---------------------------------------------------------------------------

MGZ2SE_MoveBG:
                move.l  (Events_bg+$08).w,d0
                cmpi.l  #$50000,d0
                bhs.s   S3MGZ2Screen_StepBossBgOffset
                addi.l  #$800,d0
                move.l  d0,(Events_bg+$08).w

S3MGZ2Screen_StepBossBgOffset:
                swap    d0
                add.w   d0,(Events_bg+$0C).w            ; Apply a movement offset for the BG scrolling during the boss
                jmp     DrawTilesAsYouMove(pc)

; =============== S U B R O U T I N E =======================================

MGZ2_LevelCollapse:
                cmpi.b  #6,(Player_1+routine).w
                bhs.w   S3MGZ2Screen_CollapseReturn     ; If dying, don't do anything else
                tst.w   (Screen_shake_flag).w
                bmi.w   S3MGZ2Screen_BeginCollapseColumnUpdate  ; If shaking continuously, branch
                bne.w   S3MGZ2Screen_CollapseReturn
                movea.w $38(a3),a1                      ; Get chunk line at $700 Y
                lea     $79(a1),a1                      ; Get chunk at $3C80
                move.w  -8(a3),d0                       ; Get FG level X chunksize
                subq.w  #3,d0
                moveq   #3-1,d1

S3MGZ2Screen_ClearInitialCollapseChunks:
                clr.b   (a1)+
                clr.b   (a1)+
                clr.b   (a1)+                           ; Clear the three main chunks on three lines that comprise the boss battle
                adda.w  d0,a1
                dbf     d1,S3MGZ2Screen_ClearInitialCollapseChunks
                lea     (HScroll_table+$102).w,a1
                lea     (HScroll_table+$13C).w,a5
                lea     $28(a5),a6
                move.w  (Camera_Y_pos_copy).w,d0        ; Get BG Y camera
                and.w   (Camera_Y_pos_mask).w,d0        ; AND it to get tile position
                moveq   #$A-1,d1

S3MGZ2Screen_InitCollapseColumns:
                move.w  d0,(a1)
                addq.w  #4,a1
                clr.l   (a5)+
                clr.l   (a6)+                           ; Clear scroll values, etc
                dbf     d1,S3MGZ2Screen_InitCollapseColumns
                jsr     (AllocateObject).l
                bne.s   S3MGZ2Screen_EnableCollapseVScroll
                move.w  #$3C90,d1
                move.l  #$5C00790,d2
                move.l  #HScroll_table+$13C,d3
                moveq   #$A-1,d4

S3MGZ2Screen_TryCreateCollapseSolids:
                move.l  #Obj_MGZ2LevelCollapseSolid,(a1)  ; Create solid objects that Sonic can stand on as the level collapses
                move.w  d1,x_pos(a1)
                move.w  d2,$2E(a1)
                move.l  d3,$30(a1)
                swap    d2
                jsr     (CreateNewSprite4).l
                bne.s   S3MGZ2Screen_EnableCollapseVScroll
                move.l  #Obj_MGZ2LevelCollapseSolid,(a1)
                move.w  d1,x_pos(a1)
                move.w  d2,$2E(a1)
                move.l  d3,$30(a1)
                addi.w  #$20,d1
                swap    d2
                addq.l  #4,d3
                jsr     (CreateNewSprite4).l
                dbne    d4,S3MGZ2Screen_TryCreateCollapseSolids

; Enable the special scroll even if either collapse solid failed to spawn
S3MGZ2Screen_EnableCollapseVScroll:
                st      (Screen_shake_flag).w           ; Turn quake on
                clr.w   (Events_bg+$06).w
                st      (SceneRowAnchorOrCompetitionWinCounts).w  ; Turn on special VScroll VInt function
                move.w  #4,(Special_V_int_routine).w

S3MGZ2Screen_BeginCollapseColumnUpdate:
                lea     (HScroll_table+$100).w,a1
                lea     $28(a1),a4
                lea     $14(a4),a5
                lea     MGZ2_CollapseScrollDelay(pc),a6
                move.w  (Events_bg+$06).w,d0
                addq.w  #1,(Events_bg+$06).w
                moveq   #$A,d1
                moveq   #$A-1,d2

S3MGZ2Screen_TryAccelerateColumn:
                cmp.w   (a6)+,d0                        ; Get scroll delay for each block
                blo.s   S3MGZ2Screen_StepCollapseColumn
                addi.l  #$500,$64(a1)                   ; Add $500 to Vscroll velocity for this block when not delayed

; Clamp the displayed displacement while keeping the full accumulator for collision
S3MGZ2Screen_StepCollapseColumn:
                move.l  $64(a1),d3
                add.l   d3,(a5)+                        ; Add velocity to actual VScroll
                move.w  -4(a5),d3
                cmpi.w  #$2E0,d3
                blo.s   S3MGZ2Screen_StoreColumnScroll
                move.w  #$2E0,d3                        ; $2E0 is the maximum scroll
                subq.w  #1,d1                           ; When maximum scroll is reached, lower amount of "active" scrolling lines

S3MGZ2Screen_StoreColumnScroll:
                move.w  (Camera_Y_pos_copy).w,d4        ; Get BG Y
                sub.w   d3,d4
                move.w  d4,(a4)+
                move.w  d4,(a1)                         ; Subtract from scroll to get... something
                addq.w  #4,a1
                dbf     d2,S3MGZ2Screen_TryAccelerateColumn  ; Repeat until all scrolling parts are off-screen
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   S3MGZ2Screen_TryFinishCollapse
                moveq   #signextendB(sfx_BigRumble),d0  ; Play collapsing sound every 16 frames
                jsr     (Play_SFX).l

S3MGZ2Screen_TryFinishCollapse:
                tst.w   d1
                bne.s   S3MGZ2Screen_CollapseReturn     ; If scrolling chunks still remain, do nothing
                movea.w $2C(a3),a1                      ; Get chunk line at $580 Y
                lea     $79(a1),a1                      ; Get chunk at $3C80 X
                move.w  -8(a3),d0
                subq.w  #3,d0
                moveq   #2,d1

S3MGZ2Screen_ClearFinalCollapseChunks:
                clr.b   (a1)+
                clr.b   (a1)+
                clr.b   (a1)+
                adda.w  d0,a1
                dbf     d1,S3MGZ2Screen_ClearFinalCollapseChunks
                clr.w   (Screen_shake_flag).w           ; Stop quaking
                clr.l   (Events_bg+$08).w               ; Stop special tile drawing
                move.w  (Camera_X_pos_copy).w,(Events_bg+$0C).w
                move.w  #$C,(Special_V_int_routine).w   ; Set VScroll VInt routine
                addq.w  #4,(Events_routine_fg).w        ; Next screen routine

S3MGZ2Screen_CollapseReturn:
                rts
; End of function MGZ2_LevelCollapse

; =============== S U B R O U T I N E =======================================

MGZ2_QuakeEvent:
                move.w  (Player_1+x_pos).w,d0
                move.w  (Player_1+y_pos).w,d1
                move.w  (Events_bg+$10).w,d2
                jmp     MGZ2_QuakeEvent_Index(pc,d2.w)
; End of function MGZ2_QuakeEvent

; ---------------------------------------------------------------------------

MGZ2_QuakeEvent_Index:
                bra.w   MGZ2_QuakeEventCheck
; ---------------------------------------------------------------------------
                bra.w   MGZ2_QuakeEvent1
; ---------------------------------------------------------------------------
                bra.w   MGZ2_QuakeEvent2
; ---------------------------------------------------------------------------
                bra.w   MGZ2_QuakeEvent3
; ---------------------------------------------------------------------------
                bra.w   MGZ2_QuakeEvent1Cont
; ---------------------------------------------------------------------------
                bra.w   MGZ2_QuakeEvent2Cont
; ---------------------------------------------------------------------------
                bra.w   MGZ2_QuakeEvent3Cont
; ---------------------------------------------------------------------------

MGZ2_QuakeEventCheck:
                lea     (Events_bg+$12).w,a5            ; EEE4-EEE6 are flags to determine whether earthquake event has already completed. There are three
                lea     MGZ2_QuakeEventArray(pc),a1
                moveq   #4,d2
                moveq   #2,d3

S3MGZ2Screen_FindUnusedQuakeTrigger:
                tst.b   (a5)
                bne.s   S3MGZ2Screen_NextQuakeTrigger
                cmp.w   (a1),d0
                blo.s   S3MGZ2Screen_NextQuakeTrigger
                cmp.w   2(a1),d0
                bhs.s   S3MGZ2Screen_NextQuakeTrigger
                cmp.w   4(a1),d1
                blo.s   S3MGZ2Screen_NextQuakeTrigger
                cmp.w   6(a1),d1
                bhs.s   S3MGZ2Screen_NextQuakeTrigger
                move.w  d2,(Events_bg+$10).w
                move.w  8(a1),d0
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                move.w  $A(a1),d0
                cmpi.w  #4,d2
                bne.s   S3MGZ2Screen_SetLaterQuakeMinX
                move.w  d0,(Camera_max_X_pos).w         ; First earthquake event near start of level makes you go right
                move.w  d0,(Camera_target_max_X_pos).w
                rts
; ---------------------------------------------------------------------------

S3MGZ2Screen_SetLaterQuakeMinX:
                move.w  d0,(Camera_min_X_pos).w         ; The other two make you go left
                move.w  d0,(Camera_target_min_X_pos).w
                rts
; ---------------------------------------------------------------------------

S3MGZ2Screen_NextQuakeTrigger:
                lea     $C(a1),a1
                addq.w  #1,a5
                addq.w  #4,d2
                dbf     d3,S3MGZ2Screen_FindUnusedQuakeTrigger
                rts
; ---------------------------------------------------------------------------

MGZ2_QuakeEvent1:
                cmpi.w  #$780,d0
                blo.w   S3MGZ2Screen_ResetQuakeBounds   ; If player retreats, revert to normal camera movement
                move.w  (Camera_max_X_pos).w,d0
                cmp.w   (Camera_X_pos).w,d0
                bhi.s   S3MGZ2Screen_Quake1Return       ; If camera X hasn't reached level X end, branch
                move.w  d0,(Camera_min_X_pos).w         ; Lock the screen
                move.w  d0,(Camera_target_min_X_pos).w
                st      (Events_bg+$12).w               ; Set the earthquake flag for this first one
                addi.w  #$C,(Events_bg+$10).w           ; Set next quake event routine
                st      (Screen_shake_flag).w
                jsr     (AllocateObject).l
                bne.s   S3MGZ2Screen_Quake1Return
                move.l  #Obj_MGZ2DrillingRobotnik,(a1)
                move.w  #$8E0,x_pos(a1)
                move.w  #$690,y_pos(a1)                 ; Create drilling Eggman boss sprite

S3MGZ2Screen_Quake1Return:
                rts
; ---------------------------------------------------------------------------

MGZ2_QuakeEvent2:
                cmpi.w  #$3200,d0
                bhs.w   S3MGZ2Screen_ResetQuakeBounds
                move.w  (Camera_min_X_pos).w,d0         ; If camera X hasn't reached level X start, branch
                cmp.w   (Camera_X_pos).w,d0
                blo.s   S3MGZ2Screen_Quake2Return
                move.w  d0,(Camera_max_X_pos).w         ; Lock the screen
                move.w  d0,(Camera_target_max_X_pos).w
                st      (Events_bg+$13).w               ; Set this earthquake flag
                addi.w  #$C,(Events_bg+$10).w           ; Set next quake event routine
                st      (Screen_shake_flag).w
                jsr     (AllocateObject).l
                bne.s   S3MGZ2Screen_Quake2Return
                move.l  #Obj_MGZ2DrillingRobotnik,(a1)
                bset    #0,render_flags(a1)
                move.w  #$2FA0,x_pos(a1)
                move.w  #$2D0,y_pos(a1)                 ; Set Robotnik drilling object

S3MGZ2Screen_Quake2Return:
                rts
; ---------------------------------------------------------------------------

MGZ2_QuakeEvent3:
                cmpi.w  #$3480,d0                       ; Same as above, you know the drill (haha, drill...)
                bhs.s   S3MGZ2Screen_ResetQuakeBounds
                move.w  (Camera_min_X_pos).w,d0
                cmp.w   (Camera_X_pos).w,d0
                blo.s   S3MGZ2Screen_Quake3Return
                move.w  d0,(Camera_max_X_pos).w
                move.w  d0,(Camera_target_max_X_pos).w
                st      (Events_bg+$14).w
                addi.w  #$C,(Events_bg+$10).w
                st      (Screen_shake_flag).w
                jsr     (AllocateObject).l
                bne.s   S3MGZ2Screen_Quake3Return
                move.l  #Obj_MGZ2DrillingRobotnik,(a1)
                bset    #0,render_flags(a1)
                move.w  #$3300,x_pos(a1)
                move.w  #$790,y_pos(a1)

S3MGZ2Screen_Quake3Return:
                rts
; ---------------------------------------------------------------------------

S3MGZ2Screen_ResetQuakeBounds:
                move.w  #$1000,d0
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                move.l  #$6000,d0
                move.l  d0,(Camera_min_X_pos).w
                move.l  d0,(Camera_target_min_X_pos).w
                clr.w   (Events_bg+$10).w
                rts
; ---------------------------------------------------------------------------

MGZ2_QuakeEvent1Cont:
                cmpi.w  #$980,(Player_1+x_pos).w
                bhs.s   S3MGZ2Screen_RestoreQuakeIdleBounds  ; Reset level Y end when Sonic has travelled past $980 X
                rts
; ---------------------------------------------------------------------------

MGZ2_QuakeEvent2Cont:
                cmpi.w  #$100,(Player_1+y_pos).w
                bhs.s   S3MGZ2Screen_Quake2ExitReturn
                cmpi.w  #$2F80,(Player_1+x_pos).w
                blo.s   S3MGZ2Screen_Quake2ExitReturn
                move.w  #$6000,d0
                move.w  d0,(Camera_max_X_pos).w
                move.w  d0,(Camera_target_max_X_pos).w
                bra.s   S3MGZ2Screen_RestoreQuakeIdleBounds
; ---------------------------------------------------------------------------

S3MGZ2Screen_Quake2ExitReturn:
                rts
; ---------------------------------------------------------------------------

MGZ2_QuakeEvent3Cont:
                cmpi.w  #$3200,(Player_1+x_pos).w
                blo.s   S3MGZ2Screen_RestoreQuakeIdleBounds
                rts
; ---------------------------------------------------------------------------

S3MGZ2Screen_RestoreQuakeIdleBounds:
                move.w  #$1000,d0
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                clr.w   (Events_bg+$10).w
                rts

; =============== S U B R O U T I N E =======================================

MGZ2_ChunkEvent:
                move.w  (Events_bg+$04).w,d0
                jmp     MGZ2_ChunkEvent_Index(pc,d0.w)
; End of function MGZ2_ChunkEvent

; ---------------------------------------------------------------------------

MGZ2_ChunkEvent_Index:
                bra.w   MGZ2_ChunkEventCheck
; ---------------------------------------------------------------------------
                bra.w   MGZ2_ChunkEvent1
; ---------------------------------------------------------------------------
                bra.w   MGZ2_ChunkEvent2_3
; ---------------------------------------------------------------------------
                bra.w   MGZ2_ChunkEvent2_3
; ---------------------------------------------------------------------------
                bra.w   MGZ2_ChunkEventReset
; ---------------------------------------------------------------------------
                rts
; ---------------------------------------------------------------------------

MGZ2_ChunkEventCheck:
                move.w  (Player_1+x_pos).w,d0
                move.w  (Player_1+y_pos).w,d1
                lea     MGZ2_ChunkEventArray(pc),a1
                moveq   #4,d2
                moveq   #3-1,d3

S3MGZ2Screen_FindChunkShiftTrigger:
                cmp.w   (a1),d0
                blo.s   S3MGZ2Screen_NextChunkShiftTrigger
                cmp.w   2(a1),d0
                bhs.s   S3MGZ2Screen_NextChunkShiftTrigger
                cmp.w   4(a1),d1
                blo.s   S3MGZ2Screen_NextChunkShiftTrigger
                cmp.w   6(a1),d1
                bhs.s   S3MGZ2Screen_NextChunkShiftTrigger
                cmpi.w  #4,d2
                bne.s   S3MGZ2Screen_StartChunkShift
                tst.w   (Screen_shake_flag).w
                bmi.s   S3MGZ2Screen_StartChunkShift    ; Only perform the first layout shift event if screen is continually shaking

S3MGZ2Screen_NextChunkShiftTrigger:
                lea     $C(a1),a1
                addq.w  #4,d2
                dbf     d3,S3MGZ2Screen_FindChunkShiftTrigger
                rts
; ---------------------------------------------------------------------------

S3MGZ2Screen_StartChunkShift:
                move.w  d2,(Events_bg+$04).w
                clr.w   (Events_bg+$06).w
                clr.w   (Events_bg+$08).w
                move.w  8(a1),(Events_bg+$0A).w
                move.w  $A(a1),(Events_bg+$0C).w

MGZ2_ChunkEvent1:
                move.w  (Events_bg+$06).w,d0
                cmpi.w  #$5C,d0
                blo.s   S3MGZ2Screen_StepChunkShiftFrame
                clr.w   (Screen_shake_flag).w           ; Stop shaking when first chunk event is finished
                clr.w   (Camera_min_X_pos).w            ; Reset level height
                clr.w   (Camera_target_min_X_pos).w
                move.w  #$10,(Events_bg+$04).w
                rts
; ---------------------------------------------------------------------------

MGZ2_ChunkEvent2_3:
                move.w  (Events_bg+$06).w,d0
                cmpi.w  #$5C,d0
                blo.s   S3MGZ2Screen_StepChunkShiftFrame
                move.w  #$6000,d0
                move.w  d0,(Camera_max_X_pos).w         ; Reset level end X
                move.w  d0,(Camera_target_max_X_pos).w
                move.w  #$14,(Events_bg+$04).w
                rts
; ---------------------------------------------------------------------------

S3MGZ2Screen_StepChunkShiftFrame:
                subq.w  #1,(Events_bg+$08).w
                bpl.s   S3MGZ2Screen_ChunkRedrawReturn
                move.w  #7-1,(Events_bg+$08).w          ; Perform the layout change once every seven frames
                move.w  d0,d2
                bsr.s   MGZ2_ModifyChunk
                move.w  (Events_bg+$0A).w,d0
                addi.w  #$80,d0
                sub.w   (Camera_X_pos_copy).w,d0
                bcs.s   S3MGZ2Screen_ChunkRedrawReturn
                cmpi.w  #$1C0,d0                        ; Calculate the X position of the screen redraw
                bhs.s   S3MGZ2Screen_ChunkRedrawReturn
                move.w  (Events_bg+$0C).w,d0
                lea     MGZ2_ScreenRedrawArray(pc),a1
                add.w   (a1,d2.w),d0                    ; Calculate the Y position
                move.w  2(a1,d2.w),d2                   ; And the number of lines to write

S3MGZ2Screen_DrawVisibleChunkRow:
                move.w  (Camera_Y_pos_copy).w,d3
                and.w   (Camera_Y_pos_mask).w,d3
                cmp.w   d3,d0
                blo.s   S3MGZ2Screen_NextChunkRedrawRow
                addi.w  #$F0,d3
                cmp.w   d3,d0
                bhs.s   S3MGZ2Screen_NextChunkRedrawRow
                move.w  (Events_bg+$0A).w,d1
                moveq   #8,d6                           ; Always draw 8 tiles
                swap    d2
                jsr     Setup_TileRowDraw(pc)
                swap    d2

S3MGZ2Screen_NextChunkRedrawRow:
                addi.w  #$10,d0
                dbf     d2,S3MGZ2Screen_DrawVisibleChunkRow

S3MGZ2Screen_ChunkRedrawReturn:
                rts
; ---------------------------------------------------------------------------

MGZ2_ChunkEventReset:
                cmpi.w  #$2A00,(Player_1+x_pos).w       ; When Player has travelled far enough, reset the chunk to its original form
                blo.s   S3MGZ2Screen_ChunkResetReturn
                clr.w   (Events_bg+$04).w
                moveq   #$5C,d0
                bra.s   MGZ2_ModifyChunk
; ---------------------------------------------------------------------------

S3MGZ2Screen_ChunkResetReturn:
                rts

; =============== S U B R O U T I N E =======================================

MGZ2_ModifyChunk:
                lea     MGZ2_ChunkReplaceArray(pc),a1
                lea     ((RAM_start+$5880)&$FFFFFF).l,a5
                bsr.s   WriteNextMgz2QuakeChunkFrame
                lea     ((RAM_start+$7500)&$FFFFFF).l,a5
; End of function MGZ2_ModifyChunk

; =============== S U B R O U T I N E =======================================

WriteNextMgz2QuakeChunkFrame:
                lea     (MGZ2_QuakeChunks).l,a4
                adda.w  (a1,d0.w),a4
                moveq   #8-1,d1

S3MGZ2Screen_CopyReplacementChunkRow:
                move.l  (a4)+,(a5)+
                move.l  (a4)+,(a5)+
                move.l  (a4)+,(a5)+
                move.l  (a4)+,(a5)+
                dbf     d1,S3MGZ2Screen_CopyReplacementChunkRow
                addq.w  #2,d0
                move.w  d0,(Events_bg+$06).w
                rts
; End of function WriteNextMgz2QuakeChunkFrame
