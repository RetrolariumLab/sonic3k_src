; Owner: objects/zones/soz/sk
; Responsibility: Sand-block spawning, block motion, collision and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SOZSpawningSandBlocks:
                move.l  #Map_SOZSpawningSandBlocks,mappings(a0)
                move.w  #make_art_tile(ArtTile_SOZTile,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.w  #$200,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                add.w   d0,x_pos(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                move.w  $44(a0),$30(a0)
                andi.w  #$FF80,d0
                addi.w  #$300,d0
                move.w  d0,$32(a0)
                move.l  #SKSOZSandBlocks_WaitForOscillatorZero,(a0)

SKSOZSandBlocks_WaitForOscillatorZero:
                tst.w   $34(a0)
                beq.s   SKSOZSandBlocks_BobEmitterAndTrySpawn
                subq.w  #1,$34(a0)
                bne.w   SKSOZSandBlocks_SpawnReturn
                tst.b   (Oscillating_table+$16).w
                beq.s   SKSOZSandBlocks_BobEmitterAndTrySpawn
                move.w  #1,$34(a0)
                subq.w  #1,$36(a0)
                bra.w   SKSOZSandBlocks_SpawnReturn
; ---------------------------------------------------------------------------

SKSOZSandBlocks_BobEmitterAndTrySpawn:
                moveq   #0,d0
                move.b  (Oscillating_table+$16).w,d0
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                bsr.s   SpawnSozTimedSandBlock
                bra.w   SKSOZSandBlocks_CullAtEmitterOrigin

; =============== S U B R O U T I N E =======================================

SpawnSozTimedSandBlock:
                subq.w  #1,$36(a0)
                bpl.s   SKSOZSandBlocks_SpawnReturn
                move.w  #$7F,$36(a0)
                jsr     (AllocateObject).l
                bne.w   SKSOZSandBlocks_ArmOscillatorPause
                move.l  #SKSOZSandBlocks_FallAndTryFloorProbe,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.w  #$280,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$C,height_pixels(a1)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #4,d0
                move.w  d0,$34(a1)
                move.w  $30(a0),$30(a1)
                move.w  $32(a0),$32(a1)

; Wait for the oscillator to reach zero even if allocation failed
SKSOZSandBlocks_ArmOscillatorPause:
                move.w  #1,$34(a0)

SKSOZSandBlocks_SpawnReturn:
                rts
; End of function SpawnSozTimedSandBlock

; ---------------------------------------------------------------------------

SKSOZSandBlocks_FallAndTryFloorProbe:
                move.w  x_pos(a0),-(sp)
                jsr     (MoveSprite).l
                cmpi.w  #$200,y_vel(a0)
                blt.s   SKSOZSandBlocks_RestorePreMoveX
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKSOZSandBlocks_RestorePreMoveX
                add.w   d1,y_pos(a0)
                move.l  #SKSOZSandBlocks_TickSlideAndTrySink,(a0)
                move.w  #-$100,x_vel(a0)
                move.w  #0,y_vel(a0)

SKSOZSandBlocks_RestorePreMoveX:
                move.w  (sp)+,d4

SKSOZSandBlocks_CheckTopSolidAndDraw:
                move.w  #$18,d1
                move.w  #$D,d3
                jsr     (SolidObjectTop).l

SKSOZSandBlocks_CullAtEmitterOrigin:
                move.w  $30(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmp.w   $32(a0),d0
                bhi.w   SKSOZSandBlocks_ClearPlacementRespawnBit
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSOZSandBlocks_ClearPlacementRespawnBit:
                move.w  respawn_addr(a0),d0
                beq.s   SKSOZSandBlocks_DeleteActor
                movea.w d0,a2
                bclr    #7,(a2)

SKSOZSandBlocks_DeleteActor:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSOZSandBlocks_TickSlideAndTrySink:
                subq.w  #1,$34(a0)
                bne.s   SKSOZSandBlocks_SlideAndFollowFloor
                move.w  y_pos(a0),$46(a0)
                move.w  #0,x_vel(a0)
                move.l  #SKSOZSandBlocks_SinkAndCheckDepth,(a0)

SKSOZSandBlocks_SlideAndFollowFloor:
                move.w  x_pos(a0),-(sp)
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                add.w   d1,y_pos(a0)
                move.w  (sp)+,d4
                bra.s   SKSOZSandBlocks_CheckTopSolidAndDraw
; ---------------------------------------------------------------------------

SKSOZSandBlocks_SinkAndCheckDepth:
                jsr     (MoveSprite2).l
                addi.w  #8,y_vel(a0)
                move.w  $46(a0),d0
                addi.w  #$12,d0
                cmp.w   $14(a0),d0
                bhs.s   SKSOZSandBlocks_CheckSinkingTopSolid
                move.w  #$7F00,x_pos(a0)
                move.w  #$7F00,$30(a0)

SKSOZSandBlocks_CheckSinkingTopSolid:
                move.w  x_pos(a0),d4
                bra.w   SKSOZSandBlocks_CheckTopSolidAndDraw
; ---------------------------------------------------------------------------
Map_SOZSpawningSandBlocks:
                include "src/objects/shared/zones/soz/mappings/spawning_sand_blocks.s"
