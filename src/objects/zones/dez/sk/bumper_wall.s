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
                beq.s   loc_497A6
                bmi.s   loc_497AE
                move.b  #8,width_pixels(a0)
                move.b  d0,height_pixels(a0)
                move.l  #loc_49804,(a0)
                bra.s   loc_49804
; ---------------------------------------------------------------------------

loc_497A6:
                move.l  #loc_497C2,(a0)
                bra.s   loc_497C2
; ---------------------------------------------------------------------------

loc_497AE:
                move.l  #loc_497B4,(a0)

loc_497B4:
                cmpi.b  #$3F,(MHZ_pollen_counter).w
                bne.s   loc_497C2
                move.w  #$7F00,x_pos(a0)

loc_497C2:
                move.w  #$17,d1
                move.w  #$20,d2
                move.w  #$21,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull2).l
                swap    d6
                andi.w  #1|2,d6
                beq.s   loc_497FE
                move.w  d6,d0
                andi.w  #1,d0
                beq.s   loc_497F0
                lea     (Player_1).w,a1
                moveq   #p1_pushing_bit,d5
                bsr.s   BouncePlayerFromDezBumperWall

loc_497F0:
                andi.w  #2,d6
                beq.s   loc_497FE
                lea     (Player_2).w,a1
                moveq   #p2_pushing_bit,d5
                bsr.s   BouncePlayerFromDezBumperWall

loc_497FE:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_49804:
                move.w  #$13,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull2).l
                swap    d6
                andi.w  #1|2,d6
                beq.s   loc_49842
                move.w  d6,d0
                andi.w  #1,d0
                beq.s   loc_49834
                lea     (Player_1).w,a1
                moveq   #p1_pushing_bit,d5
                bsr.s   BouncePlayerFromDezBumperWall

loc_49834:
                andi.w  #2,d6
                beq.s   loc_49842
                lea     (Player_2).w,a1
                moveq   #p2_pushing_bit,d5
                bsr.s   BouncePlayerFromDezBumperWall

loc_49842:
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

BouncePlayerFromDezBumperWall:
                moveq   #signextendB(sfx_Bumper),d0
                jsr     (Play_SFX).l

loc_49850:
                bclr    #Status_Facing,status(a1)
                move.w  #$C00,x_vel(a1)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bcc.s   loc_49870
                bset    #Status_Facing,status(a1)
                neg.w   x_vel(a1)

loc_49870:
                bclr    d5,status(a0)
                bset    #Status_InAir,status(a1)
                bclr    #Status_Push,status(a1)
                move.b  #0,double_jump_flag(a1)
                bclr    #Status_RollJump,status(a1)
                clr.b   jumping(a1)
                move.w  #1,ground_vel(a1)
                tst.b   flip_angle(a1)
                bne.s   loc_498A2
                move.b  #1,flip_angle(a1)

loc_498A2:
                move.b  #0,anim(a1)
                move.b  #-1,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                btst    #0,status(a1)
                beq.s   locret_498C0
                neg.w   ground_vel(a1)

locret_498C0:
                rts
; End of function BouncePlayerFromDezBumperWall

; ---------------------------------------------------------------------------
Map_DEZBumperWall:
                include "src/objects/shared/zones/dez/mappings/bumper_wall.s"
