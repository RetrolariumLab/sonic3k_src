; Owner: objects/interface/s3
; Responsibility: Special-stage results object dispatch, score tally, presentation choreography and result object allocation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SpecialStage_Results:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SpecialStage_Results_Index(pc,d0.w),d1
                jmp     SpecialStage_Results_Index(pc,d1.w)
; ---------------------------------------------------------------------------
SpecialStage_Results_Index:
                dc.w    loc_2D438-SpecialStage_Results_Index
                dc.w    loc_2D49A-SpecialStage_Results_Index
                dc.w    loc_2D506-SpecialStage_Results_Index
                dc.w    loc_2D53A-SpecialStage_Results_Index
                dc.w    loc_2D590-SpecialStage_Results_Index
                dc.w    loc_2D5DC-SpecialStage_Results_Index
; ---------------------------------------------------------------------------

loc_2D438:
                lea     next_object(a0),a1
                lea     ObjDat2_2D5F0(pc),a2
                moveq   #$13-1,d1

loc_2D442:
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
                dbf     d1,loc_2D442
                move.w  (Special_stage_ring_count).w,d0
                mulu.w  #10,d0
                move.w  d0,(Ring_bonus_countdown).w
                clr.w   (Time_bonus_countdown).w
                tst.w   (Special_stage_rings_left).w
                bne.s   loc_2D48E
                move.w  #5000,(Time_bonus_countdown).w

loc_2D48E:
                move.w  #6*60,$2E(a0)
                addq.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_2D49A:
                tst.w   $2E(a0)
                beq.s   loc_2D4B4
                subq.w  #1,$2E(a0)
                cmpi.w  #289,$2E(a0)
                bne.s   locret_2D4F2
                moveq   #signextendB(mus_GotThroughAct),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

loc_2D4B4:
                moveq   #0,d0
                tst.w   (Time_bonus_countdown).w
                beq.s   loc_2D4C6
                addi.w  #10,d0
                subi.w  #10,(Time_bonus_countdown).w

loc_2D4C6:
                tst.w   (Ring_bonus_countdown).w
                beq.s   loc_2D4D6
                addi.w  #10,d0
                subi.w  #10,(Ring_bonus_countdown).w

loc_2D4D6:
                tst.w   d0
                beq.s   loc_2D4F4
                jsr     (HUD_AddToScore).l
                move.w  (Level_frame_counter).w,d0
                andi.w  #3,d0
                bne.s   locret_2D4F2
                moveq   #signextendB(sfx_Switch),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

locret_2D4F2:
                rts
; ---------------------------------------------------------------------------

loc_2D4F4:
                moveq   #signextendB(sfx_Register),d0
                jsr     (Play_SFX).l
                move.w  #2*60,$2E(a0)
                addq.b  #2,routine(a0)

loc_2D506:
                tst.w   $2E(a0)
                beq.s   loc_2D512
                subq.w  #1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_2D512:
                cmpi.w  #50,(Special_stage_ring_count).w
                blo.s   loc_2D536
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_2D536
                move.l  #loc_2D83C,(a1)
                move.w  #270,$2E(a0)
                moveq   #signextendB(sfx_Continue),d0
                jsr     (Play_SFX).l

loc_2D536:
                addq.b  #2,routine(a0)

loc_2D53A:
                tst.w   $2E(a0)
                beq.s   loc_2D546
                subq.w  #1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_2D546:
                cmpi.w  #1,(Player_mode).w
                bhi.s   loc_2D588
                tst.w   (Special_stage_spheres_left).w
                bne.s   loc_2D588
                cmpi.b  #7,(Chaos_emerald_count+1).w
                blo.s   loc_2D588
                lea     (Dynamic_object_RAM+(object_size*16)).w,a1
                moveq   #5-1,d0

loc_2D562:
                move.l  #loc_2D872,(a1)
                lea     next_object(a1),a1
                dbf     d0,loc_2D562
                move.w  #4,(Dynamic_object_RAM+(object_size*18)+objoff_2E).w
                move.w  #4,(Dynamic_object_RAM+(object_size*20)+objoff_2E).w
                move.w  #5,$30(a0)
                addq.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_2D588:
                move.b  #GameMode_Level,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

loc_2D590:
                tst.w   $30(a0)
                bne.s   locret_2D5DA
                lea     (Dynamic_object_RAM+(object_size*16)).w,a1
                lea     ObjDat2_2D6D4(pc),a2
                moveq   #5-1,d1

loc_2D5A0:
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
                dbf     d1,loc_2D5A0
                move.w  #4*60,$2E(a0)
                addq.b  #2,routine(a0)

locret_2D5DA:
                rts
; ---------------------------------------------------------------------------

loc_2D5DC:
                tst.w   $2E(a0)
                beq.s   loc_2D5E8
                subq.w  #1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_2D5E8:
                move.b  #GameMode_Level,(Game_mode).w
                rts
