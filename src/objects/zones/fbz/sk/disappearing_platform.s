; Owner: objects/zones/fbz/sk
; Responsibility: Disappearing platform timing, collision and visible states
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
word_3BAAA:
                dc.w    $7F
                dc.w    $FF
                dc.w    $1FF
                dc.w    $3FF
; ---------------------------------------------------------------------------

Obj_FBZDisappearingPlatform:
                move.l  #Map_FBZDisappearingPlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc+$41,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  #2,mapping_frame(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$C,d0
                lsr.w   #1,d0
                move.w  word_3BAAA(pc,d0.w),d0
                move.w  d0,$32(a0)
                addq.w  #1,d0
                lsr.w   #4,d0
                andi.w  #$F0,d1
                lsr.w   #4,d1
                mulu.w  d1,d0
                move.w  d0,$30(a0)
                move.l  #loc_3BB08,(a0)

loc_3BB08:
                move.w  (Level_frame_counter).w,d0
                add.w   $30(a0),d0
                and.w   $32(a0),d0
                beq.s   loc_3BB1C
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_3BB1C:
                move.b  subtype(a0),d0
                andi.b  #3,d0
                move.b  d0,anim(a0)
                move.b  #4,prev_anim(a0)
                move.l  #loc_3BB34,(a0)

loc_3BB34:
                lea     (Ani_FBZDisappearingPlatform).l,a1
                jsr     (Animate_SpriteIrregularDelay).l
                tst.b   mapping_frame(a0)
                beq.s   loc_3BB6E
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   sub_3BB86
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.s   sub_3BB86
                tst.b   routine(a0)
                beq.s   loc_3BB80
                clr.b   routine(a0)
                move.b  #2,mapping_frame(a0)
                move.l  #loc_3BB08,(a0)
                bra.s   loc_3BB80
; ---------------------------------------------------------------------------

loc_3BB6E:
                move.w  #$1B,d1
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l

loc_3BB80:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_3BB86:
                bclr    d6,status(a0)
                beq.s   locret_3BB98
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)

locret_3BB98:
                rts
; End of function sub_3BB86

; ---------------------------------------------------------------------------
Ani_FBZDisappearingPlatform:
                include "src/objects/shared/zones/fbz/animations/disappearing_platform.s"
Map_FBZDisappearingPlatform:
                include "src/objects/shared/zones/fbz/mappings/disappearing_platform.s"
