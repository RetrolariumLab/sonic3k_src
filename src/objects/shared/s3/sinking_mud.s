; Owner: objects/shared/s3
; Responsibility: Sinking mud contact, player depth control and movement response
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SinkingMud:
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                move.b  d0,width_pixels(a0)
                move.w  y_pos(a0),$30(a0)
                move.b  #$30,$38(a0)
                move.b  #$30,$3A(a0)
                bset    #7,status(a0)
                move.l  #loc_31E1C,(a0)
                tst.w   (Competition_mode).w
                bne.w   loc_31E1C
                move.l  #loc_31D3E,(a0)

loc_31D3E:
                tst.w   (Debug_placement_mode).w
                bne.w   loc_31DF2
                lea     (Player_1).w,a1
                btst    #p1_standing_bit,status(a0)
                bne.s   loc_31D7A
                cmpi.b  #$30,$38(a0)
                bhs.s   loc_31D5E
                addq.b  #2,$38(a0)

loc_31D5E:
                btst    #Status_OnObj,status(a1)
                beq.s   loc_31D84
                movea.w interact(a1),a2
                cmpi.l  #loc_31D3E,(a2)
                bne.s   loc_31D84
                move.b  $38(a2),$38(a0)
                bra.s   loc_31D84
; ---------------------------------------------------------------------------

loc_31D7A:
                tst.b   $38(a0)
                beq.s   loc_31DF8
                subq.b  #1,$38(a0)

loc_31D84:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #0,d3
                move.b  $38(a0),d3
                moveq   #p1_standing_bit,d6
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop_1P).l
                lea     (Player_2).w,a1
                btst    #p2_standing_bit,status(a0)
                bne.s   loc_31DD0
                cmpi.b  #$30,$3A(a0)
                bhs.s   loc_31DB4
                addq.b  #2,$3A(a0)

loc_31DB4:
                btst    #Status_OnObj,status(a1)
                beq.s   loc_31DDA
                movea.w interact(a1),a2
                cmpi.l  #loc_31D3E,(a2)
                bne.s   loc_31DDA
                move.b  $3A(a2),$3A(a0)
                bra.s   loc_31DDA
; ---------------------------------------------------------------------------

loc_31DD0:
                tst.b   $3A(a0)
                beq.s   loc_31E00
                subq.b  #1,$3A(a0)

loc_31DDA:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #0,d3
                move.b  $3A(a0),d3
                moveq   #p2_standing_bit,d6
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop_1P).l

loc_31DF2:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_31DF8:
                move.b  #$30,$38(a0)
                bra.s   loc_31E06
; ---------------------------------------------------------------------------

loc_31E00:
                move.b  #$30,$3A(a0)

loc_31E06:
                not.b   d1
                and.b   d1,status(a0)
                move.l  a0,-(sp)
                movea.l a0,a2
                movea.l a1,a0
                jsr     (Kill_Character).l
                movea.l (sp)+,a0
                rts
; ---------------------------------------------------------------------------

loc_31E1C:
                tst.w   (Debug_placement_mode).w
                bne.w   locret_31ED4
                lea     (Player_1).w,a1
                btst    #p1_standing_bit,status(a0)
                bne.s   loc_31E58
                cmpi.b  #$30,$38(a0)
                bhs.s   loc_31E3C
                addq.b  #2,$38(a0)

loc_31E3C:
                btst    #Status_OnObj,status(a1)
                beq.s   loc_31E62
                movea.w interact(a1),a2
                cmpi.l  #loc_31D3E,(a2)
                bne.s   loc_31E62
                move.b  $38(a2),$38(a0)
                bra.s   loc_31E62
; ---------------------------------------------------------------------------

loc_31E58:
                tst.b   $38(a0)
                beq.s   loc_31ED6
                subq.b  #1,$38(a0)

loc_31E62:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #0,d3
                move.b  $38(a0),d3
                lsr.w   #1,d3
                moveq   #p1_standing_bit,d6
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop_1P).l
                lea     (Player_2).w,a1
                btst    #p2_standing_bit,status(a0)
                bne.s   loc_31EB0
                cmpi.b  #$30,$3A(a0)
                bhs.s   loc_31E94
                addq.b  #2,$3A(a0)

loc_31E94:
                btst    #Status_OnObj,status(a1)
                beq.s   loc_31EBA
                movea.w interact(a1),a2
                cmpi.l  #loc_31D3E,(a2)
                bne.s   loc_31EBA
                move.b  $3A(a2),$3A(a0)
                bra.s   loc_31EBA
; ---------------------------------------------------------------------------

loc_31EB0:
                tst.b   $3A(a0)
                beq.s   loc_31EDE
                subq.b  #1,$3A(a0)

loc_31EBA:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #0,d3
                move.b  $3A(a0),d3
                lsr.w   #1,d3
                moveq   #p2_standing_bit,d6
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop_1P).l

locret_31ED4:
                rts
; ---------------------------------------------------------------------------

loc_31ED6:
                move.b  #$30,$38(a0)
                bra.s   loc_31EE4
; ---------------------------------------------------------------------------

loc_31EDE:
                move.b  #$30,$3A(a0)

loc_31EE4:
                not.b   d1
                and.b   d1,status(a0)
                move.l  a0,-(sp)
                movea.l a0,a2
                movea.l a1,a0
                jsr     (Kill_Character).l
                movea.l (sp)+,a0
                rts
