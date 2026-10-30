; Owner: objects/shared/springs/sk
; Responsibility: Diagonal spring collision, launch response, surface profiles and shared spring animation and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_Spring_UpDiag:
                move.w  #$1B,d1
                move.w  #$10,d2
                move.w  x_pos(a0),d4
                lea     byte_236EA(pc),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.w   sub_1DD24
                btst    #p1_standing_bit,status(a0)
                beq.s   loc_234B8
                bsr.s   sub_234E6

loc_234B8:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   sub_1DD24
                btst    #p2_standing_bit,status(a0)
                beq.s   loc_234D0
                bsr.s   sub_234E6

loc_234D0:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                move.w  $32(a0),d0
                jmp     (Sprite_OnScreen_Test2).l

; =============== S U B R O U T I N E =======================================

sub_234E6:
                btst    #0,status(a0)
                bne.s   loc_234FC
                move.w  x_pos(a0),d0
                subq.w  #4,d0
                cmp.w   x_pos(a1),d0
                blo.s   loc_2350A
                rts
; ---------------------------------------------------------------------------

loc_234FC:
                move.w  x_pos(a0),d0
                addq.w  #4,d0
                cmp.w   x_pos(a1),d0
                bhs.s   loc_2350A
                rts
; ---------------------------------------------------------------------------

loc_2350A:
                move.w  #5<<8,anim(a0)                  ; and prev_anim
                move.w  $30(a0),y_vel(a1)
                move.w  $30(a0),x_vel(a1)
                addq.w  #6,y_pos(a1)
                addq.w  #6,x_pos(a1)
                bset    #Status_Facing,status(a1)
                btst    #0,status(a0)
                bne.s   loc_23542
                bclr    #Status_Facing,status(a1)
                subi.w  #2*6,x_pos(a1)
                neg.w   x_vel(a1)

loc_23542:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                move.b  #$10,anim(a1)
                move.b  #2,routine(a1)
                move.b  subtype(a0),d0
                btst    #0,d0
                beq.s   loc_235A2
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #1,flips_remaining(a1)
                move.b  #8,flip_speed(a1)
                btst    #1,d0
                bne.s   loc_23592
                move.b  #3,flips_remaining(a1)

loc_23592:
                btst    #Status_Facing,status(a1)
                beq.s   loc_235A2
                neg.b   flip_angle(a1)
                neg.w   ground_vel(a1)

loc_235A2:
                andi.b  #$C,d0
                cmpi.b  #4,d0
                bne.s   loc_235B8
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)

loc_235B8:
                cmpi.b  #8,d0
                bne.s   loc_235CA
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

loc_235CA:
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; End of function sub_234E6

; ---------------------------------------------------------------------------

Obj_Spring_DownDiag:
                move.w  #$1B,d1
                move.w  #$10,d2
                move.w  x_pos(a0),d4
                lea     byte_23706(pc),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.w   sub_1DD24
                cmpi.w  #-2,d4
                bne.s   loc_235F8
                bsr.s   sub_23624

loc_235F8:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   sub_1DD24
                cmpi.w  #-2,d4
                bne.s   loc_2360E
                bsr.s   sub_23624

loc_2360E:
                lea     (Ani_Spring).l,a1
                jsr     (Animate_Sprite).l
                move.w  $32(a0),d0
                jmp     (Sprite_OnScreen_Test2).l

; =============== S U B R O U T I N E =======================================

sub_23624:
                move.w  #5<<8,anim(a0)                  ; and prev_anim
                move.w  $30(a0),y_vel(a1)
                neg.w   y_vel(a1)
                move.w  $30(a0),x_vel(a1)
                subq.w  #6,y_pos(a1)
                addq.w  #6,x_pos(a1)
                bset    #Status_Facing,status(a1)
                btst    #0,status(a0)
                bne.s   loc_23660
                bclr    #Status_Facing,status(a1)
                subi.w  #2*6,x_pos(a1)
                neg.w   x_vel(a1)

loc_23660:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                move.b  #2,routine(a1)
                move.b  subtype(a0),d0
                btst    #0,d0
                beq.s   loc_236BA
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #1,flips_remaining(a1)
                move.b  #8,flip_speed(a1)
                btst    #1,d0
                bne.s   loc_236AA
                move.b  #3,flips_remaining(a1)

loc_236AA:
                btst    #Status_Facing,status(a1)
                beq.s   loc_236BA
                neg.b   flip_angle(a1)
                neg.w   ground_vel(a1)

loc_236BA:
                andi.b  #$C,d0
                cmpi.b  #4,d0
                bne.s   loc_236D0
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)

loc_236D0:
                cmpi.b  #8,d0
                bne.s   loc_236E2
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

loc_236E2:
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; End of function sub_23624

; ---------------------------------------------------------------------------
byte_236EA:
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $E
                dc.b    $C
                dc.b    $A
                dc.b    8
                dc.b    6
                dc.b    4
                dc.b    2
                dc.b    0
                dc.b    -2
                dc.b    -4
                dc.b    -4
                dc.b    -4
                dc.b    -4
                dc.b    -4
                dc.b    -4
                dc.b    -4
byte_23706:
                dc.b    -$C
                dc.b    -$10
                dc.b    -$10
                dc.b    -$10
                dc.b    -$10
                dc.b    -$10
                dc.b    -$10
                dc.b    -$10
                dc.b    -$10
                dc.b    -$10
                dc.b    -$10
                dc.b    -$10
                dc.b    -$E
                dc.b    -$C
                dc.b    -$A
                dc.b    -8
                dc.b    -6
                dc.b    -4
                dc.b    -2
                dc.b    0
                dc.b    2
                dc.b    4
                dc.b    4
                dc.b    4
                dc.b    4
                dc.b    4
                dc.b    4
                dc.b    4
                even
Ani_Spring:
                include "src/objects/shared/level_misc/anim_spring.s"
Map_Spring:
                include "src/objects/shared/level_misc/map_spring.s"
Map_2PSpring:
                include "src/objects/shared/level_misc/map_2p_spring.s"
