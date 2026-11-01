; Owner: objects/zones/soz/sk
; Responsibility: Quicksand player detection, sinking, movement control and related sand states
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SOZQuicksand:
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.w  #$3F,d0
                lsl.w   #3,d0
                move.w  d0,$30(a0)
                add.w   d0,d0
                move.w  d0,$32(a0)
                move.b  subtype(a0),d0
                andi.b  #$C0,d0
                cmpi.b  #$40,d0
                bne.s   loc_3FD02
                move.l  #loc_3FE44,(a0)
                bra.w   loc_3FE44
; ---------------------------------------------------------------------------

loc_3FD02:
                cmpi.b  #$80,d0
                bne.s   loc_3FD12
                move.l  #loc_3FF80,(a0)
                bra.w   loc_3FF80
; ---------------------------------------------------------------------------

loc_3FD12:
                cmpi.b  #-$40,d0
                bne.s   loc_3FD22
                move.l  #loc_400CA,(a0)
                bra.w   loc_400CA
; ---------------------------------------------------------------------------

loc_3FD22:
                move.l  #loc_3FD28,(a0)

loc_3FD28:
                move.w  $30(a0),d2
                move.w  $32(a0),d3
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                move.w  (Ctrl_1_logical).w,d5
                bsr.s   UpdatePlayerInSozVerticalSandFlow
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d5
                bsr.s   UpdatePlayerInSozVerticalSandFlow
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerInSozVerticalSandFlow:
                btst    d6,status(a0)
                bne.s   loc_3FDD0
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   locret_3FDCE
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   d2,d0
                cmp.w   d3,d0
                bhs.s   locret_3FDCE
                btst    #Status_InAir,status(a1)
                beq.s   locret_3FDCE
                btst    #Status_OnObj,status(a1)
                bne.s   locret_3FDCE
                cmpi.b  #4,routine(a1)
                bhs.s   locret_3FDCE
                tst.b   object_control(a1)
                bne.s   locret_3FDCE
                bset    #Status_OnObj,status(a1)
                bset    d6,status(a0)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,jumping(a1)
                asr     y_vel(a1)
                asr     x_vel(a1)

locret_3FDCE:
                rts
; ---------------------------------------------------------------------------

loc_3FDD0:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   loc_3FDF8
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   d2,d0
                cmp.w   d3,d0
                bhs.s   loc_3FDF8
                btst    #Status_InAir,status(a1)
                bne.s   loc_3FE04

loc_3FDF8:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                rts
; ---------------------------------------------------------------------------

loc_3FE04:
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d5
                beq.s   loc_3FE18
                move.w  #-$800,y_vel(a1)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l

loc_3FE18:
                tst.w   y_vel(a1)
                bpl.s   loc_3FE2A
                asr     x_vel(a1)
                addi.w  #$68,y_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_3FE2A:
                asr     x_vel(a1)
                move.w  #$A8,y_vel(a1)
                btst    #1,status(a0)
                beq.s   locret_3FE42
                move.w  #-$198,y_vel(a1)

locret_3FE42:
                rts
; End of function UpdatePlayerInSozVerticalSandFlow

; ---------------------------------------------------------------------------

loc_3FE44:
                move.w  $30(a0),d2
                move.w  $32(a0),d3
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                move.w  (Ctrl_1_logical).w,d5
                bsr.s   UpdatePlayerOnSozHorizontalSandFlow
                addq.w  #1,a2
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d5
                bsr.s   UpdatePlayerOnSozHorizontalSandFlow
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnSozHorizontalSandFlow:
                tst.b   (a2)
                beq.s   loc_3FE78
                subq.b  #1,(a2)
                rts
; ---------------------------------------------------------------------------

loc_3FE78:
                btst    d6,status(a0)
                bne.w   loc_3FF02
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d2,d0
                cmp.w   d3,d0
                bhs.s   locret_3FF00
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   locret_3FF00
                btst    #Status_InAir,status(a1)
                beq.s   locret_3FF00
                btst    #Status_OnObj,status(a1)
                bne.s   locret_3FF00
                cmpi.b  #4,routine(a1)
                bhs.s   locret_3FF00
                tst.b   object_control(a1)
                bne.s   locret_3FF00
                tst.w   y_vel(a1)
                bmi.s   locret_3FF00
                bset    #Status_OnObj,status(a1)
                bset    d6,status(a0)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,jumping(a1)
                asr     y_vel(a1)
                asr     x_vel(a1)

locret_3FF00:
                rts
; ---------------------------------------------------------------------------

loc_3FF02:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d2,d0
                cmp.w   d3,d0
                bhs.s   loc_3FF2A
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   loc_3FF2A
                btst    #Status_InAir,status(a1)
                bne.s   loc_3FF3C

loc_3FF2A:
                move.w  #0,y_vel(a1)
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                rts
; ---------------------------------------------------------------------------

loc_3FF3C:
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d5
                beq.s   loc_3FF60
                move.w  #$400,y_vel(a1)
                move.b  #$1E,(a2)
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_3FF60:
                move.w  #0,y_vel(a1)
                asr     x_vel(a1)
                move.l  #$B000,d0
                btst    #0,status(a0)
                beq.s   loc_3FF7A
                neg.l   d0

loc_3FF7A:
                add.l   d0,x_pos(a1)
                rts
; End of function UpdatePlayerOnSozHorizontalSandFlow

; ---------------------------------------------------------------------------

loc_3FF80:
                move.w  $30(a0),d2
                move.w  $32(a0),d3
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   loc_3FF9E
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.s   loc_3FF9E
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_3FF9E:
                btst    d6,status(a0)
                bne.w   loc_40042
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$20,d0
                cmpi.w  #$40,d0
                bhs.w   locret_40040
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   d2,d0
                cmp.w   d3,d0
                bhs.w   locret_40040
                btst    #Status_OnObj,status(a1)
                bne.w   locret_40040
                cmpi.b  #4,routine(a1)
                bhs.s   locret_40040
                tst.b   object_control(a1)
                bne.s   locret_40040
                btst    #1,status(a0)
                bne.s   loc_3FFF2
                btst    #Status_InAir,status(a1)
                beq.s   locret_40040

loc_3FFF2:
                bset    #Status_InAir,status(a1)
                bset    #Status_OnObj,status(a1)
                bset    d6,status(a0)
                bclr    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,jumping(a1)
                moveq   #1,d6
                move.w  #1,ground_vel(a1)
                tst.b   flip_angle(a1)
                bne.s   locret_40040
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #$7F,flips_remaining(a1)
                move.b  #8,flip_speed(a1)

locret_40040:
                rts
; ---------------------------------------------------------------------------

loc_40042:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$20,d0
                cmpi.w  #$40,d0
                bhs.s   loc_40078
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   d2,d0
                cmp.w   d3,d0
                bhs.s   loc_40078
                tst.b   object_control(a1)
                bne.s   loc_40078
                cmpi.b  #4,routine(a1)
                bhs.s   loc_40078
                btst    #Status_InAir,status(a1)
                bne.s   loc_40084

loc_40078:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                rts
; ---------------------------------------------------------------------------

loc_40084:
                move.b  #$7F,flips_remaining(a1)
                tst.w   y_vel(a1)
                bpl.s   loc_400A6
                addi.w  #$68,y_vel(a1)
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   locret_400A4
                asr     x_vel(a1)

locret_400A4:
                rts
; ---------------------------------------------------------------------------

loc_400A6:
                move.w  #$A8,y_vel(a1)
                btst    #1,status(a0)
                beq.s   loc_400BA
                move.w  #-$330,y_vel(a1)

loc_400BA:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   locret_400C8
                asr     x_vel(a1)

locret_400C8:
                rts
; ---------------------------------------------------------------------------

loc_400CA:
                move.w  $30(a0),d2
                move.w  $32(a0),d3
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                move.w  (Ctrl_1_logical).w,d5
                bsr.s   UpdatePlayerOnJumpableSozSandSurface
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d5
                bsr.s   UpdatePlayerOnJumpableSozSandSurface
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnJumpableSozSandSurface:
                btst    d6,status(a0)
                bne.w   loc_401AC
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d2,d0
                cmp.w   d3,d0
                bhs.w   locret_401A2
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$33,d0
                cmpi.w  #$40,d0
                bhs.w   locret_401A2
                btst    #Status_InAir,status(a1)
                beq.s   locret_401A2
                btst    #Status_OnObj,status(a1)
                bne.s   locret_401A2
                cmpi.b  #6,routine(a1)
                bhs.s   locret_401A2
                tst.b   object_control(a1)
                bne.s   locret_401A2
                tst.w   y_vel(a1)
                bmi.s   loc_401A4
                bset    #Status_OnObj,status(a1)
                bset    d6,status(a0)
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                bclr    #Status_Roll,status(a1)
                bclr    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,anim(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,jumping(a1)
                asr     x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                asr     y_vel(a1)
                cmpi.b  #2,routine(a1)
                beq.s   locret_401A2
                move.b  #2,routine(a1)
                move.b  #2*60,invulnerability_timer(a1)
                move.b  #0,spin_dash_flag(a1)

locret_401A2:
                rts
; ---------------------------------------------------------------------------

loc_401A4:
                addi.w  #$68,y_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_401AC:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d2,d0
                cmp.w   d3,d0
                bhs.s   loc_401DA
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$33,d0
                cmpi.w  #$40,d0
                bhs.s   loc_401DA
                tst.b   object_control(a1)
                bne.s   loc_401DA
                btst    #Status_InAir,status(a1)
                bne.s   loc_401E6

loc_401DA:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                rts
; ---------------------------------------------------------------------------

loc_401E6:
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d5
                beq.s   loc_4023E
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.w  #-$680,y_vel(a1)
                cmpi.b  #2,character_id(a1)
                bne.s   loc_4020A
                move.w  #-$600,y_vel(a1)

loc_4020A:
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #1,jumping(a1)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_4023E:
                tst.w   y_vel(a1)
                bpl.s   loc_40256
                asr     x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                addi.w  #$68,y_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_40256:
                asr     x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                move.w  #$A8,y_vel(a1)
                btst    #1,status(a0)
                beq.s   locret_40274
                move.w  #-$198,y_vel(a1)

locret_40274:
                rts
; End of function UpdatePlayerOnJumpableSozSandSurface
