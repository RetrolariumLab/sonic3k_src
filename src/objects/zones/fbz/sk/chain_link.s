; Owner: objects/zones/fbz/sk
; Responsibility: Chain-link traversal, player attachment, coordinated motion and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZChainLink:
                move.b  subtype(a0),d0
                bpl.s   loc_3A7E6
                andi.w  #$3F,d0
                lsl.w   #4,d0
                move.w  d0,$3E(a0)
                move.l  #loc_3AA5A,(a0)
                bra.w   loc_3AA5A
; ---------------------------------------------------------------------------

loc_3A7E6:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.b  #$80,height_pixels(a0)
                move.w  y_pos(a0),$46(a0)
                move.l  #Map_FBZChainLink,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc,2,0),art_tile(a0)
                move.b  subtype(a0),d0
                andi.w  #$7F,d0
                lsl.w   #3,d0
                move.w  d0,$2E(a0)
                move.w  #2,$3C(a0)
                move.b  subtype(a0),d0
                bpl.s   loc_3A846
                move.w  $2E(a0),d0
                move.w  d0,$3A(a0)
                move.b  #1,$38(a0)
                add.w   d0,y_pos(a0)
                lsr.w   #4,d0
                addq.w  #1,d0
                move.b  d0,mapping_frame(a0)

loc_3A846:
                move.l  #loc_3A84C,(a0)

loc_3A84C:
                tst.b   $38(a0)
                beq.s   loc_3A85A
                tst.w   $30(a0)
                bne.s   loc_3A870
                bra.s   loc_3A860
; ---------------------------------------------------------------------------

loc_3A85A:
                tst.w   $30(a0)
                beq.s   loc_3A870

loc_3A860:
                move.w  $3A(a0),d2
                cmp.w   $2E(a0),d2
                beq.s   loc_3A894
                add.w   $3C(a0),d2
                bra.s   loc_3A87A
; ---------------------------------------------------------------------------

loc_3A870:
                move.w  $3A(a0),d2
                beq.s   loc_3A894
                sub.w   $3C(a0),d2

loc_3A87A:
                move.w  d2,$3A(a0)
                move.w  $46(a0),d0
                add.w   d2,d0
                move.w  d0,y_pos(a0)
                move.w  d2,d0
                beq.s   loc_3A890
                lsr.w   #4,d0
                addq.w  #1,d0

loc_3A890:
                move.b  d0,mapping_frame(a0)

loc_3A894:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d0
                bsr.w   sub_3A8B8
                lea     (Player_2).w,a1
                addq.w  #1,a2
                move.w  (Ctrl_2_logical).w,d0
                bsr.w   sub_3A8B8
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_3A8B8:
                tst.b   (a2)
                beq.w   loc_3A9A6
                tst.b   render_flags(a1)
                bpl.w   loc_3A954
                tst.w   (Debug_placement_mode).w
                bne.w   loc_3A954
                cmpi.b  #4,routine(a1)
                bhs.s   loc_3A954
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_3A96E
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$12,2(a2)
                andi.w  #(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
                beq.w   loc_3A8F8
                move.b  #$3C,2(a2)

loc_3A8F8:
                btst    #button_left+8,d0
                beq.s   loc_3A904
                move.w  #-$200,x_vel(a1)

loc_3A904:
                btst    #button_right+8,d0
                beq.s   loc_3A910
                move.w  #$200,x_vel(a1)

loc_3A910:
                move.w  #-$380,y_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,flip_angle(a1)
                bclr    #3,status(a1)
                move.w  #0,interact(a1)
                rts
; ---------------------------------------------------------------------------

loc_3A954:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)
                bclr    #Status_OnObj,status(a1)
                move.w  #0,interact(a1)
                rts
; ---------------------------------------------------------------------------

loc_3A96E:
                btst    #button_left+8,d0
                beq.s   loc_3A97A
                bset    #0,status(a1)

loc_3A97A:
                btst    #button_right+8,d0
                beq.s   loc_3A986
                bclr    #Status_Facing,status(a1)

loc_3A986:
                move.b  status(a1),d0
                andi.b  #1,d0
                andi.b  #$FE,render_flags(a1)
                or.b    d0,render_flags(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$9C,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

loc_3A9A6:
                tst.b   2(a2)
                beq.s   loc_3A9B4
                subq.b  #1,2(a2)
                bne.w   locret_3AA58

loc_3A9B4:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   locret_3AA58
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                subi.w  #$90,d1
                cmpi.w  #$18,d1
                bhs.w   locret_3AA58
                tst.b   object_control(a1)
                bmi.s   locret_3AA58
                cmpi.b  #4,routine(a1)
                bhs.s   locret_3AA58
                tst.w   (Debug_placement_mode).w
                bne.s   locret_3AA58
                btst    #Status_OnObj,status(a1)
                beq.s   loc_3AA18
                movea.w interact(a1),a3
                cmpi.l  #loc_3AA5A,(a3)
                bne.s   loc_3AA18
                move.w  a2,d0
                sub.w   a0,d0
                adda.w  d0,a3
                tst.b   4(a3)
                bne.s   locret_3AA58
                clr.b   (a3)
                move.b  #$3C,2(a3)

loc_3AA18:
                move.w  a0,interact(a1)
                bset    #Status_OnObj,status(a1)
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$9C,y_pos(a1)
                move.b  #$14,anim(a1)
                move.b  #1,object_control(a1)
                move.b  #1,(a2)
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l

locret_3AA58:
                rts
; ---------------------------------------------------------------------------

loc_3AA5A:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d0
                bsr.w   sub_3AA7E
                lea     (Player_2).w,a1
                addq.w  #1,a2
                move.w  (Ctrl_2_logical).w,d0
                bsr.w   sub_3AA7E
                jmp     (Delete_Sprite_If_Not_In_Range).l
; End of function sub_3A8B8

; =============== S U B R O U T I N E =======================================

sub_3AA7E:
                tst.b   (a2)
                beq.w   loc_3AC86
                tst.b   render_flags(a1)
                bpl.w   loc_3AB24
                tst.w   (Debug_placement_mode).w
                bne.w   loc_3AB24
                cmpi.b  #4,routine(a1)
                bhs.w   loc_3AB24
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_3AB3E
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$12,2(a2)
                andi.w  #(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
                beq.w   loc_3AAC0
                move.b  #$3C,2(a2)

loc_3AAC0:
                btst    #button_left+8,d0
                beq.s   loc_3AACC
                move.w  #-$200,x_vel(a1)

loc_3AACC:
                btst    #button_right+8,d0
                beq.s   loc_3AAD8
                move.w  #$200,x_vel(a1)

loc_3AAD8:
                move.w  #-$380,y_vel(a1)
                bset    #1,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.b  #$96,mapping_frame(a1)
                bset    #Status_Roll,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.b  #0,flip_angle(a1)
                bclr    #Status_OnObj,status(a1)
                move.w  #0,interact(a1)
                bra.w   loc_3AC26
; ---------------------------------------------------------------------------

loc_3AB24:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)
                bclr    #Status_OnObj,status(a1)
                move.w  #0,interact(a1)
                rts
; ---------------------------------------------------------------------------

loc_3AB3E:
                tst.b   4(a2)
                bne.s   loc_3ABBE

loc_3AB44:
                move.w  $3E(a0),d2
                subi.w  #$10,d2
                btst    #button_left+8,d0
                beq.s   loc_3AB70
                bset    #Status_Facing,status(a1)
                move.w  x_pos(a1),d1
                sub.w   x_pos(a0),d1
                add.w   d2,d1
                beq.s   loc_3AB70
                move.b  #4,4(a2)
                move.b  #1,2(a2)

loc_3AB70:
                btst    #button_right+8,d0
                beq.s   loc_3AB9A
                bclr    #Status_Facing,status(a1)
                move.w  x_pos(a1),d1
                sub.w   x_pos(a0),d1
                add.w   d2,d1
                add.w   d2,d2
                cmp.w   d2,d1
                beq.w   loc_3AB9A
                move.b  #4,4(a2)
                move.b  #0,2(a2)

loc_3AB9A:
                move.b  status(a1),d0
                andi.b  #1,d0
                andi.b  #$FC,render_flags(a1)
                or.b    d0,render_flags(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$12,y_pos(a1)
                tst.b   4(a2)
                beq.s   loc_3AC26

loc_3ABBE:
                subq.b  #1,6(a2)
                bpl.s   loc_3AC26
                move.b  #7,6(a2)
                move.b  #0,anim(a1)
                moveq   #0,d1
                move.b  4(a2),d1
                cmpi.b  #2,d1
                bne.s   loc_3ABE4
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l

loc_3ABE4:
                subq.w  #1,d1
                bne.s   loc_3ABEE
                move.b  #$14,anim(a1)

loc_3ABEE:
                add.b   8(a2),d1
                move.b  RawAni_3AC38(pc,d1.w),mapping_frame(a1)
                move.b  byte_3AC40(pc,d1.w),d1
                ext.w   d1
                tst.b   2(a2)
                beq.s   loc_3AC06
                neg.w   d1

loc_3AC06:
                add.w   d1,x_pos(a1)
                subq.b  #1,4(a2)
                bne.s   loc_3AC26
                bsr.s   sub_3AC48
                move.b  #0,6(a2)
                bchg    #2,8(a2)
                andi.w  #(button_left_mask|button_right_mask)<<8,d0
                bne.w   loc_3AB44

loc_3AC26:
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; End of function sub_3AA7E

; ---------------------------------------------------------------------------
RawAni_3AC38:
                dc.b    $91, $81, $80, $85, $91, $84, $83, $82
byte_3AC40:
                dc.b    4,  $C,  $A,   6,   4,  $C,  $C,   4
                even

; =============== S U B R O U T I N E =======================================

sub_3AC48:
                btst    #6,subtype(a0)
                beq.s   locret_3AC84
                move.w  $3E(a0),d2
                subi.w  #$10,d2
                btst    #0,status(a0)
                beq.s   loc_3AC70
                move.w  x_pos(a1),d1
                sub.w   x_pos(a0),d1
                add.w   d2,d1
                bne.s   locret_3AC84
                bra.w   loc_3AB24
; ---------------------------------------------------------------------------

loc_3AC70:
                move.w  x_pos(a1),d1
                sub.w   x_pos(a0),d1
                add.w   d2,d1
                add.w   d2,d2
                cmp.w   d2,d1
                bne.s   locret_3AC84
                bra.w   loc_3AB24
; ---------------------------------------------------------------------------

locret_3AC84:
                rts
; End of function sub_3AC48

; ---------------------------------------------------------------------------

loc_3AC86:
                tst.b   2(a2)
                beq.s   loc_3AC94
                subq.b  #1,2(a2)
                bne.w   locret_3AD88

loc_3AC94:
                move.w  $3E(a0),d2
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d2,d0
                add.w   d2,d2
                cmp.w   d2,d0
                bhs.w   locret_3AD88
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                cmpi.w  #$18,d1
                bhs.w   locret_3AD88
                tst.b   object_control(a1)
                bmi.w   locret_3AD88
                cmpi.b  #4,routine(a1)
                bhs.w   locret_3AD88
                tst.w   (Debug_placement_mode).w
                bne.w   locret_3AD88
                btst    #Status_OnObj,status(a1)
                beq.s   loc_3ACEA
                movea.w interact(a1),a3
                cmpi.l  #loc_3A84C,(a3)
                beq.w   locret_3AD88

loc_3ACEA:
                andi.w  #$FFE0,d0
                btst    #6,subtype(a0)
                beq.s   loc_3AD10
                btst    #0,status(a0)
                beq.s   loc_3AD06
                tst.w   d0
                beq.w   locret_3AD88
                bra.s   loc_3AD10
; ---------------------------------------------------------------------------

loc_3AD06:
                subi.w  #$20,d2
                cmp.w   d2,d0
                beq.w   locret_3AD88

loc_3AD10:
                addi.w  #$10,d0
                sub.w   $3E(a0),d0
                add.w   x_pos(a0),d0
                move.w  d0,x_pos(a1)
                move.w  a0,interact(a1)
                bset    #3,status(a1)
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$12,y_pos(a1)
                move.b  #$14,anim(a1)
                move.b  #3,object_control(a1)
                andi.b  #$FD,render_flags(a1)
                move.b  #1,(a2)
                move.b  #0,2(a2)
                move.b  #0,4(a2)
                move.b  #0,6(a2)
                move.b  #$91,mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                moveq   #signextendB(sfx_Grab),d0
                jsr     (Play_SFX).l

locret_3AD88:
                rts
; ---------------------------------------------------------------------------
Map_FBZChainLink:
                include "src/objects/shared/zones/fbz/mappings/chain_link.s"
