; Owner: objects/zones/fbz/sk
; Responsibility: Flying Battery and Death Egg player launcher state, capture and launch
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZDEZPlayerLauncher:
                move.l  #Map_FBZDEZPlayerLauncher,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc+$3C,1,0),art_tile(a0)
                cmpi.b  #$B,(Current_zone).w
                bne.s   SKFBZDEZLauncher_FinishInit
                move.w  #make_art_tile(ArtTile_DEZMisc2,1,0),art_tile(a0)
                move.b  #1,mapping_frame(a0)

SKFBZDEZLauncher_FinishInit:
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.w  x_pos(a0),$44(a0)
                move.l  #SKFBZDEZLauncher_TickLaunchWindow,(a0)

SKFBZDEZLauncher_TickLaunchWindow:
                tst.b   $30(a0)
                beq.s   SKFBZDEZLauncher_UpdateRidersAndSolid
                subq.b  #1,$30(a0)
                bne.s   SKFBZDEZLauncher_MoveAndTryDoubleSpeed
                move.w  #0,x_vel(a0)
                move.l  #SKFBZDEZLauncher_BeginReturnStep,(a0)
                move.b  #1,$32(a0)

SKFBZDEZLauncher_MoveAndTryDoubleSpeed:
                jsr     (MoveSprite2).l
                tst.b   $31(a0)
                beq.s   SKFBZDEZLauncher_UpdateRidersAndSolid
                subq.b  #1,$31(a0)
                asl     x_vel(a0)

SKFBZDEZLauncher_UpdateRidersAndSolid:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   UpdatePlayerOnFbzDezFloorLauncher
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.s   UpdatePlayerOnFbzDezFloorLauncher
                move.w  #$10,d1
                move.w  #3,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                move.w  $44(a0),d0
                jmp     (Sprite_OnScreen_Test2).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnFbzDezFloorLauncher:
                btst    d6,status(a0)
                beq.s   SKFBZDEZLauncher_RiderReturn
                moveq   #4,d0
                move.w  #$100,d1
                bclr    #Status_Facing,status(a1)
                btst    #0,status(a0)
                beq.s   SKFBZDEZLauncher_AlignRiderAndTryRelease
                bset    #Status_Facing,status(a1)
                neg.w   d0
                neg.w   d1

SKFBZDEZLauncher_AlignRiderAndTryRelease:
                add.w   x_pos(a0),d0
                move.w  d0,x_pos(a1)
                tst.b   $32(a0)
                beq.s   SKFBZDEZLauncher_SyncSpeedAndTryLaunch
                move.b  #0,anim(a1)
                bset    #Status_InAir,status(a1)
                move.w  #0,y_vel(a1)
                rts
; ---------------------------------------------------------------------------

SKFBZDEZLauncher_SyncSpeedAndTryLaunch:
                move.w  x_vel(a0),d0
                move.w  d0,x_vel(a1)
                move.w  d0,ground_vel(a1)
                tst.b   $30(a0)
                bne.s   SKFBZDEZLauncher_RiderReturn
                move.w  d1,x_vel(a0)
                move.b  #$C,$30(a0)
                move.b  #4,$31(a0)
                moveq   #signextendB(sfx_FloorLauncher),d0
                jsr     (Play_SFX).l

SKFBZDEZLauncher_RiderReturn:
                rts
; End of function UpdatePlayerOnFbzDezFloorLauncher

; ---------------------------------------------------------------------------

SKFBZDEZLauncher_BeginReturnStep:
                move.w  x_pos(a0),-(sp)
                moveq   #1,d1
                move.w  x_pos(a0),d0
                sub.w   $44(a0),d0
                bne.s   SKFBZDEZLauncher_SignReturnStep
                move.l  #SKFBZDEZLauncher_TickLaunchWindow,(a0)
                move.b  #0,$32(a0)
                bra.s   SKFBZDEZLauncher_ResolveReturningSolid
; ---------------------------------------------------------------------------

SKFBZDEZLauncher_SignReturnStep:
                bcs.s   SKFBZDEZLauncher_StepTowardBase
                neg.w   d1

SKFBZDEZLauncher_StepTowardBase:
                add.w   d1,x_pos(a0)

SKFBZDEZLauncher_ResolveReturningSolid:
                move.w  #$10,d1
                move.w  #3,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectTop).l
                move.w  $44(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
Map_FBZDEZPlayerLauncher:
                include "src/objects/shared/zones/fbz/mappings/dez_player_launcher.s"
