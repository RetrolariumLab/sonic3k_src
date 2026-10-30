; Owner: objects/shared/s3
; Responsibility: Automatic player rolling triggers and their shared geometric contact helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AutoSpin:
                move.l  #Map_PathSwap,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ring,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #$80,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  subtype(a0),d0
                btst    #2,d0
                beq.s   loc_1C4BA
                andi.w  #7,d0
                move.b  d0,mapping_frame(a0)
                andi.w  #3,d0
                add.w   d0,d0
                move.w  word_1C4B2(pc,d0.w),$32(a0)
                move.w  y_pos(a0),d1
                lea     (Player_1).w,a1
                cmp.w   y_pos(a1),d1
                bhs.s   loc_1C498
                move.b  #1,$34(a0)

loc_1C498:
                lea     (Player_2).w,a1
                cmp.w   y_pos(a1),d1
                bhs.s   loc_1C4A8
                move.b  #1,$35(a0)

loc_1C4A8:
                move.l  #loc_1C5FA,(a0)
                bra.w   loc_1C5FA
; ---------------------------------------------------------------------------
word_1C4B2:
                dc.w    $20,   $40,   $80,  $100
; ---------------------------------------------------------------------------

loc_1C4BA:
                andi.w  #3,d0
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                move.w  word_1C4B2(pc,d0.w),$32(a0)
                move.w  x_pos(a0),d1
                lea     (Player_1).w,a1
                cmp.w   x_pos(a1),d1
                bhs.s   loc_1C4DE
                move.b  #1,$34(a0)

loc_1C4DE:
                lea     (Player_2).w,a1
                cmp.w   x_pos(a1),d1
                bhs.s   loc_1C4EE
                move.b  #1,$35(a0)

loc_1C4EE:
                move.l  #loc_1C4F4,(a0)

loc_1C4F4:
                tst.w   (Debug_placement_mode).w
                bne.w   loc_1C5BC
                move.w  x_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   sub_1C518
                lea     (Player_2).w,a1
                cmpi.w  #4,(Tails_CPU_routine).w
                beq.w   loc_1C5BC

; =============== S U B R O U T I N E =======================================

sub_1C518:
                tst.b   (a2)+
                bne.s   loc_1C56E
                cmp.w   x_pos(a1),d1
                bhi.w   loc_1C5BC
                move.b  #1,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blo.s   loc_1C5BC
                cmp.w   d3,d4
                bhs.s   loc_1C5BC
                btst    #0,render_flags(a0)
                bne.s   loc_1C566
                move.w  #$580,ground_vel(a1)
                move.b  #1,spin_dash_flag(a1)
                tst.b   subtype(a0)
                bpl.s   loc_1C564
                move.b  #$81,spin_dash_flag(a1)

loc_1C564:
                bra.s   loc_1C5CA
; ---------------------------------------------------------------------------

loc_1C566:
                move.b  #0,spin_dash_flag(a1)
                bra.s   loc_1C5BC
; ---------------------------------------------------------------------------

loc_1C56E:
                cmp.w   x_pos(a1),d1
                bls.s   loc_1C5BC
                move.b  #0,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blo.s   loc_1C5BC
                cmp.w   d3,d4
                bhs.s   loc_1C5BC
                btst    #0,render_flags(a0)
                beq.s   loc_1C5B6
                move.w  #-$580,ground_vel(a1)
                move.b  #1,spin_dash_flag(a1)
                tst.b   subtype(a0)
                bpl.s   loc_1C5B4
                move.b  #$81,spin_dash_flag(a1)

loc_1C5B4:
                bra.s   loc_1C5CA
; ---------------------------------------------------------------------------

loc_1C5B6:
                move.b  #0,spin_dash_flag(a1)

loc_1C5BC:
                tst.w   (Debug_mode_flag).w
                beq.w   Delete_Sprite_If_Not_In_Range
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_1C5CA:
                btst    #Status_Roll,status(a1)
                beq.s   loc_1C5D4
                rts
; ---------------------------------------------------------------------------

loc_1C5D4:
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                addq.w  #5,y_pos(a1)
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l
                rts
; End of function sub_1C518

; ---------------------------------------------------------------------------

loc_1C5FA:
                tst.w   (Debug_placement_mode).w
                bne.w   loc_1C6F2
                move.w  y_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   sub_1C61E
                lea     (Player_2).w,a1
                cmpi.w  #4,(Tails_CPU_routine).w
                beq.w   loc_1C6F2

; =============== S U B R O U T I N E =======================================

sub_1C61E:
                tst.b   (a2)+
                bne.s   loc_1C694
                cmp.w   y_pos(a1),d1
                bhi.w   loc_1C6F2
                move.b  #1,-1(a2)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  x_pos(a1),d4
                cmp.w   d2,d4
                blo.w   loc_1C6F2
                cmp.w   d3,d4
                bhs.w   loc_1C6F2
                btst    #0,render_flags(a0)
                bne.s   loc_1C68C
                move.b  #1,spin_dash_flag(a1)
                tst.b   subtype(a0)
                bpl.s   loc_1C668
                move.b  #$81,spin_dash_flag(a1)

loc_1C668:
                btst    #6,subtype(a0)
                beq.s   loc_1C688
                bclr    #Status_InAir,status(a1)
                move.b  #$40,angle(a1)
                move.w  y_vel(a1),ground_vel(a1)
                move.w  #0,x_vel(a1)

loc_1C688:
                bra.w   loc_1C5CA
; ---------------------------------------------------------------------------

loc_1C68C:
                move.b  #0,spin_dash_flag(a1)
                bra.s   loc_1C6F2
; ---------------------------------------------------------------------------

loc_1C694:
                cmp.w   y_pos(a1),d1
                bls.s   loc_1C6F2
                move.b  #0,-1(a2)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  x_pos(a1),d4
                cmp.w   d2,d4
                blo.s   loc_1C6F2
                cmp.w   d3,d4
                bhs.s   loc_1C6F2
                btst    #0,render_flags(a0)
                beq.s   loc_1C6EC
                move.b  #1,spin_dash_flag(a1)
                tst.b   subtype(a0)
                bpl.s   loc_1C6D4
                move.b  #$81,spin_dash_flag(a1)

loc_1C6D4:
                btst    #6,subtype(a0)
                beq.s   loc_1C6E8
                bclr    #Status_InAir,status(a1)
                move.b  #$40,angle(a1)

loc_1C6E8:
                bra.w   loc_1C5CA
; ---------------------------------------------------------------------------

loc_1C6EC:
                move.b  #0,spin_dash_flag(a1)

loc_1C6F2:
                tst.w   (Debug_mode_flag).w
                beq.w   Delete_Sprite_If_Not_In_Range
                jmp     (Sprite_OnScreen_Test).l
; End of function sub_1C61E
