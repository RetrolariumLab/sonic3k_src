; Owner: objects/zones/hcz/sk
; Responsibility: Hydrocity spinning column player contact, rotating transport and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZSpinningColumn:
                move.l  #Map_HCZSpinningColumn,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZ2BlockPlat+$18,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  x_pos(a0),$2E(a0)
                move.w  y_pos(a0),$30(a0)
                move.b  subtype(a0),d0
                move.w  d0,d1
                add.w   d0,d0
                andi.w  #6,d0
                move.w  d0,$3A(a0)
                andi.w  #$F0,d1
                move.w  d1,$40(a0)
                move.w  #1,$42(a0)
                cmpi.w  #$E0,d1
                bne.s   loc_326B0
                neg.w   $42(a0)

loc_326B0:
                move.l  #loc_326B6,(a0)

loc_326B6:
                bsr.s   UpdateHczSpinningColumnMotion
                lea     $32(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                move.w  (Ctrl_1_logical).w,d5
                bsr.w   UpdatePlayerOnHczSpinningColumn
                addq.w  #4,a2
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d5
                bsr.w   UpdatePlayerOnHczSpinningColumn
                move.w  #$1B,d1
                move.w  #$20,d2
                move.w  #$21,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_32708
                move.b  #7,anim_frame_timer(a0)
                subq.b  #1,mapping_frame(a0)
                bcc.s   loc_32708
                move.b  #2,mapping_frame(a0)

loc_32708:
                move.w  $2E(a0),d0
                jmp     (Sprite_OnScreen_Test2).l

; =============== S U B R O U T I N E =======================================

UpdateHczSpinningColumnMotion:
                move.w  $3A(a0),d0
                move.w  off_3271E(pc,d0.w),d0
                jmp     off_3271E(pc,d0.w)
; End of function UpdateHczSpinningColumnMotion

; ---------------------------------------------------------------------------
off_3271E:
                dc.w    locret_32724-off_3271E
                dc.w    loc_32726-off_3271E
                dc.w    loc_32766-off_3271E
; ---------------------------------------------------------------------------

locret_32724:
                rts
; ---------------------------------------------------------------------------

loc_32726:
                move.w  $42(a0),d1
                bmi.s   loc_3273E
                move.w  $40(a0),d0
                add.w   d1,d0
                cmpi.w  #$E0,d0
                bne.s   loc_3273C
                neg.w   $42(a0)

loc_3273C:
                bra.s   loc_3274A
; ---------------------------------------------------------------------------

loc_3273E:
                move.w  $40(a0),d0
                add.w   d1,d0
                bne.s   loc_3274A
                neg.w   $42(a0)

loc_3274A:
                move.w  d0,$40(a0)
                subi.w  #$70,d0
                btst    #0,status(a0)
                beq.s   loc_3275C
                neg.w   d0

loc_3275C:
                add.w   $2E(a0),d0
                move.w  d0,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_32766:
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                btst    #0,status(a0)
                beq.s   loc_3277A
                neg.w   d0
                addi.w  #$80,d0

loc_3277A:
                add.w   $30(a0),d0
                move.w  d0,y_pos(a0)
                rts

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnHczSpinningColumn:
                move.b  (a2),d0
                bne.s   loc_327FC
                btst    d6,status(a0)
                beq.s   locret_327FA
                move.b  #0,1(a2)
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bpl.s   loc_327A6
                neg.w   d0
                move.b  #$80,1(a2)

loc_327A6:
                move.b  d0,2(a2)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.w  #0,ground_vel(a1)
                move.b  #3,object_control(a1)
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                bclr    #Status_Roll,status(a1)
                bclr    #Status_InAir,status(a1)
                bclr    #Status_Push,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,jumping(a1)
                move.b  #0,anim(a1)
                move.b  #1,(a2)
                bra.w   loc_3260A
; ---------------------------------------------------------------------------

locret_327FA:
                rts
; ---------------------------------------------------------------------------

loc_327FC:
                tst.b   render_flags(a1)
                bpl.w   loc_328AC
                cmpi.b  #4,routine(a1)
                bhs.w   loc_328AC
                btst    d6,status(a0)
                beq.w   loc_328BE
                tst.b   2(a2)
                beq.s   loc_32820
                subq.b  #1,2(a2)

loc_32820:
                moveq   #0,d0
                move.b  1(a2),d0
                jsr     (GetSineCosine).l
                addi.w  #$100,d0
                asr.w   #2,d0
                move.b  d0,3(a2)
                moveq   #0,d2
                move.w  2(a2),d2
                muls.w  d2,d1
                swap    d1
                add.w   x_pos(a0),d1
                move.w  d1,x_pos(a1)
                addq.b  #2,1(a2)
                move.w  #0,ground_vel(a1)
                move.w  y_vel(a0),d0
                bpl.s   loc_3285A
                neg.w   d0

loc_3285A:
                btst    #Status_InAir,status(a1)
                bne.s   loc_3286E
                cmpi.w  #$480,d0
                blo.s   loc_3286E
                move.w  #$800,ground_vel(a1)

loc_3286E:
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d5
                beq.w   loc_3260A
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                move.w  y_vel(a0),y_vel(a1)
                addi.w  #-$680,y_vel(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,ground_vel(a1)

loc_328AC:
                bset    #Status_InAir,status(a1)
                move.w  #$100,priority(a1)
                move.b  #0,object_control(a1)

loc_328BE:
                move.b  #0,(a2)
                rts
; End of function UpdatePlayerOnHczSpinningColumn
