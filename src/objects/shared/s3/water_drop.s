; Owner: objects/shared/s3
; Responsibility: Water-drop motion, collision, destruction and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_WaterDrop:
                move.l  #Map_HCZWaterDrop,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZ2Slide,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #0,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.b  #8,x_radius(a0)
                move.b  #7,y_radius(a0)
                move.b  #6,mapping_frame(a0)
                move.l  #loc_3784C,(a0)

loc_3784C:
                subq.w  #1,$30(a0)
                bpl.s   loc_37888
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #2,d0
                move.w  d0,$30(a0)
                tst.b   render_flags(a0)
                bpl.s   loc_37888
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_37888
                moveq   #subtype,d0

loc_37870:
                move.w  (a0,d0.w),(a1,d0.w)
                subq.w  #2,d0
                bcc.s   loc_37870
                move.l  #loc_3788E,(a1)
                move.b  #$C7,collision_flags(a1)
                moveq   #0,d0

loc_37888:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_3788E:
                tst.b   routine(a0)
                beq.s   loc_378C8
                jsr     (MoveSprite2).l
                addi.w  #8,y_vel(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_378C8
                add.w   d1,y_pos(a0)
                clr.w   y_vel(a0)
                move.w  #(1<<8)|1,anim(a0)              ; and prev_anim
                move.l  #loc_378C8,(a0)
                move.b  #1,anim_frame_timer(a0)
                clr.b   anim_frame(a0)

loc_378C8:
                lea     (Ani_HCZWaterDrop).l,a1
                jsr     (Animate_Sprite).l
                cmpi.b  #4,routine(a0)
                bne.s   loc_378E2
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_378E2:
                tst.b   collision_property(a0)
                beq.s   loc_37908
                lea     (Player_1).w,a2
                bclr    #0,collision_property(a0)
                beq.s   loc_378F6
                bsr.s   sub_37914

loc_378F6:
                lea     (Player_2).w,a2
                bclr    #1,collision_property(a0)
                beq.s   loc_37904
                bsr.s   sub_37914

loc_37904:
                clr.b   collision_property(a0)

loc_37908:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_37914:
                cmpi.b  #5,anim(a2)
                bne.s   loc_37922
                move.b  #0,prev_anim(a2)

loc_37922:
                move.b  #1,anim(a0)
                move.l  #loc_378C8,(a0)
                move.b  #0,collision_flags(a0)
                move.b  #2,routine(a0)
                rts
; End of function sub_37914

; ---------------------------------------------------------------------------
Ani_HCZWaterDrop:
                include "src/objects/shared/zones/hcz/anim_water_drop.s"
Map_HCZWaterDrop:
                include "src/objects/shared/zones/hcz/map_water_drop.s"
