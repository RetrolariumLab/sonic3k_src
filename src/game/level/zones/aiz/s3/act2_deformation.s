; Owner: game/level/zones/aiz/s3
; Responsibility: Angel Island act-two plane deformation and art or background transfer helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

AIZ2_Deform:
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  (Screen_shake_offset).w,d1
                sub.w   d1,d0
                asr.w   #1,d0
                add.w   d1,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                cmpi.w  #$10,(Events_routine_bg).w
                bcs.s   S3AIZ2Deform_InitBgOffsetsFromEventX
                move.w  (Events_bg+$16).w,d0
                add.w   d0,(Camera_Y_pos_BG_copy).w

S3AIZ2Deform_InitBgOffsetsFromEventX:
                move.w  (Events_fg_1).w,d0
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d1
                asr.l   #5,d1
                move.l  d1,d2
                add.l   d1,d1
                add.l   d2,d1
                lea     (HScroll_table+$1C0).w,a1
                lea     AIZ2_BGDeformMake(pc),a5
                moveq   #0,d2

S3AIZ2Deform_ReadBgOffsetGroup:
                move.b  (a5)+,d3
                bmi.s   S3AIZ2Deform_BgOffsetReturn
                ext.w   d3
                swap    d0

S3AIZ2Deform_ScatterBgOffset:
                move.b  (a5)+,d2
                move.w  d0,(a1,d2.w)
                dbf     d3,S3AIZ2Deform_ScatterBgOffset
                swap    d0
                add.l   d1,d0
                bra.s   S3AIZ2Deform_ReadBgOffsetGroup
; ---------------------------------------------------------------------------

S3AIZ2Deform_BgOffsetReturn:
                rts
; End of function AIZ2_Deform

; =============== S U B R O U T I N E =======================================

AIZ2_ApplyDeform:
                lea     (HScroll_table).w,a1
                lea     AIZ2_FGDeformDelta(pc),a6
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  #$DF,d1
                move.w  (Level_frame_counter).w,d2
                add.w   d0,d2
                add.w   d0,d2
                moveq   #$3E,d3
                move.w  (Camera_X_pos_copy).w,d6
                neg.w   d6
                move.w  (Water_level).w,d4
                sub.w   d0,d4
                bls.s   S3AIZ2Deform_PickFgWaterWave    ; If completely underwater, only do water deformation
                cmp.w   d1,d4
                bhi.s   S3AIZ2Deform_ApplyFgWaveAndSetUpBg  ; If water isn't showing at all, only do non-water deformation
                move.w  d4,d1                           ; Otherwise, just do both
                subq.w  #1,d1
                and.w   d3,d2
                adda.w  d2,a6
                jsr     MakeFGDeformArray(pc)
                move.w  (Water_level).w,d0
                subi.w  #$DE,d1
                neg.w   d1
                move.w  (Level_frame_counter).w,d2
                add.w   d0,d2
                add.w   d0,d2

S3AIZ2Deform_PickFgWaterWave:
                lea     AIZ1_WaterFGDeformDelta(pc),a6
                moveq   #$7E,d3

S3AIZ2Deform_ApplyFgWaveAndSetUpBg:
                and.w   d3,d2
                adda.w  d2,a6
                jsr     MakeFGDeformArray(pc)
                lea     (H_scroll_buffer).w,a1
                lea     (HScroll_table).w,a2
                lea     AIZ2_BGDeformArray(pc),a4
                lea     (HScroll_table+$1C0).w,a5
                lea     AIZ2_ALZ_BGDeformDelta(pc),a6
                move.w  (Camera_Y_pos_BG_copy).w,d0
                move.w  #$DF,d1
                move.w  (Level_frame_counter).w,d2
                asr.w   #1,d2
                add.w   d0,d2
                add.w   d0,d2
                moveq   #$3E,d3
                move.w  (Water_level).w,d4
                sub.w   (Camera_Y_pos_copy).w,d4
                bls.s   S3AIZ2Deform_PickBgWaterWave    ; Same as above, if completely underwater only apply water deformation
                cmp.w   d1,d4
                bhi.s   S3AIZ2Deform_ApplyBgWaveAndCheckShip  ; Same as above, if no water is showing, only do above-ground deformation
                move.w  d4,d1                           ; Otherwise, just do both
                subq.w  #1,d1
                and.w   d3,d2
                adda.w  d2,a6
                jsr     ApplyFGandBGDeformation(pc)
                lea     AIZ2_BGDeformArray(pc),a4
                lea     (HScroll_table+$1C0).w,a5
                move.w  (Water_level).w,d0
                sub.w   (Camera_Y_pos_copy).w,d0
                add.w   (Camera_Y_pos_BG_copy).w,d0
                subi.w  #$DE,d1
                neg.w   d1
                move.w  (Level_frame_counter).w,d2
                asr.w   #1,d2
                add.w   d0,d2
                add.w   d0,d2

S3AIZ2Deform_PickBgWaterWave:
                lea     AIZ1_WaterBGDeformDelta(pc),a6
                moveq   #$7E,d3

S3AIZ2Deform_ApplyBgWaveAndCheckShip:
                and.w   d3,d2
                adda.w  d2,a6
                jsr     ApplyFGandBGDeformation(pc)
                tst.w   (Events_bg+$04).w
                beq.s   S3AIZ2Deform_WaveAndShipReturn
                lea     (H_scroll_buffer).w,a1          ; This is for what I assume to be the flying battleship sequence
                move.w  (_unkEE98).w,d0                 ; Nullifies the top 8 tiles worth of FG waviness for this effect
                neg.w   d0                              ; And replaces it with position data from the second BG camera
                moveq   #bytesToLcnt($40),d1

S3AIZ2Deform_WriteShipFgScroll:
                move.w  d0,(a1)
                addq.w  #4,a1
                move.w  d0,(a1)
                addq.w  #4,a1
                move.w  d0,(a1)
                addq.w  #4,a1
                move.w  d0,(a1)
                addq.w  #4,a1
                dbf     d1,S3AIZ2Deform_WriteShipFgScroll

S3AIZ2Deform_WaveAndShipReturn:
                rts
; End of function AIZ2_ApplyDeform

; ---------------------------------------------------------------------------

AIZ2_DoShipLoop:
                clr.w   (Level_repeat_offset).w
                move.w  (Camera_X_pos).w,d0
                addq.w  #4,d0
                cmp.w   (Events_bg+$02).w,d0
                blo.s   S3AIZ2Deform_CommitShipCameraAndMinX
                move.w  #$200,d1                        ; Do loop
                move.w  d1,(Level_repeat_offset).w
                sub.w   d1,(Player_1+x_pos).w
                sub.w   d1,(Player_2+x_pos).w           ; Subtract $200 from X position of Sonic and Tails
                sub.w   d1,d0
                move.w  d0,d1
                andi.w  #$FFF0,d1
                subi.w  #$10,d1
                move.w  d1,(Camera_X_pos_rounded).w
                move.w  d1,(HScroll_table+$1FE).w

S3AIZ2Deform_CommitShipCameraAndMinX:
                move.w  d0,(Camera_X_pos).w
                move.w  d0,(Camera_X_pos_copy).w
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w         ; Set all the camera/start positions
                addi.w  #$18,d0
                cmp.w   (Player_1+x_pos).w,d0
                bls.s   S3AIZ2Deform_ClampShipRunnerMaxX
                move.w  d0,(Player_1+x_pos).w           ; Make sure Sonic stays on-screen
                move.w  #$400,(Player_1+ground_vel).w   ; Set his running velocity to $400 if the left of screen is hit
                bra.s   S3AIZ2Deform_ShipLoopReturn
; ---------------------------------------------------------------------------

S3AIZ2Deform_ClampShipRunnerMaxX:
                addi.w  #$88,d0
                cmp.w   (Player_1+x_pos).w,d0
                bhi.s   S3AIZ2Deform_ShipLoopReturn
                move.w  d0,(Player_1+x_pos).w           ; Make sure Sonic can't go past a certain point to the right

S3AIZ2Deform_ShipLoopReturn:
                rts
