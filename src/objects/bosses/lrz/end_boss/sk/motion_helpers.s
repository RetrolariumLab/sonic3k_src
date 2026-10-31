; Owner: objects/bosses/lrz/end_boss/sk
; Responsibility: Lava Reef end-boss motion, collision, palette, angle and parent-state helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

sub_79EB6:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_79EE6
                rts
; ---------------------------------------------------------------------------

loc_79EC4:
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                bne.w   locret_797F8
                lea     word_79F0C(pc),a2
                jsr     (Check_InTheirRange).l
                beq.w   locret_797F8
                bset    #6,status(a1)

loc_79EE6:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_79EFA
                move.b  #6,subtype(a1)

loc_79EFA:
                jsr     (Delete_Current_Sprite).l
                moveq   #signextendB(sfx_ThumpBoss),d0
                jsr     (Play_SFX).l
                addq.w  #4,sp
                rts
; End of function sub_79EB6

; ---------------------------------------------------------------------------
word_79F0C:
                dc.w    -$30,   $60,  -$30,   $60
; =============== S U B R O U T I N E =======================================

sub_79F14:
                move.w  (Events_bg+$0A).w,d0
                move.w  (_unkFA84).w,d1
                lsr.w   #2,d1
                add.w   d1,d0
                add.w   d0,d0
                tst.b   (_unkFAA2).w
                bne.s   loc_79F2A
                neg.w   d0

loc_79F2A:
                move.w  d0,x_vel(a0)
                rts
; End of function sub_79F14

; =============== S U B R O U T I N E =======================================

sub_79F30:
                move.w  x_pos(a0),d0
                subi.w  #$9E0,d0
                lsr.w   #1,d0
                lea     (HScroll_table+$100).w,a1
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                subi.w  #$30,d1
                neg.w   d1
                addi.w  #$612,d1
                add.w   angle(a0),d1
                move.w  d1,y_pos(a0)
                rts
; End of function sub_79F30

; =============== S U B R O U T I N E =======================================

sub_79F58:
                btst    #6,status(a0)
                beq.s   locret_79F98
                tst.b   $20(a0)
                bne.s   loc_79F7A
                subq.b  #1,collision_property(a0)
                beq.s   loc_79F9A
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_79F7A:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_79F88
                addi.w  #2*4,d0

loc_79F88:
                bsr.w   sub_79FD8
                subq.b  #1,$20(a0)
                bne.s   locret_79F98
                bclr    #6,status(a0)

locret_79F98:
                rts
; ---------------------------------------------------------------------------

loc_79F9A:
                move.l  #loc_79988,(a0)
                bset    #7,status(a0)
                clr.b   (_unkFAA3).w
                clr.w   (_unkFA84).w
                st      (Events_fg_5).w
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_79FC6
                move.b  #4,subtype(a1)

loc_79FC6:
                clr.b   (Events_bg+$09).w
                jsr     (BossDefeated_StopTimer).l
                move.w  #$7F,$2E(a0)
                rts
; End of function sub_79F58

; =============== S U B R O U T I N E =======================================

sub_79FD8:
                lea     word_79FE6(pc),a1
                lea     word_79FEE(pc,d0.w),a2
                jmp     (CopyWordData_4).l
; End of function sub_79FD8

; ---------------------------------------------------------------------------
word_79FE6:
                dc.w    Normal_palette_line_2+$08, Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
word_79FEE:
                dc.w    $406,  $646,  $424,     0
                dc.w    $EEE,  $EEE,  $EEE,  $EEE

; =============== S U B R O U T I N E =======================================

sub_79FFE:
                movea.w (_unkFAA4).w,a1
                tst.w   (a1)
                beq.w   locret_797F8
                lea     word_7A038(pc),a2
                jsr     (Check_InTheirRange).l
                beq.w   locret_797F8
                lea     ChildObjDat_7A1BC(pc),a2
                jsr     (CreateChild6_Simple).l
                jsr     (Go_Delete_Sprite).l
                jsr     (Displace_PlayerOffObject).l
                moveq   #signextendB(sfx_Clank),d0
                jsr     (Play_SFX).l
                addq.w  #4,sp
                rts
; End of function sub_79FFE

; ---------------------------------------------------------------------------
word_7A038:
                dc.w    -$40,   $80,  -$40,   $80

; =============== S U B R O U T I N E =======================================

sub_7A040:
                move.w  x_pos(a0),d0
                sub.w   (Camera_X_pos).w,d0
                cmpi.w  #$140,d0
                bhs.s   loc_7A060
                move.w  y_pos(a0),d0
                sub.w   (Camera_Y_pos).w,d0
                cmpi.w  #$E0,d0
                bhs.s   loc_7A060
                moveq   #1,d0
                rts
; ---------------------------------------------------------------------------

loc_7A060:
                moveq   #0,d0
                rts
; End of function sub_7A040

; =============== S U B R O U T I N E =======================================

sub_7A064:
                move.w  x_pos(a0),-(sp)
                jsr     (MoveSprite2).l
                moveq   #$23,d1
                moveq   #$10,d2
                moveq   #$D,d3
                move.w  (sp)+,d4
                jmp     (SolidObjectTop).l
; End of function sub_7A064

; =============== S U B R O U T I N E =======================================

sub_7A07C:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d0
                move.b  RawAni_7A0BA(pc,d0.w),mapping_frame(a0)
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                lea     byte_7A0C4(pc,d1.w),a2
                move.b  (a2)+,d0
                ext.w   d0
                add.w   d0,d2
                move.b  (a2)+,d0
                ext.w   d0
                add.w   d0,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                add.w   d1,d1
                move.l  word_7A0D8(pc,d1.w),x_vel(a0)   ; and y_vel
                rts
; End of function sub_7A07C

; ---------------------------------------------------------------------------
RawAni_7A0BA:
                dc.b    1,   1,   1,   1,   1,   3,   2,   3,   2,   3
                even
byte_7A0C4:
                dc.b    -$10,  -8
                dc.b    0,  -8
                dc.b    $10,  -8
                dc.b    -8,   8
                dc.b    8,   8
                dc.b    -$C,  -4
                dc.b    $C,  -4
                dc.b    -$14,   8
                dc.b    $14,   8
                dc.b    0,  $C
word_7A0D8:
                dc.w    -$280, -$300
                dc.w    $80, -$380
                dc.w    $280, -$300
                dc.w    -$200, -$280
                dc.w    $200, -$280
                dc.w    -$300, -$300
                dc.w    $300, -$280
                dc.w    -$300, -$380
                dc.w    $300, -$380
                dc.w    -$80, -$400
; ---------------------------------------------------------------------------

loc_7A100:
                tst.b   (_unkFACD).w
                beq.w   locret_797F8
                move.l  #loc_7A12A,(a0)
                lea     word_78EAA(pc),a1
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                move.l  #loc_7A138,(Palette_rotation_custom).w
                move.w  #$7FFF,(Palette_cycle_counter1).w

loc_7A12A:
                jsr     (Run_PalRotationScript).l

loc_7A130:
                move.w  #$7FFF,(Palette_cycle_counter1).w
                rts
; ---------------------------------------------------------------------------

loc_7A138:
                move.l  #loc_7A130,(a0)
                rts
