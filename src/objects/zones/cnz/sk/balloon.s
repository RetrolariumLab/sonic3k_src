; Owner: objects/zones/cnz/sk
; Responsibility: Carnival Night balloon collision, bounce, burst and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZBalloon:
                move.l  #Map_CNZBalloon,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #$D7,collision_flags(a0)
                move.w  y_pos(a0),$32(a0)
                move.b  subtype(a0),d0
                add.b   d0,d0
                andi.b  #$E,d0
                move.b  d0,anim(a0)
                jsr     (Random_Number).l
                move.b  d0,angle(a0)
                move.l  #loc_31754,(a0)

loc_31754:
                tst.b   collision_property(a0)
                beq.s   loc_31776
                lea     (Player_1).w,a1
                bclr    #0,collision_property(a0)
                beq.s   loc_31768
                bsr.s   sub_317AE

loc_31768:
                lea     (Player_2).w,a1
                bclr    #1,collision_property(a0)
                beq.s   loc_31776
                bsr.s   sub_317AE

loc_31776:
                lea     (Ani_CNZBalloon).l,a1
                jsr     (Animate_Sprite).l
; Bug: probably meant to be routine(a0), and at some point the animation terminated
; with code $FC (increment routine counter) rather than $FB (move offscreen)
                tst.b   routine
                beq.s   loc_3178E
                move.w  #$7F00,x_pos(a0)

loc_3178E:
                moveq   #0,d0
                move.b  angle(a0),d0
                addq.b  #1,angle(a0)
                jsr     (GetSineCosine).l
                asr.w   #5,d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a0)
                jmp     (Sprite_CheckDeleteTouch3).l

; =============== S U B R O U T I N E =======================================

sub_317AE:
                move.w  #-$700,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                bclr    #Status_Push,status(a1)
                clr.b   jumping(a1)
                move.b  #0,object_control(a1)
                bset    #0,anim(a0)
                tst.b   subtype(a0)
                bpl.s   loc_31808
                move.w  #-$380,y_vel(a1)
                tst.b   (Water_flag).w
                beq.s   loc_31808
                tst.b   $34(a0)
                bne.s   loc_31808
                lea     (byte_3185A).l,a2
                bsr.s   sub_3181E
                bsr.s   sub_3181E
                bsr.s   sub_3181E
                bsr.s   sub_3181E
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)

loc_31808:
                tst.b   $34(a0)
                bne.s   locret_3181C
                moveq   #signextendB(sfx_Balloon),d0
                jsr     (Play_SFX).l
                move.b  #1,$34(a0)

locret_3181C:
                rts
; End of function sub_317AE

; =============== S U B R O U T I N E =======================================

sub_3181E:
                jsr     (AllocateObject).l
                bne.s   locret_31858
                move.l  #Obj_Bubbler,(a1)
                move.w  x_pos(a0),x_pos(a1)
                jsr     (Random_Number).l
                move.w  d0,d1
                andi.w  #$F,d0
                subq.w  #8,d0
                add.w   d0,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                andi.w  #$F,d1
                subq.w  #8,d1
                add.w   d1,y_pos(a1)
                move.b  (a2)+,subtype(a1)

locret_31858:
                rts
; End of function sub_3181E

; ---------------------------------------------------------------------------
byte_3185A:
                dc.b    0,   0,   1,   3
                even
Ani_CNZBalloon:
                include "src/objects/shared/zones/cnz/anim_balloon.s"
