; Owner: objects/zones/cnz/sk
; Responsibility: Carnival Night vacuum tube capture, player transport and release
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_CNZVacuumTube:
                move.b  subtype(a0),d0
                beq.s   loc_31F46
                add.b   d0,d0
                move.b  d0,$34(a0)
                move.l  #loc_31FF4,(a0)
                bra.w   loc_31FF4
; ---------------------------------------------------------------------------

loc_31F46:
                move.l  #loc_31F4C,(a0)

loc_31F4C:
                lea     (Player_1).w,a1
                bsr.w   ApplyCnzHorizontalVacuumTubeToPlayer
                lea     (Player_2).w,a1
                bsr.w   ApplyCnzHorizontalVacuumTubeToPlayer
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

ApplyCnzHorizontalVacuumTubeToPlayer:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                btst    #0,status(a0)
                bne.s   loc_31F74
                neg.w   d0

loc_31F74:
                addi.w  #$50,d0
                cmpi.w  #$A0,d0
                bhs.s   locret_31FF2
                move.w  y_pos(a1),d1
                addi.w  #$20,d1
                sub.w   y_pos(a0),d1
                bcs.s   locret_31FF2
                cmpi.w  #$40,d1
                bhs.s   locret_31FF2
                cmpi.b  #4,routine(a1)
                bhs.s   locret_31FF2
                tst.b   object_control(a1)
                bne.s   locret_31FF2
                subi.w  #$50,d0
                bcc.s   loc_31FC2
                not.w   d0
                move.w  #$1000,ground_vel(a1)
                btst    #0,status(a0)
                bne.s   loc_31FBA
                neg.w   ground_vel(a1)

loc_31FBA:
                move.w  ground_vel(a1),x_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_31FC2:
                add.w   d0,d0
                addi.w  #$60,d0
                btst    #0,status(a0)
                bne.s   loc_31FD2
                neg.w   d0

loc_31FD2:
                neg.b   d0
                asr.w   #4,d0
                add.w   d0,x_pos(a1)
                move.w  $36(a0),d0
                bne.s   loc_31FE8
                moveq   #signextendB(sfx_TunnelBooster),d0
                jsr     (Play_SFX).l

loc_31FE8:
                addq.w  #1,$36(a0)
                andi.w  #$1F,$36(a0)

locret_31FF2:
                rts
; End of function ApplyCnzHorizontalVacuumTubeToPlayer

; ---------------------------------------------------------------------------

loc_31FF4:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                bsr.w   UpdatePlayerInCnzVerticalVacuumTube
                addq.w  #1,a2
                lea     (Player_2).w,a1
                bsr.w   UpdatePlayerInCnzVerticalVacuumTube
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerInCnzVerticalVacuumTube:
                move.b  (a2),d0
                bne.w   loc_3209C
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$18,d0
                cmpi.w  #$30,d0
                bhs.s   locret_3209A
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$30,d1
                cmpi.w  #$50,d1
                bhs.s   locret_3209A
                cmpi.b  #4,routine(a1)
                bhs.s   locret_3209A
                tst.b   object_control(a1)
                bne.s   locret_3209A
                subi.w  #$50,d1
                neg.w   d1
                cmpi.w  #$40,d1
                blo.s   loc_3206A
                move.b  #1,(a2)
                move.b  $34(a0),2(a2)
                move.w  d0,-(sp)
                moveq   #signextendB(sfx_Transporter),d0
                jsr     (Play_SFX).l
                move.w  (sp)+,d0

loc_3206A:
                asr.w   #2,d1
                cmpi.b  #1,character_id(a1)
                beq.s   loc_32076
                asr.w   #1,d1

loc_32076:
                sub.w   d1,y_pos(a1)
                moveq   #1,d2
                cmpi.w  #$18,d0
                beq.s   loc_3208A
                bcs.s   loc_32086
                neg.w   d2

loc_32086:
                add.w   d2,x_pos(a1)

loc_3208A:
                bset    #Status_InAir,status(a1)
                move.b  #$F,anim(a1)
                clr.b   jumping(a1)

locret_3209A:
                rts
; ---------------------------------------------------------------------------

loc_3209C:
                subq.b  #1,d0
                bne.s   locret_320E0
                subq.b  #1,2(a2)
                beq.s   loc_320D4
                subi.w  #8,y_pos(a1)
                moveq   #1,d2
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                beq.s   loc_320C0
                bcs.s   loc_320BC
                neg.w   d2

loc_320BC:
                add.w   d2,x_pos(a1)

loc_320C0:
                move.w  #0,x_vel(a1)
                move.w  #0,ground_vel(a1)
                move.w  #0,y_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_320D4:
                move.w  #-$800,y_vel(a1)
                move.b  #0,(a2)
                rts
; ---------------------------------------------------------------------------

locret_320E0:
                rts
; End of function UpdatePlayerInCnzVerticalVacuumTube
