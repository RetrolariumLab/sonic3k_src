; Owner: objects/zones/dez/sk
; Responsibility: Hover machine state, player interaction, movement and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_DEZHoverMachine:
                move.l  #Map_DEZHoverMachine,mappings(a0)
                move.w  #make_art_tile(ArtTile_DEZMisc2+$11,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKDEZHover_InitRootAnimation
                move.l  #SKDEZHover_SelectFieldPriority,(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.w  #$280,priority(a1)
                move.b  #2,mapping_frame(a1)
                move.w  x_pos(a0),d2
                move.w  d2,$44(a1)
                addi.w  #$20,d2
                move.w  d2,x_pos(a1)
                move.w  y_pos(a0),d3
                move.w  d3,y_pos(a1)

SKDEZHover_InitRootAnimation:
                move.l  #SKDEZHover_ToggleRootFrame,(a0)

SKDEZHover_ToggleRootFrame:
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKDEZHover_SelectFieldPriority:
                move.w  #$200,priority(a0)
                move.b  angle(a0),d0
                bpl.s   SKDEZHover_MoveFieldAndLiftPlayers
                move.w  #$300,priority(a0)

SKDEZHover_MoveFieldAndLiftPlayers:
                addq.b  #2,angle(a0)
                jsr     (GetSineCosine).l
                asr.w   #3,d1
                add.w   $44(a0),d1
                move.w  d1,x_pos(a0)
                lea     (Player_1).w,a1
                bsr.w   ApplyDezHoverMachineFieldToPlayer
                lea     (Player_2).w,a1
                bsr.w   ApplyDezHoverMachineFieldToPlayer
                move.w  $44(a0),d0
                jmp     (Sprite_OnScreen_Test2).l

; =============== S U B R O U T I N E =======================================

ApplyDezHoverMachineFieldToPlayer:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                cmpi.w  #$80,d0
                bhs.w   SKDEZHover_LiftReturn
                jsr     (GetSineCosine).l
                asr.w   #2,d0
                addi.w  #$20,d0
                move.w  d0,d2
                addi.w  #$20,d2
                moveq   #0,d1
                add.w   y_pos(a1),d1
                sub.w   y_pos(a0),d1
                add.w   d0,d1
                cmp.w   d2,d1
                bhs.s   SKDEZHover_LiftReturn
                cmpi.b  #4,routine(a1)
                bhs.w   SKDEZHover_LiftReturn
                tst.b   object_control(a1)
                bne.s   SKDEZHover_LiftReturn
                sub.w   d0,d1
                bcs.s   SKDEZHover_ApplyLiftAndResetAirState
                not.w   d1
                add.w   d1,d1

SKDEZHover_ApplyLiftAndResetAirState:
                add.w   d0,d1
                neg.w   d1
                asr.w   #4,d1
                add.w   d1,y_pos(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.w  #0,y_vel(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,jumping(a1)
                move.w  #1,ground_vel(a1)
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   SKDEZHover_TryStartPlayerFlip
                moveq   #signextendB(sfx_MagneticSpike),d0
                jsr     (Play_SFX).l

SKDEZHover_TryStartPlayerFlip:
                tst.b   flip_angle(a1)
                bne.s   SKDEZHover_LiftReturn
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #$7F,flips_remaining(a1)
                move.b  #8,flip_speed(a1)

SKDEZHover_LiftReturn:
                rts
; End of function ApplyDezHoverMachineFieldToPlayer

; ---------------------------------------------------------------------------
Map_DEZHoverMachine:
                include "src/objects/shared/zones/dez/mappings/hover_machine.s"
