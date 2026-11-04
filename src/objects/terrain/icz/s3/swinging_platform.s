; Owner: objects/terrain/icz/s3
; Responsibility: IceCap swinging platform states, linked children, motion helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZSwingingPlatform:
                lea     ObjDat_ICZSwingingPlatform(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #S3ICZSwingPlat_WaitForSwingImpulse,(a0)
                lea     S3ICZSwingPlat_SwingAssemblyChildren(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.w  a1,parent3(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZSwingPlat_WaitForSwingImpulse:
                btst    #3,$38(a0)
                beq.s   S3ICZSwingPlat_DrawIdlePlatform
                move.l  #S3ICZSwingPlat_StepUnflippedAngle,(a0)
                btst    #0,render_flags(a0)
                beq.s   S3ICZSwingPlat_DrawIdlePlatform
                move.l  #S3ICZSwingPlat_StepMirroredAngle,(a0)

S3ICZSwingPlat_DrawIdlePlatform:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

S3ICZSwingPlat_StepUnflippedAngle:
                move.w  $3E(a0),d0
                subi.w  #$10,d0
                move.w  d0,$3E(a0)
                move.w  $3C(a0),d1
                add.w   d0,d1
                scc     d2
                tst.w   d0
                bpl.s   S3ICZSwingPlat_TryDetachUnflipped
                tst.b   d2
                bne.s   S3ICZSwingPlat_ResetSwingAtCenter

S3ICZSwingPlat_TryDetachUnflipped:
                move.w  d1,$3C(a0)
                tst.b   subtype(a0)
                beq.s   S3ICZSwingPlat_TryProjectUnflipped
                cmpi.w  #$4800,d1
                blo.s   S3ICZSwingPlat_TryProjectUnflipped
                cmpi.w  #$200,d0
                bhs.s   S3ICZSwingPlat_DetachAndSignalChain

S3ICZSwingPlat_TryProjectUnflipped:
                cmpi.w  #$6E00,d1
                bhs.s   S3ICZSwingPlat_DrawUnflippedSwing
                moveq   #1,d2
                jsr     MoveSprite_CircularSimple(pc)

S3ICZSwingPlat_DrawUnflippedSwing:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

S3ICZSwingPlat_ResetSwingAtCenter:
                move.l  #S3ICZSwingPlat_WaitForSwingImpulse,(a0)
                bclr    #3,$38(a0)
                clr.w   $3C(a0)
                moveq   #1,d2
                jsr     MoveSprite_CircularSimple(pc)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

S3ICZSwingPlat_DetachAndSignalChain:
                move.l  #S3ICZSwingPlat_FlyAndTryBounce,(a0)
                bset    #2,$38(a0)
                move.b  #$10,y_radius(a0)
                move.w  #$400,d0
                btst    #0,render_flags(a0)
                beq.s   S3ICZSwingPlat_SetThrowVelocity
                neg.w   d0

S3ICZSwingPlat_SetThrowVelocity:
                move.w  d0,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

S3ICZSwingPlat_StepMirroredAngle:
                move.w  $3E(a0),d0
                addi.w  #$10,d0
                move.w  d0,$3E(a0)
                move.w  $3C(a0),d1
                add.w   d0,d1
                scs     d2
                tst.w   d0
                bmi.s   S3ICZSwingPlat_TryDetachMirrored
                tst.b   d2
                bne.s   S3ICZSwingPlat_ResetSwingAtCenter

S3ICZSwingPlat_TryDetachMirrored:
                move.w  d1,$3C(a0)
                tst.b   subtype(a0)
                beq.s   S3ICZSwingPlat_TryProjectMirrored
                cmpi.w  #-$4800,d1
                bhi.s   S3ICZSwingPlat_TryProjectMirrored
                cmpi.w  #$200,d0
                bhs.s   S3ICZSwingPlat_DetachAndSignalChain

S3ICZSwingPlat_TryProjectMirrored:
                cmpi.w  #-$6E00,d1
                bls.s   S3ICZSwingPlat_DrawMirroredSwing
                moveq   #1,d2
                jsr     MoveSprite_CircularSimple(pc)

S3ICZSwingPlat_DrawMirroredSwing:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

S3ICZSwingPlat_FlyAndTryBounce:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   S3ICZSwingPlat_DrawFlyingPlatform
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   S3ICZSwingPlat_DrawFlyingPlatform
                add.w   d1,y_pos(a0)
                move.w  y_vel(a0),d0
                cmpi.w  #$100,d0
                blo.s   S3ICZSwingPlat_BeginSlideFriction
                asr.w   #2,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                lea     S3ICZSwingPlat_BounceDustChildren(pc),a2
                jsr     CreateChild1_Normal(pc)

S3ICZSwingPlat_DrawFlyingPlatform:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

S3ICZSwingPlat_BeginSlideFriction:
                move.l  #S3ICZSwingPlat_SlideAndTryDust,(a0)
                move.w  #$10,d0
                tst.w   x_vel(a0)
                bmi.s   S3ICZSwingPlat_SetFrictionAndStopY
                neg.w   d0

S3ICZSwingPlat_SetFrictionAndStopY:
                move.w  d0,$40(a0)
                clr.w   y_vel(a0)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

S3ICZSwingPlat_SlideAndTryDust:
                move.w  x_vel(a0),d0
                move.w  d0,d1
                add.w   $40(a0),d0
                eor.w   d0,d1
                bmi.s   S3ICZSwingPlat_BeginRestingPlatform
                move.w  d0,x_vel(a0)
                move.w  x_pos(a0),d1
                jsr     (MoveSprite2).l
                move.w  x_pos(a0),d0
                eor.w   d0,d1
                btst    #3,d1
                beq.s   S3ICZSwingPlat_DrawSlidingPlatform
                lea     S3ICZSwingPlat_SlideDustChild(pc),a2
                jsr     CreateChild1_Normal(pc)

S3ICZSwingPlat_DrawSlidingPlatform:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

; Stop integrating motion when the next friction step would change sign, leaving the old X speed stored
S3ICZSwingPlat_BeginRestingPlatform:
                move.l  #S3ICZSwingPlat_DrawRestingPlatform,(a0)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

S3ICZSwingPlat_DrawRestingPlatform:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

S3ICZSwingPlat_InitMainLedge:
                lea     S3ICZSwingPlat_MainLedgeAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #S3ICZSwingPlat_TryMainLedgeImpulse,(a0)

S3ICZSwingPlat_TryMainLedgeImpulse:
                bsr.w   ICZSwingLedge_UpdateRiderImpulse
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

S3ICZSwingPlat_RearmLedgeAfterSwing:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   S3ICZSwingPlat_UpdateMovingMainLedge
                move.l  #S3ICZSwingPlat_TryMainLedgeImpulse,(a0)

S3ICZSwingPlat_UpdateMovingMainLedge:
                bsr.w   RefreshAndCollideIczSwingMainLedge
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

S3ICZSwingPlat_InitSideLedge:
                lea     S3ICZSwingPlat_SideLedgeAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #S3ICZSwingPlat_UpdateSideLedge,(a0)

S3ICZSwingPlat_UpdateSideLedge:
                bsr.w   RefreshAndCollideIczSwingSideLedge
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

S3ICZSwingPlat_InitChainAnchor:
                lea     S3ICZSwingPlat_ChainAnchorAttrs(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #S3ICZSwingPlat_UpdateChainAndDraw,(a0)
                subi.w  #$80,y_pos(a0)
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                beq.s   S3ICZSwingPlat_InitChainSprites
                bset    #0,render_flags(a0)

S3ICZSwingPlat_InitChainSprites:
                bset    #6,render_flags(a0)
                move.w  #7,mainspr_childsprites(a0)
                lea     sub2_mapframe-1(a0),a1
                moveq   #7-1,d6

S3ICZSwingPlat_SetChainLinkFrame:
                move.w  #8,(a1)
                addq.w  #next_subspr,a1
                dbf     d6,S3ICZSwingPlat_SetChainLinkFrame
                move.b  #8,mapping_frame(a0)

; Rebuild and draw the chain on the same update that handles detachment
S3ICZSwingPlat_UpdateChainAndDraw:
                bsr.w   ICZSwingChain_TryBreakOnDetach
                bsr.w   ICZSwingChain_BuildLinkPositions
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

S3ICZSwingPlat_InitChainDebris:
                lea     S3ICZSwingPlat_ChainDebrisAttrs(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #S3ICZSwingPlat_MoveChainDebris,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  S3ICZSwingPlat_ChainDebrisSpeeds(pc,d0.w),d1
                neg.w   d1
                move.w  d1,y_vel(a0)
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                bne.s   S3ICZSwingPlat_SetShardSpeedAndOrigin
                neg.w   d1

S3ICZSwingPlat_SetShardSpeedAndOrigin:
                move.w  d1,x_vel(a0)
                lsr.w   #1,d0
                move.b  S3ICZSwingPlat_ChainLinkOffsets(pc,d0.w),d0
                movea.w parent3(a0),a1
                move.w  (a1,d0.w),x_pos(a0)
                move.w  sub2_y_pos-sub2_x_pos(a1,d0.w),y_pos(a0)
                rts
; ---------------------------------------------------------------------------
S3ICZSwingPlat_ChainDebrisSpeeds:
                dc.w    $80
                dc.w    $100
                dc.w    $180
                dc.w    $200
                dc.w    $280
                dc.w    $300
                dc.w    $380
                dc.w    $400
S3ICZSwingPlat_ChainLinkOffsets:
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

S3ICZSwingPlat_MoveChainDebris:
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

S3ICZSwingPlat_InterpolateChainLink:
                move.l  d1,d2
                move.w  S3ICZSwingPlat_ChainFractionTable(pc,d5.w),d4
                jsr     S3ICZSwingPlat_ChainFractionTable(pc,d4.w)
                move.l  d0,(a2)
                swap    d2
                add.l   d2,(a2)+
                addq.w  #2,a2
                addq.w  #2,d5
                dbf     d6,S3ICZSwingPlat_InterpolateChainLink
                rts
; End of function ICZSwingChain_BuildLinkPositions

; ---------------------------------------------------------------------------
S3ICZSwingPlat_ChainFractionTable:
                dc.w    S3ICZSwingPlat_ScaleDelta1Of8-S3ICZSwingPlat_ChainFractionTable
                dc.w    S3ICZSwingPlat_ScaleDelta1Of4-S3ICZSwingPlat_ChainFractionTable
                dc.w    S3ICZSwingPlat_ScaleDelta3Of8-S3ICZSwingPlat_ChainFractionTable
                dc.w    S3ICZSwingPlat_ScaleDelta1Of2-S3ICZSwingPlat_ChainFractionTable
                dc.w    S3ICZSwingPlat_ScaleDelta5Of8-S3ICZSwingPlat_ChainFractionTable
                dc.w    S3ICZSwingPlat_ScaleDelta3Of4-S3ICZSwingPlat_ChainFractionTable
                dc.w    S3ICZSwingPlat_ScaleDelta7Of8-S3ICZSwingPlat_ChainFractionTable
                dc.w    S3ICZSwingPlat_ChainFractionReturn-S3ICZSwingPlat_ChainFractionTable
; ---------------------------------------------------------------------------

S3ICZSwingPlat_ScaleDelta1Of8:
                asr.w   #3,d2
                swap    d2
                asr.w   #3,d2
                rts
; ---------------------------------------------------------------------------

S3ICZSwingPlat_ScaleDelta1Of4:
                asr.w   #2,d2
                swap    d2
                asr.w   #2,d2
                rts
; ---------------------------------------------------------------------------

S3ICZSwingPlat_ScaleDelta3Of8:
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

S3ICZSwingPlat_ScaleDelta1Of2:
                asr.w   #1,d2
                swap    d2
                asr.w   #1,d2
                rts
; ---------------------------------------------------------------------------

S3ICZSwingPlat_ScaleDelta5Of8:
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

S3ICZSwingPlat_ScaleDelta3Of4:
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

S3ICZSwingPlat_ScaleDelta7Of8:
                move.w  d2,d3
                asr.w   #3,d3
                sub.w   d3,d2
                swap    d2
                move.w  d2,d3
                asr.w   #3,d3
                sub.w   d3,d2

S3ICZSwingPlat_ChainFractionReturn:
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
                beq.s   S3ICZSwingPlat_LedgeImpulseReturn
                movea.w parent3(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d2
                bsr.w   ICZSwingLedge_TryStartFromRider
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d2
                bsr.w   ICZSwingLedge_TryStartFromRider

S3ICZSwingPlat_LedgeImpulseReturn:
                rts
; End of function ICZSwingLedge_UpdateRiderImpulse

; =============== S U B R O U T I N E =======================================

; A rider moving in the required direction supplies a bounded swing impulse and has their own speed adjusted
ICZSwingLedge_TryStartFromRider:
                btst    d2,d1
                beq.s   S3ICZSwingPlat_LedgeImpulseReturn
                move.w  x_vel(a1),d3
                smi     d4
                cmpi.w  #-$200,d3
                ble.s   S3ICZSwingPlat_TryHalveStandingImpulse
                cmpi.w  #$200,d3
                blt.s   S3ICZSwingPlat_LedgeImpulseReturn

S3ICZSwingPlat_TryHalveStandingImpulse:
                btst    d2,d0
                beq.s   S3ICZSwingPlat_SignImpulseForMirroring
                asr.w   #1,d3

S3ICZSwingPlat_SignImpulseForMirroring:
                btst    #0,render_flags(a2)
                beq.s   S3ICZSwingPlat_StartSwingFromImpulse
                not.b   d4

S3ICZSwingPlat_StartSwingFromImpulse:
                tst.b   d4
                bne.s   S3ICZSwingPlat_LedgeImpulseReturn
                move.l  #S3ICZSwingPlat_RearmLedgeAfterSwing,(a0)
                bset    #3,$38(a2)
                asr.w   #1,d3
                bmi.s   S3ICZSwingPlat_ClampNegativeImpulse
                cmpi.w  #$400,d3
                ble.s   S3ICZSwingPlat_SetImpulseAndSkipCaller
                move.w  #$400,d3
                bra.w   S3ICZSwingPlat_SetImpulseAndSkipCaller
; ---------------------------------------------------------------------------

S3ICZSwingPlat_ClampNegativeImpulse:
                cmpi.w  #-$400,d3
                bge.s   S3ICZSwingPlat_SetImpulseAndSkipCaller
                move.w  #-$400,d3

; The first accepted rider sets the swing speed and discards the return address for the remaining rider pass
S3ICZSwingPlat_SetImpulseAndSkipCaller:
                move.w  d3,$3E(a2)
                asl.w   #1,d3
                move.w  d3,x_vel(a1)
                move.w  d3,ground_vel(a1)
                addq.w  #4,sp

S3ICZSwingPlat_SwingOrChainReturn:
                rts
; End of function ICZSwingLedge_TryStartFromRider

; =============== S U B R O U T I N E =======================================

; When the parent detaches, request eight fragments and schedule composite sprite deletion
ICZSwingChain_TryBreakOnDetach:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   S3ICZSwingPlat_SwingOrChainReturn
                move.w  x_pos(a0),sub5_x_pos(a0)
                move.w  y_pos(a0),sub5_y_pos(a0)
                lea     S3ICZSwingPlat_ChainDebrisChildren(pc),a2
                jsr     CreateChild6_Simple(pc)
                jmp     Go_Delete_Sprite_2(pc)
; End of function ICZSwingChain_TryBreakOnDetach

; ---------------------------------------------------------------------------
ObjDat_ICZSwingingPlatform:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,1,0)
                dc.w    $80
                dc.b    $20, $10,   7,   0
S3ICZSwingPlat_ChainAnchorAttrs:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $80, $80,   8,   0
S3ICZSwingPlat_ChainDebrisAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    8,   8,   8,   0
S3ICZSwingPlat_MainLedgeAttrs:
                dc.w    $300
                dc.b    $20, $10, $27,   0
S3ICZSwingPlat_SideLedgeAttrs:
                dc.w    $300
                dc.b    $30,   8, $27,   0
S3ICZSwingPlat_SwingAssemblyChildren:
                dc.w    3-1
                dc.l    S3ICZSwingPlat_InitMainLedge
                dc.b    0,   8
                dc.l    S3ICZSwingPlat_InitSideLedge
                dc.b    $1C,  -8
                dc.l    S3ICZSwingPlat_InitChainAnchor
                dc.b    0,   0
S3ICZSwingPlat_ChainDebrisChildren:
                dc.w    8-1
                dc.l    S3ICZSwingPlat_InitChainDebris
S3ICZSwingPlat_BounceDustChildren:
                dc.w    2-1
                dc.l    Obj_ICZSnowdust
                dc.b    $1C, $10
                dc.l    Obj_ICZSnowdust
                dc.b    $14, $10
S3ICZSwingPlat_SlideDustChild:
                dc.w    1-1
                dc.l    Obj_ICZSnowdust
                dc.b    $1C, $10
