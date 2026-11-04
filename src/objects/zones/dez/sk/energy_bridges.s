; Owner: objects/zones/dez/sk
; Responsibility: Straight and curved energy bridge activation, segment state and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_DEZEnergyBridge:
                move.l  #Map_DEZEnergyBridge,mappings(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                bset    #7,status(a0)
                bsr.s   InitializeDezEnergyBridgeTiming
                sub.w   d1,d0
                bcc.s   SKDEZEnergyBridge_InitStraightWait
                neg.w   d0
                move.w  d0,$34(a0)
                move.l  #SKDEZEnergyBridge_TickStraightAndDetach,(a0)
                bra.s   SKDEZEnergyBridge_TickStraightAndDetach
; ---------------------------------------------------------------------------

SKDEZEnergyBridge_InitStraightWait:
                move.l  #SKDEZEnergyBridge_WaitStraightPhaseZero,(a0)

SKDEZEnergyBridge_WaitStraightPhaseZero:
                move.w  (Level_frame_counter).w,d0
                add.w   $30(a0),d0
                and.w   $32(a0),d0
                beq.s   SKDEZEnergyBridge_ActivateStraightBridge
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

SKDEZEnergyBridge_ActivateStraightBridge:
                move.b  subtype(a0),d0
                andi.b  #3,d0
                addq.b  #2,d0
                lsl.w   #5,d0
                move.w  d0,$34(a0)
                move.l  #SKDEZEnergyBridge_TickStraightAndDetach,(a0)

SKDEZEnergyBridge_TickStraightAndDetach:
                subq.w  #1,$34(a0)
                bne.s   SKDEZEnergyBridge_CheckStraightTopSolid
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   DetachPlayerFromExpiredDezEnergyBridge
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.s   DetachPlayerFromExpiredDezEnergyBridge
                move.l  #SKDEZEnergyBridge_WaitStraightPhaseZero,(a0)
                bra.s   SKDEZEnergyBridge_AnimateStraightAndZap
; ---------------------------------------------------------------------------

SKDEZEnergyBridge_CheckStraightTopSolid:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                move.w  #9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l

SKDEZEnergyBridge_AnimateStraightAndZap:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #3,d0
                move.b  d0,mapping_frame(a0)
                tst.b   render_flags(a0)
                bpl.s   SKDEZEnergyBridge_DrawStraightBridge
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   SKDEZEnergyBridge_DrawStraightBridge
                moveq   #signextendB(sfx_EnergyZap),d0
                jsr     (Play_SFX).l

SKDEZEnergyBridge_DrawStraightBridge:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

DetachPlayerFromExpiredDezEnergyBridge:
                bclr    d6,status(a0)
                beq.s   SKDEZEnergyBridge_DetachReturn
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)

SKDEZEnergyBridge_DetachReturn:
                rts
; End of function DetachPlayerFromExpiredDezEnergyBridge

; ---------------------------------------------------------------------------

Obj_DEZEnergyBridgeCurved:
                move.l  #Map_DEZEnergyBridgeCurved,mappings(a0)
                move.b  #$50,width_pixels(a0)
                move.b  #$30,height_pixels(a0)
                bsr.w   InitializeDezEnergyBridgeTiming
                sub.w   d1,d0
                bcc.s   SKDEZEnergyBridge_InitCurvedWait
                neg.w   d0
                move.w  d0,$34(a0)
                move.l  #SKDEZEnergyBridge_TickCurvedLifetime,(a0)
                bra.s   SKDEZEnergyBridge_TickCurvedLifetime
; ---------------------------------------------------------------------------

SKDEZEnergyBridge_InitCurvedWait:
                move.l  #SKDEZEnergyBridge_WaitCurvedPhaseZero,(a0)

SKDEZEnergyBridge_WaitCurvedPhaseZero:
                move.w  (Level_frame_counter).w,d0
                add.w   $30(a0),d0
                and.w   $32(a0),d0
                beq.s   SKDEZEnergyBridge_ActivateCurvedBridge
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

SKDEZEnergyBridge_ActivateCurvedBridge:
                move.b  subtype(a0),d0
                andi.b  #3,d0
                addq.b  #2,d0
                lsl.w   #5,d0
                move.w  d0,$34(a0)
                move.l  #SKDEZEnergyBridge_TickCurvedLifetime,(a0)

SKDEZEnergyBridge_TickCurvedLifetime:
                subq.w  #1,$34(a0)
                bne.s   SKDEZEnergyBridge_UpdateCurvedLayers
                move.l  #SKDEZEnergyBridge_WaitCurvedPhaseZero,(a0)

SKDEZEnergyBridge_UpdateCurvedLayers:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   DEZCurvedBridge_UpdatePlayerLayer
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.s   DEZCurvedBridge_UpdatePlayerLayer
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #3,d0
                move.b  d0,mapping_frame(a0)
                tst.b   render_flags(a0)
                bpl.s   SKDEZEnergyBridge_DrawCurvedBridge
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   SKDEZEnergyBridge_DrawCurvedBridge
                moveq   #signextendB(sfx_EnergyZap),d0
                jsr     (Play_SFX).l

SKDEZEnergyBridge_DrawCurvedBridge:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

DEZCurvedBridge_UpdatePlayerLayer:
                tst.w   $34(a0)
                beq.s   SKDEZEnergyBridge_TryReleaseCurvedRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$50,d0
                cmpi.w  #$A0,d0
                bhs.s   SKDEZEnergyBridge_TryReleaseCurvedRider
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$30,d0
                cmpi.w  #$60,d0
                bhs.s   SKDEZEnergyBridge_TryReleaseCurvedRider
                bset    d6,status(a0)
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)
                rts
; ---------------------------------------------------------------------------

SKDEZEnergyBridge_TryReleaseCurvedRider:
                bclr    d6,status(a0)
                beq.s   SKDEZEnergyBridge_LayerUpdateReturn
                tst.w   $34(a0)
                bne.s   SKDEZEnergyBridge_RestoreDefaultLayers
                bset    #Status_InAir,status(a1)

SKDEZEnergyBridge_RestoreDefaultLayers:
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)

SKDEZEnergyBridge_LayerUpdateReturn:
                rts
; End of function DEZCurvedBridge_UpdatePlayerLayer

; ---------------------------------------------------------------------------
Map_DEZEnergyBridge:
                include "src/objects/shared/zones/dez/mappings/energy_bridge.s"
Map_DEZEnergyBridgeCurved:
                include "src/objects/shared/zones/dez/mappings/energy_bridge_curved.s"
