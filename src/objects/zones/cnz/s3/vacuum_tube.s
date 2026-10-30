; Owner: objects/zones/cnz/s3
; Responsibility: Carnival Night vacuum tube capture, player transport and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZVacuumTube:
                move.b  subtype(a0),d0
                beq.s   loc_310B6
                add.b   d0,d0
                move.b  d0,$34(a0)
                move.l  #loc_31164,(a0)
                bra.w   loc_31164
; ---------------------------------------------------------------------------

loc_310B6:
                move.l  #loc_310BC,(a0)

loc_310BC:
                lea     (Player_1).w,a1
                bsr.w   sub_310D2
                lea     (Player_2).w,a1
                bsr.w   sub_310D2
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_310D2:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                btst    #0,status(a0)
                bne.s   loc_310E4
                neg.w   d0

loc_310E4:
                addi.w  #$50,d0
                cmpi.w  #$A0,d0
                bhs.s   locret_31162
                move.w  y_pos(a1),d1
                addi.w  #$20,d1
                sub.w   y_pos(a0),d1
                bcs.s   locret_31162
                cmpi.w  #$40,d1
                bhs.s   locret_31162
                cmpi.b  #4,routine(a1)
                bhs.s   locret_31162
                tst.b   object_control(a1)
                bne.s   locret_31162
                subi.w  #$50,d0
                bcc.s   loc_31132
                not.w   d0
                move.w  #$1000,ground_vel(a1)
                btst    #0,status(a0)
                bne.s   loc_3112A
                neg.w   ground_vel(a1)

loc_3112A:
                move.w  ground_vel(a1),x_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_31132:
                add.w   d0,d0
                addi.w  #$60,d0
                btst    #0,status(a0)
                bne.s   loc_31142
                neg.w   d0

loc_31142:
                neg.b   d0
                asr.w   #4,d0
                add.w   d0,x_pos(a1)
                move.w  $36(a0),d0
                bne.s   loc_31158
                moveq   #signextendB(sfx_TunnelBooster),d0
                jsr     (Play_SFX).l

loc_31158:
                addq.w  #1,$36(a0)
                andi.w  #$1F,$36(a0)

locret_31162:
                rts
; End of function sub_310D2

; ---------------------------------------------------------------------------

loc_31164:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                bsr.w   sub_31180
                addq.w  #1,a2
                lea     (Player_2).w,a1
                bsr.w   sub_31180
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_31180:
                move.b  (a2),d0
                bne.w   loc_3120C
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$18,d0
                cmpi.w  #$30,d0
                bhs.s   locret_3120A
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$30,d1
                cmpi.w  #$50,d1
                bhs.s   locret_3120A
                cmpi.b  #4,routine(a1)
                bhs.s   locret_3120A
                tst.b   object_control(a1)
                bne.s   locret_3120A
                subi.w  #$50,d1
                neg.w   d1
                cmpi.w  #$40,d1
                blo.s   loc_311DA
                move.b  #1,(a2)
                move.b  $34(a0),2(a2)
                move.w  d0,-(sp)
                moveq   #signextendB(sfx_Transporter),d0
                jsr     (Play_SFX).l
                move.w  (sp)+,d0

loc_311DA:
                asr.w   #2,d1
                cmpi.b  #1,character_id(a1)
                beq.s   loc_311E6
                asr.w   #1,d1

loc_311E6:
                sub.w   d1,y_pos(a1)
                moveq   #1,d2
                cmpi.w  #$18,d0
                beq.s   loc_311FA
                bcs.s   loc_311F6
                neg.w   d2

loc_311F6:
                add.w   d2,x_pos(a1)

loc_311FA:
                bset    #Status_InAir,status(a1)
                move.b  #$F,anim(a1)
                clr.b   jumping(a1)

locret_3120A:
                rts
; ---------------------------------------------------------------------------

loc_3120C:
                subq.b  #1,d0
                bne.s   locret_31250
                subq.b  #1,2(a2)
                beq.s   loc_31244
                subi.w  #8,y_pos(a1)
                moveq   #1,d2
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                beq.s   loc_31230
                bcs.s   loc_3122C
                neg.w   d2

loc_3122C:
                add.w   d2,x_pos(a1)

loc_31230:
                move.w  #0,x_vel(a1)
                move.w  #0,ground_vel(a1)
                move.w  #0,y_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_31244:
                move.w  #-$800,y_vel(a1)
                move.b  #0,(a2)
                rts
; ---------------------------------------------------------------------------

locret_31250:
                rts
; End of function sub_31180
