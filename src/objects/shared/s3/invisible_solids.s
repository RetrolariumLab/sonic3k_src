; Owner: objects/shared/s3
; Responsibility: Invisible solid block setup, player contact and optional debug display
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_InvisibleBlock:
                move.l  #Map_InvisibleBlock,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ring,0,1),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$F0,d0
                addi.w  #$10,d0
                lsr.w   #1,d0
                move.b  d0,width_pixels(a0)
                andi.w  #$F,d1
                addq.w  #1,d1
                lsl.w   #3,d1
                move.b  d1,height_pixels(a0)
                tst.w   (Competition_mode).w
                beq.s   S3InvisibleSolid_InstallNormalHandler
                move.l  #S3InvisibleSolid_CollideCompInvisible,(a0)
                bra.s   S3InvisibleSolid_CollideCompInvisible
; ---------------------------------------------------------------------------

S3InvisibleSolid_InstallNormalHandler:
                move.l  #S3InvisibleSolid_CollideCullAndDrawDebug,(a0)

S3InvisibleSolid_CollideCullAndDrawDebug:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull2
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_1C778
                tst.w   (Debug_placement_mode).w
                beq.s   S3InvisibleSolid_NoDebugDrawReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3InvisibleSolid_NoDebugDrawReturn:
                rts
; ---------------------------------------------------------------------------

S3InvisibleSolid_CollideCompInvisible:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bra.w   SolidObjectFull2
; ---------------------------------------------------------------------------
Map_InvisibleBlock:
                include "src/objects/shared/level_misc/mappings/invisible_block.s"
