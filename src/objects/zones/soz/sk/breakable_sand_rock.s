; Owner: objects/zones/soz/sk
; Responsibility: Breakable sand rock collision, fracture response and fragments
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZBreakableSandRock:
                move.l  #Map_SOZBreakableSandRock,mappings(a0)
                move.w  #make_art_tile(ArtTile_SOZMisc+$10,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.l  #SKSOZSandRock_SaveAnimsAndCheckSolid,(a0)

SKSOZSandRock_SaveAnimsAndCheckSolid:
                move.b  (Player_1+anim).w,$30(a0)
                move.b  (Player_2+anim).w,$31(a0)
                move.w  #$23,d1
                move.w  #$10,d2
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   SKSOZSandRock_CheckBreakWithBothRiders

SKSOZSandRock_DrawIntactRock:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

; With both players standing, either rider's roll can break the rock
SKSOZSandRock_CheckBreakWithBothRiders:
                cmpi.b  #$18,d0
                bne.s   SKSOZSandRock_TryBreakWithP1
                cmpi.b  #2,$30(a0)
                beq.s   SKSOZSandRock_ReleaseBothRiders
                cmpi.b  #2,$31(a0)
                bne.s   SKSOZSandRock_DrawIntactRock

SKSOZSandRock_ReleaseBothRiders:
                lea     (Player_1).w,a1
                move.b  $30(a0),d0
                bsr.s   ReleasePlayerFromBreakingSozSandRock
                lea     (Player_2).w,a1
                move.b  $31(a0),d0
                bsr.s   ReleasePlayerFromBreakingSozSandRock
                bra.w   SKSOZSandRock_ClearRidersAndDissolve
; ---------------------------------------------------------------------------

SKSOZSandRock_TryBreakWithP1:
                move.b  d0,d1
                andi.b  #8,d1
                beq.s   SKSOZSandRock_TryBreakWithP2
                cmpi.b  #2,$30(a0)
                bne.s   SKSOZSandRock_DrawIntactRock
                lea     (Player_1).w,a1
                bsr.s   ReboundRollingPlayerFromSozSandRock
                bra.s   SKSOZSandRock_ClearRidersAndDissolve

; =============== S U B R O U T I N E =======================================

ReleasePlayerFromBreakingSozSandRock:
                cmpi.b  #2,d0
                bne.s   SKSOZSandRock_SetRiderAirborne
; End of function ReleasePlayerFromBreakingSozSandRock

; =============== S U B R O U T I N E =======================================

ReboundRollingPlayerFromSozSandRock:
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.w  #-$300,y_vel(a1)

SKSOZSandRock_SetRiderAirborne:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #2,routine(a1)
                rts
; End of function ReboundRollingPlayerFromSozSandRock

; ---------------------------------------------------------------------------

SKSOZSandRock_TryBreakWithP2:
                andi.b  #$10,d0
                beq.w   SKSOZSandRock_DrawIntactRock
                cmpi.b  #2,$31(a0)
                bne.w   SKSOZSandRock_DrawIntactRock
                lea     (Player_2).w,a1
                bsr.s   ReboundRollingPlayerFromSozSandRock

SKSOZSandRock_ClearRidersAndDissolve:
                andi.b  #$E7,status(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                move.l  #SKSOZSandRock_TickDissolve,(a0)

SKSOZSandRock_TickDissolve:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKSOZSandRock_DrawDissolvingRock
                move.b  #5,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #5,mapping_frame(a0)
                blo.s   SKSOZSandRock_DrawDissolvingRock
                move.w  #$7F00,x_pos(a0)

SKSOZSandRock_DrawDissolvingRock:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_SOZBreakableSandRock:
                include "src/objects/shared/zones/soz/mappings/breakable_sand_rock.s"
; End of function SKSOZSandRock_TryBreakWithP2
