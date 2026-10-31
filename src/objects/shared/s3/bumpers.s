; Owner: objects/shared/s3
; Responsibility: Shared bumper response, competition and product-specific bonus variants and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_Bumper:
                move.l  #Map_Bumper,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc+$13,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$80,priority(a0)
                move.b  #$D7,collision_flags(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                tst.w   (Competition_mode).w
                beq.s   loc_320D8
                move.l  #Map_2PBumper,mappings(a0)
                move.w  #make_art_tile(ArtTile_BPZMisc,1,0),art_tile(a0)
                move.l  #loc_3221C,(a0)
                bra.w   loc_3221C
; ---------------------------------------------------------------------------

loc_320D8:
                move.l  #loc_3211A,(a0)
                move.b  subtype(a0),d0
                beq.s   loc_3211A
                move.b  d0,angle(a0)
                move.l  #loc_320EE,(a0)

loc_320EE:
                move.b  (Level_frame_counter+1).w,d0
                btst    #0,status(a0)
                beq.s   loc_320FC
                neg.b   d0

loc_320FC:
                add.b   angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d1
                asr.w   #2,d0
                add.w   $30(a0),d1
                add.w   $32(a0),d0
                move.w  d1,x_pos(a0)
                move.w  d0,y_pos(a0)

loc_3211A:
                tst.b   collision_property(a0)
                beq.w   loc_321E0
                lea     (Player_1).w,a1
                bclr    #0,collision_property(a0)
                beq.s   loc_32130
                bsr.s   sub_32146

loc_32130:
                lea     (Player_2).w,a1
                bclr    #1,collision_property(a0)
                beq.s   loc_3213E
                bsr.s   sub_32146

loc_3213E:
                clr.b   collision_property(a0)
                bra.w   loc_321E0

; =============== S U B R O U T I N E =======================================

sub_32146:
                move.w  x_pos(a0),d1
                move.w  y_pos(a0),d2
                sub.w   x_pos(a1),d1
                sub.w   y_pos(a1),d2
                jsr     (GetArcTan).l
                move.b  (Level_frame_counter).w,d1
                andi.w  #3,d1
                add.w   d1,d0
                jsr     (GetSineCosine).l
                muls.w  #-$700,d1
                asr.l   #8,d1
                move.w  d1,x_vel(a1)
                muls.w  #-$700,d0
                asr.l   #8,d0
                move.w  d0,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                bclr    #Status_Push,status(a1)
                clr.b   jumping(a1)
                move.b  #1,anim(a0)
                moveq   #signextendB(sfx_Bumper),d0
                jsr     (Play_SFX).l
                move.w  respawn_addr(a0),d0
                beq.s   loc_321B4
                movea.w d0,a2
                cmpi.b  #$8A,(a2)
                bhs.s   locret_321DE
                addq.b  #1,(a2)

loc_321B4:
                moveq   #1,d0
                movea.w a1,a3
                jsr     (HUD_AddToScore).l
                jsr     (AllocateObject).l
                bne.s   locret_321DE
                move.l  #Obj_EnemyScore,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  #4,mapping_frame(a1)

locret_321DE:
                rts
; End of function sub_32146

; ---------------------------------------------------------------------------

loc_321E0:
                lea     (Ani_Bumper).l,a1
                jsr     (Animate_Sprite).l
                move.w  $30(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_3220A
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_3220A:
                move.w  respawn_addr(a0),d0
                beq.s   loc_32216
                movea.w d0,a2
                bclr    #7,(a2)

loc_32216:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3221C:
                tst.b   collision_property(a0)
                beq.w   loc_322A8
                lea     (Player_1).w,a1
                bclr    #0,collision_property(a0)
                beq.s   loc_32232
                bsr.s   sub_32248

loc_32232:
                lea     (Player_2).w,a1
                bclr    #1,collision_property(a0)
                beq.s   loc_32240
                bsr.s   sub_32248

loc_32240:
                clr.b   collision_property(a0)
                bra.w   loc_322A8

; =============== S U B R O U T I N E =======================================

sub_32248:
                move.w  x_pos(a0),d1
                move.w  y_pos(a0),d2
                sub.w   x_pos(a1),d1
                sub.w   y_pos(a1),d2
                jsr     (GetArcTan).l
                move.b  (Level_frame_counter).w,d1
                andi.w  #3,d1
                add.w   d1,d0
                jsr     (GetSineCosine).l
                muls.w  #-$700,d1
                asr.l   #8,d1
                move.w  d1,x_vel(a1)
                muls.w  #-$700,d0
                asr.l   #8,d0
                move.w  d0,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                bclr    #Status_Push,status(a1)
                clr.b   jumping(a1)
                move.b  #1,anim(a0)
                moveq   #signextendB(sfx_SmallBumpers),d0
                jsr     (Play_SFX).l
                rts
; End of function sub_32248

; ---------------------------------------------------------------------------

loc_322A8:
                lea     (Ani_Bumper).l,a1
                jsr     (Animate_Sprite).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_Bumper:
                include "src/objects/shared/level_misc/animations/bumper.s"
Map_Bumper:
                include "src/objects/shared/level_misc/mappings/bumper.s"
Map_2PBumper:
                include "src/game/competition/shared/mappings/competition_bumper.s"
