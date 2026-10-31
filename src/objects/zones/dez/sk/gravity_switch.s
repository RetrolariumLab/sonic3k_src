; Owner: objects/zones/dez/sk
; Responsibility: Gravity switch contact, activation and player gravity state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZGravitySwitch:
                move.l  #Map_DEZGravitySwitch,mappings(a0)
                move.w  #make_art_tile(ArtTile_DEZMisc+$143,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.l  #loc_48AD6,(a0)

loc_48AD6:
                move.w  #$1B,d1
                move.w  #8,d2
                move.w  #9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                swap    d6
                move.w  d6,d0
                andi.w  #$14,d0
                beq.w   loc_48B3A
                move.b  #1,mapping_frame(a0)
                move.l  #loc_48B7E,(a0)
                move.w  #3,$30(a0)
                moveq   #8,d0
                btst    #1,render_flags(a0)
                beq.s   loc_48B16
                neg.w   d0

loc_48B16:
                add.w   d0,y_pos(a0)
                lea     (Player_1).w,a1
                move.w  d6,d2
                move.w  #$14,d3
                bsr.s   sub_48B40
                lea     (Player_2).w,a1
                move.w  d6,d2
                move.w  #$28,d3
                bsr.s   sub_48B40
                moveq   #signextendB(sfx_Transporter),d0
                jsr     (Play_SFX).l

loc_48B3A:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_48B40:
                tst.b   object_control(a1)
                bne.s   locret_48B7C
                moveq   #0,d1
                move.b  d1,anim(a1)
                move.b  d1,flip_type(a1)
                move.b  d1,double_jump_flag(a1)
                move.b  d1,jumping(a1)
                move.b  d1,spin_dash_flag(a1)
                move.w  d1,ground_vel(a1)
                move.w  d1,x_vel(a1)
                move.w  d1,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                and.w   d3,d2
                beq.s   locret_48B7C
                add.w   d0,y_pos(a1)

locret_48B7C:
                rts
; End of function sub_48B40

; ---------------------------------------------------------------------------

loc_48B7E:
                subq.w  #1,$30(a0)
                bpl.s   loc_48B96
                move.w  #20-1,$30(a0)
                eori.b  #1,(Reverse_gravity_flag).w
                move.l  #loc_48B9C,(a0)

loc_48B96:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_48B9C:
                move.w  #$1B,d1
                move.w  #8,d2
                move.w  #9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                btst    #Status_OnObj,status(a0)
                beq.s   loc_48BC2
                move.w  #0,$30(a0)
                bra.s   loc_48BE4
; ---------------------------------------------------------------------------

loc_48BC2:
                subq.w  #1,$30(a0)
                bpl.s   loc_48BE4
                move.b  #0,mapping_frame(a0)
                moveq   #8,d0
                btst    #1,render_flags(a0)
                beq.s   loc_48BDA
                neg.w   d0

loc_48BDA:
                sub.w   d0,y_pos(a0)
                move.l  #loc_48AD6,(a0)

loc_48BE4:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_DEZGravitySwitch:
                include "src/objects/shared/zones/dez/mappings/gravity_switch.s"
