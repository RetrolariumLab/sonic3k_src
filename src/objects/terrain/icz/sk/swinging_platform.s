; Owner: objects/terrain/icz/sk
; Responsibility: IceCap swinging platform states, linked children, motion helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZSwingingPlatform:
                lea     ObjDat_ICZSwingingPlatform(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SKICZSwingPlat_WaitForSwingImpulse,(a0)
                lea     SKICZSwingPlat_SwingAssemblyChildren(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.w  a1,parent3(a0)
                rts
; ---------------------------------------------------------------------------

SKICZSwingPlat_WaitForSwingImpulse:
                btst    #3,$38(a0)
                beq.s   SKICZSwingPlat_DrawIdlePlatform
                move.l  #SKICZSwingPlat_StepUnflippedAngle,(a0)
                btst    #0,render_flags(a0)
                beq.s   SKICZSwingPlat_DrawIdlePlatform
                move.l  #SKICZSwingPlat_StepMirroredAngle,(a0)

SKICZSwingPlat_DrawIdlePlatform:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

SKICZSwingPlat_StepUnflippedAngle:
                move.w  $3E(a0),d0
                subi.w  #$10,d0
                move.w  d0,$3E(a0)
                move.w  $3C(a0),d1
                add.w   d0,d1
                scc     d2
                tst.w   d0
                bpl.s   SKICZSwingPlat_TryDetachUnflipped
                tst.b   d2
                bne.s   SKICZSwingPlat_ResetSwingAtCenter

SKICZSwingPlat_TryDetachUnflipped:
                move.w  d1,$3C(a0)
                tst.b   subtype(a0)
                beq.s   SKICZSwingPlat_TryProjectUnflipped
                cmpi.w  #$4800,d1
                blo.s   SKICZSwingPlat_TryProjectUnflipped
                cmpi.w  #$200,d0
                bhs.s   SKICZSwingPlat_DetachAndSignalChain

SKICZSwingPlat_TryProjectUnflipped:
                cmpi.w  #$6E00,d1
                bhs.s   SKICZSwingPlat_DrawUnflippedSwing
                moveq   #1,d2
                jsr     MoveSprite_CircularSimple(pc)

SKICZSwingPlat_DrawUnflippedSwing:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

SKICZSwingPlat_ResetSwingAtCenter:
                move.l  #SKICZSwingPlat_WaitForSwingImpulse,(a0)
                bclr    #3,$38(a0)
                clr.w   $3C(a0)
                moveq   #1,d2
                jsr     MoveSprite_CircularSimple(pc)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

SKICZSwingPlat_DetachAndSignalChain:
                move.l  #SKICZSwingPlat_FlyAndTryBounce,(a0)
                bset    #2,$38(a0)
                move.b  #$10,y_radius(a0)
                move.w  #$400,d0
                btst    #0,render_flags(a0)
                beq.s   SKICZSwingPlat_SetThrowVelocity
                neg.w   d0

SKICZSwingPlat_SetThrowVelocity:
                move.w  d0,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

SKICZSwingPlat_StepMirroredAngle:
                move.w  $3E(a0),d0
                addi.w  #$10,d0
                move.w  d0,$3E(a0)
                move.w  $3C(a0),d1
                add.w   d0,d1
                scs     d2
                tst.w   d0
                bmi.s   SKICZSwingPlat_TryDetachMirrored
                tst.b   d2
                bne.s   SKICZSwingPlat_ResetSwingAtCenter

SKICZSwingPlat_TryDetachMirrored:
                move.w  d1,$3C(a0)
                tst.b   subtype(a0)
                beq.s   SKICZSwingPlat_TryProjectMirrored
                cmpi.w  #-$4800,d1
                bhi.s   SKICZSwingPlat_TryProjectMirrored
                cmpi.w  #$200,d0
                bhs.s   SKICZSwingPlat_DetachAndSignalChain

SKICZSwingPlat_TryProjectMirrored:
                cmpi.w  #-$6E00,d1
                bls.s   SKICZSwingPlat_DrawMirroredSwing
                moveq   #1,d2
                jsr     MoveSprite_CircularSimple(pc)

SKICZSwingPlat_DrawMirroredSwing:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

SKICZSwingPlat_FlyAndTryBounce:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   SKICZSwingPlat_DrawFlyingPlatform
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKICZSwingPlat_DrawFlyingPlatform
                add.w   d1,y_pos(a0)
                move.w  y_vel(a0),d0
                cmpi.w  #$100,d0
                blo.s   SKICZSwingPlat_BeginSlideFriction
                asr.w   #2,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                lea     SKICZSwingPlat_BounceDustChildren(pc),a2
                jsr     CreateChild1_Normal(pc)

SKICZSwingPlat_DrawFlyingPlatform:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

SKICZSwingPlat_BeginSlideFriction:
                move.l  #SKICZSwingPlat_SlideAndTryDust,(a0)
                move.w  #$10,d0
                tst.w   x_vel(a0)
                bmi.s   SKICZSwingPlat_SetFrictionAndStopY
                neg.w   d0

SKICZSwingPlat_SetFrictionAndStopY:
                move.w  d0,$40(a0)
                clr.w   y_vel(a0)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

SKICZSwingPlat_SlideAndTryDust:
                move.w  x_vel(a0),d0
                move.w  d0,d1
                add.w   $40(a0),d0
                eor.w   d0,d1
                bmi.s   SKICZSwingPlat_BeginRestingPlatform
                move.w  d0,x_vel(a0)
                move.w  x_pos(a0),d1
                jsr     (MoveSprite2).l
                move.w  x_pos(a0),d0
                eor.w   d0,d1
                btst    #3,d1
                beq.s   SKICZSwingPlat_DrawSlidingPlatform
                lea     SKICZSwingPlat_SlideDustChild(pc),a2
                jsr     CreateChild1_Normal(pc)

SKICZSwingPlat_DrawSlidingPlatform:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

; Stop integrating motion when the next friction step would change sign, leaving the old X speed stored
SKICZSwingPlat_BeginRestingPlatform:
                move.l  #SKICZSwingPlat_DrawRestingPlatform,(a0)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

SKICZSwingPlat_DrawRestingPlatform:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

SKICZSwingPlat_InitMainLedge:
                lea     SKICZSwingPlat_MainLedgeAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #SKICZSwingPlat_TryMainLedgeImpulse,(a0)

SKICZSwingPlat_TryMainLedgeImpulse:
                bsr.w   ICZSwingLedge_UpdateRiderImpulse
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

SKICZSwingPlat_RearmLedgeAfterSwing:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   SKICZSwingPlat_UpdateMovingMainLedge
                move.l  #SKICZSwingPlat_TryMainLedgeImpulse,(a0)

SKICZSwingPlat_UpdateMovingMainLedge:
                bsr.w   RefreshAndCollideIczSwingMainLedge
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

SKICZSwingPlat_InitSideLedge:
                lea     SKICZSwingPlat_SideLedgeAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #SKICZSwingPlat_UpdateSideLedge,(a0)

SKICZSwingPlat_UpdateSideLedge:
                bsr.w   RefreshAndCollideIczSwingSideLedge
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

SKICZSwingPlat_InitChainAnchor:
                lea     SKICZSwingPlat_ChainAnchorAttrs(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #SKICZSwingPlat_UpdateChainAndDraw,(a0)
                subi.w  #$80,y_pos(a0)
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                beq.s   SKICZSwingPlat_InitChainSprites
                bset    #0,render_flags(a0)

SKICZSwingPlat_InitChainSprites:
                bset    #6,render_flags(a0)
                move.w  #7,mainspr_childsprites(a0)
                lea     sub2_mapframe-1(a0),a1
                moveq   #7-1,d6

SKICZSwingPlat_SetChainLinkFrame:
                move.w  #8,(a1)
                addq.w  #next_subspr,a1
                dbf     d6,SKICZSwingPlat_SetChainLinkFrame
                move.b  #8,mapping_frame(a0)

; Rebuild and draw the chain on the same update that handles detachment
SKICZSwingPlat_UpdateChainAndDraw:
                bsr.w   ICZSwingChain_TryBreakOnDetach
                bsr.w   ICZSwingChain_BuildLinkPositions
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

SKICZSwingPlat_InitChainDebris:
                lea     SKICZSwingPlat_ChainDebrisAttrs(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SKICZSwingPlat_MoveChainDebris,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  SKICZSwingPlat_ChainDebrisSpeeds(pc,d0.w),d1
                neg.w   d1
                move.w  d1,y_vel(a0)
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                bne.s   SKICZSwingPlat_SetShardSpeedAndOrigin
                neg.w   d1

SKICZSwingPlat_SetShardSpeedAndOrigin:
                move.w  d1,x_vel(a0)
                lsr.w   #1,d0
                move.b  SKICZSwingPlat_ChainLinkOffsets(pc,d0.w),d0
                movea.w parent3(a0),a1
                move.w  (a1,d0.w),x_pos(a0)
                move.w  sub2_y_pos-sub2_x_pos(a1,d0.w),y_pos(a0)
                rts
; ---------------------------------------------------------------------------
SKICZSwingPlat_ChainDebrisSpeeds:
                dc.w    $80
                dc.w    $100
                dc.w    $180
                dc.w    $200
                dc.w    $280
                dc.w    $300
                dc.w    $380
                dc.w    $400
SKICZSwingPlat_ChainLinkOffsets:
                dc.b    sub9_x_pos
                dc.b    sub2_x_pos
                dc.b    sub3_x_pos
                dc.b    sub4_x_pos
                dc.b    sub5_x_pos
                dc.b    sub6_x_pos
                dc.b    sub7_x_pos
                dc.b    sub8_x_pos
                even
; ---------------------------------------------------------------------------

SKICZSwingPlat_MoveChainDebris:
                jmp     MoveChkDel(pc)

; =============== S U B R O U T I N E =======================================

; Place seven intermediate sub-sprites using shift-rounded eighths of the distance to the platform
ICZSwingChain_BuildLinkPositions:
                movea.w parent3(a0),a1
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),d0
                move.w  x_pos(a1),d1
                sub.w   d0,d1
                swap    d0
                swap    d1
                move.w  y_pos(a0),d0
                move.w  y_pos(a1),d1
                sub.w   d0,d1
                moveq   #0,d5
                moveq   #6,d6

SKICZSwingPlat_InterpolateChainLink:
                move.l  d1,d2
                move.w  SKICZSwingPlat_ChainFractionTable(pc,d5.w),d4
                jsr     SKICZSwingPlat_ChainFractionTable(pc,d4.w)
                move.l  d0,(a2)
                swap    d2
                add.l   d2,(a2)+
                addq.w  #2,a2
                addq.w  #2,d5
                dbf     d6,SKICZSwingPlat_InterpolateChainLink
                rts
; End of function ICZSwingChain_BuildLinkPositions

; ---------------------------------------------------------------------------
SKICZSwingPlat_ChainFractionTable:
                dc.w    SKICZSwingPlat_ScaleDelta1Of8-SKICZSwingPlat_ChainFractionTable
                dc.w    SKICZSwingPlat_ScaleDelta1Of4-SKICZSwingPlat_ChainFractionTable
                dc.w    SKICZSwingPlat_ScaleDelta3Of8-SKICZSwingPlat_ChainFractionTable
                dc.w    SKICZSwingPlat_ScaleDelta1Of2-SKICZSwingPlat_ChainFractionTable
                dc.w    SKICZSwingPlat_ScaleDelta5Of8-SKICZSwingPlat_ChainFractionTable
                dc.w    SKICZSwingPlat_ScaleDelta3Of4-SKICZSwingPlat_ChainFractionTable
                dc.w    SKICZSwingPlat_ScaleDelta7Of8-SKICZSwingPlat_ChainFractionTable
                dc.w    SKICZSwingPlat_ChainFractionReturn-SKICZSwingPlat_ChainFractionTable
; ---------------------------------------------------------------------------

SKICZSwingPlat_ScaleDelta1Of8:
                asr.w   #3,d2
                swap    d2
                asr.w   #3,d2
                rts
; ---------------------------------------------------------------------------

SKICZSwingPlat_ScaleDelta1Of4:
                asr.w   #2,d2
                swap    d2
                asr.w   #2,d2
                rts
; ---------------------------------------------------------------------------

SKICZSwingPlat_ScaleDelta3Of8:
                asr.w   #2,d2
                move.w  d2,d3
                asr.w   #1,d2
                add.w   d3,d2
                swap    d2
                asr.w   #2,d2
                move.w  d2,d3
                asr.w   #1,d2
                add.w   d3,d2
                rts
; ---------------------------------------------------------------------------

SKICZSwingPlat_ScaleDelta1Of2:
                asr.w   #1,d2
                swap    d2
                asr.w   #1,d2
                rts
; ---------------------------------------------------------------------------

SKICZSwingPlat_ScaleDelta5Of8:
                asr.w   #1,d2
                move.w  d2,d3
                asr.w   #2,d2
                add.w   d3,d2
                swap    d2
                asr.w   #1,d2
                move.w  d2,d3
                asr.w   #2,d2
                add.w   d3,d2
                rts
; ---------------------------------------------------------------------------

SKICZSwingPlat_ScaleDelta3Of4:
                asr.w   #1,d2
                move.w  d2,d3
                asr.w   #1,d2
                add.w   d3,d2
                swap    d2
                asr.w   #1,d2
                move.w  d2,d3
                asr.w   #1,d2
                add.w   d3,d2
                rts
; ---------------------------------------------------------------------------

SKICZSwingPlat_ScaleDelta7Of8:
                move.w  d2,d3
                asr.w   #3,d3
                sub.w   d3,d2
                swap    d2
                move.w  d2,d3
                asr.w   #3,d3
                sub.w   d3,d2

SKICZSwingPlat_ChainFractionReturn:
                rts

; =============== S U B R O U T I N E =======================================

RefreshAndCollideIczSwingMainLedge:
                move.w  x_pos(a0),-(sp)
                jsr     Refresh_ChildPosition(pc)
                moveq   #$2B,d1
                moveq   #8,d2
                moveq   #8,d3
                move.w  (sp)+,d4
                jmp     (SolidObjectFull).l
; End of function RefreshAndCollideIczSwingMainLedge

; =============== S U B R O U T I N E =======================================

RefreshAndCollideIczSwingSideLedge:
                move.w  x_pos(a0),-(sp)
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #$F,d1
                moveq   #8,d2
                moveq   #8,d3
                move.w  (sp)+,d4
                jmp     (SolidObjectFull).l
; End of function RefreshAndCollideIczSwingSideLedge

; =============== S U B R O U T I N E =======================================

; Refresh solidity and compare the prior and current riders. Apply the swing impulse for the first eligible player
ICZSwingLedge_UpdateRiderImpulse:
                move.b  status(a0),$39(a0)
                bsr.s   RefreshAndCollideIczSwingMainLedge
                move.b  $39(a0),d0
                move.b  status(a0),d1
                andi.b  #standing_mask,d1
                beq.s   SKICZSwingPlat_LedgeImpulseReturn
                movea.w parent3(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d2
                bsr.w   ICZSwingLedge_TryStartFromRider
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d2
                bsr.w   ICZSwingLedge_TryStartFromRider

SKICZSwingPlat_LedgeImpulseReturn:
                rts
; End of function ICZSwingLedge_UpdateRiderImpulse

; =============== S U B R O U T I N E =======================================

; A rider moving in the required direction supplies a bounded swing impulse and has their own speed adjusted
ICZSwingLedge_TryStartFromRider:
                btst    d2,d1
                beq.s   SKICZSwingPlat_LedgeImpulseReturn
                move.w  x_vel(a1),d3
                smi     d4
                cmpi.w  #-$200,d3
                ble.s   SKICZSwingPlat_TryHalveStandingImpulse
                cmpi.w  #$200,d3
                blt.s   SKICZSwingPlat_LedgeImpulseReturn

SKICZSwingPlat_TryHalveStandingImpulse:
                btst    d2,d0
                beq.s   SKICZSwingPlat_SignImpulseForMirroring
                asr.w   #1,d3

SKICZSwingPlat_SignImpulseForMirroring:
                btst    #0,render_flags(a2)
                beq.s   SKICZSwingPlat_StartSwingFromImpulse
                not.b   d4

SKICZSwingPlat_StartSwingFromImpulse:
                tst.b   d4
                bne.s   SKICZSwingPlat_LedgeImpulseReturn
                move.l  #SKICZSwingPlat_RearmLedgeAfterSwing,(a0)
                bset    #3,$38(a2)
                asr.w   #1,d3
                bmi.s   SKICZSwingPlat_ClampNegativeImpulse
                cmpi.w  #$400,d3
                ble.s   SKICZSwingPlat_SetImpulseAndSkipCaller
                move.w  #$400,d3
                bra.w   SKICZSwingPlat_SetImpulseAndSkipCaller
; ---------------------------------------------------------------------------

SKICZSwingPlat_ClampNegativeImpulse:
                cmpi.w  #-$400,d3
                bge.s   SKICZSwingPlat_SetImpulseAndSkipCaller
                move.w  #-$400,d3

; The first accepted rider sets the swing speed and discards the return address for the remaining rider pass
SKICZSwingPlat_SetImpulseAndSkipCaller:
                move.w  d3,$3E(a2)
                asl.w   #1,d3
                move.w  d3,x_vel(a1)
                move.w  d3,ground_vel(a1)
                addq.w  #4,sp

SKICZSwingPlat_SwingOrChainReturn:
                rts
; End of function ICZSwingLedge_TryStartFromRider

; =============== S U B R O U T I N E =======================================

; When the parent detaches, request eight fragments and schedule composite sprite deletion
ICZSwingChain_TryBreakOnDetach:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   SKICZSwingPlat_SwingOrChainReturn
                move.w  x_pos(a0),sub5_x_pos(a0)
                move.w  y_pos(a0),sub5_y_pos(a0)
                lea     SKICZSwingPlat_ChainDebrisChildren(pc),a2
                jsr     CreateChild6_Simple(pc)
                jmp     Go_Delete_Sprite_2(pc)
; End of function ICZSwingChain_TryBreakOnDetach

; ---------------------------------------------------------------------------
ObjDat_ICZSwingingPlatform:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,1,0)
                dc.w    $80
                dc.b    $20, $10,   7,   0
SKICZSwingPlat_ChainAnchorAttrs:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $80, $80,   8,   0
SKICZSwingPlat_ChainDebrisAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    8,   8,   8,   0
SKICZSwingPlat_MainLedgeAttrs:
                dc.w    $300
                dc.b    $20, $10, $27,   0
SKICZSwingPlat_SideLedgeAttrs:
                dc.w    $300
                dc.b    $30,   8, $27,   0
SKICZSwingPlat_SwingAssemblyChildren:
                dc.w    3-1
                dc.l    SKICZSwingPlat_InitMainLedge
                dc.b    0,   8
                dc.l    SKICZSwingPlat_InitSideLedge
                dc.b    $1C,  -8
                dc.l    SKICZSwingPlat_InitChainAnchor
                dc.b    0,   0
SKICZSwingPlat_ChainDebrisChildren:
                dc.w    8-1
                dc.l    SKICZSwingPlat_InitChainDebris
SKICZSwingPlat_BounceDustChildren:
                dc.w    2-1
                dc.l    Obj_ICZSnowdust
                dc.b    $1C, $10
                dc.l    Obj_ICZSnowdust
                dc.b    $14, $10
SKICZSwingPlat_SlideDustChild:
                dc.w    1-1
                dc.l    Obj_ICZSnowdust
                dc.b    $1C, $10
