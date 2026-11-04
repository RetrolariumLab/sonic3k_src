; Owner: objects/interface/sk
; Responsibility: Special-stage results object dispatch, score tally, presentation choreography and result object allocation
; Source provenance and ranges: config/reconstruction/source_layout.json
word_2E398:
                dc.w    $15A0
                dc.w    $1540
                dc.w    $1600
                dc.w    $1500
                dc.w    $1640
                dc.w    $14B0
                dc.w    $1690
                dc.w    $15A0
                dc.w    $368
                dc.w    $3A0
                dc.w    $3A0
                dc.w    $350
                dc.w    $350
                dc.w    $390
                dc.w    $390
                dc.w    $368
; ---------------------------------------------------------------------------

Obj_SpecialStage_Results:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SpecialStage_Results_Index(pc,d0.w),d1
                jmp     SpecialStage_Results_Index(pc,d1.w)
; ---------------------------------------------------------------------------
SpecialStage_Results_Index:
                dc.w    loc_2E3DA-SpecialStage_Results_Index
                dc.w    loc_2E410-SpecialStage_Results_Index
                dc.w    loc_2E4D6-SpecialStage_Results_Index
                dc.w    loc_2E512-SpecialStage_Results_Index
                dc.w    loc_2E5C0-SpecialStage_Results_Index
                dc.w    loc_2E5E0-SpecialStage_Results_Index
                dc.w    loc_2E5F4-SpecialStage_Results_Index
                dc.w    loc_2E616-SpecialStage_Results_Index
                dc.w    loc_2E746-SpecialStage_Results_Index
                dc.w    loc_2E7DA-SpecialStage_Results_Index
; ---------------------------------------------------------------------------

loc_2E3DA:
                lea     next_object(a0),a1
                lea     ObjDat2_2E834(pc),a2
                moveq   #$13-1,d1
                jsr     SpecialResults_InitElementSlots(pc)
                move.w  (Special_stage_ring_count).w,d0
                mulu.w  #10,d0
                move.w  d0,(Ring_bonus_countdown).w
                clr.w   (Time_bonus_countdown).w
                tst.w   (Special_stage_rings_left).w
                bne.s   loc_2E404
                move.w  #5000,(Time_bonus_countdown).w

loc_2E404:
                move.w  #6*60,$2E(a0)
                addq.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_2E410:
                tst.w   $2E(a0)
                beq.s   loc_2E484
                subq.w  #1,$2E(a0)
                bne.s   loc_2E474
                tst.w   (SK_alone_flag).w
                bne.s   loc_2E474
                tst.b   (SK_special_stage_flag).w
                beq.s   loc_2E474
                tst.w   (Special_stage_spheres_left).w
                bne.s   loc_2E474
                move.w  #$40-1,(Palette_fade_info).w
                move.w  #$16,(Palette_fade_timer).w
                lea     (Normal_palette).w,a1
                move.w  #$EEE,$42(a1)
                move.w  #$EEE,$44(a1)
                move.w  #$EEE,$4C(a1)
                move.w  #$EEE,$62(a1)
                move.w  #$EEE,$66(a1)
                move.w  #$EEE,$6E(a1)
                move.w  #$EEE,$70(a1)
                move.w  #$EEE,$7C(a1)
                move.w  #$EEE,$7E(a1)

loc_2E474:
                cmpi.w  #289,$2E(a0)
                bne.s   locret_2E4C2
                moveq   #signextendB(mus_GotThroughAct),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

loc_2E484:
                moveq   #0,d0
                tst.w   (Time_bonus_countdown).w
                beq.s   loc_2E496
                addi.w  #10,d0
                subi.w  #10,(Time_bonus_countdown).w

loc_2E496:
                tst.w   (Ring_bonus_countdown).w
                beq.s   loc_2E4A6
                addi.w  #10,d0
                subi.w  #10,(Ring_bonus_countdown).w

loc_2E4A6:
                tst.w   d0
                beq.s   loc_2E4C4
                jsr     (HUD_AddToScore).l
                move.w  (Level_frame_counter).w,d0
                andi.w  #3,d0
                bne.s   locret_2E4C2
                moveq   #signextendB(sfx_Switch),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

locret_2E4C2:
                rts
; ---------------------------------------------------------------------------

loc_2E4C4:
                moveq   #signextendB(sfx_Register),d0
                jsr     (Play_SFX).l
                move.w  #2*60,$2E(a0)
                addq.b  #2,routine(a0)

loc_2E4D6:
                cmpi.w  #50,(Special_stage_ring_count).w
                blo.s   loc_2E50E
                tst.w   $2E(a0)
                beq.s   loc_2E4EA
                subq.w  #1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_2E4EA:
                clr.w   (SStage_results_object_addr).w
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_2E50E
                move.w  a1,(SStage_results_object_addr).w
                move.l  #loc_2EBE8,(a1)
                move.w  #270,$2E(a0)
                moveq   #signextendB(sfx_Continue),d0
                jsr     (Play_SFX).l

loc_2E50E:
                addq.b  #2,routine(a0)

loc_2E512:
                tst.w   (SK_alone_flag).w
                bne.s   loc_2E534
                tst.b   (SK_special_stage_flag).w
                beq.s   loc_2E534
                tst.w   (Special_stage_spheres_left).w
                bne.s   loc_2E534
                move.w  #60,$2E(a0)
                move.b  #$E,routine(a0)
                bra.w   loc_2E616
; ---------------------------------------------------------------------------

loc_2E534:
                tst.w   $2E(a0)
                beq.s   loc_2E540
                subq.w  #1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_2E540:
                tst.w   (Special_stage_spheres_left).w
                bne.s   loc_2E5B8
                cmpi.b  #7,(Chaos_emerald_count).w
                blo.s   loc_2E5B8
                cmpi.w  #3,(Player_mode).w
                beq.s   loc_2E570
                cmpi.w  #1,(Player_mode).w
                bls.s   loc_2E570
                cmpi.b  #4,(Special_stage_zone_and_act).w
                beq.s   loc_2E586
                cmpi.b  #7,(Special_stage_zone_and_act).w
                blo.s   loc_2E5B8
                bra.s   loc_2E586
; ---------------------------------------------------------------------------

loc_2E570:
                tst.w   (SK_alone_flag).w
                bne.s   loc_2E58C
                cmpi.b  #4,(Special_stage_zone_and_act).w
                beq.s   loc_2E586
                cmpi.b  #7,(Special_stage_zone_and_act).w
                blo.s   loc_2E58C

loc_2E586:
                move.b  #$A,routine(a0)

loc_2E58C:
                lea     (Dynamic_object_RAM+(object_size*44)).w,a1
                moveq   #4,d0

loc_2E592:
                move.l  #loc_2EC1E,(a1)
                lea     next_object(a1),a1
                dbf     d0,loc_2E592
                move.w  #4,(Dynamic_object_RAM+(object_size*46)+objoff_2E).w
                move.w  #4,(Dynamic_object_RAM+(object_size*48)+objoff_2E).w
                move.w  #5,$30(a0)
                addq.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_2E5B8:
                move.b  #GameMode_Level,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

loc_2E5C0:
                tst.w   $30(a0)
                bne.s   locret_2E5DE
                lea     (Dynamic_object_RAM+(object_size*44)).w,a1
                lea     ObjDat2_2E918(pc),a2
                moveq   #6-1,d1
                jsr     SpecialResults_InitElementSlots(pc)
                move.w  #4*60,$2E(a0)
                addq.b  #2,routine(a0)

locret_2E5DE:
                rts
; ---------------------------------------------------------------------------

loc_2E5E0:
                tst.w   $2E(a0)
                beq.s   loc_2E5EC
                subq.w  #1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_2E5EC:
                move.b  #GameMode_Level,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

loc_2E5F4:
                tst.w   $30(a0)
                bne.s   locret_2E614
                lea     (Dynamic_object_RAM+(object_size*44)).w,a1
                lea     ObjDat2_2E960(pc),a2
                moveq   #3-1,d1
                jsr     SpecialResults_InitElementSlots(pc)
                move.w  #4*60,$2E(a0)
                move.b  #$A,routine(a0)

locret_2E614:
                rts
; ---------------------------------------------------------------------------

loc_2E616:
                tst.w   $2E(a0)
                beq.s   loc_2E622
                subq.w  #1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_2E622:
                move.w  (Camera_Y_pos).w,d0
                cmpi.w  #$320,d0
                bhs.w   loc_2E6EA
                addq.w  #1,d0
                move.w  d0,(Camera_Y_pos).w
                cmpi.w  #$2A0,d0
                bne.w   locret_2E744
                moveq   #4,d0
                cmpi.w  #50,(Special_stage_ring_count).w
                blo.s   loc_2E65C
                move.w  (SStage_results_object_addr).w,d1
                beq.s   loc_2E65A
                movea.w d1,a1
                move.l  #loc_2EC4A,(a1)
                move.w  #20,$2E(a1)

loc_2E65A:
                addq.w  #1,d0

loc_2E65C:
                move.w  d0,$30(a0)
                lea     (Dynamic_object_RAM+(object_size*30)).w,a1

loc_2E664:
                move.l  #loc_2EC1E,(a1)
                lea     next_object(a1),a1
                dbf     d0,loc_2E664
                moveq   #2,d0
                cmpi.b  #7,(Super_emerald_count).w
                blo.s   loc_2E67E
                addq.w  #2,d0

loc_2E67E:
                add.w   d0,$30(a0)
                lea     (Dynamic_object_RAM+(object_size*44)).w,a1

loc_2E686:
                move.l  #loc_2EC1E,(a1)
                lea     next_object(a1),a1
                dbf     d0,loc_2E686
                addq.w  #2,$30(a0)
                lea     (Dynamic_object_RAM+(object_size*30)).w,a1
                move.w  #8,$2E(a1)
                move.w  #12,next_object+$2E(a1)
                move.w  #12,(next_object*2)+$2E(a1)
                move.w  #16,(next_object*3)+$2E(a1)
                move.w  #16,(next_object*4)+$2E(a1)
                cmpi.w  #50,(Special_stage_ring_count).w
                blo.s   loc_2E6C8
                move.w  #20,(next_object*5)+$2E(a1)

loc_2E6C8:
                clr.w   (next_object*2)+mainspr_childsprites(a1)
                clr.w   (next_object*4)+mainspr_childsprites(a1)
                lea     (Dynamic_object_RAM+(object_size*44)).w,a1
                move.w  #4,(next_object*2)+$2E(a1)
                cmpi.b  #7,(Super_emerald_count).w
                blo.s   loc_2E6E8
                move.w  #4,(next_object*4)+$2E(a1)

loc_2E6E8:
                bra.s   locret_2E744
; ---------------------------------------------------------------------------

loc_2E6EA:
                move.l  #ArtUnc_Invincibility,d1
                move.w  #tiles_to_bytes(ArtTile_Shield),d2
                move.w  #$200,d3
                jsr     (Add_To_DMA_Queue).l
                jsr     (AllocateObject).l
                bne.s   loc_2E72E
                moveq   #0,d1
                moveq   #0,d2
                moveq   #7,d3

loc_2E70C:
                move.l  #loc_2ECD0,(a1)
                move.w  d1,$2E(a1)
                move.w  d2,$30(a1)
                move.w  a0,$34(a1)
                addi.w  #$10,d1
                addq.w  #1,d2
                jsr     (CreateNewSprite4).l
                dbne    d3,loc_2E70C

loc_2E72E:
                move.w  #30,$2E(a0)
                clr.w   $30(a0)
                addq.b  #2,routine(a0)
                moveq   #signextendB(sfx_Signpost),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

locret_2E744:
                rts
; ---------------------------------------------------------------------------

loc_2E746:
                tst.w   $30(a0)
                beq.w   locret_2E7D8
                bmi.s   loc_2E75C
                st      $30(a0)
                moveq   #signextendB(sfx_SuperEmerald),d0
                jsr     (Play_SFX).l

loc_2E75C:
                cmpi.b  #7,(Super_emerald_count).w
                bhs.s   loc_2E772
                move.w  #60,$2E(a0)
                move.b  #$A,routine(a0)
                bra.s   locret_2E7D8
; ---------------------------------------------------------------------------

loc_2E772:
                tst.w   $2E(a0)
                beq.s   loc_2E77E
                subq.w  #1,$2E(a0)
                bra.s   locret_2E7D8
; ---------------------------------------------------------------------------

loc_2E77E:
                moveq   #1,d0
                cmpi.w  #$15A0,(Camera_X_pos).w
                beq.s   loc_2E792
                bcs.s   loc_2E78C
                neg.w   d0

loc_2E78C:
                add.w   d0,(Camera_X_pos).w
                bra.s   locret_2E7D8
; ---------------------------------------------------------------------------

loc_2E792:
                jsr     (AllocateObject).l
                bne.s   loc_2E7C6
                moveq   #0,d1
                moveq   #0,d2
                moveq   #7,d3

loc_2E7A0:
                move.l  #loc_2ECD0,(a1)
                move.w  d1,$2E(a1)
                move.w  d2,$30(a1)
                move.w  a0,$34(a1)
                st      $36(a1)
                addi.w  #$10,d1
                addq.w  #1,d2
                jsr     (CreateNewSprite4).l
                dbne    d3,loc_2E7A0

loc_2E7C6:
                move.w  #2*60,$2E(a0)
                addq.b  #2,routine(a0)
                moveq   #signextendB(sfx_Signpost),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

locret_2E7D8:
                rts
; ---------------------------------------------------------------------------

loc_2E7DA:
                tst.w   $2E(a0)
                beq.s   loc_2E7E6
                subq.w  #1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_2E7E6:
                lea     (Dynamic_object_RAM+(object_size*61)).w,a1
                lea     ObjDat2_2E984(pc),a2
                moveq   #7-1,d1
                jsr     SpecialResults_InitElementSlots(pc)
                move.w  #6*60,$2E(a0)
                move.b  #$A,routine(a0)
                rts

; =============== S U B R O U T I N E =======================================

; Write twelve-byte descriptors directly into the caller's consecutive object slots
SpecialResults_InitElementSlots:
                move.l  (a2)+,(a1)
                move.w  (a2)+,$46(a1)
                move.w  (a2)+,x_pos(a1)
                move.w  (a2)+,y_pos(a1)
                move.b  (a2)+,mapping_frame(a1)
                move.b  (a2)+,width_pixels(a1)
                move.b  #$40,render_flags(a1)
                move.l  #Map_Results,mappings(a1)
                move.w  a0,parent2(a1)
                lea     next_object(a1),a1
                dbf     d1,SpecialResults_InitElementSlots
                rts
; End of function SpecialResults_InitElementSlots
