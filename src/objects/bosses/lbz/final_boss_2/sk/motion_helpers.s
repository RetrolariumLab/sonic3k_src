; Owner: objects/bosses/lbz/final_boss_2/sk
; Responsibility: Launch Base final boss player response, palette, motion and parent or child callback helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

sub_74EBC:
                movea.w parent3(a0),a1
                btst    #7,art_tile(a1)
                beq.s   locret_74ED4
                bset    #7,art_tile(a0)
                move.l  (sp),(a0)
                move.b  d0,collision_flags(a0)

locret_74ED4:
                rts
; End of function sub_74EBC

; ---------------------------------------------------------------------------
; unused
                movea.w $44(a0),a1
                movea.w parent3(a0),a2
                move.w  x_pos(a1),d0
                moveq   #$10,d2
                btst    #0,render_flags(a2)
                beq.s   loc_74EEE
                neg.w   d2

loc_74EEE:
                add.w   d2,d0
                move.w  x_pos(a2),d1
                moveq   #$C,d2
                btst    #0,render_flags(a2)
                beq.s   loc_74F00
                neg.w   d2

loc_74F00:
                add.w   d2,d1
                sub.w   d1,d0
                asr.w   #1,d0
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.w  y_pos(a1),d0
                subq.w  #4,d0
                move.w  y_pos(a2),d1
                subq.w  #4,d1
                sub.w   d1,d0
                asr.w   #1,d0
                add.w   d0,d1
                move.w  d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_74F24:
                jsr     (Random_Number).l
                andi.w  #6,d0
                move.w  d0,$3A(a0)
                move.w  (Camera_X_pos).w,d1
                move.w  #$1A8,d2
                move.w  #-$300,d3
                btst    #0,render_flags(a0)
                beq.s   loc_74F4C
                move.w  #-$68,d2
                neg.w   d3

loc_74F4C:
                add.w   d2,d1
                move.w  d1,x_pos(a0)
                move.w  d3,x_vel(a0)
                move.w  (Camera_Y_pos).w,d1
                move.w  word_74F72(pc,d0.w),d2
                add.w   d1,d2
                move.w  d2,y_pos(a0)
                move.w  word_74F7A(pc,d0.w),y_vel(a0)
                move.w  #8,$3C(a0)
                rts
; ---------------------------------------------------------------------------
word_74F72:
                dc.w    $60,   $10,   $A0,   $80
word_74F7A:
                dc.w    0,  $200, -$200,     0
; ---------------------------------------------------------------------------

loc_74F82:
                move.w  #-$300,d0
                btst    #0,render_flags(a0)
                beq.s   loc_74F90
                neg.w   d0

loc_74F90:
                move.w  d0,x_vel(a0)
                jsr     (Random_Number).l
                andi.w  #$7F,d0
                addi.w  #$C0,d0
                move.w  d0,$2E(a0)
                rts

; =============== S U B R O U T I N E =======================================

sub_74FA8:
                move.w  (Camera_X_pos).w,d0
                tst.w   x_vel(a0)
                bmi.s   loc_74FBE
                add.w   d2,d0
                cmp.w   x_pos(a0),d0
                bls.s   loc_74FC6
                bra.w   locret_74FD0
; ---------------------------------------------------------------------------

loc_74FBE:
                add.w   d1,d0
                cmp.w   x_pos(a0),d0
                blo.s   locret_74FD0

loc_74FC6:
                bchg    #0,render_flags(a0)
                neg.w   x_vel(a0)

locret_74FD0:
                rts
; End of function sub_74FA8

; =============== S U B R O U T I N E =======================================

sub_74FD2:
                cmpi.b  #8,routine(a0)
                blo.s   locret_75044
                tst.b   collision_flags(a0)
                bne.s   locret_75044
                move.b  collision_property(a0),d0
                beq.s   loc_75046
                tst.b   $20(a0)
                bne.s   loc_75010
                cmpi.b  #$A,routine(a0)
                bne.s   loc_74FFA
                move.w  #8,$3A(a0)

loc_74FFA:
                move.b  #$3C,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                movea.w $44(a0),a1
                clr.b   collision_flags(a1)

loc_75010:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_75024
                addi.w  #2*6,d0

loc_75024:
                bsr.w   sub_75084
                subq.b  #1,$20(a0)
                bne.s   locret_75044
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)
                movea.w $44(a0),a1
                move.b  #$AD,collision_flags(a1)

locret_75044:
                rts
; ---------------------------------------------------------------------------

loc_75046:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #loc_746D8,$34(a0)
                jsr     (BossDefeated_StopTimer).l
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_7506E
                move.b  #4,subtype(a1)

loc_7506E:
                tst.b   $30(a0)
; Bug: this branch is inverted, freeing the player if they're _not_ being held
                bne.s   loc_7507A
                jsr     (Restore_PlayerControl).l

loc_7507A:
                lea     ChildObjDat_75186(pc),a2
                jmp     (CreateChild1_Normal).l
; End of function sub_74FD2

; =============== S U B R O U T I N E =======================================

sub_75084:
                lea     word_75092(pc),a1
                lea     word_7509E(pc,d0.w),a2
                jmp     (CopyWordData_6).l
; End of function sub_75084

; ---------------------------------------------------------------------------
word_75092:
                dc.w    Normal_palette_line_2+$08, Normal_palette_line_2+$0E, Normal_palette_line_2+$10
                dc.w    Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
word_7509E:
                dc.w    8,    $A,     4,  $644,  $422,     0
                dc.w    $888,  $666,  $AAA,  $AAA,  $EEE,  $EEE
