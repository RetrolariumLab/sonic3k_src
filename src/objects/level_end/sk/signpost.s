; Owner: objects/level_end/sk
; Responsibility: End-of-act signpost states, player hit tests, score sparkles, stub children and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_EndSign:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  EndSign_Index(pc,d0.w),d1
                jsr     EndSign_Index(pc,d1.w)
                lea     PLCPtr_EndSigns(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
EndSign_Index:
                dc.w    Obj_EndSignInit-EndSign_Index
                dc.w    Obj_EndSignFall-EndSign_Index
                dc.w    Obj_EndSignLanded-EndSign_Index
                dc.w    Obj_EndSignResults-EndSign_Index
                dc.w    Obj_EndSignAfter-EndSign_Index
; ---------------------------------------------------------------------------

Obj_EndSignInit:
                lea     ObjSlot_EndSigns(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                btst    #7,(Player_1+art_tile).w
                beq.s   SKSign_InitPointerAndModeAnim
                bset    #7,art_tile(a0)                 ; Signs have same priority as Sonic

SKSign_InitPointerAndModeAnim:
                move.w  a0,(Signpost_addr).w            ; Put RAM address here for use by hidden monitor object
                move.b  #$18,x_radius(a0)
                move.b  #$1E,y_radius(a0)
                move.l  #AniRaw_EndSigns1,$30(a0)
                cmpi.w  #3,(Player_mode).w
                bne.s   SKSign_InitAboveCamera
                move.l  #AniRaw_EndSigns2,$30(a0)

SKSign_InitAboveCamera:
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,y_pos(a0)                    ; Place vertical position at top of screen
                moveq   #signextendB(sfx_Signpost),d0
                jsr     (Play_SFX).l
                lea     Child1_EndSignStub(pc),a2       ; Make the little stub at the bottom of the signpost
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

Obj_EndSignFall:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   SKSign_UpdateFall
                lea     Child6_EndSignSparkle(pc),a2    ; Create a signpost sparkle every 4 frames
                jsr     CreateChild6_Simple(pc)

SKSign_UpdateFall:
                bsr.w   EndSign_CheckPlayerHit
                addi.w  #$C,y_vel(a0)
                jsr     (MoveSprite2).l                 ; Move downward
                bsr.w   EndSign_CheckWall
                jsr     Animate_Raw(pc)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$50,d0
                cmp.w   y_pos(a0),d0
                bhi.s   SKSign_FallReturn               ; Ensure that signpost can't land if too far up the screen itself
                tst.w   y_vel(a0)
                bmi.s   SKSign_FallReturn               ; And also when the signpost is still moving up
                cmpi.b  #8,(Current_zone).w
                bne.s   SKSign_TryFloorLanding
                moveq   #0,d0                           ; Special code for handling the landing on Sandopolis 1's sand
                cmpi.w  #$4210,x_pos(a0)
                blo.s   SKSignSand_TryChangePriority
                moveq   #2,d0

SKSignSand_TryChangePriority:
                cmp.w   $3E(a0),d0
                beq.s   SKSignSand_CheckLandingHeight
                move.w  d0,$3E(a0)
                move.w  SKLevelEnd_SignSandSideDrawPriorities(pc,d0.w),priority(a0)

; Land at unsigned Y $9F2 or later using the current Y
SKSignSand_CheckLandingHeight:
                cmpi.w  #$9F2,y_pos(a0)
                bhs.s   SKSign_BeginSpinSettle

SKSign_TryFloorLanding:
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKSign_FallReturn
                add.w   d1,y_pos(a0)

SKSign_BeginSpinSettle:
                move.b  #4,routine(a0)                  ; If signpost has landed
                bset    #0,$38(a0)
                move.w  #$40,$2E(a0)

SKSign_FallReturn:
                rts
; ---------------------------------------------------------------------------
SKLevelEnd_SignSandSideDrawPriorities:
                dc.w    $180,  $300
; ---------------------------------------------------------------------------

Obj_EndSignLanded:
                btst    #0,$38(a0)
                beq.s   SKSign_ResumeFallAfterReveal
                jsr     Animate_Raw(pc)
                subq.w  #1,$2E(a0)                      ; Keep animating while landing for X amount of frames
                bmi.s   SKSign_FinishLandingSpin
                rts
; ---------------------------------------------------------------------------

SKSign_FinishLandingSpin:
                move.b  #6,routine(a0)
                st      (_unkFABE).w
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)                       ; Null velocity
                moveq   #0,d0
                move.b  (Player_mode+1).w,d0            ; Get current character "mode"
                move.b  FrameArray_EndSign(pc,d0.w),mapping_frame(a0)
                st      (Ctrl_2_locked).w               ; Null Sonic's input
                rts
; ---------------------------------------------------------------------------

SKSign_ResumeFallAfterReveal:
                move.b  #2,routine(a0)                  ; If a hidden monitor was hit, bounce ths signpost again
                move.b  #$20,$20(a0)
                move.w  #-$200,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
FrameArray_EndSign:
                dc.b    0,   0,   1,   2
                even
; ---------------------------------------------------------------------------

Obj_EndSignResults:
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   SKSign_ResultsReturn            ; If player is not standing on the ground, wait until he is
                move.b  #8,routine(a0)
                jsr     Set_PlayerEndingPose(pc)
                jsr     (AllocateObject).l
                bne.s   SKSign_ResultsReturn
                move.l  #Obj_LevelResults,(a1)

SKSign_ResultsReturn:
                rts
; ---------------------------------------------------------------------------

Obj_EndSignAfter:
                cmpi.b  #$B,(Current_zone).w
                bne.s   SKSignAfter_StopVerticalMotion
                jsr     (ObjCheckFloorDist).l           ; If Death Egg Zone, then check if there's still a floor
                tst.w   d1
                beq.s   SKSignAfter_CorrectFloorGap
                bmi.s   SKSignAfter_CorrectFloorGap
                jsr     (MoveSprite).l                  ; Move sprite if there's no floor
                bra.w   SKSignAfter_CullOrPoseP2
; ---------------------------------------------------------------------------

SKSignAfter_CorrectFloorGap:
                add.w   d1,y_pos(a0)

SKSignAfter_StopVerticalMotion:
                clr.w   y_vel(a0)                       ; Null vertical velocity

SKSignAfter_CullOrPoseP2:
                move.w  x_pos(a0),d0                    ; Check for whether signpost goes out of range
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   SKSign_RestoreArtAndRetire
                move.w  y_pos(a0),d0
                sub.w   (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                cmpi.w  #$200,d0
                bhi.s   SKSign_RestoreArtAndRetire
                jmp     (Check_TailsEndPose).l
; ---------------------------------------------------------------------------

SKSign_RestoreArtAndRetire:
                lea     PLC_SpikesSprings(pc),a1
                jsr     (Load_PLC_Raw).l
                jsr     Remove_From_TrackingSlot(pc)
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------
PLC_SpikesSprings:  plrlistheader
                plreq   ArtTile_SpikesSprings, ArtNem_SpikesSprings
PLC_SpikesSprings_End:
; ---------------------------------------------------------------------------

Obj_SignpostSparkle:
                lea     ObjDat_SignpostSparkle(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                btst    #7,(Player_1+art_tile).w
                beq.s   SKSignSparkle_InitRandomAnchor
                bset    #7,art_tile(a0)

SKSignSparkle_InitRandomAnchor:
                move.l  #Obj_SignpostSparkleMain,(a0)
                jsr     (Random_Number).l
                andi.w  #$1F,d0
                subi.w  #$10,d0
                add.w   d0,y_pos(a0)                    ; Random vertical position
                move.w  x_pos(a0),$3A(a0)
                move.w  #$1000,x_vel(a0)
                move.w  #$20,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

Obj_SignpostSparkleMain:
                move.w  #$400,d0
                move.w  x_pos(a0),d1
                cmp.w   $3A(a0),d1
                blo.s   SKSignSparkle_AccelAndPickPriority
                neg.w   d0

SKSignSparkle_AccelAndPickPriority:
                move.w  #$280,d1
                add.w   d0,x_vel(a0)                    ; Do rotation around sign
                bpl.s   SKSignSparkle_MoveAnimateAndDraw
                move.w  #$380,d1

SKSignSparkle_MoveAnimateAndDraw:
                move.w  d1,priority(a0)
                jsr     (MoveSprite2).l
                lea     AniRaw_SignpostSparkle(pc),a1
                jsr     Animate_RawNoSST(pc)
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_SignpostStub:
                lea     ObjDat_SignpostStub(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #Obj_SignpostStubMain,(a0)
                btst    #7,(Player_1+art_tile).w
                beq.s   Obj_SignpostStubMain
                bset    #7,art_tile(a0)

Obj_SignpostStubMain:
                jsr     Refresh_ChildPosition(pc)
                jsr     (Child_GetPriority).l
                jmp     (Child_Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

EndSign_CheckPlayerHit:
                tst.b   $20(a0)
                bne.s   SKSign_TickHitCooldown
                lea     EndSign_Range(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   SKSign_HitReturn                ; If neither player is in range, don't do anything
                tst.w   d0                              ; Is Sonic?
                beq.s   SKSign_TryPackedP2Hit           ; If it's not Sonic, branch

; Bug: After returning from the subroutine, the address of the characters in d0
; will be corrupted and the check will not work correctly
                bsr.w   SKEndSign_TryScoreRollingHit

; Swap d0 after the primary hit call. That call can overwrite the packed pointer value
SKSign_TryPackedP2Hit:
                swap    d0                              ; Get Tails address
                tst.w   d0                              ; Is Tails?
                beq.s   SKSign_HitReturn                ; If it's not Tails, branch
; End of function EndSign_CheckPlayerHit

; =============== S U B R O U T I N E =======================================

; Require a rising roll. The successful path reuses d0, which carried the packed player pointers in the caller
SKEndSign_TryScoreRollingHit:
                movea.w d0,a1                           ; This can be done up to twice depending on who hit the signpost
                cmpi.b  #2,anim(a1)
                bne.s   SKSign_HitReturn                ; only go on if Player is currently jumping
                tst.w   y_vel(a1)
                bpl.s   SKSign_HitReturn                ; And if he's actually moving upwards
                move.b  #$20,$20(a0)                    ; Set delay for when it checks for the next hit
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bne.s   SKSign_BounceAndAwardScore
                moveq   #8,d0

SKSign_BounceAndAwardScore:
                lsl.w   #4,d0
                move.w  d0,x_vel(a0)                    ; Modify strength of X velocity based on how far to the left/right player is
                move.w  #-$200,y_vel(a0)                ; New vertical velocity is always the same
                moveq   #signextendB(sfx_Signpost),d0
                jsr     (Play_SFX).l
                lea     Child6_EndSignScore(pc),a2
                jsr     CreateChild6_Simple(pc)
                moveq   #10,d0
                movea.l a1,a3
                jmp     (HUD_AddToScore).l              ; Add 100 points whenever hit
; ---------------------------------------------------------------------------

SKSign_TickHitCooldown:
                subq.b  #1,$20(a0)

SKSign_HitReturn:
                rts
; End of function SKEndSign_TryScoreRollingHit

; ---------------------------------------------------------------------------
EndSign_Range:
                dc.w    -$20,   $40,  -$18,   $30

; =============== S U B R O U T I N E =======================================

EndSign_CheckWall:
                move.w  (Camera_X_pos).w,d0
                tst.w   x_vel(a0)
                bmi.s   SKSign_CheckLeftMarginAndWall
                addi.w  #$128,d0
                cmp.w   x_pos(a0),d0
                blo.s   SKSign_ReverseXVel
                moveq   #$20,d3
                jsr     (ObjCheckRightWallDist).l
                tst.w   d1
                bmi.s   SKSign_ReverseXVel
                rts
; ---------------------------------------------------------------------------

SKSign_CheckLeftMarginAndWall:
                addi.w  #$18,d0
                cmp.w   x_pos(a0),d0
                bhi.s   SKSign_ReverseXVel
                moveq   #-$20,d3
                jsr     (ObjCheckLeftWallDist).l
                tst.w   d1
                bpl.s   SKSign_WallCheckReturn

SKSign_ReverseXVel:
                neg.w   x_vel(a0)

SKSign_WallCheckReturn:
                rts
; End of function EndSign_CheckWall

; ---------------------------------------------------------------------------
ObjSlot_EndSigns:
                dc.w    1-1
                dc.w    make_art_tile(ArtTile_EndSigns,0,0)
                dc.w    $C,     0
                dc.l    Map_EndSigns
                dc.w    $300
                dc.b    $18, $10,   0,   0
ObjDat_SignpostStub:
                dc.l    Map_SignpostStub
                dc.w    make_art_tile(ArtTile_SignpostStub,0,0)
                dc.w    $300
                dc.b    4,   8,   0,   0
ObjDat_SignpostSparkle:
                dc.l    Map_Ring
                dc.w    make_art_tile(ArtTile_Ring,1,0)
                dc.w    $280
                dc.b    8,   8,   4,   0
Child1_EndSignStub:
                dc.w    1-1
                dc.l    Obj_SignpostStub
                dc.b    0, $18
Child6_EndSignSparkle:
                dc.w    1-1
                dc.l    Obj_SignpostSparkle
Child6_EndSignScore:
                dc.w    1-1
                dc.l    Obj_EnemyScore
PLCPtr_EndSigns:
                dc.l    ArtUnc_EndSigns
                dc.l    DPLC_EndSigns
AniRaw_EndSigns1:
                dc.b    1,   0,   4,   5,   6,   1,   4,   5,   6,   3,   4,   5,   6, $FC
AniRaw_EndSigns2:
                dc.b    1,   1,   4,   5,   6,   2,   4,   5,   6,   3,   4,   5,   6, $FC
AniRaw_SignpostSparkle:
                dc.b    1,   4,   5,   6,   7, $FC
                even
DPLC_EndSigns:
                include "src/objects/shared/signpost/dplc/end_signs.s"
Map_EndSigns:
                include "src/objects/shared/signpost/mappings/end_signs.s"
Map_SignpostStub:
                include "src/objects/shared/signpost/mappings/stub.s"
