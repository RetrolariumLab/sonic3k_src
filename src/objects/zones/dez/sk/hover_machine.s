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
                bne.w   loc_494D4
                move.l  #loc_494EA,(a1)
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

loc_494D4:
                move.l  #loc_494DA,(a0)

loc_494DA:
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_494EA:
                move.w  #$200,priority(a0)
                move.b  angle(a0),d0
                bpl.s   loc_494FC
                move.w  #$300,priority(a0)

loc_494FC:
                addq.b  #2,angle(a0)
                jsr     (GetSineCosine).l
                asr.w   #3,d1
                add.w   $44(a0),d1
                move.w  d1,x_pos(a0)
                lea     (Player_1).w,a1
                bsr.w   sub_4952A
                lea     (Player_2).w,a1
                bsr.w   sub_4952A
                move.w  $44(a0),d0
                jmp     (Sprite_OnScreen_Test2).l

; =============== S U B R O U T I N E =======================================

sub_4952A:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                cmpi.w  #$80,d0
                bhs.w   locret_495D6
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
                bhs.s   locret_495D6
                cmpi.b  #4,routine(a1)
                bhs.w   locret_495D6
                tst.b   object_control(a1)
                bne.s   locret_495D6
                sub.w   d0,d1
                bcs.s   loc_49578
                not.w   d1
                add.w   d1,d1

loc_49578:
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
                bne.s   loc_495B8
                moveq   #signextendB(sfx_MagneticSpike),d0
                jsr     (Play_SFX).l

loc_495B8:
                tst.b   flip_angle(a1)
                bne.s   locret_495D6
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #$7F,flips_remaining(a1)
                move.b  #8,flip_speed(a1)

locret_495D6:
                rts
; End of function sub_4952A

; ---------------------------------------------------------------------------
Map_DEZHoverMachine:
                include "src/objects/shared/zones/dez/mappings/hover_machine.s"
