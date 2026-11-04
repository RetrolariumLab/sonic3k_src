; Owner: objects/enemies/sk
; Responsibility: Toxomister enemy, attack actors, movement helpers and private object resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Toxomister:
                jsr     (Obj_WaitOffscreen).l
                lea     ObjDat_Toxomister(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKToxomister_CheckCoreDeath,(a0)
                bset    #6,render_flags(a0)
                move.w  #1,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a1
                move.w  x_pos(a0),(a1)+
                move.w  y_pos(a0),d0
                moveq   #$18,d1
                btst    #1,render_flags(a0)
                beq.s   SKToxomister_StoreEmbeddedSpriteAndSpawn
                neg.w   d1

SKToxomister_StoreEmbeddedSpriteAndSpawn:
                add.w   d1,d0
                move.w  d0,(a1)+
                move.w  #0,(a1)+
                bsr.w   SpawnAndTrackToxomisterCore

SKToxomister_CheckCoreDeath:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.s   SKToxomister_FacePlayerAndDraw
                move.l  #SKToxomister_TickCoreRespawnWait,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #SKToxomister_RespawnCoreAndResumePoll,$34(a0)

SKToxomister_FacePlayerAndDraw:
                bsr.w   FaceToxomisterOnEighthVblankPhase
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

SKToxomister_TickCoreRespawnWait:
                bsr.w   FaceToxomisterOnEighthVblankPhase
                jsr     (Obj_Wait).l
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

SKToxomister_RespawnCoreAndResumePoll:
                move.l  #SKToxomister_CheckCoreDeath,(a0)
                bra.w   SpawnAndTrackToxomisterCore
; ---------------------------------------------------------------------------

SKToxomister_CoreDispatchAndQueueTouch:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKToxomister_CoreStateOffsets(pc,d0.w),d1
                jsr     SKToxomister_CoreStateOffsets(pc,d1.w)
                jmp     (Child_AddToTouchList).l
; ---------------------------------------------------------------------------
SKToxomister_CoreStateOffsets:
                dc.w    SKToxomister_InitCoreAndSpawnCloud-SKToxomister_CoreStateOffsets
                dc.w    SKToxomister_CoreTryAttachAndWait-SKToxomister_CoreStateOffsets
                dc.w    SKToxomister_CoreTryAttachAndFall-SKToxomister_CoreStateOffsets
                dc.w    SKToxomister_CoreTryAttachAndWait-SKToxomister_CoreStateOffsets
                dc.w    SKToxomister_CoreFollowAndDrainRings-SKToxomister_CoreStateOffsets
; ---------------------------------------------------------------------------

SKToxomister_InitCoreAndSpawnCloud:
                lea     SKToxomister_CoreAndCloudAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.b  #$D8,collision_flags(a0)
                move.b  #$18,y_radius(a0)
                move.w  #$6F,$2E(a0)
                move.l  #SKToxomister_CoreBeginDescent,$34(a0)
                lea     SKToxomister_CoreCloudChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SKToxomister_CoreTryAttachAndWait:
                bsr.w   AttachToxomisterCoreToContactingPlayer
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKToxomister_CoreBeginDescent:
                move.b  #4,routine(a0)
                move.w  #$40,y_vel(a0)
                move.l  #SKToxomister_CoreBeginFloorWait,$34(a0)

SKToxomister_CoreCloudFacingReturn:
                rts
; ---------------------------------------------------------------------------

SKToxomister_CoreTryAttachAndFall:
                bsr.w   AttachToxomisterCoreToContactingPlayer
                jsr     (MoveSprite2).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

SKToxomister_CoreBeginFloorWait:
                move.b  #6,routine(a0)
                clr.w   y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

; Check for a controller shake before following the player, applying drag and draining the shared ring count
SKToxomister_CoreFollowAndDrainRings:
                movea.w $44(a0),a1
                cmpi.b  #9,anim(a1)
                beq.s   SKToxomister_CoreMarkCloudBurst
                jsr     (Check_LRControllerShake).l
                bne.s   SKToxomister_CoreDeleteOnDetach
                movea.w $44(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                bsr.w   ApplyToxomisterAttachedVelocityDrag
                jsr     (DrainGlobalRingFromAttachedMegaChopper).l
                beq.w   SKToxomister_CoreCloudFacingReturn

; A defeated victim or a failed ring drain sets the burst flag. Shaking free bypasses it
SKToxomister_CoreMarkCloudBurst:
                bset    #2,$38(a0)

SKToxomister_CoreDeleteOnDetach:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

; Reverse the cloud subtype order for the stagger and store the delay in the low byte of the wait timer
SKToxomister_InitCloudAndStagger:
                lea     SKToxomister_CoreAndCloudAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SKToxomister_CloudTickHiddenDelay,(a0)
                move.l  #SKToxomister_CloudExpandAndLoopAnim,$30(a0)
                move.b  subtype(a0),d0
                subi.b  #$C,d0
                neg.b   d0
                move.b  d0,subtype(a0)
                lsl.b   #2,d0
                move.b  d0,$2F(a0)
                move.l  #SKToxomister_CloudBeginFollowing,$34(a0)
                jmp     (Child_CheckParent).l
; ---------------------------------------------------------------------------

SKToxomister_CloudTickHiddenDelay:
                jsr     (Obj_Wait).l
                jmp     (Child_CheckParent).l
; ---------------------------------------------------------------------------

SKToxomister_CloudBeginFollowing:
                move.l  #SKToxomister_CloudFollowAndAnimate,(a0)
                rts
; ---------------------------------------------------------------------------

SKToxomister_CloudFollowAndAnimate:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   SKToxomister_CloudCheckBurstOnCoreDeath
                jsr     (Refresh_ChildPosition).l
                jsr     (Animate_Raw).l
                btst    #0,(V_int_run_count+3).w
                sne     d0
                btst    #0,subtype(a0)
                beq.s   SKToxomister_CloudDrawOnMatchingParity
                not.b   d0

SKToxomister_CloudDrawOnMatchingParity:
                tst.b   d0
                bne.w   SKToxomister_CoreCloudFacingReturn
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

SKToxomister_CloudCheckBurstOnCoreDeath:
                clr.w   x_vel(a0)
                btst    #2,$38(a1)
                beq.s   SKToxomister_CloudBeginRiseAndShrink
                bsr.w   SKToxomister_CloudChooseFacingBurstX

; Switch to the contraction stream without resetting the current animation cursor
SKToxomister_CloudBeginRiseAndShrink:
                clr.w   y_vel(a0)
                move.l  #SKToxomister_CloudRiseAnimateAndDraw,(a0)
                move.l  #SKToxomister_CloudShrinkAndDeleteAnim,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

SKToxomister_CloudRiseAnimateAndDraw:
                addi.w  #-$10,y_vel(a0)
                jsr     (MoveSprite2).l
                jsr     (Animate_Raw).l
                jmp     (Sprite_CheckDeleteXY).l

; =============== S U B R O U T I N E =======================================

FaceToxomisterOnEighthVblankPhase:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #7,d0
                bne.w   SKToxomister_CoreCloudFacingReturn
                jsr     (Find_SonicTails).l
                jmp     (Change_FlipX).l
; End of function FaceToxomisterOnEighthVblankPhase

; =============== S U B R O U T I N E =======================================

SpawnAndTrackToxomisterCore:
                moveq   #signextendB(sfx_EnemyBreath),d0
                jsr     (Play_SFX).l
                lea     SKToxomister_RootCoreChild(pc),a2
                jsr     (CreateChild10_NormalAdjusted).l
                bne.s   SKToxomister_SpawnCoreReturn
                move.w  a1,$44(a0)

SKToxomister_SpawnCoreReturn:
                rts
; End of function SpawnAndTrackToxomisterCore

; =============== S U B R O U T I N E =======================================

AttachToxomisterCoreToContactingPlayer:
                move.b  collision_property(a0),d0
                beq.w   SKToxomister_CoreCloudFacingReturn
                clr.b   collision_property(a0)
                andi.w  #3,d0
                lsl.w   #2,d0
                lea     SKToxomister_CoreContactPlayersAndPads-4(pc,d0.w),a1
                movea.w (a1)+,a2
                cmpi.b  #2,anim(a2)
                beq.w   SKToxomister_CoreCloudFacingReturn
                btst    #Status_BublShield,status_secondary(a2)
                bne.w   SKToxomister_CoreCloudFacingReturn
                move.w  a2,$44(a0)
                movea.w (a1)+,a2
                move.w  a2,$3E(a0)
                move.w  (a2),$3A(a0)
                move.b  #8,routine(a0)
                move.w  #60-1,$2E(a0)
                rts
; End of function AttachToxomisterCoreToContactingPlayer

; ---------------------------------------------------------------------------
SKToxomister_CoreContactPlayersAndPads:
                dc.w    Player_1, Ctrl_1
                dc.w    Player_2, Ctrl_2
                dc.w    Player_1, Ctrl_1

; =============== S U B R O U T I N E =======================================

ApplyToxomisterAttachedVelocityDrag:
                move.w  x_vel(a1),d0
                asr.w   #3,d0
                sub.w   d0,x_vel(a1)
                moveq   #ground_vel,d0
                btst    #Status_InAir,status(a1)
                beq.s   SKToxomister_CoreApplyEighthDrag
                moveq   #y_vel,d0

SKToxomister_CoreApplyEighthDrag:
                move.w  (a1,d0.w),d1
                asr.w   #3,d1
                sub.w   d1,(a1,d0.w)
                rts
; End of function ApplyToxomisterAttachedVelocityDrag

; ---------------------------------------------------------------------------

SKToxomister_CloudChooseFacingBurstX:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  SKToxomister_CloudBurstSpeeds(pc,d0.w),d0
                movea.w $44(a1),a2
                btst    #0,render_flags(a2)
                bne.s   SKToxomister_CloudStoreBurstX
                neg.w   d0

SKToxomister_CloudStoreBurstX:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------
SKToxomister_CloudBurstSpeeds:
                dc.w    $100,  $180,  $200,  $180,  $100,  $200,  $180
ObjDat_Toxomister:
                dc.l    Map_Toxomister
                dc.w    make_art_tile(ArtTile_Toxomister,1,1)
                dc.w    $280
                dc.b    8,   8,   1, $18
SKToxomister_CoreAndCloudAttributes:
                dc.w    0
                dc.b    8,   8,   2,   0
SKToxomister_RootCoreChild:
                dc.w    1-1
                dc.l    SKToxomister_CoreDispatchAndQueueTouch
                dc.b    -$C,   8
SKToxomister_CoreCloudChildren:
                dc.w    7-1
                dc.l    SKToxomister_InitCloudAndStagger
                dc.b    -$C,   4
                dc.l    SKToxomister_InitCloudAndStagger
                dc.b    $C,   4
                dc.l    SKToxomister_InitCloudAndStagger
                dc.b    -8,  -4
                dc.l    SKToxomister_InitCloudAndStagger
                dc.b    8,  -4
                dc.l    SKToxomister_InitCloudAndStagger
                dc.b    0,  -4
                dc.l    SKToxomister_InitCloudAndStagger
                dc.b    -4,   4
                dc.l    SKToxomister_InitCloudAndStagger
                dc.b    4,   4
SKToxomister_CloudExpandAndLoopAnim:
                dc.b    7,   2,   3,   4,   5,   6,   7, $F8
                dc.b    9,   7,   6,   5,   4,   5,   6,   7, $FC
SKToxomister_CloudShrinkAndDeleteAnim:
                dc.b    7,   7,   6,   5,   4,   3,   2, $F4
                even
Map_Toxomister:
                include "src/objects/shared/toxomister/mappings/toxomister.s"
; End of function SKToxomister_CloudChooseFacingBurstX
