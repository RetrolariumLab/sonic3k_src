; Owner: objects/interface/s3
; Responsibility: Special-stage results text, emerald display, tally elements and product-specific emerald projection effects
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_2D710:
                jsr     LevelResults_MoveElement(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2D71A:
                jsr     LevelResults_MoveElement(pc)
                move.w  (Ring_bonus_countdown).w,d0
                bra.s   loc_2D72C
; ---------------------------------------------------------------------------

loc_2D724:
                jsr     LevelResults_MoveElement(pc)
                move.w  (Time_bonus_countdown).w,d0

loc_2D72C:
                jsr     LevResults_DisplayScore(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2D736:
                cmpi.w  #50,(Special_stage_ring_count).w
                blo.w   loc_2D89E
                jsr     LevelResults_MoveElement(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2D74A:
                lea     (Collected_emeralds_array).w,a1
                moveq   #0,d0
                move.b  width_pixels(a0),d0
                tst.b   (a1,d0.w)
                beq.w   loc_2D89E
                btst    #0,(Level_frame_counter+1).w
                beq.s   locret_2D76A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_2D76A:
                rts
; ---------------------------------------------------------------------------

loc_2D76C:
                tst.w   (Special_stage_spheres_left).w
                beq.w   loc_2D89E
                bra.s   loc_2D710
; ---------------------------------------------------------------------------

loc_2D776:
                tst.w   (Special_stage_spheres_left).w
                bne.w   loc_2D89E
                jsr     sub_2D8A4(pc)
                add.w   d0,x_pos(a0)
                add.w   d0,$46(a0)
                add.b   d1,mapping_frame(a0)
                cmpi.b  #7,(Chaos_emerald_count+1).w
                blo.s   loc_2D7A2
                subi.w  #$10,x_pos(a0)
                subi.w  #$10,$46(a0)

loc_2D7A2:
                lea     (loc_2D710).l,a1
                move.l  a1,(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------

loc_2D7AC:
                tst.w   (Special_stage_spheres_left).w
                bne.w   loc_2D89E
                jsr     sub_2D8A4(pc)
                sub.w   d0,x_pos(a0)
                sub.w   d0,$46(a0)
                cmpi.b  #7,(Chaos_emerald_count+1).w
                blo.s   loc_2D7D4
                subi.w  #$10,x_pos(a0)
                subi.w  #$10,$46(a0)

loc_2D7D4:
                lea     (loc_2D710).l,a1
                move.l  a1,(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------

loc_2D7DE:
                tst.w   (Special_stage_spheres_left).w
                bne.w   loc_2D89E
                cmpi.b  #7,(Chaos_emerald_count+1).w
                blo.s   loc_2D7F6
                subq.w  #8,x_pos(a0)
                subq.w  #8,$46(a0)

loc_2D7F6:
                lea     (loc_2D710).l,a1
                move.l  a1,(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------

loc_2D800:
                tst.w   (Special_stage_spheres_left).w
                bne.w   loc_2D89E
                cmpi.b  #7,(Chaos_emerald_count+1).w
                blo.w   loc_2D89E
                jsr     sub_2D8A4(pc)
                sub.w   d0,x_pos(a0)
                sub.w   d0,$46(a0)
                lea     (loc_2D710).l,a1
                move.l  a1,(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------

loc_2D828:
                tst.w   (Special_stage_spheres_left).w
                bne.w   loc_2D89E
                cmpi.b  #7,(Chaos_emerald_count+1).w
                blo.s   loc_2D89E
                bra.w   loc_2D710
; ---------------------------------------------------------------------------

loc_2D83C:
                move.l  #Map_Results,mappings(a0)
                move.w  #$17C,x_pos(a0)
                move.w  #$14C,y_pos(a0)
                move.w  (Player_mode).w,d0
                subq.w  #1,d0
                bcc.s   loc_2D85A
                moveq   #0,d0

loc_2D85A:
                addi.w  #$29,d0
                move.b  d0,mapping_frame(a0)
                btst    #3,(Level_frame_counter+1).w
                beq.s   locret_2D870
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_2D870:
                rts
; ---------------------------------------------------------------------------

loc_2D872:
                tst.w   $2E(a0)
                beq.s   loc_2D87E
                subq.w  #1,$2E(a0)
                bra.s   loc_2D898
; ---------------------------------------------------------------------------

loc_2D87E:
                tst.b   render_flags(a0)
                bmi.s   loc_2D892
                movea.w parent2(a0),a1
                subq.w  #1,$30(a1)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2D892:
                addi.w  #$20,x_pos(a0)

loc_2D898:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2D89E:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_2D8A4:
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
; End of function sub_2D8A4
