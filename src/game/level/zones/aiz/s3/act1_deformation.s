; Owner: game/level/zones/aiz/s3
; Responsibility: Angel Island act-one intro and normal deformation, water effects and transition-floor control
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

AIZ1_IntroDeform:
                move.w  (Camera_Y_pos_copy).w,(Camera_Y_pos_BG_copy).w
                move.w  (Events_fg_1).w,d0
                bmi.s   loc_3AFE2
                move.w  (Camera_X_pos_copy).w,d0

loc_3AFE2:
                asr.w   #1,d0
                lea     (HScroll_table+$028).w,a1
                cmpi.w  #$580,d0
                blt.s   loc_3AFF8
                moveq   #$25-1,d1

loc_3AFF0:
                move.w  d0,(a1)+
                dbf     d1,loc_3AFF0
                bra.s   loc_3B018
; ---------------------------------------------------------------------------

loc_3AFF8:
                move.w  d0,(a1)+
                subi.w  #$580,d0
                swap    d0
                clr.w   d0
                move.l  d0,d1
                asr.l   #5,d1
                moveq   #$24-1,d2

loc_3B008:
                add.l   d1,d0
                move.l  d0,d3
                swap    d3
                addi.w  #$580,d3
                move.w  d3,(a1)+
                dbf     d2,loc_3B008

loc_3B018:
                lea     (HScroll_table+$028).w,a1
                lea     (HScroll_table).w,a5
                move.w  (a1)+,d0
                bpl.s   loc_3B026
                moveq   #0,d0

loc_3B026:
                move.w  d0,(a5)
                addq.w  #4,a5
                moveq   #9-1,d0

loc_3B02C:
                move.w  (a1),d1
                bpl.s   loc_3B032
                moveq   #0,d1

loc_3B032:
                move.w  d1,(a5)
                addq.w  #8,a1
                addq.w  #4,a5
                dbf     d0,loc_3B02C
                rts
; End of function AIZ1_IntroDeform

; =============== S U B R O U T I N E =======================================

AIZ1_Deform:
                move.w  (Camera_Y_pos_copy).w,d0
                asr.w   #1,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                subi.w  #$1300,d0
                swap    d0
                clr.w   d0
                asr.l   #5,d0
                move.l  d0,d2
                add.l   d0,d0
                move.l  d0,d1
                lsl.l   #3,d0
                sub.l   d1,d0
                lea     (HScroll_table+$030).w,a1
                swap    d0
                move.w  d0,(a1)
                swap    d0
                add.l   d1,d0
                swap    d0
                move.w  d0,-$2C(a1)
                move.w  d0,2(a1)
                move.w  d0,$A(a1)
                swap    d0
                add.l   d1,d0
                swap    d0
                move.w  d0,4(a1)
                move.w  d0,8(a1)
                swap    d0
                add.l   d1,d0
                swap    d0
                move.w  d0,6(a1)
                lea     (HScroll_table+$016).w,a1
                move.l  d2,d0
                swap    d0
                move.w  d0,-(a1)
                swap    d0
                move.l  (HScroll_table+$03C).w,d3
                addi.l  #$2000,(HScroll_table+$03C).w
                asr.l   #1,d0
                moveq   #5,d1

loc_3B0AE:
                add.l   d3,d0
                swap    d0
                move.w  d0,-(a1)
                swap    d0
                add.l   d2,d0
                dbf     d1,loc_3B0AE
                lea     (HScroll_table+$016).w,a1
                move.l  d2,d0
                asr.l   #3,d2
                moveq   #$C,d1

loc_3B0C6:
                add.l   d2,d0
                swap    d0
                move.w  d0,(a1)+
                swap    d0
                dbf     d1,loc_3B0C6
                rts
; End of function AIZ1_Deform

; ---------------------------------------------------------------------------

AIZ1_ApplyDeformWater:
                lea     AIZ1_DeformArray(pc),a4
                lea     (HScroll_table+$008).w,a5
                move.w  (Water_level).w,d1
                sub.w   (Camera_Y_pos_copy).w,d1
                cmpi.w  #$E0,d1
                blt.s   loc_3B0EE
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

loc_3B0EE:
                subq.w  #1,d1
                jsr     ApplyDeformation3(pc)
                move.l  a1,-(sp)
                lea     (HScroll_table+$040).w,a1
                lea     AIZ1_WaterFGDeformDelta(pc),a6
                move.w  (Water_level).w,d0
                subi.w  #$DE,d1
                neg.w   d1
                move.w  (Level_frame_counter).w,d2
                add.w   d0,d2
                add.w   d0,d2
                andi.w  #$7E,d2
                adda.w  d2,a6
                move.w  (Camera_X_pos_copy).w,d6
                neg.w   d6
                jsr     MakeFGDeformArray(pc)
                movea.l (sp)+,a1
                lea     (HScroll_table+$040).w,a2
                lea     AIZ1_DeformArray(pc),a4
                lea     (HScroll_table+$008).w,a5
                lea     AIZ1_WaterBGDeformDelta(pc),a6
                move.w  (Water_level).w,d0
                sub.w   (Camera_Y_pos_copy).w,d0
                add.w   (Camera_Y_pos_BG_copy).w,d0
                move.w  (Level_frame_counter).w,d2
                asr.w   #1,d2
                add.w   d0,d2
                add.w   d0,d2
                andi.w  #$7E,d2
                adda.w  d2,a6
                jmp     ApplyFGandBGDeformation(pc)

; =============== S U B R O U T I N E =======================================

AIZ1_FireRise:
                cmpi.b  #6,(Player_1+routine).w
                bcc.s   locret_3B178
                moveq   #0,d0
                move.w  (Events_bg+$02).w,d0
                addi.w  #$280,d0
                cmpi.w  #$A000,d0
                bcs.s   loc_3B16E
                move.w  #$A000,d0

loc_3B16E:
                move.w  d0,(Events_bg+$02).w
                lsl.l   #4,d0
                add.l   d0,(Camera_Y_pos_BG_copy).w

locret_3B178:
                rts
; End of function AIZ1_FireRise

; =============== S U B R O U T I N E =======================================

AIZTrans_WavyFlame:
                cmpi.b  #6,(Player_1+routine).w
                bcc.s   locret_3B1C4
                addq.w  #6,(_unkEE8E).w
                move.w  (_unkEE8E).w,d0
                andi.w  #$60,d0
                addi.w  #$1000,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                lea     (Vscroll_buffer).w,a1
                lea     AIZ_FlameVScroll(pc),a5
                move.w  (Camera_Y_pos_copy).w,d0
                swap    d0
                move.w  (Camera_Y_pos_BG_copy).w,d1
                move.w  (Level_frame_counter).w,d2
                asr.w   #2,d2
                moveq   #$14-1,d3

loc_3B1B0:
                addq.w  #2,d2
                andi.w  #$F,d2
                move.b  (a5,d2.w),d0
                ext.w   d0
                add.w   d1,d0
                move.l  d0,(a1)+
                dbf     d3,loc_3B1B0

locret_3B1C4:
                rts
; End of function AIZTrans_WavyFlame

; ---------------------------------------------------------------------------

Obj_AIZTransitionFloor:
                tst.b   (Current_act).w
                beq.s   loc_3B1D8
                move.w  #$7F00,x_pos(a0)
                move.l  #Delete_Current_Sprite,(a0)

loc_3B1D8:
                move.b  #$A0,width_pixels(a0)
                bset    #7,status(a0)
                move.w  #$A0+$B,d1
                moveq   #$10,d2
                moveq   #$10,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull2).l
; ---------------------------------------------------------------------------
AIZ1_IntroDrawArray:
                dc.w    $3E0,    $10,    $10,    $10,    $10,    $10,    $10,    $10,    $10, $7FFF
AIZ1_IntroDeformArray:
                dc.w    $3E0,     4,     4,     4,     4,     4,     4,     4,     4
                dc.w    4,     4,     4,     4,     4,     4,     4,     4,     4
                dc.w    4,     4,     4,     4,     4,     4,     4,     4,     4
                dc.w    4,     4,     4,     4,     4,     4,     4,     4,     4, $7FFF
AIZ1_BGDrawArray:
                dc.w    $220, $7FFF
AIZ1_DeformArray:
                dc.w    $D0,   $20,   $30,   $30,   $10,   $10,   $10, $800D,    $F,     6,    $E,   $50,   $20, $7FFF
AIZ_FlameVScroll:
                dc.b    0,  -1,  -2,  -5,  -8, -$A, -$D, -$E, -$F, -$E, -$D, -$A,  -7,  -5,  -2,  -1
                even
