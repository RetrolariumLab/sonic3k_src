; Owner: objects/zones/mgz/sk
; Responsibility: Marble Garden swinging spike-ball motion, chain sprites and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_MGZSwingingSpikeBall:
                move.l  #Map_MGZSwingingSpikeBall,mappings(a0)
                move.w  #make_art_tile(ArtTile_MGZMisc1,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  #$200,priority(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                move.b  #3,mapping_frame(a0)
                move.b  #$8F,collision_flags(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKMGZSpikeBall_PickSwingMode
                move.l  #SKMGZSpikeBall_CullOrDrawChain,(a1)
                move.l  #Map_MGZSwingingSpikeBall,mappings(a1)
                move.w  #make_art_tile(ArtTile_MGZMisc1,1,0),art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.b  #$50,width_pixels(a1)
                move.b  #$50,height_pixels(a1)
                move.w  #$280,priority(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                bset    #6,render_flags(a1)
                move.w  #4,mainspr_childsprites(a1)
                lea     sub2_x_pos(a1),a2
                move.w  mainspr_childsprites(a1),d0

; Initialize five embedded records while declaring four for rendering
SKMGZSpikeBall_WriteInitialChainRecords:
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #0,(a2)+
                dbf     d0,SKMGZSpikeBall_WriteInitialChainRecords
                move.w  #1,-2(a2)
                move.b  #1,mapping_frame(a1)
                move.w  a1,$3C(a0)

SKMGZSpikeBall_PickSwingMode:
                move.b  subtype(a0),d0
                beq.s   SKMGZSpikeBall_PickHorizontalPhaseStep
                move.w  #2,-2(a2)
                move.b  #2,mapping_frame(a1)
                move.w  #$8000,$34(a0)
                move.w  #$100,$36(a0)
                move.l  #SKMGZSpikeBall_UpdateVerticalSwing,(a0)
                bra.s   SKMGZSpikeBall_UpdateVerticalSwing
; ---------------------------------------------------------------------------

SKMGZSpikeBall_PickHorizontalPhaseStep:
                moveq   #2,d0
                btst    #1,status(a0)
                beq.s   SKMGZSpikeBall_StartHorizontalSwing
                neg.w   d0

SKMGZSpikeBall_StartHorizontalSwing:
                move.b  d0,$36(a0)
                move.l  #SKMGZSpikeBall_UpdateHorizontalSwing,(a0)

SKMGZSpikeBall_UpdateHorizontalSwing:
                movea.w $3C(a0),a1
                bsr.w   PositionHorizontalSwingingSpikeChain
                move.b  $34(a0),d2
                move.b  $36(a0),d0
                add.b   d0,$34(a0)
                tst.b   render_flags(a0)
                bpl.s   SKMGZSpikeBall_CullOrDrawAtPivot
                move.b  $34(a0),d0
                eor.b   d0,d2
                andi.b  #$40,d2
                beq.s   SKMGZSpikeBall_CullOrDrawAtPivot
                andi.b  #$40,d0
                beq.s   SKMGZSpikeBall_CullOrDrawAtPivot
                moveq   #signextendB(sfx_SpikeBalls),d0
                jsr     (Play_SFX).l

SKMGZSpikeBall_CullOrDrawAtPivot:
                move.w  $30(a0),d0
                jmp     (SKTouchCull_TestAnchorAndDraw).l
; ---------------------------------------------------------------------------

SKMGZSpikeBall_UpdateVerticalSwing:
                movea.w $3C(a0),a1
                bsr.w   PositionVerticalSwingingSpikeChain
                move.b  $34(a0),d2
                bpl.s   SKMGZSpikeBall_DecelerateVerticalSwing
                addi.w  #$10,$36(a0)
                bra.s   SKMGZSpikeBall_StepVerticalPhaseAndSound
; ---------------------------------------------------------------------------

SKMGZSpikeBall_DecelerateVerticalSwing:
                subi.w  #$10,$36(a0)

SKMGZSpikeBall_StepVerticalPhaseAndSound:
                move.w  $36(a0),d0
                add.w   d0,$34(a0)
                tst.b   render_flags(a0)
                bpl.s   SKMGZSpikeBall_CullOrDrawAtBall
                move.b  $34(a0),d0
                eor.b   d0,d2
                andi.b  #$40,d2
                beq.s   SKMGZSpikeBall_CullOrDrawAtBall
                andi.b  #$40,d0
                beq.s   SKMGZSpikeBall_CullOrDrawAtBall
                moveq   #signextendB(sfx_SpikeBalls),d0
                jsr     (Play_SFX).l

SKMGZSpikeBall_CullOrDrawAtBall:
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

SKMGZSpikeBall_CullOrDrawChain:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

PositionHorizontalSwingingSpikeChain:
                move.w  #$200,priority(a0)
                move.b  #0,mapping_frame(a1)
                move.w  #5,mainspr_childsprites(a1)
                move.b  $34(a0),d0
                bpl.s   SKMGZSpikeBall_SetUpChainXOffsets
                move.w  #$300,priority(a0)
                move.b  #1,mapping_frame(a1)
                move.w  #4,mainspr_childsprites(a1)

SKMGZSpikeBall_SetUpChainXOffsets:
                jsr     (GetSineCosine).l
                move.w  $30(a0),d3
                swap    d1
                asr.l   #4,d1
                move.l  d1,d5
                lea     sub2_x_pos(a1),a2
                moveq   #4-1,d6

SKMGZSpikeBall_WriteChainXOffset:
                move.l  d5,d4
                swap    d4
                add.w   d3,d4
                move.w  d4,(a2)+
                add.l   d1,d5
                addq.w  #4,a2
                dbf     d6,SKMGZSpikeBall_WriteChainXOffset
                add.l   d1,d5
                swap    d5
                add.w   d3,d5
                move.w  d5,x_pos(a0)
                rts
; End of function PositionHorizontalSwingingSpikeChain

; =============== S U B R O U T I N E =======================================

PositionVerticalSwingingSpikeChain:
                move.w  #$200,priority(a0)
                move.b  #0,mapping_frame(a1)
                move.w  #5,mainspr_childsprites(a1)
                move.b  $34(a0),d0
                bpl.s   SKMGZSpikeBall_SetUpChainYOffsets
                move.w  #$300,priority(a0)
                move.b  #2,mapping_frame(a1)
                move.w  #4,mainspr_childsprites(a1)

SKMGZSpikeBall_SetUpChainYOffsets:
                jsr     (GetSineCosine).l
                move.w  $32(a0),d3
                swap    d1
                asr.l   #4,d1
                move.l  d1,d5
                lea     sub2_y_pos(a1),a2
                moveq   #4-1,d6

SKMGZSpikeBall_WriteChainYOffset:
                move.l  d5,d4
                swap    d4
                add.w   d3,d4
                move.w  d4,(a2)+
                add.l   d1,d5
                addq.w  #4,a2
                dbf     d6,SKMGZSpikeBall_WriteChainYOffset
                add.l   d1,d5
                swap    d5
                add.w   d3,d5
                move.w  d5,y_pos(a0)
                rts
; End of function PositionVerticalSwingingSpikeChain
