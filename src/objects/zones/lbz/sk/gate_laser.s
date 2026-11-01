; Owner: objects/zones/lbz/sk
; Responsibility: Launch Base gate laser activation, collision and sprite state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZGateLaser:
                move.l  #Map_LBZGateLaser,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,2,0),art_tile(a0)
                move.b  #$1C,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$180,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                andi.w  #$F,d0
                lsl.w   #3,d0
                add.w   y_pos(a0),d0
                move.w  d0,$2E(a0)
                lsr.b   #1,d1
                andi.w  #$78,d1
                addq.w  #8,d1
                move.w  d1,$32(a0)
                move.l  #loc_29386,(a0)

loc_29386:
                subq.w  #1,$30(a0)
                bpl.s   loc_293CA
                move.w  $32(a0),$30(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_293CA
                bsr.s   InitializeLbzGateLaserSegment
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_293CA
                bsr.s   InitializeLbzGateLaserSegment
                move.w  #$80,priority(a1)
                move.b  #2,mapping_frame(a1)
                move.b  #$98,collision_flags(a1)
                move.l  #loc_29416,(a1)
                moveq   #signextendB(sfx_EnergyZap),d0
                jsr     (Play_SFX).l

loc_293CA:
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

InitializeLbzGateLaserSegment:
                move.l  #loc_2941C,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  $2E(a0),$2E(a1)
                move.l  #Map_LBZGateLaser,mappings(a1)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,2,0),art_tile(a1)
                move.b  #$1C,width_pixels(a1)
                move.b  #4,height_pixels(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.b  #1,mapping_frame(a1)
                move.w  #$180,priority(a1)
                rts
; End of function InitializeLbzGateLaserSegment

; ---------------------------------------------------------------------------

loc_29416:
                jsr     (Add_SpriteToCollisionResponseList).l

loc_2941C:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                bne.s   loc_2942C
                bchg    #1,render_flags(a0)

loc_2942C:
                move.w  y_pos(a0),d0
                addq.w  #4,y_pos(a0)
                cmp.w   $2E(a0),d0
                blo.s   loc_29440
                move.w  #$7FF0,x_pos(a0)

loc_29440:
                jmp     (Sprite_OnScreen_Test).l
