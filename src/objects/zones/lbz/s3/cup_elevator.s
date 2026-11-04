; Owner: objects/zones/lbz/s3
; Responsibility: Launch Base cup elevator coordinated movement, flicker, base, attachment and pole objects
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZCupElevator:
                move.l  #Map_LBZCupElevator,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZMisc+$4A,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3LBZCupLift_InitTravelAndOrbit
                move.l  #Obj_LBZCupElevatorAttach,(a1)
                move.l  #Map_LBZCupElevator,mappings(a1)
                move.w  #make_art_tile(ArtTile_LBZMisc+$4A,2,0),art_tile(a1)
                move.b  #4,render_flags(a1)
                move.w  #$80,priority(a1)
                move.b  #$20,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  x_pos(a0),$30(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  #1,mapping_frame(a1)
                addi.w  #$18,x_pos(a1)
                btst    #0,status(a0)
                bne.s   S3LBZCupLift_LinkAttachmentAndTryBase
                subi.w  #2*$18,x_pos(a1)                ; Set position based on orientation of original object

S3LBZCupLift_LinkAttachmentAndTryBase:
                move.w  a0,$40(a1)
                move.w  a1,$42(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3LBZCupLift_InitTravelAndOrbit
                move.l  #Obj_LBZCupElevatorBase,(a1)
                move.l  #Map_LBZCupElevator,mappings(a1)
                move.w  #make_art_tile(ArtTile_LBZMisc+$4A,2,0),art_tile(a1)
                move.b  #4,render_flags(a1)
                move.w  #$100,priority(a1)
                move.b  #$20,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  #2,mapping_frame(a1)
                move.w  a0,$40(a1)
                move.w  a1,$40(a0)

S3LBZCupLift_InitTravelAndOrbit:
                moveq   #0,d0
                move.b  subtype(a0),d0                  ; BITS 3-0
                andi.w  #$F,d0
                lsl.w   #5,d0                           ; Multiples of $60
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                move.w  d0,$38(a0)
                move.w  #0,angle(a0)
                addi.w  #$40,x_pos(a0)
                btst    #0,status(a0)
                bne.s   S3LBZCupLift_PickInitialEndpoint
                subi.w  #$80,x_pos(a0)
                move.w  #$8080,angle(a0)

; Any of subtype bits 4 through 6 selects the upper starting endpoint
S3LBZCupLift_PickInitialEndpoint:
                move.b  subtype(a0),d1                  ; BITS 6-4
                andi.w  #$70,d1
                beq.s   S3LBZCupLift_BeginCupControl
                move.w  d0,$3A(a0)                      ; If any bit set, elevator is moving downward
                add.w   d0,$32(a0)
                move.w  #6,$36(a0)
                btst    #0,subtype(a0)
                beq.s   S3LBZCupLift_BeginCupControl
                addi.b  #$80,angle+1(a0)

S3LBZCupLift_BeginCupControl:
                move.l  #Obj_LBZCupElevatorMain,(a0)

Obj_LBZCupElevatorMain:
                bsr.w   LBZCupElevator_Action
                move.w  x_pos(a0),d4
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d1
                add.w   $30(a0),d1
                move.w  d1,x_pos(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                lea     $3C(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                move.w  (Ctrl_1_logical).w,d0
                movem.l d1-d4,-(sp)
                bsr.w   LBZCupElevator_PlayerControl
                movem.l (sp)+,d1-d4
                lea     $3D(a0),a2
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d0
                bsr.w   LBZCupElevator_PlayerControl
                bra.w   S3LBZCupLift_DrawFromCenterX

; =============== S U B R O U T I N E =======================================

LBZCupElevator_Action:
                move.w  $36(a0),d0
                move.w  LBZCupElevator_Action_Index(pc,d0.w),d1
                jmp     LBZCupElevator_Action_Index(pc,d1.w)
; End of function LBZCupElevator_Action

; ---------------------------------------------------------------------------
LBZCupElevator_Action_Index:
                dc.w    LBZCupElev_WaitEnter-LBZCupElevator_Action_Index  ; 0
                dc.w    LBZCupElev_MoveUp-LBZCupElevator_Action_Index  ; 2
                dc.w    LBZCupElev_WaitExit1-LBZCupElevator_Action_Index  ; 4
                dc.w    LBZCupElev_WaitEnter-LBZCupElevator_Action_Index  ; 6
                dc.w    LBZCupElev_MoveDown-LBZCupElevator_Action_Index  ; 8
                dc.w    LBZCupElev_WaitExit2-LBZCupElevator_Action_Index  ; A
                dc.w    LBZCupElev_Spin1-LBZCupElevator_Action_Index  ; C
                dc.w    LBZCupElev_Fling1-LBZCupElevator_Action_Index  ; E
                dc.w    LBZCupElev_Fling2-LBZCupElevator_Action_Index  ; 10
                dc.w    LBZCupElev_Spin2-LBZCupElevator_Action_Index  ; 12
                dc.w    LBZCupElev_Fling3-LBZCupElevator_Action_Index  ; 14
; ---------------------------------------------------------------------------

LBZCupElev_WaitEnter:
                tst.w   $3C(a0)
                beq.s   S3LBZCupLift_EntryWaitReturn
                move.w  #1,$34(a0)
                addq.w  #2,$36(a0)

S3LBZCupLift_EntryWaitReturn:
                rts
; ---------------------------------------------------------------------------

LBZCupElev_MoveUp:
                move.w  $3A(a0),d0
                cmp.w   $38(a0),d0
                bne.s   S3LBZCupLift_StepUpwardHelix
                tst.b   subtype(a0)
                bpl.s   S3LBZCupLift_BeginUpperExitWait
                move.w  #$C,$36(a0)
                move.w  #$600,$2E(a0)
                bra.w   LBZCupElev_Spin1
; ---------------------------------------------------------------------------

S3LBZCupLift_BeginUpperExitWait:
                move.w  #$80,priority(a0)
                move.w  #0,$34(a0)
                addq.w  #2,$36(a0)
                rts
; ---------------------------------------------------------------------------

S3LBZCupLift_StepUpwardHelix:
                addq.w  #4,$3A(a0)
                move.w  $3A(a0),d0
                move.w  d0,d1
                mulu.w  #$155,d0
                lsr.w   #8,d0
                add.b   angle+1(a0),d0
                move.b  d0,angle(a0)
                move.w  $32(a0),d0
                sub.w   d1,d0
                move.w  d0,y_pos(a0)
                cmpi.w  #$200,priority(a0)
                bne.s   S3LBZCupLift_TryMoveUpwardToBack
                tst.b   angle(a0)
                bpl.s   S3LBZCupLift_UpwardFrontReturn
                move.w  #$80,priority(a0)
                moveq   #signextendB(sfx_Hoverpad),d0
                jsr     (Play_SFX).l

S3LBZCupLift_UpwardFrontReturn:
                rts
; ---------------------------------------------------------------------------

S3LBZCupLift_TryMoveUpwardToBack:
                tst.b   angle(a0)
                bmi.s   S3LBZCupLift_UpwardBackReturn
                move.w  #$200,priority(a0)
                moveq   #signextendB(sfx_Hoverpad),d0
                jsr     (Play_SFX).l

S3LBZCupLift_UpwardBackReturn:
                rts
; ---------------------------------------------------------------------------

LBZCupElev_WaitExit1:
                tst.w   $3C(a0)
                bne.s   S3LBZCupLift_UpperExitReturn
                addq.w  #2,$36(a0)

S3LBZCupLift_UpperExitReturn:
                rts
; ---------------------------------------------------------------------------

LBZCupElev_MoveDown:
                tst.w   $3A(a0)
                bne.s   S3LBZCupLift_StepDownwardHelix
                tst.b   subtype(a0)
                bpl.s   S3LBZCupLift_BeginLowerExitWait
                move.w  #$12,$36(a0)
                move.w  #$600,$2E(a0)
                bra.w   LBZCupElev_Spin1
; ---------------------------------------------------------------------------

S3LBZCupLift_BeginLowerExitWait:
                move.w  #$80,priority(a0)
                move.w  #0,$34(a0)
                addq.w  #2,$36(a0)
                rts
; ---------------------------------------------------------------------------

S3LBZCupLift_StepDownwardHelix:
                subq.w  #4,$3A(a0)
                move.w  $3A(a0),d0
                move.w  d0,d1
                mulu.w  #$155,d0
                lsr.w   #8,d0
                add.b   angle+1(a0),d0
                move.b  d0,angle(a0)
                move.w  $32(a0),d0
                sub.w   d1,d0
                move.w  d0,y_pos(a0)
                cmpi.w  #$200,priority(a0)
                bne.s   S3LBZCupLift_TryMoveDownwardToBack
                tst.b   angle(a0)
                bpl.s   S3LBZCupLift_DownwardFrontReturn
                move.w  #$80,priority(a0)
                moveq   #signextendB(sfx_Hoverpad),d0
                jsr     (Play_SFX).l

S3LBZCupLift_DownwardFrontReturn:
                rts
; ---------------------------------------------------------------------------

S3LBZCupLift_TryMoveDownwardToBack:
                tst.b   angle(a0)
                bmi.s   S3LBZCupLift_DownwardBackReturn
                move.w  #$200,priority(a0)
                moveq   #signextendB(sfx_Hoverpad),d0
                jsr     (Play_SFX).l

S3LBZCupLift_DownwardBackReturn:
                rts
; ---------------------------------------------------------------------------

LBZCupElev_WaitExit2:
                tst.w   $3C(a0)
                bne.s   S3LBZCupLift_LowerExitReturn
                move.w  #0,$36(a0)

S3LBZCupLift_LowerExitReturn:
                rts
; ---------------------------------------------------------------------------

LBZCupElev_Spin1:
                cmpi.w  #$1000,$2E(a0)
                bne.s   S3LBZCupLift_AccelerateForwardSpin
                btst    #0,status(a0)
                bne.s   S3LBZCupLift_TryFinishForwardSpin
                move.b  angle(a0),d0
                addi.b  #$40,d0
                cmpi.b  #$F0,d0
                blo.s   S3LBZCupLift_StepForwardSpin
                move.b  #$C0,angle(a0)
                movea.w $42(a0),a1
                move.w  #$7FFF,$30(a1)
                addq.w  #2,$36(a0)
                rts
; ---------------------------------------------------------------------------

S3LBZCupLift_TryFinishForwardSpin:
                move.b  angle(a0),d0
                addi.b  #$C0,d0
                cmpi.b  #$F0,d0
                blo.s   S3LBZCupLift_StepForwardSpin
                move.b  #$40,angle(a0)
                movea.w $42(a0),a1
                move.w  #$7FFF,$30(a1)
                addq.w  #4,$36(a0)
                rts
; ---------------------------------------------------------------------------

S3LBZCupLift_AccelerateForwardSpin:
                addi.w  #$10,$2E(a0)

S3LBZCupLift_StepForwardSpin:
                move.b  $2E(a0),d0
                add.b   d0,angle(a0)
                cmpi.w  #$200,priority(a0)
                bne.s   S3LBZCupLift_TryMoveForwardSpinToBack
                tst.b   angle(a0)
                bpl.s   S3LBZCupLift_ForwardSpinFrontReturn
                move.w  #$80,priority(a0)
                moveq   #signextendB(sfx_Hoverpad),d0
                jsr     (Play_SFX).l

S3LBZCupLift_ForwardSpinFrontReturn:
                rts
; ---------------------------------------------------------------------------

S3LBZCupLift_TryMoveForwardSpinToBack:
                tst.b   angle(a0)
                bmi.s   S3LBZCupLift_ForwardSpinBackReturn
                move.w  #$200,priority(a0)
                moveq   #signextendB(sfx_Hoverpad),d0
                jsr     (Play_SFX).l

S3LBZCupLift_ForwardSpinBackReturn:
                rts
; ---------------------------------------------------------------------------

LBZCupElev_Spin2:
                cmpi.w  #$1000,$2E(a0)
                bne.s   S3LBZCupLift_AccelerateReverseSpin
                move.b  angle(a0),d0
                addi.b  #$B0,d0
                cmpi.b  #$F0,d0
                blo.s   S3LBZCupLift_StepReverseSpin
                move.b  #$40,angle(a0)
                movea.w $42(a0),a1
                move.w  #$7FFF,$30(a1)
                addq.w  #2,$36(a0)
                rts
; ---------------------------------------------------------------------------

S3LBZCupLift_AccelerateReverseSpin:
                addi.w  #$10,$2E(a0)

S3LBZCupLift_StepReverseSpin:
                move.b  $2E(a0),d0
                sub.b   d0,angle(a0)
                cmpi.w  #$200,priority(a0)
                bne.s   S3LBZCupLift_TryMoveReverseSpinToBack
                tst.b   angle(a0)
                bpl.s   S3LBZCupLift_ReverseSpinFrontReturn
                move.w  #$80,priority(a0)
                moveq   #signextendB(sfx_Hoverpad),d0
                jsr     (Play_SFX).l

S3LBZCupLift_ReverseSpinFrontReturn:
                rts
; ---------------------------------------------------------------------------

S3LBZCupLift_TryMoveReverseSpinToBack:
                tst.b   angle(a0)
                bmi.s   S3LBZCupLift_ReverseSpinBackReturn
                move.w  #$200,priority(a0)
                moveq   #signextendB(sfx_Hoverpad),d0
                jsr     (Play_SFX).l

S3LBZCupLift_ReverseSpinBackReturn:
                rts
; ---------------------------------------------------------------------------

LBZCupElev_Fling1:
                cmpi.w  #$16C0,$30(a0)
                blo.s   S3LBZCupLift_StepFirstFlingCenter
                move.w  #$16C0,$30(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #0,y_vel(a0)
                bra.s   S3LBZCupLift_FlingRidersAndRetireCup
; ---------------------------------------------------------------------------

S3LBZCupLift_StepFirstFlingCenter:
                addi.w  #$10,$30(a0)
                rts
; ---------------------------------------------------------------------------

LBZCupElev_Fling2:
                cmpi.w  #$2AE0,$30(a0)
                bhi.s   S3LBZCupLift_StepSecondFlingCenter
                move.w  #$2AE0,$30(a0)
                move.w  #$200,x_vel(a0)
                move.w  #0,y_vel(a0)
                bra.s   S3LBZCupLift_FlingRidersAndRetireCup
; ---------------------------------------------------------------------------

S3LBZCupLift_StepSecondFlingCenter:
                subi.w  #$10,$30(a0)
                rts
; ---------------------------------------------------------------------------

LBZCupElev_Fling3:
                cmpi.w  #$2B20,$30(a0)
                blo.s   S3LBZCupLift_StepThirdFlingCenter
                move.w  #$2B20,$30(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #0,y_vel(a0)
                bra.s   S3LBZCupLift_FlingRidersAndRetireCup
; ---------------------------------------------------------------------------

S3LBZCupLift_StepThirdFlingCenter:
                addi.w  #$10,$30(a0)
                rts
; ---------------------------------------------------------------------------

; Fling P1 at -$300 Y speed and P2 at -$400 before the cup flickers away
S3LBZCupLift_FlingRidersAndRetireCup:
                move.l  #Obj_LBZElevatorCupFlicker,(a0)
                moveq   #signextendB(sfx_Death),d0
                jsr     (Play_SFX).l
                lea     $3C(a0),a2
                lea     (Player_1).w,a1
                move.w  #-$300,d0
                bsr.s   FlingPlayerFromLbzCupElevator
                lea     $3D(a0),a2
                lea     (Player_2).w,a1
                move.w  #-$400,d0

; =============== S U B R O U T I N E =======================================

FlingPlayerFromLbzCupElevator:
                move.b  #$12,2(a2)
                tst.b   (a2)
                beq.s   S3LBZCupLift_FlingReturn
                move.b  #4,routine(a1)                  ; Hit animation
                bclr    #Status_OnObj,status(a1)
                bclr    #Status_Push,status(a1)         ; Player is not standing on/pushing an object
                bset    #Status_InAir,status(a1)
                move.w  d0,y_vel(a1)
                move.w  #-$200,x_vel(a1)                ; Set speed of player
                btst    #0,status(a0)
                beq.s   S3LBZCupLift_SetFlungRiderPose
                neg.w   x_vel(a1)                       ; Reverse direction depending on flip
                bset    #Status_Facing,status(a1)

S3LBZCupLift_SetFlungRiderPose:
                move.w  #0,ground_vel(a1)               ; Zero out inertia
                move.b  #$1A,anim(a1)                   ; Set falling animation

S3LBZCupLift_FlingReturn:
                rts
; End of function FlingPlayerFromLbzCupElevator

; ---------------------------------------------------------------------------

Obj_LBZElevatorCupFlicker:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bmi.s   S3LBZCupLift_DrawFlickeringCup
                move.w  #$7FFF,x_pos(a0)

S3LBZCupLift_DrawFlickeringCup:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                beq.s   S3LBZCupLift_SkipFlickerFrame
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

; The even-frame path skips the cull along with drawing
S3LBZCupLift_SkipFlickerFrame:
                rts
; ---------------------------------------------------------------------------

S3LBZCupLift_DrawFromCenterX:
                move.w  $30(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3LBZCupLift_ClearCupRespawnBit
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3LBZCupLift_ClearCupRespawnBit:
                move.w  respawn_addr(a0),d0
                beq.s   S3LBZCupLift_ReleaseRidersAndDelete
                movea.w d0,a2
                bclr    #7,(a2)

S3LBZCupLift_ReleaseRidersAndDelete:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   LBZCupElevator_ReleasePlayer
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.s   LBZCupElevator_ReleasePlayer
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

LBZCupElevator_ReleasePlayer:
                bclr    d6,status(a0)
                beq.w   S3LBZCupLift_CullReleaseReturn
                move.w  #$100,priority(a1)
                clr.b   object_control(a1)
                bclr    #Status_OnObj,status(a1)
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)

S3LBZCupLift_CullReleaseReturn:
                rts
; End of function LBZCupElevator_ReleasePlayer

; =============== S U B R O U T I N E =======================================

LBZCupElevator_PlayerControl:
                tst.b   (a2)
                bne.s   S3LBZCupLift_CarryOrReleaseRider  ; If player is inside cup, branch
                tst.b   2(a2)
                beq.s   S3LBZCupLift_TryResolveCupSolid  ; If timer has run out, branch
                subq.b  #1,2(a2)
                rts
; ---------------------------------------------------------------------------

S3LBZCupLift_TryResolveCupSolid:
                move.b  angle(a0),d0
                subi.b  #$20,d0
                cmpi.b  #$40,d0
                blo.w   S3LBZCupLift_CaptureReturn      ; Only be solid when in proper angle position
                jsr     (SolidObjectFull2_1P).l
                btst    d6,status(a0)
                beq.w   S3LBZCupLift_CaptureReturn      ; If player is not standing on elevator, don't bother
                tst.w   $34(a0)
                bne.s   S3LBZCupLift_CaptureCupRider    ; If $34 is set, then initiate elevator regardless of proximity to center
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #8,d0
                bmi.w   S3LBZCupLift_CaptureReturn
                cmpi.w  #$10,d0
                bhs.w   S3LBZCupLift_CaptureReturn      ; Otherwise only initiate elevator when close to center

S3LBZCupLift_CaptureCupRider:
                move.b  #1,(a2)                         ; Elevator on
                move.b  #3,object_control(a1)           ; Sonic is under control of object and is not animated by normal function
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)                  ; Clear momentum of character
                move.b  #0,anim(a1)                     ; Null animation number
                bra.w   S3LBZCupLift_PlaceRiderAndSetPriority
; ---------------------------------------------------------------------------

S3LBZCupLift_CarryOrReleaseRider:
                tst.b   render_flags(a1)
                bpl.w   S3LBZCupLift_DetachAndStartCooldown  ; If player is offscreen somehow, branch
                cmpi.b  #4,routine(a1)
                bhs.s   S3LBZCupLift_DetachAndStartCooldown  ; If player is in hit routine, branch
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   S3LBZCupLift_PlaceRiderAndSetPriority  ; If jump hasn't been pressed, branch
                tst.b   (_unkFAA9).w
                bne.w   S3LBZCupLift_PlaceRiderAndSetPriority  ; If controller is disabled, branch
                move.w  #$100,priority(a1)              ; Reset character priority
                clr.b   object_control(a1)              ; Sonic is under player control once more
                bclr    d6,status(a0)                   ; Release Solid object
                bclr    #Status_OnObj,status(a1)
                bclr    #Status_Push,status(a1)         ; Release player from object
                bset    #Status_InAir,status(a1)
                move.b  #0,jumping(a1)                  ; Not jumping (?)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)                 ; Reset height/width
                move.b  #2,anim(a1)                     ; Set jumping animation
                bset    #Status_Roll,status(a1)         ; Set character in ball form
                bclr    #Status_RollJump,status(a1)     ; Full air control to player
                move.b  #0,(a2)                         ; Turn off elevator
                move.b  #$12,2(a2)                      ; Set cooldown timer so that elevator won't restart instantly
                btst    #button_left+8,d0
                beq.s   S3LBZCupLift_TrySetJumpRight
                move.w  #-$200,x_vel(a1)                ; Set left speed if holding left on controller

S3LBZCupLift_TrySetJumpRight:
                btst    #button_right+8,d0
                beq.s   S3LBZCupLift_SetJumpYSpeed
                move.w  #$200,x_vel(a1)                 ; Set right speed if holding right on controller

S3LBZCupLift_SetJumpYSpeed:
                move.w  #-$480,y_vel(a1)                ; Set jump speed regardless
                rts
; ---------------------------------------------------------------------------

S3LBZCupLift_DetachAndStartCooldown:
                bclr    d6,status(a0)                   ; Release player if offscreen somehow
                bclr    #Status_OnObj,status(a1)
                move.w  #$100,priority(a1)
                clr.b   object_control(a1)
                move.b  #0,(a2)
                move.b  #60,2(a2)
                rts
; ---------------------------------------------------------------------------

S3LBZCupLift_PlaceRiderAndSetPriority:
                move.w  x_pos(a0),x_pos(a1)             ; Match character position to cup position
                move.w  y_pos(a0),d0
                subi.w  #$10,d0
                move.w  d0,y_pos(a1)
                move.w  #$280,priority(a1)              ; Set character priority
                move.b  angle(a0),d0
                addi.b  #$20,d0
                cmpi.b  #$C0,d0
                blo.s   S3LBZCupLift_ApplyCylinderPose
                move.w  #$100,priority(a1)              ; If correct angle range, set priority higher

S3LBZCupLift_ApplyCylinderPose:
                moveq   #0,d0
                move.b  angle(a0),d0
                jmp     (S3CNZCylinder_ApplyTwistFrameAndTiles).l
; ---------------------------------------------------------------------------

S3LBZCupLift_CaptureReturn:
                rts
; End of function LBZCupElevator_PlayerControl

; ---------------------------------------------------------------------------

Obj_LBZCupElevatorBase:
                movea.w $40(a0),a1
                move.w  y_pos(a1),y_pos(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_LBZCupElevatorAttach:
                movea.w $40(a0),a1
                move.w  y_pos(a1),y_pos(a0)
                move.b  angle(a1),angle(a0)             ; Match angle and Y position to parent object
                move.w  #$180,priority(a0)
                move.b  angle(a0),d0                    ; If angle is positive object has lower priority
                bpl.s   S3LBZCupLift_SetAttachmentFlip
                move.w  #$100,priority(a0)

S3LBZCupLift_SetAttachmentFlip:
                andi.b  #$FE,render_flags(a0)
                subi.b  #$40,d0
                bpl.s   S3LBZCupLift_PlaceAttachment
                ori.b   #1,render_flags(a0)             ; Flip object if angle-$40 is negative

S3LBZCupLift_PlaceAttachment:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                move.w  d1,d2
                add.w   d1,d1
                add.w   d2,d1
                asr.w   #5,d1
                add.w   $30(a0),d1
                move.w  d1,x_pos(a0)
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

Obj_LBZCupElevatorPole:
                move.l  #Map_LBZCupElevator,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZMisc+$4A,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$180,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #$30,height_pixels(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                move.b  #3,mapping_frame(a0)
                tst.b   subtype(a0)
                beq.s   S3LBZCupLift_StartStaticPole
                move.b  #$60,height_pixels(a0)
                move.b  #4,mapping_frame(a0)

S3LBZCupLift_StartStaticPole:
                move.l  #S3LBZCupLift_DrawStaticPole,(a0)

S3LBZCupLift_DrawStaticPole:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_LBZCupElevator:
                include "src/objects/shared/zones/lbz/mappings/cup_elevator.s"
