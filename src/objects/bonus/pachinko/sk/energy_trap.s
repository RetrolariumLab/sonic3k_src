; Owner: objects/bonus/pachinko/sk
; Responsibility: Pachinko energy trap capture, player response and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_PachinkoEnergyTrap:
                movea.l a0,a1
                moveq   #2-1,d1
                bra.s   PachinkoTrap_SetActorAndFinishPair
; ---------------------------------------------------------------------------

PachinkoTrap_TrySpawnOffsetCompanion:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   PachinkoTrap_InitHoldAndRiseDelays
                move.l  #PachinkoTrap_CompanionFollowParentY,(a1)
                move.w  x_pos(a0),x_pos(a1)
                addi.w  #$190,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                bset    #0,render_flags(a1)
                move.w  a0,$3E(a1)

PachinkoTrap_SetActorAndFinishPair:
                move.l  #Map_PachinkoEnergyTrap,mappings(a1)
                move.w  #make_art_tile(ArtTile_PachinkoMain+$85,1,1),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.b  #8,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.w  #0,priority(a1)

PachinkoTrap_InitHoldAndRiseDelays:
                dbf     d1,PachinkoTrap_TrySpawnOffsetCompanion
                move.b  #60,$24(a0)
                move.b  #4*60,$25(a0)
                move.l  #PachinkoTrap_TryPeriodicWave,(a0)

PachinkoTrap_TryPeriodicWave:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   PachinkoTrap_TickAngleAndCheckRise
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   PachinkoTrap_TickAngleAndCheckRise
                move.l  #Obj_PachinkoInvisibleUnknown,(a1)
                move.w  x_pos(a0),x_pos(a1)
                addi.w  #$80,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  angle(a0),angle(a1)
                move.w  a0,$3E(a1)

PachinkoTrap_TickAngleAndCheckRise:
                addi.b  #8,angle(a0)
                tst.b   subtype(a0)
                bne.s   PachinkoTrap_WarnForP1AboveBand
                tst.b   $25(a0)
                beq.s   PachinkoTrap_RiseAfterDelay
                subq.b  #1,$25(a0)
                bra.s   PachinkoTrap_WarnForP1AboveBand
; ---------------------------------------------------------------------------

PachinkoTrap_RiseAfterDelay:
                subq.w  #1,y_pos(a0)

PachinkoTrap_WarnForP1AboveBand:
                lea     (Player_1).w,a1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$180,d0
                cmpi.w  #$180,d0
                bhs.s   PachinkoTrap_ProcessBothPlayersAndDraw
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$3F,d0
                bne.s   PachinkoTrap_ProcessBothPlayersAndDraw
                moveq   #signextendB(sfx_Transporter),d0
                jsr     (Play_SFX).l

PachinkoTrap_ProcessBothPlayersAndDraw:
                bsr.s   PachinkoTrap_HoldAndReturnPlayer
                lea     (Player_2).w,a1
                bsr.s   PachinkoTrap_HoldAndReturnPlayer
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Hold players at the barrier. Player 1 can restore the main level after the countdown or immediately above the top boundary
PachinkoTrap_HoldAndReturnPlayer:
                move.w  y_pos(a1),d0
                cmpi.w  #-$20,d0
                bge.s   PachinkoTrap_CheckCaptureAndSnapY
                cmpa.w  #Player_1,a1
                bne.s   PachinkoTrap_LockPlayerAndTickP1Return
                move.b  #0,$24(a0)
                bra.s   PachinkoTrap_LockPlayerAndTickP1Return
; ---------------------------------------------------------------------------

PachinkoTrap_CheckCaptureAndSnapY:
                sub.w   y_pos(a0),d0
                addi.w  #$C,d0
                cmpi.w  #$18,d0
                bhs.s   PachinkoTrap_CaptureUpdateReturn
                tst.w   (Debug_placement_mode).w
                bne.s   PachinkoTrap_CaptureUpdateReturn
                move.w  y_pos(a0),y_pos(a1)
                tst.b   $2E(a1)
                bne.s   PachinkoTrap_LockPlayerAndTickP1Return
                moveq   #signextendB(sfx_Bouncy),d0
                jsr     (Play_SFX).l

PachinkoTrap_LockPlayerAndTickP1Return:
                move.b  #$81,object_control(a1)
                bset    #Status_InAir,status(a1)
                cmpa.w  #Player_1,a1
                bne.s   PachinkoTrap_CaptureUpdateReturn
                move.b  #1,subtype(a0)
                subq.b  #1,$24(a0)
                bcc.s   PachinkoTrap_CaptureUpdateReturn
                move.w  (Saved_zone_and_act).w,(Current_zone_and_act).w
                move.w  (Saved_apparent_zone_and_act).w,(Apparent_zone_and_act).w
                move.b  (Saved_last_star_post_hit).w,(Last_star_post_hit).w
                move.b  #0,(Special_bonus_entry_flag).w
                move.b  #1,(Restart_level_flag).w
                move.w  (Ring_count).w,(Saved_ring_count).w
                move.b  (Extra_life_flags).w,(Saved_extra_life_flags).w
                move.b  (Player_1+status_secondary).w,d0
                andi.b  #$71,d0
                move.b  d0,(Saved_status_secondary).w

PachinkoTrap_CaptureUpdateReturn:
                rts
; End of function PachinkoTrap_HoldAndReturnPlayer

; ---------------------------------------------------------------------------

PachinkoTrap_CompanionFollowParentY:
                movea.w $3E(a0),a1
                move.w  y_pos(a1),y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_PachinkoEnergyTrap:
                include "src/objects/shared/zones/pachinko/mappings/energy_trap.s"
