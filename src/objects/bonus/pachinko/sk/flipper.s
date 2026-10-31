; Owner: objects/bonus/pachinko/sk
; Responsibility: Pachinko flipper timing, player contact, launch and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_PachinkoFlipper:
                move.l  #Map_PachinkoFlipper,mappings(a0)
                move.w  #make_art_tile(ArtTile_PachinkoMain+$62,0,1),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$1C,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.l  #loc_49C8A,(a0)

loc_49C8A:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                lea     (byte_49E5A).l,a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped2).l
                lea     $36(a0),a3
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d5
                moveq   #p1_standing_bit,d6
                bsr.s   sub_49CFE
                lea     $37(a0),a3
                lea     (Player_2).w,a1
                move.w  (Ctrl_2_logical).w,d5
                moveq   #p2_standing_bit,d6
                bsr.s   sub_49CFE
                tst.b   $38(a0)
                beq.s   loc_49CEC
                clr.b   $38(a0)
                lea     $36(a0),a3
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.w   sub_49D72
                lea     $37(a0),a3
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   sub_49D72
                move.b  #1,anim(a0)

loc_49CEC:
                lea     (Ani_PachinkoFlipper).l,a1
                jsr     (Animate_Sprite).l
                jmp     (loc_49B22).l

; =============== S U B R O U T I N E =======================================

sub_49CFE:
                tst.w   (Debug_placement_mode).w
                bne.s   loc_49D48
                move.b  (a3),d0
                bne.s   loc_49D3C
                btst    d6,status(a0)
                beq.s   locret_49D3A
                addq.b  #1,(a3)
                move.w  #2<<8,anim(a1)                  ; and prev_anim
                move.b  #1,object_control(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bne.s   locret_49D3A
                addq.w  #5,y_pos(a1)

locret_49D3A:
                rts
; ---------------------------------------------------------------------------

loc_49D3C:
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d5
                bne.s   loc_49D68
                btst    d6,status(a0)
                bne.s   loc_49D54

loc_49D48:
                move.b  #0,object_control(a1)
                move.b  #0,(a3)
                rts
; ---------------------------------------------------------------------------

loc_49D54:
                moveq   #$18,d1
                btst    #0,status(a0)
                beq.s   loc_49D60
                not.w   d1

loc_49D60:
                add.w   d1,ground_vel(a1)
                bra.w   loc_49DE4
; ---------------------------------------------------------------------------

loc_49D68:
                move.b  #1,$38(a0)
                bra.w   loc_49DE4
; End of function sub_49CFE

; =============== S U B R O U T I N E =======================================

sub_49D72:
                bclr    d6,status(a0)
                beq.w   locret_49D3A
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                btst    #0,status(a0)
                beq.s   loc_49D8C
                neg.w   d0

loc_49D8C:
                addi.w  #$20,d0
                move.w  d0,d2
                lsl.w   #5,d2
                addi.w  #$800,d2
                neg.w   d2
                asr.w   #2,d0
                addi.w  #$40,d0
                jsr     (GetSineCosine).l
                muls.w  d2,d0
                muls.w  d2,d1
                asr.l   #8,d0
                asr.l   #8,d1
                move.w  d0,y_vel(a1)
                btst    #0,status(a0)
                beq.s   loc_49DBC
                neg.w   d1

loc_49DBC:
                move.w  d1,x_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #2,routine(a1)
                move.b  #0,object_control(a1)
                move.b  #0,(a3)
                moveq   #signextendB(sfx_Flipper),d0
                jmp     (Play_SFX).l
; End of function sub_49D72

; ---------------------------------------------------------------------------

loc_49DE4:
                move.l  a0,-(sp)
                movea.l a1,a0
                move.w  ground_vel(a0),d0
                beq.s   loc_49E0A
                bmi.s   loc_49DFE
                sub.w   d5,d0
                bcc.s   loc_49DF8
                move.w  #0,d0

loc_49DF8:
                move.w  d0,ground_vel(a0)
                bra.s   loc_49E0A
; ---------------------------------------------------------------------------

loc_49DFE:
                add.w   d5,d0
                bcc.s   loc_49E06
                move.w  #0,d0

loc_49E06:
                move.w  d0,ground_vel(a0)

loc_49E0A:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                jsr     (MoveSprite_TestGravity2).l
                jsr     (CheckLeftWallDist).l
                tst.w   d1
                bpl.s   loc_49E42
                sub.w   d1,x_pos(a0)
                move.w  #0,ground_vel(a0)

loc_49E42:
                jsr     (CheckRightWallDist).l
                tst.w   d1
                bpl.s   loc_49E56
                add.w   d1,x_pos(a0)
                move.w  #0,ground_vel(a0)

loc_49E56:
                movea.l (sp)+,a0
                rts
; ---------------------------------------------------------------------------
byte_49E5A:
                dc.b    -4,  -4,  -4,  -4,  -4,  -4,  -4,  -4,  -4,  -5,  -6,  -7,  -8,  -9, -$A, -$B, -$C, -$D, -$E, -$F
                dc.b    -$10,-$11,-$12,-$13,-$14,-$15,-$16,-$17,-$18,-$19,-$1A,-$1B
                even
Ani_PachinkoFlipper:
                include "src/objects/shared/zones/pachinko/animations/flipper.s"
Map_PachinkoFlipper:
                include "src/objects/shared/zones/pachinko/mappings/flipper.s"
