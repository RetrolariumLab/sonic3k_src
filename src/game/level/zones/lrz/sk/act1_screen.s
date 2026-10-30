; Owner: game/level/zones/lrz/sk
; Responsibility: Lava Reef act-one screen and background events, deformation and coordinated scene actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

LRZ1_ScreenInit:
                jsr     (Reset_TileOffsetPositionActual).l
                jmp     (Refresh_PlaneFull).l
; ---------------------------------------------------------------------------

LRZ1_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                move.w  (Events_bg+$0C).w,d0
                beq.s   loc_56B5E
                bmi.s   loc_56B2C
                movea.w $40(a3),a1
                move.b  #$9C,$A(a1)
                bra.s   loc_56B54
; ---------------------------------------------------------------------------

loc_56B2C:
                movea.w $38(a3),a1
                lea     $1D(a1),a1
                move.b  #$44,(a1)+
                move.b  #0,(a1)+
                move.b  #$4A,(a1)
                movea.w $3C(a3),a1
                lea     $1D(a1),a1
                move.b  #$3E,(a1)+
                move.b  #0,(a1)+
                move.b  #$4B,(a1)

loc_56B54:
                clr.w   (Events_bg+$0C).w
                jmp     (Refresh_PlaneScreenDirect).l
; ---------------------------------------------------------------------------

loc_56B5E:
                jmp     (DrawTilesAsYouMove).l
; ---------------------------------------------------------------------------

LRZ1_BackgroundInit:
                move.w  (a3),d0
                move.w  #$1C,d1
                moveq   #$19-1,d2

loc_56B6C:
                move.w  d0,(a3,d1.w)
                addq.w  #4,d1
                dbf     d2,loc_56B6C
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_56B88
                movea.w 4(a3),a1
                move.b  #-$A,4(a1)

loc_56B88:
                jsr     LRZ1_Deform(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                clr.l   (HScroll_table).w
                move.w  d2,(HScroll_table+$006).w
                clr.l   (HScroll_table+$008).w
                lea     LRZ1_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                jsr     (Refresh_PlaneTileDeform).l
                lea     LRZ1_BGDeformArray(pc),a4
                lea     (HScroll_table+$00C).w,a5
                jmp     (ApplyDeformation).l
; ---------------------------------------------------------------------------

LRZ1_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     LRZ1_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

LRZ1_BackgroundEvent_Index:
                bra.w   loc_56BD2
; ---------------------------------------------------------------------------
                bra.w   loc_56C6E
; ---------------------------------------------------------------------------
                bra.w   loc_56C88
; ---------------------------------------------------------------------------
                bra.w   loc_56CAA
; ---------------------------------------------------------------------------

loc_56BD2:
                tst.w   (Events_fg_5).w
                beq.s   loc_56C28
                clr.w   (Events_fg_5).w
                movem.l d7-a0/a2-a3,-(sp)
                lea     (LRZ2_128x128_Secondary_Kos).l,a1
                lea     (Chunk_table+$180).l,a2
                jsr     (Queue_Kos).l
                lea     (LRZ2_16x16_Secondary_Kos).l,a1
                lea     (Block_table+$128).w,a2
                jsr     (Queue_Kos).l
                lea     (ArtKosM_LRZ2_Secondary).l,a1
                move.w  #tiles_to_bytes($090),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_30,d0
                jsr     (Load_PLC).l
                movem.l (sp)+,d7-a0/a2-a3
                move.w  #$C,(Events_routine_bg).w
                bra.w   loc_56D16
; ---------------------------------------------------------------------------

loc_56C28:
                jsr     sub_56DCA(pc)
                jsr     LRZ1_Deform(pc)

loc_56C30:
                lea     LRZ1_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                moveq   #$20,d6
                moveq   #3,d5
                jsr     (Draw_BG).l
                move.l  (Events_bg+$02).w,d0
                beq.s   loc_56C5A
                move.w  d0,(Camera_Y_pos_BG_copy).w
                swap    d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                jsr     (PlainDeformation).l
                bra.s   loc_56C68
; ---------------------------------------------------------------------------

loc_56C5A:
                lea     LRZ1_BGDeformArray(pc),a4
                lea     (HScroll_table+$00C).w,a5
                jsr     (ApplyDeformation).l

loc_56C68:
                jmp     (ShakeScreen_Setup).l
; ---------------------------------------------------------------------------

loc_56C6E:
                jsr     sub_56DCA(pc)
                jsr     sub_56DAC(pc)

loc_56C76:
                jsr     (DrawBGAsYouMove).l
                jsr     (PlainDeformation).l
                jmp     (ShakeScreen_Setup).l
; ---------------------------------------------------------------------------

loc_56C88:
                jsr     LRZ1_Deform(pc)

loc_56C8C:
                lea     LRZ1_BGDrawArray(pc),a4
                lea     (HScroll_table-$04).w,a5
                move.w  (Camera_Y_pos_BG_copy).w,d1
                jsr     (Draw_PlaneVertBottomUpComplex).l
                bpl.s   loc_56C30
                clr.l   (Events_bg+$02).w
                clr.w   (Events_routine_bg).w
                bra.s   loc_56C30
; ---------------------------------------------------------------------------

loc_56CAA:
                tst.b   (Kos_modules_left).w
                bne.s   loc_56D16
                move.w  #$901,(Current_zone_and_act).w
                clr.b   (Dynamic_resize_routine).w
                clr.b   (Object_load_routine).w
                clr.b   (Rings_manager_routine).w
                clr.b   (Boss_flag).w
                clr.b   (Respawn_table_keep).w
                jsr     (Clear_Switches).l
                clr.b   (LRZ_rocks_routine).w
                movem.l d7-a0/a2-a3,-(sp)
                jsr     (Load_Level).l
                jsr     (LoadSolids).l
                movem.l (sp)+,d7-a0/a2-a3
                move.w  #$2C00,d0
                moveq   #0,d1
                sub.w   d0,(Player_1+x_pos).w
                sub.w   d0,(Player_2+x_pos).w
                jsr     (Offset_ObjectsDuringTransition).l
                sub.w   d0,(Camera_X_pos).w
                sub.w   d0,(Camera_X_pos_copy).w
                sub.w   d0,(Camera_min_X_pos).w
                sub.w   d0,(Camera_max_X_pos).w
                jsr     (Reset_TileOffsetPositionActual).l
                clr.w   (Events_routine_bg).w

loc_56D16:
                jsr     LRZ1_Deform(pc)
                lea     LRZ1_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                moveq   #$20,d6
                moveq   #3,d5
                jsr     (Draw_BG).l
                lea     LRZ1_BGDeformArray(pc),a4
                lea     (HScroll_table+$00C).w,a5
                jsr     (ApplyDeformation).l
                jmp     (ShakeScreen_Setup).l

; =============== S U B R O U T I N E =======================================

LRZ1_Deform:
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  (Screen_shake_offset).w,d1
                sub.w   d1,d0
                asr.w   #3,d0
                add.w   d1,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                asr.l   #3,d0
                move.l  d0,d1
                move.l  d0,d2
                asr.l   #2,d0
                swap    d1
                move.w  d1,(Camera_X_pos_BG_copy).w
                move.w  d1,(HScroll_table+$004).w
                swap    d1
                sub.l   d0,d1
                swap    d1
                move.w  d1,(Events_bg+$10).w
                swap    d1
                sub.l   d0,d1
                swap    d1
                move.w  d1,(Events_bg+$12).w
                lea     (HScroll_table+$01C).w,a1
                move.l  d2,d1
                moveq   #8-1,d3

loc_56D88:
                swap    d1
                move.w  d1,-(a1)
                swap    d1
                add.l   d0,d1
                dbf     d3,loc_56D88
                lea     (HScroll_table+$01C).w,a1
                add.l   d0,d2
                add.l   d0,d0
                moveq   #5-1,d3

loc_56D9E:
                swap    d2
                move.w  d2,(a1)+
                swap    d2
                add.l   d0,d2
                dbf     d3,loc_56D9E
                rts
; End of function LRZ1_Deform

; =============== S U B R O U T I N E =======================================

sub_56DAC:
                move.w  (Camera_Y_pos_copy).w,d0
                subi.w  #$788,d0
                add.w   (_unkEE9C).w,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                subi.w  #$1500,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                rts
; End of function sub_56DAC

; =============== S U B R O U T I N E =======================================

sub_56DCA:
                lea     word_56F88(pc),a1
                move.w  (Player_1+x_pos).w,d0
                move.w  (Player_1+y_pos).w,d1
                moveq   #0,d2
                move.w  #3-1,d3

loc_56DDC:
                lea     (a1),a5
                cmp.w   (a5)+,d0
                blo.s   loc_56DEE
                cmp.w   (a5)+,d0
                bhi.s   loc_56DEE
                cmp.w   (a5)+,d1
                blo.s   loc_56DEE
                cmp.w   (a5)+,d1
                blo.s   loc_56DFA

loc_56DEE:
                adda.w  #$A,a1
                addq.w  #4,d2
                dbf     d3,loc_56DDC
                rts
; ---------------------------------------------------------------------------

loc_56DFA:
                jmp     loc_56DFE(pc,d2.w)
; End of function sub_56DCA

; ---------------------------------------------------------------------------

loc_56DFE:
                bra.w   loc_56E0A
; ---------------------------------------------------------------------------
                bra.w   loc_56E1C
; ---------------------------------------------------------------------------
                bra.w   loc_56E2E
; ---------------------------------------------------------------------------

loc_56E0A:
                tst.w   (Events_bg+$00).w
                bne.s   loc_56E16
                cmp.w   (a5),d0
                bhs.s   loc_56E40
                rts
; ---------------------------------------------------------------------------

loc_56E16:
                cmp.w   (a5),d0
                blo.s   loc_56E66
                rts
; ---------------------------------------------------------------------------

loc_56E1C:
                tst.w   (Events_bg+$00).w
                bne.s   loc_56E28
                cmp.w   (a5),d0
                blo.s   loc_56E40
                rts
; ---------------------------------------------------------------------------

loc_56E28:
                cmp.w   (a5),d0
                bhs.s   loc_56E66
                rts
; ---------------------------------------------------------------------------

loc_56E2E:
                tst.w   (Events_bg+$00).w
                bne.s   loc_56E3A
                cmp.w   (a5),d1
                bhs.s   loc_56E40
                rts
; ---------------------------------------------------------------------------

loc_56E3A:
                cmp.w   (a5),d1
                blo.s   loc_56E66
                rts
; ---------------------------------------------------------------------------

loc_56E40:
                st      (Events_bg+$00).w
                jsr     (AllocateObject).l
                bne.s   loc_56E52
                move.l  #Obj_56EA0,(a1)

loc_56E52:
                jsr     sub_56DAC(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                addq.w  #4,(Events_routine_bg).w
                addq.w  #4,sp
                jmp     loc_56C76(pc)
; ---------------------------------------------------------------------------

loc_56E66:
                clr.w   (Events_bg+$00).w
                move.w  (Camera_X_pos_BG_copy).w,(Events_bg+$02).w
                move.w  (Camera_Y_pos_BG_copy).w,(Events_bg+$04).w
                jsr     LRZ1_Deform(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                move.w  d2,(HScroll_table+$006).w
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                addq.w  #4,sp
                jmp     loc_56C8C(pc)
; ---------------------------------------------------------------------------

Obj_56EA0:
                move.l  #loc_56EC2,(a0)
                move.b  #$80,height_pixels(a0)
                move.w  #$1E80,x_pos(a0)
                bset    #7,status(a0)
                move.w  #-$4000,$34(a0)
                clr.w   (_unkEE9C).w

loc_56EC2:
                tst.w   (Events_bg+$00).w
                bne.s   loc_56ECE
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_56ECE:
                move.l  $2E(a0),d0
                move.l  $32(a0),d1
                move.l  #-$100,d2
                tst.b   $36(a0)
                beq.s   loc_56EF6
                neg.l   d2
                add.l   d1,d0
                bmi.s   loc_56F0A
                moveq   #0,d0
                move.l  #$C000,d1
                clr.b   $36(a0)
                bra.s   loc_56F0C
; ---------------------------------------------------------------------------

loc_56EF6:
                add.l   d1,d0
                beq.s   loc_56EFC
                bpl.s   loc_56F0A

loc_56EFC:
                moveq   #0,d0
                move.l  #-$C000,d1
                st      $36(a0)
                bra.s   loc_56F0C
; ---------------------------------------------------------------------------

loc_56F0A:
                add.l   d2,d1

loc_56F0C:
                move.l  d1,$32(a0)
                move.l  d0,$2E(a0)
                swap    d0
                move.w  d0,(_unkEE9C).w
                neg.w   d0
                addi.w  #$988,d0
                move.w  d0,y_pos(a0)
                move.w  #$280,d1
                move.w  #$80,d2
                move.w  #$6C,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                btst    #p1_standing_bit,status(a0)
                beq.s   loc_56F54
                lea     (Player_1).w,a1
                btst    #Status_FireShield,status_secondary(a1)
                bne.s   loc_56F54
                jsr     (sub_24280).l

loc_56F54:
                btst    #p2_standing_bit,status(a0)
                beq.s   locret_56F66
                lea     (Player_2).w,a1
                jsr     (sub_24280).l

locret_56F66:
                rts
; ---------------------------------------------------------------------------
LRZ1_BGDrawArray:
                dc.w    $B0,  $100, $7FFF
LRZ1_BGDeformArray:
                dc.w    $40,   $20,   $10,   $10,   $10,   $10,   $10,  $100,   $10,   $10,   $10,   $20, $7FFF
word_56F88:
                dc.w    $1AC0, $1B40,  $840,  $8C0
                dc.w    $1B00, $2240, $2340,  $840
                dc.w    $880, $22C0, $20C0, $2180
                dc.w    $740,  $800,  $7A0
