; Owner: objects/terrain/icz/sk
; Responsibility: IceCap tension platform mechanics, collision helpers and private child construction data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZTensionPlatform:
                lea     ObjDat_ICZTensionPlatform(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SKICZTensionPlat_UpdateSpringAndContacts,(a0)
                move.w  y_pos(a0),$30(a0)
                lea     SKICZTensionPlat_SideRopeChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

SKICZTensionPlat_UpdateSpringAndContacts:
                bsr.w   StepIczTensionPlatformSpringMotion
                bsr.w   ICZTension_UpdateRiderContacts
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

SKICZTensionPlat_InitSideRope:
                lea     SKICZTensionPlat_SideRopeAttrs(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #SKICZTensionPlat_UpdateRopeAndDraw,(a0)
                tst.b   subtype(a0)
                beq.s   SKICZTensionPlat_InitRopeSprites
                bset    #0,render_flags(a0)

SKICZTensionPlat_InitRopeSprites:
                bset    #6,render_flags(a0)
                move.w  #2,mainspr_childsprites(a0)
                bsr.w   ICZTensionRope_InitSideSprites
                move.b  #8,mapping_frame(a0)

SKICZTensionPlat_UpdateRopeAndDraw:
                bsr.w   UpdateIczTensionSideRopeVerticalSpan
                jmp     Child_Draw_Sprite(pc)

; =============== S U B R O U T I N E =======================================

; Fill the two secondary sprite records for this side rope
ICZTensionRope_InitSideSprites:
                lea     sub2_x_pos(a0),a1
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                moveq   #0,d2
                moveq   #1,d3

SKICZTensionPlat_GetMirroredRopeOffset:
                move.w  d0,d4
                move.w  SKICZTensionPlat_RopeXOffsets(pc,d2.w),d5
                btst    #0,render_flags(a0)
                beq.s   SKICZTensionPlat_PlaceRopeSprite
                neg.w   d5

SKICZTensionPlat_PlaceRopeSprite:
                add.w   d5,d4
                move.w  d4,(a1)+
                move.w  d1,(a1)+
                move.w  #8,(a1)+
                addq.w  #2,d2
                dbf     d3,SKICZTensionPlat_GetMirroredRopeOffset
                rts
; End of function ICZTensionRope_InitSideSprites

; ---------------------------------------------------------------------------
SKICZTensionPlat_RopeXOffsets:
                dc.w    $C,   $18

; =============== S U B R O U T I N E =======================================

UpdateIczTensionSideRopeVerticalSpan:
                movea.w parent3(a0),a1
                lea     sub2_y_pos(a0),a2
                move.w  y_pos(a0),d0
                move.w  y_pos(a1),d1
                move.w  d1,d2
                sub.w   d0,d1
                asr.w   #1,d1
                add.w   d0,d1
                move.w  d1,(a2)
                addq.w  #6,a2
                move.w  d2,(a2)
                rts
; End of function UpdateIczTensionSideRopeVerticalSpan

; =============== S U B R O U T I N E =======================================

StepIczTensionPlatformSpringMotion:
                btst    #2,$38(a0)
                beq.s   SKICZTensionPlat_SpringMotionReturn
                move.w  #$80,d0
                move.w  y_pos(a0),d1
                move.w  sub2_y_pos(a0),d2
                move.b  $39(a0),d3
                sub.w   $32(a0),d1
                scs     $39(a0)
                bcs.s   SKICZTensionPlat_CalcAbsRestDistance
                neg.w   d0
                bra.w   SKICZTensionPlat_HandleRestCrossing
; ---------------------------------------------------------------------------

SKICZTensionPlat_CalcAbsRestDistance:
                neg.w   d1

; Apply two extra acceleration steps on crossing, then test rider launch or spring rest
SKICZTensionPlat_HandleRestCrossing:
                cmp.b   $39(a0),d3
                beq.s   SKICZTensionPlat_AccelerateAndClamp
                add.w   d0,d2
                add.w   d0,d2
                cmpi.w  #-$80,d2
                bge.s   SKICZTensionPlat_TryStopNearRest
                cmpi.w  #-$400,d2
                bgt.s   SKICZTensionPlat_AccelerateAndClamp
                bsr.w   LaunchIczTensionPlatformStandingPlayers
                bra.w   SKICZTensionPlat_AccelerateAndClamp
; ---------------------------------------------------------------------------

SKICZTensionPlat_TryStopNearRest:
                cmpi.w  #$80,d2
                bgt.s   SKICZTensionPlat_AccelerateAndClamp
                cmpi.w  #1,d1
                bhi.s   SKICZTensionPlat_AccelerateAndClamp
                bclr    #2,$38(a0)

SKICZTensionPlat_AccelerateAndClamp:
                add.w   d0,d2
                move.w  #-$900,d3
                cmp.w   d3,d2
                bge.s   SKICZTensionPlat_CheckPositiveSpeedLimit
                bra.w   SKICZTensionPlat_ApplySignedSpeedLimit
; ---------------------------------------------------------------------------

SKICZTensionPlat_CheckPositiveSpeedLimit:
                neg.w   d3
                cmp.w   d3,d2
                ble.s   SKICZTensionPlat_MoveAndCheckDistance

SKICZTensionPlat_ApplySignedSpeedLimit:
                move.w  d3,d2

SKICZTensionPlat_MoveAndCheckDistance:
                move.w  d2,y_vel(a0)
                jsr     (MoveSprite2).l
                cmpi.w  #$50,d1
                blo.s   SKICZTensionPlat_SpringMotionReturn
                move.w  #-$100,y_vel(a0)

SKICZTensionPlat_SpringMotionReturn:
                rts
; End of function StepIczTensionPlatformSpringMotion

; =============== S U B R O U T I N E =======================================

LaunchIczTensionPlatformStandingPlayers:
                move.b  $3A(a0),d3
                andi.b  #standing_mask,d3
                beq.s   SKICZTensionPlat_LaunchReturn
                btst    #p1_standing_bit,d3
                beq.s   SKICZTensionPlat_TryLaunchP2
                lea     (Player_1).w,a1
                bsr.w   LaunchPlayerFromIczTensionPlatform

SKICZTensionPlat_TryLaunchP2:
                btst    #p2_standing_bit,d3
                beq.s   SKICZTensionPlat_LaunchReturn
                lea     (Player_2).w,a1
; End of function LaunchIczTensionPlatformStandingPlayers

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromIczTensionPlatform:
                move.w  d2,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                move.b  #$10,anim(a1)
                move.b  #2,routine(a1)

SKICZTensionPlat_LaunchReturn:
                rts
; End of function LaunchPlayerFromIczTensionPlatform

; =============== S U B R O U T I N E =======================================

; Use top-only solidity. A change in either rider's contact can update the rest height, activity and vertical momentum
ICZTension_UpdateRiderContacts:
                move.b  status(a0),$3A(a0)
                move.w  (Player_1+y_vel).w,-(sp)
                move.w  (Player_2+y_vel).w,-(sp)
                moveq   #$23,d1
                moveq   #$14,d2
                moveq   #$B,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                move.l  (sp)+,d0
                move.b  status(a0),d1
                move.b  $3A(a0),d2
                move.b  d1,$3A(a0)
                eor.b   d1,d2
                andi.b  #standing_mask,d2
                beq.s   SKICZTensionPlat_ContactImpulseReturn
                bsr.w   ICZTension_SetRestHeightFromRiders
                bset    #2,$38(a0)
                clr.b   $39(a0)
                moveq   #p1_standing_bit,d4
                btst    d4,d2
                beq.s   SKICZTensionPlat_TryTransferP2Impulse
                lea     (Player_1).w,a1
                bsr.w   ICZTension_TransferRiderYImpulse

SKICZTensionPlat_TryTransferP2Impulse:
                moveq   #p2_standing_bit,d4
                btst    d4,d2
                beq.s   SKICZTensionPlat_ContactImpulseReturn
                swap    d0
                lea     (Player_2).w,a1
                bsr.w   ICZTension_TransferRiderYImpulse

SKICZTensionPlat_ContactImpulseReturn:
                rts
; End of function ICZTension_UpdateRiderContacts

; =============== S U B R O U T I N E =======================================

; Damp the signed word sum by subtracting its arithmetic shift right by two
ICZTension_TransferRiderYImpulse:
                move.w  y_vel(a0),d5
                btst    d4,d1
                bne.s   SKICZTensionPlat_AddAndDampRiderImpulse
                tst.w   d0
                bpl.s   SKICZTensionPlat_AddAndDampRiderImpulse
                add.w   d5,y_vel(a1)
                neg.w   d0

SKICZTensionPlat_AddAndDampRiderImpulse:
                add.w   d0,d5
                move.w  d5,d6
                asr.w   #2,d6
                sub.w   d6,d5
                move.w  d5,y_vel(a0)
                rts
; End of function ICZTension_TransferRiderYImpulse

; =============== S U B R O U T I N E =======================================

; Set the rest height eight pixels below the base per standing player
ICZTension_SetRestHeightFromRiders:
                moveq   #0,d5
                btst    #3,d1
                beq.s   SKICZTensionPlat_AddP2RestHeight
                addq.w  #8,d5

SKICZTensionPlat_AddP2RestHeight:
                btst    #4,d1
                beq.s   SKICZTensionPlat_SetWeightedRestHeight
                addq.w  #8,d5

SKICZTensionPlat_SetWeightedRestHeight:
                move.w  $30(a0),d3
                add.w   d5,d3
                move.w  d3,$32(a0)
                rts
; End of function ICZTension_SetRestHeightFromRiders

; ---------------------------------------------------------------------------
ObjDat_ICZTensionPlatform:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,0)
                dc.w    $280
                dc.b    $18,  $C, $1F,   0
SKICZTensionPlat_SideRopeAttrs:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $40, $40,   8,   0
SKICZTensionPlat_SideRopeChildren:
                dc.w    2-1
                dc.l    SKICZTensionPlat_InitSideRope
                dc.b    -$38,   0
                dc.l    SKICZTensionPlat_InitSideRope
                dc.b    $38,   0
