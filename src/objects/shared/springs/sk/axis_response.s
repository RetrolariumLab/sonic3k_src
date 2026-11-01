; Owner: objects/shared/springs/sk
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
                beq.s   loc_22F1C
                bsr.s   LaunchPlayerFromUpSpring

loc_22F1C:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   SolidObjectFull2_1P
                btst    #p2_standing_bit,status(a0)
                beq.s   loc_22F34
                bsr.s   LaunchPlayerFromUpSpring

loc_22F34:
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
                beq.s   loc_22F6E
                bsr.s   LaunchPlayerFromUpSpring

loc_22F6E:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   SolidObjectFull2_1P
                btst    #p2_standing_bit,status(a0)
                beq.s   loc_22F86
                bsr.s   LaunchPlayerFromUpSpring

loc_22F86:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromUpSpring:
                move.w  #1<<8,anim(a0)                  ; and prev_anim
                addq.w  #8,y_pos(a1)
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_22FAE
                subi.w  #2*8,y_pos(a1)

loc_22FAE:
                move.w  $30(a0),y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                move.b  #$10,anim(a1)
                move.b  #2,routine(a1)
                move.b  subtype(a0),d0
                bpl.s   loc_22FE0
                move.w  #0,x_vel(a1)

loc_22FE0:
                btst    #0,d0
                beq.s   loc_23020
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                btst    #1,d0
                bne.s   loc_23010
                move.b  #1,flips_remaining(a1)

loc_23010:
                btst    #Status_Facing,status(a1)
                beq.s   loc_23020
                neg.b   flip_angle(a1)
                neg.w   ground_vel(a1)

loc_23020:
                andi.b  #$C,d0
                cmpi.b  #4,d0
                bne.s   loc_23036
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)

loc_23036:
                cmpi.b  #8,d0
                bne.s   loc_23048
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

loc_23048:
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
                beq.s   loc_23092
                move.b  status(a0),d1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   loc_23088
                eori.b  #1,d1

loc_23088:
                andi.b  #1,d1
                bne.s   loc_23092
                bsr.w   LaunchPlayerFromHorizontalSpring

loc_23092:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   SolidObjectFull2_1P
                swap    d6
                andi.w  #2,d6
                beq.s   loc_230C4
                move.b  status(a0),d1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   loc_230BA
                eori.b  #1,d1

loc_230BA:
                andi.b  #1,d1
                bne.s   loc_230C4
                bsr.w   LaunchPlayerFromHorizontalSpring

loc_230C4:
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
                beq.s   loc_2311E
                move.b  status(a0),d1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   loc_23116
                eori.b  #1,d1

loc_23116:
                andi.b  #1,d1
                bne.s   loc_2311E
                bsr.s   LaunchPlayerFromSmallHorizontalSpring

loc_2311E:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   SolidObjectFull2_1P
                swap    d6
                andi.w  #2,d6
                beq.s   loc_2314E
                move.b  status(a0),d1
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   loc_23146
                eori.b  #1,d1

loc_23146:
                andi.b  #1,d1
                bne.s   loc_2314E
                bsr.s   LaunchPlayerFromSmallHorizontalSpring

loc_2314E:
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
                bne.s   loc_2318E
                bclr    #Status_Facing,status(a1)
                subi.w  #2*4,x_pos(a1)
                neg.w   x_vel(a1)

loc_2318E:
                bra.s   loc_231BE
; End of function LaunchPlayerFromSmallHorizontalSpring

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromHorizontalSpring:
                move.w  #3<<8,anim(a0)                  ; and prev_anim
                move.w  $30(a0),x_vel(a1)
                addq.w  #8,x_pos(a1)
                bset    #Status_Facing,status(a1)
                btst    #0,status(a0)
                bne.s   loc_231BE
                bclr    #Status_Facing,status(a1)
                subi.w  #2*8,x_pos(a1)
                neg.w   x_vel(a1)

loc_231BE:
                move.w  #$F,$32(a1)
                move.w  x_vel(a1),ground_vel(a1)
                btst    #Status_Roll,status(a1)
                bne.s   loc_231D8
                move.b  #0,anim(a1)

loc_231D8:
                move.b  subtype(a0),d0
                bpl.s   loc_231E4
                move.w  #0,y_vel(a1)

loc_231E4:
                btst    #0,d0
                beq.s   loc_23224
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #1,flips_remaining(a1)
                move.b  #8,flip_speed(a1)
                btst    #1,d0
                bne.s   loc_23214
                move.b  #3,flips_remaining(a1)

loc_23214:
                btst    #Status_Facing,status(a1)
                beq.s   loc_23224
                neg.b   flip_angle(a1)
                neg.w   ground_vel(a1)

loc_23224:
                andi.b  #$C,d0
                cmpi.b  #4,d0
                bne.s   loc_2323A
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)

loc_2323A:
                cmpi.b  #8,d0
                bne.s   loc_2324C
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

loc_2324C:
                bclr    #p1_pushing_bit,status(a0)
                bclr    #p2_pushing_bit,status(a0)
                bclr    #Status_Push,status(a1)
                move.b  #0,double_jump_flag(a1)
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; End of function LaunchPlayerFromHorizontalSpring

; =============== S U B R O U T I N E =======================================

BoostGroundedPlayersNearHorizontalSpring:
                cmpi.b  #3,anim(a0)
                beq.w   locret_23324
                move.w  x_pos(a0),d0
                move.w  d0,d1
                addi.w  #$28,d1
                btst    #0,status(a0)
                beq.s   loc_2328E
                move.w  d0,d1
                subi.w  #$28,d0

loc_2328E:
                move.w  y_pos(a0),d2
                move.w  d2,d3
                subi.w  #$18,d2
                addi.w  #$18,d3
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   loc_232E2
                move.w  ground_vel(a1),d4
                btst    #0,status(a0)
                beq.s   loc_232B6
                neg.w   d4

loc_232B6:
                tst.w   d4
                bmi.s   loc_232E2
                move.w  x_pos(a1),d4
                cmp.w   d0,d4
                blo.w   loc_232E2
                cmp.w   d1,d4
                bhs.w   loc_232E2
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blo.w   loc_232E2
                cmp.w   d3,d4
                bhs.w   loc_232E2
                move.w  d0,-(sp)
                bsr.w   LaunchPlayerFromHorizontalSpring
                move.w  (sp)+,d0

loc_232E2:
                lea     (Player_2).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   locret_23324
                move.w  ground_vel(a1),d4
                btst    #0,status(a0)
                beq.s   loc_232FC
                neg.w   d4

loc_232FC:
                tst.w   d4
                bmi.s   locret_23324
                move.w  x_pos(a1),d4
                cmp.w   d0,d4
                blo.w   locret_23324
                cmp.w   d1,d4
                bhs.w   locret_23324
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blo.w   locret_23324
                cmp.w   d3,d4
                bhs.w   locret_23324
                bsr.w   LaunchPlayerFromHorizontalSpring

locret_23324:
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
                bne.s   loc_2334C
                bsr.s   LaunchPlayerFromDownSpring

loc_2334C:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   SolidObjectFull2_1P
                cmpi.w  #-2,d4
                bne.s   loc_23362
                bsr.s   LaunchPlayerFromDownSpring

loc_23362:
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
                bne.s   loc_2339E
                subq.w  #4,y_pos(a1)
                bsr.s   loc_233DA

loc_2339E:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   SolidObjectFull2_1P
                cmpi.w  #-2,d4
                bne.s   loc_233B8
                subq.w  #4,y_pos(a1)
                bsr.s   loc_233DA

loc_233B8:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromDownSpring:
                subq.w  #8,y_pos(a1)
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_233DA
                addi.w  #2*8,y_pos(a1)

loc_233DA:
                move.w  #1<<8,anim(a0)                  ; and prev_anim
                move.w  $30(a0),y_vel(a1)
                neg.w   y_vel(a1)
                cmpi.w  #$1000,y_vel(a1)
                bne.s   loc_233F8
                move.w  #$D00,y_vel(a1)

loc_233F8:
                move.b  subtype(a0),d0
                bpl.s   loc_23404
                move.w  #0,x_vel(a1)

loc_23404:
                btst    #0,d0
                beq.s   loc_23444
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                btst    #1,d0
                bne.s   loc_23434
                move.b  #1,flips_remaining(a1)

loc_23434:
                btst    #Status_Facing,status(a1)
                beq.s   loc_23444
                neg.b   flip_angle(a1)
                neg.w   ground_vel(a1)

loc_23444:
                andi.b  #$C,d0
                cmpi.b  #4,d0
                bne.s   loc_2345A
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)

loc_2345A:
                cmpi.b  #8,d0
                bne.s   loc_2346C
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

loc_2346C:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                move.b  #2,routine(a1)
                move.b  #0,double_jump_flag(a1)
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; End of function LaunchPlayerFromDownSpring
