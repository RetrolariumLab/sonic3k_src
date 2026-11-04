; Owner: objects/zones/dez/sk
; Responsibility: Gravity puzzle state, coordinated sprites and player interactions
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZGravityPuzzle:
                move.l  #Map_DEZGravityPuzzle,mappings(a0)
                move.w  #make_art_tile(ArtTile_DEZMisc2+$31,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$30,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.w  y_pos(a0),$46(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKDEZGravPuzzle_InitPuzzleUpdate
                move.l  #Sprite_OnScreen_Test,(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.b  #$20,width_pixels(a1)
                move.b  #$30,height_pixels(a1)
                move.w  #$200,priority(a1)
                bset    #6,render_flags(a1)
                move.w  x_pos(a0),d2
                move.w  d2,x_pos(a1)
                move.w  y_pos(a0),d3
                move.w  d3,y_pos(a1)
                move.b  (MHZ_pollen_counter).w,d4
                lea     sub2_x_pos(a1),a2
                lea     SKDEZGravPuzzle_PanelOffsetFrameTriplets(pc),a3
                moveq   #6,d1
                move.w  d1,mainspr_childsprites(a1)
                subq.w  #1,d1

SKDEZGravPuzzle_InitCompositePanel:
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d2,d0
                move.w  d0,(a2)+
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d3,d0
                move.w  d0,(a2)+
                addq.w  #1,a2
                move.b  (a3)+,(a2)+
                lsr.b   #1,d4
                bcc.s   SKDEZGravPuzzle_NextPanelOrSaveHandle
                subq.b  #2,-1(a2)

SKDEZGravPuzzle_NextPanelOrSaveHandle:
                dbf     d1,SKDEZGravPuzzle_InitCompositePanel
                move.w  a1,$3E(a0)

SKDEZGravPuzzle_InitPuzzleUpdate:
                move.l  #SKDEZGravPuzzle_BobAndPlacePanels,(a0)

SKDEZGravPuzzle_BobAndPlacePanels:
                move.b  angle(a0),d0
                addq.b  #1,angle(a0)
                jsr     (GetSineCosine).l
                asr.w   #2,d0
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                movea.w $3E(a0),a2
                lea     sub2_y_pos(a2),a3
                lea     SKDEZGravPuzzle_PanelOffsetFrameTriplets+1(pc),a4
                moveq   #6-1,d1

SKDEZGravPuzzle_SetPanelY:
                move.b  (a4),d2
                ext.w   d2
                add.w   d0,d2
                move.w  d2,(a3)+
                addq.w  #4,a3
                addq.w  #3,a4
                dbf     d1,SKDEZGravPuzzle_SetPanelY
                move.w  #$23,d1
                move.w  #$30,d2
                move.w  #$31,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull2).l
                swap    d6
                andi.w  #1|2,d6
                beq.s   SKDEZGravPuzzle_DrawPuzzleRoot
                move.w  d6,d0
                andi.w  #1,d0
                beq.s   SKDEZGravPuzzle_MarkAndBounceP2
                lea     (Player_1).w,a1
                bsr.s   MarkTouchedDezGravityPuzzlePanel
                moveq   #p1_pushing_bit,d5
                bsr.s   BouncePlayerFromDezGravityPuzzle

SKDEZGravPuzzle_MarkAndBounceP2:
                andi.w  #2,d6
                beq.s   SKDEZGravPuzzle_DrawPuzzleRoot
                bsr.s   MarkTouchedDezGravityPuzzlePanel
                lea     (Player_2).w,a1
                moveq   #p2_pushing_bit,d5
                bsr.s   BouncePlayerFromDezGravityPuzzle

SKDEZGravPuzzle_DrawPuzzleRoot:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

BouncePlayerFromDezGravityPuzzle:
                moveq   #signextendB(sfx_TunnelBooster),d0
                jsr     (Play_SFX).l
                bra.w   SKDEZBumperWall_LaunchAwayFromBumper
; End of function BouncePlayerFromDezGravityPuzzle

; =============== S U B R O U T I N E =======================================

MarkTouchedDezGravityPuzzlePanel:
                moveq   #0,d1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcs.s   SKDEZGravPuzzle_ClampPanelMinY
                moveq   #3,d1

SKDEZGravPuzzle_ClampPanelMinY:
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$30,d0
                bpl.s   SKDEZGravPuzzle_ClampPanelMaxY
                moveq   #0,d0

SKDEZGravPuzzle_ClampPanelMaxY:
                cmpi.w  #$60,d0
                blo.s   SKDEZGravPuzzle_MarkPanelAndSetFrame
                moveq   #$40,d0

SKDEZGravPuzzle_MarkPanelAndSetFrame:
                lsr.w   #5,d0
                add.w   d1,d0
                bset    d0,(MHZ_pollen_counter).w
                movea.w $3E(a0),a2
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                add.w   d0,d0
                addi.w  #$1D,d0
                cmpi.b  #3,(a2,d0.w)
                blo.s   SKDEZGravPuzzle_MarkPanelReturn
                subq.b  #2,(a2,d0.w)

SKDEZGravPuzzle_MarkPanelReturn:
                rts
; End of function MarkTouchedDezGravityPuzzlePanel

; ---------------------------------------------------------------------------
SKDEZGravPuzzle_PanelOffsetFrameTriplets:
                dc.b    -$1C,-$20
                dc.b    3,-$1C
                dc.b    0,   3
                dc.b    -$1C, $20
                dc.b    3, $1C
                dc.b    -$20,   4
                dc.b    $1C,   0
                dc.b    4, $1C
                dc.b    $20,   4
                even
Map_DEZGravityPuzzle:
                include "src/objects/shared/zones/dez/mappings/gravity_puzzle.s"
