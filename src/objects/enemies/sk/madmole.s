; Owner: objects/enemies/sk
; Responsibility: Madmole enemy controller, attacks, child motion helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Madmole:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Madmole_Index(pc,d0.w),d1
                jsr     Madmole_Index(pc,d1.w)
                bsr.w   ResolveMadmoleBaseSolidRectangle
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------
Madmole_Index:
                dc.w    SKMadmole_InitBase-Madmole_Index
                dc.w    SKMadmole_BaseCheckPlayerXRange-Madmole_Index
                dc.w    SKMadmole_BaseWaitForBody-Madmole_Index
                dc.w    SKMHZMadmole_Base_RunSpawnCooldownWait-Madmole_Index
; ---------------------------------------------------------------------------

SKMadmole_InitBase:
                lea     ObjDat_Madmole(pc),a1
                jmp     (SetUp_ObjAttributes).l
; ---------------------------------------------------------------------------

SKMadmole_BaseCheckPlayerXRange:
                jsr     (Find_SonicTails).l
                cmpi.w  #$A0,d2
                blo.s   SKMadmole_BaseSpawnBody
                rts
; ---------------------------------------------------------------------------

SKMadmole_BaseSpawnBody:
                move.b  #4,routine(a0)
                bset    #1,$38(a0)
                lea     SKMadmole_BaseBodyChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SKMadmole_BaseWaitForBody:
                btst    #1,$38(a0)
                beq.s   SKMadmole_BaseStartSpawnCooldown
                rts
; ---------------------------------------------------------------------------

; The 60 preload expires after 61 calls to the wait routine
SKMadmole_BaseStartSpawnCooldown:
                move.b  #6,routine(a0)
                move.w  #60,$2E(a0)
                move.l  #SKMHZMadmole_Base_RearmNearestPlayerPoll,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKMHZMadmole_Base_RunSpawnCooldownWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKMHZMadmole_Base_RearmNearestPlayerPoll:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

SKMadmole_BodyDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKMadmole_BodyStateOffsets(pc,d0.w),d1
                jsr     SKMadmole_BodyStateOffsets(pc,d1.w)
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------
SKMadmole_BodyStateOffsets:
                dc.w    SKMadmole_BodyInitRise-SKMadmole_BodyStateOffsets
                dc.w    SKMadmole_BodyRiseAndFacePlayer-SKMadmole_BodyStateOffsets
                dc.w    SKMadmole_BodyAimAtPlayer-SKMadmole_BodyStateOffsets
                dc.w    SKMadmole_BodyAnimateAttack-SKMadmole_BodyStateOffsets
                dc.w    SKMadmole_BodyDescendAndWait-SKMadmole_BodyStateOffsets
; ---------------------------------------------------------------------------

SKMadmole_BodyInitRise:
                lea     SKMadmole_BodyAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.w  #-$100,y_vel(a0)
                move.w  #$1F,$2E(a0)

SKMadmole_BodyRiseAndFacePlayer:
                bsr.w   FaceMadmoleBodyTowardNearestPlayer
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bmi.s   SKMadmole_BodyStartAim
                rts
; ---------------------------------------------------------------------------

SKMadmole_BodyStartAim:
                move.b  #4,routine(a0)
                move.w  #$1F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

SKMadmole_BodyAimAtPlayer:
                bsr.w   FaceMadmoleBodyTowardNearestPlayer
                subq.w  #1,$2E(a0)
                bmi.s   SKMadmole_BodyStartAttackAnimation
                rts
; ---------------------------------------------------------------------------

SKMadmole_BodyStartAttackAnimation:
                move.b  #6,routine(a0)
                move.l  #SKMadmole_BodyFireAnimation,$30(a0)
                move.l  #SKMadmole_BodyFireAndSetDescentAnim,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKMadmole_BodyAnimateAttack:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

SKMadmole_BodyFireAndSetDescentAnim:
                move.l  #SKMadmole_BodyDescentCueAnimation,$30(a0)
                move.l  #SKMadmole_BodyStartDescent,$34(a0)
                moveq   #signextendB(sfx_SpikeMove),d0
                jsr     (Play_SFX).l
                lea     SKMadmole_BodyAttackChildUnflipped(pc),a2
                btst    #0,render_flags(a0)
                beq.s   SKMadmole_BodySpawnFacingAttack
                lea     SKMadmole_BodyAttackChildFlipped(pc),a2

SKMadmole_BodySpawnFacingAttack:
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SKMadmole_BodyStartDescent:
                move.b  #8,routine(a0)
                move.w  #$100,y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #SKMadmole_BodyClearBusyAndDelete,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKMadmole_BodyDescendAndWait:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKMadmole_BodyClearBusyAndDelete:
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

SKMadmole_AttackDispatchCullAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKMadmole_AttackStateOffsets(pc,d0.w),d1
                jsr     SKMadmole_AttackStateOffsets(pc,d1.w)
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   SKMadmole_AttackReleasePlayerOnCull
                move.w  y_pos(a0),d0
                sub.w   (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                cmpi.w  #$200,d0
                bhi.s   SKMadmole_AttackReleasePlayerOnCull
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKMadmole_AttackReleasePlayerOnCull:
                move.w  $44(a0),d0
                beq.s   SKMadmole_AttackDeleteOnCull
                movea.w d0,a1
                bset    #Status_InAir,status(a1)
                clr.b   object_control(a1)

SKMadmole_AttackDeleteOnCull:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
SKMadmole_AttackStateOffsets:
                dc.w    SKMadmole_InitAttackAndRandomMotion-SKMadmole_AttackStateOffsets
                dc.w    SKMadmole_FastAttackKnockBackAndMove-SKMadmole_AttackStateOffsets
                dc.w    SKMadmole_BounceAttackCaptureAndMove-SKMadmole_AttackStateOffsets
                dc.w    SKMadmole_ReleasedAttackMoveAndAnimate-SKMadmole_AttackStateOffsets
                dc.w    SKMadmole_HeldPlayerFaceFromAttackX-SKMadmole_AttackStateOffsets
; ---------------------------------------------------------------------------

SKMadmole_InitAttackAndRandomMotion:
                lea     SKMadmole_AttackAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.b  #$18,x_radius(a0)
                move.b  #8,y_radius(a0)
                move.l  #SKMadmole_AttackLoopAnimation,$30(a0)
                bra.w   SKMadmole_AttackChooseFastOrBounce
; ---------------------------------------------------------------------------

SKMadmole_FastAttackKnockBackAndMove:
                bsr.w   KnockBackPlayerFromMadmoleFastAttack
                jsr     (MoveSprite2).l
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

SKMadmole_BounceAttackCaptureAndMove:
                bsr.w   CapturePlayerWithMadmoleBouncingAttack
                jsr     (MoveSprite_LightGravity).l
                tst.w   y_vel(a0)
                bmi.s   SKMadmole_BounceAttackAnimate
                jsr     (ObjHitFloor_DoRoutine).l

SKMadmole_BounceAttackAnimate:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

SKMadmole_BounceAttackRebound:
                move.w  #-$500,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKMadmole_ReleasedAttackMoveAndAnimate:
                jsr     (MoveSprite2).l
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

SKMadmole_HeldPlayerFaceFromAttackX:
                movea.w $44(a0),a1
                bclr    #0,render_flags(a1)
                tst.w   x_vel(a0)
                bmi.s   SKMadmole_HeldPlayerCheckControl
                bset    #0,render_flags(a1)

SKMadmole_HeldPlayerCheckControl:
                tst.b   object_control(a1)
                beq.s   SKMadmole_AttackEnterReleasedState
                moveq   #8,d1
                move.w  x_pos(a0),d0
                btst    #0,render_flags(a1)
                bne.s   SKMadmole_HeldPlayerPositionAndProbe
                neg.w   d1

SKMadmole_HeldPlayerPositionAndProbe:
                add.w   d1,d0
                move.w  d0,x_pos(a1)
                move.w  y_pos(a0),d0
                addi.w  #8,d0
                move.w  d0,y_pos(a1)
                jsr     (MoveSprite_LightGravity).l
                tst.w   x_vel(a0)
                bmi.s   SKMadmole_HeldAttackProbeLeftWall
                move.w  #$18,d3
                jsr     (ObjCheckRightWallDist).l
                bra.w   SKMadmole_HeldAttackCheckWallAndFloor
; ---------------------------------------------------------------------------

SKMadmole_HeldAttackProbeLeftWall:
                move.w  #-$18,d3
                jsr     (ObjCheckLeftWallDist).l

SKMadmole_HeldAttackCheckWallAndFloor:
                tst.w   d1
                bmi.s   SKMadmole_HeldAttackWallRebound
                tst.w   y_vel(a0)
                bmi.s   SKMadmole_HeldAttackAnimate
                jsr     (ObjHitFloor_DoRoutine).l

SKMadmole_HeldAttackAnimate:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

; Give the player the reversed horizontal speed and leave half that speed on the attack object
SKMadmole_HeldAttackWallRebound:
                movea.w $44(a0),a1
                move.w  x_vel(a0),d0
                neg.w   d0
                move.w  d0,x_vel(a1)
                asr.w   #1,d0
                move.w  d0,x_vel(a0)

SKMadmole_HeldPlayerRestoreControl:
                bset    #Status_InAir,status(a1)
                clr.b   object_control(a1)

SKMadmole_AttackEnterReleasedState:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

; At a downward speed of at least 10 pixels per frame, release the player instead of bouncing
SKMadmole_HeldAttackCheckFloorRelease:
                cmpi.w  #$A00,y_vel(a0)
                bge.s   SKMadmole_HeldAttackFloorRelease
                move.w  #-$500,y_vel(a0)
                moveq   #signextendB(sfx_Flipper),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

SKMadmole_HeldAttackFloorRelease:
                movea.w $44(a0),a1
                move.w  #-$200,y_vel(a0)
                move.w  #-$300,y_vel(a1)
                move.w  x_vel(a0),x_vel(a1)
                bra.s   SKMadmole_HeldPlayerRestoreControl

; =============== S U B R O U T I N E =======================================

ResolveMadmoleBaseSolidRectangle:
                moveq   #$1F,d1
                moveq   #4,d2
                moveq   #5,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function ResolveMadmoleBaseSolidRectangle

; =============== S U B R O U T I N E =======================================

FaceMadmoleBodyTowardNearestPlayer:
                jsr     (Find_SonicTails).l
                bclr    #0,render_flags(a0)
                tst.w   d0
                beq.s   SKMadmole_BodyFacePlayerReturn
                bset    #0,render_flags(a0)

SKMadmole_BodyFacePlayerReturn:
                rts
; End of function FaceMadmoleBodyTowardNearestPlayer

; ---------------------------------------------------------------------------

SKMadmole_AttackChooseFastOrBounce:
                jsr     (Random_Number).l
                moveq   #0,d2
                tst.b   d0
                bpl.s   SKMadmole_AttackLoadFacingVelocity
                addq.w  #4,d2
                move.b  #4,routine(a0)
                move.l  #SKMadmole_BounceAttackRebound,$34(a0)

SKMadmole_AttackLoadFacingVelocity:
                lea     SKMadmole_AttackVelocityPairs(pc,d2.w),a1
                move.w  (a1)+,d0
                movea.w parent3(a0),a2
                btst    #0,render_flags(a2)
                beq.s   SKMadmole_AttackStoreVelocity
                neg.w   d0
                bset    #0,render_flags(a0)

SKMadmole_AttackStoreVelocity:
                move.w  d0,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
SKMadmole_AttackVelocityPairs:
                dc.w    -$600,     0
                dc.w    -$380,  $200

; =============== S U B R O U T I N E =======================================

KnockBackPlayerFromMadmoleFastAttack:
                move.b  collision_property(a0),d0
                beq.w   SKMadmole_FastAttackContactReturn
                clr.b   collision_property(a0)
                andi.w  #3,d0
                add.w   d0,d0
                lea     SKMadmole_AttackContactPlayers-2(pc,d0.w),a1
                movea.w (a1)+,a2
                btst    #Status_Invincible,status_secondary(a2)
                bne.s   SKMadmole_FastAttackContactReturn
                tst.b   object_control(a2)
                bne.s   SKMadmole_FastAttackContactReturn
                move.w  a2,$44(a0)
                move.b  #6,routine(a0)
                moveq   #signextendB(sfx_Flipper),d0
                jsr     (Play_SFX).l
                move.w  x_vel(a0),d0
                lsl.w   #1,d0
                move.w  d0,x_vel(a2)
                move.w  d0,ground_vel(a2)
                move.w  #-$200,y_vel(a2)
                bset    #Status_InAir,status(a2)
                move.b  #$1A,anim(a2)
                clr.b   spin_dash_flag(a2)

SKMadmole_FastAttackContactReturn:
                rts
; End of function KnockBackPlayerFromMadmoleFastAttack

; ---------------------------------------------------------------------------
SKMadmole_AttackContactPlayers:
                dc.w    Player_1
                dc.w    Player_2
                dc.w    Player_2

; =============== S U B R O U T I N E =======================================

CapturePlayerWithMadmoleBouncingAttack:
                move.b  collision_property(a0),d0
                beq.w   SKMadmole_BounceAttackContactReturn
                clr.b   collision_property(a0)
                andi.w  #3,d0
                add.w   d0,d0
                lea     SKMadmole_AttackContactPlayers-2(pc,d0.w),a1
                movea.w (a1)+,a2
                btst    #Status_Invincible,status_secondary(a2)
                bne.s   SKMadmole_BounceAttackContactReturn
                tst.b   object_control(a2)
                bne.s   SKMadmole_BounceAttackContactReturn
                move.w  a2,$44(a0)
                move.b  #8,routine(a0)
                move.w  #0,priority(a0)
                move.l  #SKMadmole_HeldAttackCheckFloorRelease,$34(a0)
                moveq   #signextendB(sfx_Flipper),d0
                jsr     (Play_SFX).l
                bset    #Status_InAir,status(a2)
                move.b  #1,object_control(a2)
                move.b  #$1A,anim(a2)
                clr.b   spin_dash_flag(a2)

SKMadmole_BounceAttackContactReturn:
                rts
; End of function CapturePlayerWithMadmoleBouncingAttack

; ---------------------------------------------------------------------------
ObjDat_Madmole:
                dc.l    Map_Madmole
                dc.w    make_art_tile(ArtTile_Madmole,0,0)
                dc.w    $280
                dc.b    $18,   4,  $D,   0
SKMadmole_BodyAttributes:
                dc.w    $280
                dc.b    $C,  $C,   0,  $B
SKMadmole_AttackAttributes:
                dc.w    $280
                dc.b    8,   8,   5, $D8
SKMadmole_BaseBodyChild:
                dc.w    1-1
                dc.l    SKMadmole_BodyDispatchAndDraw
                dc.b    0, $10
SKMadmole_BodyAttackChildUnflipped:
                dc.w    1-1
                dc.l    SKMadmole_AttackDispatchCullAndDraw
                dc.b    -$E, -$C
SKMadmole_BodyAttackChildFlipped:
                dc.w    1-1
                dc.l    SKMadmole_AttackDispatchCullAndDraw
                dc.b    $E, -$C
SKMadmole_BodyFireAnimation:
                dc.b    2,   0,   1,   2, $F4
SKMadmole_BodyDescentCueAnimation:
                dc.b    2,   3,   3,   4,   4,   4,   4,   4,   4, $F4
SKMadmole_AttackLoopAnimation:
                dc.b    2,   5,   6,   7,   8,   9,  $A,  $B,  $C, $FC
                even
Map_Madmole:
                include "src/objects/shared/madmole/mappings/madmole.s"
