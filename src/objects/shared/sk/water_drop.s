; Owner: objects/shared/sk
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
                move.l  #loc_382BA,(a0)

loc_382BA:
                subq.w  #1,$30(a0)
                bpl.s   loc_382F6
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #2,d0
                move.w  d0,$30(a0)
                tst.b   render_flags(a0)
                bpl.s   loc_382F6
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_382F6
                moveq   #subtype,d0

loc_382DE:
                move.w  (a0,d0.w),(a1,d0.w)
                subq.w  #2,d0
                bcc.s   loc_382DE
                move.l  #loc_382FC,(a1)
                move.b  #$C7,collision_flags(a1)
                moveq   #0,d0

loc_382F6:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_382FC:
                tst.b   routine(a0)
                beq.s   loc_38336
                jsr     (MoveSprite2).l
                addi.w  #8,y_vel(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_38336
                add.w   d1,y_pos(a0)
                clr.w   y_vel(a0)
                move.w  #(1<<8)|1,anim(a0)              ; and prev_anim
                move.l  #loc_38336,(a0)
                move.b  #1,anim_frame_timer(a0)
                clr.b   anim_frame(a0)

loc_38336:
                lea     (Ani_HCZWaterDrop).l,a1
                jsr     (Animate_Sprite).l
                cmpi.b  #4,routine(a0)
                bne.s   loc_38350
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_38350:
                tst.b   collision_property(a0)
                beq.s   loc_38376
                lea     (Player_1).w,a2
                bclr    #0,collision_property(a0)
                beq.s   loc_38364
                bsr.s   sub_38382

loc_38364:
                lea     (Player_2).w,a2
                bclr    #1,collision_property(a0)
                beq.s   loc_38372
                bsr.s   sub_38382

loc_38372:
                clr.b   collision_property(a0)

loc_38376:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_38382:
                cmpi.b  #5,anim(a2)
                bne.s   loc_38390
                move.b  #0,prev_anim(a2)

loc_38390:
                move.b  #1,anim(a0)
                move.l  #loc_38336,(a0)
                move.b  #0,collision_flags(a0)
                move.b  #2,routine(a0)
                rts
; End of function sub_38382

; ---------------------------------------------------------------------------
Ani_HCZWaterDrop:
                include "src/objects/shared/zones/hcz/anim_water_drop.s"
