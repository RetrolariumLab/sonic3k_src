; Owner: objects/terrain/icz/sk
; Responsibility: IceCap breakable wall and ice-block behavior, collision helpers and private construction data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZBreakableWall:
                lea     ObjDat_ICZBreakableWall(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SKICZBreakIce_ResolveWallAndCheckBreak,(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKICZBreakIce_ResolveWallAndCheckBreak:
                moveq   #$2B,d1
                moveq   #$40,d2
                moveq   #$70,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   SKICZBreakIce_CheckPlatformOverlap
                swap    d6
                andi.w  #1,d6
                bne.s   SKICZBreakIce_ShatterWall

SKICZBreakIce_CheckPlatformOverlap:
                movea.w (SceneControllerObjectAddress).w,a1
                cmpi.l  #Obj_ICZPathFollowPlatform_2,(a1)
                bne.s   SKICZBreakIce_DrawIntactWall
                move.w  x_pos(a1),d0
                move.w  y_pos(a1),d1
                and.w   (Screen_Y_wrap_value).w,d1
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                lea     SKICZBreakIce_PlatformBreakBounds(pc),a2
                add.w   (a2)+,d2
                cmp.w   d2,d0
                blo.s   SKICZBreakIce_DrawIntactWall
                add.w   (a2)+,d2
                cmp.w   d2,d0
                bhs.s   SKICZBreakIce_DrawIntactWall
                add.w   (a2)+,d3
                cmp.w   d3,d1
                blo.s   SKICZBreakIce_DrawIntactWall
                add.w   (a2)+,d3
                cmp.w   d3,d1
                blo.s   SKICZBreakIce_ShatterWall

SKICZBreakIce_DrawIntactWall:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKICZBreakIce_ShatterWall:
                lea     SKICZBreakIce_WallDebrisChildren(pc),a2
                jsr     CreateChild6_Simple(pc)
                jsr     Go_Delete_Sprite(pc)
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
SKICZBreakIce_PlatformBreakBounds:
                dc.w    -$30,   $60,  -$40,   $80
; ---------------------------------------------------------------------------

SKICZBreakIce_InitAttachedIcePiece:
                lea     SKICZBreakIce_AttachedIcePieceAttrs(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SKICZBreakIce_TryReleaseIcePiece,(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKICZBreakIce_TryReleaseIcePiece:
                movea.w parent3(a0),a1
                btst    #p1_standing_bit,status(a1)
                beq.s   SKICZBreakIce_DrawAttachedIcePiece
                move.l  #MoveChkDel,(a0)

SKICZBreakIce_DrawAttachedIcePiece:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_ICZIceBlock:
                jsr     (Obj_WaitOffscreen).l
                lea     ObjDat_ICZIceBlock(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SKICZBreakIce_UpdateIceBlockSolid,(a0)

SKICZBreakIce_UpdateIceBlockSolid:
                moveq   #$1B,d1
                moveq   #$10,d2
                moveq   #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

; Accept the signed candidate only within inclusive -$C00 to $C00
ICZPathPlatform_TrySetXVel:
                cmpi.w  #-$C00,d0
                blt.s   SKICZBreakIce_LimitXSpeedReturn
                cmpi.w  #$C00,d0
                bgt.s   SKICZBreakIce_LimitXSpeedReturn
                move.w  d0,x_vel(a0)

SKICZBreakIce_LimitXSpeedReturn:
                rts
; End of function ICZPathPlatform_TrySetXVel

; =============== S U B R O U T I N E =======================================

; Add $38 to Y velocity only if the result remains within inclusive -$C00 to $C00
ICZPathPlatform_TryApplyGravity:
                move.w  y_vel(a0),d0
                addi.w  #$38,d0
                cmpi.w  #-$C00,d0
                blt.s   SKICZBreakIce_LimitGravityReturn
                cmpi.w  #$C00,d0
                bgt.s   SKICZBreakIce_LimitGravityReturn
                move.w  d0,y_vel(a0)

SKICZBreakIce_LimitGravityReturn:
                rts
; End of function ICZPathPlatform_TryApplyGravity

; =============== S U B R O U T I N E =======================================

; Use the absolute horizontal speed and the quantized saved floor angle
ICZPathPlatform_SetDepartureYVel:
                move.b  angle(a0),d3
                lsr.b   #3,d3
                andi.w  #$E,d3
                move.w  x_vel(a0),d1
                bpl.s   SKICZBreakIce_DispatchExitYSpeed
                neg.w   d1

SKICZBreakIce_DispatchExitYSpeed:
                move.w  SKICZBreakIce_ExitYSpeedTable(pc,d3.w),d0
                jmp     SKICZBreakIce_ExitYSpeedTable(pc,d0.w)
; End of function ICZPathPlatform_SetDepartureYVel

; ---------------------------------------------------------------------------
SKICZBreakIce_ExitYSpeedTable:
                dc.w    SKICZBreakIce_ClearExitYSpeed-SKICZBreakIce_ExitYSpeedTable
                dc.w    SKICZBreakIce_SetHalfXExitYSpeed-SKICZBreakIce_ExitYSpeedTable
                dc.w    SKICZBreakIce_SetFullXExitYSpeed-SKICZBreakIce_ExitYSpeedTable
                dc.w    SKICZBreakIce_SetHalfXExitYSpeed-SKICZBreakIce_ExitYSpeedTable
                dc.w    SKICZBreakIce_ClearExitYSpeed-SKICZBreakIce_ExitYSpeedTable
                dc.w    SKICZBreakIce_SetHalfXExitYSpeed-SKICZBreakIce_ExitYSpeedTable
                dc.w    SKICZBreakIce_SetFullXExitYSpeed-SKICZBreakIce_ExitYSpeedTable
                dc.w    SKICZBreakIce_SetHalfXExitYSpeed-SKICZBreakIce_ExitYSpeedTable
; ---------------------------------------------------------------------------

SKICZBreakIce_ClearExitYSpeed:
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKICZBreakIce_SetHalfXExitYSpeed:
                lsr.w   #1,d1
                move.w  d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKICZBreakIce_SetFullXExitYSpeed:
                move.w  d1,y_vel(a0)
                rts

; =============== S U B R O U T I N E =======================================

SetFastVerticalCameraForIczPlatformRider:
                clr.b   (Fast_V_scroll_flag).w
                tst.w   x_vel(a0)
                bne.s   SKICZBreakIce_CheckP1FastCamera
                tst.w   y_vel(a0)
                beq.s   SKICZBreakIce_FastCameraReturn

SKICZBreakIce_CheckP1FastCamera:
                btst    #p1_standing_bit,status(a0)
                beq.s   SKICZBreakIce_FastCameraReturn
                st      (Fast_V_scroll_flag).w

SKICZBreakIce_FastCameraReturn:
                rts
; End of function SetFastVerticalCameraForIczPlatformRider

; ---------------------------------------------------------------------------
ObjDat_ICZPathFollowPlatform:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $20, $14,   0,   0
ObjDat_ICZIceBlock:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,0)
                dc.w    $280
                dc.b    $10, $10, $1E,   0
SKICZBreakIce_AttachedIcePieceAttrs:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $10,  $C,   8,   0
ObjDat_ICZBreakableWall:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $20, $40,   6,   0
SKICZBreakIce_PlatformDebrisAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,1)
                dc.w    $80
                dc.b    8,   8, $23,   0
SKICZBreakIce_WallDebrisAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZIntroSprites,2,1)
                dc.w    $80
                dc.b    $C,  $C, $1C,   0
SKICZBreakIce_PlatformDebrisChildren:
                dc.w    6-1
                dc.l    SKICZPathPlat_InitPlatformDebris
SKICZBreakIce_WallDebrisChildren:
                dc.w    9-1
                dc.l    SKICZPathPlat_InitWallDebris
SKICZBreakIce_AttachedIcePieceChild:
                dc.w    1-1
                dc.l    SKICZBreakIce_InitAttachedIcePiece
                dc.b    -$10, $10
SKICZBreakIce_PlatformDebrisAnim:
                dc.b    2, $23, $13, $24, $14, $FC
SKICZBreakIce_WallDebrisAnim:
                dc.b    2, $1C, $1D, $25, $26, $FC
                even
