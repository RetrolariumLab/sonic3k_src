; Owner: objects/level_end/s3
; Responsibility: End-of-act signpost states, bounce detection, score sparkles, stub children and their private resources
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
                move.w  a0,(Signpost_addr).w            ; Put RAM address here for use by hidden monitor object
                move.b  #$18,x_radius(a0)
                move.b  #$1E,y_radius(a0)
                move.l  #AniRaw_EndSigns,$30(a0)
                cmpi.b  #6,(Current_zone).w
                bne.s   loc_523FA
                move.w  #$3EC0,x_pos(a0)

loc_523FA:
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
                bne.s   loc_52428
                lea     Child6_EndSignSparkle(pc),a2    ; Create a signpost sparkle every 4 frames
                jsr     CreateChild6_Simple(pc)

loc_52428:
                bsr.w   EndSign_CheckPlayerHit
                addi.w  #$C,y_vel(a0)
                jsr     (MoveSprite2).l                 ; Move downward
                bsr.w   EndSign_CheckWall
                jsr     Animate_Raw(pc)
                move.w  (Camera_Y_pos).w,d0
                cmpi.b  #6,(Current_zone).w
                bne.s   loc_52450
                addi.w  #$60,d0

loc_52450:
                cmp.w   y_pos(a0),d0
                bhi.s   locret_5247C                    ; Ensure that signpost can't land if too far up the screen itself
                tst.w   y_vel(a0)
                bmi.s   locret_5247C                    ; And also when the signpost is still moving up
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   locret_5247C
                add.w   d1,y_pos(a0)
                move.b  #4,routine(a0)                  ; If signpost has landed
                bset    #0,$38(a0)
                move.w  #$40,$2E(a0)

locret_5247C:
                rts
; ---------------------------------------------------------------------------

Obj_EndSignLanded:
                btst    #0,$38(a0)
                beq.s   loc_524AA
                jsr     Animate_Raw(pc)
                subq.w  #1,$2E(a0)                      ; Keep animating while landing for X amount of frames
                bmi.s   loc_52492
                rts
; ---------------------------------------------------------------------------

loc_52492:
                move.b  #6,routine(a0)
                moveq   #0,d0
                move.b  (Player_mode+1).w,d0            ; Get current character "mode"
                move.b  FrameArray_EndSign(pc,d0.w),mapping_frame(a0)
                st      (Ctrl_2_locked).w               ; Null Sonic's input
                rts
; ---------------------------------------------------------------------------

loc_524AA:
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
                bne.s   locret_524E6                    ; If player is not standing on the ground, wait until he is
                move.b  #8,routine(a0)
                jsr     Set_PlayerEndingPose(pc)
                jsr     (AllocateObject).l
                bne.s   locret_524E6
                move.l  #Obj_LevelResults,(a1)

locret_524E6:
                rts
; ---------------------------------------------------------------------------

Obj_EndSignAfter:
                move.w  x_pos(a0),d0                    ; Check for whether signpost goes out of range
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_52500
                jmp     (Check_TailsEndPose).l
; ---------------------------------------------------------------------------

loc_52500:
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
                blo.s   loc_52564
                neg.w   d0

loc_52564:
                move.w  #$80,d1
                add.w   d0,x_vel(a0)                    ; Do rotation around sign
                bpl.s   loc_52572
                move.w  #$180,d1

loc_52572:
                move.w  d1,priority(a0)
                jsr     (MoveSprite2).l
                lea     AniRaw_SignpostSparkle(pc),a1
                jsr     Animate_RawNoSST(pc)
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_SignpostStub:
                move.l  #Obj_SignpostStubMain,(a0)
                lea     ObjDat_SignpostStub(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

Obj_SignpostStubMain:
                jsr     Refresh_ChildPosition(pc)
                jmp     (Child_Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

EndSign_CheckPlayerHit:
                tst.b   $20(a0)
                bne.s   loc_5260E
                lea     EndSign_Range(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   locret_52612                    ; If neither player is in range, don't do anything
                tst.w   d0                              ; Is Sonic?
                beq.s   loc_525C0                       ; If it's not Sonic, branch

; Bug: After returning from the subroutine, the address of the characters in d0
; will be corrupted and the check will not work correctly
                bsr.w   EndSignS3ApplyUpwardRollingPlayerHitAndScore

loc_525C0:
                swap    d0                              ; Get Tails address
                tst.w   d0                              ; Is Tails?
                beq.s   locret_52612                    ; If it's not Tails, branch
; End of function EndSign_CheckPlayerHit

; =============== S U B R O U T I N E =======================================

EndSignS3ApplyUpwardRollingPlayerHitAndScore:
                movea.w d0,a1                           ; This can be done up to twice depending on who hit the signpost
                cmpi.b  #2,anim(a1)
                bne.s   locret_52612                    ; only go on if Player is currently jumping
                tst.w   y_vel(a1)
                bpl.s   locret_52612                    ; And if he's actually moving upwards
                move.b  #$20,$20(a0)                    ; Set delay for when it checks for the next hit
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bne.s   loc_525E8
                moveq   #8,d0

loc_525E8:
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

loc_5260E:
                subq.b  #1,$20(a0)

locret_52612:
                rts
; End of function EndSignS3ApplyUpwardRollingPlayerHitAndScore

; ---------------------------------------------------------------------------
EndSign_Range:
                dc.w    -$20,   $40,  -$18,   $30

; =============== S U B R O U T I N E =======================================

EndSign_CheckWall:
                move.w  (Camera_X_pos).w,d0
                tst.w   x_vel(a0)
                bmi.s   loc_5263E
                addi.w  #$128,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_52654
                moveq   #$20,d3
                jsr     (ObjCheckRightWallDist).l
                tst.w   d1
                bmi.s   loc_52654
                rts
; ---------------------------------------------------------------------------

loc_5263E:
                addi.w  #$18,d0
                cmp.w   x_pos(a0),d0
                bhi.s   loc_52654
                moveq   #-$20,d3
                jsr     (ObjCheckLeftWallDist).l
                tst.w   d1
                bpl.s   locret_52658

loc_52654:
                neg.w   x_vel(a0)

locret_52658:
                rts
; End of function EndSign_CheckWall

; ---------------------------------------------------------------------------
ObjSlot_EndSigns:
                dc.w    1-1
                dc.w    make_art_tile(ArtTile_EndSigns,0,0)
                dc.w    $C,     0
                dc.l    Map_EndSigns
                dc.w    $100
                dc.b    $18, $10,   0,   0
ObjDat_SignpostStub:
                dc.l    Map_SignpostStub
                dc.w    make_art_tile(ArtTile_SignpostStub,0,0)
                dc.w    $100
                dc.b    4,   8,   0,   0
ObjDat_SignpostSparkle:
                dc.l    Map_Ring
                dc.w    make_art_tile(ArtTile_Ring,1,0)
                dc.w    $80
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
AniRaw_EndSigns:
                dc.b    1,   0,   4,   5,   6,   1,   4,   5,   6,   2,   4,   5,   6,   3,   4,   5,   6, $FC
AniRaw_SignpostSparkle:
                dc.b    1,   4,   5,   6,   7, $FC
                even
