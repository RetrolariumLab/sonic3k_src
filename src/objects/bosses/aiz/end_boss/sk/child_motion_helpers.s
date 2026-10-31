; Owner: objects/bosses/aiz/end_boss/sk
; Responsibility: Angel Island end-boss child positioning, synchronized drawing, animation and spawn helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

sub_69AD8:
                move.w  angle(a0),d0
                moveq   #0,d1
                eori.w  #$C,d0
                beq.s   loc_69AEE
                cmpi.w  #$C,d0
                beq.s   loc_69AEE
                addi.w  #$10,d1

loc_69AEE:
                moveq   #0,d2
                move.b  $39(a0),d2
                add.w   d2,d1
                lea     byte_69B0E(pc,d1.w),a1
                move.b  (a1)+,child_dx(a0)
                move.b  (a1)+,child_dy(a0)
                move.b  (a1)+,mapping_frame(a0)
                addq.b  #4,d2
                move.b  d2,$39(a0)
                rts
; End of function sub_69AD8

; ---------------------------------------------------------------------------
byte_69B0E:
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
                bne.s   loc_69B56
                bclr    #6,$38(a0)
                bset    #7,art_tile(a0)
                btst    #7,art_tile(a1)
                bne.s   locret_69B54
                bclr    #7,art_tile(a0)

locret_69B54:
                rts
; ---------------------------------------------------------------------------

loc_69B56:
                bset    #6,$38(a0)
                rts
; End of function Child_SyncDraw

; ---------------------------------------------------------------------------

loc_69B5E:
                move.w  angle(a0),d0
                lsr.w   #1,d0
                move.w  off_69B72(pc,d0.w),d0
                lea     off_69B72(pc,d0.w),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------
off_69B72:
                dc.w    ChildObjDat_69D3E-off_69B72
                dc.w    ChildObjDat_69D46-off_69B72
                dc.w    ChildObjDat_69D46-off_69B72
                dc.w    ChildObjDat_69D4E-off_69B72
; ---------------------------------------------------------------------------

loc_69B7A:
                movea.w parent3(a0),a1
                move.w  angle(a1),d0
                cmpi.w  #8,d0
                bhs.s   loc_69B8E
                bset    #0,render_flags(a0)

loc_69B8E:
                move.l  off_69BB2(pc,d0.w),$30(a0)
                lea     word_69BC2(pc,d0.w),a1
                move.w  (a1)+,d1
                add.w   d1,x_pos(a0)
                move.w  (a1)+,d1
                add.w   d1,y_pos(a0)
                lea     word_69BD2(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
off_69BB2:
                dc.l    byte_69E1D
                dc.l    byte_69E23
                dc.l    byte_69E23
                dc.l    byte_69E1D
word_69BC2:
                dc.w    $14,   $14
                dc.w    0,   $18
                dc.w    0,   $18
                dc.w    -$14,   $14
word_69BD2:
                dc.w    $300,  $300
                dc.w    0,  $400
                dc.w    0,  $400
                dc.w    -$300,  $300

; =============== S U B R O U T I N E =======================================

sub_69BE2:
                tst.b   collision_flags(a0)
                bne.s   locret_69C34
                tst.b   collision_property(a0)
                beq.s   loc_69C36
                tst.b   $20(a0)
                bne.s   loc_69C02
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_69C02:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_69C16
                addi.w  #2*7,d0

loc_69C16:
                bsr.w   sub_69C5C
                subq.b  #1,$20(a0)
                bne.s   locret_69C34
                bclr    #6,status(a0)
                cmpi.b  #0,mapping_frame(a0)
                bne.s   locret_69C34
                move.b  $25(a0),collision_flags(a0)

locret_69C34:
                rts
; ---------------------------------------------------------------------------

loc_69C36:
                move.l  #Wait_FadeToLevelMusic,(a0)
                bclr    #6,$38(a0)
                bset    #7,art_tile(a0)
                move.b  #0,mapping_frame(a0)
                move.l  #loc_69482,$34(a0)
                jmp     (BossDefeated_StopTimer).l
; End of function sub_69BE2

; =============== S U B R O U T I N E =======================================

sub_69C5C:
                lea     word_69C6A(pc),a1
                lea     word_69C78(pc,d0.w),a2
                jmp     (CopyWordData_7).l
; End of function sub_69C5C

; ---------------------------------------------------------------------------
word_69C6A:
                dc.w    Normal_palette_line_2+$08, Normal_palette_line_2+$0E, Normal_palette_line_2+$12, Normal_palette_line_2+$14
                dc.w    Normal_palette_line_2+$16, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
word_69C78:
                dc.w    $222,     8,   $4C,     6,   $20,  $A24,  $622
                dc.w    $AAA,  $AAA,  $AAA,  $CCC,  $EEE,  $666,  $888

; =============== S U B R O U T I N E =======================================

sub_69C94:
                moveq   #0,d0
                bsr.s   sub_69C5C
                bclr    #6,status(a0)
                clr.b   $20(a0)
                rts
; End of function sub_69C94

; =============== S U B R O U T I N E =======================================

sub_69CA4:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_69CB2
                rts
; ---------------------------------------------------------------------------

loc_69CB2:
                move.l  #Wait_Draw,(a0)
                bset    #7,status(a0)
                move.b  #1,mapping_frame(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_69720,$34(a0)
                rts
; End of function sub_69CA4
