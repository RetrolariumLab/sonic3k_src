; Owner: game/level/zones/mgz/sk
; Responsibility: Marble Garden act-two screen initialization, event control and collapse triggering
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

MGZ2_ScreenInit:
                clr.l   (Events_bg+$10).w
                clr.l   (Events_bg+$14).w
                clr.w   (Events_fg_0).w
                clr.w   (Events_fg_2).w
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

MGZ2_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                tst.w   (Events_fg_0).w
                beq.s   loc_512D0
                st      (Screen_shake_flag).w           ; Turn continuous shaking on

loc_512D0:
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
                bne.s   loc_512FA
                jsr     MGZ2_QuakeEvent(pc)
                jsr     MGZ2_ChunkEvent(pc)
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

loc_512FA:
                clr.w   (Events_fg_4).w                 ; Clear background event
                st      (Events_bg+$16).w
                move.w  #$14,(Screen_shake_flag).w
                addq.w  #4,(Events_routine_fg).w

MGZ2SE_Collapse:
                jsr     MGZ2_LevelCollapse(pc)
                tst.w   (Screen_shake_flag).w
                bmi.s   loc_5131A
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

loc_5131A:
                lea     (MGZ2_FGVScrollArray).l,a4
                lea     (HScroll_table+$100).w,a5
                moveq   #$F,d6
                moveq   #$A,d5
                jmp     DrawTilesVDeform(pc)
; ---------------------------------------------------------------------------

MGZ2SE_MoveBG:
                move.l  (Events_bg+$08).w,d0
                cmpi.l  #$50000,d0
                bhs.s   loc_51342
                addi.l  #$800,d0
                move.l  d0,(Events_bg+$08).w

loc_51342:
                swap    d0
                add.w   d0,(Events_bg+$0C).w            ; Apply a movement offset for the BG scrolling during the boss
                jmp     DrawTilesAsYouMove(pc)

; =============== S U B R O U T I N E =======================================

MGZ2_LevelCollapse:
                cmpi.b  #6,(Player_1+routine).w
                bhs.w   locret_514A8                    ; If dying, don't do anything else
                tst.w   (Screen_shake_flag).w
                bmi.w   loc_5140C                       ; If shaking continuously, branch
                bne.w   locret_514A8
                movea.w $38(a3),a1                      ; Get chunk line at $700 Y
                lea     $79(a1),a1                      ; Get chunk at $3C80
                move.w  -8(a3),d0                       ; Get FG level X chunksize
                subq.w  #3,d0
                moveq   #3-1,d1

loc_51372:
                clr.b   (a1)+
                clr.b   (a1)+
                clr.b   (a1)+                           ; Clear the three main chunks on three lines that comprise the boss battle
                adda.w  d0,a1
                dbf     d1,loc_51372
                lea     (HScroll_table+$102).w,a1
                lea     (HScroll_table+$13C).w,a5
                lea     $28(a5),a6
                move.w  (Camera_Y_pos_copy).w,d0        ; Get BG Y camera
                and.w   (Camera_Y_pos_mask).w,d0        ; AND it to get tile position
                moveq   #$A-1,d1

loc_51394:
                move.w  d0,(a1)
                addq.w  #4,a1
                clr.l   (a5)+
                clr.l   (a6)+                           ; Clear scroll values, etc
                dbf     d1,loc_51394
                jsr     (AllocateObject).l
                bne.s   loc_513FA
                move.w  #$3C90,d1
                move.l  #$5C00790,d2
                move.l  #HScroll_table+$13C,d3
                moveq   #$A-1,d4

loc_513BA:
                move.l  #Obj_MGZ2LevelCollapseSolid,(a1)  ; Create solid objects that Sonic can stand on as the level collapses
                move.w  d1,x_pos(a1)
                move.w  d2,$2E(a1)
                move.l  d3,$30(a1)
                swap    d2
                jsr     (CreateNewSprite4).l
                bne.s   loc_513FA
                move.l  #Obj_MGZ2LevelCollapseSolid,(a1)
                move.w  d1,x_pos(a1)
                move.w  d2,$2E(a1)
                move.l  d3,$30(a1)
                addi.w  #$20,d1
                swap    d2
                addq.l  #4,d3
                jsr     (CreateNewSprite4).l
                dbne    d4,loc_513BA

loc_513FA:
                st      (Screen_shake_flag).w           ; Turn quake on
                clr.w   (Events_bg+$06).w
                st      (_unkEEA2).w                    ; Turn on special VScroll VInt function
                move.w  #4,(Special_V_int_routine).w

loc_5140C:
                lea     (HScroll_table+$100).w,a1
                lea     $28(a1),a4
                lea     $14(a4),a5
                lea     (MGZ2_CollapseScrollDelay).l,a6
                move.w  (Events_bg+$06).w,d0
                addq.w  #1,(Events_bg+$06).w
                moveq   #$A,d1
                moveq   #$A-1,d2

loc_5142A:
                cmp.w   (a6)+,d0                        ; Get scroll delay for each block
                blo.s   loc_51436
                addi.l  #$500,$64(a1)                   ; Add $500 to Vscroll velocity for this block when not delayed

loc_51436:
                move.l  $64(a1),d3
                add.l   d3,(a5)+                        ; Add velocity to actual VScroll
                move.w  -4(a5),d3
                cmpi.w  #$2E0,d3
                blo.s   loc_5144C
                move.w  #$2E0,d3                        ; $2E0 is the maximum scroll
                subq.w  #1,d1                           ; When maximum scroll is reached, lower amount of "active" scrolling lines

loc_5144C:
                move.w  (Camera_Y_pos_copy).w,d4        ; Get BG Y
                sub.w   d3,d4
                move.w  d4,(a4)+
                move.w  d4,(a1)                         ; Subtract from scroll to get... something
                addq.w  #4,a1
                dbf     d2,loc_5142A                    ; Repeat until all scrolling parts are off-screen
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   loc_51470
                moveq   #signextendB(sfx_BigRumble),d0  ; Play collapsing sound every 16 frames
                jsr     (Play_SFX).l

loc_51470:
                tst.w   d1
                bne.s   locret_514A8                    ; If scrolling chunks still remain, do nothing
                movea.w $2C(a3),a1                      ; Get chunk line at $580 Y
                lea     $79(a1),a1                      ; Get chunk at $3C80 X
                move.w  -8(a3),d0
                subq.w  #3,d0
                moveq   #2,d1

loc_51484:
                clr.b   (a1)+
                clr.b   (a1)+
                clr.b   (a1)+
                adda.w  d0,a1
                dbf     d1,loc_51484
                clr.w   (Screen_shake_flag).w           ; Stop quaking
                clr.l   (Events_bg+$08).w               ; Stop special tile drawing
                move.w  (Camera_X_pos_copy).w,(Events_bg+$0C).w
                move.w  #$C,(Special_V_int_routine).w   ; Set VScroll VInt routine
                addq.w  #4,(Events_routine_fg).w        ; Next screen routine

locret_514A8:
                rts
; End of function MGZ2_LevelCollapse

; =============== S U B R O U T I N E =======================================

MGZ2_QuakeEvent:
                tst.w   (Events_fg_2).w
                beq.s   loc_514D8
                bpl.s   loc_514BE
                tst.l   (Nem_decomp_queue).w
                bne.s   loc_514D8
                move.w  #$FF,(Events_fg_2).w

loc_514BE:
                move.w  (Camera_min_Y_pos).w,d0
                beq.s   loc_514D8
                cmpi.w  #$1E0,d0
                beq.s   loc_514D8
                subq.w  #2,d0
                bcc.s   loc_514D4
                moveq   #0,d0
                move.w  d0,(Events_fg_2).w

loc_514D4:
                move.w  d0,(Camera_min_Y_pos).w

loc_514D8:
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
                lea     (MGZ2_QuakeEventArray).l,a1
                moveq   #4,d2
                moveq   #2,d3

loc_51512:
                tst.b   (a5)
                bne.s   loc_51552
                cmp.w   (a1),d0
                blo.s   loc_51552
                cmp.w   2(a1),d0
                bhs.s   loc_51552
                cmp.w   4(a1),d1
                blo.s   loc_51552
                cmp.w   6(a1),d1
                bhs.s   loc_51552
                move.w  d2,(Events_bg+$10).w
                move.w  8(a1),d0
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                move.w  $A(a1),d0
                cmpi.w  #4,d2
                bne.s   loc_5154C
                move.w  d0,(Camera_max_X_pos).w         ; First earthquake event near start of level makes you go right
                rts
; ---------------------------------------------------------------------------

loc_5154C:
                move.w  d0,(Camera_min_X_pos).w         ; The other two make you go left
                rts
; ---------------------------------------------------------------------------

loc_51552:
                lea     $C(a1),a1
                addq.w  #1,a5
                addq.w  #4,d2
                dbf     d3,loc_51512
                rts
; ---------------------------------------------------------------------------

MGZ2_QuakeEvent1:
                cmpi.w  #$780,d0
                blo.w   loc_51656                       ; If player retreats, revert to normal camera movement
                move.w  (Camera_max_X_pos).w,d0
                cmp.w   (Camera_X_pos).w,d0
                bhi.s   locret_515A2                    ; If camera X hasn't reached level X end, branch
                move.w  d0,(Camera_min_X_pos).w         ; Lock the screen
                st      (Events_bg+$12).w               ; Set the earthquake flag for this first one
                addi.w  #$C,(Events_bg+$10).w           ; Set next quake event routine
                jsr     (AllocateObject).l
                bne.s   locret_515A2
                move.l  #Obj_MGZ2DrillingRobotnik,(a1)
                move.w  #$8E0,x_pos(a1)
                move.w  #$690,y_pos(a1)                 ; Create drilling Eggman boss sprite
                st      (Screen_shake_flag).w
                st      (Events_fg_0).w                 ; Start shaking the screen

locret_515A2:
                rts
; ---------------------------------------------------------------------------

MGZ2_QuakeEvent2:
                cmpi.w  #$3200,d0
                blo.s   loc_515B4
                move.w  #$1DF,(Camera_min_Y_pos).w      ; If player retreats, reset level height
                bra.w   loc_51656
; ---------------------------------------------------------------------------

loc_515B4:
                move.w  (Camera_max_Y_pos).w,d1
                cmp.w   (Camera_Y_pos).w,d1
                bne.s   loc_515CC
                cmp.w   (Camera_min_Y_pos).w,d1
                beq.s   loc_515CC
                move.w  d1,(Camera_min_Y_pos).w         ; Adjust level height during this event
                st      (Events_fg_2+1).w

loc_515CC:
                move.w  (Camera_min_X_pos).w,d0         ; If camera X hasn't reached level X start, branch
                cmp.w   (Camera_X_pos).w,d0
                blo.s   locret_5160C
                move.w  d0,(Camera_max_X_pos).w         ; Lock the screen
                st      (Events_bg+$13).w               ; Set this earthquake flag
                addi.w  #$C,(Events_bg+$10).w           ; Set next quake event routine
                jsr     (AllocateObject).l
                bne.s   locret_5160C
                move.l  #Obj_MGZ2DrillingRobotnik,(a1)
                bset    #0,render_flags(a1)
                move.w  #$2FA0,x_pos(a1)
                move.w  #$2D0,y_pos(a1)                 ; Set Robotnik drilling object
                st      (Screen_shake_flag).w
                st      (Events_fg_0).w                 ; Start quaking

locret_5160C:
                rts
; ---------------------------------------------------------------------------

MGZ2_QuakeEvent3:
                cmpi.w  #$3480,d0                       ; Same as above, you know the drill (haha, drill...)
                bhs.s   loc_51656
                move.w  (Camera_min_X_pos).w,d0
                cmp.w   (Camera_X_pos).w,d0
                blo.s   locret_51654
                move.w  d0,(Camera_max_X_pos).w
                st      (Events_bg+$14).w
                addi.w  #$C,(Events_bg+$10).w
                jsr     (AllocateObject).l
                bne.s   locret_51654
                move.l  #Obj_MGZ2DrillingRobotnik,(a1)
                bset    #0,render_flags(a1)
                move.w  #$3300,x_pos(a1)
                move.w  #$790,y_pos(a1)
                st      (Screen_shake_flag).w
                st      (Events_fg_0).w

locret_51654:
                rts
; ---------------------------------------------------------------------------

loc_51656:
                move.w  #$1000,d0
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                move.l  #$6000,d0
                move.l  d0,(Camera_min_X_pos).w
                clr.w   (Events_bg+$10).w
                rts
; ---------------------------------------------------------------------------

MGZ2_QuakeEvent1Cont:
                cmpi.w  #$980,(Player_1+x_pos).w
                bhs.s   loc_516A2                       ; Reset level Y end when Sonic has travelled past $980 X
                rts
; ---------------------------------------------------------------------------

MGZ2_QuakeEvent2Cont:
                cmpi.w  #$100,(Player_1+y_pos).w
                bhs.s   locret_51696
                cmpi.w  #$2F80,(Player_1+x_pos).w
                blo.s   locret_51696
                move.w  #$6000,d0
                move.w  d0,(Camera_max_X_pos).w
                bra.s   loc_516A2
; ---------------------------------------------------------------------------

locret_51696:
                rts
; ---------------------------------------------------------------------------

MGZ2_QuakeEvent3Cont:
                cmpi.w  #$3200,(Player_1+x_pos).w
                blo.s   loc_516A2
                rts
; ---------------------------------------------------------------------------

loc_516A2:
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
                lea     (MGZ2_ChunkEventArray).l,a1
                moveq   #4,d2
                moveq   #3-1,d3

loc_516E4:
                cmp.w   (a1),d0
                blo.s   loc_51706
                cmp.w   2(a1),d0
                bhs.s   loc_51706
                cmp.w   4(a1),d1
                blo.s   loc_51706
                cmp.w   6(a1),d1
                bhs.s   loc_51706
                cmpi.w  #4,d2
                bne.s   loc_51712
                tst.w   (Screen_shake_flag).w
                bmi.s   loc_51712                       ; Only perform the first layout shift event if screen is continually shaking

loc_51706:
                lea     $C(a1),a1
                addq.w  #4,d2
                dbf     d3,loc_516E4
                rts
; ---------------------------------------------------------------------------

loc_51712:
                move.w  d2,(Events_bg+$04).w
                clr.w   (Events_bg+$06).w
                clr.w   (Events_bg+$08).w
                move.w  8(a1),(Events_bg+$0A).w
                move.w  $A(a1),(Events_bg+$0C).w

MGZ2_ChunkEvent1:
                move.w  (Events_bg+$06).w,d0
                cmpi.w  #$5C,d0
                blo.s   loc_51762
                clr.w   (Screen_shake_flag).w           ; Stop shaking when first chunk event is finished
                clr.w   (Events_fg_0).w                 ; Reset quake event
                clr.w   (Camera_min_X_pos).w            ; Reset level height
                move.w  #$10,(Events_bg+$04).w
                rts
; ---------------------------------------------------------------------------

MGZ2_ChunkEvent2_3:
                move.w  (Events_bg+$06).w,d0
                cmpi.w  #$5C,d0
                blo.s   loc_51762
                move.w  #$6000,d0
                move.w  d0,(Camera_max_X_pos).w         ; Reset level end X
                move.w  #$14,(Events_bg+$04).w
                rts
; ---------------------------------------------------------------------------

loc_51762:
                subq.w  #1,(Events_bg+$08).w
                bpl.s   locret_517C2
                move.w  #7-1,(Events_bg+$08).w          ; Perform the layout change once every seven frames
                move.w  d0,d2
                bsr.s   MGZ2_ModifyChunk
                move.w  (Events_bg+$0A).w,d0
                addi.w  #$80,d0
                sub.w   (Camera_X_pos_copy).w,d0
                bcs.s   locret_517C2
                cmpi.w  #$1C0,d0                        ; Calculate the X position of the screen redraw
                bhs.s   locret_517C2
                move.w  (Events_bg+$0C).w,d0
                lea     (MGZ2_ScreenRedrawArray).l,a1
                add.w   (a1,d2.w),d0                    ; Calculate the Y position
                move.w  2(a1,d2.w),d2                   ; And the number of lines to write

loc_51798:
                move.w  (Camera_Y_pos_copy).w,d3
                and.w   (Camera_Y_pos_mask).w,d3
                cmp.w   d3,d0
                blo.s   loc_517BA
                addi.w  #$F0,d3
                cmp.w   d3,d0
                bhs.s   loc_517BA
                move.w  (Events_bg+$0A).w,d1
                moveq   #8,d6                           ; Always draw 8 tiles
                swap    d2
                jsr     Setup_TileRowDraw(pc)
                swap    d2

loc_517BA:
                addi.w  #$10,d0
                dbf     d2,loc_51798

locret_517C2:
                rts
; ---------------------------------------------------------------------------

MGZ2_ChunkEventReset:
                cmpi.w  #$2A00,(Player_1+x_pos).w       ; When Player has travelled far enough, reset the chunk to its original form
                blo.s   locret_517D4
                clr.w   (Events_bg+$04).w
                moveq   #$5C,d0
                bra.s   MGZ2_ModifyChunk
; ---------------------------------------------------------------------------

locret_517D4:
                rts

; =============== S U B R O U T I N E =======================================

MGZ2_ModifyChunk:
                lea     (MGZ2_ChunkReplaceArray).l,a1
                lea     ((RAM_start+$5880)&$FFFFFF).l,a5
                bsr.s   sub_517EA
                lea     ((RAM_start+$7500)&$FFFFFF).l,a5
; End of function MGZ2_ModifyChunk

; =============== S U B R O U T I N E =======================================

sub_517EA:
                lea     (MGZ2_QuakeChunks).l,a4
                adda.w  (a1,d0.w),a4
                moveq   #8-1,d1

loc_517F6:
                move.l  (a4)+,(a5)+
                move.l  (a4)+,(a5)+
                move.l  (a4)+,(a5)+
                move.l  (a4)+,(a5)+
                dbf     d1,loc_517F6
                addq.w  #2,d0
                move.w  d0,(Events_bg+$06).w
                rts
; End of function sub_517EA
