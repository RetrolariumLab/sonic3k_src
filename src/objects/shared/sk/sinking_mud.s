; Owner: objects/shared/sk
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
                move.l  #loc_32B8C,(a0)
                tst.w   (Competition_mode).w
                bne.w   loc_32B8C
                move.l  #loc_32AAE,(a0)

loc_32AAE:
                tst.w   (Debug_placement_mode).w
                bne.w   loc_32B62
                lea     (Player_1).w,a1
                btst    #p1_standing_bit,status(a0)
                bne.s   loc_32AEA
                cmpi.b  #$30,$38(a0)
                bhs.s   loc_32ACE
                addq.b  #2,$38(a0)

loc_32ACE:
                btst    #Status_OnObj,status(a1)
                beq.s   loc_32AF4
                movea.w interact(a1),a2
                cmpi.l  #loc_32AAE,(a2)
                bne.s   loc_32AF4
                move.b  $38(a2),$38(a0)
                bra.s   loc_32AF4
; ---------------------------------------------------------------------------

loc_32AEA:
                tst.b   $38(a0)
                beq.s   loc_32B68
                subq.b  #1,$38(a0)

loc_32AF4:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #0,d3
                move.b  $38(a0),d3
                moveq   #p1_standing_bit,d6
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop_1P).l
                lea     (Player_2).w,a1
                btst    #p2_standing_bit,status(a0)
                bne.s   loc_32B40
                cmpi.b  #$30,$3A(a0)
                bhs.s   loc_32B24
                addq.b  #2,$3A(a0)

loc_32B24:
                btst    #Status_OnObj,status(a1)
                beq.s   loc_32B4A
                movea.w interact(a1),a2
                cmpi.l  #loc_32AAE,(a2)
                bne.s   loc_32B4A
                move.b  $3A(a2),$3A(a0)
                bra.s   loc_32B4A
; ---------------------------------------------------------------------------

loc_32B40:
                tst.b   $3A(a0)
                beq.s   loc_32B70
                subq.b  #1,$3A(a0)

loc_32B4A:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #0,d3
                move.b  $3A(a0),d3
                moveq   #p2_standing_bit,d6
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop_1P).l

loc_32B62:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_32B68:
                move.b  #$30,$38(a0)
                bra.s   loc_32B76
; ---------------------------------------------------------------------------

loc_32B70:
                move.b  #$30,$3A(a0)

loc_32B76:
                not.b   d1
                and.b   d1,status(a0)
                move.l  a0,-(sp)
                movea.l a0,a2
                movea.l a1,a0
                jsr     (Kill_Character).l
                movea.l (sp)+,a0
                rts
; ---------------------------------------------------------------------------

loc_32B8C:
                tst.w   (Debug_placement_mode).w
                bne.w   locret_32C44
                lea     (Player_1).w,a1
                btst    #p1_standing_bit,status(a0)
                bne.s   loc_32BC8
                cmpi.b  #$30,$38(a0)
                bhs.s   loc_32BAC
                addq.b  #2,$38(a0)

loc_32BAC:
                btst    #Status_OnObj,status(a1)
                beq.s   loc_32BD2
                movea.w interact(a1),a2
                cmpi.l  #loc_32AAE,(a2)
                bne.s   loc_32BD2
                move.b  $38(a2),$38(a0)
                bra.s   loc_32BD2
; ---------------------------------------------------------------------------

loc_32BC8:
                tst.b   $38(a0)
                beq.s   loc_32C46
                subq.b  #1,$38(a0)

loc_32BD2:
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
                bne.s   loc_32C20
                cmpi.b  #$30,$3A(a0)
                bhs.s   loc_32C04
                addq.b  #2,$3A(a0)

loc_32C04:
                btst    #Status_OnObj,status(a1)
                beq.s   loc_32C2A
                movea.w interact(a1),a2
                cmpi.l  #loc_32AAE,(a2)
                bne.s   loc_32C2A
                move.b  $3A(a2),$3A(a0)
                bra.s   loc_32C2A
; ---------------------------------------------------------------------------

loc_32C20:
                tst.b   $3A(a0)
                beq.s   loc_32C4E
                subq.b  #1,$3A(a0)

loc_32C2A:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #0,d3
                move.b  $3A(a0),d3
                lsr.w   #1,d3
                moveq   #p2_standing_bit,d6
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop_1P).l

locret_32C44:
                rts
; ---------------------------------------------------------------------------

loc_32C46:
                move.b  #$30,$38(a0)
                bra.s   loc_32C54
; ---------------------------------------------------------------------------

loc_32C4E:
                move.b  #$30,$3A(a0)

loc_32C54:
                not.b   d1
                and.b   d1,status(a0)
                move.l  a0,-(sp)
                movea.l a0,a2
                movea.l a1,a0
                jsr     (Kill_Character).l
                movea.l (sp)+,a0
                rts
