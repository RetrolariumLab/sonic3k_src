; Owner: objects/zones/lbz/sk
; Responsibility: Launch Base exploding trigger collision, activation and destruction state
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_LBZExplodingTrigger:
                move.l  #Map_LBZExplodingTrigger,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZMisc+$70,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  #$C6,collision_flags(a0)
                move.l  #loc_25CF0,(a0)

loc_25CF0:
                move.b  collision_property(a0),d0
                beq.w   loc_25D26
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                moveq   #0,d3
                lea     (Player_1).w,a1
                bclr    #0,collision_property(a0)
                beq.s   loc_25D18
                bsr.s   sub_25D2C

loc_25D18:
                lea     (Player_2).w,a1
                bclr    #1,collision_property(a0)
                beq.s   loc_25D26
                bsr.s   sub_25D2C

loc_25D26:
                jmp     (Sprite_CheckDeleteTouch3).l

; =============== S U B R O U T I N E =======================================

sub_25D2C:
                cmpi.b  #2,anim(a1)
                bne.s   locret_25D52
                neg.w   x_vel(a1)
                neg.w   y_vel(a1)
                bchg    d3,(a3)
                move.l  #Obj_Explosion,(a0)
                move.b  #2,routine(a0)
                clr.b   collision_flags(a0)
                clr.b   collision_property(a0)

locret_25D52:
                rts
; End of function sub_25D2C
