; Owner: objects/zones/dez/sk
; Responsibility: Gravity hub player contact, directional control and release
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_DEZGravityHub:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d1
                bsr.s   sub_492D4
                lea     $32(a0),a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2_logical).w,d1
                bsr.s   sub_492D4
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_492D4:
                move.b  (a2),d0
                bne.s   loc_49348
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$20,d0
                cmpi.w  #$40,d0
                bhs.s   locret_49346
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$20,d1
                cmpi.w  #$40,d1
                bhs.s   locret_49346
                btst    #Status_OnObj,status(a1)
                bne.s   locret_49346
                cmpi.b  #6,routine(a1)
                bhs.s   locret_49346
                tst.w   (Debug_placement_mode).w
                bne.s   locret_49346
                bset    #Status_InAir,status(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.w  #0,ground_vel(a1)
                move.w  #0,angle(a1)                    ; and flip_angle
                andi.b  #$FC,render_flags(a1)
                move.w  #1,anim(a1)                     ; and prev_anim
                move.b  #$83,object_control(a1)
                move.b  #1,(a2)

locret_49346:
                rts
; ---------------------------------------------------------------------------

loc_49348:
                cmpi.b  #7,d0
                bhs.w   loc_493F2
                moveq   #8,d1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bpl.s   loc_49360
                neg.w   d0
                neg.w   d1

loc_49360:
                cmpi.w  #8,d0
                bhs.s   loc_49372
                move.w  x_pos(a0),x_pos(a1)
                moveq   #0,d1
                bset    #1,(a2)

loc_49372:
                sub.w   d1,x_pos(a1)
                moveq   #8,d1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                bpl.s   loc_49386
                neg.w   d0
                neg.w   d1

loc_49386:
                cmpi.w  #8,d0
                bhs.s   loc_49398
                move.w  y_pos(a0),y_pos(a1)
                moveq   #0,d1
                bset    #2,(a2)

loc_49398:
                sub.w   d1,y_pos(a1)

loc_4939C:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   loc_493AE
                moveq   #signextendB(sfx_GravityTunnel),d0
                jsr     (Play_SFX).l

loc_493AE:
                moveq   #0,d2
                move.b  1(a2),d2
                addq.b  #1,1(a2)
                cmpi.b  #$60,1(a2)
                blo.s   loc_493C6
                move.b  #0,1(a2)

loc_493C6:
                lsr.w   #2,d2
                move.b  RawAni_493DA(pc,d2.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jmp     (Perform_Player_DPLC).l
; ---------------------------------------------------------------------------
RawAni_493DA:
                dc.b    $34, $35, $36, $37, $38, $39, $3A, $3B, $3C, $31, $32, $33, $76, $77, $6C, $6D, $6E, $6F, $70, $71
                dc.b    $72, $73, $74, $75
                even
; ---------------------------------------------------------------------------

loc_493F2:
                cmpi.b  #8,d0
                beq.s   loc_49430
                and.b   subtype(a0),d1
                beq.s   loc_4939C
                move.b  #8,(a2)
                lea     (word_49420-4).l,a3

loc_49408:
                addq.w  #4,a3
                lsr.b   #1,d1
                bcc.s   loc_49408
                move.w  (a3)+,x_vel(a1)
                move.w  (a3)+,y_vel(a1)
                move.b  #0,object_control(a1)
                bra.w   loc_4939C
; ---------------------------------------------------------------------------
word_49420:
                dc.w    0, -$C00
                dc.w    0,  $C00
                dc.w    -$C00,     0
                dc.w    $C00,     0
; ---------------------------------------------------------------------------

loc_49430:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$20,d0
                cmpi.w  #$40,d0
                bhs.s   loc_49456
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$20,d1
                cmpi.w  #$40,d1
                blo.w   loc_4939C

loc_49456:
                move.w  #0,(a2)
                rts
; End of function sub_492D4
