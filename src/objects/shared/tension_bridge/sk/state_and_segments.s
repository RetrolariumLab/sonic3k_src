; Owner: objects/shared/tension_bridge/sk
; Responsibility: Tension bridge initialization, coordinated segments, player state and active control
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_TensionBridge:
                move.l  #SKTensionBridge_TickFlatBendFromRiders,(a0)
                move.l  #Map_TensionBridge,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZ2BlockPlat+$10,2,0),art_tile(a0)
                move.w  #$200,priority(a0)
                cmpi.b  #5,(Current_zone).w
                bne.s   SKTensionBridge_SetLavaReefArt
                move.l  #SKTensionBridge_TickAnimFlatFromRiders,(a0)
                move.l  #Map_ICZTensionBridge,mappings(a0)
                move.w  #make_art_tile(ArtTile_ICZMisc1,2,0),art_tile(a0)
                tst.b   subtype(a0)
                bpl.s   SKTensionBridge_SetLavaReefArt
                move.l  #SKTensionBridge_InitSlopedGeometry,(a0)
                andi.b  #$7F,subtype(a0)

SKTensionBridge_SetLavaReefArt:
                cmpi.b  #9,(Current_zone).w
                bne.s   SKTensionBridge_CheckTriggerCollapse
                move.w  #make_art_tile($113,3,1),art_tile(a0)

SKTensionBridge_CheckTriggerCollapse:
                tst.b   subtype(a0)
                bpl.s   SKTensionBridge_InitGeometryAndBanks
                move.l  #SKTensionBridge_TryTriggeredCollapse,(a0)
                andi.b  #$7F,subtype(a0)

SKTensionBridge_InitGeometryAndBanks:
                move.b  #4,render_flags(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  y_pos(a0),d2
                move.w  d2,$3C(a0)
                move.w  x_pos(a0),d3
                lea     subtype(a0),a2
                moveq   #0,d1
                move.b  (a2),d1
                move.w  d1,d0
                lsr.w   #1,d0
                lsl.w   #4,d0
                sub.w   d0,d3
                swap    d1
                move.w  #8,d1
                bsr.s   CreateTensionBridgeSpriteBank
                move.w  $30(a1),d0
                subq.w  #8,d0
                move.w  d0,x_pos(a1)
                move.l  a1,$30(a0)
                swap    d1
                subq.w  #8,d1
                bls.s   SKTensionBridge_EnterFlatUpdate
                move.w  d1,d4
                bsr.s   CreateTensionBridgeSpriteBank
                move.l  a1,$34(a0)
                move.w  d4,d0
                add.w   d0,d0
                add.w   d4,d0
                move.w  sub2_x_pos(a1,d0.w),d0
                subq.w  #8,d0
                move.w  d0,x_pos(a1)

SKTensionBridge_EnterFlatUpdate:
                bra.w   SKTensionBridge_TickFlatBendFromRiders

; =============== S U B R O U T I N E =======================================

CreateTensionBridgeSpriteBank:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKTensionBridge_CreateBankReturn
                move.l  #SKTensionBridge_DrawEmbeddedSegmentBank,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.w  priority(a0),priority(a1)
                bset    #6,render_flags(a1)
                move.b  #$40,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.w  d1,mainspr_childsprites(a1)
                subq.b  #1,d1
                lea     sub2_x_pos(a1),a2

SKTensionBridge_WriteSegmentAndStepX:
                move.w  d3,(a2)+
                move.w  d2,(a2)+
                move.w  #0,(a2)+
                addi.w  #$10,d3
                dbf     d1,SKTensionBridge_WriteSegmentAndStepX

SKTensionBridge_CreateBankReturn:
                rts
; End of function CreateTensionBridgeSpriteBank

; ---------------------------------------------------------------------------

SKTensionBridge_TryTriggeredCollapse:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                tst.b   (a3)
                beq.s   SKTensionBridge_TickFlatBendFromRiders
                move.l  #SKTensionBridge_WaitCollapseRelease,(a0)
                move.b  #$E,$34(a0)
                move.l  #SKTensionBridge_WaitAndDrawCollapsePiece,d4
                bra.w   SKTensionBridge_CollapseSpriteBanks
; ---------------------------------------------------------------------------

SKTensionBridge_TickFlatBendFromRiders:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   SKTensionBridge_MoveFlatCursorTowardP2
                tst.b   $3E(a0)
                beq.s   SKTensionBridge_CollideFlatBridge
                subq.b  #4,$3E(a0)
                bra.s   SKTensionBridge_BendFlatSegments
; ---------------------------------------------------------------------------

SKTensionBridge_MoveFlatCursorTowardP2:
                andi.b  #$10,d0
                beq.s   SKTensionBridge_RaiseFlatPhaseTo40
                move.b  $3F(a0),d0
                sub.b   $3B(a0),d0
                beq.s   SKTensionBridge_RaiseFlatPhaseTo40
                bcc.s   SKTensionBridge_DecrementFlatBendCursor
                addq.b  #1,$3F(a0)
                bra.s   SKTensionBridge_RaiseFlatPhaseTo40
; ---------------------------------------------------------------------------

SKTensionBridge_DecrementFlatBendCursor:
                subq.b  #1,$3F(a0)

SKTensionBridge_RaiseFlatPhaseTo40:
                cmpi.b  #$40,$3E(a0)
                beq.s   SKTensionBridge_BendFlatSegments
                addq.b  #4,$3E(a0)

SKTensionBridge_BendFlatSegments:
                bsr.w   BendTensionBridgeSegments

SKTensionBridge_CollideFlatBridge:
                moveq   #0,d1
                move.b  subtype(a0),d1
                lsl.w   #3,d1
                move.w  d1,d2
                addq.w  #8,d1
                add.w   d2,d2
                moveq   #8,d3
                move.w  x_pos(a0),d4
                bsr.w   CollidePlayersWithTensionBridge

SKTensionBridge_CullRootByCoarseX:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   SKTensionBridge_DeleteBanksOutsideRange
                rts
; ---------------------------------------------------------------------------

SKTensionBridge_DeleteBanksOutsideRange:
                movea.l $30(a0),a1
                jsr     (Delete_Referenced_Sprite).l
                cmpi.b  #8,subtype(a0)
                bls.s   SKTensionBridge_ClearRootLoadedBit
                movea.l $34(a0),a1
                jsr     (Delete_Referenced_Sprite).l

SKTensionBridge_ClearRootLoadedBit:
                move.w  respawn_addr(a0),d0
                beq.s   SKTensionBridge_DeleteRootAfterBanks
                movea.w d0,a2
                bclr    #7,(a2)

SKTensionBridge_DeleteRootAfterBanks:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKTensionBridge_DrawEmbeddedSegmentBank:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKTensionBridge_TickAnimFlatFromRiders:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   SKTensionBridge_MoveAnimFlatCursorToP2
                tst.b   $3E(a0)
                beq.s   SKTensionBridge_CollideAndAnimateFlat
                subq.b  #4,$3E(a0)
                bra.s   SKTensionBridge_BendAnimFlatSegments
; ---------------------------------------------------------------------------

SKTensionBridge_MoveAnimFlatCursorToP2:
                andi.b  #p2_standing,d0
                beq.s   SKTensionBridge_RaiseAnimFlatPhaseTo40
                move.b  $3F(a0),d0
                sub.b   $3B(a0),d0
                beq.s   SKTensionBridge_RaiseAnimFlatPhaseTo40
                bcc.s   SKTensionBridge_LowerAnimFlatCursor
                addq.b  #1,$3F(a0)
                bra.s   SKTensionBridge_RaiseAnimFlatPhaseTo40
; ---------------------------------------------------------------------------

SKTensionBridge_LowerAnimFlatCursor:
                subq.b  #1,$3F(a0)

SKTensionBridge_RaiseAnimFlatPhaseTo40:
                cmpi.b  #$40,$3E(a0)
                beq.s   SKTensionBridge_BendAnimFlatSegments
                addq.b  #4,$3E(a0)

SKTensionBridge_BendAnimFlatSegments:
                bsr.w   BendTensionBridgeSegments

SKTensionBridge_CollideAndAnimateFlat:
                moveq   #0,d1
                move.b  subtype(a0),d1
                lsl.w   #3,d1
                move.w  d1,d2
                addq.w  #8,d1
                add.w   d2,d2
                moveq   #8,d3
                move.w  x_pos(a0),d4
                bsr.w   CollidePlayersWithTensionBridge
                bsr.w   TensionBridge_AnimateRiddenBoards
                bra.w   SKTensionBridge_CullRootByCoarseX
; ---------------------------------------------------------------------------

SKTensionBridge_WaitAndDrawCollapsePiece:
                tst.b   $34(a0)
                beq.s   SKTensionBridge_MoveCollapsePiece
                subq.b  #1,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; Use the saved render sign from the preceding frame to decide whether to draw or delete
SKTensionBridge_MoveCollapsePiece:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bpl.s   SKTensionBridge_DeleteHiddenPiece
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKTensionBridge_DeleteHiddenPiece:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKTensionBridge_WaitCollapseRelease:
                tst.b   $34(a0)
                beq.s   SKTensionBridge_ReleaseCollapseP1
                subq.b  #1,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKTensionBridge_ReleaseCollapseP1:
                bclr    #p1_standing_bit,status(a0)
                beq.s   SKTensionBridge_ReleaseCollapseP2
                bclr    #Status_OnObj,(Player_1+status).w
                bset    #Status_InAir,(Player_1+status).w

SKTensionBridge_ReleaseCollapseP2:
                bclr    #p2_standing_bit,status(a0)
                beq.s   SKTensionBridge_DeleteCollapseRoot
                bclr    #Status_OnObj,(Player_2+status).w
                bset    #Status_InAir,(Player_2+status).w

SKTensionBridge_DeleteCollapseRoot:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKTensionBridge_InitSlopedGeometry:
                bsr.w   BendSlopedTensionBridgeSegments
                move.l  #SKTensionBridge_TickSlopeBendFromRiders,(a0)

SKTensionBridge_TickSlopeBendFromRiders:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   SKTensionBridge_CacheSlopedRiderBins
                tst.b   $3E(a0)
                beq.s   SKTensionBridge_CollideAndAnimateSlope
                subq.b  #4,$3E(a0)
                bra.s   SKTensionBridge_BendSlopedSegments
; ---------------------------------------------------------------------------

SKTensionBridge_CacheSlopedRiderBins:
                moveq   #0,d1
                move.b  subtype(a0),d1
                lsl.w   #3,d1
                move.w  d1,d2
                addq.w  #8,d1
                add.w   d2,d2
                bsr.w   CacheTensionBridgeRiderSegments
                move.b  status(a0),d0
                andi.b  #p2_standing,d0
                beq.s   SKTensionBridge_RaiseSlopePhaseTo40
                move.b  $3F(a0),d0
                sub.b   $3B(a0),d0
                beq.s   SKTensionBridge_RaiseSlopePhaseTo40
                bcc.s   SKTensionBridge_LowerSlopeCursor
                addq.b  #1,$3F(a0)
                bra.s   SKTensionBridge_RaiseSlopePhaseTo40
; ---------------------------------------------------------------------------

SKTensionBridge_LowerSlopeCursor:
                subq.b  #1,$3F(a0)

SKTensionBridge_RaiseSlopePhaseTo40:
                cmpi.b  #$40,$3E(a0)
                beq.s   SKTensionBridge_BendSlopedSegments
                addq.b  #4,$3E(a0)

SKTensionBridge_BendSlopedSegments:
                bsr.w   BendSlopedTensionBridgeSegments

SKTensionBridge_CollideAndAnimateSlope:
                moveq   #0,d1
                move.b  subtype(a0),d1
                lsl.w   #3,d1
                move.w  d1,d2
                addq.w  #8,d1
                add.w   d2,d2
                moveq   #8,d3
                move.w  x_pos(a0),d4
                bsr.w   CollidePlayersWithSlopedTensionBridge
                bsr.w   TensionBridge_AnimateRiddenBoards
                bra.w   SKTensionBridge_CullRootByCoarseX
; ---------------------------------------------------------------------------

; Collapse a second bank when the bridge has more than eight segments
SKTensionBridge_CollapseSpriteBanks:
                movea.l $30(a0),a3
                bsr.s   CollapseTensionBridgeSpriteBank
                cmpi.b  #8,subtype(a0)
                bls.s   SKTensionBridge_CollapseBanksReturn
                movea.l $34(a0),a3
                bsr.s   CollapseTensionBridgeSpriteBank

SKTensionBridge_CollapseBanksReturn:
                rts
