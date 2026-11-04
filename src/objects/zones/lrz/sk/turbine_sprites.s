; Owner: objects/zones/lrz/sk
; Responsibility: Turbine sprite movement, coordination, player interaction and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZTurbineSprites:
                move.w  #make_art_tile(ArtTile_LRZ2Drum,1,1),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                tst.b   subtype(a0)
                beq.s   SKLRZTurbine_InitRideable
                move.l  #Map_LRZTurbineSprites2,mappings(a0)
                move.b  #4,width_pixels(a0)
                move.b  #$30,height_pixels(a0)
                move.b  #$A0,collision_flags(a0)
                move.l  #SKLRZTurbine_UpdateContactOnlyTurbine,(a0)
                bra.w   SKLRZTurbine_UpdateContactOnlyTurbine
; ---------------------------------------------------------------------------

SKLRZTurbine_InitRideable:
                move.l  #Map_LRZTurbineSprites,mappings(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$30,height_pixels(a0)
                move.l  #SKLRZTurbine_UpdateRidersAndFrames,(a0)

SKLRZTurbine_UpdateRidersAndFrames:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d1
                bsr.s   UpdatePlayerOnLrzTurbine
                addq.w  #1,a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2_logical).w,d1
                bsr.s   UpdatePlayerOnLrzTurbine
                move.b  (Level_frame_counter+1).w,d0
                lsr.b   #1,d0
                andi.b  #3,d0
                move.b  d0,mapping_frame(a0)
                tst.b   render_flags(a0)
                bpl.s   SKLRZTurbine_DrawRideable
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   SKLRZTurbine_DrawRideable
                moveq   #signextendB(sfx_FanBig),d0
                jsr     (Play_SFX).l

SKLRZTurbine_DrawRideable:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnLrzTurbine:
                tst.b   (a2)
                beq.w   SKLRZTurbine_TickRecaptureDelay
                tst.w   (Debug_placement_mode).w
                bne.w   SKLRZTurbine_DetachRiderInRoll
                cmpi.b  #4,routine(a1)
                bhs.w   SKLRZTurbine_DetachRiderInRoll
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d1
                bne.w   SKLRZTurbine_CalcJumpYSpeed
                bsr.w   PositionPlayerOnLrzTurbinePhase
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------

SKLRZTurbine_DetachRiderInRoll:
                clr.b   (a2)
                move.b  #30,2(a2)
                andi.b  #$FC,object_control(a1)
                move.w  #$100,priority(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,flip_angle(a1)
                rts
; ---------------------------------------------------------------------------
SKLRZTurbine_JumpAngleSectors:
                dc.b    $20, $20, $20, $30, $40, $50, $60, $60, $60, $A0, $A0, $B0, $C0, $D0, $E0, $E0
                even
; ---------------------------------------------------------------------------

SKLRZTurbine_CalcJumpYSpeed:
                moveq   #0,d1
                move.b  4(a2),d0
                move.b  d0,d1
                lsr.w   #4,d1
                move.b  SKLRZTurbine_JumpAngleSectors(pc,d1.w),d1
                andi.b  #$F,d0
                or.b    d1,d0
                jsr     (GetSineCosine).l
                muls.w  #$C,d0
                neg.w   d0
                move.w  d0,y_vel(a1)
                move.w  #0,anim(a1)                     ; and prev_anim
                tst.w   d0
                bpl.s   SKLRZTurbine_ReleaseJumpingRider
                move.w  #$10<<8,anim(a1)                ; and prev_anim
                ori.w   #high_priority,art_tile(a1)

SKLRZTurbine_ReleaseJumpingRider:
                clr.b   (a2)
                move.b  #20,2(a2)
                andi.b  #$FC,object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                move.b  #2,routine(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,flip_angle(a1)
                rts
; ---------------------------------------------------------------------------

SKLRZTurbine_TickRecaptureDelay:
                tst.b   2(a2)
                beq.s   SKLRZTurbine_CheckRangeAndSelectBand
                subq.b  #1,2(a2)
                bne.s   SKLRZTurbine_RecaptureDelayReturn
                move.w  #$100,priority(a1)

SKLRZTurbine_RecaptureDelayReturn:
                rts
; ---------------------------------------------------------------------------

SKLRZTurbine_CheckRangeAndSelectBand:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   SKLRZTurbine_CaptureReturn
                moveq   #$70,d1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$50,d0
                cmpi.w  #$18,d0
                blo.w   SKLRZTurbine_CheckRiderEligibility
                moveq   #$30,d1
                addi.w  #-$40,d0
                cmpi.w  #$18,d0
                blo.w   SKLRZTurbine_CheckRiderEligibility
                subi.w  #$40,d0
                cmpi.w  #$18,d0
                bhs.w   SKLRZTurbine_CaptureReturn
                moveq   #-$10,d1

; Only the middle band requires the player's high-priority art bit
SKLRZTurbine_CheckRiderEligibility:
                tst.w   (Debug_placement_mode).w
                bne.w   SKLRZTurbine_CaptureReturn
                cmpi.b  #4,routine(a1)
                bhs.w   SKLRZTurbine_CaptureReturn
                tst.b   object_control(a1)
                bne.w   SKLRZTurbine_CaptureReturn
                cmpi.b  #$30,d1
                bne.s   SKLRZTurbine_CaptureAndSeedPhase
                tst.w   art_tile(a1)
                bpl.w   SKLRZTurbine_CaptureReturn

SKLRZTurbine_CaptureAndSeedPhase:
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                andi.b  #$FC,render_flags(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                subi.b  #4,d0
                add.b   d0,d0
                add.b   d0,d0
                add.b   d0,d1
                move.b  d1,4(a2)
                move.b  #0,anim(a1)
                move.b  #3,object_control(a1)
                move.b  #1,(a2)
                bsr.w   PositionPlayerOnLrzTurbinePhase
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2

SKLRZTurbine_CaptureReturn:
                rts
; End of function UpdatePlayerOnLrzTurbine

; =============== S U B R O U T I N E =======================================

PositionPlayerOnLrzTurbinePhase:
                moveq   #0,d0
                move.b  4(a2),d0
                lsr.b   #3,d0
                move.b  SKLRZTurbine_RiderFrames(pc,d0.w),d1
                move.b  d1,mapping_frame(a1)
                andi.w  #$1F,d0
                move.b  SKLRZTurbine_RiderYOffsets(pc,d0.w),d1
                ext.w   d1
                add.w   y_pos(a0),d1
                move.w  d1,y_pos(a1)
                move.w  #$100,priority(a1)
                ori.w   #high_priority,art_tile(a1)
                move.b  4(a2),d0
                bpl.s   SKLRZTurbine_StepRiderPhase
                move.w  #$280,priority(a1)
                andi.w  #drawing_mask,art_tile(a1)

SKLRZTurbine_StepRiderPhase:
                addq.b  #4,d0
                move.b  d0,4(a2)
                rts
; End of function PositionPlayerOnLrzTurbinePhase

; ---------------------------------------------------------------------------
SKLRZTurbine_RiderFrames:
                dc.b    $95, $95, $63, $63, $64, $64, $64, $64, $64, $65, $65, $65, $65, $66, $66, $66, $66, $66, $66, $66
                dc.b    $67, $67, $67, $67, $68, $68, $68, $68, $95, $95, $95, $95
SKLRZTurbine_RiderYOffsets:
                dc.b    $43, $40, $38, $32, $24, $1E, $17, $12,  $E,-$16,-$1C,-$24,-$29,-$32,-$3A,-$40,-$43,-$40,-$3A,-$32
                dc.b    -$29,-$24,-$1C,-$10,   0, $10, $17, $1E, $24, $32, $38, $40
                even
; ---------------------------------------------------------------------------

SKLRZTurbine_UpdateContactOnlyTurbine:
                move.b  (Level_frame_counter+1).w,d0
                lsr.b   #1,d0
                andi.b  #3,d0
                move.b  d0,mapping_frame(a0)
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------
Map_LRZTurbineSprites:
                include "src/objects/shared/zones/lrz/mappings/turbine.s"
; End of function SKLRZTurbine_UpdateContactOnlyTurbine
