; Owner: objects/zones/fbz/sk
; Responsibility: Elevator movement, player riding and trigger state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZElevator:
                move.l  #SKFBZElevator_TickAndTrySpawn,(a0)

SKFBZElevator_TickAndTrySpawn:
                subq.w  #1,$30(a0)
                bpl.s   SKFBZElevator_CullSpawner
                move.w  #$5F,$30(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKFBZElevator_CullSpawner
                move.l  #SKFBZElevator_TickPlatformLifetime,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_FBZElevator,mappings(a1)
                move.w  #make_art_tile(ArtTile_FBZMisc2,2,0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.b  #$30,width_pixels(a1)
                move.b  #$20,height_pixels(a1)
                move.w  #$80,priority(a1)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                move.w  d0,$30(a1)
                move.w  #1,y_vel(a1)
                btst    #0,status(a0)
                bne.s   SKFBZElevator_CullSpawner
                neg.w   y_vel(a1)

SKFBZElevator_CullSpawner:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

SKFBZElevator_TickPlatformLifetime:
                subq.w  #1,$30(a0)
                bpl.s   SKFBZElevator_MoveAndResolveSolid
                move.w  #$7F00,x_pos(a0)

SKFBZElevator_MoveAndResolveSolid:
                move.w  y_vel(a0),d0
                add.w   d0,y_pos(a0)
                move.w  #$3B,d1
                move.w  #$10,d2
                move.w  x_pos(a0),d4
                lea     (SKFBZElevator_SurfaceHeights).l,a2
                jsr     (CollidePlayersWithHeightProfileSolid).l
                tst.w   y_vel(a0)
                bmi.s   SKFBZElevator_DrawAndCull
                jsr     (CheckPlayerReleaseFromObj).l

SKFBZElevator_DrawAndCull:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
SKFBZElevator_SurfaceHeights:
                dc.b    $10, $10, $10, $10, $10, $10, $10, $11, $12, $12, $13, $13, $13, $14, $14, $14, $15, $15, $15, $16
                dc.b    $16, $16, $17, $17, $17, $18, $18, $18, $19, $19, $19, $1A, $1A, $1A, $1B, $1B, $1B, $1C, $1C, $1C
                dc.b    $1D, $1D, $1D, $1E, $1E, $1E, $1F, $1F, $1F, $20, $20, $20, $21, $21, $21, $21, $21, $21, $21, $21
                even
Map_FBZElevator:
                include "src/objects/shared/zones/fbz/mappings/elevator.s"
; End of function Obj_FBZElevator
