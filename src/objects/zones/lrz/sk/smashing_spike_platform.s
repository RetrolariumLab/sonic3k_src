; Owner: objects/zones/lrz/sk
; Responsibility: Smashing spike-platform movement, player collision and damage
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZSmashingSpikePlatform:
                move.l  #Map_LRZSmashingSpikePlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZMisc,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.w  y_pos(a0),$46(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                move.w  d0,$38(a0)
                move.l  #SKLRZSpikeSlam_DropAndCheckBottom,(a0)

; Integrate the old Y velocity into displacement before using the new velocity
SKLRZSpikeSlam_DropAndCheckBottom:
                tst.b   $32(a0)
                bne.s   SKLRZSpikeSlam_TickBottomHold
                move.w  y_vel(a0),d0
                addi.w  #$40,y_vel(a0)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,$34(a0)
                move.w  $34(a0),d2
                cmp.w   $38(a0),d2
                blo.w   SKLRZSpikeSlam_PlaceAndCheckSolid
                clr.w   y_vel(a0)
                move.w  $38(a0),$34(a0)
                move.b  #1,$32(a0)
                move.w  #30,$3A(a0)
                move.b  #0,anim_frame(a0)
                tst.b   render_flags(a0)
                bpl.s   SKLRZSpikeSlam_PlaceAndCheckSolid
                moveq   #signextendB(sfx_Crash),d0
                jsr     (Play_SFX).l
                bra.s   SKLRZSpikeSlam_PlaceAndCheckSolid
; ---------------------------------------------------------------------------

SKLRZSpikeSlam_TickBottomHold:
                tst.w   $3A(a0)
                beq.s   SKLRZSpikeSlam_RetractAndToggleFrame
                subq.w  #1,$3A(a0)
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                move.b  SKLRZSpikeSlam_BottomHoldFrames(pc,d0.w),mapping_frame(a0)
                beq.s   SKLRZSpikeSlam_PlaceAndCheckSolid
                addq.b  #1,anim_frame(a0)
                bra.s   SKLRZSpikeSlam_PlaceAndCheckSolid
; ---------------------------------------------------------------------------
SKLRZSpikeSlam_BottomHoldFrames:
                dc.b    2,   4,   6,   7,   7,   7,   7,   6,   6,   5,   5,   4,   4,   3,   3,   2,   2,   1,   1,   0
                even
; ---------------------------------------------------------------------------

SKLRZSpikeSlam_RetractAndToggleFrame:
                move.w  $34(a0),d2
                beq.s   SKLRZSpikeSlam_ResetDropState
                subq.w  #1,d2
                move.w  d2,$34(a0)
                addq.b  #8,mapping_frame(a0)
                andi.b  #8,mapping_frame(a0)
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$1F,d0
                bne.s   SKLRZSpikeSlam_PlaceAndCheckSolid
                moveq   #signextendB(sfx_Blast),d0
                jsr     (Play_SFX).l
                bra.s   SKLRZSpikeSlam_PlaceAndCheckSolid
; ---------------------------------------------------------------------------

SKLRZSpikeSlam_ResetDropState:
                move.b  #0,$32(a0)
                move.b  #0,mapping_frame(a0)

SKLRZSpikeSlam_PlaceAndCheckSolid:
                move.w  $46(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.b  mapping_frame(a0),d0
                andi.w  #7,d0
                sub.w   d0,d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                swap    d6
                andi.w  #4|8,d6
                bne.s   SKLRZSpikeSlam_TryHurtP1
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKLRZSpikeSlam_TryHurtP1:
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   SKLRZSpikeSlam_TryHurtP2
                lea     (Player_1).w,a1
                jsr     (HurtPlayerFromSolidHazard).l

SKLRZSpikeSlam_TryHurtP2:
                andi.b  #8,d6
                beq.s   SKLRZSpikeSlam_DrawPlatform
                lea     (Player_2).w,a1
                jsr     (HurtPlayerFromSolidHazard).l

SKLRZSpikeSlam_DrawPlatform:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_LRZSmashingSpikePlatform:
                include "src/objects/shared/zones/lrz/mappings/smashing_spike_platform.s"
; End of function Obj_LRZSmashingSpikePlatform
