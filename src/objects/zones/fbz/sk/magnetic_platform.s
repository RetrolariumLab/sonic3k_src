; Owner: objects/zones/fbz/sk
; Responsibility: Magnetic platform state, movement, player collision and riding
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZMagneticPlatform:
                move.l  #Map_FBZMagneticPlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc+$CA,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  #$F,y_radius(a0)
                move.w  y_pos(a0),$46(a0)
                move.b  #$8D,collision_flags(a0)
                moveq   #0,d1
                move.b  subtype(a0),d1
                lsl.w   #4,d1
                subi.w  #$20,d1
                move.w  d1,$2E(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKFBZMagPlat_StartFalling
                move.l  #SKFBZMagPlat_DrawChainActor,(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$80,height_pixels(a1)
                move.w  #$200,priority(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subi.w  #$70,y_pos(a1)
                moveq   #8,d0
                bset    #6,render_flags(a1)
                move.w  d0,mainspr_childsprites(a1)
                move.w  y_pos(a0),d1
                addi.w  #$C,d1
                lea     sub2_x_pos(a1),a2
                move.w  mainspr_childsprites(a1),d0
                subq.w  #1,d0

SKFBZMagPlat_InitChainSprites:
                move.w  x_pos(a0),(a2)+
                move.w  d1,(a2)+
                move.w  #1,(a2)+
                dbf     d0,SKFBZMagPlat_InitChainSprites
                move.w  #3,$1C(a1)
                move.w  a1,$3C(a0)

; The platform starts moving even when the chain actor could not be allocated
SKFBZMagPlat_StartFalling:
                move.l  #SKFBZMagPlat_FallAndCheckFloor,(a0)

SKFBZMagPlat_FallAndCheckFloor:
                jsr     (MoveSprite2).l
                addi.w  #$58,y_vel(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKFBZMagPlat_TrySwitchToRising
                add.w   d1,y_pos(a0)
                move.w  #0,y_vel(a0)
                move.b  #$10,y_radius(a0)
                move.l  #SKFBZMagPlat_TrySwitchToRising,(a0)

SKFBZMagPlat_TrySwitchToRising:
                tst.b   (_unkF7C1).w
                beq.s   SKFBZMagPlat_FinishFallUpdate
                move.l  #SKFBZMagPlat_RiseAndCheckHeight,(a0)

SKFBZMagPlat_FinishFallUpdate:
                bra.s   SKFBZMagPlat_RebuildChainAndResolveSolid
; ---------------------------------------------------------------------------

SKFBZMagPlat_RiseAndCheckHeight:
                jsr     (MoveSprite2).l
                subi.w  #$18,y_vel(a0)
                move.w  $46(a0),d0
                sub.w   y_pos(a0),d0
                cmp.w   $2E(a0),d0
                blo.s   SKFBZMagPlat_TryStopAtCeiling
                move.w  $46(a0),d0
                sub.w   $2E(a0),d0
                move.w  d0,y_pos(a0)
                move.w  #0,y_vel(a0)
                move.l  #SKFBZMagPlat_WaitForMagnetOff,(a0)
                moveq   #signextendB(sfx_ChainTension),d0
                jsr     (Play_SFX).l
                bra.s   SKFBZMagPlat_WaitForMagnetOff
; ---------------------------------------------------------------------------

SKFBZMagPlat_TryStopAtCeiling:
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   SKFBZMagPlat_WaitForMagnetOff
                sub.w   d1,y_pos(a0)
                move.w  #0,y_vel(a0)
                move.l  #SKFBZMagPlat_WaitForMagnetOff,(a0)

SKFBZMagPlat_WaitForMagnetOff:
                tst.b   (_unkF7C1).w
                bne.s   SKFBZMagPlat_RebuildChainAndResolveSolid
                move.b  #$F,y_radius(a0)
                move.l  #SKFBZMagPlat_FallAndCheckFloor,(a0)

; The chain update uses the stored child pointer directly
SKFBZMagPlat_RebuildChainAndResolveSolid:
                bsr.w   BuildFbzMagneticPlatformChainSprites
                move.w  #$23,d1
                move.w  #8,d2
                move.w  #-9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull_Offset).l
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

SKFBZMagPlat_DrawChainActor:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

BuildFbzMagneticPlatformChainSprites:
                movea.w $3C(a0),a1
                lea     $20(a1),a2
                move.w  y_pos(a0),d2
                addi.w  #$18,d2
                move.w  $46(a0),d0
                sub.w   y_pos(a0),d0
                move.w  d0,d6
                addi.w  #$18,d6
                lsr.w   #5,d6
                addq.w  #1,d6
                cmpi.w  #8,d6
                blo.s   SKFBZMagPlat_SetChainSpriteCount
                moveq   #8,d6

SKFBZMagPlat_SetChainSpriteCount:
                move.w  d6,mainspr_childsprites(a1)
                subq.w  #2,d6
                bcs.s   SKFBZMagPlat_ChainBuildReturn

SKFBZMagPlat_PlaceChainSegments:
                move.w  d2,(a2)+
                move.w  #2,(a2)+
                addq.w  #2,a2
                addi.w  #$20,d2
                dbf     d6,SKFBZMagPlat_PlaceChainSegments
                subq.w  #8,d0
                andi.w  #$1F,d0
                cmpi.w  #$10,d0
                bhs.s   SKFBZMagPlat_ChainBuildReturn
                move.w  #1,-4(a2)

SKFBZMagPlat_ChainBuildReturn:
                rts
; End of function BuildFbzMagneticPlatformChainSprites

; ---------------------------------------------------------------------------
Map_FBZMagneticPlatform:
                include "src/objects/shared/zones/fbz/mappings/magnetic_platform.s"
