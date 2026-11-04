; Owner: objects/zones/hcz/s3
; Responsibility: Hydrocity air-bubble, water-rush and water-wall object families with player contact, debris and shared sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_Bubbler:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Bubbler_Index(pc,d0.w),d1
                jmp     Bubbler_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Bubbler_Index:
                dc.w    S3HCZWater_InitBubbleOrEmitter-Bubbler_Index
                dc.w    S3HCZWater_AnimateAndCheckBreathFrame-Bubbler_Index
                dc.w    S3HCZWater_TryPopAtSurface-Bubbler_Index
                dc.w    S3HCZWater_AnimateBubblePop-Bubbler_Index
                dc.w    S3HCZWater_DeleteFinishedBubble-Bubbler_Index
                dc.w    S3HCZWater_TryStartBurst-Bubbler_Index
; ---------------------------------------------------------------------------

S3HCZWater_InitBubbleOrEmitter:
                addq.b  #2,routine(a0)
                move.l  #Map_Bubbler,mappings(a0)
                move.w  #make_art_tile(ArtTile_Bubbles,0,0),art_tile(a0)
                move.b  #$84,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.b  subtype(a0),d0
                bpl.s   S3HCZWater_InitRisingBubble
                addq.b  #8,routine(a0)
                andi.w  #$7F,d0
                move.b  d0,$32(a0)
                move.b  d0,$33(a0)
                move.b  #8,anim(a0)
                bra.w   S3HCZWater_TryStartBurst
; ---------------------------------------------------------------------------

S3HCZWater_InitRisingBubble:
                move.b  d0,anim(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  #-$88,y_vel(a0)
                jsr     (Random_Number).l
                move.b  d0,angle(a0)

S3HCZWater_AnimateAndCheckBreathFrame:
                lea     (Ani_Bubbler).l,a1
                jsr     (Animate_Sprite).l
                cmpi.b  #6,mapping_frame(a0)
                bne.s   S3HCZWater_TryPopAtSurface
                move.b  #1,$2E(a0)

S3HCZWater_TryPopAtSurface:
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                blo.s   S3HCZWater_WobbleAndCheckBreathing
                move.b  #6,routine(a0)
                addq.b  #4,anim(a0)
                bra.w   S3HCZWater_AnimateBubblePop
; ---------------------------------------------------------------------------

S3HCZWater_WobbleAndCheckBreathing:
                move.b  angle(a0),d0
                addq.b  #1,angle(a0)
                andi.w  #$7F,d0
                lea     (AirCountdown_WobbleData).l,a1
                move.b  (a1,d0.w),d0
                ext.w   d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                tst.b   $2E(a0)
                beq.s   S3HCZWater_MoveAndDrawRisingBubble
                bsr.w   CheckPlayersForHczAirBubble
                cmpi.b  #6,routine(a0)
                beq.s   S3HCZWater_AnimateBubblePop

S3HCZWater_MoveAndDrawRisingBubble:
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bpl.s   S3HCZWater_DeleteHiddenRisingBubble
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3HCZWater_DeleteHiddenRisingBubble:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3HCZWater_AnimateBubblePop:
                lea     (Ani_Bubbler).l,a1
                jsr     (Animate_Sprite).l
                tst.b   render_flags(a0)
                bpl.s   S3HCZWater_DeleteHiddenPoppingBubble
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3HCZWater_DeleteHiddenPoppingBubble:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3HCZWater_DeleteFinishedBubble:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3HCZWater_TryStartBurst:
                tst.w   $36(a0)
                bne.s   S3HCZWater_TickBurstGap
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                bhs.w   S3HCZWater_CullOrDrawEmitter
                tst.b   render_flags(a0)
                bpl.w   S3HCZWater_CullOrDrawEmitter
                subq.w  #1,$38(a0)
                bpl.w   S3HCZWater_AnimateEmitter
                move.w  #1,$36(a0)

S3HCZWater_PickBurstPattern:
                jsr     (Random_Number).l
                move.w  d0,d1
                andi.w  #7,d0
                cmpi.w  #6,d0
                bhs.s   S3HCZWater_PickBurstPattern
                move.b  d0,$34(a0)
                andi.w  #$C,d1
                lea     (S3HCZWater_BurstPatternWindows).l,a1
                adda.w  d1,a1
                move.l  a1,$3C(a0)
                subq.b  #1,$32(a0)
                bpl.s   S3HCZWater_JoinFirstBurstAttempt
                move.b  $33(a0),$32(a0)
                bset    #7,$36(a0)

S3HCZWater_JoinFirstBurstAttempt:
                bra.s   S3HCZWater_TrySpawnPatternBubble
; ---------------------------------------------------------------------------

S3HCZWater_TickBurstGap:
                subq.w  #1,$38(a0)
                bpl.w   S3HCZWater_AnimateEmitter

S3HCZWater_TrySpawnPatternBubble:
                jsr     (Random_Number).l
                andi.w  #$1F,d0
                move.w  d0,$38(a0)
                jsr     (AllocateObject).l
                bne.s   S3HCZWater_ConsumeBurstAttempt
                move.l  (a0),(a1)
                move.w  x_pos(a0),x_pos(a1)
                jsr     (Random_Number).l
                andi.w  #$F,d0
                subq.w  #8,d0
                add.w   d0,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                moveq   #0,d0
                move.b  $34(a0),d0
                movea.l $3C(a0),a2
                move.b  (a2,d0.w),subtype(a1)
                btst    #7,$36(a0)
                beq.s   S3HCZWater_ConsumeBurstAttempt
                jsr     (Random_Number).l
                andi.w  #3,d0
                bne.s   S3HCZWater_TryForceLastBubbleLarge
                bset    #6,$36(a0)
                bne.s   S3HCZWater_ConsumeBurstAttempt
                move.b  #2,subtype(a1)

S3HCZWater_TryForceLastBubbleLarge:
                tst.b   $34(a0)
                bne.s   S3HCZWater_ConsumeBurstAttempt
                bset    #6,$36(a0)
                bne.s   S3HCZWater_ConsumeBurstAttempt
                move.b  #2,subtype(a1)

; Count the attempt even when no object slot was allocated
S3HCZWater_ConsumeBurstAttempt:
                subq.b  #1,$34(a0)
                bpl.s   S3HCZWater_AnimateEmitter
                jsr     (Random_Number).l
                andi.w  #$7F,d0
                addi.w  #$80,d0
                add.w   d0,$38(a0)
                clr.w   $36(a0)

S3HCZWater_AnimateEmitter:
                lea     (Ani_Bubbler).l,a1
                jsr     (Animate_Sprite).l

S3HCZWater_CullOrDrawEmitter:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3HCZWater_ClearEmitterRespawn
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                blo.w   S3HCZWater_DrawSubmergedEmitter
                rts
; ---------------------------------------------------------------------------

S3HCZWater_ClearEmitterRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   S3HCZWater_DeleteEmitter
                movea.w d0,a2
                bclr    #7,(a2)

S3HCZWater_DeleteEmitter:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3HCZWater_DrawSubmergedEmitter:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
S3HCZWater_BurstPatternWindows:
                dc.b    0
                dc.b    1
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    1
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    1
                dc.b    0
                dc.b    1
                dc.b    0
                dc.b    0
                dc.b    1
                dc.b    0
                even

; =============== S U B R O U T I N E =======================================

CheckPlayersForHczAirBubble:
                lea     (Player_1).w,a1
                bsr.s   LetPlayerBreatheHczAirBubble
                lea     (Player_2).w,a1
; End of function CheckPlayersForHczAirBubble

LetPlayerBreatheHczAirBubble:
                tst.b   object_control(a1)
                bmi.w   S3HCZWater_BreathContactReturn
                move.w  x_pos(a1),d0
                move.w  x_pos(a0),d1
                subi.w  #$10,d1
                cmp.w   d0,d1
                bhs.w   S3HCZWater_BreathContactReturn
                addi.w  #2*$10,d1
                cmp.w   d0,d1
                blo.w   S3HCZWater_BreathContactReturn
                move.w  y_pos(a1),d0
                move.w  y_pos(a0),d1
                cmp.w   d0,d1
                bhs.w   S3HCZWater_BreathContactReturn
                addi.w  #$10,d1
                cmp.w   d0,d1
                blo.w   S3HCZWater_BreathContactReturn
                btst    #Status_BublShield,status_secondary(a1)
                bne.w   S3HCZWater_BreathContactReturn
                jsr     (Player_ResetAirTimer).l
                moveq   #signextendB(sfx_Bubble),d0
                jsr     (Play_SFX).l
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.b  #$15,anim(a1)
                move.w  #35,move_lock(a1)
                move.b  #0,jumping(a1)
                bclr    #Status_Push,status(a1)
                bclr    #Status_RollJump,status(a1)
                btst    #Status_Roll,status(a1)
                beq.w   S3HCZWater_TryStartBreathingPop
                cmpi.l  #Obj_Sonic,(a1)
                bne.s   S3HCZWater_AdjustRolledRadii
                bclr    #Status_Roll,status(a1)
                move.b  #$13,y_radius(a1)
                move.b  #9,x_radius(a1)
                subq.w  #5,y_pos(a1)
                bra.s   S3HCZWater_TryStartBreathingPop
; ---------------------------------------------------------------------------

S3HCZWater_AdjustRolledRadii:
                move.b  #$F,y_radius(a1)
                move.b  #9,x_radius(a1)
                subq.w  #1,y_pos(a1)

S3HCZWater_TryStartBreathingPop:
                cmpi.b  #6,routine(a0)
                beq.s   S3HCZWater_BreathContactReturn
                move.b  #6,routine(a0)
                addq.b  #4,anim(a0)

S3HCZWater_BreathContactReturn:
                rts
; ---------------------------------------------------------------------------
Ani_Bubbler:
                include "src/objects/shared/bubbles/animations/bubbler.s"
Map_Bubbler:
                include "src/objects/shared/bubbles/mappings/bubbler.s"
; ---------------------------------------------------------------------------

Obj_HCZWaterRush:
                move.l  #Map_HCZWaterRush,mappings(a0)
                ori.b   #4,render_flags(a0)
                move.w  #make_art_tile(ArtTile_HCZWaterRush,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #2,mapping_frame(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3HCZWater_InitRushTriggerWait
                move.l  #S3HCZWater_TryStartRisingBlock,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subi.w  #$30,x_pos(a1)
                move.l  #Map_HCZWaterRushBlock,mappings(a1)
                move.w  #make_art_tile(ArtTile_HCZMisc+$A,2,0),art_tile(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$20,height_pixels(a1)
                move.b  #4,render_flags(a1)
                move.w  #$280,priority(a1)
                move.b  #1,mapping_frame(a1)
                move.w  a1,$3C(a0)

S3HCZWater_InitRushTriggerWait:
                move.b  #3,(HczPlayerWaterTunnelBlockBits).w
                move.l  #S3HCZWater_TryActivateRush,(a0)

S3HCZWater_TryActivateRush:
                tst.b   (Level_trigger_array).w
                beq.s   S3HCZWater_DrawWaitingRush
                move.b  #3,mapping_frame(a0)
                move.b  #1,anim_frame_timer(a0)
                move.l  #S3HCZWater_StepRushAnimAndMotion,(a0)
                move.b  #0,(HczPlayerWaterTunnelBlockBits).w
                move.b  #1,(Palette_cycle_counters+$00).w

S3HCZWater_DrawWaitingRush:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

S3HCZWater_StepRushAnimAndMotion:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3HCZWater_TryHideFinishedRush
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #2,mapping_frame(a0)
                bne.s   S3HCZWater_WrapRushFrame
                addi.w  #$20,x_pos(a0)
                cmpi.w  #$580,x_pos(a0)
                bne.s   S3HCZWater_WrapRushFrame
                cmpi.w  #$5A0,y_pos(a0)
                bne.s   S3HCZWater_WrapRushFrame
                subi.w  #$20,x_pos(a0)
                subi.w  #$20,y_pos(a0)

S3HCZWater_WrapRushFrame:
                andi.b  #1,mapping_frame(a0)

S3HCZWater_TryHideFinishedRush:
                cmpi.w  #$980,x_pos(a0)
                blo.s   S3HCZWater_DrawActiveRush
                move.w  #$7F00,x_pos(a0)

S3HCZWater_DrawActiveRush:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

S3HCZWater_TryStartRisingBlock:
                tst.b   (Level_trigger_array).w
                beq.s   S3HCZWater_CheckBlockSolidAndDraw
                move.l  #S3HCZWater_MoveAndTryHideBlock,(a0)

S3HCZWater_MoveAndTryHideBlock:
                subi.w  #$10,y_pos(a0)
                cmpi.w  #$560,y_pos(a0)
                bne.s   S3HCZWater_CheckBlockSolidAndDraw
                move.w  #$7F00,x_pos(a0)

S3HCZWater_CheckBlockSolidAndDraw:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_HCZWaterRush:
                include "src/objects/shared/zones/hcz/mappings/water_rush.s"
Map_HCZWaterRushBlock:
                include "src/objects/shared/zones/hcz/mappings/water_rush_block.s"
; ---------------------------------------------------------------------------

Obj_HCZWaterWall:
                tst.b   subtype(a0)
                beq.s   S3HCZWater_CheckHorizontalWallY
                move.l  #S3HCZWater_CheckVerticalLiftWindow,(a0)
                rts
; ---------------------------------------------------------------------------

S3HCZWater_CheckHorizontalWallY:
                move.w  (Player_1+y_pos).w,d0
                cmpi.w  #$500,d0
                bhs.s   S3HCZWater_QueueHorizontalWallArt
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3HCZWater_QueueHorizontalWallArt:
                lea     (ArtKosM_HCZGeyserHorz).l,a1
                move.w  #tiles_to_bytes(ArtTile_HCZGeyser),d2
                jsr     (Queue_Kos_Module).l
                move.l  #S3HCZWater_WaitForHorizontalWallArt,(a0)

S3HCZWater_WaitForHorizontalWallArt:
                tst.b   (Kos_modules_left).w
                beq.s   S3HCZWater_InitHorizontalWall
                rts
; ---------------------------------------------------------------------------

S3HCZWater_InitHorizontalWall:
                ori.b   #4,render_flags(a0)
                move.w  #$300,priority(a0)
                move.l  #Map_HCZWaterWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZGeyser,2,0),art_tile(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                bset    #6,render_flags(a0)
                move.w  #1,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #$20,$30(a0)
                move.l  #S3HCZWater_TryStartHorizontalBurst,(a0)

S3HCZWater_TryStartHorizontalBurst:
                move.w  (Player_1+x_pos).w,d0
                subi.w  #$60,d0
                cmp.w   x_pos(a0),d0
                blo.w   S3HCZWater_DrawWaitingHorizontalWall
                move.l  #S3HCZWater_StepHorizontalWall,(a0)
                moveq   #signextendB(sfx_Geyser),d0
                jsr     (Play_SFX).l
                lea     (S3HCZWater_HorizontalDebrisRecords).l,a3
                move.w  x_pos(a0),d2
                addi.w  #$60,d2
                move.w  y_pos(a0),d3
                moveq   #8-1,d1

S3HCZWater_TrySpawnHorizontalDebris:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   S3HCZWater_DrawWaitingHorizontalWall
                move.l  #S3HCZWater_AnimateAirborneDebris,(a1)
                move.l  #Map_HCZWaterWallDebris,mappings(a1)
                move.w  #make_art_tile(ArtTile_HCZGeyser+$58,2,0),art_tile(a1)
                move.b  #$84,render_flags(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d3,d0
                move.w  d0,y_pos(a1)
                move.w  #$380,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.w  (a3)+,x_vel(a1)
                move.w  (a3)+,y_vel(a1)
                move.b  d1,mapping_frame(a1)
                dbf     d1,S3HCZWater_TrySpawnHorizontalDebris

S3HCZWater_DrawWaitingHorizontalWall:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
S3HCZWater_HorizontalDebrisRecords:
                dc.b    0,-$18
                dc.w    $400,  -$80
                dc.b    0,  -8
                dc.w    $600,  -$40
                dc.b    0,   8
                dc.w    $600,   $40
                dc.b    0, $18
                dc.w    $400,   $80
                dc.b    0,-$18
                dc.w    $300, -$380
                dc.b    0,  -8
                dc.w    $400, -$340
                dc.b    0,   8
                dc.w    $300,  $100
                dc.b    0, $18
                dc.w    $500, -$100
; ---------------------------------------------------------------------------

S3HCZWater_StepHorizontalWall:
                tst.w   $30(a0)
                beq.s   S3HCZWater_TrySpawnHorizontalDroplet
                subq.w  #1,$30(a0)
                addq.w  #8,x_pos(a0)

S3HCZWater_TrySpawnHorizontalDroplet:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3HCZWater_SyncHorizontalWallAndCull
                move.l  #S3HCZWater_MoveDropletToSurface,(a1)
                move.l  mappings(a0),mappings(a1)
                move.b  #$84,render_flags(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  (Level_frame_counter).w,d0
                jsr     (Random_Number).l
                move.w  d0,d1
                andi.w  #$F,d0
                lsl.w   #3,d0
                subi.w  #$50,d0
                add.w   d0,x_pos(a1)
                addi.w  #$18,y_pos(a1)
                move.w  #make_art_tile(ArtTile_HCZGeyser+$30,2,0),art_tile(a1)
                lsr.w   #4,d1
                andi.w  #3,d1
                bne.s   S3HCZWater_LaunchHorizontalDroplet
                move.w  #make_art_tile(ArtTile_Bubbles,0,0),art_tile(a1)

S3HCZWater_LaunchHorizontalDroplet:
                move.b  d1,anim(a1)
                move.w  #$380,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.w  #$400,x_vel(a1)
                move.w  #0,y_vel(a1)

S3HCZWater_SyncHorizontalWallAndCull:
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                tst.b   render_flags(a0)
                bmi.s   S3HCZWater_DrawActiveHorizontalWall
                clr.b   (Palette_cycle_counters+$00).w
                move.w  #signextendB(cmd_MutePSG),d0
                jsr     (Play_SFX).l
                move.w  #signextendB(cmd_StopSFX),d0
                jsr     (Play_SFX).l
                move.w  #150,$30(a0)
                move.l  #S3HCZWater_TickEnemyArtReloadDelay,(a0)
                rts
; ---------------------------------------------------------------------------

S3HCZWater_DrawActiveHorizontalWall:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

S3HCZWater_TickEnemyArtReloadDelay:
                subq.w  #1,$30(a0)
                bmi.s   S3HCZWater_ReloadEnemyArtAndDelete
                rts
; ---------------------------------------------------------------------------

S3HCZWater_ReloadEnemyArtAndDelete:
                jsr     (LoadEnemyArt).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3HCZWater_AnimateAirborneDebris:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3HCZWater_MoveDebrisToWater
                move.b  #2,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #7,mapping_frame(a0)

S3HCZWater_MoveDebrisToWater:
                jsr     (MoveSprite2).l
                addi.w  #$38,y_vel(a0)
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   S3HCZWater_DrawAirborneDebris
                move.w  #0,y_vel(a0)
                asr     x_vel(a0)
                asr     x_vel(a0)
                move.l  #S3HCZWater_AnimateSubmergedDebris,(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3HCZWater_DrawAirborneDebris
                move.l  #S3HCZWater_AnimateWallSplash,(a1)
                move.l  #Map_HCZWaterWall,mappings(a1)
                move.w  #make_art_tile(ArtTile_HCZGeyser+$30,1,0),art_tile(a1)
                move.b  #$84,render_flags(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  (Water_level).w,y_pos(a1)
                move.w  #$200,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.b  #8,anim(a1)

S3HCZWater_DrawAirborneDebris:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3HCZWater_AnimateSubmergedDebris:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3HCZWater_MoveSubmergedDebris
                move.b  #9,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #7,mapping_frame(a0)

S3HCZWater_MoveSubmergedDebris:
                jsr     (MoveSprite2).l
                addi.w  #8,y_vel(a0)
                tst.b   render_flags(a0)
                bpl.w   S3HCZWater_DeleteHiddenDebris
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3HCZWater_DeleteHiddenDebris:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3HCZWater_MoveDropletToSurface:
                jsr     (MoveSprite2).l
                addi.w  #$28,y_vel(a0)
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   S3HCZWater_AnimateMovingDroplet
                move.w  d0,y_pos(a0)
                move.l  #S3HCZWater_AnimateDropletPop,(a0)
                addq.b  #4,anim(a0)

S3HCZWater_AnimateMovingDroplet:
                tst.b   render_flags(a0)
                bpl.w   S3HCZWater_DeleteHiddenDebris
                lea     (Ani_HCZWaterWall).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3HCZWater_AnimateDropletPop:
                tst.b   render_flags(a0)
                bpl.w   S3HCZWater_DeleteHiddenDebris
                lea     (Ani_HCZWaterWall).l,a1
                jsr     (Animate_Sprite).l
                tst.b   routine(a0)
                bne.w   S3HCZWater_DeleteHiddenDebris
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3HCZWater_AnimateWallSplash:
                tst.b   render_flags(a0)
                bpl.w   S3HCZWater_DeleteHiddenDebris
                lea     (Ani_HCZWaterWall).l,a1
                jsr     (Animate_SpriteIrregularDelay).l
                tst.b   routine(a0)
                bne.w   S3HCZWater_DeleteHiddenDebris
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_HCZWaterWall:
                include "src/objects/shared/zones/hcz/animations/water_wall.s"
; ---------------------------------------------------------------------------

S3HCZWater_CheckVerticalLiftWindow:
                move.w  (Player_1+x_pos).w,d0
                addi.w  #$30,d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$60,d0
                bhs.s   S3HCZWater_CullDormantVerticalWall
                move.w  (Player_1+y_pos).w,d0
                addi.w  #$40,d0
                sub.w   y_pos(a0),d0
                cmpi.w  #$10,d0
                blo.s   S3HCZWater_QueueVerticalArtAndLockP1P2

S3HCZWater_CullDormantVerticalWall:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

S3HCZWater_QueueVerticalArtAndLockP1P2:
                lea     (ArtKosM_HCZGeyserVert).l,a1
                move.w  #tiles_to_bytes(ArtTile_HCZGeyser),d2
                jsr     (Queue_Kos_Module).l
                move.b  #1,mapping_frame(a0)
                move.b  #$81,(Player_1+object_control).w
                move.b  #$81,(Player_2+object_control).w
                move.l  #S3HCZWater_LiftWhileArtLoads,(a0)

S3HCZWater_LiftWhileArtLoads:
                tst.b   (Kos_modules_left).w
                beq.s   S3HCZWater_InitVerticalLift
                subi.w  #8,(Player_1+y_pos).w
                subi.w  #8,(Player_2+y_pos).w
                rts
; ---------------------------------------------------------------------------

S3HCZWater_InitVerticalLift:
                ori.b   #4,render_flags(a0)
                move.w  #$300,priority(a0)
                move.l  #Map_HCZWaterWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZGeyser,2,0),art_tile(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$60,height_pixels(a0)
                move.w  #$60,$30(a0)
                move.b  #$1C,(Player_1+anim).w
                move.b  #$1C,(Player_2+anim).w
                move.l  #S3HCZWater_StepVerticalLift,(a0)

S3HCZWater_StepVerticalLift:
                tst.w   $30(a0)
                beq.s   S3HCZWater_LiftRidersAndTryBurst
                subq.w  #1,$30(a0)
                subq.w  #8,y_pos(a0)

S3HCZWater_LiftRidersAndTryBurst:
                subi.w  #8,(Player_1+y_pos).w
                subi.w  #8,(Player_2+y_pos).w
                cmpi.w  #$28,$30(a0)
                bhi.w   S3HCZWater_LiftOrBurstReturn
                move.b  #$1A,(Player_1+anim).w
                move.b  #$1A,(Player_2+anim).w
                move.l  #S3HCZWater_TickBurstAndReleaseRiders,(a0)
                moveq   #signextendB(sfx_Geyser),d0
                jsr     (Play_SFX).l
                move.b  #1,(Palette_cycle_counters+$00).w
                lea     (S3HCZWater_VerticalDebrisRecords).l,a3
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #$80,d3
                moveq   #8-1,d1

S3HCZWater_TrySpawnVerticalDebris:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   S3HCZWater_LiftOrBurstReturn
                move.l  #S3HCZWater_AnimateAirborneDebris,(a1)
                move.l  #Map_HCZWaterWallDebris,mappings(a1)
                move.w  #make_art_tile(ArtTile_HCZGeyser+$58,2,0),art_tile(a1)
                move.b  #$84,render_flags(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d3,d0
                move.w  d0,y_pos(a1)
                move.w  #$280,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.w  (a3)+,x_vel(a1)
                move.w  (a3)+,y_vel(a1)
                move.b  d1,mapping_frame(a1)
                dbf     d1,S3HCZWater_TrySpawnVerticalDebris

S3HCZWater_LiftOrBurstReturn:
                rts
; ---------------------------------------------------------------------------
S3HCZWater_VerticalDebrisRecords:
                dc.b    -$18,   0
                dc.w    -$200, -$B00
                dc.b    -8,   0
                dc.w    -$100, -$C00
                dc.b    -$18,   0
                dc.w    -$400, -$800
                dc.b    -8,   0
                dc.w    -$300, -$A00
                dc.b    8,   0
                dc.w    $300, -$C00
                dc.b    $18,   0
                dc.w    $400, -$B00
                dc.b    8,   0
                dc.w    $100, -$A00
                dc.b    $18,   0
                dc.w    $200, -$800
; ---------------------------------------------------------------------------

S3HCZWater_TickBurstAndReleaseRiders:
                tst.w   $30(a0)
                beq.s   S3HCZWater_MoveAndTryVerticalDroplets
                move.w  #-$A00,y_vel(a0)
                subq.w  #1,$30(a0)
                bne.s   S3HCZWater_MoveAndTryVerticalDroplets
                move.l  #S3HCZWater_TryMoveFreeVerticalWall,(a0)
                lea     (Player_1).w,a1
                move.b  #0,object_control(a1)
                move.w  #0,x_vel(a1)
                move.w  #-$C00,y_vel(a1)
                move.b  #0,jumping(a1)
                lea     (Player_2).w,a1
                move.b  #0,object_control(a1)
                move.w  #0,x_vel(a1)
                move.w  #-$C00,y_vel(a1)
                move.b  #0,jumping(a1)
                move.w  #-$800,y_vel(a0)

S3HCZWater_MoveAndTryVerticalDroplets:
                subi.w  #$A,(Player_1+y_pos).w
                subi.w  #$A,(Player_2+y_pos).w
                jsr     (MoveSprite2).l
                addi.w  #$48,y_vel(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3HCZWater_DrawVerticalBurst
                jsr     (Random_Number).l
                move.w  d0,d1
                move.w  d0,d2
                bsr.s   InitializeHczGeyserDroplet
                addi.w  #$10,x_pos(a1)
                andi.w  #$F,d1
                lsl.w   #6,d1
                move.w  d1,x_vel(a1)
                move.w  #-$700,y_vel(a1)
                move.w  d0,d2
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3HCZWater_DrawVerticalBurst
                bsr.s   InitializeHczGeyserDroplet
                subi.w  #$10,x_pos(a1)
                neg.w   d1
                move.w  d1,x_vel(a1)
                move.w  #-$700,y_vel(a1)

S3HCZWater_DrawVerticalBurst:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

InitializeHczGeyserDroplet:
                move.l  #S3HCZWater_MoveDropletToSurface,(a1)
                move.l  mappings(a0),mappings(a1)
                move.b  #$84,render_flags(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subi.w  #$50,y_pos(a1)
                move.w  #$380,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.w  #make_art_tile(ArtTile_HCZGeyser+$30,2,0),art_tile(a1)
                lsr.w   #4,d2
                andi.w  #3,d2
                bne.s   S3HCZWater_SetVerticalDropletAnim
                move.w  #make_art_tile(ArtTile_Bubbles,0,0),art_tile(a1)

S3HCZWater_SetVerticalDropletAnim:
                move.b  d2,anim(a1)
                rts
; End of function InitializeHczGeyserDroplet

; ---------------------------------------------------------------------------

S3HCZWater_TryMoveFreeVerticalWall:
                tst.b   render_flags(a0)
                bmi.s   S3HCZWater_MoveFreeVerticalWall
                move.w  #signextendB(cmd_StopSFX),d0
                jsr     (Play_SFX).l
                move.w  #signextendB(cmd_MutePSG),d0
                jsr     (Play_SFX).l                    ; this will actually never play... Why is any of this here?
                move.w  #signextendB(cmd_StopSFX),d0
                jsr     (Play_SFX).l
                move.b  #0,(Palette_cycle_counters+$00).w
                move.w  respawn_addr(a0),d0
                beq.s   S3HCZWater_StartEnemyArtReloadWait
                movea.w d0,a2
                bclr    #7,(a2)

S3HCZWater_StartEnemyArtReloadWait:
                move.w  #$1E,$30(a0)
                move.l  #S3HCZWater_TickEnemyArtReloadDelay,(a0)
                rts
; ---------------------------------------------------------------------------

S3HCZWater_MoveFreeVerticalWall:
                jsr     (MoveSprite2).l
                addi.w  #$48,y_vel(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_HCZWaterWall:
                include "src/objects/shared/zones/hcz/mappings/waterfall.s"
Map_HCZWaterWallDebris:
                include "src/objects/shared/zones/hcz/mappings/water_wall_debris.s"
; End of function S3HCZWater_TryMoveFreeVerticalWall
