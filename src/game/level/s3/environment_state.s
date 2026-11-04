; Owner: game/level/s3
; Responsibility: Competition environment palette, collision response reset, water surface height and dynamic water-level state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
Pal_Level_2P:
                binclude "data/Levels/Misc/Palettes/2P Level Secondary.bin"
                even
; ---------------------------------------------------------------------------

Obj_ResetCollisionResponseList:
                move.w  #0,(Collision_response_list).w
                rts

; =============== S U B R O U T I N E =======================================

UpdateWaterSurface:
                rts
; ---------------------------------------------------------------------------
; unused leftover from Sonic 2
                tst.b   (Water_flag).w
                beq.s   S3Water_RetainedSurfaceReturn
                move.w  (Camera_X_pos).w,d1
                btst    #0,(Level_frame_counter+1).w
                beq.s   S3Water_RetainedBiasSurface
                addi.w  #$20,d1

S3Water_RetainedBiasSurface:
                move.w  d1,d0
                addi.w  #$60,d0
                addi.w  #$120,d1

S3Water_RetainedSurfaceReturn:
                rts
; End of function UpdateWaterSurface

; =============== S U B R O U T I N E =======================================

Handle_Onscreen_Water_Height:
                tst.b   (Water_flag).w
                beq.w   S3Water_ApplyGroundSurfaceMotion
                tst.b   (Deform_lock).w
                bne.s   S3Water_SetCurrentFromMeanHeight
                cmpi.b  #6,(Player_1+routine).w
                bhs.s   S3Water_SetCurrentFromMeanHeight
                bsr.w   S3HCZ_ApplyWaterTunnelCurrents
                bsr.w   DynamicWaterHeight

S3Water_SetCurrentFromMeanHeight:
                clr.b   (Water_full_screen_flag).w
                moveq   #0,d0
                add.w   (Mean_water_level).w,d0
                move.w  d0,(Water_level).w
                cmpi.w  #$100,(Current_zone_and_act).w
                bne.s   S3Water_ClassifyCameraCoverage
                cmpi.w  #$900,(Camera_X_pos).w
                blo.s   S3Water_DisableSplitAndReturn

S3Water_ClassifyCameraCoverage:
                move.w  (Water_level).w,d0
                sub.w   (Camera_Y_pos).w,d0
                beq.s   S3Water_MarkFullScreenWater
                bcc.s   S3Water_CapSplitCounter
                tst.w   d0
                bpl.s   S3Water_CapSplitCounter

S3Water_MarkFullScreenWater:
                move.b  #1,(Water_full_screen_flag).w

S3Water_DisableSplitAndReturn:
                move.b  #-1,(H_int_counter).w
                rts
; ---------------------------------------------------------------------------

S3Water_CapSplitCounter:
                cmpi.w  #$DF,d0
                blo.s   S3Water_StoreSplitCounter
                move.w  #$FF,d0

S3Water_StoreSplitCounter:
                move.b  d0,(H_int_counter).w

S3Water_ApplyGroundSurfaceMotion:
                bsr.w   S3Surface_DispatchBothPlayers
                rts
; End of function Handle_Onscreen_Water_Height

; ---------------------------------------------------------------------------
; unused
                clr.b   (Water_full_screen_flag).w
                move.w  (Mean_water_level).w,(Water_level).w
                move.l  #HInt3,(H_int_addr).w
                cmpi.w  #$1000,(V_blank_cycles).w
                blo.s   S3Water_RetainedClassifyWrapSplit
                move.l  #HInt4,(H_int_addr).w

S3Water_RetainedClassifyWrapSplit:
                move.w  (Water_level).w,d0
                sub.w   (Camera_Y_pos).w,d0
                beq.s   S3Water_RetainedMarkFullWater
                bcc.s   S3Water_RetainedCapNormalSplit
                tst.w   d0
                bpl.s   S3Water_RetainedCapNormalSplit
                addi.w  #$1E0,d0
                beq.s   S3Water_RetainedMarkFullWater
                bcs.s   S3Water_RetainedCapReverseSplit

S3Water_RetainedMarkFullWater:
                move.b  #1,(Water_full_screen_flag).w
                move.b  #-1,(H_int_counter).w
                rts
; ---------------------------------------------------------------------------

S3Water_RetainedCapReverseSplit:
                cmpi.w  #$DF,d0
                blo.s   S3Water_RetainedInstallReverseHInt
                move.w  #$FF,d0

S3Water_RetainedInstallReverseHInt:
                move.b  d0,(H_int_counter).w
                move.b  #1,(Water_full_screen_flag).w
                move.l  #HInt5,(H_int_addr).w
                cmpi.w  #$1000,(V_blank_cycles).w
                blo.s   S3Water_RetainedJoinSurfaceMotion
                move.l  #HInt6,(H_int_addr).w

S3Water_RetainedJoinSurfaceMotion:
                bra.s   S3Water_RetainedApplySurfaceMotion
; ---------------------------------------------------------------------------

S3Water_RetainedCapNormalSplit:
                cmpi.w  #$DF,d0
                blo.s   S3Water_RetainedStoreNormalSplit
                move.w  #$FF,d0

S3Water_RetainedStoreNormalSplit:
                move.b  d0,(H_int_counter).w

S3Water_RetainedApplySurfaceMotion:
                bsr.w   S3Surface_DispatchBothPlayers
                rts
; ---------------------------------------------------------------------------
StartingWaterHeights:
                binclude "data/Levels/Misc/StartingWaterHeights.bin"
                even

; =============== S U B R O U T I N E =======================================

DynamicWaterHeight:
                moveq   #0,d0
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #6,d0
                andi.w  #$FFFE,d0
                move.w  DynamicWaterHeight_Index(pc,d0.w),d0
                jsr     DynamicWaterHeight_Index(pc,d0.w)
                moveq   #0,d1
                move.b  (Water_speed).w,d1
                move.w  (Target_water_level).w,d0
                sub.w   (Mean_water_level).w,d0
                beq.s   S3Water_StepHeightReturn
                bcc.s   S3Water_StepMeanHeight
                neg.w   d1

S3Water_StepMeanHeight:
                add.w   d1,(Mean_water_level).w

S3Water_StepHeightReturn:
                rts
; End of function DynamicWaterHeight

; ---------------------------------------------------------------------------
DynamicWaterHeight_Index:
                dc.w    DynamicWaterHeight_AIZ1-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_AIZ2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_HCZ1-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_HCZ2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_LBZ1-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Ending-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
; ---------------------------------------------------------------------------

DynamicWaterHeight_AIZ1:
                rts
; ---------------------------------------------------------------------------

DynamicWaterHeight_AIZ2:
                cmpi.w  #$820,(Camera_target_max_Y_pos).w
                beq.s   S3Water_AIZ2_WaterEventReturn
                cmpi.w  #$2440,(Camera_X_pos).w
                bhs.s   S3Water_AIZ2_TryLatchWaterTrigger
                cmpi.w  #$618,(Target_water_level).w
                bne.s   S3Water_AIZ2_WaterEventReturn
                move.w  #$528,(Target_water_level).w
                move.b  #2,(Water_speed).w
                rts
; ---------------------------------------------------------------------------

S3Water_AIZ2_TryLatchWaterTrigger:
                tst.b   (Level_trigger_array).w
                bne.s   S3Water_AIZ2_TryRaiseWater
                cmpi.w  #$2850,(Camera_X_pos).w
                blo.s   S3Water_AIZ2_WaterEventReturn
                move.b  #1,(Level_trigger_array).w

S3Water_AIZ2_TryRaiseWater:
                cmpi.w  #$618,(Target_water_level).w
                beq.s   S3Water_AIZ2_WaterEventReturn
                cmpi.w  #$2900,(Camera_X_pos).w
                bhs.s   S3Water_AIZ2_BeginLayoutClear
                move.w  #-1,(Screen_shake_flag).w
                jsr     (AllocateObject).l
                bne.s   S3Water_AIZ2_BeginLayoutClear
                move.l  #ScreenShakeDelay_CountDownToStop,(a1)
                move.b  #180,anim_frame_timer(a1)

S3Water_AIZ2_BeginLayoutClear:
                lea     (Level_layout_main+$1C).w,a3
                moveq   #4-1,d1

S3Water_AIZ2_ClearLayoutAndSetTarget:
                movea.w (a3),a1
                move.b  #0,$4E(a1)
                addq.w  #4,a3
                dbf     d1,S3Water_AIZ2_ClearLayoutAndSetTarget
                move.w  #$618,(Target_water_level).w

S3Water_AIZ2_WaterEventReturn:
                rts
; ---------------------------------------------------------------------------

ScreenShakeDelay_CountDownToStop:
                subq.b  #1,anim_frame_timer(a0)
                beq.s   ScreenShakeDelay_ClearFlagAndDelete
                rts
; ---------------------------------------------------------------------------

ScreenShakeDelay_ClearFlagAndDelete:
                move.w  #0,(Screen_shake_flag).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

DynamicWaterHeight_HCZ1:
                lea     (S3Water_HCZ1HeightByX).l,a1
                bra.s   S3Water_ReadCameraXForHeight
; ---------------------------------------------------------------------------
S3Water_HCZ1HeightByX:
                dc.w    $8500,  $900
                dc.w    $8680, $2A00
                dc.w    $8680, $3500
                dc.w    $86A0, $FFFF
; ---------------------------------------------------------------------------

DynamicWaterHeight_HCZ2:
                tst.b   (ZoneEventLatchOrBossReleaseSignal).w
                beq.s   S3Water_SelectHCZ2HeightTable
                rts
; ---------------------------------------------------------------------------

S3Water_SelectHCZ2HeightTable:
                lea     (S3Water_HCZ2HeightByX).l,a1
                bra.s   S3Water_ReadCameraXForHeight
; ---------------------------------------------------------------------------
S3Water_HCZ2HeightByX:
                dc.w    $700, $3E00
                dc.w    $7E0, $FFFF
; ---------------------------------------------------------------------------

DynamicWaterHeight_Null:
                rts
; ---------------------------------------------------------------------------

DynamicWaterHeight_LBZ1:
                lea     (S3Water_LBZ1HeightByX).l,a1
                bra.s   S3Water_ReadCameraXForHeight
; ---------------------------------------------------------------------------
S3Water_LBZ1HeightByX:
                dc.w    $8B00,  $E00
                dc.w    $8A00, $1980
                dc.w    $8A00, $2340
                dc.w    $8AC8, $2C00
                dc.w    $8FF0, $FFFF
; ---------------------------------------------------------------------------

DynamicWaterHeight_Null2:
                rts
; ---------------------------------------------------------------------------

DynamicWaterHeight_Ending:
                cmpi.w  #$1DE0,(Camera_X_pos).w
                blo.s   S3Water_EndingHeightReturn
                move.w  #$510,(Target_water_level).w

S3Water_EndingHeightReturn:
                rts
; ---------------------------------------------------------------------------

S3Water_ReadCameraXForHeight:
                move.w  (Camera_X_pos).w,d0

; Use the first record whose unsigned upper X bound includes the camera. Bit 15 of the height sets it immediately
S3Water_FindHeightAtCameraX:
                move.l  (a1)+,d1
                cmp.w   d1,d0
                bhi.s   S3Water_FindHeightAtCameraX
                swap    d1
                tst.w   d1
                bpl.s   S3Water_StoreTargetHeight
                andi.w  #$7FFF,d1
                move.w  d1,(Mean_water_level).w

S3Water_StoreTargetHeight:
                move.w  d1,(Target_water_level).w
                rts
