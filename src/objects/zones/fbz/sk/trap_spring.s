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
                move.l  #SKFBZTrapSpring_TrySetP1BelowAnim,(a0)

SKFBZTrapSpring_TrySetP1BelowAnim:
                move.w  (Player_1+y_pos).w,d0
                sub.w   y_pos(a0),d0
                bcs.s   SKFBZTrapSpring_TrySetP1AboveAnim
                cmpi.w  #$20,d0
                blt.s   SKFBZTrapSpring_TryLaunchP1
                move.b  #1,anim(a0)
                bra.s   SKFBZTrapSpring_TryLaunchP1
; ---------------------------------------------------------------------------

SKFBZTrapSpring_TrySetP1AboveAnim:
                cmpi.w  #-$10,d0
                bge.s   SKFBZTrapSpring_TryLaunchP1
                move.b  #0,anim(a0)

SKFBZTrapSpring_TryLaunchP1:
                lea     (Player_1).w,a1
                bclr    #p1_standing_bit,status(a0)
                beq.s   SKFBZTrapSpring_TryLaunchP2
                bsr.s   LaunchPlayerFromFbzSpringSurface

SKFBZTrapSpring_TryLaunchP2:
                lea     (Player_2).w,a1
                bclr    #p2_standing_bit,status(a0)
                beq.s   SKFBZTrapSpring_ResolveSolidAndDraw
                bsr.s   LaunchPlayerFromFbzSpringSurface

SKFBZTrapSpring_ResolveSolidAndDraw:
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
                beq.s   SKFBZTrapSpring_SetAirborneAndTryTumble
                move.w  #-$A00,y_vel(a1)

SKFBZTrapSpring_SetAirborneAndTryTumble:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                move.b  #$10,anim(a1)
                move.b  #2,routine(a1)
                btst    #0,d0
                beq.s   SKFBZTrapSpring_PlaySpringSound
                move.w  #1,ground_vel(a1)
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                btst    #1,d0
                bne.s   SKFBZTrapSpring_TryFlipTumbleDirection
                move.b  #1,flips_remaining(a1)

SKFBZTrapSpring_TryFlipTumbleDirection:
                btst    #Status_Facing,status(a1)
                beq.s   SKFBZTrapSpring_PlaySpringSound
                neg.b   flip_angle(a1)
                neg.w   ground_vel(a1)

SKFBZTrapSpring_PlaySpringSound:
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; End of function LaunchPlayerFromFbzSpringSurface

; ---------------------------------------------------------------------------
Ani_FBZTrapSpring:
                include "src/objects/shared/zones/fbz/animations/trap_spring.s"
Map_FBZTrapSpring:
                include "src/objects/shared/zones/fbz/mappings/trap_spring.s"
