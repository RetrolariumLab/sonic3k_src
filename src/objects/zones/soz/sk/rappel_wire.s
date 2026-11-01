; Owner: objects/zones/soz/sk
; Responsibility: Sandopolis rappel wire geometry, player attachment, constrained travel, character motion and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZRapelWire:
                movea.l a0,a1
                move.l  #loc_4AA80,(a1)
                bsr.w   InitializeSozRappelWirePieceDisplay
                move.b  #$20,mapping_frame(a1)
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                move.w  d2,$3E(a0)
                move.w  d3,$40(a0)
                move.b  subtype(a0),d1
                andi.b  #$F,d1
                move.b  d1,$36(a0)
                move.w  #$30,$32(a0)
                moveq   #$F,d1
                addq.w  #1,d1
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_4AA44
                move.w  a1,$44(a0)
                move.l  #loc_4AD7A,(a1)
                move.w  a0,parent(a1)
                bra.s   loc_4AA16
; ---------------------------------------------------------------------------

loc_4A9FA:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_4AA44
                move.l  #loc_4AE50,(a1)
                move.w  a2,parent(a1)
                move.w  a1,$44(a2)
                move.w  a0,parent3(a1)

loc_4AA16:
                movea.l a1,a2
                bsr.s   InitializeSozRappelWirePieceDisplay
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                addi.w  #$10,d3
                addq.w  #1,$34(a0)
                move.w  $34(a0),$34(a1)
                dbf     d1,loc_4A9FA
                move.l  #loc_4AF0A,(a1)
                move.b  #$21,mapping_frame(a1)
                move.w  a1,parent3(a0)

loc_4AA44:
                bra.s   loc_4AA80

; =============== S U B R O U T I N E =======================================

InitializeSozRappelWirePieceDisplay:
                move.b  #4,render_flags(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.w  #$280,priority(a1)
                move.l  #Map_SOZRapelWire,mappings(a1)
                move.w  #make_art_tile(ArtTile_SOZMisc+$48,2,0),art_tile(a1)
                move.b  status(a0),status(a1)
                move.w  x_pos(a0),$3E(a1)
                move.w  y_pos(a0),$40(a1)
                rts
; End of function InitializeSozRappelWirePieceDisplay

; ---------------------------------------------------------------------------

loc_4AA80:
                movea.w parent3(a0),a1
                tst.b   $38(a1)
                beq.s   loc_4AA90
                move.l  #loc_4AA94,(a0)

loc_4AA90:
                bra.w   loc_4AD32
; ---------------------------------------------------------------------------

loc_4AA94:
                movea.w parent3(a0),a1
                tst.b   $38(a1)
                bne.s   loc_4AAA4
                move.l  #loc_4ACC6,(a0)

loc_4AAA4:
                addq.w  #2,$32(a0)
                cmpi.w  #$C0,$32(a0)
                bne.s   loc_4AAC4
                moveq   #signextendB(sfx_GlideLand),d0
                jsr     (Play_SFX).l
                move.l  #loc_4AAC8,(a0)
                move.w  #1,$2E(a0)

loc_4AAC4:
                bra.w   loc_4AD32
; ---------------------------------------------------------------------------

loc_4AAC8:
                movea.w parent3(a0),a1
                tst.b   $38(a1)
                bne.s   loc_4AAD8
                move.l  #loc_4ACC6,(a0)

loc_4AAD8:
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_4AB6A
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                move.b  subtype(a0),d1
                andi.w  #$F0,d1
                bne.s   loc_4AB16
                move.l  #loc_4AB6E,(a0)
                move.w  #$3F,$30(a0)
                move.b  #0,angle(a0)
                subq.b  #1,$36(a0)
                bne.s   loc_4AB6A
                move.l  #loc_4AB9E,(a0)
                bra.s   loc_4AB6A
; ---------------------------------------------------------------------------

loc_4AB16:
                lsl.w   #1,d1
                subi.w  #6,d1
                subq.w  #1,d1
                move.w  d1,$30(a0)
                move.l  #loc_4ABD8,(a0)
                move.b  #$80,angle(a0)
                move.b  #$80,$37(a0)
                move.w  #$400,x_vel(a0)
                btst    #0,status(a0)
                bne.s   loc_4AB4C
                neg.w   x_vel(a0)
                move.b  #0,$37(a0)

loc_4AB4C:
                bchg    #0,status(a0)
                move.w  #3,$2E(a0)
                move.w  #6,$3C(a0)
                subq.b  #1,$36(a0)
                bne.s   loc_4AB6A
                move.l  #loc_4AC3A,(a0)

loc_4AB6A:
                bra.w   loc_4AD32
; ---------------------------------------------------------------------------

loc_4AB6E:
                movea.w parent3(a0),a1
                tst.b   $38(a1)
                bne.s   loc_4AB7E
                move.l  #loc_4ACC6,(a0)

loc_4AB7E:
                addq.b  #2,angle(a0)
                addq.w  #2,$32(a0)
                subq.w  #1,$30(a0)
                bpl.s   loc_4AB9A
                moveq   #signextendB(sfx_GlideLand),d0
                jsr     (Play_SFX).l
                move.l  #loc_4AAC8,(a0)

loc_4AB9A:
                bra.w   loc_4AD32
; ---------------------------------------------------------------------------

loc_4AB9E:
                move.w  #2,$2E(a0)
                move.l  #loc_4ABAA,(a0)

loc_4ABAA:
                movea.w parent3(a0),a1
                tst.b   $38(a1)
                bne.s   loc_4ABBA
                move.l  #loc_4ACC6,(a0)

loc_4ABBA:
                addq.b  #2,angle(a0)
                addq.w  #2,$32(a0)
                subq.w  #1,$30(a0)
                bpl.s   loc_4ABD4
                move.b  angle(a0),$27(a0)
                move.l  #loc_4AC98,(a0)

loc_4ABD4:
                bra.w   loc_4AD32
; ---------------------------------------------------------------------------

loc_4ABD8:
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                tst.b   $38(a1)
                bne.s   loc_4ABEE
                move.l  #loc_4ACC6,(a0)

loc_4ABEE:
                cmpi.w  #$1A,$30(a0)
                blo.s   loc_4AC02
                bne.s   loc_4ABFE
                move.w  #1,$2E(a0)

loc_4ABFE:
                addq.b  #4,$37(a0)

loc_4AC02:
                addq.b  #2,angle(a0)
                addq.w  #1,$32(a0)
                subq.w  #1,$30(a0)
                bpl.s   loc_4AC24
                move.w  #0,x_vel(a0)
                moveq   #signextendB(sfx_GlideLand),d0
                jsr     (Play_SFX).l
                move.l  #loc_4AAC8,(a0)

loc_4AC24:
                tst.w   $3C(a0)
                beq.s   loc_4AC36
                subq.w  #1,$3C(a0)
                addq.w  #1,$32(a0)
                addq.b  #2,angle(a0)

loc_4AC36:
                bra.w   loc_4AD32
; ---------------------------------------------------------------------------

loc_4AC3A:
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                tst.b   $38(a1)
                bne.s   loc_4AC50
                move.l  #loc_4ACC6,(a0)

loc_4AC50:
                cmpi.w  #$1A,$30(a0)
                blo.s   loc_4AC5C
                addq.b  #4,$37(a0)

loc_4AC5C:
                addq.b  #2,angle(a0)
                addq.w  #1,$32(a0)
                subq.w  #1,$30(a0)
                bpl.s   loc_4AC82
                move.w  #0,x_vel(a0)
                move.w  #2,$2E(a0)
                move.b  angle(a0),$27(a0)
                move.l  #loc_4AC98,(a0)

loc_4AC82:
                tst.w   $3C(a0)
                beq.s   loc_4AC94
                subq.w  #1,$3C(a0)
                addq.w  #1,$32(a0)
                addq.b  #2,angle(a0)

loc_4AC94:
                bra.w   loc_4AD32
; ---------------------------------------------------------------------------

loc_4AC98:
                movea.w $46(a0),a1
                tst.b   $38(a1)
                bne.s   loc_4ACA8
                move.l  #loc_4ACC6,(a0)

loc_4ACA8:
                addq.b  #2,$27(a0)
                cmpi.b  #-4,$27(a0)
                bhs.s   loc_4ACBC
                cmpi.b  #-$7A,$27(a0)
                bhs.s   loc_4ACC2

loc_4ACBC:
                move.b  $27(a0),angle(a0)

loc_4ACC2:
                bra.w   loc_4AD32
; ---------------------------------------------------------------------------

loc_4ACC6:
                tst.b   angle(a0)
                beq.s   loc_4AD02
                cmpi.b  #-$7A,$27(a0)
                bhs.s   loc_4ACF6
                addq.b  #2,angle(a0)
                cmpi.b  #$80,angle(a0)
                blo.s   loc_4ACEE
                cmpi.b  #-4,angle(a0)
                bhs.s   loc_4ACEE
                move.b  #0,angle(a0)

loc_4ACEE:
                move.b  #0,$27(a0)
                bra.s   loc_4AD02
; ---------------------------------------------------------------------------

loc_4ACF6:
                move.b  #-4,angle(a0)
                addq.b  #2,$27(a0)
                bmi.s   loc_4AD32

loc_4AD02:
                subq.w  #4,$32(a0)
                cmpi.w  #$30,$32(a0)
                bhi.s   loc_4AD32
                move.w  #$30,$32(a0)
                move.w  #0,$2E(a0)
                move.b  subtype(a0),d1
                andi.b  #$F,d1
                move.b  d1,$36(a0)
                move.l  #loc_4AA80,(a0)
                move.w  $3E(a0),d0
                bra.s   loc_4AD36
; ---------------------------------------------------------------------------

loc_4AD32:
                move.w  x_pos(a0),d0

loc_4AD36:
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_4AD4C
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4AD4C:
                move.w  $34(a0),d2
                subq.w  #1,d2
                bcs.s   loc_4AD68
                movea.w $44(a0),a2

loc_4AD58:
                movea.l a2,a1
                movea.w $44(a1),a2
                jsr     (Delete_Referenced_Sprite).l
                dbf     d2,loc_4AD58

loc_4AD68:
                move.w  respawn_addr(a0),d0
                beq.s   loc_4AD74
                movea.w d0,a2
                bclr    #7,(a2)

loc_4AD74:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_4AD7A:
                movea.w parent(a0),a1
                move.w  angle(a1),angle(a0)
                move.w  $32(a1),$32(a0)
                move.b  angle(a0),d0
                btst    #0,status(a1)
                bne.s   loc_4AD9A
                addi.b  #$80,d0

loc_4AD9A:
                jsr     (GetSineCosineQ14).l
                muls.w  #$20,d0
                move.w  $32(a0),d2
                divs.w  d2,d0
                move.w  d0,x_vel(a0)
                move.w  d0,d1
                asr.w   #4,d1
                jsr     (GetArcTan).l
                jsr     (GetSineCosineQ14).l
                asr.w   #2,d0
                move.w  d0,y_vel(a0)
                moveq   #0,d0
                moveq   #0,d1
                move.w  d2,d4
                move.w  d2,d5
                neg.w   d5
                andi.w  #$F,d5
                move.w  x_vel(a0),d2
                ext.l   d2
                lsl.l   #4,d2
                move.w  y_vel(a0),d3
                ext.l   d3
                lsl.l   #4,d3
                subq.w  #1,d5
                bcs.s   loc_4ADF2
                addi.w  #$10,d4

loc_4ADEA:
                sub.l   d2,d0
                sub.l   d3,d1
                dbf     d5,loc_4ADEA

loc_4ADF2:
                lsl.l   #4,d2
                lsl.l   #4,d3
                lsr.w   #4,d4
                subi.w  #$10,d4
                bcc.s   loc_4AE04
                neg.w   d4
                neg.l   d2
                neg.l   d3

loc_4AE04:
                subq.w  #1,d4
                bcs.s   loc_4AE10

loc_4AE08:
                add.l   d2,d0
                add.l   d3,d1
                dbf     d4,loc_4AE08

loc_4AE10:
                add.l   x_pos(a1),d0
                move.l  d0,x_pos(a0)
                add.l   y_pos(a1),d1
                move.l  d1,y_pos(a0)
                move.w  x_vel(a0),d1
                move.w  y_vel(a0),d2
                jsr     (GetArcTan).l
                addi.b  #-$40,d0
                addq.b  #4,d0
                lsr.b   #3,d0
                move.b  d0,mapping_frame(a0)
                move.w  y_pos(a0),d0
                addi.w  #$10,d0
                cmp.w   $40(a0),d0
                ble.s   locret_4AE4E
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_4AE4E:
                rts
; ---------------------------------------------------------------------------

loc_4AE50:
                movea.w parent(a0),a1
                move.b  mapping_frame(a1),mapping_frame(a0)
                bsr.w   PositionSozRappelPieceFromPreviousLink
                cmpi.w  #$D,$34(a0)
                bne.s   loc_4AE7C
                movea.w parent3(a0),a2
                cmpi.w  #2,$2E(a2)
                bne.s   loc_4AE7C
                cmpi.b  #-$7A,$27(a2)
                blo.s   loc_4AE7C
                bsr.s   BendSozRappelWireSegmentDirection

loc_4AE7C:
                move.w  y_pos(a0),d0
                addi.w  #$10,d0
                cmp.w   $40(a0),d0
                ble.s   locret_4AE90
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_4AE90:
                rts

; =============== S U B R O U T I N E =======================================

BendSozRappelWireSegmentDirection:
                move.b  $27(a2),d0
                btst    #0,status(a2)
                beq.s   loc_4AEA2
                addi.b  #$80,d0

loc_4AEA2:
                jsr     (GetSineCosine).l
                muls.w  #$3C,d0
                asr.w   #8,d0
                addi.w  #$40,d0
                jsr     (GetSineCosineQ14).l
                asr.w   #2,d1
                move.w  d1,x_vel(a0)
                asr.w   #2,d0
                move.w  d0,y_vel(a0)
                move.w  x_vel(a0),d1
                move.w  y_vel(a0),d2
                jsr     (GetArcTan).l
                addi.b  #-$40,d0
                addq.b  #4,d0
                lsr.b   #3,d0
                move.b  d0,mapping_frame(a0)
                rts
; End of function BendSozRappelWireSegmentDirection

; =============== S U B R O U T I N E =======================================

PositionSozRappelPieceFromPreviousLink:
                move.w  x_vel(a1),d0
                move.w  d0,x_vel(a0)
                ext.l   d0
                lsl.l   #8,d0
                add.l   x_pos(a1),d0
                move.l  d0,x_pos(a0)
                move.w  y_vel(a1),d1
                move.w  d1,y_vel(a0)
                ext.l   d1
                lsl.l   #8,d1
                add.l   y_pos(a1),d1
                move.l  d1,y_pos(a0)
                rts
; End of function PositionSozRappelPieceFromPreviousLink

; ---------------------------------------------------------------------------

loc_4AF0A:
                move.w  x_pos(a0),d4
                move.w  y_pos(a0),d5
                movea.w parent(a0),a1
                bsr.w   PositionSozRappelPieceFromPreviousLink
                cmp.w   x_pos(a0),d4
                beq.s   loc_4AF24
                move.w  d4,$3E(a0)

loc_4AF24:
                cmp.w   y_pos(a0),d5
                beq.s   loc_4AF2E
                move.w  d5,$40(a0)

loc_4AF2E:
                movea.w parent3(a0),a3
                lea     $38(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d0
                bsr.s   UpdateSozRappelEndpointPlayerAttachment
                lea     (Player_2).w,a1
                addq.w  #1,a2
                move.w  (Ctrl_2_logical).w,d0
                bsr.s   UpdateSozRappelEndpointPlayerAttachment
                move.b  #$21,mapping_frame(a0)
                cmpi.w  #3,$2E(a3)
                bne.s   loc_4AF6A
                moveq   #0,d0
                move.b  $37(a3),d0
                addq.b  #4,d0
                lsr.w   #4,d0
                move.b  RawAni_4AF70(pc,d0.w),mapping_frame(a0)

loc_4AF6A:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
RawAni_4AF70:
                dc.b    $24, $25, $26, $26, $21, $22, $22, $23, $24, $25, $26, $26, $21, $22, $22, $23
                even

; =============== S U B R O U T I N E =======================================

UpdateSozRappelEndpointPlayerAttachment:
                tst.b   (a2)
                beq.w   loc_4B130
                bmi.w   loc_4B02A
                tst.b   render_flags(a1)
                bpl.w   loc_4B03C
                cmpi.b  #4,routine(a1)
                bhs.w   loc_4B03C
                tst.w   (Debug_placement_mode).w
                bne.w   loc_4B03C
                cmpi.w  #2,$2E(a3)
                bne.w   loc_4B04A
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_4B04A
                clr.b   object_control(a1)
                clr.b   (a2)
                move.w  x_pos(a0),d1
                sub.w   $3E(a0),d1
                asl.w   #8,d1
                move.w  d1,x_vel(a1)
                move.w  y_pos(a0),d1
                sub.w   $40(a0),d1
                asl.w   #8,d1
                move.w  d1,y_vel(a1)
                move.b  #60,2(a2)
                btst    #button_left+8,d0
                beq.s   loc_4AFEA
                move.w  #-$200,x_vel(a1)

loc_4AFEA:
                btst    #button_right+8,d0
                beq.s   loc_4AFF6
                move.w  #$200,x_vel(a1)

loc_4AFF6:
                addi.w  #-$380,y_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_4B02A:
                move.w  #$300,x_vel(a1)
                move.w  #$200,y_vel(a1)
                bset    #Status_InAir,status(a1)

loc_4B03C:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #60,2(a2)
                rts
; ---------------------------------------------------------------------------

loc_4B04A:
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$14,y_pos(a1)
                move.w  $2E(a3),d0
                bne.s   loc_4B070
                move.b  #$14,anim(a1)
                move.b  #$92,mapping_frame(a1)
                bra.s   loc_4B08E
; ---------------------------------------------------------------------------

loc_4B070:
                cmpi.w  #1,d0
                bne.s   loc_4B0B0
                move.b  #$14,anim(a1)
                moveq   #0,d0
                move.b  angle(a3),d0
                add.b   d0,d0
                addq.b  #8,d0
                lsr.w   #4,d0
                move.b  RawAni_4B0A0(pc,d0.w),mapping_frame(a1)

loc_4B08E:
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------
RawAni_4B0A0:
                dc.b    $93, $92, $92, $92, $91, $91, $90, $90, $90, $90, $90, $91, $91, $92, $92, $92
                even
; ---------------------------------------------------------------------------

loc_4B0B0:
                cmpi.w  #2,d0
                bne.s   loc_4B0DE
                move.b  #$14,anim(a1)
                moveq   #0,d0
                move.b  angle(a3),d0
                addq.b  #8,d0
                lsr.w   #4,d0
                move.b  RawAni_4B0CE(pc,d0.w),mapping_frame(a1)
                bra.s   loc_4B08E
; ---------------------------------------------------------------------------
RawAni_4B0CE:
                dc.b    $90, $90, $90, $90, $90, $90, $90, $90, $91, $92, $92, $92, $92, $92, $92, $91
                even
; ---------------------------------------------------------------------------

loc_4B0DE:
                move.b  #0,anim(a1)
                moveq   #0,d0
                move.b  $37(a3),d0
                addq.b  #4,d0
                lsr.w   #4,d0
                move.b  RawAni_4B110(pc,d0.w),mapping_frame(a1)
                move.b  byte_4B120(pc,d0.w),d0
                andi.b  #$FC,render_flags(a1)
                or.b    d0,render_flags(a1)
                andi.b  #$FC,status(a1)
                or.b    d0,status(a1)
                bra.w   loc_4B08E
; ---------------------------------------------------------------------------
RawAni_4B110:
                dc.b    $E4, $E5, $E6, $E6, $E7, $E6, $E6, $E5, $E4, $E8, $E9, $E9, $EA, $E9, $E9, $E8
byte_4B120:
                dc.b    0,   0,   0,   0,   0,   1,   1,   1,   1,   0,   0,   0,   0,   1,   1,   1
                even
; ---------------------------------------------------------------------------

loc_4B130:
                tst.b   2(a2)
                beq.s   loc_4B13E
                subq.b  #1,2(a2)
                bne.w   locret_4B1CE

loc_4B13E:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   locret_4B1CE
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                cmpi.w  #$18,d1
                bhs.w   locret_4B1CE
                tst.b   object_control(a1)
                bne.s   locret_4B1CE
                cmpi.b  #4,routine(a1)
                bhs.s   locret_4B1CE
                tst.w   (Debug_placement_mode).w
                bne.s   locret_4B1CE
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$14,y_pos(a1)
                move.b  #$14,anim(a1)
                move.b  #0,spin_dash_flag(a1)
                move.b  #3,object_control(a1)
                andi.b  #$FC,render_flags(a1)
                move.b  status(a3),d0
                andi.b  #1,d0
                or.b    d0,render_flags(a1)
                andi.b  #$FC,status(a1)
                or.b    d0,status(a1)
                move.b  #1,(a2)
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l

locret_4B1CE:
                rts
; End of function UpdateSozRappelEndpointPlayerAttachment

; ---------------------------------------------------------------------------
Map_SOZRapelWire:
                include "src/objects/shared/zones/soz/mappings/rapel_wire.s"
