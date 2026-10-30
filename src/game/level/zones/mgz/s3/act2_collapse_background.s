; Owner: game/level/zones/mgz/s3
; Responsibility: Marble Garden act-two collapse solids, background deformation and coordinated character-dependent background movement
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_MGZ2LevelCollapseSolid:
                cmpi.w  #8,(Events_routine_fg).w
                bne.s   loc_3CF2E
                jmp     (Delete_Current_Sprite).l       ; Delete control object when next screen event is in effect
; ---------------------------------------------------------------------------

loc_3CF2E:
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
MGZ2_QuakeEventArray:
                dc.w    $780,  $7C0,  $580,  $600,  $5A0,  $7E0  ; Player X boundaries, Player Y boundaries, Level size reset val
                dc.w    $31C0, $3200,  $1C0,  $280,  $1E0, $2F60
                dc.w    $3440, $3480,  $680,  $700,  $6A0, $32C0
MGZ2_ChunkEventArray:
                dc.w    $F68,  $F78,  $500,  $580,  $F00,  $500  ; Player X boundaries, Player Y boundaries, Screen redraw area
                dc.w    $3680, $3700,  $2F0,  $380, $3700,  $280
                dc.w    $3000, $3080,  $770,  $800, $3080,  $700
MGZ2_ScreenRedrawArray:
                dc.w    $40,  4-1
                dc.w    $50,  4-1
                dc.w    $50,  5-1
                dc.w    $60,  5-1
                dc.w    $60,  4-1
                dc.w    $70,  3-1
                dc.w    $70,  4-1
                dc.w    $80,  4-1
                dc.w    $80,  4-1
                dc.w    $80,  5-1
                dc.w    $80,  5-1
                dc.w    $80,  5-1
                dc.w    $80,  6-1
                dc.w    $90,  6-1
                dc.w    $A0,  5-1
                dc.w    $90,  7-1
                dc.w    $80,  7-1
                dc.w    $90,  7-1
                dc.w    $A0,  6-1
                dc.w    $B0,  5-1
                dc.w    $C0,  4-1
                dc.w    $D0,  3-1
                dc.w    $E0,  2-1
MGZ2_ChunkReplaceArray:
                dc.w    $100, $500
                dc.w    $180, $580
                dc.w    $200, $600
                dc.w    $280, $680
                dc.w    $300, $700
                dc.w    $380, $780
                dc.w    0, $800
                dc.w    0, $880
                dc.w    0, $900
                dc.w    0, $980
                dc.w    0, $A00
                dc.w    0, $A80
                dc.w    0, $B00
                dc.w    0, $B80
                dc.w    0, $C00
                dc.w    0, $C80
                dc.w    0, $D00
                dc.w    0, $D80
                dc.w    0, $E00
                dc.w    0, $E80
                dc.w    0, $F00
                dc.w    0, $F80
                dc.w    0,$1000
                dc.w    $80, $480
MGZ2_CollapseScrollDelay:
                dc.w    $A,   $10,     2,     8,    $E,     6,     0,    $C,   $12,     4
MGZ2_FGVScrollArray:
                dc.w    $3CA0,   $20,   $20,   $20,   $20,   $20,   $20,   $20,   $20, $7FFF
; ---------------------------------------------------------------------------

MGZ2_BackgroundInit:
                jsr     MGZ2_ClearBottomBG(pc)
                move.w  #4,(Events_routine_bg).w        ; Use second background event
                clr.w   (_unkEEA2).w                    ; Clear VScroll routine flag
                move.w  (Player_1+x_pos).w,d0
                move.w  (Player_1+y_pos).w,d1
                cmpi.w  #$500,d1
                bhs.s   loc_3D0C0
                cmpi.w  #$3800,d0
                blo.s   loc_3D10C
                move.w  #4,(Events_bg+$00).w            ; If player is <$500 Y and >$3800 X (Knuckles area presumably)
                move.l  #Obj_MGZ2BGMoveKnux,d1
                cmpi.w  #$3A80,d0
                blo.s   loc_3D102
                move.w  #$220,(Events_bg+$02).w
                bra.s   loc_3D10C
; ---------------------------------------------------------------------------

loc_3D0C0:
                cmpi.w  #$800,d1
                blo.s   loc_3D0E6
                cmpi.w  #$34C0,d0
                blo.s   loc_3D10C
                move.w  #8,(Events_bg+$00).w            ; If player is >$800 Y and >$34C0 X
                move.l  #Obj_MGZ2BGMoveSonic,d1
                cmpi.w  #$3800,d0
                blo.s   loc_3D102
                move.w  #$1D0,(Events_bg+$02).w
                bra.s   loc_3D10C
; ---------------------------------------------------------------------------

loc_3D0E6:
                cmpi.w  #$3900,d0
                blo.s   loc_3D10C
                move.w  #$C,(Events_bg+$00).w           ; If player is >$3900X and inbetween $500 and $800 Y
                move.w  #$1D0,(Events_bg+$02).w
                st      (Events_bg+$0E).w               ; Turn off cloud movement
                clr.l   (HScroll_table+$038).w
                bra.s   loc_3D10C
; ---------------------------------------------------------------------------

loc_3D102:
                jsr     (AllocateObject).l
                bne.s   loc_3D10C
                move.l  d1,(a1)

loc_3D10C:
                jsr     MGZ2_BGDeform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                clr.l   (HScroll_table).w
                move.w  d2,(HScroll_table+$006).w
                lea     MGZ2_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                jsr     Refresh_PlaneTileDeform(pc)
                lea     MGZ2_BGDeformArray(pc),a4
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
                bra.s   loc_3D190
; ---------------------------------------------------------------------------

MGZ2BGE_Normal:
                jsr     MGZ2_BGEventTrigger(pc)
                bne.s   loc_3D190                       ; If BG event has triggered, go refresh the BG
                jsr     MGZ2_BGDeform(pc)

loc_3D160:
                lea     MGZ2_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                moveq   #$20,d6
                moveq   #2,d5
                jsr     Draw_BG(pc)
                lea     MGZ2_BGDeformArray(pc),a4
                lea     (HScroll_table+$008).w,a5
                jsr     ApplyDeformation(pc)
                lea     MGZ2_FGVScrollArray(pc),a4
                lea     (HScroll_table+$126).w,a5
                jsr     Apply_FGVScroll(pc)
                jsr     Get_BGActualEffectiveDiff(pc)
                jmp     ShakeScreen_Setup(pc)
; ---------------------------------------------------------------------------

loc_3D190:
                jsr     MGZ2_BGDeform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                move.w  d2,(HScroll_table+$006).w
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_3D1B8
; ---------------------------------------------------------------------------

MGZ2BGE_Refresh:
                jsr     MGZ2_BGDeform(pc)

loc_3D1B8:
                lea     MGZ2_BGDrawArray(pc),a4
                lea     (HScroll_table-$04).w,a5
                move.w  (Camera_Y_pos_BG_copy).w,d1
                jsr     Draw_PlaneVertBottomUpComplex(pc)
                bpl.s   loc_3D160
                subq.w  #4,(Events_routine_bg).w
                bra.s   loc_3D160

; =============== S U B R O U T I N E =======================================

MGZ2_BGDeform:
                move.w  (Events_bg+$00).w,d0
                jmp     MGZ2_BGDeform_Index(pc,d0.w)
; End of function MGZ2_BGDeform

; ---------------------------------------------------------------------------

MGZ2_BGDeform_Index:
                bra.w   loc_3D21E                       ; 0 - Normal
; ---------------------------------------------------------------------------
                bra.w   loc_3D1F4                       ; 4 - Knuckles BG move event
; ---------------------------------------------------------------------------
                bra.w   loc_3D1EA                       ; 8 - Sonic BG move event
; ---------------------------------------------------------------------------
                move.w  #$500,d1                        ; C - After BG move event
                bra.s   loc_3D220
; ---------------------------------------------------------------------------

loc_3D1EA:
                move.w  #$8F0,d1
                move.w  #$3200,d2
                bra.s   loc_3D1FC
; ---------------------------------------------------------------------------

loc_3D1F4:
                move.w  #$1E0,d1
                move.w  #$3580,d2

loc_3D1FC:
                move.w  (Camera_Y_pos_copy).w,d0
                sub.w   d1,d0
                add.w   (Events_bg+$02).w,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w     ; Effective BG Y is offset, but otherwise matched in ratio during the special BG events
                move.w  (Camera_X_pos_copy).w,d0
                sub.w   d2,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                move.w  d0,(HScroll_table+$004).w
                move.w  d0,(HScroll_table+$036).w
                bra.s   loc_3D24C
; ---------------------------------------------------------------------------

loc_3D21E:
                moveq   #0,d1

loc_3D220:
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  (Screen_shake_offset).w,d2
                sub.w   d2,d0
                sub.w   d1,d0                           ; Subtract from that and the special offset for MGZ2 events
                swap    d0
                clr.w   d0
                asr.l   #4,d0
                move.l  d0,d1
                add.l   d0,d0
                add.l   d1,d0
                swap    d0
                add.w   d2,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w     ; Effective BG Y is normal 3/16ths normal BG Y during normal play
                clr.w   (Camera_X_pos_BG_copy).w
                clr.w   (HScroll_table+$004).w
                clr.w   (HScroll_table+$036).w

loc_3D24C:
                move.w  (Camera_X_pos_copy).w,d0
                cmpi.w  #8,(Events_routine_fg).w
                bne.s   loc_3D25C
                move.w  (Events_bg+$0C).w,d0            ; If playing on the boss, use the special camera scrolling set by MGZ2's screen event

loc_3D25C:
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d1
                asr.l   #3,d1
                move.l  d1,d2
                asr.l   #2,d2
                lea     (HScroll_table+$036).w,a1
                moveq   #8-1,d3

loc_3D270:
                swap    d0
                move.w  d0,-(a1)
                swap    d0
                sub.l   d1,d0
                dbf     d3,loc_3D270
                tst.w   (Events_bg+$0E).w               ; If EEE0 is set, don't bother moving the clouds automatically
                bne.s   loc_3D28A
                addi.l  #$800,(HScroll_table+$038).w

loc_3D28A:
                move.l  (HScroll_table+$038).w,d1
                lea     (HScroll_table+$008).w,a1
                lea     MGZ2_BGDeformIndex(pc),a5
                move.l  d2,d0
                asr.l   #1,d2
                moveq   #$F-1,d3

loc_3D29C:
                move.w  (a5)+,d4
                add.l   d1,d0
                swap    d0
                move.w  d0,(a1,d4.w)
                swap    d0
                add.l   d2,d0
                dbf     d3,loc_3D29C
                lea     MGZ2_BGDeformOffset(pc),a5
                moveq   #$17-1,d0

loc_3D2B4:
                move.w  (a5)+,d1
                add.w   d1,(a1)+
                dbf     d0,loc_3D2B4
                rts

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
                beq.s   loc_3D2D8
                rts
; ---------------------------------------------------------------------------

loc_3D2D8:
                move.w  (Player_1+x_pos).w,d0
                move.w  (Player_1+y_pos).w,d1
                move.w  (Events_bg+$00).w,d2
                jmp     MGZ2_BGEventTrigger_Index(pc,d2.w)
; End of function MGZ2_BGEventTrigger

; ---------------------------------------------------------------------------

MGZ2_BGEventTrigger_Index:
                bra.w   loc_3D376                       ; 0 - Normal
; ---------------------------------------------------------------------------
                bra.w   loc_3D348                       ; 4 - Knuckles BG Move Event
; ---------------------------------------------------------------------------
                bra.w   loc_3D310                       ; 8 - Sonic BG Move Event
; ---------------------------------------------------------------------------
                clr.b   (Background_collision_flag).w   ; C - After BG Move
                cmpi.w  #$800,d1                        ; Turn off BG collision
                blo.w   loc_3D3C4
                cmpi.w  #$3A40,d0
                blo.w   loc_3D3C4                       ; If Player (Sonic/Tails) is > $800 Y and > $3A40 X, go back to BG event
                move.w  #8,(Events_bg+$00).w
                rts
; ---------------------------------------------------------------------------

loc_3D310:
                st      (Background_collision_flag).w   ; Set BG collision on
                cmpi.w  #$800,d1
                bhs.s   loc_3D32E
                cmpi.w  #$3900,d0
                blo.w   loc_3D3C4
                st      (Events_bg+$0E).w               ; If Player < $800 Y and > $3900 X, turn off cloud movement
                clr.l   (HScroll_table+$038).w
                moveq   #$C,d0                          ; Go to after BG Event trigger
                bra.s   loc_3D340
; ---------------------------------------------------------------------------

loc_3D32E:
                cmpi.w  #$900,d1
                bhs.w   loc_3D3C4
                cmpi.w  #$34C0,d0
                bhs.w   loc_3D3C4                       ; If player is > $900 Y or > $34C0 X, continue normal deformation
                moveq   #0,d0

loc_3D340:
                move.w  d0,(Events_bg+$00).w            ; Otherwise, return to normal BG collision trigger
                moveq   #-1,d0
                rts
; ---------------------------------------------------------------------------

loc_3D348:
                st      (Background_collision_flag).w   ; Set BG collision on
                cmpi.w  #$100,d1
                bhs.s   loc_3D35C
                cmpi.w  #$3C00,d0
                blo.s   loc_3D35C
                clr.b   (Background_collision_flag).w   ; If Player < $100 Y and > $3C00 X, turn off BG collision

loc_3D35C:
                cmpi.w  #$80,d1
                blo.s   loc_3D3C4
                cmpi.w  #$180,d1
                bhs.s   loc_3D3C4
                cmpi.w  #$3800,d0
                bhs.s   loc_3D3C4                       ; If player is < $80 Y and > $180 Y and  > $3800 X, continue deformation
                clr.w   (Events_bg+$00).w               ; Otherwise
                moveq   #-1,d0
                rts
; ---------------------------------------------------------------------------

loc_3D376:
                clr.b   (Background_collision_flag).w
                cmpi.w  #$80,d1
                blo.s   loc_3D3C4
                cmpi.w  #$180,d1
                bhs.s   loc_3D396
                cmpi.w  #$3800,d0
                blo.s   loc_3D3C4
                moveq   #4,d0                           ; If between $80 and $180 Y and > $3800 X, use first BG move
                move.l  #Obj_MGZ2BGMoveKnux,d1
                bra.s   loc_3D3B0
; ---------------------------------------------------------------------------

loc_3D396:
                cmpi.w  #$800,d1
                blo.s   loc_3D3C4
                cmpi.w  #$900,d1
                bhs.s   loc_3D3C4
                cmpi.w  #$34C0,d0
                blo.s   loc_3D3C4
                moveq   #8,d0                           ; If between $800 and $900 Y and > $34C0 X, use second BG move
                move.l  #Obj_MGZ2BGMoveSonic,d1

loc_3D3B0:
                move.w  d0,(Events_bg+$00).w
                clr.w   (Events_bg+$02).w
                jsr     (AllocateObject).l
                bne.s   locret_3D3C2
                move.l  d1,(a1)

locret_3D3C2:
                rts
; ---------------------------------------------------------------------------

loc_3D3C4:
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

Obj_MGZ2BGMoveKnux:
                moveq   #4,d0
                move.w  #$400,d1
                move.w  #$38A0,d2
                move.w  #$220,d3
                move.w  #$6000,d4
                bra.s   loc_3D3F2
; ---------------------------------------------------------------------------

Obj_MGZ2BGMoveSonic:
                moveq   #8,d0
                move.w  #$A80,d1
                move.w  #$36D0,d2
                move.w  #$1D0,d3
                move.w  #$6000,d4
                st      $38(a0)

loc_3D3F2:
                cmp.w   (Events_bg+$00).w,d0
                beq.s   loc_3D3FE
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3D3FE:
                cmp.w   (Player_1+y_pos).w,d1
                bhs.s   locret_3D40A
                cmp.w   (Player_1+x_pos).w,d2
                blo.s   loc_3D40C

locret_3D40A:
                rts
; ---------------------------------------------------------------------------

loc_3D40C:
                move.w  d3,$2E(a0)
                move.w  d4,$32(a0)
                move.w  (Camera_X_pos_copy).w,d0
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_target_min_X_pos).w
                move.l  #loc_3D426,(a0)

loc_3D426:
                move.w  (Events_bg+$02).w,d0
                cmp.w   $2E(a0),d0                      ; Wait for BG offset to match given value
                blo.s   loc_3D444
                moveq   #signextendB(sfx_Crash),d0      ; Play final crashing sound
                jsr     (Play_SFX).l
                move.w  #$E,(Screen_shake_flag).w       ; Do final screen shake
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3D444:
                move.w  (Player_1+x_pos).w,d2
                move.w  (Player_1+y_pos).w,d3
                tst.b   $39(a0)
                beq.s   loc_3D458
                move.w  d0,d1
                addq.w  #1,d1
                bra.s   loc_3D484
; ---------------------------------------------------------------------------

loc_3D458:
                tst.b   $38(a0)
                bne.s   loc_3D46C
                cmpi.w  #$200,d3
                bhs.s   loc_3D476
                cmpi.w  #$3CB0,d2
                blo.s   loc_3D472
                bra.s   loc_3D476
; ---------------------------------------------------------------------------

loc_3D46C:
                cmpi.w  #$3D50,d2                       ; Second background object check
                blo.s   loc_3D476

loc_3D472:
                st      $39(a0)

loc_3D476:
                move.l  $34(a0),d1
                add.l   $30(a0),d1
                move.l  d1,$34(a0)
                swap    d1

loc_3D484:
                move.w  d1,(Events_bg+$02).w            ; Move background offset
                sub.w   d0,d1
                sub.w   d1,(Player_1+y_pos).w
                sub.w   d1,(Player_2+y_pos).w
                rts
; ---------------------------------------------------------------------------
MGZ2_BGDrawArray:
                dc.w    $200, $7FFF
MGZ2_BGDeformArray:
                dc.w    $10,   $10,   $10,   $10,   $10,   $18,     8,   $10,     8,     8,   $10,     8
                dc.w    8,     8,     5,   $2B,    $C,     6,     6,     8,     8,   $18,   $D8, $7FFF
MGZ2_BGDeformIndex:
                dc.w    $1C,   $18,   $1A,    $C,     6,   $14,     2,   $10,   $16,   $12,    $A,     0,     8,     4,    $E
MGZ2_BGDeformOffset:
                dc.w    -5,    -8,     9,    $A,     2,   -$C,     3,   $10,    -1,    $D,   -$F,     6
                dc.w    -$B,    -4,    $E,    -8,   $10,     8,     0,    -8,   $10,     8,     0
