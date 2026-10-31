; Owner: objects/zones/mgz/s3
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
                bne.w   loc_33DC2
                move.l  #loc_340B6,(a1)
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
                beq.s   loc_33D74
                addi.w  #2*$78,x_pos(a1)

loc_33D74:
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

loc_33DA4:
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                move.w  #5,(a2)+
                subi.w  #$18,d2
                addi.w  #$30,d3
                dbf     d0,loc_33DA4
                move.w  #6,-2(a2)
                move.w  a1,$3E(a0)

loc_33DC2:
                move.l  #loc_33DC8,(a0)

loc_33DC8:
                moveq   #0,d4
                tst.b   $38(a0)
                bne.s   loc_33DF0
                move.w  $3C(a0),d0
                cmp.w   $40(a0),d0
                beq.s   loc_33E56
                bcc.s   loc_33DE6
                addq.w  #2,$3C(a0)
                move.b  #-1,d4
                bra.s   loc_33E2E
; ---------------------------------------------------------------------------

loc_33DE6:
                move.b  #1,d4
                subq.w  #2,$3C(a0)
                bra.s   loc_33E2E
; ---------------------------------------------------------------------------

loc_33DF0:
                tst.w   $34(a0)
                bne.s   loc_33E0E
                tst.w   $3C(a0)
                beq.s   loc_33E56
                move.b  #1,d4
                subq.w  #4,$3C(a0)
                bcc.s   loc_33E2E
                move.w  #0,$3C(a0)
                bra.s   loc_33E2E
; ---------------------------------------------------------------------------

loc_33E0E:
                subq.w  #1,$34(a0)
                cmpi.w  #$C,$34(a0)
                blo.s   loc_33E56
                move.w  $40(a0),d0
                addq.w  #8,d0
                cmp.w   $3C(a0),d0
                beq.s   loc_33E56
                addq.w  #2,$3C(a0)
                move.b  #-1,d4

loc_33E2E:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_33E44
                move.b  #1,anim_frame_timer(a0)
                add.b   d4,$1D(a0)
                andi.b  #3,$1D(a0)

loc_33E44:
                tst.b   mapping_frame(a0)
                bne.s   loc_33E56
                tst.w   d4
                beq.s   loc_33E5C
                move.b  #4,mapping_frame(a0)
                bra.s   loc_33E5C
; ---------------------------------------------------------------------------

loc_33E56:
                move.b  #0,mapping_frame(a0)

loc_33E5C:
                bsr.w   sub_33FEA
                bsr.w   sub_33E6A
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_33E6A:
                lea     $38(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d0
                bsr.s   sub_33E82
                addq.w  #1,a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2).w,d0
; End of function sub_33E6A

; =============== S U B R O U T I N E =======================================

sub_33E82:
                tst.b   (a2)
                beq.w   loc_33F22
                tst.b   render_flags(a1)
                bpl.s   loc_33EE2
                cmpi.b  #4,routine(a1)
                bhs.s   loc_33EE2
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_33EF0
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #60,2(a2)
                move.w  #-$400,x_vel(a1)
                btst    #0,status(a0)
                beq.s   loc_33EBC
                neg.w   x_vel(a1)

loc_33EBC:
                move.w  #-$600,y_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                rts
; ---------------------------------------------------------------------------

loc_33EE2:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #60,2(a2)
                rts
; ---------------------------------------------------------------------------

loc_33EF0:
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #$26,d2
                addi.w  #$2E,d3
                move.w  $3C(a0),d0
                add.w   d0,d3
                lsr.w   #1,d0
                btst    #0,status(a0)
                beq.s   loc_33F16
                addi.w  #2*$26,d2
                neg.w   d0

loc_33F16:
                sub.w   d0,d2
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

loc_33F22:
                tst.b   2(a2)
                beq.s   loc_33F30
                subq.b  #1,2(a2)
                bne.w   locret_33FE8

loc_33F30:
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #$26,d2
                addi.w  #$2E,d3
                move.w  $3C(a0),d0
                add.w   d0,d3
                lsr.w   #1,d0
                btst    #0,status(a0)
                beq.s   loc_33F56
                addi.w  #2*$26,d2
                neg.w   d0

loc_33F56:
                sub.w   d0,d2
                move.w  x_pos(a1),d0
                sub.w   d2,d0
                addi.w  #$C,d0
                cmpi.w  #$18,d0
                bhs.w   locret_33FE8
                move.w  y_pos(a1),d1
                sub.w   d3,d1
                addi.w  #$C,d1
                cmpi.w  #$18,d1
                bhs.w   locret_33FE8
                tst.b   object_control(a1)
                bne.s   locret_33FE8
                cmpi.b  #4,routine(a1)
                bhs.s   locret_33FE8
                tst.w   (Debug_placement_mode).w
                bne.s   locret_33FE8
                move.w  x_vel(a1),d0
                btst    #0,status(a0)
                beq.s   loc_33F9E
                neg.w   d0

loc_33F9E:
                tst.w   d0
                bpl.s   locret_33FE8
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                move.b  #$B,anim(a1)
                move.b  #1,object_control(a1)
                bclr    #Status_Facing,status(a1)
                btst    #0,status(a0)
                beq.s   loc_33FD6
                bset    #Status_Facing,status(a1)

loc_33FD6:
                move.w  #$10,$34(a0)
                move.b  #1,(a2)
                moveq   #signextendB(sfx_PulleyGrab),d0
                jsr     (Play_SFX).l

locret_33FE8:
                rts
; End of function sub_33E82

; =============== S U B R O U T I N E =======================================

sub_33FEA:
                btst    #0,status(a0)
                bne.s   loc_34054
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
                bne.s   loc_3402E
                move.w  #$30,d0
                moveq   #8-1,d1
                bra.s   loc_34032
; ---------------------------------------------------------------------------

loc_3402E:
                addq.w  #1,mainspr_childsprites(a1)

loc_34032:
                add.w   d0,d3
                lsr.w   #1,d0
                sub.w   d0,d2

loc_34038:
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                move.w  #5,(a2)+
                subi.w  #$18,d2
                addi.w  #$30,d3
                dbf     d1,loc_34038
                move.w  #6,-2(a2)
                rts
; ---------------------------------------------------------------------------

loc_34054:
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
                bne.s   loc_34090
                move.w  #$30,d0
                moveq   #8-1,d1
                bra.s   loc_34094
; ---------------------------------------------------------------------------

loc_34090:
                addq.w  #1,mainspr_childsprites(a1)

loc_34094:
                add.w   d0,d3
                lsr.w   #1,d0
                add.w   d0,d2

loc_3409A:
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                move.w  #5,(a2)+
                addi.w  #$18,d2
                addi.w  #$30,d3
                dbf     d1,loc_3409A
                move.w  #6,-2(a2)
                rts
; End of function sub_33FEA

; ---------------------------------------------------------------------------

loc_340B6:
                move.w  $12(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
Map_MGZPulley:
                include "src/objects/shared/zones/mgz/mappings/pulley.s"
