; Owner: objects/zones/mgz/sk
; Responsibility: Marble Garden dash trigger state, activation, child sprites and animation resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_MGZDashTrigger:
                move.l  #Map_MGZDashTrigger,mappings(a0)
                move.w  #make_art_tile(ArtTile_MGZMisc1,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                bset    #6,render_flags(a0)
                move.w  #1,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #0,(a2)+
                move.l  #loc_25D9C,(a0)

loc_25D9C:
                move.w  #$1B,d1
                move.w  #$10,d2
                move.w  x_pos(a0),d4
                lea     (byte_25F0E).l,a2
                jsr     (sub_1DD0E).l
                swap    d6
                andi.w  #$33,d6
                beq.s   loc_25E22
                move.b  d6,d0
                andi.b  #$11,d0
                beq.s   loc_25DF0
                lea     (Player_1).w,a1
                cmpi.b  #9,anim(a1)
                bne.s   loc_25DF0
                move.w  #$3C,$30(a0)
                move.b  #1,$32(a0)
                move.b  status(a1),d0
                add.b   status(a0),d0
                andi.b  #1,d0
                bne.s   loc_25DF0
                move.b  #-1,$32(a0)

loc_25DF0:
                andi.b  #$22,d6
                beq.s   loc_25E22
                lea     (Player_2).w,a1
                cmpi.b  #9,anim(a1)
                bne.s   loc_25E22
                move.w  #$3C,$30(a0)
                move.b  #1,$32(a0)
                move.b  status(a1),d0
                add.b   status(a0),d0
                andi.b  #1,d0
                bne.s   loc_25E22
                move.b  #-1,$32(a0)

loc_25E22:
                tst.w   $30(a0)
                beq.s   loc_25EA0
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                subq.w  #1,$30(a0)
                bne.s   loc_25E4A
                move.b  #0,(a3)
                move.b  #0,mapping_frame(a0)
                bra.s   loc_25EA0
; ---------------------------------------------------------------------------

loc_25E4A:
                move.b  #1,(a3)
                move.b  status(a0),d6
                andi.w  #standing_mask,d6
                beq.s   loc_25E72
                move.w  d6,d0
                andi.w  #p1_standing,d0
                beq.s   loc_25E66
                lea     (Player_1).w,a1
                bsr.s   sub_25EA6

loc_25E66:
                andi.w  #p2_standing,d6
                beq.s   loc_25E72
                lea     (Player_2).w,a1
                bsr.s   sub_25EA6

loc_25E72:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_25E8C
                move.b  #1,anim_frame_timer(a0)
                move.b  $32(a0),d0
                add.b   d0,$1D(a0)
                andi.b  #3,$1D(a0)

loc_25E8C:
                tst.b   mapping_frame(a0)
                beq.s   loc_25E9A
                move.b  #0,mapping_frame(a0)
                bra.s   loc_25EA0
; ---------------------------------------------------------------------------

loc_25E9A:
                move.b  #4,mapping_frame(a0)

loc_25EA0:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_25EA6:
                move.w  x_pos(a0),d1
                subi.w  #$10,d1
                btst    #0,status(a0)
                beq.s   loc_25EBA
                addi.w  #2*$10,d1

loc_25EBA:
                move.w  y_pos(a0),d2
                addi.w  #$10,d2
                sub.w   x_pos(a1),d1
                sub.w   y_pos(a1),d2
                jsr     (GetArcTan).l
                jsr     (GetSineCosine).l
                muls.w  #-$700,d1
                asr.l   #8,d1
                move.w  d1,x_vel(a1)
                muls.w  #-$700,d0
                asr.l   #8,d0
                move.w  d0,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                bclr    #Status_Push,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                moveq   #signextendB(sfx_SmallBumpers),d0
                jsr     (Play_SFX).l
                rts
; End of function sub_25EA6

; ---------------------------------------------------------------------------
byte_25F0E:
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $F
                dc.b    $F
                dc.b    $E
                dc.b    $E
                dc.b    $D
                dc.b    $C
                dc.b    $A
                dc.b    8
                dc.b    6
                dc.b    4
                dc.b    0
                dc.b    -4
                dc.b    -8
                dc.b    -$A
                dc.b    -$A
                dc.b    -$A
                dc.b    -$A
                dc.b    -$A
                dc.b    -$A
                even
