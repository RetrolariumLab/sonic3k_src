; Owner: objects/zones/dez/sk
; Responsibility: Gravity tube player capture, constrained transport and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZGravityTube:
                move.b  subtype(a0),d0
                bpl.s   loc_48EC8
                andi.w  #$3F,d0
                lsl.w   #3,d0
                move.w  d0,$30(a0)
                move.l  #loc_4906A,(a0)
                bra.w   loc_4906A
; ---------------------------------------------------------------------------

loc_48EC8:
                andi.w  #$3F,d0
                lsl.w   #3,d0
                move.w  d0,$30(a0)
                move.w  #$20,d0
                btst    #6,subtype(a0)
                beq.s   loc_48EE2
                move.w  #$60,d0

loc_48EE2:
                move.w  d0,$32(a0)
                move.l  #loc_48EEC,(a0)

loc_48EEC:
                move.w  $30(a0),d4
                move.w  d4,d5
                add.w   d5,d5
                lea     (Player_1).w,a1
                lea     (_unkF7B0+0).w,a2
                moveq   #p1_standing_bit,d6
                bsr.s   UpdatePlayerInDezHorizontalGravityTube
                lea     (Player_2).w,a1
                lea     (_unkF7B0+1).w,a2
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                bsr.s   UpdatePlayerInDezHorizontalGravityTube
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerInDezHorizontalGravityTube:
                btst    d6,status(a0)
                bne.w   loc_48FA4
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d4,d0
                cmp.w   d5,d0
                bhs.w   locret_48F8E
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                move.w  $32(a0),d0
                add.w   d0,d1
                add.w   d0,d0
                cmp.w   d0,d1
                bhs.w   locret_48F8E
                cmpi.b  #6,routine(a1)
                bhs.s   locret_48F8E
                tst.w   (Debug_placement_mode).w
                bne.s   locret_48F8E
                move.w  d1,-(sp)
                jsr     (RideObject_SetRide).l
                move.w  (sp)+,d1
                lsr.w   #3,d1
                btst    #6,subtype(a0)
                beq.s   loc_48F6A
                lsr.w   #1,d1
                move.b  byte_48F98(pc,d1.w),d1
                bra.s   loc_48F6E
; ---------------------------------------------------------------------------

loc_48F6A:
                move.b  byte_48F90(pc,d1.w),d1

loc_48F6E:
                move.b  d1,(a2)
                move.b  #0,2(a2)
                move.b  #$80,flip_type(a1)
                move.w  #1,anim(a1)
                tst.w   ground_vel(a1)
                bne.s   locret_48F8E
                move.w  #1,ground_vel(a1)

locret_48F8E:
                rts
; ---------------------------------------------------------------------------
byte_48F90:
                dc.b    $80, $80, $80, $40, $40,   0,   0,   0
byte_48F98:
                dc.b    $80, $80, $70, $60, $50, $40, $40, $30, $20, $10,   0,   0
                even
; ---------------------------------------------------------------------------

loc_48FA4:
                btst    #Status_InAir,status(a1)
                bne.s   loc_48FF6
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d4,d0
                cmp.w   d5,d0
                blo.s   loc_48FFE

loc_48FBA:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                bset    #Status_InAir,status(a1)
                tst.b   (Reverse_gravity_flag).w
                beq.s   locret_48FF4
                move.b  flip_angle(a1),d0
                addi.b  #$40,d0
                neg.b   d0
                subi.b  #$40,d0
                move.b  d0,flip_angle(a1)
                eori.b  #2,render_flags(a1)

locret_48FF4:
                rts
; ---------------------------------------------------------------------------

loc_48FF6:
                move.w  #0,y_vel(a1)
                bra.s   loc_48FBA
; ---------------------------------------------------------------------------

loc_48FFE:
                btst    #Status_OnObj,status(a1)
                beq.s   locret_48F8E
                move.b  (a2),d0
                jsr     (GetSineCosine).l
                moveq   #8,d3
                move.w  #$1000,d0
                btst    #6,subtype(a0)
                beq.s   loc_49022
                move.w  #$5000,d0
                moveq   #4,d3

loc_49022:
                muls.w  d0,d1
                swap    d1
                move.w  y_pos(a0),d2
                add.w   d1,d2
                move.w  d2,y_pos(a1)
                move.b  (a2),d0
                move.b  d0,flip_angle(a1)
                add.b   d3,(a2)
                tst.w   ground_vel(a1)
                bne.s   loc_4904A
                move.w  #1,ground_vel(a1)
                move.w  #1,anim(a1)                     ; and prev_anim

loc_4904A:
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_49056
                eori.b  #2,render_flags(a1)

loc_49056:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   locret_49068
                moveq   #signextendB(sfx_GravityTunnel),d0
                jsr     (Play_SFX).l

locret_49068:
                rts
; End of function UpdatePlayerInDezHorizontalGravityTube

; ---------------------------------------------------------------------------

loc_4906A:
                move.w  $30(a0),d4
                move.w  d4,d5
                add.w   d5,d5
                lea     (Player_1).w,a1
                lea     (_unkF7B0+0).w,a2
                moveq   #p1_standing_bit,d6
                bsr.s   UpdatePlayerInDezVerticalGravityTube
                lea     (Player_2).w,a1
                lea     (_unkF7B0+1).w,a2
; Bug: if player 1 was riding the object, then d6 may have become dirty from
; a call to Perform_Player_DPLC, causing player 2 to behave erratically
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                bsr.s   UpdatePlayerInDezVerticalGravityTube
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerInDezVerticalGravityTube:
                btst    d6,status(a0)
                bne.w   loc_49142
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$20,d0
                cmpi.w  #$40,d0
                bhs.w   locret_49140
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                add.w   d4,d1
                cmp.w   d5,d1
                bhs.w   locret_49140
                cmpi.b  #6,routine(a1)
                bhs.w   locret_49140
                tst.w   (Debug_placement_mode).w
                bne.w   locret_49140
                tst.b   object_control(a1)
                bmi.s   locret_49140
                move.w  d0,-(sp)
                jsr     (AttachPlayerToScriptedRideObject).l
                move.w  (sp)+,d1
                move.b  #-$40,angle(a1)
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                move.b  #0,(a2)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcc.s   loc_49102
                move.b  #$80,(a2)

loc_49102:
                move.w  y_vel(a1),ground_vel(a1)
                neg.w   ground_vel(a1)
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                bcc.s   loc_49120
                move.b  #$40,angle(a1)
                neg.w   ground_vel(a1)

loc_49120:
                bset    #6,object_control(a1)
                bset    #1,object_control(a1)
                move.w  #1,anim(a1)
                move.b  #0,flip_angle(a1)
                move.b  #0,2(a2)
                bra.s   loc_49142
; ---------------------------------------------------------------------------

locret_49140:
                rts
; ---------------------------------------------------------------------------

loc_49142:
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                add.w   d4,d1
                cmp.w   d5,d1
                blo.s   loc_4917A
                move.b  #0,object_control(a1)
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #1,flip_angle(a1)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                bset    #Status_InAir,status(a1)
                rts
; ---------------------------------------------------------------------------

loc_4917A:
                btst    #Status_OnObj,status(a1)
                beq.s   locret_49140
                bclr    #1,render_flags(a1)
                tst.w   y_vel(a1)
                bmi.s   loc_49194
                bset    #1,render_flags(a1)

loc_49194:
                move.b  (a2),d0
                jsr     (GetSineCosine).l
                muls.w  #$1000,d1
                swap    d1
                move.w  x_pos(a0),d2
                add.w   d1,d2
                move.w  d2,x_pos(a1)
                moveq   #0,d2
                move.b  (a2),d2
                addq.b  #8,(a2)
                divu.w  #$B,d2
                move.b  RawAni_491DA(pc,d2.w),mapping_frame(a1)
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   loc_491CE
                moveq   #signextendB(sfx_GravityTunnel),d0
                jsr     (Play_SFX).l

loc_491CE:
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jmp     (Perform_Player_DPLC).l
; End of function UpdatePlayerInDezVerticalGravityTube

; ---------------------------------------------------------------------------
RawAni_491DA:
                dc.b    $6D, $6D, $6E, $6E, $6F, $6F, $70, $70, $71, $71, $72, $72, $73, $73, $74, $74, $75, $75, $76, $76
                dc.b    $77, $77, $6C, $6C, $6D, $6D
                even
