; Owner: objects/shared/s3
; Responsibility: Invisible horizontal and vertical harmful regions, product-specific shock or lava reactions and shared player contact geometry
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_InvisibleHurtBlockHorizontal:
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
                btst    #0,status(a0)
                beq.s   S3HurtRegion_SelectTopOrUnderside
                move.l  #S3HurtRegion_CheckSideContacts,(a0)
                rts
; ---------------------------------------------------------------------------

S3HurtRegion_SelectTopOrUnderside:
                btst    #1,status(a0)
                beq.s   S3HurtRegion_InstallTopHandler
                move.l  #S3HurtRegion_CheckUndersideContacts,(a0)
                rts
; ---------------------------------------------------------------------------

S3HurtRegion_InstallTopHandler:
                move.l  #S3HurtRegion_CheckTopContacts,(a0)

S3HurtRegion_CheckTopContacts:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull2
                move.b  status(a0),d6
                andi.b  #standing_mask,d6
                beq.s   S3HurtRegion_CullOrDebugDrawTop
                move.b  d6,d0
                andi.b  #p1_standing,d0
                beq.s   S3HurtRegion_TryHurtTopP2
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerFromSolidHazard

S3HurtRegion_TryHurtTopP2:
                andi.b  #p2_standing,d6
                beq.s   S3HurtRegion_CullOrDebugDrawTop
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerFromSolidHazard

S3HurtRegion_CullOrDebugDrawTop:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3LavaMarker_ClearMarkerLoadedBit
                tst.w   (Debug_placement_mode).w
                beq.s   S3HurtRegion_TopReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3HurtRegion_TopReturn:
                rts
; ---------------------------------------------------------------------------

S3HurtRegion_CheckSideContacts:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull2
                swap    d6
                andi.w  #3,d6
                beq.s   S3HurtRegion_CullOrDebugDrawSide
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   S3HurtRegion_TryHurtSideP2
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerFromSolidHazard

S3HurtRegion_TryHurtSideP2:
                andi.b  #2,d6
                beq.s   S3HurtRegion_CullOrDebugDrawSide
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerFromSolidHazard

S3HurtRegion_CullOrDebugDrawSide:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3LavaMarker_ClearMarkerLoadedBit
                tst.w   (Debug_placement_mode).w
                beq.s   S3HurtRegion_SideReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3HurtRegion_SideReturn:
                rts
; ---------------------------------------------------------------------------

S3HurtRegion_CheckUndersideContacts:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull2
                swap    d6
                andi.w  #$C,d6
                beq.s   S3HurtRegion_CullOrDebugDrawUnderside
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   S3HurtRegion_TryHurtUndersideP2
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerFromSolidHazard

S3HurtRegion_TryHurtUndersideP2:
                andi.b  #8,d6
                beq.s   S3HurtRegion_CullOrDebugDrawUnderside
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerFromSolidHazard

S3HurtRegion_CullOrDebugDrawUnderside:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3LavaMarker_ClearMarkerLoadedBit
                tst.w   (Debug_placement_mode).w
                beq.s   S3HurtRegion_UndersideReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3HurtRegion_UndersideReturn:
                rts
; ---------------------------------------------------------------------------

Obj_InvisibleHurtBlockVertical:
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
                btst    #0,status(a0)
                beq.s   S3KillRegion_SelectTopOrUnderside
                move.l  #S3KillRegion_CheckSideContacts,(a0)
                rts
; ---------------------------------------------------------------------------

S3KillRegion_SelectTopOrUnderside:
                btst    #1,status(a0)
                beq.s   S3KillRegion_InstallTopHandler
                move.l  #S3KillRegion_CheckUndersideContacts,(a0)
                rts
; ---------------------------------------------------------------------------

S3KillRegion_InstallTopHandler:
                move.l  #S3KillRegion_CheckTopContacts,(a0)

S3KillRegion_CheckTopContacts:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull2
                move.b  status(a0),d6
                andi.b  #standing_mask,d6
                beq.s   S3KillRegion_CullOrDebugDrawTop
                move.b  d6,d0
                andi.b  #p1_standing,d0
                beq.s   S3KillRegion_TryKillTopP2
                lea     (Player_1).w,a1
                bsr.w   KillPlayerFromInvisibleHazard

S3KillRegion_TryKillTopP2:
                andi.b  #p2_standing,d6
                beq.s   S3KillRegion_CullOrDebugDrawTop
                lea     (Player_2).w,a1
                bsr.w   KillPlayerFromInvisibleHazard

S3KillRegion_CullOrDebugDrawTop:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3LavaMarker_ClearMarkerLoadedBit
                tst.w   (Debug_placement_mode).w
                beq.s   S3KillRegion_TopReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3KillRegion_TopReturn:
                rts
; ---------------------------------------------------------------------------

S3KillRegion_CheckSideContacts:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull2
                swap    d6
                andi.w  #3,d6
                beq.s   S3KillRegion_CullOrDebugDrawSide
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   S3KillRegion_TryKillSideP2
                lea     (Player_1).w,a1
                bsr.w   KillPlayerFromInvisibleHazard

S3KillRegion_TryKillSideP2:
                andi.b  #2,d6
                beq.s   S3KillRegion_CullOrDebugDrawSide
                lea     (Player_2).w,a1
                bsr.w   KillPlayerFromInvisibleHazard

S3KillRegion_CullOrDebugDrawSide:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3LavaMarker_ClearMarkerLoadedBit
                tst.w   (Debug_placement_mode).w
                beq.s   S3KillRegion_SideReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3KillRegion_SideReturn:
                rts
; ---------------------------------------------------------------------------

S3KillRegion_CheckUndersideContacts:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull2
                swap    d6
                andi.w  #$C,d6
                beq.s   S3KillRegion_CullOrDebugDrawUnderside
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   S3KillRegion_TryKillUndersideP2
                lea     (Player_1).w,a1
                bsr.w   KillPlayerFromInvisibleHazard

S3KillRegion_TryKillUndersideP2:
                andi.b  #8,d6
                beq.s   S3KillRegion_CullOrDebugDrawUnderside
                lea     (Player_2).w,a1
                bsr.w   KillPlayerFromInvisibleHazard

S3KillRegion_CullOrDebugDrawUnderside:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3LavaMarker_ClearMarkerLoadedBit
                tst.w   (Debug_placement_mode).w
                beq.s   S3KillRegion_UndersideReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3KillRegion_UndersideReturn:
                rts

; =============== S U B R O U T I N E =======================================

KillPlayerFromInvisibleHazard:
                move.w  d6,-(sp)
                move.l  a0,-(sp)
                movea.l a1,a0
                jsr     (Kill_Character).l
                movea.l (sp)+,a0
                move.w  (sp)+,d6
                rts
; End of function KillPlayerFromInvisibleHazard
