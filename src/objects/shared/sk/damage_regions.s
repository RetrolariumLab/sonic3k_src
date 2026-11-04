; Owner: objects/shared/sk
; Responsibility: Invisible horizontal and vertical harmful regions, product-specific shock or lava reactions and shared player contact geometry
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_InvisibleShockBlock:
                bset    #5,shield_reaction(a0)
                bra.s   Obj_InvisibleHurtBlockHorizontal
; ---------------------------------------------------------------------------

Obj_InvisibleLavaBlock:
                bset    #4,shield_reaction(a0)

Obj_InvisibleHurtBlockHorizontal:
                move.l  #Map_InvisibleBlock,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ring,0,1),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                bset    #7,status(a0)
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
                beq.s   SKHurtRegion_SelectTopOrUnderside
                move.l  #SKHurtRegion_CheckSideContacts,(a0)
                rts
; ---------------------------------------------------------------------------

SKHurtRegion_SelectTopOrUnderside:
                btst    #1,status(a0)
                beq.s   SKHurtRegion_InstallTopHandler
                move.l  #SKHurtRegion_CheckUndersideContacts,(a0)
                rts
; ---------------------------------------------------------------------------

SKHurtRegion_InstallTopHandler:
                move.l  #SKHurtRegion_CheckTopContacts,(a0)

SKHurtRegion_CheckTopContacts:
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
                beq.s   SKHurtRegion_CullOrDebugDrawTop
                move.b  d6,d0
                andi.b  #p1_standing,d0
                beq.s   SKHurtRegion_TryHurtTopP2
                lea     (Player_1).w,a1
                bsr.w   InvisibleHazard_TryHurtPlayer

SKHurtRegion_TryHurtTopP2:
                andi.b  #p2_standing,d6
                beq.s   SKHurtRegion_CullOrDebugDrawTop
                lea     (Player_2).w,a1
                bsr.w   InvisibleHazard_TryHurtPlayer

SKHurtRegion_CullOrDebugDrawTop:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKLavaMarker_ClearMarkerLoadedBit
                tst.w   (Debug_placement_mode).w
                beq.s   SKHurtRegion_TopReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKHurtRegion_TopReturn:
                rts
; ---------------------------------------------------------------------------

SKHurtRegion_CheckSideContacts:
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
                beq.s   SKHurtRegion_CullOrDebugDrawSide
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   SKHurtRegion_TryHurtSideP2
                lea     (Player_1).w,a1
                bsr.w   InvisibleHazard_TryHurtPlayer

SKHurtRegion_TryHurtSideP2:
                andi.b  #2,d6
                beq.s   SKHurtRegion_CullOrDebugDrawSide
                lea     (Player_2).w,a1
                bsr.w   InvisibleHazard_TryHurtPlayer

SKHurtRegion_CullOrDebugDrawSide:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKLavaMarker_ClearMarkerLoadedBit
                tst.w   (Debug_placement_mode).w
                beq.s   SKHurtRegion_SideReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKHurtRegion_SideReturn:
                rts
; ---------------------------------------------------------------------------

SKHurtRegion_CheckUndersideContacts:
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
                beq.s   SKHurtRegion_CullOrDebugDrawUnderside
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   SKHurtRegion_TryHurtUndersideP2
                lea     (Player_1).w,a1
                bsr.w   InvisibleHazard_TryHurtPlayer

SKHurtRegion_TryHurtUndersideP2:
                andi.b  #8,d6
                beq.s   SKHurtRegion_CullOrDebugDrawUnderside
                lea     (Player_2).w,a1
                bsr.w   InvisibleHazard_TryHurtPlayer

SKHurtRegion_CullOrDebugDrawUnderside:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKLavaMarker_ClearMarkerLoadedBit
                tst.w   (Debug_placement_mode).w
                beq.s   SKHurtRegion_UndersideReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKHurtRegion_UndersideReturn:
                rts

; =============== S U B R O U T I N E =======================================

; Skip the solid-hazard damage call if the configured immunity mask matches the player
InvisibleHazard_TryHurtPlayer:
                move.b  shield_reaction(a0),d0
                andi.b  #$73,d0
                and.b   shield_reaction(a1),d0
                bne.s   SKHurtRegion_ImmunityReturn
                bsr.w   HurtPlayerFromSolidHazard

SKHurtRegion_ImmunityReturn:
                rts
; End of function InvisibleHazard_TryHurtPlayer

; ---------------------------------------------------------------------------

Obj_InvisibleHurtBlockVertical:
                move.l  #Map_InvisibleBlock,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ring,0,1),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                bset    #7,status(a0)
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
                beq.s   SKKillRegion_SelectTopOrUnderside
                move.l  #SKKillRegion_CheckSideContacts,(a0)
                rts
; ---------------------------------------------------------------------------

SKKillRegion_SelectTopOrUnderside:
                btst    #1,status(a0)
                beq.s   SKKillRegion_InstallTopHandler
                move.l  #SKKillRegion_CheckUndersideContacts,(a0)
                rts
; ---------------------------------------------------------------------------

SKKillRegion_InstallTopHandler:
                move.l  #SKKillRegion_CheckTopContacts,(a0)

SKKillRegion_CheckTopContacts:
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
                beq.s   SKKillRegion_CullOrDebugDrawTop
                move.b  d6,d0
                andi.b  #p1_standing,d0
                beq.s   SKKillRegion_TryKillTopP2
                lea     (Player_1).w,a1
                bsr.w   KillPlayerFromInvisibleHazard

SKKillRegion_TryKillTopP2:
                andi.b  #p2_standing,d6
                beq.s   SKKillRegion_CullOrDebugDrawTop
                lea     (Player_2).w,a1
                bsr.w   KillPlayerFromInvisibleHazard

SKKillRegion_CullOrDebugDrawTop:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKLavaMarker_ClearMarkerLoadedBit
                tst.w   (Debug_placement_mode).w
                beq.s   SKKillRegion_TopReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKKillRegion_TopReturn:
                rts
; ---------------------------------------------------------------------------

SKKillRegion_CheckSideContacts:
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
                beq.s   SKKillRegion_CullOrDebugDrawSide
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   SKKillRegion_TryKillSideP2
                lea     (Player_1).w,a1
                bsr.w   KillPlayerFromInvisibleHazard

SKKillRegion_TryKillSideP2:
                andi.b  #2,d6
                beq.s   SKKillRegion_CullOrDebugDrawSide
                lea     (Player_2).w,a1
                bsr.w   KillPlayerFromInvisibleHazard

SKKillRegion_CullOrDebugDrawSide:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKLavaMarker_ClearMarkerLoadedBit
                tst.w   (Debug_placement_mode).w
                beq.s   SKKillRegion_SideReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKKillRegion_SideReturn:
                rts
; ---------------------------------------------------------------------------

SKKillRegion_CheckUndersideContacts:
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
                beq.s   SKKillRegion_CullOrDebugDrawUnderside
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   SKKillRegion_TryKillUndersideP2
                lea     (Player_1).w,a1
                bsr.w   KillPlayerFromInvisibleHazard

SKKillRegion_TryKillUndersideP2:
                andi.b  #8,d6
                beq.s   SKKillRegion_CullOrDebugDrawUnderside
                lea     (Player_2).w,a1
                bsr.w   KillPlayerFromInvisibleHazard

SKKillRegion_CullOrDebugDrawUnderside:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKLavaMarker_ClearMarkerLoadedBit
                tst.w   (Debug_placement_mode).w
                beq.s   SKKillRegion_UndersideReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKKillRegion_UndersideReturn:
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
