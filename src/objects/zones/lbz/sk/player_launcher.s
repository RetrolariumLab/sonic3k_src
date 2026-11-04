; Owner: objects/zones/lbz/sk
; Responsibility: Launch Base player launcher initialization, launch control, player release and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
SKLBZLauncher_LaunchSpeeds:
                dc.w    $1000
                dc.w    $A00
; ---------------------------------------------------------------------------

Obj_LBZPlayerLauncher:
                move.l  #Map_LBZPlayerLauncher,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZMisc,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.b  subtype(a0),d0
                andi.w  #2,d0
                move.w  SKLBZLauncher_LaunchSpeeds(pc,d0.w),$34(a0)
                move.l  #SKLBZLauncher_CheckGroundedP1,(a0)

SKLBZLauncher_CheckGroundedP1:
                move.w  x_pos(a0),d0
                move.w  d0,d1
                subi.w  #$10,d0
                addi.w  #$10,d1
                move.w  y_pos(a0),d2
                move.w  d2,d3
                subi.w  #$10,d2
                addi.w  #$10,d3
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   SKLBZLauncher_CheckGroundedP2
                move.w  x_pos(a1),d4
                cmp.w   d0,d4
                blo.w   SKLBZLauncher_CheckGroundedP2
                cmp.w   d1,d4
                bhs.w   SKLBZLauncher_CheckGroundedP2
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blo.w   SKLBZLauncher_CheckGroundedP2
                cmp.w   d3,d4
                bhs.w   SKLBZLauncher_CheckGroundedP2
                move.w  d0,-(sp)
                lea     $38(a0),a2
                bsr.w   ApplyLbzLauncherContactCharge
                move.w  (sp)+,d0

SKLBZLauncher_CheckGroundedP2:
                lea     (Player_2).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   SKLBZLauncher_DrawLauncher
                move.w  x_pos(a1),d4
                cmp.w   d0,d4
                blo.w   SKLBZLauncher_DrawLauncher
                cmp.w   d1,d4
                bhs.w   SKLBZLauncher_DrawLauncher
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blo.w   SKLBZLauncher_DrawLauncher
                cmp.w   d3,d4
                bhs.w   SKLBZLauncher_DrawLauncher
                lea     $3A(a0),a2
                bsr.w   ApplyLbzLauncherContactCharge

SKLBZLauncher_DrawLauncher:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

ApplyLbzLauncherContactCharge:
                tst.w   (a2)
                bne.s   SKLBZLauncher_TickChargeAndTryLaunch
                move.l  a1,-(sp)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKLBZLauncher_RestorePlayerPointer
                move.l  #SKLBZLauncher_InitLauncherArm,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.w  a2,$3C(a1)

; The charge counter advances even if the arm could not be allocated
SKLBZLauncher_RestorePlayerPointer:
                movea.l (sp)+,a1

SKLBZLauncher_TickChargeAndTryLaunch:
                addq.w  #1,(a2)
                cmpi.w  #4,(a2)
                beq.s   SKLBZLauncher_CalcDirectedLaunchSpeed
                move.w  x_vel(a1),d0
                btst    #0,render_flags(a0)
                beq.s   SKLBZLauncher_DampOpposingMotion
                neg.w   d0

SKLBZLauncher_DampOpposingMotion:
                tst.w   d0
                bpl.s   SKLBZLauncher_DampingReturn
                asr     ground_vel(a1)
                asr     x_vel(a1)

SKLBZLauncher_DampingReturn:
                rts
; ---------------------------------------------------------------------------

SKLBZLauncher_CalcDirectedLaunchSpeed:
                move.w  x_vel(a1),d0
                btst    #0,status(a0)
                beq.s   SKLBZLauncher_TryApplyLaunchSpeed
                neg.w   d0

SKLBZLauncher_TryApplyLaunchSpeed:
                cmpi.w  #$1000,d0
                bge.s   SKLBZLauncher_PlayLaunchSound
                move.w  $34(a0),x_vel(a1)
                bclr    #Status_Facing,status(a1)
                btst    #0,status(a0)
                beq.s   SKLBZLauncher_FinishLaunch
                bset    #Status_Facing,status(a1)
                neg.w   x_vel(a1)

SKLBZLauncher_FinishLaunch:
                move.w  #15,move_lock(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #p1_pushing_bit,status(a0)
                bclr    #p2_pushing_bit,status(a0)
                bclr    #Status_Push,status(a1)

; Play the sound even when the rider already meets the launch-speed threshold
SKLBZLauncher_PlayLaunchSound:
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; End of function ApplyLbzLauncherContactCharge

; ---------------------------------------------------------------------------

SKLBZLauncher_InitLauncherArm:
                move.l  #Map_LBZPlayerLauncher,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZMisc,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #8,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  x_pos(a0),$30(a0)
                addi.w  #$10,y_pos(a0)
                move.w  y_pos(a0),$32(a0)
                move.b  #1,mapping_frame(a0)
                move.b  #$80,$40(a0)
                bset    #6,render_flags(a0)
                move.w  #4,mainspr_childsprites(a0)
                move.l  #SKLBZLauncher_UpdateArmAndSprites,(a0)

SKLBZLauncher_UpdateArmAndSprites:
                move.w  $36(a0),d0
                move.w  SKLBZLauncher_ArmStateTable(pc,d0.w),d1
                jsr     SKLBZLauncher_ArmStateTable(pc,d1.w)
                bsr.w   PositionLbzLauncherArmSprites
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
SKLBZLauncher_ArmStateTable:
                dc.w    SKLBZLauncher_ExtendArmAndResetCharge-SKLBZLauncher_ArmStateTable
                dc.w    SKLBZLauncher_RetractAndRetireArm-SKLBZLauncher_ArmStateTable
; ---------------------------------------------------------------------------

SKLBZLauncher_ExtendArmAndResetCharge:
                addi.b  #$10,$40(a0)
                cmpi.b  #$D0,$40(a0)
                bne.s   SKLBZLauncher_ArmExtendReturn
                movea.w $3C(a0),a2
                move.w  #0,(a2)
                addq.w  #2,$36(a0)

SKLBZLauncher_ArmExtendReturn:
                rts
; ---------------------------------------------------------------------------

SKLBZLauncher_RetractAndRetireArm:
                subi.b  #4,$40(a0)
                cmpi.b  #$80,$40(a0)
                bne.s   SKLBZLauncher_ArmRetractReturn
                move.w  #$7F00,$30(a0)

SKLBZLauncher_ArmRetractReturn:
                rts

; =============== S U B R O U T I N E =======================================

PositionLbzLauncherArmSprites:
                move.b  $40(a0),d0
                btst    #0,render_flags(a0)
                beq.s   SKLBZLauncher_CalcArmSpriteSteps
                neg.b   d0
                addi.b  #$80,d0

SKLBZLauncher_CalcArmSpriteSteps:
                jsr     (GetSineCosine).l
                move.w  $32(a0),d2
                move.w  $30(a0),d3
                moveq   #0,d6
                move.w  mainspr_childsprites(a0),d6
                subq.w  #1,d6
                bcs.s   SKLBZLauncher_ArmPlacementReturn
                swap    d0
                swap    d1
                asr.l   #4,d0
                asr.l   #4,d1
                moveq   #0,d4
                moveq   #0,d5
                add.l   d0,d4
                add.l   d1,d5
                lea     sub2_x_pos(a0),a2

SKLBZLauncher_PlaceArmSprite:
                movem.l d4-d5,-(sp)
                swap    d4
                swap    d5
                add.w   d2,d4
                add.w   d3,d5
                move.w  d5,(a2)+
                move.w  d4,(a2)+
                movem.l (sp)+,d4-d5
                add.l   d0,d4
                add.l   d1,d5
                addq.w  #1,a2
                move.b  #1,(a2)+
                dbf     d6,SKLBZLauncher_PlaceArmSprite
                swap    d4
                swap    d5
                add.w   d2,d4
                add.w   d3,d5
                move.w  d5,x_pos(a0)
                move.w  d4,y_pos(a0)

SKLBZLauncher_ArmPlacementReturn:
                rts
; End of function PositionLbzLauncherArmSprites

; =============== S U B R O U T I N E =======================================

InitializeLbzFlamethrowerVisuals:
                move.l  #Map_LBZFlameThrower,mappings(a1)
                move.w  #make_art_tile(ArtTile_LBZMisc-$17,2,0),art_tile(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                ori.b   #4,render_flags(a1)
                move.w  #$200,priority(a1)
                rts
; End of function InitializeLbzFlamethrowerVisuals
