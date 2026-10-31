; Owner: objects/bosses/cnz/end_boss/s3
; Responsibility: Carnival Night end-boss movement, collision, attack and child positioning helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

sub_4C6B2:
                move.b  $3C(a0),d0
                move.w  #$200,priority(a0)
                addi.b  #$40,d0
                bpl.s   locret_4C6C8
                move.w  #$280,priority(a0)

locret_4C6C8:
                rts
; End of function sub_4C6B2

; =============== S U B R O U T I N E =======================================

sub_4C6CA:
                cmpi.b  #3,mapping_frame(a0)
                beq.s   locret_4C6EC
                move.b  $3C(a0),d0
                lea     byte_4C6EE(pc),a1
                moveq   #5-1,d6

loc_4C6DC:
                cmp.b   (a1)+,d0
                blo.s   loc_4C6E8
                addq.w  #1,a1
                dbf     d6,loc_4C6DC
                rts
; ---------------------------------------------------------------------------

loc_4C6E8:
                move.b  (a1)+,mapping_frame(a0)

locret_4C6EC:
                rts
; End of function sub_4C6CA

; ---------------------------------------------------------------------------
byte_4C6EE:
                dc.b    $30,   1
                dc.b    $58,   8
                dc.b    $A8,   2
                dc.b    $D0,   8
                dc.b    $FF,   1
                even

; =============== S U B R O U T I N E =======================================

sub_4C6F8:
                movea.w parent3(a0),a1
                btst    #7,$38(a1)
                bne.s   loc_4C70E
                btst    #7,status(a1)
                bne.s   loc_4C70E
                rts
; ---------------------------------------------------------------------------

loc_4C70E:
                jmp     (Go_Delete_Sprite).l
; End of function sub_4C6F8

; =============== S U B R O U T I N E =======================================

sub_4C714:
                btst    #2,$38(a0)
                bne.s   loc_4C71E
                rts
; ---------------------------------------------------------------------------

loc_4C71E:
                lea     (Player_1).w,a1
                bsr.w   sub_4C72A
                lea     (Player_2).w,a1
; End of function sub_4C714

; =============== S U B R O U T I N E =======================================

sub_4C72A:
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                spl     d1
                bpl.s   loc_4C738
                neg.w   d0

loc_4C738:
                andi.w  #$FFC0,d0
                cmpi.w  #$1C0,d0
                blo.s   loc_4C746
                move.w  #$1C0,d0

loc_4C746:
                lsr.w   #4,d0
                move.l  dword_4C758(pc,d0.w),d2
                tst.b   d1
                bne.s   loc_4C752
                neg.l   d2

loc_4C752:
                add.l   d2,x_pos(a1)
                rts
; End of function sub_4C72A

; ---------------------------------------------------------------------------
dword_4C758:
                dc.l    $28000
                dc.l    $20000
                dc.l    $1C000
                dc.l    $18000
                dc.l    $14000
                dc.l    $10000
                dc.l    $C000
                dc.l    $8000

; =============== S U B R O U T I N E =======================================

sub_4C778:
                tst.l   (a0)
                beq.s   locret_4C7CE
                tst.b   collision_flags(a0)
                bne.s   locret_4C7CE
                tst.b   collision_property(a0)
                beq.s   loc_4C7D0
                tst.b   $20(a0)
                bne.s   loc_4C79C
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_4C79C:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_4C7AE
                addq.w  #2*4,d0

loc_4C7AE:
                lea     word_4C7E4(pc),a1
                lea     word_4C7EC(pc,d0.w),a2
                jsr     (CopyWordData_4).l
                subq.b  #1,$20(a0)
                bne.s   locret_4C7CE
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_4C7CE:
                rts
; ---------------------------------------------------------------------------

loc_4C7D0:
                move.l  #Wait_Draw,(a0)
                move.l  #loc_4C1EA,$34(a0)
                jmp     (BossDefeated_StopTimer).l
; End of function sub_4C778

; ---------------------------------------------------------------------------
word_4C7E4:
                dc.w    Normal_palette_line_2+$12, Normal_palette_line_2+$14, Normal_palette_line_2+$16, Normal_palette_line_2+$1C
word_4C7EC:
                dc.w    $60,   $20,   $20,  $640
                dc.w    $888,  $EEE,  $EEE,  $AAA

; =============== S U B R O U T I N E =======================================

sub_4C7FC:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.s   loc_4C80C
                clr.b   collision_flags(a0)

loc_4C80C:
                btst    #4,$38(a1)
                bne.s   loc_4C816
                rts
; ---------------------------------------------------------------------------

loc_4C816:
                move.l  #Delete_Current_Sprite,(a0)
                lea     ChildObjDat_4C8C8(pc),a2
                jmp     CreateChild1_Normal(pc)
; End of function sub_4C7FC

; =============== S U B R O U T I N E =======================================

sub_4C824:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.s   loc_4C834
                clr.b   collision_flags(a0)

loc_4C834:
                btst    #4,$38(a1)
                bne.s   loc_4C83E
                rts
; ---------------------------------------------------------------------------

loc_4C83E:
                bset    #7,status(a0)
                move.b  #1,mapping_frame(a0)
                clr.b   collision_flags(a0)
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                jmp     Set_IndexedVelocity(pc)
; End of function sub_4C824
