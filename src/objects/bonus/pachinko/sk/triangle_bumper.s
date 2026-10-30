; Owner: objects/bonus/pachinko/sk
; Responsibility: Pachinko triangle bumper contact, bounce response and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_PachinkoTriangleBumper:
                move.l  #Map_PachinkoTriangleBumper,mappings(a0)
                move.w  #make_art_tile(ArtTile_PachinkoMain+$1E,3,1),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$14,width_pixels(a0)
                move.b  #$3C,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.l  #loc_49ADA,(a0)

loc_49ADA:
                move.w  #$23,d1
                move.w  #$40,d2
                move.w  #$41,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull2).l
                swap    d6
                andi.w  #1|2,d6
                beq.s   loc_49B16
                move.w  d6,d0
                andi.w  #1,d0
                beq.s   loc_49B08
                lea     (Player_1).w,a1
                moveq   #p1_pushing_bit,d5
                bsr.s   sub_49B76

loc_49B08:
                andi.w  #2,d6
                beq.s   loc_49B16
                lea     (Player_2).w,a1
                moveq   #p2_pushing_bit,d5
                bsr.s   sub_49B76

loc_49B16:
                lea     (Ani_PachinkoTriangleBumper).l,a1
                jsr     (Animate_Sprite).l

loc_49B22:
                move.w  y_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_Y_pos_coarse_back).w,d0
                cmpi.w  #$200,d0
                bhi.w   loc_49B3C
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_49B3C:
                move.w  respawn_addr(a0),d0
                beq.s   loc_49B48
                movea.w d0,a2
                bclr    #7,(a2)

loc_49B48:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_49B4E:
                move.w  y_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_Y_pos_coarse_back).w,d0
                cmpi.w  #$200,d0
                bhi.w   loc_49B64
                rts
; ---------------------------------------------------------------------------

loc_49B64:
                move.w  respawn_addr(a0),d0
                beq.s   loc_49B70
                movea.w d0,a2
                bclr    #7,(a2)

loc_49B70:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_49B76:
                moveq   #signextendB(sfx_Bumper),d0
                jsr     (Play_SFX).l
                bclr    #Status_Facing,status(a1)
                move.w  #$800,x_vel(a1)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcc.s   loc_49B9E
                bset    #Status_Facing,status(a1)
                neg.w   x_vel(a1)

loc_49B9E:
                bclr    d5,status(a0)
                bset    #Status_InAir,status(a1)
                bclr    #Status_Push,status(a1)
                move.b  #0,double_jump_flag(a1)
                bclr    #Status_RollJump,status(a1)
                clr.b   jumping(a1)
                move.w  #1,ground_vel(a1)
                tst.b   flip_angle(a1)
                bne.s   loc_49BD0
                move.b  #1,flip_angle(a1)

loc_49BD0:
                move.b  #0,anim(a1)
                move.b  #-1,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                btst    #Status_Facing,status(a1)
                beq.s   loc_49BEE
                neg.w   ground_vel(a1)

loc_49BEE:
                move.b  #1,anim(a0)
                rts
; End of function sub_49B76

; ---------------------------------------------------------------------------
Ani_PachinkoTriangleBumper:
                include "src/objects/shared/zones/pachinko/anim_triangle_bumper.s"
Map_PachinkoTriangleBumper:
                include "src/objects/shared/zones/pachinko/map_triangle_bumper.s"
