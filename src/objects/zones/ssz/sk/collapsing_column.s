; Owner: objects/zones/ssz/sk
; Responsibility: Collapsing column activation, fragments and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SSZCollapsingColumn:
                move.l  #SKSSZColumn_TryBreakUnderRiders,(a0)
                move.b  #4,render_flags(a0)
                move.b  #1,routine(a0)
                move.b  #$21,height_pixels(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$180,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$10,3,1),art_tile(a0)
                move.l  #Map_SSZFloatingPlatform,mappings(a0)
                move.b  #2,mapping_frame(a0)
                move.w  y_pos(a0),y_vel(a0)
                jsr     (Random_Number).l
                andi.w  #$1FFF,d0
                addi.w  #$800,d0
                move.w  d0,$30(a0)

SKSSZColumn_TryBreakUnderRiders:
                move.b  status(a0),d0
                andi.w  #standing_mask,d0
                beq.s   SKSSZColumn_CheckAttachedShardCount
                clr.b   routine(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKSSZColumn_HideRootAfterSpawning
                lea     SKSSZColumn_ShardRecords(pc),a2
                move.w  x_pos(a0),d1
                moveq   #8-1,d2

SKSSZColumn_SpawnAndCountShard:
                move.l  #SKSSZColumn_InitShardAndUpdate,(a1)
                move.w  a0,$2E(a1)
                move.w  (a2)+,d3
                add.w   d1,d3
                move.w  d3,x_pos(a1)
                move.w  (a2)+,$30(a1)
                move.w  (a2)+,$32(a1)
                move.w  (a2)+,d3
                move.b  d3,mapping_frame(a1)
                addq.b  #1,routine(a0)
                jsr     (CreateNewSprite4).l
                dbne    d2,SKSSZColumn_SpawnAndCountShard

SKSSZColumn_HideRootAfterSpawning:
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                clr.b   mapping_frame(a0)
                move.l  #SKSSZColumn_CheckAttachedShardCount,(a0)

SKSSZColumn_CheckAttachedShardCount:
                tst.b   routine(a0)
                beq.s   SKSSZColumn_MoveEmptyRootOffscreen
                bpl.s   SKSSZColumn_MoveAndCheckTopSolid

SKSSZColumn_MoveEmptyRootOffscreen:
                move.w  #$7FFF,x_pos(a0)

SKSSZColumn_MoveAndCheckTopSolid:
                move.l  #$2800,d0
                move.l  #$80,d1
                jsr     Gradual_SwingOffset(pc)
                add.w   $1A(a0),d0
                move.w  d0,y_pos(a0)
                moveq   #$1B,d1
                moveq   #$21,d2
                moveq   #$21,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKSSZColumn_InitShardAndUpdate:
                move.l  #SKSSZColumn_CullShardAndCheckDetach,(a0)
                move.b  #$84,render_flags(a0)
                move.b  #8,height_pixels(a0)
                move.b  #8,width_pixels(a0)
                move.w  #$200,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$10,3,1),art_tile(a0)
                move.l  #Map_SSZFloatingPlatform,mappings(a0)

; On offscreen deletion, decrement the root count only if the detach timer is still positive
SKSSZColumn_CullShardAndCheckDetach:
                movea.w $2E(a0),a1
                tst.b   render_flags(a0)
                bmi.s   SKSSZColumn_TickDetachOrFall
                tst.w   $32(a0)
                beq.s   SKSSZColumn_DeleteShard
                bmi.s   SKSSZColumn_DeleteShard
                subq.b  #1,routine(a1)

SKSSZColumn_DeleteShard:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSSZColumn_TickDetachOrFall:
                subq.w  #1,$32(a0)
                bpl.s   SKSSZColumn_TryCountShardDetached
                move.w  y_pos(a0),d0
                addi.l  #$3800,$34(a0)
                add.w   $34(a0),d0
                bra.s   SKSSZColumn_ApplyShardYAndDraw
; ---------------------------------------------------------------------------

SKSSZColumn_TryCountShardDetached:
                bne.s   SKSSZColumn_FollowRootY
                subq.b  #1,routine(a1)

SKSSZColumn_FollowRootY:
                move.w  y_pos(a1),d0
                add.w   $30(a0),d0

SKSSZColumn_ApplyShardYAndDraw:
                move.w  d0,y_pos(a0)
                jmp     (Draw_Sprite).l
; End of function Obj_SSZCollapsingColumn
