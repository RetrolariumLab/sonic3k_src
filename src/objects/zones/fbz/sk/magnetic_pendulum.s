; Owner: objects/zones/fbz/sk
; Responsibility: Magnetic pendulum motion, attraction, player interactions and coordinated sprites
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZMagneticPendulum:
                move.l  #loc_3D4C2,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$180,priority(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc2+$51,1,0),art_tile(a0)
                move.l  #Map_FBZMagneticPendulum,mappings(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_3D496
                move.w  a1,$44(a0)
                move.l  #loc_3D736,(a1)
                move.w  x_pos(a0),$12(a1)
                move.w  y_pos(a0),$16(a1)
                move.w  a0,parent3(a1)

loc_3D496:
                moveq   #-$80,d0
                tst.b   subtype(a0)
                bpl.s   loc_3D4A8
                addi.w  #$40,d0
                move.b  #1,mapping_frame(a0)

loc_3D4A8:
                move.w  respawn_addr(a0),d1
                beq.s   loc_3D4BE
                movea.w d1,a1
                btst    #0,(a1)
                beq.s   loc_3D4BE
                st      $2E(a0)
                addi.w  #$80,d0

loc_3D4BE:
                move.b  d0,angle(a0)

loc_3D4C2:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bls.s   loc_3D506
                move.w  $44(a0),d0
                beq.s   loc_3D4E0
                movea.w d0,a1
                st      routine(a1)

loc_3D4E0:
                move.w  respawn_addr(a0),d0
                beq.s   loc_3D500
                movea.w d0,a1
                move.b  angle(a0),d0
                tst.b   subtype(a0)
                bmi.s   loc_3D4F6
                addi.b  #$40,d0

loc_3D4F6:
                moveq   #0,d1
                tst.b   d0
                bmi.s   loc_3D4FE
                moveq   #1,d1

loc_3D4FE:
                move.b  d1,(a1)

loc_3D500:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3D506:
                lea     (Player_1).w,a2
                tst.b   $2F(a0)
                beq.w   loc_3D730
                bmi.s   loc_3D542
                move.w  x_vel(a2),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,x_pos(a2)
                move.w  y_vel(a2),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a2)
                subq.b  #1,$2F(a0)
                bne.w   loc_3D730
                clr.b   object_control(a2)
                bclr    #Status_InAir,status(a2)
                bra.w   loc_3D730
; ---------------------------------------------------------------------------

loc_3D542:
                move.w  $30(a0),d0
                add.w   d0,angle(a0)
                moveq   #6,d1
                move.b  angle(a0),d0
                subi.b  #$40,d0
                bmi.s   loc_3D558
                neg.w   d1

loc_3D558:
                add.w   d1,$30(a0)
                move.b  angle(a0),d0
                tst.b   subtype(a0)
                bpl.s   loc_3D594
                tst.w   $30(a0)
                bpl.s   loc_3D580
                tst.b   d0
                bpl.w   loc_3D640
                cmpi.b  #-$40,d0
                bhi.w   loc_3D640
                moveq   #-$40,d0
                moveq   #0,d1
                bra.s   loc_3D5C4
; ---------------------------------------------------------------------------

loc_3D580:
                tst.b   d0
                bmi.w   loc_3D640
                cmpi.b  #$40,d0
                blo.w   loc_3D640
                moveq   #$40,d0
                moveq   #-1,d1
                bra.s   loc_3D5C4
; ---------------------------------------------------------------------------

loc_3D594:
                addi.b  #$40,d0
                tst.w   $30(a0)
                bpl.s   loc_3D5B2
                tst.b   d0
                bpl.w   loc_3D640
                cmpi.b  #-$40,d0
                bhi.w   loc_3D640
                moveq   #-$80,d0
                moveq   #0,d1
                bra.s   loc_3D5C4
; ---------------------------------------------------------------------------

loc_3D5B2:
                tst.b   d0
                bmi.w   loc_3D640
                cmpi.b  #$40,d0
                blo.w   loc_3D640
                moveq   #0,d0
                moveq   #-1,d1

loc_3D5C4:
                move.b  d0,angle(a0)
                clr.b   $27(a0)
                move.b  d1,$2E(a0)
                clr.b   $2F(a0)
                moveq   #signextendB(sfx_Clank),d0
                jsr     (Play_SFX).l
                tst.b   $32(a0)
                beq.w   loc_3D730
                clr.b   $32(a0)
                move.b  #1,$2F(a0)
                moveq   #0,d0
                move.w  $30(a0),d0
                bpl.s   loc_3D5F8
                neg.w   d0

loc_3D5F8:
                lsl.l   #8,d0
                divu.w  #$51,d0
                cmpi.w  #$100,d0
                bhs.s   loc_3D608
                move.w  #$100,d0

loc_3D608:
                tst.b   subtype(a0)
                bpl.s   loc_3D628
                clr.w   y_vel(a2)
                neg.w   d0
                move.w  d0,x_vel(a2)
                move.w  d0,ground_vel(a2)
                tst.b   angle(a0)
                bmi.s   loc_3D648
                neg.w   ground_vel(a2)
                bra.s   loc_3D648
; ---------------------------------------------------------------------------

loc_3D628:
                clr.w   x_vel(a2)
                move.w  d0,y_vel(a2)
                move.w  d0,ground_vel(a2)
                tst.b   angle(a0)
                bpl.s   loc_3D648
                neg.w   ground_vel(a2)
                bra.s   loc_3D648
; ---------------------------------------------------------------------------

loc_3D640:
                tst.b   $32(a0)
                beq.w   loc_3D730

loc_3D648:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                swap    d1
                clr.w   d1
                asr.l   #1,d1
                move.l  d1,d3
                asr.l   #3,d3
                add.l   d3,d1
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d2
                asr.l   #3,d2
                add.l   d2,d0
                btst    #Status_Roll,status(a2)
                bne.s   loc_3D67C
                asr.l   #2,d3
                add.l   d3,d1
                asr.l   #2,d2
                add.l   d2,d0
                bra.s   loc_3D684
; ---------------------------------------------------------------------------

loc_3D67C:
                asr.l   #4,d3
                sub.l   d3,d1
                asr.l   #4,d2
                sub.l   d2,d0

loc_3D684:
                swap    d1
                add.w   x_pos(a0),d1
                move.w  d1,x_pos(a2)
                swap    d0
                add.w   y_pos(a0),d0
                move.w  d0,y_pos(a2)
                move.b  angle(a0),d0
                addi.b  #$40,d0
                move.b  d0,angle(a2)
                tst.b   $32(a0)
                beq.w   loc_3D730
                move.b  angle(a0),d0
                addi.b  #$40,d0
                jsr     (GetSineCosine).l
                tst.w   $30(a0)
                bpl.s   loc_3D6C4
                neg.w   d1
                neg.w   d0

loc_3D6C4:
                move.w  d1,x_vel(a2)
                move.w  d0,y_vel(a2)
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   loc_3D730
                clr.b   $32(a0)
                clr.b   object_control(a2)
                clr.b   spin_dash_flag(a2)
                bset    #Status_InAir,status(a2)
                move.b  #1,jumping(a2)
                bset    #Status_Roll,status(a2)
                move.b  #2,anim(a2)
                move.b  #$E,y_radius(a2)
                move.b  #7,x_radius(a2)
                clr.w   ground_vel(a2)
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                move.w  d1,d3
                lsl.w   #3,d1
                sub.w   d3,d1
                move.w  d1,x_vel(a2)
                move.w  d0,d2
                lsl.w   #3,d0
                sub.w   d2,d0
                move.w  d0,y_vel(a2)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l

loc_3D730:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_3D736:
                move.l  #loc_3D78C,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$180,priority(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc2+$51,1,0),art_tile(a0)
                move.l  #Map_FBZMagneticPendulum,mappings(a0)
                move.b  #3,mapping_frame(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_3D78C
                move.w  a1,$44(a0)
                move.l  #loc_3D908,(a1)
                move.w  $12(a0),x_pos(a1)
                move.w  $16(a0),y_pos(a1)
                move.w  parent3(a0),parent3(a1)

loc_3D78C:
                tst.b   routine(a0)
                beq.s   loc_3D7A4
                move.w  $44(a0),d0
                beq.s   loc_3D79E
                movea.w d0,a1
                st      routine(a1)

loc_3D79E:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3D7A4:
                movea.w parent3(a0),a1
                move.b  angle(a1),d0
                jsr     (GetSineCosine).l
                swap    d1
                clr.w   d1
                asr.l   #1,d1
                move.l  d1,d3
                asr.l   #3,d3
                sub.l   d3,d1
                swap    d1
                add.w   $12(a0),d1
                move.w  d1,x_pos(a0)
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d3
                asr.l   #3,d3
                sub.l   d3,d0
                swap    d0
                add.w   $16(a0),d0
                move.w  d0,y_pos(a0)
                tst.b   $2F(a1)
                bne.w   loc_3D902
                lea     (Player_1).w,a2
                tst.b   object_control(a2)
                bne.w   loc_3D902
                cmpi.b  #4,routine(a2)
                bhs.w   loc_3D902
                tst.w   (Debug_placement_mode).w
                bne.w   loc_3D902
                tst.b   subtype(a1)
                bpl.s   loc_3D87A
                tst.w   x_vel(a2)
                bmi.w   loc_3D902
                move.w  x_pos(a0),d0
                subq.w  #8,d0
                cmp.w   x_pos(a2),d0
                bhi.w   loc_3D902
                addi.w  #$18,d0
                cmp.w   x_pos(a2),d0
                blo.w   loc_3D902
                moveq   #$1D,d0
                moveq   #$21,d1
                btst    #Status_Roll,status(a2)
                bne.s   loc_3D848
                moveq   #$22,d0
                moveq   #$26,d1
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_3D848
                moveq   #$1E,d0
                moveq   #$22,d1

loc_3D848:
                tst.b   $2E(a1)
                beq.s   loc_3D858
                subq.w  #1,d0
                neg.w   d0
                subq.w  #1,d1
                neg.w   d1
                exg     d0,d1

loc_3D858:
                move.w  y_pos(a0),d2
                sub.w   d0,d2
                cmp.w   y_pos(a2),d2
                blo.w   loc_3D902
                move.w  y_pos(a0),d2
                sub.w   d1,d2
                cmp.w   y_pos(a2),d2
                bhi.w   loc_3D902
                move.w  x_vel(a2),d0
                bra.s   loc_3D8E2
; ---------------------------------------------------------------------------

loc_3D87A:
                tst.w   y_vel(a2)
                bpl.w   loc_3D902
                move.w  y_pos(a0),d0
                addq.w  #8,d0
                cmp.w   y_pos(a2),d0
                blo.s   loc_3D902
                subi.w  #$18,d0
                cmp.w   y_pos(a2),d0
                bhi.s   loc_3D902
                moveq   #$1D,d0
                moveq   #$21,d1
                btst    #Status_Roll,status(a2)
                bne.s   loc_3D8B4
                moveq   #$22,d0
                moveq   #$26,d1
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_3D8B4
                moveq   #$1E,d0
                moveq   #$22,d1

loc_3D8B4:
                tst.b   $2E(a1)
                beq.s   loc_3D8C4
                subq.w  #1,d0
                neg.w   d0
                subq.w  #1,d1
                neg.w   d1
                exg     d0,d1

loc_3D8C4:
                move.w  x_pos(a0),d2
                sub.w   d0,d2
                cmp.w   x_pos(a2),d2
                blo.s   loc_3D902
                move.w  x_pos(a0),d2
                sub.w   d1,d2
                cmp.w   x_pos(a2),d2
                bhi.s   loc_3D902
                move.w  y_vel(a2),d0
                neg.w   d0

loc_3D8E2:
                mulu.w  #$51,d0
                lsr.l   #8,d0
                tst.b   $2E(a1)
                beq.s   loc_3D8F0
                neg.w   d0

loc_3D8F0:
                st      $2F(a1)
                move.w  d0,$30(a1)
                st      $32(a1)
                move.b  #1,object_control(a2)

loc_3D902:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_3D908:
                move.l  #loc_3D93A,(a0)
                move.b  #$44,render_flags(a0)
                move.b  #$70,height_pixels(a0)
                move.b  #$70,width_pixels(a0)
                move.w  #$180,priority(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc2+$51,1,0),art_tile(a0)
                move.l  #Map_FBZMagneticPendulum,mappings(a0)
                move.w  #5,mainspr_childsprites(a0)

loc_3D93A:
                tst.b   routine(a0)
                beq.s   loc_3D946
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3D946:
                movea.w parent3(a0),a1
                move.w  x_pos(a0),d3
                swap    d3
                clr.w   d3
                move.w  y_pos(a0),d2
                swap    d2
                clr.w   d2
                move.b  angle(a1),d0
                jsr     (GetSineCosine).l
                swap    d1
                clr.w   d1
                asr.l   #4,d1
                swap    d0
                clr.w   d0
                asr.l   #4,d0
                add.l   d1,d3
                add.l   d0,d2
                move.l  d1,d5
                move.l  d0,d4
                asr.l   #2,d5
                asr.l   #2,d4
                add.l   d5,d3
                add.l   d4,d2
                asr.l   #2,d5
                asr.l   #2,d4
                add.l   d5,d1
                add.l   d4,d0
                lea     sub2_x_pos(a0),a1
                moveq   #5-1,d4

loc_3D98E:
                swap    d3
                swap    d2
                move.w  d3,(a1)+
                move.w  d2,(a1)+
                addq.w  #1,a1
                move.b  #2,(a1)+
                swap    d3
                swap    d2
                add.l   d1,d3
                add.l   d0,d2
                dbf     d4,loc_3D98E
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_FBZMagneticPendulum:
                include "src/objects/shared/zones/fbz/map_magnetic_pendulum.s"
; End of function Obj_FBZMagneticPendulum
