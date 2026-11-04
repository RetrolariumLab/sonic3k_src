; Owner: objects/shared/sk
; Responsibility: Collapsing platforms and bridges, player release, fragment creation, collapse timing and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CollapsingPlatform:
                move.l  #Map_AIZCollapsingPlatform,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                cmpi.w  #1,(Current_zone_and_act).w
                bne.s   SKCollapse_SelectDelayAndSlopeData
                move.l  #Map_AIZCollapsingPlatform2,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)

SKCollapse_SelectDelayAndSlopeData:
                move.l  #SKCollapse_AIZPlatformFragmentDelays,$30(a0)
                move.l  #SKCollapse_AIZPlatformSignedSlopeHeights,$3C(a0)
                move.b  #$3C,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                cmpi.b  #5,(Current_zone).w
                bne.s   SKCollapse_InitPlatformDelayAndHandler
                move.l  #Map_ICZCollapsingBridge,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.l  #SKCollapse_ICZPlatformFragmentDelays,$30(a0)
                move.l  #SKCollapse_ICZPlatformSignedSlopeHeights,$3C(a0)
                move.b  #$30,width_pixels(a0)
                move.b  #$30,height_pixels(a0)

SKCollapse_InitPlatformDelayAndHandler:
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #7,$38(a0)
                move.b  subtype(a0),mapping_frame(a0)
                ori.b   #$80,status(a0)
                move.l  #SKCollapse_TickIntactPlatformDelay,(a0)

SKCollapse_TickIntactPlatformDelay:
                tst.b   $3A(a0)
                beq.s   SKCollapse_LatchPlatformRiders
                tst.b   $38(a0)
                beq.w   ObjPlatformCollapse_CreateFragments
                subq.b  #1,$38(a0)

SKCollapse_LatchPlatformRiders:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   CollideAndDisplayCollapsingPlatform
                move.b  #1,$3A(a0)

; =============== S U B R O U T I N E =======================================

CollideAndDisplayCollapsingPlatform:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                movea.l $3C(a0),a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped2).l
                bra.w   Sprite_OnScreen_Test
; End of function CollideAndDisplayCollapsingPlatform

; ---------------------------------------------------------------------------

SKCollapse_WaitNonSolidPlatformFragment:
                subq.b  #1,$38(a0)
                bne.s   SKCollapse_DrawWaitingPlatformFragment
                move.l  #SKCollapse_CullThenMoveFragment,(a0)

SKCollapse_DrawWaitingPlatformFragment:
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

SKCollapse_WaitSolidFragmentAndRelease:
                bsr.w   CollideAndDisplayCollapsingPlatform
                subq.b  #1,$38(a0)
                bne.s   SKCollapse_RiderReleaseReturn
                move.l  #SKCollapse_CullThenMoveFragment,(a0)
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   ReleasePlayerFromCollapsingPlatform
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6

; =============== S U B R O U T I N E =======================================

ReleasePlayerFromCollapsingPlatform:
                btst    d6,status(a0)
                beq.s   SKCollapse_RiderReleaseReturn
                bclr    d6,status(a0)
                bclr    #Status_OnObj,status(a1)
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,prev_anim(a1)

SKCollapse_RiderReleaseReturn:
                rts
; End of function ReleasePlayerFromCollapsingPlatform

; ---------------------------------------------------------------------------

SKCollapse_CullThenMoveFragment:
                tst.b   render_flags(a0)
                bpl.w   Delete_Current_Sprite
                bsr.w   MoveSprite
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

Obj_CollapsingBridge:
                move.l  #SKCollapse_TickStandingTriggeredBridge,(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                cmpi.b  #6,(Current_zone).w
                bne.s   SKCollapse_TryHCZBridgeSetup
                move.b  subtype(a0),d0
                andi.w  #$3F,d0
                add.w   d0,d0
                add.w   d0,d0
                addq.w  #8,d0
                bcc.s   SKCollapse_SetLBZDelayAndShape
                move.b  #-1,d0

SKCollapse_SetLBZDelayAndShape:
                move.b  d0,$38(a0)
                btst    #6,subtype(a0)
                bne.s   SKCollapse_InitializeLBZLedgeResources
                move.l  #Map_LBZCollapsingBridge,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.l  #LBZBridgeCollapse_TimerArray,$30(a0)
                move.l  #LBZBridgeCollapse_TimerFlipArray,$34(a0)
                bra.s   SKCollapse_TryHCZBridgeSetup
; ---------------------------------------------------------------------------

SKCollapse_InitializeLBZLedgeResources:
                move.l  #Map_LBZCollapsingLedge,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$30,height_pixels(a0)
                move.l  #LBZLedgeCollapse_TimerArray,$30(a0)

SKCollapse_TryHCZBridgeSetup:
                cmpi.b  #1,(Current_zone).w
                bne.w   SKCollapse_TryMGZBridgeOrSuperBreak
                move.l  #Map_HCZCollapsingBridge,mappings(a0)
                move.w  #make_art_tile($001,2,1),art_tile(a0)
                move.b  subtype(a0),d0
                bpl.s   SKCollapse_DecodeHCZShapeAndDelays
                move.b  d0,d1
                andi.b  #$F,d1
                move.b  d1,$40(a0)
                move.l  #SKCollapse_TickTriggerArmedBridge,(a0)
                andi.b  #$70,d0

SKCollapse_DecodeHCZShapeAndDelays:
                move.b  d0,d1
                andi.w  #$F,d0
                lsl.w   #4,d0
                addq.w  #8,d0
                move.b  d0,$38(a0)
                andi.w  #$F0,d1
                lsr.w   #2,d1
                lea     SKCollapse_HCZShapeAttributes(pc,d1.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,subtype(a0)
                add.w   d1,d1
                lea     SKCollapse_HCZShapeDelayPointerPairs(pc,d1.w),a1
                move.l  (a1)+,$30(a0)
                move.l  (a1)+,$34(a0)
                bra.s   SKCollapse_TryMGZBridgeOrSuperBreak
; ---------------------------------------------------------------------------
SKCollapse_HCZShapeAttributes:
                dc.b    $40, $10, 0, $80
                dc.b    $50, $10, 3, $80
                dc.b    $40, $10, 6,   0
                dc.b    $50, $20, 9, $80
SKCollapse_HCZShapeDelayPointerPairs:
                dc.l    SKCollapse_HCZFirstShapeForwardDelays, SKCollapse_HCZFirstShapeReverseDelays
                dc.l    SKCollapse_HCZSecondShapeForwardDelays, SKCollapse_HCZSecondShapeReverseDelays
                dc.l    SKCollapse_HCZShape3SharedDelays, SKCollapse_HCZShape3SharedDelays
                dc.l    SKCollapse_HCZFourthShapeForwardDelays, SKCollapse_HCZFourthShapeReverseDelays
; ---------------------------------------------------------------------------

SKCollapse_TryMGZBridgeOrSuperBreak:
                cmpi.b  #2,(Current_zone).w
                bne.s   SKCollapse_TryICZBridgeAndTrigger
                move.l  #Map_MGZCollapsingBridge,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$F,d0
                lsl.w   #4,d0
                addq.w  #8,d0
                move.b  d0,$38(a0)
                andi.w  #$F0,d1
                lsr.w   #2,d1
                lea     SKCollapse_MGZShapeAttributes(pc,d1.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,subtype(a0)
                add.w   d1,d1
                lea     SKCollapse_MGZShapeDelayPointerPairs(pc,d1.w),a1
                move.l  (a1)+,$30(a0)
                move.l  (a1)+,$34(a0)
                cmpi.w  #$10,d1
                bne.s   SKCollapse_TryICZBridgeAndTrigger
                move.l  #SKCollapse_CheckMGZSuperBreakRider,(a0)
                rts
; ---------------------------------------------------------------------------
SKCollapse_MGZShapeAttributes:
                dc.b    $40, $20,   0, $80
                dc.b    $30, $20,   3, $80
                dc.b    $40, $20,   6, $80
SKCollapse_MGZShapeDelayPointerPairs:
                dc.l    SKCollapse_MGZWideAndFBZForwardDelays, SKCollapse_MGZWideAndFBZReverseDelays
                dc.l    SKCollapse_MGZNarrowForwardDelays, SKCollapse_MGZNarrowReverseDelays
                dc.l    SKCollapse_MGZWideAndFBZForwardDelays, SKCollapse_MGZWideAndFBZReverseDelays
; ---------------------------------------------------------------------------

SKCollapse_TryICZBridgeAndTrigger:
                cmpi.b  #5,(Current_zone).w
                bne.s   SKCollapse_SelectHPZBridgeResources
                move.b  subtype(a0),d0
                bpl.s   SKCollapse_InitICZBridgeDelayAndMap
                move.b  d0,d1
                andi.b  #$F,d1
                move.b  d1,$40(a0)
                move.l  #SKCollapse_TickTriggerArmedBridge,(a0)
                andi.b  #$70,d0

SKCollapse_InitICZBridgeDelayAndMap:
                move.b  d0,d1
                andi.w  #$F,d0
                lsl.w   #4,d0
                addq.w  #8,d0
                move.b  d0,$38(a0)
                move.l  #Map_ICZCollapsingBridge,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$50,width_pixels(a0)
                move.b  #$38,height_pixels(a0)
                move.l  #SKCollapse_ICZBridgeForwardDelays,$30(a0)
                move.l  #SKCollapse_ICZBridgeReverseDelays,$34(a0)
                move.b  #3,mapping_frame(a0)

SKCollapse_SelectHPZBridgeResources:
                cmpi.b  #$16,(Current_zone).w
                bne.s   SKCollapse_SelectLRZBridgeResources
                move.l  #Map_HPZCollapsingBridge,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                bra.s   SKCollapse_DecodeHPZLRZBridge
; ---------------------------------------------------------------------------

SKCollapse_SelectLRZBridgeResources:
                cmpi.b  #9,(Current_zone).w
                bne.s   SKCollapse_SelectFBZBridgeAttributes
                move.l  #Map_LRZCollapsingPlatform,mappings(a0)
                move.w  #make_art_tile($090,2,0),art_tile(a0)

SKCollapse_DecodeHPZLRZBridge:
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$F,d0
                lsl.w   #4,d0
                addq.w  #8,d0
                move.b  d0,$38(a0)
                andi.w  #$70,d1
                lsr.w   #2,d1
                lea     SKCollapse_HPZLRZShapeAttributes(pc,d1.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.b  (a1)+,mapping_frame(a0)
                add.w   d1,d1
                lea     SKCollapse_HPZLRZDelayPointerPair(pc,d1.w),a1
                move.l  (a1)+,$30(a0)
                move.l  (a1)+,$34(a0)
                bra.s   SKCollapse_SelectFBZBridgeAttributes
; ---------------------------------------------------------------------------
SKCollapse_HPZLRZShapeAttributes:
                dc.b    $20, $18,   0, $80
SKCollapse_HPZLRZDelayPointerPair:
                dc.l    SKCollapse_HPZLRZForwardFragmentDelays, SKCollapse_HPZLRZReverseFragmentDelays
; ---------------------------------------------------------------------------

SKCollapse_SelectFBZBridgeAttributes:
                cmpi.b  #4,(Current_zone).w             ; is this FBZ?
                bne.s   SKCollapse_SelectSOZBridgeAttributes  ; if not, branch
                move.l  #Map_FBZCollapsingBridge,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$F,d0
                lsl.w   #4,d0
                addq.w  #8,d0
                move.b  d0,$38(a0)
                andi.w  #$F0,d1
                lsr.w   #2,d1
                lea     FBZBridgeSpriteAttribute(pc,d1.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,subtype(a0)
                add.w   d1,d1
                lea     SKCollapse_FBZWideDelayPointerPair(pc,d1.w),a1
                move.l  (a1)+,$30(a0)
                move.l  (a1)+,$34(a0)
                bra.s   SKCollapse_SelectSOZBridgeAttributes
; ---------------------------------------------------------------------------
FBZBridgeSpriteAttribute:
; width, height, frame, subtype
                dc.b    $40, $20,   0, $80
SKCollapse_FBZWideDelayPointerPair:
                dc.l    SKCollapse_MGZWideAndFBZForwardDelays, SKCollapse_MGZWideAndFBZReverseDelays
; ---------------------------------------------------------------------------

SKCollapse_SelectSOZBridgeAttributes:
                cmpi.b  #8,(Current_zone).w             ; is this zone 8?
                bne.s   SKCollapse_TickStandingTriggeredBridge  ; if not branch
                move.l  #Map_SOZCollapsingBridge,mappings(a0)  ; if yes, set its sprite properties
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1                           ; copy subtype
                andi.w  #$F,d0                          ; read first digit
                lsl.w   #4,d0                           ; multiply amount
                addq.w  #8,d0                           ; add 8 to it
                move.b  d0,$38(a0)                      ; copy the amount we got into $38 (custom variable)
                andi.w  #$70,d1
                lsr.w   #2,d1
                lea     SKCollapse_SOZShapeAttributes(pc,d1.w),a1
                move.b  (a1)+,width_pixels(a0)          ; get width
                move.b  (a1)+,height_pixels(a0)
                move.b  (a1)+,mapping_frame(a0)
                add.w   d1,d1                           ; multiply by 2
                lea     SKCollapse_SOZDelayPointerPair(pc,d1.w),a1
                move.l  (a1)+,$30(a0)
                move.l  (a1)+,$34(a0)
                bra.s   SKCollapse_TickStandingTriggeredBridge
; ---------------------------------------------------------------------------
SKCollapse_SOZShapeAttributes:
                dc.b    $20, $30,   0, $80
SKCollapse_SOZDelayPointerPair:
                dc.l    SKCollapse_SOZForwardFragmentDelays, SKCollapse_SOZReverseFragmentDelays
; ---------------------------------------------------------------------------

SKCollapse_TickStandingTriggeredBridge:
                tst.b   $3A(a0)
                beq.s   SKCollapse_LatchBridgeRiders
                tst.b   $38(a0)
                bne.s   SKCollapse_DecrementArmedBridgeCounter
                movea.l $30(a0),a4
                tst.b   subtype(a0)                     ; does this object have a subtype?
                bpl.s   SKCollapse_StartBridgeStaticSmash  ; if yes, branch to here
                move.b  status(a0),d0                   ; if bit 7 of subtype set, collapse platform in direction dependent on player position
                andi.b  #standing_mask,d0
                beq.s   SKCollapse_StartBridgeStaticSmash
                move.w  (Player_1+x_pos).w,d1
                andi.b  #8,d0
                bne.s   SKCollapse_ReverseBridgeByRiderSide
                move.w  (Player_2+x_pos).w,d1

SKCollapse_ReverseBridgeByRiderSide:
                cmp.w   x_pos(a0),d1                    ; compare object x pos with player's x pos (Sonic, Tails, Knuckles)
                bhs.s   SKCollapse_StartBridgeStaticSmash  ; if it's higher than player's x pos (x coordinates), then branch
                movea.l $34(a0),a4                      ; if it's less, get pointer to a4
                bchg    #0,status(a0)                   ; reverse status (flipping for this case)
                addq.b  #1,mapping_frame(a0)            ; add 1 to mapping frame

SKCollapse_StartBridgeStaticSmash:
                bra.w   CollapsingPtfmHandlePlayerAndSmash
; ---------------------------------------------------------------------------

SKCollapse_DecrementArmedBridgeCounter:
                subq.b  #1,$38(a0)

SKCollapse_LatchBridgeRiders:
                move.b  status(a0),d0                   ; Check if player is standing on platform
                andi.b  #standing_mask,d0
                beq.s   SKCollapse_CollideAndDrawFlatBridge
                move.b  #1,$3A(a0)                      ; Turn on collapsing timer

SKCollapse_CollideAndDrawFlatBridge:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                move.w  #$10,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                bra.w   Sprite_OnScreen_Test
; ---------------------------------------------------------------------------

SKCollapse_CheckMGZSuperBreakRider:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                move.w  #$10,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   SKCollapse_DrawUnbrokenMGZSpecialBridge
                move.b  (Player_1+status_tertiary).w,d1
                andi.b  #8,d0
                bne.s   SKCollapse_ReleaseP1ForSuperBreak
                move.b  (Player_2+status_tertiary).w,d1

SKCollapse_ReleaseP1ForSuperBreak:
                tst.b   d1
                bpl.s   SKCollapse_DrawUnbrokenMGZSpecialBridge
                bclr    #p1_standing_bit,status(a0)
                beq.s   SKCollapse_ReleaseP2ForSuperBreak
                lea     (Player_1).w,a1
                bclr    #Status_OnObj,status(a1)

SKCollapse_ReleaseP2ForSuperBreak:
                bclr    #p2_standing_bit,status(a0)
                beq.s   SKCollapse_SpawnMGZSuperBreakFragments
                lea     (Player_2).w,a1
                bclr    #Status_OnObj,status(a1)

SKCollapse_SpawnMGZSuperBreakFragments:
                lea     (SKCollapse_MGZSuperBreakVelocityPairs).l,a4
                addq.b  #1,mapping_frame(a0)
                move.w  #$80,priority(a0)
                move.l  #SKCollapse_MoveSuperBreakFragment,(a0)
                jsr     (BreakObjectToPieces).l
                move.w  respawn_addr(a0),d0             ; was obj spawned by layout?
                beq.s   SKCollapse_ContinueCurrentSuperBreakFall  ; if not, branch to function
                movea.w d0,a1                           ; if yes, get addr of respawn_table
                bclr    #7,(a1)                         ; set as unloaded
                clr.w   respawn_addr(a0)                ; clear that addr

SKCollapse_ContinueCurrentSuperBreakFall:
                bra.s   SKCollapse_MoveSuperBreakFragment
; ---------------------------------------------------------------------------

SKCollapse_DrawUnbrokenMGZSpecialBridge:
                bra.w   Sprite_OnScreen_Test
; ---------------------------------------------------------------------------

SKCollapse_MoveSuperBreakFragment:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)                  ; make object fall
                tst.b   render_flags(a0)                ; is sprite on screen?
                bpl.w   SKCollapse_DeleteHiddenSuperFragment  ; no delete
                jmp     (Draw_Sprite).l                 ; if yes, then display
; ---------------------------------------------------------------------------

SKCollapse_DeleteHiddenSuperFragment:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
SKCollapse_MGZSuperBreakVelocityPairs:
                dc.w    -$400, -$A00
                dc.w    -$300, -$A00
                dc.w    -$200, -$A00
                dc.w    -$100, -$A00
                dc.w    $100, -$A00
                dc.w    $200, -$A00
                dc.w    $300, -$A00
                dc.w    $400, -$A00
                dc.w    -$3C0, -$900
                dc.w    -$2C0, -$900
                dc.w    -$1C0, -$900
                dc.w    -$C0, -$900
                dc.w    $C0, -$900
                dc.w    $1C0, -$900
                dc.w    $2C0, -$900
                dc.w    $3C0, -$900
                dc.w    -$380, -$800
                dc.w    -$280, -$800
                dc.w    -$180, -$800
                dc.w    -$80, -$800
                dc.w    $80, -$800
                dc.w    $180, -$800
                dc.w    $280, -$800
                dc.w    $380, -$800
                dc.w    -$340, -$700
                dc.w    -$240, -$700
                dc.w    -$140, -$700
                dc.w    -$40, -$700
                dc.w    $40, -$700
                dc.w    $140, -$700
                dc.w    $240, -$700
                dc.w    $340, -$700
; ---------------------------------------------------------------------------

SKCollapse_TickTriggerArmedBridge:
                tst.b   $3A(a0)
                beq.s   SKCollapse_PollBridgeTrigger
                tst.b   $38(a0)
                bne.s   SKCollapse_TickTriggeredBridgeDelay
                movea.l $30(a0),a4
                tst.b   subtype(a0)
                bpl.s   SKCollapse_StartTriggeredStaticSmash
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   SKCollapse_StartTriggeredStaticSmash
                move.w  (Player_1+x_pos).w,d1
                andi.b  #8,d0
                bne.s   SKCollapse_ReverseTriggerBridgeBySide
                move.w  (Player_2+x_pos).w,d1

SKCollapse_ReverseTriggerBridgeBySide:
                cmp.w   x_pos(a0),d1
                bhs.s   SKCollapse_StartTriggeredStaticSmash
                movea.l $34(a0),a4
                bchg    #0,status(a0)
                addq.b  #1,mapping_frame(a0)

SKCollapse_StartTriggeredStaticSmash:
                bra.w   CollapsingPtfmHandlePlayerAndSmash
; ---------------------------------------------------------------------------

SKCollapse_TickTriggeredBridgeDelay:
                subq.b  #1,$38(a0)

; On a trigger, detach the respawn link so later culling cannot reset the original placement
SKCollapse_PollBridgeTrigger:
                move.b  $40(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                tst.b   (a3)
                beq.s   SKCollapse_RunTriggerBridgeCollisionTail
                move.b  #1,$3A(a0)
                clr.w   respawn_addr(a0)

SKCollapse_RunTriggerBridgeCollisionTail:
                bra.w   SKCollapse_CollideAndDrawFlatBridge
; ---------------------------------------------------------------------------

Obj_PlatformCollapseWait:
                subq.b  #1,$38(a0)
                bne.s   SKCollapse_DrawWaitingBridgeFragment
                move.l  #Obj_PlatformCollapseFall,(a0)

SKCollapse_DrawWaitingBridgeFragment:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_PlatformCollapseFall:
                tst.b   render_flags(a0)                ; is obj on screen?
                bpl.s   SKCollapse_DeleteFallingBridgeFragment  ; if not, delete
                jsr     (MoveSprite).l                  ; if yes, move sprite and display
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKCollapse_DeleteFallingBridgeFragment:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_PlatformCollapseWaitHandlePlayer:
                subq.b  #1,$38(a0)
                bne.s   SKCollapse_CheckWaitingRidersAndDraw
                move.l  #Obj_PlatformCollapseFall,(a0)

SKCollapse_CheckWaitingRidersAndDraw:
                move.b  $38(a0),d3
                movea.l $30(a0),a2
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   Check_CollapsePlayerRelease
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.s   Check_CollapsePlayerRelease
                bra.w   Sprite_OnScreen_Test

; =============== S U B R O U T I N E =======================================

Check_CollapsePlayerRelease:
                btst    d6,status(a0)
                beq.s   SKCollapse_ReturnFromBridgeRiderRelease
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   SKCollapse_ReleaseRiderAfterStripLoss
                move.w  x_pos(a1),d0                    ; gets player's range from object
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKCollapse_ReleaseRiderAfterStripLoss
                cmp.w   d2,d0
                bhs.s   SKCollapse_ReleaseRiderAfterStripLoss
                btst    #0,status(a0)
                beq.s   SKCollapse_CheckRiderStripDelay
                neg.w   d0
                add.w   d2,d0

SKCollapse_CheckRiderStripDelay:
                lsr.w   #4,d0
                move.b  (a2),d2
                sub.b   (a2,d0.w),d2
                cmp.b   d2,d3
                bhi.s   SKCollapse_ReturnFromBridgeRiderRelease

SKCollapse_ReleaseRiderAfterStripLoss:
                bclr    d6,status(a0)
                bclr    #Status_OnObj,status(a1)
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,prev_anim(a1)

SKCollapse_ReturnFromBridgeRiderRelease:
                rts
; End of function Check_CollapsePlayerRelease

; ---------------------------------------------------------------------------
; in s2disasm: Obj1F_CreateFragments
CollapsingPtfmHandlePlayerAndSmash:
                move.l  #Obj_PlatformCollapseWaitHandlePlayer,(a0)
                move.l  #Obj_PlatformCollapseWait,d4
                addq.b  #1,mapping_frame(a0)
                bra.s   ObjPlatformCollapse_SmashObject
; ---------------------------------------------------------------------------

ObjPlatformCollapse_CreateFragments:
                move.l  #SKCollapse_WaitSolidFragmentAndRelease,(a0)
                move.l  #SKCollapse_WaitNonSolidPlatformFragment,d4
                addq.b  #2,mapping_frame(a0)
                movea.l $30(a0),a4

ObjPlatformCollapse_SmashObject:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                add.w   d0,d0
                movea.l mappings(a0),a3
                adda.w  (a3,d0.w),a3
                move.w  (a3)+,d1
                subq.w  #1,d1
                bset    #5,render_flags(a0)             ; set flag to "static mappings flag"
                move.b  render_flags(a0),d5             ; get render type
                movea.l a0,a1
                bra.s   GetFragmentsSpriteProperties
; ---------------------------------------------------------------------------

GetFragmentsSlotsloop:
                bsr.w   AllocateObjectAfterCurrent
                bne.s   FragmentsDrawAndPlaySfx
                addq.w  #6,a3                           ; in Sonic 2's mapping format, this is just addq.w #8,a3 due to different mapping format sizes (addq.w #5,a3 for Sonic 1)
                move.l  d4,(a1)

GetFragmentsSpriteProperties:
                move.l  a3,mappings(a1)
                move.b  d5,render_flags(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.w  priority(a0),priority(a1)
                move.b  width_pixels(a0),width_pixels(a1)
                move.b  height_pixels(a0),height_pixels(a1)
                move.b  (a4)+,$38(a1)
                dbf     d1,GetFragmentsSlotsloop

FragmentsDrawAndPlaySfx:
                jsr     (Draw_Sprite).l
                move.w  respawn_addr(a0),d0
                beq.s   .CollapsingPtfmPlaySfx          ; function when object isn't spawned by layout (plays sound anyway)
                movea.w d0,a1
                bclr    #7,(a1)
                clr.w   respawn_addr(a0)

                .CollapsingPtfmPlaySfx:
                moveq   #signextendB(sfx_Collapse),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------
SKCollapse_AIZPlatformFragmentDelays:
                dc.b    $30, $2C, $28, $24, $20, $1C, $2E, $2A, $26, $22, $1E, $1A, $2C, $28, $24, $20, $1C, $18, $2A, $26
                dc.b    $22, $1E, $1A, $16, $28, $24, $20, $1C, $18, $14
SKCollapse_ICZPlatformFragmentDelays:
                dc.b    $30, $2C, $28, $24, $20, $1C, $2E, $2A, $26, $22, $1E, $1A, $2C, $28, $24, $20, $1C, $18, $2A, $26
                dc.b    $22, $1E, $1A, $16, $28, $24, $20, $1C, $18, $14, $12, $10
LBZBridgeCollapse_TimerArray:
                dc.b    $20, $1C, $18, $14, $10,  $C,   8,   4, $1E, $1A, $16, $12,  $E,  $A,   6,   2
LBZBridgeCollapse_TimerFlipArray:
                dc.b    $20,   4,   8,  $C, $10, $14, $18, $1C,   2,   6,  $A,  $E, $12, $16, $1A, $1E
LBZLedgeCollapse_TimerArray:
                dc.b    $20, $18, $10,   8, $1E, $16,  $E,   6, $1C, $14,  $C,   4, $1A, $12
SKCollapse_HCZFirstShapeForwardDelays:
                dc.b    $20, $1C, $18, $14, $10,  $C,   8,   4, $1E, $1A, $16, $12,  $E,  $A,   6,   2
SKCollapse_HCZFirstShapeReverseDelays:
                dc.b    $20,   4,   8,  $C, $10, $14, $18, $1C,   2,   6,  $A,  $E, $12, $16, $1A, $1E
SKCollapse_HCZSecondShapeForwardDelays:
                dc.b    $28, $24, $20, $1C, $18, $14, $10,  $C,   8,   4, $26, $22, $1E, $1A, $16, $12,  $E,  $A,   6,   2
SKCollapse_HCZSecondShapeReverseDelays:
                dc.b    $28,   4,   8,  $C, $10, $14, $18, $1C, $20, $24,   2,   6,  $A,  $E, $12, $16, $1A, $1E, $22, $26
SKCollapse_HCZShape3SharedDelays:
                dc.b    $1C,   4,   8,  $C, $10, $14, $18,   2,   6,  $A,  $E, $12, $16, $1A, $1E
SKCollapse_HCZFourthShapeForwardDelays:
                dc.b    $30, $2A, $24, $1E, $18, $12,  $C,   6, $2E, $28, $22, $1C, $16, $10,  $A,   4, $2C, $26, $20, $1A
                dc.b    $14,  $E,   8,   2
SKCollapse_HCZFourthShapeReverseDelays:
                dc.b    $30,   6,  $C, $12, $18, $1E, $24, $2A,   4,  $A, $10, $16, $1C, $22, $28, $2E,   2,   8,  $E, $14
                dc.b    $1A, $20, $26, $2C
SKCollapse_MGZWideAndFBZForwardDelays:
                dc.b    $40, $38, $30, $28, $20, $18, $10,   8, $3E, $36, $2E, $26, $1E, $16,  $E,   6, $3C, $34, $2C, $24
                dc.b    $1C, $14,  $C,   4, $3A, $32, $2A, $22, $1A, $12,  $A,   2
SKCollapse_MGZWideAndFBZReverseDelays:
                dc.b    $40,   8, $10, $18, $20, $28, $30, $38,   6,  $E, $16, $1E, $26, $2E, $36, $3E,   4,  $C, $14, $1C
                dc.b    $24, $2C, $34, $3C,   2,  $A, $12, $1A, $22, $2A, $32, $3A
SKCollapse_MGZNarrowForwardDelays:
                dc.b    $30, $28, $20, $18, $10,   8, $2E, $26, $1E, $16,  $E,   6, $2C, $24, $1C, $14,  $C,   4, $2A, $22
                dc.b    $1A, $12,  $A,   2
SKCollapse_MGZNarrowReverseDelays:
                dc.b    $30,   8, $10, $18, $20, $28,   6,  $E, $16, $1E, $26, $2E,   4,  $C, $14, $1C, $24, $2C,   2,  $A
                dc.b    $12, $1A, $22, $2A
SKCollapse_ICZBridgeForwardDelays:
                dc.b    $28, $24, $20, $1C, $18, $14, $10,  $C,   8,   4, $27, $23, $1F, $1B, $17, $13,  $F,  $B,   7,   3
                dc.b    $26, $22, $1E, $1A, $16, $12,  $E,  $A,   6,   2, $25, $21, $1D, $19, $15, $11,  $D,   9,   5,   1
                dc.b    4,   3,   2,   1
SKCollapse_ICZBridgeReverseDelays:
                dc.b    $28,   4,   8,  $C, $10, $14, $18, $1C, $20, $24,   3,   7,  $B,  $F, $13, $17, $1B, $1F, $23, $27
                dc.b    2,   6,  $A,  $E, $12, $16, $1A, $1E, $22, $26,   1,   5,   9,  $D, $11, $15, $19, $1D, $21, $25
                dc.b    1,   2,   3,   4
SKCollapse_SOZForwardFragmentDelays:
                dc.b    $20, $18, $10,   8, $1E, $16, $1C, $14, $1A, $12
SKCollapse_SOZReverseFragmentDelays:
                dc.b    $20,   8, $10, $18,   6,  $E,   4,  $C,   2,  $A
SKCollapse_HPZLRZForwardFragmentDelays:
                dc.b    $18, $12,  $C,   6, $16, $10,  $A,   4, $14,  $E,   8,   2
SKCollapse_HPZLRZReverseFragmentDelays:
                dc.b    $18,   6,  $C, $12,   4,  $A, $10, $16,   2,   8,  $E, $14,   0
SKCollapse_AIZPlatformSignedSlopeHeights:
                dc.b    $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F
                dc.b    $1F, $1F, $1E, $1E, $1D, $1D, $1C, $1C, $1B, $1B, $1A, $1A, $19, $19, $18, $18, $17, $17, $16, $16
                dc.b    $15, $15, $14, $14, $13, $13, $12, $12, $11, $11, $10, $10,  $F,  $F,  $E,  $E,  $E,  $E,  $E,  $E
                dc.b    $E,  $E,  $E,  $E
SKCollapse_ICZPlatformSignedSlopeHeights:
                dc.b    $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $2F
                dc.b    $2F, $2F, $2F, $2F, $2E, $2E, $2E, $2E, $2E, $2E, $2E, $2E, $2D, $2D, $2D, $2D, $2D, $2D, $2D, $2D
                dc.b    $2D, $2D, $2D, $2D, $2D, $2C, $2B, $2A
Map_LRZCollapsingPlatform:
                include "src/objects/shared/zones/lrz/mappings/collapsing_platform.s"
Map_HPZCollapsingBridge:
                include "src/objects/shared/zones/hpz/mappings/collapsing_bridge.s"
Map_FBZCollapsingBridge:
                include "src/objects/shared/zones/fbz/mappings/collapsing_bridge.s"
Map_SOZCollapsingBridge:
                include "src/objects/shared/zones/soz/mappings/collapsing_bridge.s"
