; Owner: objects/zones/fbz/sk
; Responsibility: Trap spring activation, extension, player response and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZTrapSpring:
                move.l  #Map_FBZTrapSpring,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc2+$3D,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$80,priority(a0)
                move.l  #loc_3CB66,(a0)

loc_3CB66:
                move.w  (Player_1+y_pos).w,d0
                sub.w   y_pos(a0),d0
                bcs.s   loc_3CB7E
                cmpi.w  #$20,d0
                blt.s   loc_3CB8A
                move.b  #1,anim(a0)
                bra.s   loc_3CB8A
; ---------------------------------------------------------------------------

loc_3CB7E:
                cmpi.w  #-$10,d0
                bge.s   loc_3CB8A
                move.b  #0,anim(a0)

loc_3CB8A:
                lea     (Player_1).w,a1
                bclr    #p1_standing_bit,status(a0)
                beq.s   loc_3CB98
                bsr.s   LaunchPlayerFromFbzSpringSurface

loc_3CB98:
                lea     (Player_2).w,a1
                bclr    #p2_standing_bit,status(a0)
                beq.s   loc_3CBA6
                bsr.s   LaunchPlayerFromFbzSpringSurface

loc_3CBA6:
                move.w  #$1B,d1
                move.w  #8,d2
                move.w  #9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                lea     (Ani_FBZTrapSpring).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromFbzSpringSurface:
                move.w  #-$1000,y_vel(a1)
                move.b  subtype(a0),d0
                btst    #1,d0
                beq.s   loc_3CBE4
                move.w  #-$A00,y_vel(a1)

loc_3CBE4:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                move.b  #$10,anim(a1)
                move.b  #2,routine(a1)
                btst    #0,d0
                beq.s   loc_3CC44
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                btst    #1,d0
                bne.s   loc_3CC34
                move.b  #1,flips_remaining(a1)

loc_3CC34:
                btst    #Status_Facing,status(a1)
                beq.s   loc_3CC44
                neg.b   flip_angle(a1)
                neg.w   ground_vel(a1)

loc_3CC44:
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; End of function LaunchPlayerFromFbzSpringSurface

; ---------------------------------------------------------------------------
Ani_FBZTrapSpring:
                include "src/objects/shared/zones/fbz/animations/trap_spring.s"
Map_FBZTrapSpring:
                include "src/objects/shared/zones/fbz/mappings/trap_spring.s"
