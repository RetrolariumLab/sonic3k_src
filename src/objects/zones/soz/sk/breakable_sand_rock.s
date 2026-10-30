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
                move.l  #loc_4172E,(a0)

loc_4172E:
                move.b  (Player_1+anim).w,$30(a0)
                move.b  (Player_2+anim).w,$31(a0)
                move.w  #$23,d1
                move.w  #$10,d2
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_41760

loc_4175A:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_41760:
                cmpi.b  #$18,d0
                bne.s   loc_4178E
                cmpi.b  #2,$30(a0)
                beq.s   loc_41776
                cmpi.b  #2,$31(a0)
                bne.s   loc_4175A

loc_41776:
                lea     (Player_1).w,a1
                move.b  $30(a0),d0
                bsr.s   sub_417A6
                lea     (Player_2).w,a1
                move.b  $31(a0),d0
                bsr.s   sub_417A6
                bra.w   loc_417F6
; ---------------------------------------------------------------------------

loc_4178E:
                move.b  d0,d1
                andi.b  #8,d1
                beq.s   loc_417DE
                cmpi.b  #2,$30(a0)
                bne.s   loc_4175A
                lea     (Player_1).w,a1
                bsr.s   sub_417AC
                bra.s   loc_417F6

; =============== S U B R O U T I N E =======================================

sub_417A6:
                cmpi.b  #2,d0
                bne.s   loc_417CA
; End of function sub_417A6

; =============== S U B R O U T I N E =======================================

sub_417AC:
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.w  #-$300,y_vel(a1)

loc_417CA:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #2,routine(a1)
                rts
; End of function sub_417AC

; ---------------------------------------------------------------------------

loc_417DE:
                andi.b  #$10,d0
                beq.w   loc_4175A
                cmpi.b  #2,$31(a0)
                bne.w   loc_4175A
                lea     (Player_2).w,a1
                bsr.s   sub_417AC

loc_417F6:
                andi.b  #$E7,status(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                move.l  #loc_4180A,(a0)

loc_4180A:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_41828
                move.b  #5,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #5,mapping_frame(a0)
                blo.s   loc_41828
                move.w  #$7F00,x_pos(a0)

loc_41828:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_SOZBreakableSandRock:
                include "src/objects/shared/zones/soz/map_breakable_sand_rock.s"
; End of function loc_417DE
