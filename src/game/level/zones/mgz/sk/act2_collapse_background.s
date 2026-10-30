; Owner: game/level/zones/mgz/sk
; Responsibility: Marble Garden act-two collapse solids, background events and coordinated character-dependent movement
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_MGZ2LevelCollapseSolid:
                cmpi.w  #8,(Events_routine_fg).w
                bne.s   loc_51818
                jmp     (Delete_Current_Sprite).l       ; Delete control object when next screen event is in effect
; ---------------------------------------------------------------------------

loc_51818:
                movea.l $30(a0),a1                      ; Get vertical scroll position for this block
                move.w  $2E(a0),d0                      ; Get vertical position
                add.w   (a1),d0                         ; Add it to scroll value to get final Y position
                move.w  d0,y_pos(a0)
                move.b  #$10,width_pixels(a0)           ; Set up width
                bset    #7,status(a0)                   ; Make it invisible
                moveq   #$1B,d1
                moveq   #$40,d2
                moveq   #$40,d3                         ; Height, etc
                move.w  x_pos(a0),d4                    ; Position
                jmp     (SolidObjectFull2).l
; ---------------------------------------------------------------------------

MGZ2_BackgroundInit:
                jsr     MGZ2_ClearBottomBG(pc)
                move.w  #4,(Events_routine_bg).w        ; Use second background event
                clr.w   (_unkEEA2).w                    ; Clear VScroll routine flag
                move.w  (Player_1+x_pos).w,d0
                move.w  (Player_1+y_pos).w,d1
                cmpi.w  #$500,d1
                bhs.s   loc_5187E
                cmpi.w  #$3800,d0
                blo.s   loc_518CA
                move.w  #4,(Events_bg+$00).w            ; If player is <$500 Y and >$3800 X (Knuckles area presumably)
                move.l  #Obj_MGZ2BGMoveKnux,d1
                cmpi.w  #$3A80,d0
                blo.s   loc_518C0
                move.w  #$220,(Events_bg+$02).w
                bra.s   loc_518CA
; ---------------------------------------------------------------------------

loc_5187E:
                cmpi.w  #$800,d1
                blo.s   loc_518A4
                cmpi.w  #$34C0,d0
                blo.s   loc_518CA
                move.w  #8,(Events_bg+$00).w            ; If player is >$800 Y and >$34C0 X
                move.l  #Obj_MGZ2BGMoveSonic,d1
                cmpi.w  #$3800,d0
                blo.s   loc_518C0
                move.w  #$1D0,(Events_bg+$02).w
                bra.s   loc_518CA
; ---------------------------------------------------------------------------

loc_518A4:
                cmpi.w  #$3900,d0
                blo.s   loc_518CA
                move.w  #$C,(Events_bg+$00).w           ; If player is >$3900X and inbetween $500 and $800 Y
                move.w  #$1D0,(Events_bg+$02).w
                st      (Events_bg+$0E).w               ; Turn off cloud movement
                clr.l   (HScroll_table+$038).w
                bra.s   loc_518CA
; ---------------------------------------------------------------------------

loc_518C0:
                jsr     (AllocateObject).l
                bne.s   loc_518CA
                move.l  d1,(a1)

loc_518CA:
                jsr     (MGZ2_BGDeform).l
                jsr     Reset_TileOffsetPositionEff(pc)
                clr.l   (HScroll_table).w
                move.w  d2,(HScroll_table+$006).w
                lea     (MGZ2_BGDrawArray).l,a4
                lea     (HScroll_table).w,a5
                jsr     Refresh_PlaneTileDeform(pc)
                lea     (MGZ2_BGDeformArray).l,a4
                lea     (HScroll_table+$008).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

MGZ2_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     MGZ2_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

MGZ2_BackgroundEvent_Index:
                bra.w   MGZ2BGE_GoRefresh
; ---------------------------------------------------------------------------
                bra.w   MGZ2BGE_Normal
; ---------------------------------------------------------------------------
                bra.w   MGZ2BGE_Refresh
; ---------------------------------------------------------------------------

MGZ2BGE_GoRefresh:
                jsr     MGZ2_ClearBottomBG(pc)
                clr.l   (HScroll_table).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_51968
; ---------------------------------------------------------------------------

MGZ2BGE_Normal:
                jsr     MGZ2_BGEventTrigger(pc)
                bne.s   loc_51968                       ; If BG event has triggered, go refresh the BG
                jsr     (MGZ2_BGDeform).l

loc_51926:
                lea     (MGZ2_BGDrawArray).l,a4
                lea     (HScroll_table).w,a5
                moveq   #$20,d6
                moveq   #2,d5
                jsr     Draw_BG(pc)
                lea     (MGZ2_BGDeformArray).l,a4
                lea     (HScroll_table+$008).w,a5
                jsr     ApplyDeformation(pc)
                lea     (MGZ2_FGVScrollArray).l,a4
                lea     (HScroll_table+$126).w,a5
                jsr     Apply_FGVScroll(pc)
                jsr     Get_BGActualEffectiveDiff(pc)
                jsr     ShakeScreen_Setup(pc)
                tst.b   (Background_collision_flag).w
                beq.s   locret_51966
                jmp     Go_CheckPlayerRelease(pc)       ; Only do this if BG collision is on
; ---------------------------------------------------------------------------

locret_51966:
                rts
; ---------------------------------------------------------------------------

loc_51968:
                jsr     (MGZ2_BGDeform).l
                jsr     Reset_TileOffsetPositionEff(pc)
                move.w  d2,(HScroll_table+$006).w
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_51994
; ---------------------------------------------------------------------------

MGZ2BGE_Refresh:
                jsr     (MGZ2_BGDeform).l

loc_51994:
                lea     (MGZ2_BGDrawArray).l,a4
                lea     (HScroll_table-$04).w,a5
                move.w  (Camera_Y_pos_BG_copy).w,d1
                jsr     Draw_PlaneVertBottomUpComplex(pc)
                bpl.w   loc_51926
                subq.w  #4,(Events_routine_bg).w
                bra.w   loc_51926

; =============== S U B R O U T I N E =======================================

MGZ2_ClearBottomBG:
                move.w  (a3),d0
                addq.w  #8,d0
                move.w  d0,$74(a3)
                move.w  d0,$78(a3)
                move.w  d0,$7C(a3)
                rts
; End of function MGZ2_ClearBottomBG

; =============== S U B R O U T I N E =======================================

MGZ2_BGEventTrigger:
                tst.w   (_unkEEA2).w
                beq.s   loc_519CC
                rts
; ---------------------------------------------------------------------------

loc_519CC:
                move.w  (Player_1+x_pos).w,d0
                move.w  (Player_1+y_pos).w,d1
                move.w  (Events_bg+$00).w,d2
                jmp     MGZ2_BGEventTrigger_Index(pc,d2.w)
; End of function MGZ2_BGEventTrigger

; ---------------------------------------------------------------------------

MGZ2_BGEventTrigger_Index:
                bra.w   loc_51A6A                       ; 0 - Normal
; ---------------------------------------------------------------------------
                bra.w   loc_51A3C                       ; 4 - Knuckles BG Move Event
; ---------------------------------------------------------------------------
                bra.w   loc_51A04                       ; 8 - Sonic BG Move Event
; ---------------------------------------------------------------------------
                clr.b   (Background_collision_flag).w   ; C - After BG Move
                cmpi.w  #$800,d1                        ; Turn off BG collision
                blo.w   loc_51AB8
                cmpi.w  #$3A40,d0
                blo.w   loc_51AB8                       ; If Player (Sonic/Tails) is > $800 Y and > $3A40 X, go back to BG event
                move.w  #8,(Events_bg+$00).w
                rts
; ---------------------------------------------------------------------------

loc_51A04:
                st      (Background_collision_flag).w   ; Set BG collision on
                cmpi.w  #$800,d1
                bhs.s   loc_51A22
                cmpi.w  #$3900,d0
                blo.w   loc_51AB8
                st      (Events_bg+$0E).w               ; If Player < $800 Y and > $3900 X, turn off cloud movement
                clr.l   (HScroll_table+$038).w
                moveq   #$C,d0                          ; Go to after BG Event trigger
                bra.s   loc_51A34
; ---------------------------------------------------------------------------

loc_51A22:
                cmpi.w  #$900,d1
                bhs.w   loc_51AB8
                cmpi.w  #$34C0,d0
                bhs.w   loc_51AB8                       ; If player is > $900 Y or > $34C0 X, continue normal deformation
                moveq   #0,d0

loc_51A34:
                move.w  d0,(Events_bg+$00).w            ; Otherwise, return to normal BG collision trigger
                moveq   #-1,d0
                rts
; ---------------------------------------------------------------------------

loc_51A3C:
                st      (Background_collision_flag).w   ; Set BG collision on
                cmpi.w  #$100,d1
                bhs.s   loc_51A50
                cmpi.w  #$3C00,d0
                blo.s   loc_51A50
                clr.b   (Background_collision_flag).w   ; If Player < $100 Y and > $3C00 X, turn off BG collision

loc_51A50:
                cmpi.w  #$80,d1
                blo.s   loc_51AB8
                cmpi.w  #$180,d1
                bhs.s   loc_51AB8
                cmpi.w  #$3800,d0
                bhs.s   loc_51AB8                       ; If player is < $80 Y and > $180 Y and  > $3800 X, continue deformation
                clr.w   (Events_bg+$00).w               ; Otherwise
                moveq   #-1,d0
                rts
; ---------------------------------------------------------------------------

loc_51A6A:
                clr.b   (Background_collision_flag).w
                cmpi.w  #$80,d1
                blo.s   loc_51AB8
                cmpi.w  #$180,d1
                bhs.s   loc_51A8A
                cmpi.w  #$3800,d0
                blo.s   loc_51AB8
                moveq   #4,d0                           ; If between $80 and $180 Y and > $3800 X, use first BG move
                move.l  #Obj_MGZ2BGMoveKnux,d1
                bra.s   loc_51AA4
; ---------------------------------------------------------------------------

loc_51A8A:
                cmpi.w  #$800,d1
                blo.s   loc_51AB8
                cmpi.w  #$900,d1
                bhs.s   loc_51AB8
                cmpi.w  #$34C0,d0
                blo.s   loc_51AB8
                moveq   #8,d0                           ; If between $800 and $900 Y and > $34C0 X, use second BG move
                move.l  #Obj_MGZ2BGMoveSonic,d1

loc_51AA4:
                move.w  d0,(Events_bg+$00).w
                clr.w   (Events_bg+$02).w
                jsr     (AllocateObject).l
                bne.s   locret_51AB6
                move.l  d1,(a1)

locret_51AB6:
                rts
; ---------------------------------------------------------------------------

loc_51AB8:
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

Obj_MGZ2BGMoveKnux:
                moveq   #4,d0
                move.w  #$400,d1
                move.w  #$38A0,d2
                move.w  #$220,d3
                move.w  #$6000,d4
                bra.s   loc_51AE6
; ---------------------------------------------------------------------------

Obj_MGZ2BGMoveSonic:
                moveq   #8,d0
                move.w  #$A80,d1
                move.w  #$36D0,d2
                move.w  #$1D0,d3
                move.w  #$6000,d4
                st      $38(a0)

loc_51AE6:
                cmp.w   (Events_bg+$00).w,d0
                beq.s   loc_51AF2
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_51AF2:
                cmp.w   (Player_1+y_pos).w,d1
                bhs.s   locret_51AFE
                cmp.w   (Player_1+x_pos).w,d2
                blo.s   loc_51B00

locret_51AFE:
                rts
; ---------------------------------------------------------------------------

loc_51B00:
                move.w  d3,$2E(a0)
                move.w  d4,$32(a0)
                move.w  (Camera_X_pos_copy).w,d0
                move.w  d0,(Camera_min_X_pos).w
                bset    #7,(Disable_wall_grab).w
                move.l  #loc_51B1C,(a0)

loc_51B1C:
                move.w  (Events_bg+$02).w,d0
                cmp.w   $2E(a0),d0                      ; Wait for BG offset to match given value
                blo.s   loc_51B44
                moveq   #signextendB(sfx_Crash),d0      ; Play final crashing sound
                jsr     (Play_SFX).l
                move.w  #$E,(Screen_shake_flag).w       ; Do final screen shake
                clr.w   (Events_fg_0).w                 ; Disable constant screen shaking
                bclr    #7,(Disable_wall_grab).w        ; Reenable Knuckles wall grab
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_51B44:
                move.w  (Player_1+x_pos).w,d2
                move.w  (Player_1+y_pos).w,d3
                tst.b   $39(a0)
                beq.s   loc_51B58
                move.w  d0,d1
                addq.w  #1,d1
                bra.s   loc_51B84
; ---------------------------------------------------------------------------

loc_51B58:
                tst.b   $38(a0)
                bne.s   loc_51B6C
                cmpi.w  #$200,d3
                bhs.s   loc_51B76
                cmpi.w  #$3CB0,d2
                blo.s   loc_51B72
                bra.s   loc_51B76
; ---------------------------------------------------------------------------

loc_51B6C:
                cmpi.w  #$3D50,d2                       ; Second background object check
                blo.s   loc_51B76

loc_51B72:
                st      $39(a0)

loc_51B76:
                move.l  $34(a0),d1
                add.l   $30(a0),d1
                move.l  d1,$34(a0)
                swap    d1

loc_51B84:
                move.w  d1,(Events_bg+$02).w            ; Move background offset
                sub.w   d0,d1
                sub.w   d1,(Player_1+y_pos).w
                sub.w   d1,(Player_2+y_pos).w
                rts
