; Owner: objects/terrain/icz/sk
; Responsibility: IceCap freezer trap, player freeze and release states, fragments and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZFreezer:
                jsr     Obj_WaitOffscreen(pc)
                move.l  #SKICZFreezer_TryArmFreezer,(a0)
                lea     ObjDat_ICZFreezer(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

SKICZFreezer_TryArmFreezer:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   SKICZFreezer_DrawWaitingFreezer
                move.l  #SKICZFreezer_TickEmissionPhase,(a0)
                clr.w   $2E(a0)
                clr.w   $30(a0)
                clr.b   $39(a0)
                moveq   #signextendB(sfx_FrostPuff),d0
                jsr     (Play_SFX).l

SKICZFreezer_DrawWaitingFreezer:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

SKICZFreezer_TickEmissionPhase:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   SKICZFreezer_StopFreezerOutOfRange
                subq.w  #1,$30(a0)
                bpl.s   SKICZFreezer_TryEmitFrostPuff
                moveq   #0,d0
                move.b  $39(a0),d0
                bchg    #1,d0
                move.b  d0,$39(a0)
                move.w  SKICZFreezer_PhaseDelays(pc,d0.w),$30(a0)
                move.w  SKICZFreezer_PhaseHandlers(pc,d0.w),d0
                jsr     SKICZFreezer_PhaseHandlers(pc,d0.w)

SKICZFreezer_TryEmitFrostPuff:
                btst    #1,$38(a0)
                beq.s   SKICZFreezer_DrawActiveFreezer
                subq.w  #1,$2E(a0)
                bpl.s   SKICZFreezer_DrawActiveFreezer
                move.w  #1,$2E(a0)
                bsr.w   SpawnIczFreezerFrostPuff

SKICZFreezer_DrawActiveFreezer:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

SKICZFreezer_StopFreezerOutOfRange:
                move.l  #SKICZFreezer_TryArmFreezer,(a0)
                bclr    #1,$38(a0)
                moveq   #signextendB(cmd_StopSFX),d0
                jsr     (Play_SFX).l
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
SKICZFreezer_PhaseDelays:
                dc.w    $40,   $40
SKICZFreezer_PhaseHandlers:
                dc.w    SKICZFreezer_DisableEmission-SKICZFreezer_PhaseHandlers
                dc.w    SKICZFreezer_EnableAndPickCaptureField-SKICZFreezer_PhaseHandlers
; ---------------------------------------------------------------------------

SKICZFreezer_DisableEmission:
                bclr    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

SKICZFreezer_EnableAndPickCaptureField:
                bset    #1,$38(a0)
                lea     SKICZFreezer_LowerFieldChild(pc),a2
                btst    #1,render_flags(a0)
                beq.s   SKICZFreezer_SpawnCaptureField
                lea     SKICZFreezer_UpperFieldChild(pc),a2

SKICZFreezer_SpawnCaptureField:
                jmp     CreateChild1_Normal(pc)

; =============== S U B R O U T I N E =======================================

SpawnIczFreezerFrostPuff:
                lea     SKICZFreezer_LowerPuffChild(pc),a2
                btst    #1,render_flags(a0)
                beq.s   SKICZFreezer_SpawnFrostPuff
                lea     SKICZFreezer_UpperPuffChild(pc),a2

SKICZFreezer_SpawnFrostPuff:
                jmp     CreateChild1_Normal(pc)
; End of function SpawnIczFreezerFrostPuff

; ---------------------------------------------------------------------------

SKICZFreezer_InitFrostPuff:
                lea     SKICZFreezer_FrostPuffAttrs(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #SKICZFreezer_UpdateAndDrawPuff,(a0)

SKICZFreezer_PuffDrawReturn:
                rts
; ---------------------------------------------------------------------------

SKICZFreezer_UpdateAndDrawPuff:
                bsr.w   AdvanceIczFreezerPuffEnvelopeAndJitter
                jsr     Refresh_ChildPosition(pc)
                subq.b  #1,$3A(a0)
                bpl.w   SKICZFreezer_PuffDrawReturn
                move.b  #2,$3A(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKICZFreezer_InitCaptureWarmup:
                move.l  #SKICZFreezer_TickCaptureWarmup,(a0)
                move.w  #$1F,$2E(a0)
                lea     ObjDat_ICZFreezer(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

SKICZFreezer_TickCaptureWarmup:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   SKICZFreezer_BeginResidualCapture
                subq.w  #1,$2E(a0)
                bmi.s   SKICZFreezer_BeginActiveCapture
                rts
; ---------------------------------------------------------------------------

SKICZFreezer_BeginActiveCapture:
                move.l  #SKICZFreezer_CaptureDuringEmission,(a0)
                rts
; ---------------------------------------------------------------------------

SKICZFreezer_CaptureDuringEmission:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   SKICZFreezer_BeginResidualCapture
                lea     SKICZFreezer_CaptureBounds(pc),a1
                bra.w   CapturePlayersInsideIczFreezerZone
; ---------------------------------------------------------------------------

SKICZFreezer_BeginResidualCapture:
                move.l  #SKICZFreezer_CaptureDuringResidual,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

; Run the capture test even on the update that schedules field deletion
SKICZFreezer_CaptureDuringResidual:
                jsr     Obj_Wait(pc)
                lea     SKICZFreezer_CaptureBounds(pc),a1
                bra.w   CapturePlayersInsideIczFreezerZone
; ---------------------------------------------------------------------------

SKICZFreezer_InitFrozenShell:
                lea     SKICZFreezer_FrozenShellAttrs(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SKICZFreezer_CheckShellRightLimit,(a0)
                move.b  #$10,y_radius(a0)
                movea.w $44(a0),a1
                move.w  x_pos(a1),d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                btst    #0,render_flags(a1)
                beq.s   SKICZFreezer_ChooseShellThrowX
                bset    #0,render_flags(a0)

SKICZFreezer_ChooseShellThrowX:
                movea.w parent3(a0),a2
                move.w  #$200,d1
                cmp.w   x_pos(a2),d0
                bhs.s   SKICZFreezer_SetShellLaunchAndTimer
                neg.w   d1

SKICZFreezer_SetShellLaunchAndTimer:
                move.w  d1,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #SKICZFreezer_HurtOnShellTimeout,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKICZFreezer_CheckShellRightLimit:
                move.w  (Camera_X_pos).w,d0
                tst.w   x_vel(a0)
                bmi.s   SKICZFreezer_CheckShellLeftLimit
                addi.w  #$128,d0
                cmp.w   x_pos(a0),d0
                blo.s   SKICZFreezer_StopShellX
                bra.w   SKICZFreezer_MoveShellAndCheckFloor
; ---------------------------------------------------------------------------

SKICZFreezer_CheckShellLeftLimit:
                addi.w  #$20,d0
                cmp.w   x_pos(a0),d0
                blo.s   SKICZFreezer_MoveShellAndCheckFloor

SKICZFreezer_StopShellX:
                clr.w   x_vel(a0)

SKICZFreezer_MoveShellAndCheckFloor:
                jsr     (MoveSprite).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKICZFreezer_UpdateFrozenPlayer
                add.w   d1,y_pos(a0)
                move.l  #SKICZFreezer_UpdateFrozenPlayer,(a0)

SKICZFreezer_UpdateFrozenPlayer:
                movea.w $44(a0),a1
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                cmpi.b  #2,character_id(a1)
                bne.s   SKICZFreezer_PlacePlayerAndTestEscape
                moveq   #-4,d2
                btst    #0,render_flags(a1)
                beq.s   SKICZFreezer_OffsetFrozenKnuckles
                neg.w   d2

SKICZFreezer_OffsetFrozenKnuckles:
                add.w   d2,d0
                addq.w  #2,d1

SKICZFreezer_PlacePlayerAndTestEscape:
                move.w  d0,x_pos(a1)
                move.w  d1,y_pos(a1)
                subq.w  #1,$2E(a0)
                bmi.s   SKICZFreezer_HurtOnShellTimeout
                bsr.w   TryRescueIczFrozenPlayerWithPartner
                bne.s   SKICZFreezer_ReleasePlayerAndShatter
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; The invincibility bit test has no branch. The timeout still calls HurtCharacter
SKICZFreezer_HurtOnShellTimeout:
                movea.w $44(a0),a1
                btst    #Status_Invincible,status_secondary(a1)
                movea.l a0,a2
                movea.l a1,a0
                jsr     (HurtCharacter).l
                cmpi.b  #$18,anim(a0)
                beq.s   SKICZFreezer_RestoreShellPointer
                move.w  #$200,d0
                btst    #0,render_flags(a0)
                bne.s   SKICZFreezer_SetTimeoutHurtXSpeed
                neg.w   d0

SKICZFreezer_SetTimeoutHurtXSpeed:
                move.w  d0,x_vel(a0)

SKICZFreezer_RestoreShellPointer:
                movea.l a2,a0

SKICZFreezer_ReleasePlayerAndShatter:
                movea.w $44(a0),a1
                bset    #1,status(a1)
                clr.b   object_control(a1)
                move.b  #2*60,invulnerability_timer(a1)
                lea     SKICZFreezer_ShellShardChildren(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKICZFreezer_InitShellShard:
                lea     SKICZFreezer_ShellShardAttrs(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AnimateRaw_MoveChkDel,(a0)
                move.l  #SKICZFreezer_MediumIceShardAnim,$30(a0)
                cmpi.b  #8,subtype(a0)
                bhs.s   SKICZFreezer_SetShardFrameAndSpeed
                move.l  #SKICZFreezer_LargeIceShardAnim,$30(a0)

SKICZFreezer_SetShardFrameAndSpeed:
                jsr     (Random_Number).l
                andi.b  #3,d0
                move.b  d0,anim_frame(a0)
                moveq   #$C,d0
                jmp     Set_IndexedVelocity(pc)

; =============== S U B R O U T I N E =======================================

AdvanceIczFreezerPuffEnvelopeAndJitter:
                subq.w  #1,$2E(a0)
                bpl.s   SKICZFreezer_PuffEnvelopeReturn
                move.w  #2,$2E(a0)
                moveq   #0,d0
                move.b  $39(a0),d0
                addq.b  #4,d0
                cmpi.b  #$48,d0
                bhs.s   SKICZFreezer_DeletePuffAndSkipCaller
                move.b  d0,$39(a0)
                lea     SKICZFreezer_PuffEnvelope(pc,d0.w),a1
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
                beq.s   SKICZFreezer_ApplyPuffYJitter
                neg.b   child_dy(a0)

SKICZFreezer_ApplyPuffYJitter:
                add.b   d0,child_dy(a0)

SKICZFreezer_PuffEnvelopeReturn:
                rts
; ---------------------------------------------------------------------------

; Discard the caller's return address to skip position refresh and drawing
SKICZFreezer_DeletePuffAndSkipCaller:
                jsr     (Delete_Current_Sprite).l
                addq.w  #4,sp
                rts
; End of function AdvanceIczFreezerPuffEnvelopeAndJitter

; ---------------------------------------------------------------------------
SKICZFreezer_PuffEnvelope:
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
                beq.s   SKICZFreezer_FreezeReturn
                tst.w   d0
                beq.s   SKICZFreezer_TryCaptureP2
                movea.w d0,a4
                bsr.w   FreezeEligiblePlayerInIczShell

SKICZFreezer_TryCaptureP2:
                swap    d0
                tst.w   d0
                beq.s   SKICZFreezer_FreezeReturn
                movea.w d0,a4
; End of function CapturePlayersInsideIczFreezerZone

; =============== S U B R O U T I N E =======================================

FreezeEligiblePlayerInIczShell:
                tst.b   object_control(a4)
                bne.s   SKICZFreezer_FreezeReturn
                btst    #Status_Invincible,status_secondary(a4)
                bne.s   SKICZFreezer_FreezeReturn
                tst.b   invulnerability_timer(a4)
                bne.s   SKICZFreezer_FreezeReturn
                cmpi.b  #4,routine(a4)
                bhs.s   SKICZFreezer_FreezeReturn
                move.b  #$81,object_control(a4)
                move.b  #$1A,anim(a4)
                bset    #Status_InAir,status(a4)
                clr.b   spin_dash_flag(a4)
                clr.w   x_vel(a4)
                clr.w   y_vel(a4)
                clr.w   ground_vel(a4)
                move.l  d0,d4
                lea     SKICZFreezer_FrozenShellChild(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.l  d4,d0
                move.w  a4,$44(a1)

; The preceding path freezes the player and writes their handle into the shell without testing allocation
SKICZFreezer_FreezeReturn:
                rts
; End of function FreezeEligiblePlayerInIczShell

; ---------------------------------------------------------------------------
SKICZFreezer_CaptureBounds:
                dc.w    -$10,   $20,  -$28,   $50

; =============== S U B R O U T I N E =======================================

TryRescueIczFrozenPlayerWithPartner:
                lea     (Player_1).w,a3
                cmpa.w  $44(a0),a3
                bne.s   SKICZFreezer_CheckRescuePartner
                lea     (Player_2).w,a3

SKICZFreezer_CheckRescuePartner:
                tst.w   y_vel(a3)
                bmi.s   SKICZFreezer_RescueFailed
                cmpi.b  #2,anim(a3)
                beq.s   SKICZFreezer_FindRescueContact
                cmpi.b  #9,anim(a3)
                bne.s   SKICZFreezer_RescueFailed

SKICZFreezer_FindRescueContact:
                lea     SKICZFreezer_RescueBounds(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   SKICZFreezer_RescueReturn
                tst.w   d0
                beq.s   SKICZFreezer_TryP2RescueContact
                movea.w d0,a4
                tst.b   object_control(a4)
                beq.s   SKICZFreezer_BounceRescuePartner

SKICZFreezer_TryP2RescueContact:
                swap    d0
                tst.w   d0
                beq.s   SKICZFreezer_RescueReturn
                movea.w d0,a4
                tst.b   object_control(a4)
                bne.s   SKICZFreezer_RescueFailed

SKICZFreezer_BounceRescuePartner:
                neg.w   y_vel(a3)
                moveq   #1,d0

; The shell tests the zero flag on return to decide whether to shatter
SKICZFreezer_RescueReturn:
                rts
; ---------------------------------------------------------------------------

SKICZFreezer_RescueFailed:
                moveq   #0,d0
                rts
; End of function TryRescueIczFrozenPlayerWithPartner

; ---------------------------------------------------------------------------
SKICZFreezer_RescueBounds:
                dc.w    -$1C,   $38,  -$18,   $30
ObjDat_ICZFreezer:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,1,0)
                dc.w    $280
                dc.b    $10,  $C,   6, $9A
SKICZFreezer_FrostPuffAttrs:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    $C,  $C, $16,   0
SKICZFreezer_FrozenShellAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    $14, $10,   2,   0
SKICZFreezer_ShellShardAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    4,   4,  $C,   0
SKICZFreezer_LowerPuffChild:
                dc.w    1-1
                dc.l    SKICZFreezer_InitFrostPuff
                dc.b    0,  $C
SKICZFreezer_UpperPuffChild:
                dc.w    1-1
                dc.l    SKICZFreezer_InitFrostPuff
                dc.b    0, -$C
SKICZFreezer_LowerFieldChild:
                dc.w    1-1
                dc.l    SKICZFreezer_InitCaptureWarmup
                dc.b    0, $30
SKICZFreezer_UpperFieldChild:
                dc.w    1-1
                dc.l    SKICZFreezer_InitCaptureWarmup
                dc.b    0,-$30
SKICZFreezer_FrozenShellChild:
                dc.w    1-1
                dc.l    SKICZFreezer_InitFrozenShell
                dc.b    0,   0
SKICZFreezer_ShellShardChildren:
                dc.w    $C-1
                dc.l    SKICZFreezer_InitShellShard
                dc.b    -$C,  -8
                dc.l    SKICZFreezer_InitShellShard
                dc.b    -4,  -8
                dc.l    SKICZFreezer_InitShellShard
                dc.b    4,  -8
                dc.l    SKICZFreezer_InitShellShard
                dc.b    $C,  -8
                dc.l    SKICZFreezer_InitShellShard
                dc.b    -$C,   0
                dc.l    SKICZFreezer_InitShellShard
                dc.b    -4,   0
                dc.l    SKICZFreezer_InitShellShard
                dc.b    4,   0
                dc.l    SKICZFreezer_InitShellShard
                dc.b    $C,   0
                dc.l    SKICZFreezer_InitShellShard
                dc.b    -$C,   8
                dc.l    SKICZFreezer_InitShellShard
                dc.b    -4,   8
                dc.l    SKICZFreezer_InitShellShard
                dc.b    4,   8
                dc.l    SKICZFreezer_InitShellShard
                dc.b    $C,   8
SKICZFreezer_LargeIceShardAnim:
                dc.b    0, $27, $23, $27, $13, $27, $24, $27, $14, $FC
SKICZFreezer_MediumIceShardAnim:
                dc.b    0, $27,  $C, $27,  $D, $27,  $E, $FC
SKICZFreezer_SmallIceShardAnim:
                dc.b    0, $27,  $F, $27, $10, $27, $11, $FC
                even
