; Owner: objects/bonus/slots/sk
; Responsibility: Rotating slot bonus spike initialization, player collision and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SlotSpike:
                moveq   #0,d1
                move.w  $3C(a0),d1
                swap    d1
                move.l  $34(a0),d0
                sub.l   d1,d0
                asr.l   #4,d0
                sub.l   d0,$34(a0)
                move.w  $34(a0),x_pos(a0)
                moveq   #0,d1
                move.w  $3E(a0),d1
                swap    d1
                move.l  $38(a0),d0
                sub.l   d1,d0
                asr.l   #4,d0
                sub.l   d0,$38(a0)
                move.w  $38(a0),y_pos(a0)
                subq.w  #1,$40(a0)
                bne.w   SlotsSpike_DrawLiveSpike
                movea.l $2E(a0),a1
                subq.w  #1,(a1)
                cmpi.w  #5,(SStage_scalar_index_2).w
                blo.s   SlotsSpike_DebitRingIfNonzero
                clr.w   (SStage_scalar_index_2).w
                moveq   #signextendB(sfx_SpikeHit),d0
                jsr     (Play_SFX).l

SlotsSpike_DebitRingIfNonzero:
                tst.w   (Ring_count).w
                beq.s   SlotsSpike_DeleteAfterRingCheck
                subq.w  #1,(Ring_count).w
                ori.b   #$81,(Update_HUD_ring_count).w

SlotsSpike_DeleteAfterRingCheck:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SlotsSpike_DrawLiveSpike:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_SlotSpike:
                include "src/objects/shared/zones/slots/mappings/spike.s"
; End of function Obj_SlotSpike
