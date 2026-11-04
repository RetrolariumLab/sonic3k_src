; Owner: objects/zones/dez/sk
; Responsibility: Staircase activation, coordinated block movement and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZStaircase:
                ori.b   #4,render_flags(a0)
                move.b  subtype(a0),d0
                andi.w  #7,d0
                cmpi.w  #4,d0
                blo.s   SKDEZStairs_TryMirrorStairs
                bchg    #0,render_flags(a0)

SKDEZStairs_TryMirrorStairs:
                btst    #1,render_flags(a0)
                beq.s   SKDEZStairs_SelectOffsetSlotOrder
                bchg    #0,render_flags(a0)

SKDEZStairs_SelectOffsetSlotOrder:
                moveq   #$34,d3
                moveq   #2,d4
                btst    #0,status(a0)
                beq.s   SKDEZStairs_BeginBlockSetup
                moveq   #$3A,d3
                moveq   #-2,d4

SKDEZStairs_BeginBlockSetup:
                move.w  x_pos(a0),d2
                movea.l a0,a1
                moveq   #3,d1
                bra.s   SKDEZStairs_InitBlockAndOffsetSlot
; ---------------------------------------------------------------------------

SKDEZStairs_TryAllocNextBlock:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKDEZStairs_InitRootPhaseDispatch
                move.l  #SKDEZStairs_PlaceBlockAndCollectContacts,(a1)

SKDEZStairs_InitBlockAndOffsetSlot:
                move.l  #Map_DEZTiltingBridge,mappings(a1)
                move.w  #make_art_tile(ArtTile_DEZMisc+$133,1,0),art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.w  #$180,priority(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.b  subtype(a0),subtype(a1)
                move.w  d2,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  x_pos(a0),$44(a1)
                move.w  y_pos(a1),$46(a1)
                addi.w  #$20,d2
                move.b  d3,$33(a1)
                move.w  a0,$3E(a1)
                add.b   d4,d3
                dbf     d1,SKDEZStairs_TryAllocNextBlock

SKDEZStairs_InitRootPhaseDispatch:
                move.l  #SKDEZStairs_DispatchPhase,(a0)

SKDEZStairs_DispatchPhase:
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.w  #7,d0
                add.w   d0,d0
                move.w  SKDEZStairs_PhaseOffsets(pc,d0.w),d1
                jsr     SKDEZStairs_PhaseOffsets(pc,d1.w)

SKDEZStairs_PlaceBlockAndCollectContacts:
                movea.w $3E(a0),a2
                moveq   #0,d0
                move.b  $33(a0),d0
                move.w  (a2,d0.w),d0
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                move.w  #$1B,d1
                move.w  #$10,d2
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                swap    d6
                or.b    d6,$32(a2)
                move.w  $44(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
SKDEZStairs_PhaseOffsets:
                dc.w    SKDEZStairs_WaitForSideContact-SKDEZStairs_PhaseOffsets
                dc.w    SKDEZStairs_LowerStepOffsets-SKDEZStairs_PhaseOffsets
                dc.w    SKDEZStairs_WaitForTopContact-SKDEZStairs_PhaseOffsets
                dc.w    SKDEZStairs_LowerStepOffsets-SKDEZStairs_PhaseOffsets
                dc.w    SKDEZStairs_WaitForSideContact-SKDEZStairs_PhaseOffsets
                dc.w    SKDEZStairs_RaiseStepOffsets-SKDEZStairs_PhaseOffsets
                dc.w    SKDEZStairs_WaitForTopContact-SKDEZStairs_PhaseOffsets
                dc.w    SKDEZStairs_RaiseStepOffsets-SKDEZStairs_PhaseOffsets
; ---------------------------------------------------------------------------

SKDEZStairs_WaitForSideContact:
                tst.w   $30(a0)
                bne.s   SKDEZStairs_TickSideContactDelay
                move.b  $32(a0),d0
                andi.b  #$30,d0
                beq.s   SKDEZStairs_SideDelayReturn
                move.w  #30,$30(a0)

SKDEZStairs_SideDelayReturn:
                rts
; ---------------------------------------------------------------------------

SKDEZStairs_TickSideContactDelay:
                subq.w  #1,$30(a0)
                bne.s   SKDEZStairs_SideDelayReturn
                addq.b  #1,subtype(a0)
                moveq   #signextendB(sfx_FanBig),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

SKDEZStairs_WaitForTopContact:
                tst.w   $30(a0)
                bne.s   SKDEZStairs_TickTopContactDelay
                move.b  $32(a0),d0
                andi.b  #$C,d0
                beq.s   SKDEZStairs_TopWaitReturn
                move.w  #$3C,$30(a0)

SKDEZStairs_TopWaitReturn:
                rts
; ---------------------------------------------------------------------------

SKDEZStairs_TickTopContactDelay:
                subq.w  #1,$30(a0)
                bne.s   SKDEZStairs_WriteShakeOffsets
                addq.b  #1,subtype(a0)
                moveq   #signextendB(sfx_FanBig),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

SKDEZStairs_WriteShakeOffsets:
                lea     $34(a0),a1
                move.w  $30(a0),d0
                lsr.b   #2,d0
                andi.b  #1,d0
                move.w  d0,(a1)+
                eori.b  #1,d0
                move.w  d0,(a1)+
                eori.b  #1,d0
                move.w  d0,(a1)+
                eori.b  #1,d0
                move.w  d0,(a1)+
                rts
; ---------------------------------------------------------------------------

SKDEZStairs_LowerStepOffsets:
                lea     $34(a0),a1
                cmpi.w  #$80,(a1)
                beq.s   SKDEZStairs_LoweringReturn
                addq.w  #1,(a1)
                moveq   #0,d1
                move.w  (a1)+,d1
                swap    d1
                lsr.l   #1,d1
                move.l  d1,d2
                lsr.l   #1,d1
                move.l  d1,d3
                add.l   d2,d3
                swap    d1
                swap    d2
                swap    d3
                move.w  d3,(a1)+
                move.w  d2,(a1)+
                move.w  d1,(a1)+

SKDEZStairs_LoweringReturn:
                rts
; ---------------------------------------------------------------------------

SKDEZStairs_RaiseStepOffsets:
                lea     $34(a0),a1
                cmpi.w  #-$80,(a1)
                beq.s   SKDEZStairs_RaisingReturn
                subq.w  #1,(a1)
                moveq   #0,d1
                move.w  (a1)+,d1
                swap    d1
                asr.l   #1,d1
                move.l  d1,d2
                asr.l   #1,d1
                move.l  d1,d3
                add.l   d2,d3
                swap    d1
                swap    d2
                swap    d3
                move.w  d3,(a1)+
                move.w  d2,(a1)+
                move.w  d1,(a1)+

SKDEZStairs_RaisingReturn:
                rts
