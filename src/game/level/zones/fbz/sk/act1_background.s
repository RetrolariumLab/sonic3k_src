; Owner: game/level/zones/fbz/sk
; Responsibility: Flying Battery act-one background initialization, events, deformation and outdoor background motion
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

FBZ1_BackgroundInit:
                jsr     (AllocateObject).l
                bne.s   loc_5286A
                move.l  #Obj_FBZOutdoorBGMotion,(a1)

loc_5286A:
                cmpi.w  #$180,(Player_1+x_pos).w
                bhs.s   loc_528A4
                st      (Events_bg+$04).w               ; if player is at start, then he's outside. Set outdoors flag
                lea     Pal_FBZBGOutdoors(pc),a1
                lea     (Target_palette_line_4+$4).w,a5
                move.l  (a1)+,(a5)+                     ; Change to outdoor palette
                move.l  (a1)+,(a5)+
                move.l  (a1)+,(a5)+
                move.l  (a1)+,(a5)+
                jsr     FBZ_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                move.w  #$200,d1                        ; Outdoor BG is $200 pixels right of indoor BG
                moveq   #0,d0
                jsr     Refresh_PlaneFull(pc)
                lea     FBZ_OutBGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

loc_528A4:
                jsr     FBZ_Deform(pc)                  ; Indoors
                jsr     Reset_TileOffsetPositionEff(pc)
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                lea     FBZ_InBGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

FBZ1_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     FBZ1_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

FBZ1_BackgroundEvent_Index:
                bra.w   FBZ1BGE_Normal
; ---------------------------------------------------------------------------
                bra.w   FBZ1BGE_ChangeTopDown
; ---------------------------------------------------------------------------
                bra.w   FBZ1BGE_ChangeBottomUp
; ---------------------------------------------------------------------------
                bra.w   FBZ1BGE_ChangeLeftRight
; ---------------------------------------------------------------------------
                bra.w   FBZ1BGE_ChangeRightLeft
; ---------------------------------------------------------------------------

FBZ1BGE_ChangeTopDown:
                jsr     FBZ1_CheckBGChange(pc)

loc_528DE:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                tst.w   (Events_bg+$04).w
                beq.s   loc_528F0
                move.w  #$200,d1
                moveq   #0,d2

loc_528F0:
                jsr     Draw_PlaneVertTopDown(pc)
                bpl.w   FBZ1BGE_GoDeform
                clr.w   (Events_routine_bg).w
                bra.w   FBZ1BGE_GoDeform
; ---------------------------------------------------------------------------

FBZ1BGE_ChangeBottomUp:
                jsr     FBZ1_CheckBGChange(pc)

loc_52904:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                tst.w   (Events_bg+$04).w
                beq.s   loc_52916
                move.w  #$200,d1
                moveq   #0,d2

loc_52916:
                jsr     Draw_PlaneVertSingleBottomUp(pc)
                bpl.w   FBZ1BGE_GoDeform
                clr.w   (Events_routine_bg).w
                bra.w   FBZ1BGE_GoDeform
; ---------------------------------------------------------------------------

FBZ1BGE_ChangeLeftRight:
                jsr     FBZ1_CheckBGChange(pc)

loc_5292A:
                move.w  (Camera_Y_pos_BG_copy).w,d1
                moveq   #0,d2
                tst.w   (Events_bg+$04).w
                beq.s   loc_5293C
                moveq   #0,d1
                move.w  #$200,d2

loc_5293C:
                jsr     Draw_PlaneHorzLeftToRight(pc)
                bpl.w   FBZ1BGE_GoDeform
                clr.w   (Events_routine_bg).w
                bra.w   FBZ1BGE_GoDeform
; ---------------------------------------------------------------------------

FBZ1BGE_ChangeRightLeft:
                jsr     FBZ1_CheckBGChange(pc)

loc_52950:
                move.w  (Camera_Y_pos_BG_copy).w,d1
                moveq   #0,d2
                tst.w   (Events_bg+$04).w
                beq.s   loc_52962
                moveq   #0,d1
                move.w  #$200,d2

loc_52962:
                jsr     Draw_PlaneHorzRightToLeft(pc)
                bpl.w   FBZ1BGE_GoDeform
                clr.w   (Events_routine_bg).w
                bra.w   FBZ1BGE_GoDeform
; ---------------------------------------------------------------------------

FBZ1BGE_Normal:
                tst.w   (Events_fg_5).w
                beq.s   loc_529EE
                clr.w   (Events_fg_5).w                 ; Check for transition flag
                movem.l d7-a0/a2-a3,-(sp)
                moveq   #PLCID_1C,d0
                jsr     (Load_PLC).l
                move.w  #$401,(Current_zone_and_act).w
                clr.b   (Dynamic_resize_routine).w
                clr.b   (Object_load_routine).w
                clr.b   (Rings_manager_routine).w
                clr.b   (Boss_flag).w
                clr.b   (Respawn_table_keep).w
                jsr     Clear_Switches(pc)
                jsr     (Load_Level).l
                jsr     (LoadSolids).l
                moveq   #PalID_FBZ2,d0
                jsr     (LoadPalette_Immediate).l
                movem.l (sp)+,d7-a0/a2-a3
                move.w  #$2E00,d0
                moveq   #0,d1
                sub.w   d0,(Player_1+x_pos).w
                sub.w   d0,(Player_2+x_pos).w
                jsr     Offset_ObjectsDuringTransition(pc)
                sub.w   d0,(Camera_X_pos).w
                sub.w   d0,(Camera_X_pos_copy).w
                sub.w   d0,(Camera_min_X_pos).w
                sub.w   d0,(Camera_max_X_pos).w
                jsr     Reset_TileOffsetPositionActual(pc)
                jsr     FBZ_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                bra.s   FBZ1BGE_GoDeform
; ---------------------------------------------------------------------------

loc_529EE:
                cmpi.b  #6,(Player_1+routine).w
                blo.s   loc_529F8
                rts                                     ; Don't do special events if Sonic is dying
; ---------------------------------------------------------------------------

loc_529F8:
                jsr     FBZ1_CheckBGChange(pc)

FBZ1BGE_GoDeform:
                move.w  (Events_bg+$04).w,d1
                beq.s   loc_52A06
                move.w  #$200,d1

loc_52A06:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                lea     FBZ_InBGDeformArray(pc),a4
                tst.w   (Events_bg+$04).w
                beq.s   loc_52A22
                lea     FBZ_OutBGDeformArray(pc),a4

loc_52A22:
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)

; =============== S U B R O U T I N E =======================================

FBZ_Deform:
                tst.w   (Events_bg+$04).w
                bne.s   loc_52A70
                move.w  (Camera_Y_pos_copy).w,d0        ; Indoors
                asr.w   #1,d0
                move.w  d0,d1
                asr.w   #5,d1
                sub.w   d1,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w     ; Effective BG Y is slightly below half speed of normal BG Y
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                asr.l   #4,d0
                move.l  d0,d1
                lea     (HScroll_table).w,a1
                lea     FBZ_InBGDeformIndex(pc),a5
                moveq   #0,d2

loc_52A56:
                move.b  (a5)+,d3
                bmi.s   locret_52A6E
                ext.w   d3
                swap    d0

loc_52A5E:
                move.b  (a5)+,d2
                move.w  d0,(a1,d2.w)
                dbf     d3,loc_52A5E
                swap    d0
                add.l   d1,d0
                bra.s   loc_52A56
; ---------------------------------------------------------------------------

locret_52A6E:
                rts
; ---------------------------------------------------------------------------

loc_52A70:
                moveq   #$16,d0                         ; Outdoors
                add.w   (Events_bg+$08).w,d0            ; Add offset of bobbing motion to 16
                move.w  d0,(Camera_Y_pos_BG_copy).w
                lea     (HScroll_table).w,a1
                lea     FBZ_OutBGDeformIndex(pc),a5
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                asr.l   #4,d0
                move.l  d0,d1
                asr.l   #1,d1
                move.l  (HScroll_table+$1FC).w,d2       ; Get cloud movement speed
                addi.l  #$E00,(HScroll_table+$1FC).w
                moveq   #9-1,d3

loc_52A9E:
                move.w  (a5)+,d4
                add.l   d2,d0
                swap    d0
                move.w  d0,(a1,d4.w)
                swap    d0
                add.l   d1,d0
                dbf     d3,loc_52A9E
                rts
; End of function FBZ_Deform

; =============== S U B R O U T I N E =======================================

FBZ1_CheckBGChange:
                move.w  (Player_1+x_pos).w,d0
                move.w  (Player_1+y_pos).w,d1
                move.w  (Events_bg+$00).w,d2            ; The BG change events are synced with the layout mod events in screen events. Each numbered routine
                jmp     FBZ1_CheckBGChange_Index(pc,d2.w)  ; here corresponds with the same layoutmod number in FBZ1_ScreenEvents
; End of function FBZ1_CheckBGChange

; ---------------------------------------------------------------------------

FBZ1_CheckBGChange_Index:
                bra.w   FBZ_Deform                      ; If no event, then just do business as usual
; ---------------------------------------------------------------------------
                bra.w   FBZ1_BGChange1
; ---------------------------------------------------------------------------
                bra.w   FBZ1_BGChange2
; ---------------------------------------------------------------------------
                bra.w   FBZ1_BGChange3
; ---------------------------------------------------------------------------
                bra.w   FBZ1_BGChange4
; ---------------------------------------------------------------------------
                bra.w   FBZ1_BGChange5
; ---------------------------------------------------------------------------
                bra.w   FBZ1_BGChange6
; ---------------------------------------------------------------------------

FBZ1_BGChange1:
                tst.w   (Events_bg+$04).w
                bne.s   loc_52AFE
                cmpi.w  #$B00,d0                        ; If indoors
                bhs.s   loc_52AF4
                cmpi.w  #$9C0,d1
                blo.w   FBZ_Deform
                bra.s   loc_52B22
; ---------------------------------------------------------------------------

loc_52AF4:
                cmpi.w  #$900,d1
                blo.w   FBZ_Deform
                bra.s   loc_52B22
; ---------------------------------------------------------------------------

loc_52AFE:
                cmpi.w  #$B00,d0                        ; If outdoors
                bhs.s   loc_52B0E
                cmpi.w  #$9C0,d1
                bhi.w   FBZ_Deform
                bra.s   loc_52B16
; ---------------------------------------------------------------------------

loc_52B0E:
                cmpi.w  #$900,d1
                bhi.w   FBZ_Deform

loc_52B16:
                clr.w   (Events_bg+$04).w
                moveq   #4,d0
                moveq   #0,d6
                bra.w   FBZ_BGChangeGoIn
; ---------------------------------------------------------------------------

loc_52B22:
                st      (Events_bg+$04).w
                moveq   #8,d0
                move.w  #$F0,d6
                bra.w   FBZ_BGChangeGoOut
; ---------------------------------------------------------------------------

FBZ1_BGChange2:
                tst.w   (Events_bg+$04).w
                bne.s   loc_52B50
                cmpi.w  #$C80,d0
                bhs.s   loc_52B46
                cmpi.w  #$2C0,d1
                bhi.w   FBZ_Deform
                bra.s   loc_52B76
; ---------------------------------------------------------------------------

loc_52B46:
                cmpi.w  #$240,d1
                bhi.w   FBZ_Deform
                bra.s   loc_52B76
; ---------------------------------------------------------------------------

loc_52B50:
                cmpi.w  #$C80,d0
                bhs.s   loc_52B60
                cmpi.w  #$2C0,d1
                blo.w   FBZ_Deform
                bra.s   loc_52B68
; ---------------------------------------------------------------------------

loc_52B60:
                cmpi.w  #$240,d1
                blo.w   FBZ_Deform

loc_52B68:
                clr.w   (Events_bg+$04).w
                moveq   #8,d0
                move.w  #$F0,d6
                bra.w   FBZ_BGChangeGoIn
; ---------------------------------------------------------------------------

loc_52B76:
                st      (Events_bg+$04).w
                moveq   #4,d0
                moveq   #0,d6
                bra.w   FBZ_BGChangeGoOut
; ---------------------------------------------------------------------------

FBZ1_BGChange3:
                tst.w   (Events_bg+$04).w
                bne.s   loc_52BA2
                cmpi.w  #$1880,d0
                bhs.s   loc_52B98
                cmpi.w  #$9C0,d1
                blo.w   FBZ_Deform
                bra.s   loc_52BC6
; ---------------------------------------------------------------------------

loc_52B98:
                cmpi.w  #$940,d1
                blo.w   FBZ_Deform
                bra.s   loc_52BC6
; ---------------------------------------------------------------------------

loc_52BA2:
                cmpi.w  #$1880,d0
                bhs.s   loc_52BB2
                cmpi.w  #$9C0,d1
                bhi.w   FBZ_Deform
                bra.s   loc_52BBA
; ---------------------------------------------------------------------------

loc_52BB2:
                cmpi.w  #$940,d1
                bhi.w   FBZ_Deform

loc_52BBA:
                clr.w   (Events_bg+$04).w
                moveq   #4,d0
                moveq   #0,d6
                bra.w   FBZ_BGChangeGoIn
; ---------------------------------------------------------------------------

loc_52BC6:
                st      (Events_bg+$04).w
                moveq   #8,d0
                move.w  #$F0,d6
                bra.w   FBZ_BGChangeGoOut
; ---------------------------------------------------------------------------

FBZ1_BGChange4:
                cmpi.w  #$100,d1
                blo.s   loc_52C0C
                tst.w   (Events_bg+$04).w
                bne.s   loc_52BEA
                cmpi.w  #$1C0,d1
                bhi.w   FBZ_Deform
                bra.s   loc_52C00
; ---------------------------------------------------------------------------

loc_52BEA:
                cmpi.w  #$1C0,d1
                blo.w   FBZ_Deform
                clr.w   (Events_bg+$04).w
                moveq   #8,d0
                move.w  #$F0,d6
                bra.w   FBZ_BGChangeGoIn
; ---------------------------------------------------------------------------

loc_52C00:
                st      (Events_bg+$04).w
                moveq   #4,d0
                moveq   #0,d6
                bra.w   FBZ_BGChangeGoOut
; ---------------------------------------------------------------------------

loc_52C0C:
                tst.w   (Events_bg+$04).w
                bne.s   loc_52C1C
                cmpi.w  #$1B00,d0
                blo.w   FBZ_Deform
                bra.s   loc_52C2E
; ---------------------------------------------------------------------------

loc_52C1C:
                cmpi.w  #$1B00,d0
                bhi.w   FBZ_Deform
                clr.w   (Events_bg+$04).w
                moveq   #$C,d0
                moveq   #0,d6
                bra.s   loc_52C3E
; ---------------------------------------------------------------------------

loc_52C2E:
                st      (Events_bg+$04).w
                moveq   #$10,d0
                move.w  #$3F0,d6
                lea     Pal_FBZBGOutdoors(pc),a1
                bra.s   loc_52C42
; ---------------------------------------------------------------------------

loc_52C3E:
                lea     Pal_FBZBGIndoors(pc),a1         ; Special case for going left/right rather than up/down

loc_52C42:
                lea     (Normal_palette_line_4+$4).w,a5
                move.l  (a1)+,(a5)+
                move.l  (a1)+,(a5)+
                move.l  (a1)+,(a5)+
                move.l  (a1)+,(a5)+
                move.w  d0,(Events_routine_bg).w
                jsr     FBZ_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                move.w  d6,(Draw_delayed_position).w
                move.w  #$1F,(Draw_delayed_rowcount).w
                addq.w  #4,sp
                cmpi.w  #$C,(Events_routine_bg).w
                beq.w   loc_5292A
                bra.w   loc_52950
; ---------------------------------------------------------------------------

FBZ1_BGChange5:
                tst.w   (Events_bg+$04).w
                bne.s   loc_52C84
                cmpi.w  #$240,d1
                bhi.w   FBZ_Deform
                bra.s   loc_52C98
; ---------------------------------------------------------------------------

loc_52C84:
                cmpi.w  #$240,d1
                blo.w   FBZ_Deform
                clr.w   (Events_bg+$04).w
                moveq   #8,d0
                move.w  #$F0,d6
                bra.s   FBZ_BGChangeGoIn
; ---------------------------------------------------------------------------

loc_52C98:
                st      (Events_bg+$04).w
                moveq   #4,d0
                moveq   #0,d6
                bra.s   FBZ_BGChangeGoOut
; ---------------------------------------------------------------------------

FBZ1_BGChange6:
                tst.w   (Events_bg+$04).w
                bne.s   loc_52CB2
                cmpi.w  #$640,d1
                blo.w   FBZ_Deform
                bra.s   loc_52CC4
; ---------------------------------------------------------------------------

loc_52CB2:
                cmpi.w  #$640,d1
                bhi.w   FBZ_Deform
                clr.w   (Events_bg+$04).w
                moveq   #4,d0
                moveq   #0,d6
                bra.s   FBZ_BGChangeGoIn
; ---------------------------------------------------------------------------

loc_52CC4:
                st      (Events_bg+$04).w
                moveq   #8,d0
                move.w  #$F0,d6

FBZ_BGChangeGoOut:
                lea     Pal_FBZBGOutdoors(pc),a1
                bra.s   loc_52CD8
; ---------------------------------------------------------------------------

FBZ_BGChangeGoIn:
                lea     Pal_FBZBGIndoors(pc),a1

loc_52CD8:
                lea     (Normal_palette_line_4+$4).w,a5
                move.l  (a1)+,(a5)+
                move.l  (a1)+,(a5)+
                move.l  (a1)+,(a5)+
                move.l  (a1)+,(a5)+                     ; Modify the palette as needed
                move.w  d0,(Events_routine_bg).w        ; Set the appropriate BG event to handle the change
                jsr     FBZ_Deform(pc)                  ; Do deformation as normal
                jsr     Reset_TileOffsetPositionEff(pc)
                add.w   d6,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,sp                           ; Finish here without doing anything else
                cmpi.w  #4,(Events_routine_bg).w
                beq.w   loc_528DE
                bra.w   loc_52904
; ---------------------------------------------------------------------------

Obj_FBZOutdoorBGMotion:
                move.l  #$2800,d0                       ; Uses built-in bobbing motion function to move BG up and down
                move.l  #$80,d1
                jsr     (Gradual_SwingOffset).l
                move.w  d0,(Events_bg+$08).w
                rts
; ---------------------------------------------------------------------------
FBZ_InBGDeformArray:
                dc.w    $80
                dc.w    $40
                dc.w    $20
                dc.w    8
                dc.w    8
                dc.w    8
                dc.w    8
                dc.w    $28
                dc.w    $30
                dc.w    8
                dc.w    4
                dc.w    4
                dc.w    $B8
                dc.w    $30
                dc.w    $10
                dc.w    $10
                dc.w    $30
                dc.w    $28
                dc.w    $18
                dc.w    $10
                dc.w    $30
                dc.w    $30
                dc.w    $10
                dc.w    $10
                dc.w    $30
                dc.w    $28
                dc.w    $18
                dc.w    $10
                dc.w    $B0
                dc.w    $30
                dc.w    $28
                dc.w    $40
                dc.w    $18
                dc.w    $30
                dc.w    $7FFF
FBZ_OutBGDeformArray:
                dc.w    $30
                dc.w    $20
                dc.w    $30
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $10
                dc.w    $7FFF
FBZ_InBGDeformIndex:
                dc.b    1-1,  $C
                dc.b    2-1,  $A, $16
                dc.b    $B-1,   8, $14, $18, $1C, $20, $24, $28, $2C, $30, $34, $38
                dc.b    3-1,   6, $12, $3E
                dc.b    1-1, $46
                dc.b    8-1,   4, $10, $1E, $26, $2E, $36, $3A, $40
                dc.b    4-1,  $E, $22, $32, $3C
                dc.b    2-1,   0, $44
                dc.b    4-1,   2, $1A, $2A, $42
                dc.b    $FF
                even
FBZ_OutBGDeformIndex:
                dc.w    $E
                dc.w    2
                dc.w    $A
                dc.w    6
                dc.w    $C
                dc.w    4
                dc.w    8
                dc.w    0
                dc.w    $10
Pal_FBZBGIndoors:
                binclude "data/Levels/FBZ/Palettes/FBZ BG Indoors.bin"
                even
Pal_FBZBGOutdoors:
                binclude "data/Levels/FBZ/Palettes/FBZ BG Outdoors.bin"
                even
