; Owner: objects/zones/cnz/s3
; Responsibility: Carnival Night wire-cage player capture, spin, motion and release
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_CNZWireCage:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                move.w  d0,$38(a0)
                add.w   d0,d0
                move.w  d0,$3A(a0)
                moveq   #1,d1
                btst    #0,status(a0)
                bne.s   loc_32A8E
                neg.w   d1

loc_32A8E:
                move.w  d1,y_vel(a0)
                move.l  #loc_32A98,(a0)

loc_32A98:
                lea     (Player_1).w,a1
                lea     $30(a0),a2
                moveq   #p1_standing_bit,d6
                move.w  (Ctrl_1_logical).w,d5
                bsr.s   sub_32AFE
                lea     (Player_2).w,a1
                lea     $34(a0),a2
; Bug: if player 1 was riding the object, then d6 may have become dirty from
; a call to Perform_Player_DPLC, causing player 2 to behave erratically
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d5
                bsr.s   sub_32AFE
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$3F,d0
                bne.s   loc_32AF8
                move.w  x_pos(a0),d0
                sub.w   (Camera_X_pos).w,d0
                addi.w  #$40,d0
                cmpi.w  #$1C0,d0
                bhs.s   loc_32AF8
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   $38(a0),d0
                addi.w  #$40,d0
                move.w  $3A(a0),d1
                addi.w  #$80,d1
                cmp.w   d1,d0
                bhs.s   loc_32AF8
                moveq   #signextendB(sfx_WaveHover),d0
                jsr     (Play_SFX).l

loc_32AF8:
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_32AFE:
                btst    d6,status(a0)
                bne.w   loc_32BDA
                tst.b   1(a2)
                beq.s   loc_32B12
                subq.b  #1,1(a2)
                rts
; ---------------------------------------------------------------------------

loc_32B12:
                moveq   #0,d1
                move.b  y_radius(a1),d1
                addi.w  #$44,d1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                add.w   d1,d1
                cmp.w   d1,d0
                bhs.w   locret_32BD8
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   $38(a0),d0
                cmp.w   $3A(a0),d0
                bhs.w   locret_32BD8
                tst.b   object_control(a1)
                bne.w   locret_32BD8
                tst.w   (Debug_placement_mode).w
                bne.w   locret_32BD8
                subi.w  #$10,d0
                bcc.s   loc_32B5C
                sub.w   d0,y_pos(a1)

loc_32B5C:
                btst    #Status_InAir,status(a1)
                beq.w   loc_32B92
                tst.b   angle(a1)
                beq.s   loc_32B86
                bclr    #Status_InAir,status(a1)
                move.w  ground_vel(a1),d0
                bpl.s   loc_32B7A
                neg.w   d0

loc_32B7A:
                cmpi.w  #$400,d0
                bhs.s   loc_32B92
                bset    #Status_InAir,status(a1)

loc_32B86:
                move.b  #1,1(a2)
                bset    #0,object_control(a1)

loc_32B92:
                bsr.w   sub_32E68
                move.b  #$80,(a2)
                move.b  #-$40,angle(a1)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcs.s   loc_32BB4
                move.b  #$40,angle(a1)
                move.b  #0,(a2)

loc_32BB4:
                bclr    #Status_Facing,status(a1)
                bclr    #0,render_flags(a1)
                bclr    #1,render_flags(a1)
                bset    #6,object_control(a1)
                bset    #1,object_control(a1)
                move.b  #0,anim(a1)

locret_32BD8:
                rts
; ---------------------------------------------------------------------------

loc_32BDA:
                tst.b   1(a2)
                bne.w   loc_32D18
                tst.w   (Debug_placement_mode).w
                bne.s   loc_32C48
                move.w  ground_vel(a1),d0
                bpl.s   loc_32BF0
                neg.w   d0

loc_32BF0:
                cmpi.w  #$300,d0
                bhs.s   loc_32C06
                move.b  #1,1(a2)
                bset    #0,object_control(a1)
                bra.w   loc_32D18
; ---------------------------------------------------------------------------

loc_32C06:
                btst    #Status_InAir,status(a1)
                beq.s   loc_32C36
                move.w  #-$800,x_vel(a1)
                move.w  #-$200,y_vel(a1)
                bset    #Status_Facing,status(a1)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcs.s   loc_32C48
                neg.w   x_vel(a1)
                bclr    #Status_Facing,status(a1)
                bra.s   loc_32C48
; ---------------------------------------------------------------------------

loc_32C36:
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   $38(a0),d0
                cmp.w   $3A(a0),d0
                blo.s   loc_32C8A

loc_32C48:
                move.b  #0,angle(a1)
                bclr    #Status_Roll,status(a1)
                move.b  #$13,y_radius(a1)
                move.b  #9,x_radius(a1)
                move.w  #1,anim(a1)                     ; and prev_anim
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                bclr    #6,object_control(a1)
                bclr    #1,object_control(a1)
                andi.w  #drawing_mask,art_tile(a1)
                move.b  #$10,1(a2)
                rts
; ---------------------------------------------------------------------------

loc_32C8A:
                move.w  y_vel(a0),d1
                bpl.s   loc_32C96
                cmpi.w  #$10,d0
                bls.s   loc_32C9A

loc_32C96:
                add.w   d1,y_pos(a1)

loc_32C9A:
                subi.w  #$10,d0
                bcc.s   loc_32CA4
                sub.w   d0,y_pos(a1)

loc_32CA4:
                moveq   #0,d0
                move.b  (a2),d0
                addq.b  #4,(a2)
                jsr     (GetSineCosine).l
                move.w  d1,d3
                asr.w   #2,d1
                add.w   x_pos(a0),d1
                moveq   #0,d0
                move.b  y_radius(a1),d0
                muls.w  d3,d0
                asr.w   #8,d0
                add.w   d0,d1
                move.w  d1,x_pos(a1)
                moveq   #0,d0
                move.b  (a2),d0
                andi.w  #drawing_mask,art_tile(a1)
                cmpi.b  #$80,d0
                blo.s   loc_32CDE
                ori.w   #high_priority,art_tile(a1)

loc_32CDE:
                addi.b  #$40,d0
                neg.b   d0
                andi.w  #$FF,d0
                divu.w  #$B,d0
                move.b  RawAni_32D00(pc,d0.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jmp     (Perform_Player_DPLC).l
; ---------------------------------------------------------------------------
; unused
                rts
; ---------------------------------------------------------------------------
RawAni_32D00:
                dc.b    $76, $76, $77, $77, $6C, $6C, $6D, $6D, $6E, $6E, $6F, $6F, $70, $70, $71, $71, $72, $72, $73, $73
                dc.b    $74, $74, $75, $75
                even
; ---------------------------------------------------------------------------

loc_32D18:
                tst.w   (Debug_placement_mode).w
                bne.s   loc_32D9C
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d5
                beq.s   loc_32D58
                bset    #Status_InAir,status(a1)
                move.b  #0,jumping(a1)
                move.w  #-$800,x_vel(a1)
                move.w  #-$200,y_vel(a1)
                bset    #Status_Facing,status(a1)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcs.s   loc_32D9C
                neg.w   x_vel(a1)
                bclr    #Status_Facing,status(a1)
                bra.s   loc_32D9C
; ---------------------------------------------------------------------------

loc_32D58:
                btst    #Status_InAir,status(a1)
                bne.s   loc_32D9C
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                add.w   $38(a0),d0
                cmp.w   $3A(a0),d0
                blo.s   loc_32DE4
                bne.s   loc_32D9C
                move.b  (a2),d0
                andi.b  #$7F,d0
                bne.s   loc_32DF4
                move.w  #-$100,x_vel(a1)
                move.w  #0,y_vel(a1)
                tst.b   (a2)
                bmi.s   loc_32D90
                neg.w   x_vel(a1)

loc_32D90:
                move.w  x_vel(a1),ground_vel(a1)
                bset    #Status_InAir,status(a1)

loc_32D9C:
                move.b  #0,angle(a1)
                bclr    #Status_Roll,status(a1)
                move.b  #$13,y_radius(a1)
                move.b  #9,x_radius(a1)
                move.w  #1,anim(a1)                     ; and prev_anim
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                bclr    #6,object_control(a1)
                bclr    #1,object_control(a1)
                bclr    #0,object_control(a1)
                andi.w  #drawing_mask,art_tile(a1)
                move.b  #$10,1(a2)
                rts
; ---------------------------------------------------------------------------

loc_32DE4:
                move.w  y_vel(a0),d1
                bpl.s   loc_32DF0
                cmpi.w  #$10,d0
                bls.s   loc_32DF4

loc_32DF0:
                add.w   d1,y_pos(a1)

loc_32DF4:
                moveq   #0,d0
                move.b  (a2),d0
                addq.b  #4,(a2)
                jsr     (GetSineCosine).l
                move.w  d1,d3
                asr.w   #2,d1
                add.w   x_pos(a0),d1
                moveq   #0,d0
                move.b  y_radius(a1),d0
                muls.w  d3,d0
                asr.w   #8,d0
                add.w   d0,d1
                move.w  d1,x_pos(a1)
                moveq   #0,d0
                move.b  (a2),d0
                andi.w  #drawing_mask,art_tile(a1)
                cmpi.b  #$80,d0
                blo.s   loc_32E2E
                ori.w   #high_priority,art_tile(a1)

loc_32E2E:
                addi.b  #$40,d0
                neg.b   d0
                andi.w  #$FF,d0
                divu.w  #$B,d0
                move.b  RawAni_32E50(pc,d0.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jmp     (Perform_Player_DPLC).l
; End of function sub_32AFE

; ---------------------------------------------------------------------------
; unused
                rts
; ---------------------------------------------------------------------------
RawAni_32E50:
                dc.b    $5E, $5E, $5E, $5F, $5F, $5F, $5F, $60, $60, $60, $60, $60, $61, $61, $61, $61, $5C, $5C, $5C, $5C
                dc.b    $5D, $5D, $5D, $5D
                even

; =============== S U B R O U T I N E =======================================

sub_32E68:
                btst    #Status_OnObj,status(a1)
                beq.s   loc_32E78
                movea.w interact(a1),a3
                bclr    d6,status(a3)

loc_32E78:
                move.w  a0,interact(a1)
                btst    #Status_InAir,status(a1)
                beq.s   loc_32EAE
                move.w  #0,x_vel(a1)
                move.l  a0,-(sp)
                movea.l a1,a0
                move.w  a0,d1
                subi.w  #Player_1,d1
                bne.s   loc_32EA6
                cmpi.w  #2,(Player_mode).w
                beq.s   loc_32EA6
                jsr     (Player_TouchFloor).l
                bra.s   loc_32EAC
; ---------------------------------------------------------------------------

loc_32EA6:
                jsr     (Tails_TouchFloor).l

loc_32EAC:
                movea.l (sp)+,a0

loc_32EAE:
                bset    #Status_OnObj,status(a1)
                bclr    #Status_InAir,status(a1)
                bset    d6,status(a0)
                rts
; End of function sub_32E68
