; Owner: objects/zones/aiz/s3
; Responsibility: Angel Island spiked log state, movement, player collision and damage
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZSpikedLog:
                move.l  #Map_AIZSpikedLog,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,0),art_tile(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.b  #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.w  y_pos(a0),$30(a0)
                move.b  (Water_entered_counter).w,$36(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3SpikedLog_StartUpdate
                move.l  #S3SpikedLog_UpdateTouchProxy,(a1)
                move.b  #4,render_flags(a1)
                move.b  #$9C,collision_flags(a1)
                move.w  a0,$3C(a1)
                move.w  a1,$3C(a0)

S3SpikedLog_StartUpdate:
                move.l  #S3SpikedLog_CheckForcedOrWaterCycle,(a0)

S3SpikedLog_CheckForcedOrWaterCycle:
                tst.b   $34(a0)
                bmi.s   S3SpikedLog_TryStartRotation
                move.b  $36(a0),d0
                cmp.b   (Water_entered_counter).w,d0
                beq.s   S3SpikedLog_CheckRidersOrRelax
                move.b  (Water_entered_counter).w,$36(a0)
                move.b  #-$7F,$34(a0)
                bra.s   S3SpikedLog_TryStartRotation
; ---------------------------------------------------------------------------

S3SpikedLog_CheckRidersOrRelax:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   S3SpikedLog_TryStartRotation
                tst.b   $32(a0)
                beq.s   S3SpikedLog_ApplyDepressionAndRotate
                subq.b  #4,$32(a0)
                bra.s   S3SpikedLog_ApplyDepressionAndRotate
; ---------------------------------------------------------------------------

S3SpikedLog_TryStartRotation:
                tst.b   $34(a0)
                bne.s   S3SpikedLog_IncreaseDepression
                move.b  anim_frame(a0),$35(a0)
                move.b  #0,anim_frame(a0)
                move.b  #0,anim_frame_timer(a0)
                move.b  #1,$34(a0)

S3SpikedLog_IncreaseDepression:
                cmpi.b  #$40,$32(a0)
                beq.s   S3SpikedLog_ClearForcedCycle
                addq.b  #4,$32(a0)
                bra.s   S3SpikedLog_ApplyDepressionAndRotate
; ---------------------------------------------------------------------------

S3SpikedLog_ClearForcedCycle:
                andi.b  #$7F,$34(a0)

S3SpikedLog_ApplyDepressionAndRotate:
                move.b  $32(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #5,d0
                add.w   $30(a0),d0
                move.w  d0,y_pos(a0)
                tst.b   $34(a0)
                beq.s   S3SpikedLog_StepIdleAnim
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3SpikedLog_CheckSolidAndDraw
                move.b  #3,anim_frame_timer(a0)
                subq.b  #1,mapping_frame(a0)
                andi.b  #$F,mapping_frame(a0)
                addq.b  #1,anim_frame(a0)
                cmpi.b  #$10,anim_frame(a0)
                blo.s   S3SpikedLog_CheckSolidAndDraw
                move.b  $35(a0),anim_frame(a0)
                move.b  #0,$34(a0)
                bra.s   S3SpikedLog_CheckSolidAndDraw
; ---------------------------------------------------------------------------

S3SpikedLog_StepIdleAnim:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3SpikedLog_CheckSolidAndDraw
                move.b  #$17,anim_frame_timer(a0)
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #1,anim_frame(a0)
                move.b  S3SpikedLog_IdleFrames(pc,d0.w),mapping_frame(a0)
                move.b  S3SpikedLog_IdleFrames+1(pc,d0.w),d0
                bpl.s   S3SpikedLog_JoinSolidUpdate
                move.b  #0,anim_frame(a0)

S3SpikedLog_JoinSolidUpdate:
                bra.s   S3SpikedLog_CheckSolidAndDraw
; ---------------------------------------------------------------------------
S3SpikedLog_IdleFrames:
                dc.b    7
                dc.b    8
                dc.b    9
                dc.b    $A
                dc.b    9
                dc.b    8
                dc.b    -1
                even
; ---------------------------------------------------------------------------

S3SpikedLog_CheckSolidAndDraw:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3SpikedLog_TryDeleteTouchProxy
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3SpikedLog_TryDeleteTouchProxy:
                move.w  $3C(a0),d0
                beq.s   S3SpikedLog_ClearRespawnBit
                movea.w d0,a1
                jsr     (Delete_Referenced_Sprite).l

S3SpikedLog_ClearRespawnBit:
                move.w  respawn_addr(a0),d0
                beq.s   S3SpikedLog_DeleteAfterProxyCleanup
                movea.w d0,a2
                bclr    #7,(a2)

S3SpikedLog_DeleteAfterProxyCleanup:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3SpikedLog_UpdateTouchProxy:
                movea.w $3C(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.b  S3SpikedLog_TouchOffsetsByFrame(pc,d0.w),d0
                beq.s   S3SpikedLog_TouchProxyReturn
                ext.w   d0
                add.w   d0,y_pos(a0)
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

S3SpikedLog_TouchProxyReturn:
                rts
; ---------------------------------------------------------------------------
S3SpikedLog_TouchOffsetsByFrame:
                dc.b    -$C, -$C,   0,   0,   0,   0,   0,  $C,  $C,  $C,   0,   0,   0,   0,   0, -$C
                even
