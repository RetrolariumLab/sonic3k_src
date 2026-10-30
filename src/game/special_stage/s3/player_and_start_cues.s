; Owner: game/special_stage/s3
; Responsibility: Stage icons, moving instruction cues and the primary character state machine with player frame-loading support
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SStage_7D70:
                move.b  #$80,width_pixels(a0)
                move.b  #$80,height_pixels(a0)
                move.w  #0,priority(a0)
                move.l  #Map_SSIcons,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_Icons,2,1),art_tile(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$94,y_pos(a0)
                move.l  #loc_7DA2,(a0)

loc_7DA2:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_SSIcons:
                include "src/game/special_stage/shared/special_stage/map_icons.s"
; ---------------------------------------------------------------------------

Obj_SStage_7DB8:
                jsr     (AllocateObjectAfterCurrent_SpecialStage).l
                bne.w   loc_7DD4
                move.l  #loc_7DD4,(a1)
                bset    #0,status(a1)
                move.b  #1,mapping_frame(a1)

loc_7DD4:
                move.b  #$80,width_pixels(a0)
                move.b  #$80,height_pixels(a0)
                move.w  #0,priority(a0)
                move.l  #Map_GetBlueSpheres,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_GetBlueSpheres,1,1),art_tile(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$E8,y_pos(a0)
                move.w  #3*60,$32(a0)
                move.l  #loc_7E0C,(a0)

loc_7E0C:
                tst.w   $32(a0)
                beq.s   loc_7E1C
                subq.w  #1,$32(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7E1C:
                cmpi.w  #$C0,$30(a0)
                blo.s   loc_7E3C
                move.l  #loc_7E5E,(a0)
                addq.b  #2,mapping_frame(a0)
                tst.w   (Special_stage_velocity).w
                bne.s   loc_7E42
                move.b  #1,(Special_stage_advancing).w
                bra.s   loc_7E42
; ---------------------------------------------------------------------------

loc_7E3C:
                addi.w  #$10,$30(a0)

loc_7E42:
                move.w  $30(a0),d0
                btst    #0,status(a0)
                bne.s   loc_7E50
                neg.w   d0

loc_7E50:
                addi.w  #$120,d0
                move.w  d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7E5E:
                tst.w   (Special_stage_rings_left).w
                beq.s   loc_7E66
                rts
; ---------------------------------------------------------------------------

loc_7E66:
                subi.w  #$10,$30(a0)
                bne.s   loc_7E7A
                move.l  #loc_7E96,(a0)
                move.w  #180,$32(a0)

loc_7E7A:
                move.w  $30(a0),d0
                btst    #0,status(a0)
                bne.s   loc_7E88
                neg.w   d0

loc_7E88:
                addi.w  #$120,d0
                move.w  d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7E96:
                tst.w   $32(a0)
                beq.s   loc_7EA6
                subq.w  #1,$32(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7EA6:
                cmpi.w  #$C0,$30(a0)
                bhs.s   loc_7EB4
                addi.w  #$10,$30(a0)

loc_7EB4:
                move.w  $30(a0),d0
                btst    #0,status(a0)
                bne.s   loc_7EC2
                neg.w   d0

loc_7EC2:
                addi.w  #$120,d0
                move.w  d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_GetBlueSpheres:
                include "src/game/special_stage/shared/special_stage/map_get_blue_spheres.s"
; ---------------------------------------------------------------------------

Obj_SStage_7F1C:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$200,priority(a0)
                move.l  #Map_SStageSonic,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_Player1,0,1),art_tile(a0)
                cmpi.w  #2,(Player_option).w
                bne.s   loc_7F6C
                move.l  #Map_SStageTails,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_Player2,1,1),art_tile(a0)
                jsr     (AllocateObjectAfterCurrent_SpecialStage).l
                bne.w   loc_7F6C
                move.l  #Obj_SStage_82EE,(a1)
                move.w  a0,$3E(a1)

loc_7F6C:
                move.w  #$A0,$30(a0)
                move.w  #$70,$32(a0)
                move.w  #0,$34(a0)
                move.w  #$F800,$36(a0)
                move.w  #0,$38(a0)
                bsr.w   sub_8402
                move.b  #$FF,$3A(a0)
                move.l  #loc_7F9A,(a0)

loc_7F9A:
                tst.w   (Special_stage_rate_timer).w
                beq.s   loc_7FCE
                subq.w  #1,(Special_stage_rate_timer).w
                bne.s   loc_7FCE
                move.w  #30*60,(Special_stage_rate_timer).w
                cmpi.w  #$2000,(Special_stage_rate).w
                beq.s   loc_7FCE
                addi.w  #$400,(Special_stage_rate).w
                move.b  (Special_stage_rate).w,d0
                subi.b  #$20,d0
                neg.b   d0
                add.b   d0,d0
                addq.b  #8,d0
                jsr     (Change_Music_Tempo).l

loc_7FCE:
                bsr.w   sub_8476
                moveq   #$C,d0
                move.w  (Special_stage_velocity).w,d1
                beq.s   loc_7FF8
                asr.w   #5,d1
                add.w   d1,anim_frame_timer(a0)
                moveq   #0,d0
                move.b  anim_frame_timer(a0),d0
                bpl.s   loc_7FEE
                addi.b  #$C,d0
                bra.s   loc_7FF8
; ---------------------------------------------------------------------------

loc_7FEE:
                cmpi.b  #$C,d0
                blo.s   loc_7FF8
                subi.b  #$C,d0

loc_7FF8:
                move.b  d0,anim_frame_timer(a0)
                lea     (byte_811E).l,a1
                tst.b   (Special_stage_jumping).w
                bpl.s   loc_801C
                lea     (byte_812C).l,a1
                move.w  (Special_stage_velocity).w,d1
                bne.s   loc_801C
                move.b  (Level_frame_counter+1).w,d0
                andi.w  #3,d0

loc_801C:
                move.b  (a1,d0.w),mapping_frame(a0)
                tst.b   (Special_stage_clear_routine).w
                bne.s   loc_803E
                move.w  (Ctrl_1).w,d0
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   loc_803E
                tst.b   (Special_stage_jumping).w
                bmi.s   loc_803E
                move.b  #1,(Special_stage_jumping).w

loc_803E:
                move.b  (Special_stage_angle).w,d0
                andi.b  #$3F,d0
                bne.w   loc_80A2
                cmpi.b  #1,(Special_stage_jumping).w
                bne.s   loc_806E
                move.l  #-$100000,$40(a0)
                move.b  #$80,(Special_stage_jumping).w
                move.b  #0,(Special_stage_turning).w
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l

loc_806E:
                tst.b   (Special_stage_jumping).w
                bpl.s   loc_80A2
                move.l  $3C(a0),d0
                add.l   $40(a0),d0
                bmi.s   loc_8088
                moveq   #0,d0
                move.l  d0,$40(a0)
                move.b  d0,(Special_stage_jumping).w

loc_8088:
                move.w  (Special_stage_rate).w,d1
                ext.l   d1
                lsl.l   #4,d1
                add.l   d1,$40(a0)
                move.l  d0,$3C(a0)
                swap    d0
                addi.w  #-$800,d0
                move.w  d0,$36(a0)

loc_80A2:
                bsr.w   sub_8402
                bsr.w   sub_8434
                jsr     (Draw_Sprite).l
                lea     (PLC_SStageSonic).l,a2
                move.l  #ArtUnc_SStageSonic,d6
                move.w  #tiles_to_bytes(ArtTile_SStage_Player1),d4
                cmpi.w  #2,(Player_option).w
                bne.s   loc_80D8
                lea     (PLC_SStageTails).l,a2
                move.l  #ArtUnc_SStageTails,d6
                move.w  #tiles_to_bytes(ArtTile_SStage_Player2),d4

loc_80D8:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   $3A(a0),d0
                beq.s   locret_811C
                move.b  d0,$3A(a0)
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   locret_811C

loc_80F4:
                moveq   #0,d1
                move.w  (a2)+,d1
                move.w  d1,d3
                lsr.w   #8,d3
                andi.w  #$F0,d3
                addi.w  #$10,d3
                andi.w  #$FFF,d1
                lsl.l   #5,d1
                add.l   d6,d1
                move.w  d4,d2
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                dbf     d5,loc_80F4

locret_811C:
                rts
; ---------------------------------------------------------------------------
byte_811E:
                dc.b    2,   6,   7,   8,   7,   6,   2,   3,   4,   5,   4,   3,   1,   0
byte_812C:
                dc.b    9,  $B,  $A,  $B,   9,  $B,  $A,  $B,   9,  $B,  $A,  $B,  $B,   0
byte_813A:
                dc.b    9,  $A,  $B,   9,  $A,  $B,   9,  $A,  $B,   9,  $A,  $B,  $B,   0
                even
; ---------------------------------------------------------------------------
