; Owner: game/level/zones/lbz/sk
; Responsibility: Launch Base act-two screen and background initialization and event control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

LBZ2_ScreenInit:
                jsr     Adjust_LBZ2Layout(pc)
                move.w  #4,(Events_routine_fg).w
                clr.l   (Events_bg+$14).w
                clr.w   (_unkEEA0).w
                clr.w   (Event_LBZ2_DeathEgg).w
                clr.w   (Events_fg_3).w
                bsr.s   LBZ2_LayoutMod
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

LBZ2_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                move.w  (Events_routine_fg).w,d0
                jmp     LBZ2_ScreenEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

LBZ2_ScreenEvent_Index:
                bra.w   LBZ2SE_FromTransition
; ---------------------------------------------------------------------------
                bra.w   LBZ2SE_Normal
; ---------------------------------------------------------------------------

LBZ2SE_FromTransition:
                cmpi.w  #3,(Player_mode).w              ; Only run when going from transition, of course
                beq.s   loc_543C2                       ; Knuckles adjusts the layout immediately
                cmpi.w  #$60A,(Player_1+x_pos).w
                blo.s   loc_5439E
                bsr.s   LBZ2_LayoutMod
                addq.w  #4,(Events_routine_fg).w
                jmp     Refresh_PlaneScreenDirect(pc)
; ---------------------------------------------------------------------------

loc_5439E:
                jmp     DrawTilesAsYouMove(pc)

; =============== S U B R O U T I N E =======================================

LBZ2_LayoutMod:
                movea.w (a3),a5                         ; Thankfully, this is the only one in the whole level
                lea     $94(a5),a5
                movea.w (a3),a1
                addq.w  #6,a1
                move.w  -8(a3),d0
                subq.w  #6,d0
                moveq   #6-1,d1

loc_543B4:
                move.l  (a5)+,(a1)+
                move.w  (a5)+,(a1)+
                adda.w  d0,a5
                adda.w  d0,a1
                dbf     d1,loc_543B4
                rts
; End of function LBZ2_LayoutMod

; ---------------------------------------------------------------------------

loc_543C2:
                bsr.s   LBZ2_LayoutMod
                addq.w  #4,(Events_routine_fg).w

LBZ2SE_Normal:
                jmp     DrawTilesAsYouMove(pc)          ; Remarkably straightforward

; =============== S U B R O U T I N E =======================================

Adjust_LBZ2Layout:
                movea.w (Level_layout_main+$48).w,a1
                movea.w (Level_layout_main+$4C).w,a5
                move.b  5(a1),5(a5)
                move.b  #$DB,5(a1)
                jsr     LBZ1_RotateChunks(pc)
                movea.w (Level_layout_main+$4C).w,a1
                move.b  4(a1),d0
                movea.w (Level_layout_main+$50).w,a1
                addq.w  #4,a1
                move.b  d0,(a1)+
                move.b  d0,(a1)+
                move.b  d0,(a1)+
                movea.w (Level_layout_main+$1C).w,a1
                move.b  #$58,$8A(a1)
                movea.w (Level_layout_main+$20).w,a1
                move.b  #$55,$8A(a1)
                rts
; End of function Adjust_LBZ2Layout

; ---------------------------------------------------------------------------

LBZ2_BackgroundInit:
                move.w  #8,(Events_routine_bg).w
                jsr     LBZ2_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                moveq   #$40,d0
                cmp.w   (Events_bg+$10).w,d0
                blt.s   loc_54432
                neg.w   d0
                cmp.w   (Events_bg+$10).w,d0
                bgt.s   loc_54436

loc_54432:
                move.w  d0,(Events_bg+$10).w            ; Keep art reloading in range

loc_54436:
                lea     (LBZ2_BGDeformArray).l,a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

LBZ2_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     LBZ2_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

LBZ2_BackgroundEvent_Index:
                bra.w   LBZ2BGE_FromTransition
; ---------------------------------------------------------------------------
                bra.w   LBZ2BGE_Refresh
; ---------------------------------------------------------------------------
                bra.w   LBZ2BGE_Normal
; ---------------------------------------------------------------------------
                bra.w   LBZ2BGE_DeathEgg
; ---------------------------------------------------------------------------
                bra.w   LBZ2BGE_PlatformDetach
; ---------------------------------------------------------------------------
                bra.w   LBZ2BGE_Falling
; ---------------------------------------------------------------------------

LBZ2BGE_FromTransition:
                jsr     LBZ2_Deform(pc)                 ; This and below are only done when transitioning
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_54488
; ---------------------------------------------------------------------------

LBZ2BGE_Refresh:
                jsr     LBZ2_Deform(pc)

loc_54488:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.s   loc_544A4
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_544A4
; ---------------------------------------------------------------------------

LBZ2BGE_Normal:
                tst.w   (Events_fg_5).w
                bne.s   loc_544C6                       ; Wait for flag
                jsr     LBZ2_Deform(pc)

loc_544A4:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                lea     (LBZ2_BGDeformArray).l,a4
                lea     (HScroll_table).w,a5
                jsr     ApplyDeformation(pc)
                jmp     ShakeScreen_Setup(pc)
; ---------------------------------------------------------------------------

loc_544C6:
                clr.w   (Events_fg_5).w                 ; Oh boy, NOW the fun begins
                move.w  8(a3),(a3)
                move.w  $C(a3),4(a3)                    ; Modify the background slightly
                move.w  #$4390,d0
                move.w  d0,(Camera_max_X_pos).w         ; X-end is at $4390
                move.w  #$668,d0
                move.w  d0,(Camera_max_Y_pos).w         ; Y-end is $668
                move.w  d0,(Camera_target_max_Y_pos).w
                move.w  #$3C,(Events_bg+$0E).w
                move.w  #$1E00,(_unkEEA2).w
                move.l  #$6200,(_unkEE9C).w
                st      (Scroll_lock).w
                st      (Event_LBZ2_DeathEgg).w
                addq.w  #4,(Events_routine_bg).w

LBZ2BGE_DeathEgg:
                tst.w   (Event_LBZ2_DeathEgg).w
                beq.s   loc_5452E
                tst.w   (Screen_shake_flag).w
                bne.s   loc_5451A                       ; Branch if shaking
                clr.w   (Event_LBZ2_DeathEgg).w
                bra.s   loc_5452E
; ---------------------------------------------------------------------------

loc_5451A:
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   loc_5452E
                moveq   #signextendB(sfx_DeathEggRiseLoud),d0  ; Play Death Egg rumbling sound
                jsr     (Play_SFX).l

loc_5452E:
                tst.w   (Events_fg_5).w
                beq.w   loc_545DE
                jsr     LBZ2_EndFallingAccel(pc)        ; When signaled, start the falling of the death egg platform
                tst.w   (_unkEE9C).w
                bpl.w   loc_545DE
                clr.w   (Events_fg_5).w                 ; When movement starts going negative
                move.w  #$1B,(Draw_delayed_rowcount).w
                move.w  #$10,(Special_V_int_routine).w  ; Do the first window copy
                clr.b   (Water_flag).w                  ; No more water evidently
                addq.w  #4,(Events_routine_bg).w
                bra.w   loc_545DE
; ---------------------------------------------------------------------------

LBZ2BGE_PlatformDetach:
                tst.w   (Special_V_int_routine).w
                bne.s   AdvanceLbz2DeathEggFallingBackground                       ; Wait for window copy to finish
                move.w  (Level_frame_counter).w,d0
                andi.w  #3,d0
                bne.s   loc_545AA
                move.w  (Events_bg+$16).w,d0            ; Only ever four frames
                cmpi.w  #$28,d0
                blo.s   loc_545A4
                clr.w   (Events_bg+$16).w               ; When scroll A has scrolled off screen
                move.w  #$18,(Special_V_int_routine).w  ; Use the next Special VInt function to restore the entire platform
                movea.w $2A(a3),a1
                lea     $87(a1),a1
                clr.b   (a1)
                clr.b   1(a1)
                clr.b   2(a1)                           ; Furthermore, clear the entire level layout at $580 Y, $4380 X (3 chunks long, 2 chunks high)
                adda.w  -$A(a3),a1
                clr.b   (a1)+
                clr.b   (a1)+
                clr.b   (a1)                            ; This is for when the platform scrolls off screen at the end
                addq.w  #4,(Events_routine_bg).w
                bra.s   LBZ2BGE_Falling
; ---------------------------------------------------------------------------

loc_545A4:
                addq.w  #1,d0
                move.w  d0,(Events_bg+$16).w            ; Increment value

loc_545AA:
                bsr.s   AdvanceLbz2DeathEggFallingBackground
                move.w  (Camera_Y_pos_copy).w,(V_scroll_value).w
                move.w  (Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w
                move.w  (Events_bg+$16).w,d0
                add.w   d0,(V_scroll_value).w           ; Actual vertical scroll is modified by EEE8
                addq.w  #4,sp
                rts
; ---------------------------------------------------------------------------

LBZ2BGE_Falling:
                tst.w   (Events_fg_5).w
                beq.s   AdvanceLbz2DeathEggFallingBackground                       ; Continue Death Egg deformation until signal
                st      (Scroll_lock).w                 ; Set flag so that camera doesn't follow Sonic
                move.w  (Camera_Y_pos).w,(Camera_Y_pos_copy).w  ; Scroll screen upwards
                subq.w  #2,(Camera_Y_pos).w
                rts

; =============== S U B R O U T I N E =======================================

AdvanceLbz2DeathEggFallingBackground:
                jsr     LBZ2_EndFallingAccel(pc)

loc_545DE:
                jsr     LBZ2_DeathEggMoveScreen(pc)
                jsr     LBZ2_DeathEggDeform(pc)
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                lea     (LBZ2_DEBGDeformArray).l,a4
                lea     (HScroll_table).w,a5
                jsr     ApplyDeformation(pc)
                jmp     ShakeScreen_Setup(pc)
; End of function AdvanceLbz2DeathEggFallingBackground
