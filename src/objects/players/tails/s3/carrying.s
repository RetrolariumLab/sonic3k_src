; Owner: objects/players/tails/s3
; Responsibility: Sonic carrying attachment, release input, relative position checks and carry-coordinate synchronization
; Source provenance and ranges: config/reconstruction/source_layout.json
Tails_Carry_Sonic:
                tst.b   (a2)
                beq.w   loc_151A2
                cmpi.b  #4,routine(a1)
                bhs.w   loc_150EC
                btst    #Status_InAir,status(a1)
                beq.w   loc_150E0
                move.w  (_unkF744).w,d1
                cmp.w   x_vel(a1),d1
                bne.s   loc_150E0
                move.w  (_unkF74C).w,d1
                cmp.w   y_vel(a1),d1
                bne.s   loc_150E6
                tst.b   object_control(a1)
                bmi.s   loc_150F0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_150FA
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$12,1(a2)
                andi.w  #(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
                beq.w   loc_15096
                move.b  #$3C,1(a2)

loc_15096:
                btst    #button_left+8,d0
                beq.s   loc_150A2
                move.w  #-$200,x_vel(a1)

loc_150A2:
                btst    #button_right+8,d0
                beq.s   loc_150AE
                move.w  #$200,x_vel(a1)

loc_150AE:
                move.w  #-$380,y_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                rts
; ---------------------------------------------------------------------------

loc_150E0:
                move.w  #-$100,y_vel(a1)

loc_150E6:
                move.b  #0,jumping(a1)

loc_150EC:
                clr.b   object_control(a1)

loc_150F0:
                clr.b   (a2)
                move.b  #$3C,1(a2)
                rts
; ---------------------------------------------------------------------------

loc_150FA:
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$1C,y_pos(a1)
                andi.b  #$FC,render_flags(a1)
                andi.b  #$FE,status(a1)
                move.b  status(a0),d0
                andi.b  #1,d0
                or.b    d0,render_flags(a1)
                or.b    d0,status(a1)
                subq.b  #1,anim_frame_timer(a1)
                bpl.s   loc_15166
                move.b  #$B,anim_frame_timer(a1)
                moveq   #0,d1
                move.b  anim_frame(a1),d1
                addq.b  #1,anim_frame(a1)
                move.b  AniRaw_Tails_Carry(pc,d1.w),d0
                cmpi.b  #-1,d0
                bne.s   loc_15152
                move.b  #0,anim_frame(a1)
                move.b  AniRaw_Tails_Carry(pc),d0

loc_15152:
                move.b  d0,mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2

loc_15166:
                move.w  x_vel(a0),(Player_1+x_vel).w
                move.w  x_vel(a0),(_unkF744).w
                move.w  y_vel(a0),(Player_1+y_vel).w
                move.w  y_vel(a0),(_unkF74C).w
                movem.l d0-a6,-(sp)
                lea     (Player_1).w,a0
                bsr.w   Sonic_DoLevelCollision
                movem.l (sp)+,d0-a6
                rts
; ---------------------------------------------------------------------------
AniRaw_Tails_Carry:
                dc.b    $91, $91, $90, $90, $90, $90, $90, $90, $92, $92, $92, $92, $92, $92, $91, $91, $FF
                even
; ---------------------------------------------------------------------------

loc_151A2:
                tst.b   1(a2)
                beq.s   loc_151B0
                subq.b  #1,1(a2)
                bne.w   locret_15200

loc_151B0:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   locret_15200
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                subi.w  #$20,d1
                cmpi.w  #$10,d1
                bhs.w   locret_15200
                tst.b   object_control(a1)
                bne.s   locret_15200
                cmpi.b  #4,routine(a1)
                bhs.s   locret_15200
                tst.w   (Debug_placement_mode).w
                bne.s   locret_15200
                tst.b   spin_dash_flag(a1)
                bne.s   locret_15200
                bsr.s   TailsS3InitializeCarriedPlayerAttachment
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l
                move.b  #1,(a2)

locret_15200:
                rts
; End of function Tails_Carry_Sonic

; =============== S U B R O U T I N E =======================================

TailsS3InitializeCarriedPlayerAttachment:
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                clr.w   angle(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$1C,y_pos(a1)
                move.w  #$22<<8,anim(a1)                ; and prev_anim
                move.b  #0,anim_frame_timer(a1)
                move.b  #0,anim_frame(a1)
                move.b  #3,object_control(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,spin_dash_flag(a1)
                andi.b  #$FC,render_flags(a1)
                andi.b  #$FE,status(a1)
                move.b  status(a0),d0
                andi.b  #1,d0
                or.b    d0,render_flags(a1)
                or.b    d0,status(a1)
                move.w  x_vel(a0),(_unkF744).w
                move.w  x_vel(a0),x_vel(a1)
                move.w  y_vel(a0),(_unkF74C).w
                move.w  y_vel(a0),y_vel(a1)
                rts
; End of function TailsS3InitializeCarriedPlayerAttachment

; =============== S U B R O U T I N E =======================================
