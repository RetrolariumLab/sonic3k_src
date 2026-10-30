; Owner: objects/interface/sk
; Responsibility: Special-stage results text, emerald display, tally elements and product-specific emerald projection effects
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_2E9D8:
                move.w  -$3A(a0),d0
                cmp.w   -4(a0),d0
                bne.s   locret_2E9F4
                clr.b   (_unkFAC1).w
                moveq   #signextendB(sfx_Perfect),d0
                jsr     (Play_SFX).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

locret_2E9F4:
                rts
; ---------------------------------------------------------------------------

loc_2E9F6:
                tst.w   (SK_alone_flag).w
                bne.s   loc_2EA10
                tst.b   (SK_special_stage_flag).w
                beq.s   loc_2EA10
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_2EA10
                move.w  #make_art_tile($000,1,0),art_tile(a0)

loc_2EA10:
                jsr     sub_2EC80(pc)
                add.w   d0,x_pos(a0)
                add.w   d0,$46(a0)
                bra.s   loc_2EA4A
; ---------------------------------------------------------------------------

loc_2EA1E:
                tst.w   (SK_alone_flag).w
                bne.s   loc_2EA4A
                tst.b   (SK_special_stage_flag).w
                beq.s   loc_2EA4A
                addi.b  #$1A,mapping_frame(a0)
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_2EA4A
                addq.b  #5,mapping_frame(a0)
                bra.s   loc_2EA4A
; ---------------------------------------------------------------------------

loc_2EA3E:
                jsr     sub_2EC80(pc)
                sub.w   d0,x_pos(a0)
                sub.w   d0,$46(a0)

loc_2EA4A:
                move.l  #loc_2EA50,(a0)

loc_2EA50:
                jsr     LevelResults_MoveElement(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2EA5A:
                jsr     LevelResults_MoveElement(pc)
                move.w  (Ring_bonus_countdown).w,d0
                bra.s   loc_2EA6C
; ---------------------------------------------------------------------------

loc_2EA64:
                jsr     LevelResults_MoveElement(pc)
                move.w  (Time_bonus_countdown).w,d0

loc_2EA6C:
                jsr     LevResults_DisplayScore(pc)
                move.w  (_unkEF68).w,art_tile(a0)       ; this is not here in Sonic 3. _unkEF68 is always set to $98. What does this do?!?!?!
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2EA7C:
                cmpi.w  #50,(Special_stage_ring_count).w
                blo.w   loc_2EC7A
                tst.w   (SK_alone_flag).w
                bne.s   loc_2EA4A
                tst.b   (SK_special_stage_flag).w
                beq.s   loc_2EA4A
                addi.b  #$1A,mapping_frame(a0)
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_2EA4A
                addq.b  #5,mapping_frame(a0)
                bra.s   loc_2EA4A
; ---------------------------------------------------------------------------

loc_2EAA6:
                lea     (Collected_emeralds_array).w,a1
                moveq   #0,d0
                move.b  width_pixels(a0),d0
                cmpi.b  #1,(a1,d0.w)
                bne.w   loc_2EC7A
                tst.w   (Emerald_flicker_flag).w
                beq.s   locret_2EAC6
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_2EAC6:
                rts
; ---------------------------------------------------------------------------

loc_2EAC8:
                tst.w   (Special_stage_spheres_left).w
                beq.w   loc_2EC7A
                jsr     sub_2ECBC(pc)
                bra.w   loc_2EA50
; ---------------------------------------------------------------------------

loc_2EAD8:
                tst.w   (Special_stage_spheres_left).w
                bne.w   loc_2EC7A
                jsr     sub_2ECA8(pc)
                cmpi.b  #7,(a1)
                blo.s   loc_2EAF6
                subi.w  #$10,x_pos(a0)
                subi.w  #$10,$46(a0)

loc_2EAF6:
                jsr     sub_2EC80(pc)
                add.w   d0,x_pos(a0)
                add.w   d0,$46(a0)
                add.b   d1,mapping_frame(a0)
                move.w  #-$87,art_tile(a0)
                tst.w   (SK_alone_flag).w
                bne.w   loc_2EA4A
                tst.b   (SK_special_stage_flag).w
                beq.w   loc_2EA4A
                cmpi.w  #3,(Player_mode).w
                bne.w   loc_2EA4A
                addi.w  #palette_line_1,art_tile(a0)
                bra.w   loc_2EA4A
; ---------------------------------------------------------------------------

loc_2EB30:
                tst.w   (Special_stage_spheres_left).w
                bne.w   loc_2EC7A
                jsr     sub_2ECBC(pc)
                jsr     sub_2EC80(pc)
                sub.w   d0,x_pos(a0)
                sub.w   d0,$46(a0)
                jsr     sub_2ECA8(pc)
                cmpi.b  #7,(a1)
                blo.w   loc_2EA4A
                subi.w  #$10,x_pos(a0)
                subi.w  #$10,$46(a0)
                bra.w   loc_2EA4A
; ---------------------------------------------------------------------------

loc_2EB64:
                tst.w   (Special_stage_spheres_left).w
                bne.w   loc_2EC7A
                jsr     sub_2ECBC(pc)
                tst.w   (SK_alone_flag).w
                bne.s   loc_2EB7C
                tst.b   (SK_special_stage_flag).w
                bne.s   loc_2EB88

loc_2EB7C:
                cmpi.b  #7,(Chaos_emerald_count).w
                blo.w   loc_2EA4A
                bra.s   loc_2EB98
; ---------------------------------------------------------------------------

loc_2EB88:
                move.b  #$30,mapping_frame(a0)
                cmpi.b  #7,(Super_emerald_count).w
                blo.w   loc_2EA4A

loc_2EB98:
                subq.w  #8,x_pos(a0)
                subq.w  #8,$46(a0)
                bra.w   loc_2EA4A
; ---------------------------------------------------------------------------

loc_2EBA4:
                tst.w   (Special_stage_spheres_left).w
                bne.w   loc_2EC7A
                jsr     sub_2ECBC(pc)
                jsr     sub_2ECA8(pc)
                cmpi.b  #7,(a1)
                blo.w   loc_2EC7A
                jsr     sub_2EC80(pc)
                sub.w   d0,x_pos(a0)
                sub.w   d0,$46(a0)
                bra.w   loc_2EA4A
; ---------------------------------------------------------------------------

loc_2EBCC:
                tst.w   (Special_stage_spheres_left).w
                bne.w   loc_2EC7A
                jsr     sub_2ECBC(pc)
                jsr     sub_2ECA8(pc)
                cmpi.b  #7,(a1)
                blo.w   loc_2EC7A
                bra.w   loc_2EA50
; ---------------------------------------------------------------------------

loc_2EBE8:
                move.l  #Map_Results,mappings(a0)
                move.w  #$17C,x_pos(a0)
                move.w  #$14C,y_pos(a0)
                move.w  (Player_mode).w,d0
                subq.w  #1,d0
                bcc.s   loc_2EC06
                moveq   #0,d0

loc_2EC06:
                addi.w  #$29,d0
                move.b  d0,mapping_frame(a0)
                btst    #3,(Level_frame_counter+1).w
                beq.s   locret_2EC1C
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_2EC1C:
                rts
; ---------------------------------------------------------------------------

loc_2EC1E:
                tst.w   $2E(a0)
                beq.s   loc_2EC2A
                subq.w  #1,$2E(a0)
                bra.s   loc_2EC44
; ---------------------------------------------------------------------------

loc_2EC2A:
                tst.b   render_flags(a0)
                bmi.s   loc_2EC3E
                movea.w parent2(a0),a1
                subq.w  #1,$30(a1)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2EC3E:
                addi.w  #$20,x_pos(a0)

loc_2EC44:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2EC4A:
                tst.w   $2E(a0)
                beq.s   loc_2EC56
                subq.w  #1,$2E(a0)
                bra.s   loc_2EC6A
; ---------------------------------------------------------------------------

loc_2EC56:
                cmpi.w  #$1CC,x_pos(a0)
                blo.s   loc_2EC64
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2EC64:
                addi.w  #$20,x_pos(a0)

loc_2EC6A:
                btst    #3,(Level_frame_counter+1).w
                beq.s   locret_2EC78
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_2EC78:
                rts
; ---------------------------------------------------------------------------

loc_2EC7A:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_2EC80:
                moveq   #0,d0
                moveq   #0,d1
                cmpi.w  #1,(Player_mode).w
                bls.s   .return
                moveq   #-$18,d0
                moveq   #3,d1
                cmpi.w  #3,(Player_mode).w
                beq.s   .return
                moveq   #0,d0
                moveq   #1,d1
                tst.b   (Graphics_flags).w
                bpl.s   .return
                moveq   #4,d0
                moveq   #2,d1

                .return:
                rts
; End of function sub_2EC80

; =============== S U B R O U T I N E =======================================

sub_2ECA8:
                lea     (Chaos_emerald_count).w,a1
                tst.w   (SK_alone_flag).w
                bne.s   .return
                tst.b   (SK_special_stage_flag).w
                beq.s   .return
                addq.w  #1,a1

                .return:
                rts
; End of function sub_2ECA8

; =============== S U B R O U T I N E =======================================

sub_2ECBC:
                tst.w   (SK_alone_flag).w
                bne.s   loc_2ECC8
                tst.b   (SK_special_stage_flag).w
                bne.s   locret_2ECCE

loc_2ECC8:
                move.w  #make_art_tile($000,3,0),art_tile(a0)

locret_2ECCE:
                rts
; End of function sub_2ECBC

; ---------------------------------------------------------------------------

loc_2ECD0:
                move.l  #loc_2ED2A,(a0)
                move.b  #$44,render_flags(a0)
                move.w  #make_art_tile(ArtTile_Shield,0,1),art_tile(a0)
                move.l  #Map_Invincibility,mappings(a0)
                moveq   #0,d0
                move.b  (Current_special_stage_2).w,d0
                add.w   d0,d0
                lea     word_2E398(pc),a1
                move.w  (a1,d0.w),d1
                addi.w  #$A0,d1
                move.w  d1,x_pos(a0)
                move.w  $10(a1,d0.w),y_pos(a0)
                move.w  #2,mainspr_childsprites(a0)
                move.w  #-$2000,$32(a0)
                tst.w   $36(a0)
                beq.s   loc_2ED2A
                move.w  #$1640,x_pos(a0)
                move.w  #$340,y_pos(a0)
                clr.w   $32(a0)

loc_2ED2A:
                move.w  $2E(a0),d0
                jsr     (GetSineCosine).l
                move.w  $32(a0),d2
                tst.w   d1
                smi     d3
                bpl.s   loc_2ED40
                neg.w   d1

loc_2ED40:
                mulu.w  d2,d1
                swap    d1
                tst.b   d3
                beq.s   loc_2ED4A
                neg.w   d1

loc_2ED4A:
                tst.w   d0
                smi     d3
                bpl.s   loc_2ED52
                neg.w   d0

loc_2ED52:
                mulu.w  d2,d0
                swap    d0
                tst.b   d3
                beq.s   loc_2ED5C
                neg.w   d0

loc_2ED5C:
                move.w  $30(a0),d2
                addq.w  #1,d2
                cmpi.w  #8,d2
                bls.s   loc_2ED6A
                moveq   #0,d2

loc_2ED6A:
                move.w  d2,$30(a0)
                lea     sub2_x_pos(a0),a1
                move.w  x_pos(a0),d3
                add.w   d1,d3
                move.w  d3,(a1)+
                move.w  y_pos(a0),d3
                add.w   d0,d3
                move.w  d3,(a1)+
                move.w  d2,(a1)+
                neg.w   d1
                add.w   x_pos(a0),d1
                move.w  d1,(a1)+
                neg.w   d0
                add.w   y_pos(a0),d0
                move.w  d0,(a1)+
                move.w  d2,(a1)+
                addq.w  #2,$2E(a0)
                tst.w   $36(a0)
                bne.s   loc_2EDBC
                subi.w  #$100,$32(a0)
                bcs.s   loc_2EDAE
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2EDAE:
                movea.w $34(a0),a1
                st      $31(a1)
                clr.b   (_unkFAC0).w
                bra.s   loc_2EDCA
; ---------------------------------------------------------------------------

loc_2EDBC:
                addi.w  #$100,$32(a0)
                bcs.s   loc_2EDCA
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2EDCA:
                jmp     (Delete_Current_Sprite).l
; End of function loc_2ECD0
