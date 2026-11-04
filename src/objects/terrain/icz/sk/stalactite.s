; Owner: objects/terrain/icz/sk
; Responsibility: IceCap falling stalactite state, trigger helper and private child data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZStalagtite:
                jsr     Obj_WaitOffscreen(pc)
                lea     ObjDat_ICZStalagtite(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SKICZStalactite_ResolveSolidAndTryShake,(a0)
                move.b  #$10,y_radius(a0)
                rts
; ---------------------------------------------------------------------------

SKICZStalactite_ResolveSolidAndTryShake:
                bsr.w   CollideIczStalactiteAsSolidRectangle
                jsr     Find_SonicTails(pc)
                cmpi.w  #$70,d2
                bhs.s   SKICZStalactite_DrawIntact
                move.l  #SKICZStalactite_ChooseShakeOffset,(a0)
                move.w  #$F,$2E(a0)
                move.l  #SKICZStalactite_BeginHarmfulFall,$34(a0)

SKICZStalactite_DrawIntact:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

SKICZStalactite_ChooseShakeOffset:
                moveq   #2,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   SKICZStalactite_ShakeAndTickRelease
                neg.w   d0

SKICZStalactite_ShakeAndTickRelease:
                add.w   d0,x_pos(a0)
                jsr     Obj_Wait(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

SKICZStalactite_BeginHarmfulFall:
                move.l  #SKICZStalactite_FallAndCheckImpact,(a0)
                move.b  #$82,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

SKICZStalactite_FallAndCheckImpact:
                jsr     (MoveSprite).l
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   SKICZStalactite_DrawFalling
                move.l  #SKICZStalactite_UpdateSettledSolid,(a0)
                clr.b   collision_flags(a0)
                lea     SKICZStalactite_IceShardChildren(pc),a2
                jsr     CreateChild6_Simple(pc)
                moveq   #signextendB(sfx_FloorThump),d0
                jsr     (Play_SFX).l

SKICZStalactite_DrawFalling:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

SKICZStalactite_UpdateSettledSolid:
                bsr.w   CollideIczStalactiteAsSolidRectangle
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

SKICZStalactite_InitIceShard:
                lea     SKICZStalactite_IceShardAttrs(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AnimateRaw_MoveChkDel,(a0)
                move.l  #SKICZFreezer_SmallIceShardAnim,$30(a0)
                cmpi.b  #6,subtype(a0)
                bhs.s   SKICZStalactite_SetShardFrameAndSpeed
                move.l  #SKICZFreezer_MediumIceShardAnim,$30(a0)

SKICZStalactite_SetShardFrameAndSpeed:
                jsr     (Random_Number).l
                andi.b  #3,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d0
                jmp     Set_IndexedVelocity(pc)

; =============== S U B R O U T I N E =======================================

CollideIczStalactiteAsSolidRectangle:
                moveq   #$1B,d1
                moveq   #$20,d2
                moveq   #$20,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function CollideIczStalactiteAsSolidRectangle

; ---------------------------------------------------------------------------
ObjDat_ICZStalagtite:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $10, $20,   7,   0
SKICZStalactite_IceShardAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,1)
                dc.w    $280
                dc.b    4,   4,  $F,   0
; The simple child spawner reads the count and handler. The stored tail is unused
SKICZStalactite_IceShardChildren:
                dc.w    $C-1
                dc.l    SKICZStalactite_InitIceShard
                dc.b    0, $27
                dc.b    $F, $27, $10, $27, $11, $FC
                even
