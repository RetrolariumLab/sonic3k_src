; Owner: objects/zones/ssz/sk
; Responsibility: Sky Sanctuary and Hidden Palace teleporter capture, transition control and player release
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SSZHPZTeleporter:
                move.l  #loc_455CC,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$18,width_pixels(a0)
                move.w  #$180,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$88,0,0),art_tile(a0)
                move.l  #Map_SSZHPZTeleporter,mappings(a0)
                move.w  y_pos(a0),$16(a0)
                move.b  subtype(a0),d0
                bpl.s   loc_45574
                lea     (Events_bg+$00).w,a1
                add.b   d0,d0
                bpl.s   loc_4556A
                addq.w  #2,a1

loc_4556A:
                tst.b   (a1)
                bmi.s   loc_45574
                move.w  #$20,y_vel(a0)

loc_45574:
                cmpi.w  #$1701,(Current_zone_and_act).w
                beq.s   loc_455AC
                cmpi.b  #$16,(Current_zone).w
                bne.s   loc_455BA
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_45596
                move.l  #loc_45B94,(a1)
                move.w  a0,$2E(a1)

loc_45596:
                move.w  #make_art_tile(ArtTile_HPZTeleporter,0,0),art_tile(a0)  ; If in HPZ, use this VRAM offset
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_455B2
                move.b  #$4A,subtype(a0)
                bra.s   loc_455B2
; ---------------------------------------------------------------------------

loc_455AC:
                move.w  #make_art_tile(ArtTile_SSZMisc+$1b4,0,0),art_tile(a0)

loc_455B2:
                move.b  #$A,mapping_frame(a0)
                bra.s   loc_455CC
; ---------------------------------------------------------------------------

loc_455BA:
                cmpi.w  #$1A00,x_pos(a0)
                blo.s   loc_455CC
                cmpi.w  #$680,y_pos(a0)
                blo.w   loc_45A66

loc_455CC:
                cmpi.b  #$16,(Current_zone).w
                bne.s   loc_455F8
                tst.b   render_flags(a0)
                bpl.s   loc_455EE
                tst.b   $38(a0)
                bne.s   loc_455F8
                move.l  #$40C0408,(Normal_palette_line_4+$2).w
                st      (Palette_cycle_counters+$00).w
                bra.s   loc_455F8
; ---------------------------------------------------------------------------

loc_455EE:
                tst.b   $38(a0)
                bne.s   loc_455F8
                clr.b   (Palette_cycle_counters+$00).w

loc_455F8:
                move.w  $16(a0),d0
                add.w   $1A(a0),d0
                move.w  d0,y_pos(a0)
                jsr     sub_45866(pc)
                tst.b   subtype(a0)
                bne.s   loc_45616
                tst.b   (Events_bg+$04).w
                bne.w   loc_456EE

loc_45616:
                tst.w   $1A(a0)
                bne.s   loc_4562C
                moveq   #$23,d1
                lea     byte_466E8(pc),a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped2).l

loc_4562C:
                lea     (Events_bg+$00).w,a1
                move.b  subtype(a0),d0
                beq.w   loc_456EE
                bpl.s   loc_45660
                add.b   d0,d0
                bpl.s   loc_45640
                addq.w  #2,a1

loc_45640:
                tst.b   (a1)
                bpl.w   loc_456EE
                tst.w   $1A(a0)
                beq.s   loc_45660
                move.w  (Level_frame_counter).w,d0
                andi.w  #3,d0
                bne.w   loc_456EE
                subq.w  #1,y_vel(a0)
                bra.w   loc_456EE
; ---------------------------------------------------------------------------

loc_45660:
                btst    #p1_standing_bit,status(a0)
                beq.w   loc_456EE
                lea     (Player_1).w,a2
                move.w  x_pos(a2),d0
                sub.w   x_pos(a0),d0
                addi.w  #$C,d0
                cmpi.w  #$18,d0
                bhs.s   loc_456EE
                tst.b   object_control(a2)
                bne.w   loc_456EE
                cmpi.b  #4,routine(a2)
                bhs.w   loc_456EE
                tst.w   (Debug_placement_mode).w
                bne.w   loc_456EE
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_456EE
                move.w  a1,$3C(a0)
                move.l  #Obj_TeleporterBeam,(a1)
                move.w  a0,parent2(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                clr.w   x_vel(a2)
                clr.w   ground_vel(a2)
                move.w  #-1,y_vel(a2)
                clr.b   spin_dash_flag(a2)
                move.b  #1,object_control(a2)
                move.b  #5,anim(a2)
                move.l  #loc_456F4,(a0)
                move.w  #-$100,$38(a0)
                moveq   #signextendB(sfx_Charging),d0
                jsr     (Play_SFX).l

loc_456EE:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_456F4:
                jsr     sub_45856(pc)
                lea     (Player_1).w,a1
                movea.w $3C(a0),a2
                cmpi.b  #8,$46(a2)
                blt.w   loc_457B8
                beq.w   loc_457A2
                cmpi.b  #$18,$46(a2)
                bhs.s   loc_45744
                btst    #0,(Level_frame_counter+1).w
                beq.w   loc_457B8
                subq.w  #1,y_pos(a1)
                btst    #1,(Level_frame_counter+1).w
                beq.w   loc_457B8
                moveq   #1,d1
                move.w  x_pos(a1),d0
                cmp.w   x_pos(a0),d0
                beq.s   loc_457B8
                bcs.s   loc_4573E
                neg.w   d1

loc_4573E:
                add.w   d1,x_pos(a1)
                bra.s   loc_457B8
; ---------------------------------------------------------------------------

loc_45744:
                move.l  #loc_457BE,(a0)
                move.b  subtype(a0),d0
                cmpi.b  #$16,(Current_zone).w
                beq.s   loc_4575A
                andi.w  #$3F,d0

loc_4575A:
                move.b  d0,$2D(a0)
                move.b  #3,object_control(a1)
                moveq   #0,d0
                move.b  d0,anim(a1)
                move.b  d0,mapping_frame(a1)
                cmpi.b  #$16,(Current_zone).w
                bne.s   loc_4577E
                move.w  #$AA0,(Camera_min_X_pos).w
                bra.s   loc_45790
; ---------------------------------------------------------------------------

loc_4577E:
                move.w  #-$100,(Camera_min_Y_pos).w
                move.w  #$1000,d0
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w

loc_45790:
                clr.b   (Events_bg+$05).w
                moveq   #signextendB(sfx_Transporter),d0
                jsr     (Play_SFX).l
                st      (Scroll_lock).w
                bra.s   loc_457B8
; ---------------------------------------------------------------------------

loc_457A2:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_Roll,status(a1)
                move.b  #2,anim(a1)
                st      (Events_bg+$04).w

loc_457B8:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_457BE:
                jsr     sub_45856(pc)
                lea     (Player_1).w,a1
                tst.b   $2D(a0)
                bne.s   loc_45804
                move.b  #1,object_control(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                move.w  y_pos(a1),$3E(a0)
                clr.l   $2E(a0)
                clr.l   $32(a0)
                clr.b   $36(a0)
                clr.b   (Scroll_lock).w
                movea.w $3C(a0),a1
                st      routine(a1)
                move.l  #loc_4581C,(a0)
                rts
; ---------------------------------------------------------------------------

loc_45804:
                subi.w  #$10,y_pos(a1)
                subq.b  #1,$2D(a0)
                beq.s   loc_45816
                subi.w  #$10,(Camera_Y_pos).w

loc_45816:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4581C:
                jsr     sub_45856(pc)
                lea     (Player_1).w,a1
                move.l  #$20000,d0
                move.l  #$800,d1
                jsr     Gradual_SwingOffset(pc)
                add.w   $3E(a0),d0
                move.w  d0,y_pos(a1)
                tst.l   $2E(a0)
                bmi.s   locret_45854
                clr.b   object_control(a1)
                clr.b   anim(a1)
                clr.b   (Events_bg+$04).w
                move.l  #loc_455CC,(a0)

locret_45854:
                rts

; =============== S U B R O U T I N E =======================================

sub_45856:
                moveq   #$23,d1
                lea     byte_466E8(pc),a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped2).l
; End of function sub_45856

; =============== S U B R O U T I N E =======================================

sub_45866:
                tst.b   $39(a0)
                beq.s   loc_45872
                subq.b  #1,$39(a0)
                bra.s   locret_458B2
; ---------------------------------------------------------------------------

loc_45872:
                move.b  #3,$39(a0)
                move.w  $3A(a0),d0
                bne.s   loc_45884
                tst.b   $38(a0)
                beq.s   locret_458B2

loc_45884:
                addq.w  #4,d0
                cmpi.w  #$28,d0
                blo.s   loc_4588E
                moveq   #0,d0

loc_4588E:
                move.w  d0,$3A(a0)
                lea     word_4670C(pc),a1
                cmpi.b  #$A,(Current_zone).w
                bne.s   loc_458A6
                move.l  (a1,d0.w),(Normal_palette_line_3+$18).w
                bra.s   locret_458B2
; ---------------------------------------------------------------------------

loc_458A6:
                move.w  2(a1,d0.w),(Normal_palette_line_4+$2).w
                move.w  (a1,d0.w),(Normal_palette_line_4+$4).w

locret_458B2:
                rts
; End of function sub_45866
