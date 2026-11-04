; Owner: objects/competition/s3
; Responsibility: Balloon Park balloon motion, player bounce and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_BPZBalloon:
                move.l  #Map_BPZBalloon,mappings(a0)
                move.w  #make_art_tile(ArtTile_BPZMisc,3,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$D7,collision_flags(a0)
                move.l  #S3BPZBalloon_BounceContactingPlayers,(a0)

S3BPZBalloon_BounceContactingPlayers:
                tst.b   collision_property(a0)
                beq.w   S3BPZBalloon_RegisterCollisionFrames5To6
                lea     (Player_1).w,a1
                bclr    #0,collision_property(a0)
                beq.s   S3BPZBalloon_CheckP2Contact
                bsr.s   S3CompBalloon_BouncePlayer

S3BPZBalloon_CheckP2Contact:
                lea     (Player_2).w,a1
                bclr    #1,collision_property(a0)
                beq.s   S3BPZBalloon_ClearContactAndAnimate
                bsr.s   S3CompBalloon_BouncePlayer

S3BPZBalloon_ClearContactAndAnimate:
                clr.b   collision_property(a0)
                bra.w   S3BPZBalloon_RegisterCollisionFrames5To6

; =============== S U B R O U T I N E =======================================

; Upper-cone contact gives a stronger straight-up launch
S3CompBalloon_BouncePlayer:
                move.w  x_pos(a0),d1
                move.w  y_pos(a0),d2
                sub.w   x_pos(a1),d1
                sub.w   y_pos(a1),d2
                jsr     (GetArcTan).l
                move.b  d0,d1
                subi.b  #$20,d1
                cmpi.b  #$40,d1
                bhs.s   S3BPZBalloon_ApplyRadialBounce
                move.w  #-$900,y_vel(a1)
                move.b  #1,anim(a0)
                bra.s   S3BPZBalloon_SetAirborneAndPlayBounce
; ---------------------------------------------------------------------------

S3BPZBalloon_ApplyRadialBounce:
                jsr     (GetSineCosine).l
                muls.w  #-$480,d1
                asr.l   #8,d1
                move.w  d1,x_vel(a1)
                muls.w  #-$480,d0
                asr.l   #8,d0
                move.w  d0,y_vel(a1)
                move.b  #2,anim(a0)

S3BPZBalloon_SetAirborneAndPlayBounce:
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                bclr    #Status_Push,status(a1)
                clr.b   jumping(a1)
                moveq   #signextendB(sfx_SmallBumpers),d0
                jmp     (Play_SFX).l
; End of function S3CompBalloon_BouncePlayer

; ---------------------------------------------------------------------------

S3BPZBalloon_RegisterCollisionFrames5To6:
                lea     (Ani_BPZBalloon).l,a1
                jsr     (Animate_Sprite).l
                cmpi.b  #5,mapping_frame(a0)
                blo.s   S3BPZBalloon_QueueDraw
                cmpi.b  #7,mapping_frame(a0)
                bhs.s   S3BPZBalloon_QueueDraw
                jsr     (Add_SpriteToCollisionResponseList).l

S3BPZBalloon_QueueDraw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_BPZBalloon:
                include "src/objects/shared/zones/bpz/animations/balloon.s"
Map_BPZBalloon:
                include "src/objects/shared/zones/bpz/mappings/balloon.s"
