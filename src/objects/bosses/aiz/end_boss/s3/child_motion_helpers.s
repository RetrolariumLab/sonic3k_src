; Owner: objects/bosses/aiz/end_boss/s3
; Responsibility: Angel Island end-boss child positioning, synchronized drawing, animation and spawn helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

sub_47916:
                move.w  angle(a0),d0
                moveq   #0,d1
                eori.w  #$C,d0
                beq.s   loc_4792C
                cmpi.w  #$C,d0
                beq.s   loc_4792C
                addi.w  #$10,d1

loc_4792C:
                moveq   #0,d2
                move.b  $39(a0),d2
                add.w   d2,d1
                lea     byte_4794C(pc,d1.w),a1
                move.b  (a1)+,child_dx(a0)
                move.b  (a1)+,child_dy(a0)
                move.b  (a1)+,mapping_frame(a0)
                addq.b  #4,d2
                move.b  d2,$39(a0)
                rts
; End of function sub_47916

; ---------------------------------------------------------------------------
byte_4794C:
                dc.b    -$18,   8,   5
                even
                dc.b    -$18,   8,   5
                even
                dc.b    -$1C,   0,   4
                even
                dc.b    -$1C,   0,   4
                even
                dc.b    -$18,   8,   5
                even
                dc.b    -$10, $10,   6
                even
                dc.b    -$18,   8,   5
                even
                dc.b    -$1C,   0,   4
                even

; =============== S U B R O U T I N E =======================================

Child_SyncDraw:
                movea.w parent3(a0),a1
                btst    #6,$38(a1)
                bne.s   loc_47994
                bclr    #6,$38(a0)
                bset    #7,art_tile(a0)
                btst    #7,art_tile(a1)
                bne.s   locret_47992
                bclr    #7,art_tile(a0)

locret_47992:
                rts
; ---------------------------------------------------------------------------

loc_47994:
                bset    #6,$38(a0)
                rts
; End of function Child_SyncDraw

; ---------------------------------------------------------------------------

loc_4799C:
                move.w  angle(a0),d0
                lsr.w   #1,d0
                move.w  off_479B0(pc,d0.w),d0
                lea     off_479B0(pc,d0.w),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------
off_479B0:
                dc.w    ChildObjDat_47B94-off_479B0
                dc.w    ChildObjDat_47B9C-off_479B0
                dc.w    ChildObjDat_47B9C-off_479B0
                dc.w    ChildObjDat_47BA4-off_479B0
; ---------------------------------------------------------------------------

loc_479B8:
                movea.w parent3(a0),a1
                move.w  angle(a1),d0
                cmpi.w  #8,d0
                bhs.s   loc_479CC
                bset    #0,render_flags(a0)

loc_479CC:
                move.l  off_479F0(pc,d0.w),$30(a0)
                lea     word_47A00(pc,d0.w),a1
                move.w  (a1)+,d1
                add.w   d1,x_pos(a0)
                move.w  (a1)+,d1
                add.w   d1,y_pos(a0)
                lea     word_47A10(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
off_479F0:
                dc.l    byte_47C73
                dc.l    byte_47C79
                dc.l    byte_47C79
                dc.l    byte_47C73
word_47A00:
                dc.w    $14,   $14
                dc.w    0,   $18
                dc.w    0,   $18
                dc.w    -$14,   $14
word_47A10:
                dc.w    $300,  $300
                dc.w    0,  $400
                dc.w    0,  $400
                dc.w    -$300,  $300

; =============== S U B R O U T I N E =======================================

sub_47A20:
                tst.b   collision_flags(a0)
                bne.s   locret_47A72
                tst.b   collision_property(a0)
                beq.s   loc_47A74
                tst.b   $20(a0)
                bne.s   loc_47A40
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_47A40:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_47A54
                addi.w  #2*7,d0

loc_47A54:
                bsr.w   sub_47A9A
                subq.b  #1,$20(a0)
                bne.s   locret_47A72
                bclr    #6,status(a0)
                cmpi.b  #0,mapping_frame(a0)
                bne.s   locret_47A72
                move.b  $25(a0),collision_flags(a0)

locret_47A72:
                rts
; ---------------------------------------------------------------------------

loc_47A74:
                move.l  #Wait_Draw,(a0)
                bclr    #6,$38(a0)
                bset    #7,art_tile(a0)
                move.b  #0,mapping_frame(a0)
                move.l  #loc_47360,$34(a0)
                jmp     (BossDefeated_StopTimer).l
; End of function sub_47A20

; =============== S U B R O U T I N E =======================================

sub_47A9A:
                lea     word_47AC0(pc),a1
                lea     word_47ACE(pc,d0.w),a2
                rept    7
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+
                endm
                rts
; End of function sub_47A9A

; ---------------------------------------------------------------------------
word_47AC0:
                dc.w    Normal_palette_line_2+$08, Normal_palette_line_2+$0E, Normal_palette_line_2+$12, Normal_palette_line_2+$14
                dc.w    Normal_palette_line_2+$16, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
word_47ACE:
                dc.w    $222,     8,   $4C,     6,   $20,  $A24,  $622
                dc.w    $AAA,  $AAA,  $AAA,  $CCC,  $EEE,  $666,  $888

; =============== S U B R O U T I N E =======================================

sub_47AEA:
                moveq   #0,d0
                bsr.s   sub_47A9A
                bclr    #6,status(a0)
                clr.b   $20(a0)
                rts
; End of function sub_47AEA

; =============== S U B R O U T I N E =======================================

sub_47AFA:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_47B08
                rts
; ---------------------------------------------------------------------------

loc_47B08:
                move.l  #Wait_Draw,(a0)
                bset    #7,status(a0)
                move.b  #1,mapping_frame(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_47584,$34(a0)
                rts
; End of function sub_47AFA
