; Owner: objects/zones/mhz/sk
; Responsibility: Horizontal swing-bar contact, character rotation and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZSwingBarHorizontal:
                move.l  #Map_MHZSwingBarHorizontal,mappings(a0)
                move.w  #make_art_tile(ArtTile_MHZMisc+$AC,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                move.l  #loc_3ED46,(a0)

loc_3ED46:
                lea     $30(a0),a2
                lea     $3A(a0),a3
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d1
                bsr.s   UpdatePlayerOnMhzHorizontalSwingBar
                addq.w  #1,a2
                lea     $3C(a0),a3
                lea     (Player_2).w,a1
                move.w  (Ctrl_2_logical).w,d1
                bsr.s   UpdatePlayerOnMhzHorizontalSwingBar
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnMhzHorizontalSwingBar:
                tst.b   (a2)
                beq.w   loc_3EECE
                tst.w   (Debug_placement_mode).w
                bne.w   loc_3EE2C
                cmpi.b  #4,routine(a1)
                bhs.w   loc_3EE2C
                btst    #button_left+8,d1
                beq.s   loc_3EDB6
                move.w  x_pos(a0),d0
                subi.w  #$16,d0
                cmp.w   x_pos(a1),d0
                bge.s   loc_3EDB6
                subq.w  #1,x_pos(a1)
                subq.b  #1,6(a2)
                bpl.s   loc_3EDB6
                move.b  #7,6(a2)
                addi.b  #$10,8(a2)
                andi.b  #$10,8(a2)

loc_3EDB6:
                btst    #button_right+8,d1
                beq.s   loc_3EDE6
                move.w  x_pos(a0),d0
                addi.w  #$15,d0
                cmp.w   x_pos(a1),d0
                ble.s   loc_3EDE6
                addq.w  #1,x_pos(a1)
                subq.b  #1,6(a2)
                bpl.s   loc_3EDE6
                move.b  #7,6(a2)
                addi.b  #$10,8(a2)
                andi.b  #$10,8(a2)

loc_3EDE6:
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d1
                bne.w   loc_3EE18
                cmpi.b  #$28,4(a2)
                beq.w   loc_3EE7A
                cmpi.b  #5,4(a2)
                beq.w   loc_3EEC2
                bsr.w   UpdateMhzHorizontalBarPlayerPose
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------

loc_3EE18:
                move.w  #-$500,y_vel(a1)
                btst    #Status_Underwater,status(a1)
                beq.s   loc_3EE2C
                move.w  #-$200,y_vel(a1)

loc_3EE2C:
                clr.b   (a2)
                move.b  #30,2(a2)
                btst    #Status_Underwater,status(a1)
                beq.s   loc_3EE42
                move.b  #60,2(a2)

loc_3EE42:
                andi.b  #$FC,object_control(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,flip_angle(a1)
                rts
; ---------------------------------------------------------------------------

loc_3EE7A:
                move.w  #$10<<8,anim(a1)                ; and prev_anim
                move.w  (a3),d0
                move.w  d0,d1
                asr.w   #1,d1
                add.w   d1,d0
                move.w  d0,y_vel(a1)

loc_3EE8C:
                clr.b   (a2)
                move.b  #8,2(a2)
                andi.b  #$FC,object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                move.b  #2,routine(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,flip_angle(a1)
                rts
; ---------------------------------------------------------------------------

loc_3EEC2:
                move.w  #0,anim(a1)
                move.w  (a3),y_vel(a1)
                bra.s   loc_3EE8C
; ---------------------------------------------------------------------------

loc_3EECE:
                tst.b   2(a2)
                beq.s   loc_3EEDA
                subq.b  #1,2(a2)
                rts
; ---------------------------------------------------------------------------

loc_3EEDA:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$16,d0
                cmpi.w  #$2C,d0
                bhs.w   locret_3EFB8
                move.w  y_pos(a0),d0
                addi.w  #$14,d0
                cmp.w   y_pos(a1),d0
                bhs.w   locret_3EFB8
                addi.w  #$10,d0
                cmp.w   y_pos(a1),d0
                bcs.w   locret_3EFB8
                tst.w   (Debug_placement_mode).w
                bne.w   locret_3EFB8
                cmpi.b  #4,routine(a1)
                bhs.w   locret_3EFB8
                tst.b   object_control(a1)
                bne.w   locret_3EFB8
                move.w  y_vel(a1),(a3)
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                andi.b  #$FC,render_flags(a1)
                move.w  y_pos(a0),d0
                addi.w  #$14,d0
                move.w  d0,y_pos(a1)
                move.b  #0,anim(a1)
                move.b  #3,object_control(a1)
                move.b  #$94,mapping_frame(a1)
                move.b  #0,4(a2)
                move.b  #0,6(a2)
                move.b  #0,8(a2)
                cmpi.w  #-$400,(a3)
                bgt.s   loc_3EF84
                move.b  #$95,mapping_frame(a1)
                move.b  #$20,4(a2)
                move.b  #$10,8(a2)
                bra.s   loc_3EF9C
; ---------------------------------------------------------------------------

loc_3EF84:
                cmpi.w  #$400,(a3)
                blt.s   loc_3EF9C
                move.b  #$95,mapping_frame(a1)
                move.b  #$21,4(a2)
                move.b  #$10,8(a2)

loc_3EF9C:
                move.b  #1,(a2)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l

locret_3EFB8:
                rts
; End of function UpdatePlayerOnMhzHorizontalSwingBar

; =============== S U B R O U T I N E =======================================

UpdateMhzHorizontalBarPlayerPose:
                cmpi.w  #-$400,(a3)
                ble.s   loc_3EFE6
                cmpi.w  #$400,(a3)
                bge.s   loc_3EFE6
                move.b  4(a2),d0
                beq.s   loc_3EFE4
                bpl.s   loc_3EFD8
                addi.b  #6,d0
                bcc.s   loc_3EFD6
                moveq   #0,d0

loc_3EFD6:
                bra.s   loc_3EFE0
; ---------------------------------------------------------------------------

loc_3EFD8:
                subi.b  #6,d0
                bcc.s   loc_3EFE0
                moveq   #0,d0

loc_3EFE0:
                move.b  d0,4(a2)

loc_3EFE4:
                bra.s   loc_3EFF2
; ---------------------------------------------------------------------------

loc_3EFE6:
                move.b  4(a2),d0
                addi.b  #$C,d0
                move.b  d0,4(a2)

loc_3EFF2:
                moveq   #0,d0
                move.b  4(a2),d0
                lsr.b   #4,d0
                add.b   8(a2),d0
                move.b  RawAni_3F01A(pc,d0.w),d1
                move.b  d1,mapping_frame(a1)
                andi.w  #$F,d0
                move.b  byte_3F03A(pc,d0.w),d1
                ext.w   d1
                add.w   y_pos(a0),d1
                move.w  d1,y_pos(a1)
                rts
; End of function UpdateMhzHorizontalBarPlayerPose

; ---------------------------------------------------------------------------
RawAni_3F01A:
                dc.b    $94, $63, $64, $64, $65, $65, $65, $66, $66, $66, $66, $67, $67, $67, $68, $68, $95, $63, $64, $64
                dc.b    $65, $65, $65, $66, $66, $66, $66, $67, $67, $67, $68, $68
byte_3F03A:
                dc.b    $14, $14,  $B,  $B, -$F, -$F, -$F,-$14,-$14,-$14,-$14, -$C, -$C, -$C,  -2,  -2
                even
