; Owner: objects/zones/lrz/sk
; Responsibility: Collapsing bridge segment creation, player contact, timed collapse and fragments
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZCollapsingBridge:
                move.l  #SKLRZBridge_CheckCollapseDelay,(a0)
                move.b  #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.l  #Map_LRZCollapsingBridge,mappings(a0)
                move.w  #make_art_tile($0D3,2,1),art_tile(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$F,d0
                lsl.w   #4,d0
                addq.w  #8,d0
                move.b  d0,$30(a0)
                andi.w  #$F0,d1
                lsr.w   #2,d1
                lea     SKLRZBridge_BridgeAttributes(pc,d1.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,subtype(a0)
                move.b  #$1C,y_radius(a0)
                bra.s   SKLRZBridge_CheckCollapseDelay
; ---------------------------------------------------------------------------
SKLRZBridge_BridgeAttributes:
                dc.b    $40
                dc.b    $20
                dc.b    8
                dc.b    0
                even
; ---------------------------------------------------------------------------

SKLRZBridge_CheckCollapseDelay:
                tst.b   $32(a0)
                beq.s   SKLRZBridge_CheckStandingLatch
                tst.b   $30(a0)
                bne.s   SKLRZBridge_TickCollapseDelay
                bra.w   SKLRZBridge_BeginCollapse
; ---------------------------------------------------------------------------

SKLRZBridge_TickCollapseDelay:
                subq.b  #1,$30(a0)

SKLRZBridge_CheckStandingLatch:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   SKLRZBridge_CheckIntactSolidAndDraw
                move.b  #1,$32(a0)

SKLRZBridge_CheckIntactSolidAndDraw:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #0,d3
                move.b  y_radius(a0),d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

; Keep an invisible top surface for 42 updates after spawning the visible fragments
SKLRZBridge_TickTemporarySolid:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #0,d3
                move.b  y_radius(a0),d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                subq.b  #1,$30(a0)
                bne.s   SKLRZBridge_ProxyReturn
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   ReleasePlayerFromCollapsedLrzBridge
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.s   ReleasePlayerFromCollapsedLrzBridge
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

ReleasePlayerFromCollapsedLrzBridge:
                btst    d6,status(a0)
                beq.s   SKLRZBridge_ProxyReturn
                bclr    d6,status(a0)
                bclr    #Status_OnObj,status(a1)
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,prev_anim(a1)

SKLRZBridge_ProxyReturn:
                rts
; End of function ReleasePlayerFromCollapsedLrzBridge

; ---------------------------------------------------------------------------

SKLRZBridge_TickFragmentDelay:
                tst.b   $30(a0)
                beq.s   SKLRZBridge_TickFragmentFrames
                subq.b  #1,$30(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKLRZBridge_TickFragmentFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKLRZBridge_FallAndDrawVisible
                move.b  #7,anim_frame_timer(a0)
                move.b  mapping_frame(a0),d0
                addq.b  #1,d0
                andi.b  #3,d0
                add.b   $34(a0),d0
                move.b  d0,mapping_frame(a0)

SKLRZBridge_FallAndDrawVisible:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bpl.s   SKLRZBridge_DeleteFragment
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKLRZBridge_DeleteFragment:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKLRZBridge_BeginCollapse:
                move.b  #$2A,$30(a0)
                lea     (SKLRZBridge_FragmentRecords).l,a3
                move.l  #SKLRZBridge_TickTemporarySolid,(a0)
                move.l  #SKLRZBridge_TickFragmentDelay,d4
                move.w  (a3)+,d1
                move.b  render_flags(a0),d5
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3

SKLRZBridge_TrySpawnFragment:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKLRZBridge_ClearPlacementRespawn
                move.l  d4,(a1)
                move.l  mappings(a0),mappings(a1)
                move.b  d5,render_flags(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d3,d0
                move.w  d0,y_pos(a1)
                move.b  (a3)+,mapping_frame(a1)
                move.w  art_tile(a0),art_tile(a1)
                ori.w   #high_priority,art_tile(a1)
                move.w  #$80,priority(a1)
                move.b  #$20,width_pixels(a1)
; Bug: This only covers the width, when it
; should be covering the height as the width
; has already been defined
                move.b  #$20,width_pixels(a1)
                move.b  (a3)+,$30(a1)
                move.b  mapping_frame(a1),d0
                andi.b  #$FC,d0
                move.b  d0,$34(a1)
                dbf     d1,SKLRZBridge_TrySpawnFragment

SKLRZBridge_ClearPlacementRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   SKLRZBridge_PlayCollapseSound
                movea.w d0,a1
                bclr    #7,(a1)
                clr.w   respawn_addr(a0)

SKLRZBridge_PlayCollapseSound:
                moveq   #signextendB(sfx_Collapse),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------
SKLRZBridge_FragmentRecords:    dc.w    $16-1
                dc.b    -$20,   4,   7, $24
                dc.b    0,   8,   6, $20
                dc.b    $20,   4,   6, $22
                dc.b    -$30,-$10,   7, $2C
                dc.b    -$10,-$10,   6, $28
                dc.b    $10,-$10,   7, $2A
                dc.b    $30,-$10,   6, $26
                dc.b    -$20,-$18,   0, $1E
                dc.b    $20,-$18,   1, $1C
                dc.b    -$38,   0,   0, $1A
                dc.b    $38,   0,   1, $18
                dc.b    -$30, $10,   0, $12
                dc.b    $30, $10,   1, $10
                dc.b    -$18, $10,   0,  $E
                dc.b    $18, $10,   1,  $C
                dc.b    -$A, $14,   0,  $A
                dc.b    $A, $14,   1,   8
                dc.b    0, $18,   0,   6
                dc.b    -$20, $18,   0,   2
                dc.b    $20, $18,   1,   4
                dc.b    -$2C,  $C,   4, $16
                dc.b    $2C,  $C,   5, $14
Map_LRZCollapsingBridge:
                include "src/objects/shared/zones/lrz/mappings/collapsing_bridge.s"
