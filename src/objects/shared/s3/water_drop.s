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
                move.l  #S3WaterDrop_TickDelayAndTryEmit,(a0)

S3WaterDrop_TickDelayAndTryEmit:
                subq.w  #1,$30(a0)
                bpl.s   S3WaterDrop_CullAndDrawWaterDropEmitter
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #2,d0
                move.w  d0,$30(a0)
                tst.b   render_flags(a0)
                bpl.s   S3WaterDrop_CullAndDrawWaterDropEmitter
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3WaterDrop_CullAndDrawWaterDropEmitter
                moveq   #subtype,d0

S3WaterDrop_CopyEmitterPrefix:
                move.w  (a0,d0.w),(a1,d0.w)
                subq.w  #2,d0
                bcc.s   S3WaterDrop_CopyEmitterPrefix
                move.l  #S3WaterDrop_MoveAndCheckFloorImpact,(a1)
                move.b  #$C7,collision_flags(a1)
                moveq   #0,d0

S3WaterDrop_CullAndDrawWaterDropEmitter:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

S3WaterDrop_MoveAndCheckFloorImpact:
                tst.b   routine(a0)
                beq.s   S3WaterDrop_AnimateOrDeleteAtRoutine4
                jsr     (MoveSprite2).l
                addi.w  #8,y_vel(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   S3WaterDrop_AnimateOrDeleteAtRoutine4
                add.w   d1,y_pos(a0)
                clr.w   y_vel(a0)
                move.w  #(1<<8)|1,anim(a0)              ; and prev_anim
                move.l  #S3WaterDrop_AnimateOrDeleteAtRoutine4,(a0)
                move.b  #1,anim_frame_timer(a0)
                clr.b   anim_frame(a0)

S3WaterDrop_AnimateOrDeleteAtRoutine4:
                lea     (Ani_HCZWaterDrop).l,a1
                jsr     (Animate_Sprite).l
                cmpi.b  #4,routine(a0)
                bne.s   S3WaterDrop_ConsumeP1Contact
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3WaterDrop_ConsumeP1Contact:
                tst.b   collision_property(a0)
                beq.s   S3WaterDrop_QueueDropForTouchAndDrawing
                lea     (Player_1).w,a2
                bclr    #0,collision_property(a0)
                beq.s   S3WaterDrop_ConsumeP2Contact
                bsr.s   SplashWaterDropOnPlayerContact

S3WaterDrop_ConsumeP2Contact:
                lea     (Player_2).w,a2
                bclr    #1,collision_property(a0)
                beq.s   S3WaterDrop_ClearDropContacts
                bsr.s   SplashWaterDropOnPlayerContact

S3WaterDrop_ClearDropContacts:
                clr.b   collision_property(a0)

S3WaterDrop_QueueDropForTouchAndDrawing:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

SplashWaterDropOnPlayerContact:
                cmpi.b  #5,anim(a2)
                bne.s   S3WaterDrop_BeginSplashAndDisableColl
                move.b  #0,prev_anim(a2)

S3WaterDrop_BeginSplashAndDisableColl:
                move.b  #1,anim(a0)
                move.l  #S3WaterDrop_AnimateOrDeleteAtRoutine4,(a0)
                move.b  #0,collision_flags(a0)
                move.b  #2,routine(a0)
                rts
; End of function SplashWaterDropOnPlayerContact

; ---------------------------------------------------------------------------
Ani_HCZWaterDrop:
                include "src/objects/shared/zones/hcz/animations/water_drop.s"
Map_HCZWaterDrop:
                include "src/objects/shared/zones/hcz/mappings/water_drop.s"
