; Owner: objects/terrain/icz/s3
; Responsibility: IceCap freezer trap, player freeze and release states, fragments and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZFreezer:
                jsr     Obj_WaitOffscreen(pc)
                move.l  #S3ICZFreezer_TryArmFreezer,(a0)
                lea     ObjDat_ICZFreezer(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

S3ICZFreezer_TryArmFreezer:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   S3ICZFreezer_DrawWaitingFreezer
                move.l  #S3ICZFreezer_TickEmissionPhase,(a0)
                clr.w   $2E(a0)
                clr.w   $30(a0)
                clr.b   $39(a0)
                moveq   #signextendB(sfx_FrostPuff),d0
                jsr     (Play_SFX).l

S3ICZFreezer_DrawWaitingFreezer:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

S3ICZFreezer_TickEmissionPhase:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   S3ICZFreezer_StopFreezerOutOfRange
                subq.w  #1,$30(a0)
                bpl.s   S3ICZFreezer_TryEmitFrostPuff
                moveq   #0,d0
                move.b  $39(a0),d0
                bchg    #1,d0
                move.b  d0,$39(a0)
                move.w  S3ICZFreezer_PhaseDelays(pc,d0.w),$30(a0)
                move.w  S3ICZFreezer_PhaseHandlers(pc,d0.w),d0
                jsr     S3ICZFreezer_PhaseHandlers(pc,d0.w)

S3ICZFreezer_TryEmitFrostPuff:
                btst    #1,$38(a0)
                beq.s   S3ICZFreezer_DrawActiveFreezer
                subq.w  #1,$2E(a0)
                bpl.s   S3ICZFreezer_DrawActiveFreezer
                move.w  #1,$2E(a0)
                bsr.w   SpawnIczFreezerFrostPuff

S3ICZFreezer_DrawActiveFreezer:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

S3ICZFreezer_StopFreezerOutOfRange:
                move.l  #S3ICZFreezer_TryArmFreezer,(a0)
                bclr    #1,$38(a0)
                moveq   #signextendB(cmd_StopSFX),d0
                jsr     (Play_SFX).l
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
S3ICZFreezer_PhaseDelays:
                dc.w    $40,   $40
S3ICZFreezer_PhaseHandlers:
                dc.w    S3ICZFreezer_DisableEmission-S3ICZFreezer_PhaseHandlers
                dc.w    S3ICZFreezer_EnableAndPickCaptureField-S3ICZFreezer_PhaseHandlers
; ---------------------------------------------------------------------------

S3ICZFreezer_DisableEmission:
                bclr    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZFreezer_EnableAndPickCaptureField:
                bset    #1,$38(a0)
                lea     S3ICZFreezer_LowerFieldChild(pc),a2
                btst    #1,render_flags(a0)
                beq.s   S3ICZFreezer_SpawnCaptureField
                lea     S3ICZFreezer_UpperFieldChild(pc),a2

S3ICZFreezer_SpawnCaptureField:
                jmp     CreateChild1_Normal(pc)

; =============== S U B R O U T I N E =======================================

SpawnIczFreezerFrostPuff:
                lea     S3ICZFreezer_LowerPuffChild(pc),a2
                btst    #1,render_flags(a0)
                beq.s   S3ICZFreezer_SpawnFrostPuff
                lea     S3ICZFreezer_UpperPuffChild(pc),a2

S3ICZFreezer_SpawnFrostPuff:
                jmp     CreateChild1_Normal(pc)
; End of function SpawnIczFreezerFrostPuff

; ---------------------------------------------------------------------------

S3ICZFreezer_InitFrostPuff:
                lea     S3ICZFreezer_FrostPuffAttrs(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #S3ICZFreezer_UpdateAndDrawPuff,(a0)

S3ICZFreezer_PuffDrawReturn:
                rts
; ---------------------------------------------------------------------------

S3ICZFreezer_UpdateAndDrawPuff:
                bsr.w   AdvanceIczFreezerPuffEnvelopeAndJitter
                jsr     Refresh_ChildPosition(pc)
                subq.b  #1,$3A(a0)
                bpl.w   S3ICZFreezer_PuffDrawReturn
                move.b  #2,$3A(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3ICZFreezer_InitCaptureWarmup:
                move.l  #S3ICZFreezer_TickCaptureWarmup,(a0)
                move.w  #$1F,$2E(a0)
                lea     ObjDat_ICZFreezer(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

S3ICZFreezer_TickCaptureWarmup:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   S3ICZFreezer_BeginResidualCapture
                subq.w  #1,$2E(a0)
                bmi.s   S3ICZFreezer_BeginActiveCapture
                rts
; ---------------------------------------------------------------------------

S3ICZFreezer_BeginActiveCapture:
                move.l  #S3ICZFreezer_CaptureDuringEmission,(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZFreezer_CaptureDuringEmission:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   S3ICZFreezer_BeginResidualCapture
                lea     S3ICZFreezer_CaptureBounds(pc),a1
                bra.w   CapturePlayersInsideIczFreezerZone
; ---------------------------------------------------------------------------

S3ICZFreezer_BeginResidualCapture:
                move.l  #S3ICZFreezer_CaptureDuringResidual,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

; Run the capture test even on the update that schedules field deletion
S3ICZFreezer_CaptureDuringResidual:
                jsr     Obj_Wait(pc)
                lea     S3ICZFreezer_CaptureBounds(pc),a1
                bra.w   CapturePlayersInsideIczFreezerZone
; ---------------------------------------------------------------------------

S3ICZFreezer_InitFrozenShell:
                lea     S3ICZFreezer_FrozenShellAttrs(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #S3ICZFreezer_CheckShellRightLimit,(a0)
                move.b  #$10,y_radius(a0)
                movea.w $44(a0),a1
                move.w  x_pos(a1),d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                btst    #0,render_flags(a1)
                beq.s   S3ICZFreezer_ChooseShellThrowX
                bset    #0,render_flags(a0)

S3ICZFreezer_ChooseShellThrowX:
                movea.w parent3(a0),a2
                move.w  #$200,d1
                cmp.w   x_pos(a2),d0
                bhs.s   S3ICZFreezer_SetShellLaunchAndTimer
                neg.w   d1

S3ICZFreezer_SetShellLaunchAndTimer:
                move.w  d1,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #S3ICZFreezer_HurtOnShellTimeout,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZFreezer_CheckShellRightLimit:
                move.w  (Camera_X_pos).w,d0
                tst.w   x_vel(a0)
                bmi.s   S3ICZFreezer_CheckShellLeftLimit
                addi.w  #$128,d0
                cmp.w   x_pos(a0),d0
                blo.s   S3ICZFreezer_StopShellX
                bra.w   S3ICZFreezer_MoveShellAndCheckFloor
; ---------------------------------------------------------------------------

S3ICZFreezer_CheckShellLeftLimit:
                addi.w  #$20,d0
                cmp.w   x_pos(a0),d0
                blo.s   S3ICZFreezer_MoveShellAndCheckFloor

S3ICZFreezer_StopShellX:
                clr.w   x_vel(a0)

S3ICZFreezer_MoveShellAndCheckFloor:
                jsr     (MoveSprite).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   S3ICZFreezer_UpdateFrozenPlayer
                add.w   d1,y_pos(a0)
                move.l  #S3ICZFreezer_UpdateFrozenPlayer,(a0)

S3ICZFreezer_UpdateFrozenPlayer:
                movea.w $44(a0),a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subq.w  #1,$2E(a0)
                bmi.s   S3ICZFreezer_HurtOnShellTimeout
                bsr.w   TryRescueIczFrozenPlayerWithPartner
                bne.s   S3ICZFreezer_ReleasePlayerAndShatter
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3ICZFreezer_HurtOnShellTimeout:
                movea.w $44(a0),a1
                movea.l a0,a2
                movea.l a1,a0
                jsr     (HurtCharacter).l
                cmpi.b  #$18,anim(a0)
                beq.s   S3ICZFreezer_RestoreShellPointer
                move.w  #$200,d0
                btst    #0,render_flags(a0)
                bne.s   S3ICZFreezer_SetTimeoutHurtXSpeed
                neg.w   d0

S3ICZFreezer_SetTimeoutHurtXSpeed:
                move.w  d0,x_vel(a0)

S3ICZFreezer_RestoreShellPointer:
                movea.l a2,a0

S3ICZFreezer_ReleasePlayerAndShatter:
                movea.w $44(a0),a1
                bset    #1,status(a1)
                clr.b   object_control(a1)
                move.b  #2*60,invulnerability_timer(a1)
                lea     S3ICZFreezer_ShellShardChildren(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3ICZFreezer_InitShellShard:
                lea     S3ICZFreezer_ShellShardAttrs(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AnimateRaw_MoveChkDel,(a0)
                move.l  #S3ICZFreezer_MediumIceShardAnim,$30(a0)
                cmpi.b  #8,subtype(a0)
                bhs.s   S3ICZFreezer_SetShardFrameAndSpeed
                move.l  #S3ICZFreezer_LargeIceShardAnim,$30(a0)

S3ICZFreezer_SetShardFrameAndSpeed:
                jsr     (Random_Number).l
                andi.b  #3,d0
                move.b  d0,anim_frame(a0)
                moveq   #$C,d0
                jmp     Set_IndexedVelocity(pc)

; =============== S U B R O U T I N E =======================================

AdvanceIczFreezerPuffEnvelopeAndJitter:
                subq.w  #1,$2E(a0)
                bpl.s   S3ICZFreezer_PuffEnvelopeReturn
                move.w  #2,$2E(a0)
                moveq   #0,d0
                move.b  $39(a0),d0
                addq.b  #4,d0
                cmpi.b  #$48,d0
                bhs.s   S3ICZFreezer_DeletePuffAndSkipCaller
                move.b  d0,$39(a0)
                lea     S3ICZFreezer_PuffEnvelope(pc,d0.w),a1
                move.b  (a1)+,child_dy(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,d2
                jsr     (Random_Number).l
                and.b   d2,d0
                move.w  d2,d3
                lsr.b   #1,d3
                sub.b   d3,d0
                move.b  d0,child_dx(a0)
                swap    d0
                and.b   d2,d0
                sub.b   d3,d0
                movea.w parent3(a0),a1
                btst    #1,render_flags(a1)
                beq.s   S3ICZFreezer_ApplyPuffYJitter
                neg.b   child_dy(a0)

S3ICZFreezer_ApplyPuffYJitter:
                add.b   d0,child_dy(a0)

S3ICZFreezer_PuffEnvelopeReturn:
                rts
; ---------------------------------------------------------------------------

; Discard the caller's return address to skip position refresh and drawing
S3ICZFreezer_DeletePuffAndSkipCaller:
                jsr     (Delete_Current_Sprite).l
                addq.w  #4,sp
                rts
; End of function AdvanceIczFreezerPuffEnvelopeAndJitter

; ---------------------------------------------------------------------------
S3ICZFreezer_PuffEnvelope:
                dc.b    $10, $16,   3
                even
                dc.b    $10, $16,   3
                even
                dc.b    $14, $16,   3
                even
                dc.b    $18, $16,   3
                even
                dc.b    $1C, $16,   7
                even
                dc.b    $22, $17,   7
                even
                dc.b    $26, $17,   7
                even
                dc.b    $2E, $17,   7
                even
                dc.b    $32, $17,   7
                even
                dc.b    $3C, $18,   7
                even
                dc.b    $40, $18,  $F
                even
                dc.b    $4D, $19,  $F
                even
                dc.b    $52, $19,  $F
                even
                dc.b    $4B, $19,  $F
                even
                dc.b    $44, $19,  $F
                even
                dc.b    $42, $19,  $F
                even
                dc.b    $3E, $18,  $F
                even
                dc.b    $3B, $17,  $F
                even
                dc.b    $38, $16,  $F
                even

; =============== S U B R O U T I N E =======================================

CapturePlayersInsideIczFreezerZone:
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   S3ICZFreezer_FreezeReturn
                tst.w   d0
                beq.s   S3ICZFreezer_TryCaptureP2
                movea.w d0,a4
                bsr.w   FreezeEligiblePlayerInIczShell

S3ICZFreezer_TryCaptureP2:
                swap    d0
                tst.w   d0
                beq.s   S3ICZFreezer_FreezeReturn
                movea.w d0,a4
; End of function CapturePlayersInsideIczFreezerZone

; =============== S U B R O U T I N E =======================================

FreezeEligiblePlayerInIczShell:
                tst.b   object_control(a4)
                bne.s   S3ICZFreezer_FreezeReturn
                btst    #Status_Invincible,status_secondary(a4)
                bne.s   S3ICZFreezer_FreezeReturn
                tst.b   invulnerability_timer(a4)
                bne.s   S3ICZFreezer_FreezeReturn
                cmpi.b  #4,routine(a4)
                bhs.s   S3ICZFreezer_FreezeReturn
                move.b  #$81,object_control(a4)
                move.b  #$1A,anim(a4)
                bset    #Status_InAir,status(a4)
                clr.b   spin_dash_flag(a4)
                clr.w   x_vel(a4)
                clr.w   y_vel(a4)
                clr.w   ground_vel(a4)
                move.l  d0,d4
                lea     S3ICZFreezer_FrozenShellChild(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.l  d4,d0
                move.w  a4,$44(a1)

; The preceding path freezes the player and writes their handle into the shell without testing allocation
S3ICZFreezer_FreezeReturn:
                rts
; End of function FreezeEligiblePlayerInIczShell

; ---------------------------------------------------------------------------
S3ICZFreezer_CaptureBounds:
                dc.w    -$10,   $20,  -$28,   $50

; =============== S U B R O U T I N E =======================================

TryRescueIczFrozenPlayerWithPartner:
                lea     (Player_1).w,a3
                cmpa.w  $44(a0),a3
                bne.s   S3ICZFreezer_CheckRescuePartner
                lea     (Player_2).w,a3

S3ICZFreezer_CheckRescuePartner:
                tst.w   y_vel(a3)
                bmi.s   S3ICZFreezer_RescueFailed
                cmpi.b  #2,anim(a3)
                beq.s   S3ICZFreezer_FindRescueContact
                cmpi.b  #9,anim(a3)
                bne.s   S3ICZFreezer_RescueFailed

S3ICZFreezer_FindRescueContact:
                lea     S3ICZFreezer_RescueBounds(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   S3ICZFreezer_RescueReturn
                tst.w   d0
                beq.s   S3ICZFreezer_TryP2RescueContact
                movea.w d0,a4
                tst.b   object_control(a4)
                beq.s   S3ICZFreezer_BounceRescuePartner

S3ICZFreezer_TryP2RescueContact:
                swap    d0
                tst.w   d0
                beq.s   S3ICZFreezer_RescueReturn
                movea.w d0,a4
                tst.b   object_control(a4)
                bne.s   S3ICZFreezer_RescueFailed

S3ICZFreezer_BounceRescuePartner:
                neg.w   y_vel(a3)
                moveq   #1,d0

; The shell tests the zero flag on return to decide whether to shatter
S3ICZFreezer_RescueReturn:
                rts
; ---------------------------------------------------------------------------

S3ICZFreezer_RescueFailed:
                moveq   #0,d0
                rts
; End of function TryRescueIczFrozenPlayerWithPartner

; ---------------------------------------------------------------------------
S3ICZFreezer_RescueBounds:
                dc.w    -$1C,   $38,  -$18,   $30
ObjDat_ICZFreezer:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,1,0)
                dc.w    $280
                dc.b    $10,  $C,   6, $9A
S3ICZFreezer_FrostPuffAttrs:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    $C,  $C, $16,   0
S3ICZFreezer_FrozenShellAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    $14, $10,   2,   0
S3ICZFreezer_ShellShardAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    4,   4,  $C,   0
S3ICZFreezer_LowerPuffChild:
                dc.w    1-1
                dc.l    S3ICZFreezer_InitFrostPuff
                dc.b    0,  $C
S3ICZFreezer_UpperPuffChild:
                dc.w    1-1
                dc.l    S3ICZFreezer_InitFrostPuff
                dc.b    0, -$C
S3ICZFreezer_LowerFieldChild:
                dc.w    1-1
                dc.l    S3ICZFreezer_InitCaptureWarmup
                dc.b    0, $30
S3ICZFreezer_UpperFieldChild:
                dc.w    1-1
                dc.l    S3ICZFreezer_InitCaptureWarmup
                dc.b    0,-$30
S3ICZFreezer_FrozenShellChild:
                dc.w    1-1
                dc.l    S3ICZFreezer_InitFrozenShell
                dc.b    0,   0
S3ICZFreezer_ShellShardChildren:
                dc.w    $C-1
                dc.l    S3ICZFreezer_InitShellShard
                dc.b    -$C,  -8
                dc.l    S3ICZFreezer_InitShellShard
                dc.b    -4,  -8
                dc.l    S3ICZFreezer_InitShellShard
                dc.b    4,  -8
                dc.l    S3ICZFreezer_InitShellShard
                dc.b    $C,  -8
                dc.l    S3ICZFreezer_InitShellShard
                dc.b    -$C,   0
                dc.l    S3ICZFreezer_InitShellShard
                dc.b    -4,   0
                dc.l    S3ICZFreezer_InitShellShard
                dc.b    4,   0
                dc.l    S3ICZFreezer_InitShellShard
                dc.b    $C,   0
                dc.l    S3ICZFreezer_InitShellShard
                dc.b    -$C,   8
                dc.l    S3ICZFreezer_InitShellShard
                dc.b    -4,   8
                dc.l    S3ICZFreezer_InitShellShard
                dc.b    4,   8
                dc.l    S3ICZFreezer_InitShellShard
                dc.b    $C,   8
S3ICZFreezer_LargeIceShardAnim:
                dc.b    0, $27, $23, $27, $13, $27, $24, $27, $14, $FC
S3ICZFreezer_MediumIceShardAnim:
                dc.b    0, $27,  $C, $27,  $D, $27,  $E, $FC
S3ICZFreezer_SmallIceShardAnim:
                dc.b    0, $27,  $F, $27, $10, $27, $11, $FC
                even
