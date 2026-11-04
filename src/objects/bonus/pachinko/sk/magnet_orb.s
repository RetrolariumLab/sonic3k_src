; Owner: objects/bonus/pachinko/sk
; Responsibility: Pachinko magnet orb player attraction, capture, motion and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_PachinkoMagnetOrb:
                move.l  #Map_PachinkoFItem,mappings(a0)
                move.w  #make_art_tile(ArtTile_PachinkoMain+$AB,3,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.l  #loc_4A408,(a0)

loc_4A408:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d1
                bsr.s   PachinkoMagnet_UpdatePlayer
                addq.w  #1,a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2_logical).w,d1
                bsr.s   PachinkoMagnet_UpdatePlayer
                jmp     (loc_49B4E).l

; =============== S U B R O U T I N E =======================================

; Capture an eligible player, move it through the oscillation and launch by phase on jump. Then enforce recapture cooldown
PachinkoMagnet_UpdatePlayer:
                tst.b   (a2)
                beq.w   loc_4A53A
                tst.w   (Debug_placement_mode).w
                bne.w   loc_4A4F0
                cmpi.b  #4,routine(a1)
                bhs.w   loc_4A4F0
                tst.b   object_control(a1)
                bmi.w   loc_4A4F6
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d1
                bne.w   loc_4A4B4
                btst    #button_left+8,d1
                beq.s   loc_4A45A
                subq.b  #1,6(a2)

loc_4A45A:
                btst    #button_right+8,d1
                beq.s   loc_4A464
                addq.b  #1,6(a2)

loc_4A464:
                move.w  x_pos(a1),d1
                move.w  y_pos(a1),d2
                movem.l d1-d2,-(sp)
                bsr.w   PachinkoMagnet_PositionCapturedPlayer
                movem.l (sp)+,d1-d2
                sub.w   x_pos(a1),d1
                asl.w   #8,d1
                neg.w   d1
                move.w  d1,x_vel(a1)
                sub.w   y_pos(a1),d2
                asl.w   #8,d2
                neg.w   d2
                move.w  d2,y_vel(a1)
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   locret_4A4A2
                moveq   #signextendB(sfx_WaveHover),d0
                jsr     (Play_SFX).l

locret_4A4A2:
                rts
; ---------------------------------------------------------------------------
byte_4A4A4:
                dc.b    $20, $20, $20, $30, $40, $50, $60, $60, $60, $A0, $A0, $B0, $C0, $D0, $E0, $E0
                even
; ---------------------------------------------------------------------------

loc_4A4B4:
                moveq   #0,d1
                move.b  4(a2),d0
                move.b  d0,d1
                lsr.w   #4,d1
                move.b  byte_4A4A4(pc,d1.w),d1
                andi.b  #$F,d0
                or.b    d1,d0
                jsr     (GetSineCosine).l
                muls.w  #$C,d0
                move.w  d0,d2
                move.b  6(a2),d0
                jsr     (GetSineCosine).l
                muls.w  d2,d0
                muls.w  d2,d1
                asr.l   #8,d0
                asr.l   #8,d1
                move.w  d0,x_vel(a1)
                neg.w   d1
                move.w  d1,y_vel(a1)

loc_4A4F0:
                andi.b  #$FC,object_control(a1)

loc_4A4F6:
                clr.b   (a2)
                move.b  #30,2(a2)
                move.w  #$100,priority(a1)
                bset    #Status_InAir,status(a1)
                clr.b   jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,flip_angle(a1)
                move.b  #0,double_jump_flag(a1)
                rts
; ---------------------------------------------------------------------------

loc_4A53A:
                tst.b   2(a2)
                beq.s   loc_4A54E
                subq.b  #1,2(a2)
                bne.s   locret_4A54C
                move.w  #$100,priority(a1)

locret_4A54C:
                rts
; ---------------------------------------------------------------------------

loc_4A54E:
                move.w  x_pos(a1),d1
                sub.w   x_pos(a0),d1
                addi.w  #$38,d1
                cmpi.w  #$70,d1
                bhs.w   locret_4A5DE
                move.w  y_pos(a1),d2
                sub.w   y_pos(a0),d2
                addi.w  #$38,d2
                cmpi.w  #$70,d2
                bhs.w   locret_4A5DE
                tst.w   (Debug_placement_mode).w
                bne.w   locret_4A5DE
                cmpi.b  #4,routine(a1)
                bhs.w   locret_4A5DE
                tst.b   object_control(a1)
                bne.w   locret_4A5DE
                subi.w  #$38,d1
                subi.w  #$38,d2
                jsr     (GetArcTan).l
                moveq   #0,d1
                tst.b   d0
                bpl.s   loc_4A5AA
                moveq   #-$80,d1
                addi.b  #$80,d0

loc_4A5AA:
                move.b  d1,4(a2)
                subi.b  #$40,d0
                move.b  d0,6(a2)
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                move.w  #$800,ground_vel(a1)
                andi.b  #$FD,render_flags(a1)
                move.b  #2,anim(a1)
                move.b  #1,object_control(a1)
                move.b  #1,(a2)
                bsr.w   PachinkoMagnet_PositionCapturedPlayer

locret_4A5DE:
                rts
; End of function PachinkoMagnet_UpdatePlayer

; =============== S U B R O U T I N E =======================================

; Use a cosine-varying radius along the magnet heading, set front or back priority, and advance phase
PachinkoMagnet_PositionCapturedPlayer:
                moveq   #0,d0
                move.b  4(a2),d0
                jsr     (GetSineCosine).l
                muls.w  #$3800,d1
                swap    d1
                moveq   #0,d2
                move.w  d1,d3
                moveq   #0,d0
                move.b  6(a2),d0
                jsr     (GetSineCosine).l
                move.w  d3,d5
                muls.w  d0,d5
                muls.w  d1,d3
                asr.l   #8,d3
                sub.l   d5,d2
                asr.l   #8,d2
                add.w   x_pos(a0),d2
                add.w   y_pos(a0),d3
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                move.w  #$100,priority(a1)
                ori.w   #high_priority,art_tile(a1)
                move.b  4(a2),d0
                bpl.s   loc_4A63C
                move.w  #$280,priority(a1)
                andi.w  #drawing_mask,art_tile(a1)

loc_4A63C:
                addq.b  #4,d0
                move.b  d0,4(a2)
                rts
; End of function PachinkoMagnet_PositionCapturedPlayer
