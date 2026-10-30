; Owner: objects/zones/mgz/sk
; Responsibility: Marble Garden pulley travel, player attachment, coordinated sprites and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MGZPulley:
                move.l  #Map_MGZPulley,mappings(a0)
                move.w  #make_art_tile(ArtTile_MGZMisc1,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  #$280,priority(a0)
                bset    #6,render_flags(a0)
                move.w  #1,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #0,(a2)+
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                move.w  d0,$40(a0)
                move.w  d0,$3C(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_348FA
                move.l  #loc_34BEE,(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.b  #$60,width_pixels(a1)
                move.b  #$C0,height_pixels(a1)
                move.w  #$300,priority(a1)
                move.w  x_pos(a0),$12(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subi.w  #$78,x_pos(a1)
                btst    #0,status(a0)
                beq.s   loc_348AC
                addi.w  #2*$78,x_pos(a1)

loc_348AC:
                addi.w  #$D0,y_pos(a1)
                bset    #6,render_flags(a1)
                move.w  #8,mainspr_childsprites(a1)
                lea     sub2_x_pos(a1),a2
                moveq   #8-1,d0
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #$C,d2
                subi.w  #8,d3
                subi.w  #$18,d2
                addi.w  #$30,d3

loc_348DC:
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                move.w  #5,(a2)+
                subi.w  #$18,d2
                addi.w  #$30,d3
                dbf     d0,loc_348DC
                move.w  #6,-2(a2)
                move.w  a1,$3E(a0)

loc_348FA:
                move.l  #loc_34900,(a0)

loc_34900:
                moveq   #0,d4
                tst.b   $38(a0)
                bne.s   loc_34928
                move.w  $3C(a0),d0
                cmp.w   $40(a0),d0
                beq.s   loc_3498E
                bcc.s   loc_3491E
                addq.w  #2,$3C(a0)
                move.b  #-1,d4
                bra.s   loc_34966
; ---------------------------------------------------------------------------

loc_3491E:
                move.b  #1,d4
                subq.w  #2,$3C(a0)
                bra.s   loc_34966
; ---------------------------------------------------------------------------

loc_34928:
                tst.w   $34(a0)
                bne.s   loc_34946
                tst.w   $3C(a0)
                beq.s   loc_3498E
                move.b  #1,d4
                subq.w  #4,$3C(a0)
                bcc.s   loc_34966
                move.w  #0,$3C(a0)
                bra.s   loc_34966
; ---------------------------------------------------------------------------

loc_34946:
                subq.w  #1,$34(a0)
                cmpi.w  #$C,$34(a0)
                blo.s   loc_3498E
                move.w  $40(a0),d0
                addq.w  #8,d0
                cmp.w   $3C(a0),d0
                beq.s   loc_3498E
                addq.w  #2,$3C(a0)
                move.b  #-1,d4

loc_34966:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_3497C
                move.b  #1,anim_frame_timer(a0)
                add.b   d4,$1D(a0)
                andi.b  #3,$1D(a0)

loc_3497C:
                tst.b   mapping_frame(a0)
                bne.s   loc_3498E
                tst.w   d4
                beq.s   loc_34994
                move.b  #4,mapping_frame(a0)
                bra.s   loc_34994
; ---------------------------------------------------------------------------

loc_3498E:
                move.b  #0,mapping_frame(a0)

loc_34994:
                bsr.w   sub_34B22
                bsr.w   sub_349A2
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_349A2:
                lea     $38(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bsr.s   sub_349BA
                addq.w  #1,a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2).w,d0
; End of function sub_349A2

; =============== S U B R O U T I N E =======================================

sub_349BA:
                tst.b   (a2)
                beq.w   loc_34A5A
                tst.b   render_flags(a1)
                bpl.s   loc_34A1A
                cmpi.b  #4,routine(a1)
                bhs.s   loc_34A1A
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_34A28
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #60,2(a2)
                move.w  #-$400,x_vel(a1)
                btst    #0,status(a0)
                beq.s   loc_349F4
                neg.w   x_vel(a1)

loc_349F4:
                move.w  #-$600,y_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                rts
; ---------------------------------------------------------------------------

loc_34A1A:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #60,2(a2)
                rts
; ---------------------------------------------------------------------------

loc_34A28:
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #$26,d2
                addi.w  #$2E,d3
                move.w  $3C(a0),d0
                add.w   d0,d3
                lsr.w   #1,d0
                btst    #0,status(a0)
                beq.s   loc_34A4E
                addi.w  #2*$26,d2
                neg.w   d0

loc_34A4E:
                sub.w   d0,d2
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

loc_34A5A:
                tst.b   2(a2)
                beq.s   loc_34A68
                subq.b  #1,2(a2)
                bne.w   locret_34B20

loc_34A68:
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #$26,d2
                addi.w  #$2E,d3
                move.w  $3C(a0),d0
                add.w   d0,d3
                lsr.w   #1,d0
                btst    #0,status(a0)
                beq.s   loc_34A8E
                addi.w  #2*$26,d2
                neg.w   d0

loc_34A8E:
                sub.w   d0,d2
                move.w  x_pos(a1),d0
                sub.w   d2,d0
                addi.w  #$C,d0
                cmpi.w  #$18,d0
                bhs.w   locret_34B20
                move.w  y_pos(a1),d1
                sub.w   d3,d1
                addi.w  #$C,d1
                cmpi.w  #$18,d1
                bhs.w   locret_34B20
                tst.b   object_control(a1)
                bne.s   locret_34B20
                cmpi.b  #4,routine(a1)
                bhs.s   locret_34B20
                tst.w   (Debug_placement_mode).w
                bne.s   locret_34B20
                move.w  x_vel(a1),d0
                btst    #0,status(a0)
                beq.s   loc_34AD6
                neg.w   d0

loc_34AD6:
                tst.w   d0
                bpl.s   locret_34B20
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                move.b  #$B,anim(a1)
                move.b  #1,object_control(a1)
                bclr    #Status_Facing,status(a1)
                btst    #0,status(a0)
                beq.s   loc_34B0E
                bset    #Status_Facing,status(a1)

loc_34B0E:
                move.w  #$10,$34(a0)
                move.b  #1,(a2)
                moveq   #signextendB(sfx_PulleyGrab),d0
                jsr     (Play_SFX).l

locret_34B20:
                rts
; End of function sub_349BA

; =============== S U B R O U T I N E =======================================

sub_34B22:
                btst    #0,status(a0)
                bne.s   loc_34B8C
                movea.w $3E(a0),a1
                moveq   #0,d0
                move.w  $3C(a0),d0
                addi.w  #$18,d0
                divu.w  #$30,d0
                move.w  d0,mainspr_childsprites(a1)
                move.w  d0,d1
                lea     sub2_x_pos(a1),a2
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #$C,d2
                subi.w  #8,d3
                swap    d0
                cmpi.w  #8,d1
                bne.s   loc_34B66
                move.w  #$30,d0
                moveq   #8-1,d1
                bra.s   loc_34B6A
; ---------------------------------------------------------------------------

loc_34B66:
                addq.w  #1,mainspr_childsprites(a1)

loc_34B6A:
                add.w   d0,d3
                lsr.w   #1,d0
                sub.w   d0,d2

loc_34B70:
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                move.w  #5,(a2)+
                subi.w  #$18,d2
                addi.w  #$30,d3
                dbf     d1,loc_34B70
                move.w  #6,-2(a2)
                rts
; ---------------------------------------------------------------------------

loc_34B8C:
                movea.w $3E(a0),a1
                moveq   #0,d0
                move.w  $3C(a0),d0
                addi.w  #$18,d0
                divu.w  #$30,d0
                move.w  d0,mainspr_childsprites(a1)
                move.w  d0,d1
                lea     sub2_x_pos(a1),a2
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                addi.w  #$C,d2
                subi.w  #8,d3
                swap    d0
                cmpi.w  #8,d1
                bne.s   loc_34BC8
                move.w  #$30,d0
                moveq   #8-1,d1
                bra.s   loc_34BCC
; ---------------------------------------------------------------------------

loc_34BC8:
                addq.w  #1,mainspr_childsprites(a1)

loc_34BCC:
                add.w   d0,d3
                lsr.w   #1,d0
                add.w   d0,d2

loc_34BD2:
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                move.w  #5,(a2)+
                addi.w  #$18,d2
                addi.w  #$30,d3
                dbf     d1,loc_34BD2
                move.w  #6,-2(a2)
                rts
; End of function sub_34B22

; ---------------------------------------------------------------------------

loc_34BEE:
                move.w  $12(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
