; Owner: objects/competition/sk
; Responsibility: Competition time display, live mapping construction, item icons and position widgets
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

SKRaceHUD_InitP1TimeWidget:
                move.l  #Map_2PTime_P1_RAM,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PTime,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$C8,x_pos(a0)
                move.w  #$90,y_pos(a0)
                bset    #3,render_flags(a0)
                lea     (Map_2PTime).l,a1
                lea     (Map_2PTime_P1_RAM).l,a2
                move.w  #bytesToWcnt(Map_2PTime_end-Map_2PTime),d0

SKRaceHUD_CopyP1TimeMap:
                move.w  (a1)+,(a2)+
                dbf     d0,SKRaceHUD_CopyP1TimeMap
                move.l  #SKRaceHUD_BindP1TimeUpdateFields,(a0)

SKRaceHUD_BindP1TimeUpdateFields:
                lea     (Score).w,a1
                lea     (Map_2PTime_P1_RAM+$A).l,a2
                lea     (Timer_minute).w,a3
                moveq   #0,d1
                move.b  (Competition_lap_count).w,d1
                lea     (Update_HUD_timer).w,a4
                lea     (Competition_time_record).w,a5
                lea     ((RAM_start+$7828)&$FFFFFF).l,a6
                bra.s   SKRaceHUD_GateTimeTickAndApplyCap
; ---------------------------------------------------------------------------

SKRaceHUD_SkipP2TimeWidgetInGhostMode:
                tst.b   (Not_ghost_flag).w
                bne.s   SKRaceHUD_InitP2TimeWidget
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKRaceHUD_InitP2TimeWidget:
                move.l  #Map_2PTime_P2_RAM,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PTime,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$C8,x_pos(a0)
                move.w  #$90,y_pos(a0)
                bset    #4,render_flags(a0)
                lea     (Map_2PTime).l,a1
                lea     (Map_2PTime_P2_RAM).l,a2
                move.w  #bytesToWcnt(Map_2PTime_end-Map_2PTime),d0

SKRaceHUD_CopyP2TimeMap:
                move.w  (a1)+,(a2)+
                dbf     d0,SKRaceHUD_CopyP2TimeMap
                move.l  #SKRaceHUD_BindP2TimeUpdateFields,(a0)

SKRaceHUD_BindP2TimeUpdateFields:
                lea     (Score_P2).w,a1
                lea     (Map_2PTime_P2_RAM+$A).l,a2
                lea     (Timer_minute_P2).w,a3
                moveq   #0,d1
                move.b  (Competition_lap_count_2P).w,d1
                lea     (Update_HUD_timer_P2).w,a4
                lea     (Competition_time_record_P2).w,a5
                lea     ((RAM_start+$7840)&$FFFFFF).l,a6

SKRaceHUD_GateTimeTickAndApplyCap:
                tst.b   (a4)
                beq.s   SKRaceHUD_ConvertLapAndUpdateRecord
                bmi.s   SKRaceHUD_ConvertLapAndUpdateRecord
                cmpi.l  #(9<<16)|(59<<8)|99,(a5)
                blo.s   SKRaceHUD_TickTimerWith60FrameCarry
                move.b  #$80,(a4)
                move.l  #(9<<16)|(59<<8)|99,(a5)
                bra.s   SKRaceHUD_WriteMinutesAndPrepSeconds
; ---------------------------------------------------------------------------

SKRaceHUD_TickTimerWith60FrameCarry:
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   SKRaceHUD_ConvertLapAndUpdateRecord
                move.b  #0,(a1)
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   SKRaceHUD_ConvertLapAndUpdateRecord
                move.b  #0,(a1)
                addq.b  #1,-(a1)

SKRaceHUD_ConvertLapAndUpdateRecord:
                move.l  -1(a3),d6
                jsr     (SKCompConvertTimerFrameByteToHundredths).l
                cmpi.w  #5,d1
                bhs.s   SKRaceHUD_WriteMinutesAndPrepSeconds
                lsl.w   #2,d1
                move.l  d6,(a6,d1.w)
                move.l  $14(a6),d5
                jsr     SKCompGoal_AddPackedTimes(pc)
                move.l  d6,(a5)

SKRaceHUD_WriteMinutesAndPrepSeconds:
                addq.w  #1,a5
                lea     SKRaceHUD_DigitPieceTemplates(pc),a1
                moveq   #0,d0
                move.b  (a5)+,d0
                lsl.w   #2,d0
                move.l  (a1,d0.w),(a2)+
                addq.w  #8,a2
                moveq   #0,d0
                move.b  (a5)+,d0
                moveq   #0,d2

SKRaceHUD_CountSecondsTens:
                subi.w  #$A,d0
                bcs.s   SKRaceHUD_WriteSecondsAndPrepFraction
                addq.w  #4,d2
                bra.s   SKRaceHUD_CountSecondsTens
; ---------------------------------------------------------------------------

SKRaceHUD_WriteSecondsAndPrepFraction:
                addi.w  #$A,d0
                move.l  (a1,d2.w),(a2)+
                addq.w  #2,a2
                lsl.w   #2,d0
                move.l  (a1,d0.w),(a2)+
                addq.w  #8,a2
                moveq   #0,d0
                move.b  (a5)+,d0
                moveq   #0,d2

SKRaceHUD_CountHundredthsTens:
                subi.w  #$A,d0
                bcs.s   SKRaceHUD_WriteHundredthsAndDraw
                addq.w  #4,d2
                bra.s   SKRaceHUD_CountHundredthsTens
; ---------------------------------------------------------------------------

SKRaceHUD_WriteHundredthsAndDraw:
                addi.w  #$A,d0
                move.l  (a1,d2.w),(a2)+
                addq.w  #2,a2
                lsl.w   #2,d0
                move.l  (a1,d0.w),(a2)+
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
SKRaceHUD_DigitPieceTemplates:
                dc.w    $F805,     8
                dc.w    $F801,    $C
                dc.w    $F805,    $E
                dc.w    $F805,   $12
                dc.w    $F805,   $16
                dc.w    $F805,   $1A
                dc.w    $F805,   $1E
                dc.w    $F805,   $22
                dc.w    $F805,   $26
                dc.w    $F805,   $2A
SKRaceHUD_FrameToHundredthsTable:
                dc.b    0,   1,   3,   5,   6,   8,  $A,  $B,  $D,  $F, $10, $12, $14, $15, $17, $19, $1A, $1C, $1E, $1F
                dc.b    $21, $23, $24, $26, $28, $29, $2B, $2D, $2E, $30, $32, $33, $35, $37, $38, $3A, $3C, $3D, $3F, $41
                dc.b    $42, $44, $46, $47, $49, $4B, $4C, $4E, $50, $51, $53, $55, $56, $58, $5A, $5B, $5D, $5F, $60, $62
Map_2PTime:
                dc.w    SKRaceHUD_MutableTimeMapTemplate-Map_2PTime
SKRaceHUD_MutableTimeMapTemplate:   dc.w    8
                dc.b    $F8,  $D,   0,   0, $FF, $C0
                dc.b    $F8,   5,   0,   8, $FF, $E8
                dc.b    $F0,   0,   0, $2E, $FF, $F4
                dc.b    $F8,   5,   0,   8, $FF, $FC
                dc.b    $F8,   5,   0,   8,   0,   8
                dc.b    $F0,   0,   0, $2F,   0, $14
                dc.b    $F8,   5,   0,   8,   0, $1C
                dc.b    $F8,   5,   0,   8,   0, $28
Map_2PTime_end:
; End of function SKRaceHUD_InitP1TimeWidget
; ---------------------------------------------------------------------------

SKRaceHUD_InitItemWidget:
                move.l  #Map_2PItemIcon,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PLapNum+$50,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$E0,y_pos(a0)
                tst.b   subtype(a0)
                beq.s   SKRaceHUD_InstallP1ItemWidget
                tst.b   (Not_ghost_flag).w
                bne.s   SKRaceHUD_InstallP2ItemWidget
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKRaceHUD_InstallP2ItemWidget:
                bset    #4,render_flags(a0)
                move.l  #SKRaceHUD_SelectP2RingItemFrame,(a0)
                bra.s   SKRaceHUD_SelectP2RingItemFrame
; ---------------------------------------------------------------------------

SKRaceHUD_InstallP1ItemWidget:
                bset    #3,render_flags(a0)
                move.l  #SKRaceHUD_SelectP1RingItemFrame,(a0)

SKRaceHUD_SelectP1RingItemFrame:
                moveq   #0,d0
                tst.w   (Ring_count).w
                beq.s   SKRaceHUD_OverrideP1SpeedItemFrame
                moveq   #3,d0

SKRaceHUD_OverrideP1SpeedItemFrame:
                btst    #Status_SpeedShoes,(Player_1+status_secondary).w
                beq.s   SKRaceHUD_StoreP1ItemFrameAndDraw
                moveq   #1,d0
                cmpi.w  #$C00,(Max_speed).w
                beq.s   SKRaceHUD_StoreP1ItemFrameAndDraw
                moveq   #2,d0

SKRaceHUD_StoreP1ItemFrameAndDraw:
                move.b  d0,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKRaceHUD_SelectP2RingItemFrame:
                moveq   #0,d0
                tst.w   (Ring_count_P2).w
                beq.s   SKRaceHUD_OverrideP2SpeedItemFrame
                moveq   #3,d0

SKRaceHUD_OverrideP2SpeedItemFrame:
                btst    #2,(Player_2+status_secondary).w
                beq.s   SKRaceHUD_StoreP2ItemFrameAndDraw
                moveq   #1,d0
                cmpi.w  #$C00,(Max_speed_P2).w
                beq.s   SKRaceHUD_StoreP2ItemFrameAndDraw
                moveq   #2,d0

SKRaceHUD_StoreP2ItemFrameAndDraw:
                move.b  d0,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; End of function SKRaceHUD_InitItemWidget
; ---------------------------------------------------------------------------
Map_2PItemIcon:
                include "src/game/competition/shared/mappings/item_icon.s"
; ---------------------------------------------------------------------------
; unused
                move.l  #Map_2PPosition,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PPosIcon,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #4,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                tst.b   subtype(a0)
                beq.s   SKRaceHUD_InitP1PositionWidget
                tst.b   (Not_ghost_flag).w
                bne.s   SKRaceHUD_InitP2PositionWidget
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKRaceHUD_InitP2PositionWidget:
                move.w  #$90,x_pos(a0)
                move.w  #$84,y_pos(a0)
                move.w  (Player_2+x_pos).w,$30(a0)
                bset    #4,render_flags(a0)
                move.b  #2,mapping_frame(a0)
                move.l  #SKRaceHUD_ReadP2PositionAndAnchor,(a0)
                bra.s   SKRaceHUD_ReadP2PositionAndAnchor
; ---------------------------------------------------------------------------

SKRaceHUD_InitP1PositionWidget:
                move.w  #$90,x_pos(a0)
                move.w  #$E8,y_pos(a0)
                move.w  (Player_1+x_pos).w,$30(a0)
                bset    #3,render_flags(a0)
                move.b  #1,mapping_frame(a0)
                move.l  #SKRaceHUD_ReadP1PositionAndAnchor,(a0)

SKRaceHUD_ReadP1PositionAndAnchor:
                move.w  (Player_1+x_pos).w,d0
                move.w  (Saved_X_pos).w,d1

SKRaceHUD_ResetPositionAccumulator:
                tst.w   (Events_bg+$14).w
                beq.s   SKRaceHUD_ComputeWrappedPositionDelta
                move.w  #0,$34(a0)
                move.w  d1,$30(a0)

SKRaceHUD_ComputeWrappedPositionDelta:
                move.w  d0,d1
                sub.w   $30(a0),d0
                beq.s   SKRaceHUD_ProjectRaceDistanceAndDraw
                bcc.s   SKRaceHUD_FoldPositiveHalfWrap
                cmpi.w  #-$200,d0
                bge.s   SKRaceHUD_AccumulateDeltaAndStoreX
                addi.w  #$400,d0
                bra.s   SKRaceHUD_AccumulateDeltaAndStoreX
; ---------------------------------------------------------------------------

SKRaceHUD_FoldPositiveHalfWrap:
                cmpi.w  #$200,d0
                blt.s   SKRaceHUD_AccumulateDeltaAndStoreX
                subi.w  #$400,d0

SKRaceHUD_AccumulateDeltaAndStoreX:
                add.w   d0,$34(a0)
                move.w  d1,$30(a0)

SKRaceHUD_ProjectRaceDistanceAndDraw:
                move.w  $34(a0),d0
                asr.w   #6,d0
                addi.w  #$90,d0
                move.w  d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKRaceHUD_ReadP2PositionAndAnchor:
                move.w  (Player_2+x_pos).w,d0
                move.w  (Saved2_X_pos).w,d1
                bra.s   SKRaceHUD_ResetPositionAccumulator
; ---------------------------------------------------------------------------
Map_2PPosition:
                include "src/game/competition/shared/mappings/position_icons_unused.s"
; End of function SKRaceHUD_InitP2PositionWidget
