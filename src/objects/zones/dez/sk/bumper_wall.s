; Owner: objects/zones/dez/sk
; Responsibility: Bumper wall player collision, bounce response and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_DEZBumperWall:
                move.l  #Map_DEZBumperWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_DEZMisc2+$31,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  subtype(a0),d0
                beq.s   SKDEZBumperWall_InitVisibleBumper
                bmi.s   SKDEZBumperWall_InitPuzzleBumper
                move.b  #8,width_pixels(a0)
                move.b  d0,height_pixels(a0)
                move.l  #SKDEZBumperWall_CheckInvisibleSolid,(a0)
                bra.s   SKDEZBumperWall_CheckInvisibleSolid
; ---------------------------------------------------------------------------

SKDEZBumperWall_InitVisibleBumper:
                move.l  #SKDEZBumperWall_CheckVisibleBumperSolid,(a0)
                bra.s   SKDEZBumperWall_CheckVisibleBumperSolid
; ---------------------------------------------------------------------------

SKDEZBumperWall_InitPuzzleBumper:
                move.l  #SKDEZBumperWall_TryRemoveSolvedBumper,(a0)

SKDEZBumperWall_TryRemoveSolvedBumper:
                cmpi.b  #$3F,(MHZ_pollen_counter).w
                bne.s   SKDEZBumperWall_CheckVisibleBumperSolid
                move.w  #$7F00,x_pos(a0)

SKDEZBumperWall_CheckVisibleBumperSolid:
                move.w  #$17,d1
                move.w  #$20,d2
                move.w  #$21,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull2).l
                swap    d6
                andi.w  #1|2,d6
                beq.s   SKDEZBumperWall_DrawVisibleBumper
                move.w  d6,d0
                andi.w  #1,d0
                beq.s   SKDEZBumperWall_TryBounceP2Visible
                lea     (Player_1).w,a1
                moveq   #p1_pushing_bit,d5
                bsr.s   BouncePlayerFromDezBumperWall

SKDEZBumperWall_TryBounceP2Visible:
                andi.w  #2,d6
                beq.s   SKDEZBumperWall_DrawVisibleBumper
                lea     (Player_2).w,a1
                moveq   #p2_pushing_bit,d5
                bsr.s   BouncePlayerFromDezBumperWall

SKDEZBumperWall_DrawVisibleBumper:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKDEZBumperWall_CheckInvisibleSolid:
                move.w  #$13,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull2).l
                swap    d6
                andi.w  #1|2,d6
                beq.s   SKDEZBumperWall_CullInvisibleBumper
                move.w  d6,d0
                andi.w  #1,d0
                beq.s   SKDEZBumperWall_TryBounceP2Invisible
                lea     (Player_1).w,a1
                moveq   #p1_pushing_bit,d5
                bsr.s   BouncePlayerFromDezBumperWall

SKDEZBumperWall_TryBounceP2Invisible:
                andi.w  #2,d6
                beq.s   SKDEZBumperWall_CullInvisibleBumper
                lea     (Player_2).w,a1
                moveq   #p2_pushing_bit,d5
                bsr.s   BouncePlayerFromDezBumperWall

SKDEZBumperWall_CullInvisibleBumper:
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

BouncePlayerFromDezBumperWall:
                moveq   #signextendB(sfx_Bumper),d0
                jsr     (Play_SFX).l

SKDEZBumperWall_LaunchAwayFromBumper:
                bclr    #Status_Facing,status(a1)
                move.w  #$C00,x_vel(a1)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcc.s   SKDEZBumperWall_ClearPushAndSetAirborne
                bset    #Status_Facing,status(a1)
                neg.w   x_vel(a1)

SKDEZBumperWall_ClearPushAndSetAirborne:
                bclr    d5,status(a0)
                bset    #Status_InAir,status(a1)
                bclr    #Status_Push,status(a1)
                move.b  #0,double_jump_flag(a1)
                bclr    #Status_RollJump,status(a1)
                clr.b   jumping(a1)
                move.w  #1,ground_vel(a1)
                tst.b   flip_angle(a1)
                bne.s   SKDEZBumperWall_StartContinuousFlip
                move.b  #1,flip_angle(a1)

SKDEZBumperWall_StartContinuousFlip:
                move.b  #0,anim(a1)
                move.b  #-1,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                btst    #0,status(a1)
                beq.s   SKDEZBumperWall_BounceReturn
                neg.w   ground_vel(a1)

SKDEZBumperWall_BounceReturn:
                rts
; End of function BouncePlayerFromDezBumperWall

; ---------------------------------------------------------------------------
Map_DEZBumperWall:
                include "src/objects/shared/zones/dez/mappings/bumper_wall.s"
