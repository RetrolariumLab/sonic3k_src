; Owner: game/blue_sphere/sk
; Responsibility: Blue Sphere mode label and rotating option-icon placement, selection state and private position records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SpheresTitle_4D610:
                move.l  #Map_BlueSpheresText,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Misc,0,1),art_tile(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$128,y_pos(a0)
                move.w  #$80,priority(a0)
                move.b  #$14,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.b  #3,mapping_frame(a0)
                move.l  #loc_4D648,(a0)

loc_4D648:
                jmp     (Draw_Sprite).l
; End of function Obj_SpheresTitle_4D610
; ---------------------------------------------------------------------------

Obj_SpheresTitle_4D64E:
                move.l  #Map_BlueSpheresIcon,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Misc+$4A,3,1),art_tile(a0)
                cmpi.w  #3,(Player_option).w
                bne.s   loc_4D66A
                move.w  #make_art_tile(ArtTile_BlueSphere_Misc+$4A,0,1),art_tile(a0)

loc_4D66A:
                move.w  #$100,x_pos(a0)
                move.w  #$126,y_pos(a0)
                tst.b   (Blue_spheres_mode).w
                bne.s   loc_4D682
                move.w  #$BE,y_pos(a0)

loc_4D682:
                move.l  #word_4D7A6,$30(a0)
                btst    #0,render_flags(a0)
                beq.s   loc_4D6A0
                move.w  #$140,x_pos(a0)
                move.l  #word_4D7B2,$30(a0)

loc_4D6A0:
                move.w  #0,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.l  #loc_4D6B8,(a0)

loc_4D6B8:
                tst.b   (Blue_spheres_mode).w
                beq.w   loc_4D75E
                movea.l $30(a0),a1
                moveq   #0,d0
                move.b  (Blue_spheres_option).w,d0
                lsl.w   #2,d0
                move.w  (a1,d0.w),d2
                move.w  2(a1,d0.w),d3
                cmp.w   x_pos(a0),d2
                bne.s   loc_4D6F0
                move.w  x_vel(a0),d0
                addi.w  #$80,d0
                cmpi.w  #$100,d0
                bhi.s   loc_4D6F0
                moveq   #0,d1
                move.w  d1,x_vel(a0)
                bra.s   loc_4D712
; ---------------------------------------------------------------------------

loc_4D6F0:
                move.w  #$40,d1
                cmp.w   x_pos(a0),d2
                bge.s   loc_4D708
                neg.w   d1
                tst.w   x_vel(a0)
                bmi.s   loc_4D712
                add.w   d1,d1
                add.w   d1,d1
                bra.s   loc_4D712
; ---------------------------------------------------------------------------

loc_4D708:
                tst.w   x_vel(a0)
                bpl.s   loc_4D712
                add.w   d1,d1
                add.w   d1,d1

loc_4D712:
                add.w   d1,x_vel(a0)
                cmp.w   y_pos(a0),d3
                bne.s   loc_4D732
                move.w  y_vel(a0),d0
                addi.w  #$100,d0
                cmpi.w  #$200,d0
                bhi.s   loc_4D732
                moveq   #0,d1
                move.w  d1,y_vel(a0)
                bra.s   loc_4D754
; ---------------------------------------------------------------------------

loc_4D732:
                move.w  #$80,d1
                cmp.w   y_pos(a0),d3
                bge.s   loc_4D74A
                neg.w   d1
                tst.w   y_vel(a0)
                bmi.s   loc_4D754
                add.w   d1,d1
                add.w   d1,d1
                bra.s   loc_4D754
; ---------------------------------------------------------------------------

loc_4D74A:
                tst.w   y_vel(a0)
                bpl.s   loc_4D754
                add.w   d1,d1
                add.w   d1,d1

loc_4D754:
                add.w   d1,y_vel(a0)
                jsr     (MoveSprite2).l

loc_4D75E:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_4D774
                move.b  #3-1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #7,mapping_frame(a0)

loc_4D774:
                move.b  (Ctrl_1_pressed).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   loc_4D7A0
                move.w  art_tile(a0),d0
                move.w  #3,(Player_option).w
                move.w  #make_art_tile(ArtTile_BlueSphere_Misc+$4A,0,1),art_tile(a0)
                cmpi.w  #make_art_tile(ArtTile_BlueSphere_Misc+$4A,0,1),d0
                bne.s   loc_4D7A0
                move.w  #1,(Player_option).w
                move.w  #make_art_tile(ArtTile_BlueSphere_Misc+$4A,3,1),art_tile(a0)

loc_4D7A0:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
word_4D7A6:
                dc.w    $100,   $AE
                dc.w    $100,  $126
                dc.w    $C8,  $142
word_4D7B2:
                dc.w    $140,   $AE
                dc.w    $140,  $126
                dc.w    $178,  $142
; End of function Obj_SpheresTitle_4D64E
