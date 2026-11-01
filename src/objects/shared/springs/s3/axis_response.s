; Owner: objects/shared/springs/s3
; Responsibility: Up, horizontal and down spring contact and launch responses for normal and competition players
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Spring_Up:
                move.w  #$1B,d1
                move.w  #8,d2
                move.w  #$10,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.w   SolidObjectFull2_1P
                btst    #p1_standing_bit,status(a0)
                beq.s   loc_215CE
                bsr.s   LaunchPlayerFromUpSpring

loc_215CE:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   SolidObjectFull2_1P
                btst    #p2_standing_bit,status(a0)
                beq.s   loc_215E6
                bsr.s   LaunchPlayerFromUpSpring

loc_215E6:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_2PSpring_Up:
                move.w  #$13,d1
                move.w  #8,d2
                move.w  #$10,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.w   SolidObjectFull2_1P
                btst    #p1_standing_bit,status(a0)
                beq.s   loc_21620
                bsr.s   LaunchPlayerFromUpSpring

loc_21620:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   SolidObjectFull2_1P
                btst    #p2_standing_bit,status(a0)
                beq.s   loc_21638
                bsr.s   LaunchPlayerFromUpSpring

loc_21638:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromUpSpring:
                move.w  #1<<8,anim(a0)                  ; and prev_anim
                addq.w  #8,y_pos(a1)
                move.w  $30(a0),y_vel(a1)
                bset    #1,status(a1)
                bclr    #3,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                move.b  #$10,anim(a1)
                move.b  #2,routine(a1)
                move.b  subtype(a0),d0
                bpl.s   loc_21686
                move.w  #0,x_vel(a1)

loc_21686:
                btst    #0,d0
                beq.s   loc_216C6
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                btst    #1,d0
                bne.s   loc_216B6
                move.b  #1,flips_remaining(a1)

loc_216B6:
                btst    #0,status(a1)
                beq.s   loc_216C6
                neg.b   flip_angle(a1)
                neg.w   ground_vel(a1)

loc_216C6:
                andi.b  #$C,d0
                cmpi.b  #4,d0
                bne.s   loc_216DC
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)

loc_216DC:
                cmpi.b  #8,d0
                bne.s   loc_216EE
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

loc_216EE:
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; End of function LaunchPlayerFromUpSpring

; ---------------------------------------------------------------------------

Obj_Spring_Horizontal:
                move.w  #$13,d1
                move.w  #$E,d2
                move.w  #$F,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.w   SolidObjectFull2_1P
                swap    d6
                andi.w  #1,d6
                beq.s   loc_21738
                move.b  status(a0),d1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   loc_2172E
                eori.b  #1,d1

loc_2172E:
                andi.b  #1,d1
                bne.s   loc_21738
                bsr.w   LaunchPlayerFromHorizontalSpring

loc_21738:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   SolidObjectFull2_1P
                swap    d6
                andi.w  #2,d6
                beq.s   loc_2176A
                move.b  status(a0),d1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   loc_21760
                eori.b  #1,d1

loc_21760:
                andi.b  #1,d1
                bne.s   loc_2176A
                bsr.w   LaunchPlayerFromHorizontalSpring

loc_2176A:
                bsr.w   BoostGroundedPlayersNearHorizontalSpring
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                move.w  $32(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

Obj_2PSpring_Horizontal:
                move.w  #$F,d1
                move.w  #$C,d2
                move.w  #$D,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.w   SolidObjectFull2_1P
                swap    d6
                andi.w  #1,d6
                beq.s   loc_217C4
                move.b  status(a0),d1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   loc_217BC
                eori.b  #1,d1

loc_217BC:
                andi.b  #1,d1
                bne.s   loc_217C4
                bsr.s   LaunchPlayerFromSmallHorizontalSpring

loc_217C4:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   SolidObjectFull2_1P
                swap    d6
                andi.w  #2,d6
                beq.s   loc_217F4
                move.b  status(a0),d1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   loc_217EC
                eori.b  #1,d1

loc_217EC:
                andi.b  #1,d1
                bne.s   loc_217F4
                bsr.s   LaunchPlayerFromSmallHorizontalSpring

loc_217F4:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromSmallHorizontalSpring:
                move.w  #3<<8,anim(a0)                  ; and prev_anim
                move.w  $30(a0),x_vel(a1)
                addq.w  #4,x_pos(a1)
                bset    #Status_Facing,status(a1)
                btst    #0,status(a0)
                bne.s   loc_21834
                bclr    #Status_Facing,status(a1)
                subi.w  #2*4,x_pos(a1)
                neg.w   x_vel(a1)

loc_21834:
                bra.s   loc_21864
; End of function LaunchPlayerFromSmallHorizontalSpring

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromHorizontalSpring:
                move.w  #3<<8,anim(a0)                  ; and prev_anim
                move.w  $30(a0),x_vel(a1)
                addq.w  #8,x_pos(a1)
                bset    #Status_Facing,status(a1)
                btst    #0,status(a0)
                bne.s   loc_21864
                bclr    #Status_Facing,status(a1)
                subi.w  #2*8,x_pos(a1)
                neg.w   x_vel(a1)

loc_21864:
                move.w  #$F,$32(a1)
                move.w  x_vel(a1),ground_vel(a1)
                btst    #Status_Roll,status(a1)
                bne.s   loc_2187E
                move.b  #0,anim(a1)

loc_2187E:
                move.b  subtype(a0),d0
                bpl.s   loc_2188A
                move.w  #0,y_vel(a1)

loc_2188A:
                btst    #0,d0
                beq.s   loc_218CA
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #1,flips_remaining(a1)
                move.b  #8,flip_speed(a1)
                btst    #1,d0
                bne.s   loc_218BA
                move.b  #3,flips_remaining(a1)

loc_218BA:
                btst    #Status_Facing,status(a1)
                beq.s   loc_218CA
                neg.b   flip_angle(a1)
                neg.w   ground_vel(a1)

loc_218CA:
                andi.b  #$C,d0
                cmpi.b  #4,d0
                bne.s   loc_218E0
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)

loc_218E0:
                cmpi.b  #8,d0
                bne.s   loc_218F2
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

loc_218F2:
                bclr    #p1_pushing_bit,status(a0)
                bclr    #p2_pushing_bit,status(a0)
                bclr    #Status_Push,status(a1)
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; End of function LaunchPlayerFromHorizontalSpring

; =============== S U B R O U T I N E =======================================

BoostGroundedPlayersNearHorizontalSpring:
                cmpi.b  #3,anim(a0)
                beq.w   locret_219C4
                move.w  x_pos(a0),d0
                move.w  d0,d1
                addi.w  #$28,d1
                btst    #0,status(a0)
                beq.s   loc_2192E
                move.w  d0,d1
                subi.w  #$28,d0

loc_2192E:
                move.w  y_pos(a0),d2
                move.w  d2,d3
                subi.w  #$18,d2
                addi.w  #$18,d3
                lea     (Player_1).w,a1
                btst    #1,status(a1)
                bne.s   loc_21982
                move.w  ground_vel(a1),d4
                btst    #0,status(a0)
                beq.s   loc_21956
                neg.w   d4

loc_21956:
                tst.w   d4
                bmi.s   loc_21982
                move.w  x_pos(a1),d4
                cmp.w   d0,d4
                blo.w   loc_21982
                cmp.w   d1,d4
                bhs.w   loc_21982
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blo.w   loc_21982
                cmp.w   d3,d4
                bhs.w   loc_21982
                move.w  d0,-(sp)
                bsr.w   LaunchPlayerFromHorizontalSpring
                move.w  (sp)+,d0

loc_21982:
                lea     (Player_2).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   locret_219C4
                move.w  ground_vel(a1),d4
                btst    #0,status(a0)
                beq.s   loc_2199C
                neg.w   d4

loc_2199C:
                tst.w   d4
                bmi.s   locret_219C4
                move.w  x_pos(a1),d4
                cmp.w   d0,d4
                blo.w   locret_219C4
                cmp.w   d1,d4
                bhs.w   locret_219C4
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blo.w   locret_219C4
                cmp.w   d3,d4
                bhs.w   locret_219C4
                bsr.w   LaunchPlayerFromHorizontalSpring

locret_219C4:
                rts
; End of function BoostGroundedPlayersNearHorizontalSpring

; ---------------------------------------------------------------------------

Obj_Spring_Down:
                move.w  #$1B,d1
                move.w  #8,d2
                move.w  #9,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.w   SolidObjectFull2_1P
                cmpi.w  #-2,d4
                bne.s   loc_219EC
                bsr.s   LaunchPlayerFromDownSpring

loc_219EC:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   SolidObjectFull2_1P
                cmpi.w  #-2,d4
                bne.s   loc_21A02
                bsr.s   LaunchPlayerFromDownSpring

loc_21A02:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_2PSpring_Down:
                move.w  #$13,d1
                move.w  #8,d2
                move.w  #9,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.w   SolidObjectFull2_1P
                cmpi.w  #-2,d4
                bne.s   loc_21A3E
                subq.w  #4,y_pos(a1)
                bsr.s   loc_21A6E

loc_21A3E:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   SolidObjectFull2_1P
                cmpi.w  #-2,d4
                bne.s   loc_21A58
                subq.w  #4,y_pos(a1)
                bsr.s   loc_21A6E

loc_21A58:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromDownSpring:
                subq.w  #8,y_pos(a1)

loc_21A6E:
                move.w  #1<<8,anim(a0)                  ; and prev_anim
                move.w  $30(a0),y_vel(a1)
                neg.w   y_vel(a1)
                cmpi.w  #$1000,y_vel(a1)
                bne.s   loc_21A8C
                move.w  #$D00,y_vel(a1)

loc_21A8C:
                move.b  subtype(a0),d0
                bpl.s   loc_21A98
                move.w  #0,x_vel(a1)

loc_21A98:
                btst    #0,d0
                beq.s   loc_21AD8
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                btst    #1,d0
                bne.s   loc_21AC8
                move.b  #1,flips_remaining(a1)

loc_21AC8:
                btst    #Status_Facing,status(a1)
                beq.s   loc_21AD8
                neg.b   flip_angle(a1)
                neg.w   ground_vel(a1)

loc_21AD8:
                andi.b  #$C,d0
                cmpi.b  #4,d0
                bne.s   loc_21AEE
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)

loc_21AEE:
                cmpi.b  #8,d0
                bne.s   loc_21B00
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

loc_21B00:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                move.b  #2,routine(a1)
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; End of function LaunchPlayerFromDownSpring
