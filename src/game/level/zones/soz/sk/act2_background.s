; Owner: game/level/zones/soz/sk
; Responsibility: Sandopolis act-two background initialization, event control, deformation and private sequence data
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

SOZ2_BackgroundInit:
                jsr     ClearSoz2EntranceBackgroundChunkStrip(pc)
                moveq   #$10,d0
                cmpi.w  #$2980,(Player_1+x_pos).w
                blo.s   loc_56278
                moveq   #$20,d0

loc_56278:
                move.w  d0,(Events_routine_bg).w
                jsr     SetSoz2HalfSpeedBackgroundCoordinates(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                moveq   #0,d1
                jsr     (Refresh_PlaneFull).l
                jmp     (PlainDeformation).l
; ---------------------------------------------------------------------------

SOZ2_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     SOZ2_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

SOZ2_BackgroundEvent_Index:
                bra.w   loc_562D0                       ; $00
; ---------------------------------------------------------------------------
                bra.w   loc_56300                       ; $04
; ---------------------------------------------------------------------------
                bra.w   loc_56324                       ; $08
; ---------------------------------------------------------------------------
                bra.w   loc_56366                       ; $0C
; ---------------------------------------------------------------------------
                bra.w   loc_563A6                       ; $10
; ---------------------------------------------------------------------------
                bra.w   loc_5641C                       ; $14 Rising sand #1
; ---------------------------------------------------------------------------
                bra.w   loc_5645E                       ; $18 Rising sand #2
; ---------------------------------------------------------------------------
                bra.w   loc_564B8                       ; $1C
; ---------------------------------------------------------------------------
                bra.w   loc_564D4                       ; $20
; ---------------------------------------------------------------------------
                bra.w   loc_565C6                       ; $24
; ---------------------------------------------------------------------------
                bra.w   loc_565DE                       ; $28
; ---------------------------------------------------------------------------
                bra.w   loc_56676                       ; $2C
; ---------------------------------------------------------------------------
                bra.w   loc_566A4                       ; $30
; ---------------------------------------------------------------------------

loc_562D0:
                cmpi.w  #8,(Events_routine_fg).w
                blo.s   locret_562FE
                jsr     ClearSoz2EntranceBackgroundChunkStrip(pc)
                jsr     SetSoz2HalfSpeedBackgroundCoordinates(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_56304
; ---------------------------------------------------------------------------

locret_562FE:
                rts
; ---------------------------------------------------------------------------

loc_56300:
                jsr     SetSoz2HalfSpeedBackgroundCoordinates(pc)

loc_56304:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     (Draw_PlaneVertBottomUp).l
                bpl.w   loc_563C0
                move.w  #$10-1,(Palette_fade_info).w
                move.w  #$15,(Events_bg+$00).w
                addq.w  #4,(Events_routine_bg).w

loc_56324:
                btst    #0,(Level_frame_counter+1).w
                beq.s   loc_563A6
                cmpi.w  #5,(Events_bg+$00).w
                bne.s   loc_56346
                jsr     (AllocateObject).l
                bne.s   loc_56346
                move.l  #Obj_TitleCard,(a1)
                st      $3E(a1)

loc_56346:
                move.l  a0,-(sp)
                jsr     (Pal_FromBlack).l
                movea.l (sp)+,a0
                subq.w  #1,(Events_bg+$00).w
                bpl.s   loc_563A6
                move.w  #$4020-1,(Palette_fade_info).w
                move.w  #$15,(Events_bg+$00).w
                addq.w  #4,(Events_routine_bg).w

loc_56366:
                btst    #0,(Level_frame_counter+1).w
                beq.s   loc_563A6
                move.l  a0,-(sp)
                jsr     (Pal_FromBlack).l
                movea.l (sp)+,a0
                subq.w  #1,(Events_bg+$00).w
                bpl.s   loc_563A6
                move.l  #$6000,d0
                move.l  d0,(Camera_min_X_pos).w
                move.l  d0,(Camera_target_min_X_pos).w
                move.l  #-$FFF800,d0
                move.l  d0,(Camera_min_Y_pos).w
                move.l  d0,(Camera_target_min_Y_pos).w
                clr.w   (Palette_fade_timer).w
                clr.w   (Ctrl_1_locked).w
                addq.w  #4,(Events_routine_bg).w

loc_563A6:
                jsr     IsPlayerInSoz2RisingSandExitWindow(pc)
                beq.s   loc_563B6
                move.w  #$18,(Events_routine_bg).w
                bra.w   loc_56484
; ---------------------------------------------------------------------------

loc_563B6:
                tst.w   (Events_fg_5).w
                bne.s   loc_563D8
                jsr     SetSoz2HalfSpeedBackgroundCoordinates(pc)

loc_563C0:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     (Draw_TileRow).l
                jmp     (PlainDeformation).l
; ---------------------------------------------------------------------------

loc_563D8:
                clr.w   (Events_fg_5).w
                addq.w  #4,(Events_routine_bg).w
                moveq   #0,d0
                move.w  #$80,d0
                cmpi.w  #$400,(Player_1+y_pos).w
                blo.s   loc_563F6
                addq.w  #4,(Events_routine_bg).w
                move.w  #$3E0,d0

loc_563F6:
                swap    d0
                move.l  d0,(_unkEE9C).w
                jsr     AlignSoz2RisingSandBackgroundCamera(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                subi.w  #$10,(Camera_Y_pos_BG_rounded).w
                move.w  #$10,(Special_events_routine).w
                cmpi.w  #$14,(Events_routine_bg).w
                beq.s   loc_56440
                bra.s   loc_56474
; ---------------------------------------------------------------------------

loc_5641C:
                jsr     IsPlayerInSoz2RisingSandExitWindow(pc)
                beq.s   loc_5642A
                move.w  #$18,(Events_routine_bg).w
                bra.s   loc_56484
; ---------------------------------------------------------------------------

loc_5642A:
                tst.w   (Events_fg_5).w
                bne.s   loc_56450
                cmpi.w  #$400,(_unkEE9C).w
                blo.s   loc_5643C
                clr.w   (Special_events_routine).w

loc_5643C:
                jsr     AlignSoz2RisingSandBackgroundCamera(pc)

loc_56440:
                jsr     (DrawBGAsYouMove).l
                jsr     (PlainDeformation).l
                jmp     Go_CheckPlayerRelease(pc)
; ---------------------------------------------------------------------------

loc_56450:
                clr.w   (Events_fg_5).w
                move.w  #$10,(Special_events_routine).w
                addq.w  #4,(Events_routine_bg).w

loc_5645E:
                jsr     IsPlayerInSoz2RisingSandExitWindow(pc)
                bne.s   loc_56484
                cmpi.w  #$A00,(_unkEE9C).w
                blo.s   loc_56470
                clr.w   (Special_events_routine).w

loc_56470:
                jsr     AlignSoz2RisingSandBackgroundCamera(pc)

loc_56474:
                jsr     (DrawBGAsYouMove).l
                jsr     (PlainDeformation).l
                jmp     Go_CheckPlayerRelease(pc)
; ---------------------------------------------------------------------------

loc_56484:
                move.w  (Camera_X_pos_BG_copy).w,(Events_bg+$02).w
                move.w  (Camera_Y_pos_BG_copy).w,(Events_bg+$04).w
                jsr     SetSoz2HalfSpeedBackgroundCoordinates(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                move.w  #$1F0,(Draw_delayed_position).w
                move.w  #$1F,(Draw_delayed_rowcount).w
                clr.w   (Events_fg_5).w
                clr.w   (Special_events_routine).w
                clr.b   (Background_collision_flag).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_564BC
; ---------------------------------------------------------------------------

loc_564B8:
                jsr     SetSoz2HalfSpeedBackgroundCoordinates(pc)

loc_564BC:
                move.w  (Camera_Y_pos_BG_copy).w,d1
                moveq   #0,d2
                jsr     (Draw_PlaneHorzRightToLeft).l
                bpl.s   loc_564E8
                clr.w   (Events_bg+$02).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_564E8
; ---------------------------------------------------------------------------

loc_564D4:
                cmpi.w  #$5000,(Player_1+x_pos).w
                blo.s   loc_564E4
                cmpi.w  #$500,(Camera_Y_pos).w
                bhs.s   loc_56510

loc_564E4:
                jsr     SetSoz2HalfSpeedBackgroundCoordinates(pc)

loc_564E8:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     (Draw_TileRow).l
                move.w  (Events_bg+$02).w,d0
                beq.s   loc_5650A
                move.w  d0,(Camera_X_pos_BG_copy).w
                move.w  (Events_bg+$04).w,(Camera_Y_pos_BG_copy).w

loc_5650A:
                jmp     (PlainDeformation).l
; ---------------------------------------------------------------------------

loc_56510:
                move.w  #$5250,(Events_bg+$0C).w
                move.w  #$6D8,(Events_bg+$0E).w
                movea.w (a3),a1
                move.w  -8(a3),d0
                subq.w  #4,d0
                moveq   #0,d1
                moveq   #$10-1,d2

loc_56528:
                moveq   #4-1,d3

loc_5652A:
                move.b  (a1),4(a1)
                move.b  d1,(a1)+
                dbf     d3,loc_5652A
                adda.w  d0,a1
                dbf     d2,loc_56528
                lea     (HScroll_table).w,a1
                moveq   #$80-1,d2

loc_56540:
                move.l  d1,(a1)+
                dbf     d2,loc_56540
                jsr     UpdateSoz2BossPlaneBandAnimation(pc)
                lea     (HScroll_table).w,a1
                moveq   #$D-1,d0

loc_56550:
                move.w  (a1)+,(a1)
                andi.w  #$FFF0,(a1)+
                dbf     d0,loc_56550
                move.w  #$500,(Camera_min_Y_pos).w
                move.w  #$680,d0
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                move.w  #$5140,(Camera_max_X_pos).w
                movem.l d7-a0/a2-a3,-(sp)
                lea     (SOZ2_16x16_Custom_Kos).l,a1
                lea     (Block_table+$EA0).w,a2
                jsr     (Queue_Kos).l
                lea     (ArtKosM_SOZ2_Custom).l,a1
                move.w  #tiles_to_bytes($315),d2
                jsr     (Queue_Kos_Module).l
                movem.l (sp)+,d7-a0/a2-a3
                move.w  #$7FFF,(Palette_cycle_counter1).w
                move.b  #0,(SOZ_darkness_level).w
                move.w  (Palette_cycle_counters+$06).w,d0
                neg.b   d0
                move.b  d0,(Palette_cycle_counters+$00).w
                move.w  #0,(Palette_cycle_counters+$08).w
                move.b  #$7F,(Anim_Counters).w
                jsr     SpawnSoz2BossBandCollisionProxies(pc)
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_565F4
; ---------------------------------------------------------------------------

loc_565C6:
                move.w  (Camera_Y_pos_copy).w,d0
                cmp.w   (Camera_min_Y_pos).w,d0
                beq.s   loc_565D4
                move.w  d0,(Camera_min_Y_pos).w

loc_565D4:
                cmp.w   (Camera_max_Y_pos).w,d0
                bne.s   loc_565DE
                addq.w  #4,(Events_routine_bg).w

loc_565DE:
                move.w  #$7FFF,(Palette_cycle_counter1).w
                move.b  #$7F,(Anim_Counters).w
                tst.w   (Events_fg_5).w
                bmi.s   loc_5661A
                jsr     UpdateSoz2BossPlaneBandAnimation(pc)

loc_565F4:
                lea     SOZ2_BGDrawArray(pc),a4
                lea     (HScroll_table).w,a5
                moveq   #$20,d6
                moveq   #$D,d5
                jsr     (Draw_BG).l
                lea     SOZ2_BGDrawArray(pc),a4
                lea     (HScroll_table+$100).w,a5
                jsr     (ApplyDeformation).l
                jmp     (ShakeScreen_Setup).l
; ---------------------------------------------------------------------------

loc_5661A:
                move.w  (Camera_X_pos_BG_copy).w,d0
                subi.w  #$100,d0
                move.w  d0,(Events_bg+$02).w
                jsr     SetSoz2PostBossBackgroundCoordinates(pc)
                jsr     (Reset_TileOffsetPositionEff).l
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                movem.l d7-a0/a2-a3,-(sp)
                lea     (SOZ2_16x16_Secondary_Kos).l,a1
                lea     (Block_table+$EA0).w,a2
                jsr     (Queue_Kos).l
                lea     (ArtKosM_SOZ2_Secondary).l,a1
                move.w  #tiles_to_bytes($315),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PalID_SOZ2,d0
                jsr     (LoadPalette_Immediate).l
                movem.l (sp)+,d7-a0/a2-a3
                addq.w  #4,(Events_routine_bg).w

loc_56676:
                tst.b   (Kos_modules_left).w
                bne.s   loc_566BC
                jsr     SetSoz2PostBossBackgroundCoordinates(pc)
                move.w  #$200,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     (Draw_PlaneVertBottomUp).l
                bpl.s   loc_566A8
                clr.w   (Events_bg+$02).w
                move.w  #$52C0,(Camera_max_X_pos).w
                clr.b   (Anim_Counters).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_566A8
; ---------------------------------------------------------------------------

loc_566A4:
                jsr     SetSoz2PostBossBackgroundCoordinates(pc)

loc_566A8:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                move.w  #$200,d1
                moveq   #$20,d6
                jsr     (Draw_TileRow).l

loc_566BC:
                move.w  (Events_bg+$02).w,d0
                beq.s   loc_566C6
                move.w  d0,(Camera_X_pos_BG_copy).w

loc_566C6:
                jsr     (PlainDeformation).l
                jmp     (ShakeScreen_Setup).l

; =============== S U B R O U T I N E =======================================

SetSoz2HalfSpeedBackgroundCoordinates:
                move.w  (Camera_Y_pos_copy).w,d0
                asr.w   #1,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                asr.w   #1,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                rts
; End of function SetSoz2HalfSpeedBackgroundCoordinates

; =============== S U B R O U T I N E =======================================

AlignSoz2RisingSandBackgroundCamera:
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$2E0,d0
                add.w   (_unkEE9C).w,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                subi.w  #$1930,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                rts
; End of function AlignSoz2RisingSandBackgroundCamera

; =============== S U B R O U T I N E =======================================

UpdateSoz2BossPlaneBandAnimation:
                move.w  (Camera_Y_pos_copy).w,d0
                subi.w  #$250,d0
                move.w  #$6D8,d1
                sub.w   (Events_bg+$0E).w,d1
                add.w   d1,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                subi.w  #$4010,d0
                move.w  #$5250,d1
                sub.w   (Events_bg+$0C).w,d1
                add.w   d1,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                cmpi.b  #6,(Player_1+routine).w
                bhs.w   loc_56936
                move.w  (Events_bg+$08).w,d0
                jmp     loc_56744(pc,d0.w)
; ---------------------------------------------------------------------------

loc_56744:
                bra.w   loc_5675C
; ---------------------------------------------------------------------------
                bra.w   loc_5678A
; ---------------------------------------------------------------------------
                bra.w   loc_567B0
; ---------------------------------------------------------------------------
                bra.w   loc_5680A
; ---------------------------------------------------------------------------
                bra.w   loc_5687C
; ---------------------------------------------------------------------------
                bra.w   loc_56904
; ---------------------------------------------------------------------------

loc_5675C:
                jsr     loc_568DE(pc)
                tst.w   (Events_bg+$0A).w
                beq.w   loc_56936
                lea     (HScroll_table+$134).w,a1
                moveq   #-1,d0
                moveq   #9-1,d1

loc_56770:
                move.w  d0,-(a1)
                subq.w  #1,d0
                dbf     d1,loc_56770
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                move.w  #3,(Events_bg+$06).w
                addq.w  #4,(Events_bg+$08).w

loc_5678A:
                jsr     loc_568DE(pc)
                subq.w  #1,(Events_bg+$06).w
                bpl.w   loc_56936
                lea     (HScroll_table+$134).w,a1
                moveq   #-1,d0
                moveq   #9-1,d1

loc_5679E:
                move.w  d0,-(a1)
                subq.w  #2,d0
                dbf     d1,loc_5679E
                move.w  #8,(Events_bg+$06).w
                addq.w  #4,(Events_bg+$08).w

loc_567B0:
                jsr     loc_568DE(pc)
                subq.w  #1,(Events_bg+$06).w
                bpl.w   loc_56936
                lea     (HScroll_table+$184).w,a1
                lea     $3E(a1),a5
                lea     word_56AE2(pc),a6
                move.w  (Events_bg+$0A).w,d0
                sub.w   (Camera_Y_pos_copy).w,d0
                add.w   (Camera_Y_pos_BG_copy).w,d0
                subi.w  #$440,d0
                bcc.s   loc_567DC
                moveq   #0,d0

loc_567DC:
                lsr.w   #3,d0
                andi.w  #$FFFE,d0
                cmpi.w  #$10,d0
                bls.s   loc_567EA
                moveq   #$10,d0

loc_567EA:
                suba.w  d0,a6
                moveq   #9-1,d1

loc_567EE:
                move.l  #$80000,(a1)+
                move.w  (a6)+,(a5)+
                dbf     d1,loc_567EE
                clr.w   (Events_bg+$00).w
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                addq.w  #4,(Events_bg+$08).w

loc_5680A:
                jsr     loc_568DE(pc)
                lea     (HScroll_table+$144).w,a1
                lea     $40(a1),a5
                lea     $3E(a5),a6
                moveq   #9,d0
                moveq   #9-1,d1

loc_5681E:
                tst.b   (a6)
                beq.s   loc_5682C
                bpl.s   loc_56828
                subq.w  #1,d0
                bra.s   loc_5683A
; ---------------------------------------------------------------------------

loc_56828:
                subq.b  #1,(a6)
                bra.s   loc_5683A
; ---------------------------------------------------------------------------

loc_5682C:
                move.l  (a5),d2
                sub.l   d2,(a1)
                subi.l  #$2800,(a5)
                bpl.s   loc_5683A
                st      (a6)

loc_5683A:
                addq.w  #4,a1
                addq.w  #4,a5
                addq.w  #2,a6
                dbf     d1,loc_5681E
                tst.w   d0
                beq.s   loc_56868
                cmpi.w  #9,d0
                beq.w   loc_56936
                tst.w   (Events_bg+$00).w
                bne.w   loc_56936
                moveq   #signextendB(sfx_BossRecovery),d0
                jsr     (Play_SFX).l
                st      (Events_bg+$00).w
                bra.w   loc_56936
; ---------------------------------------------------------------------------

loc_56868:
                lea     (HScroll_table+$122).w,a1
                moveq   #9-1,d1

loc_5686E:
                clr.w   (a1)+
                dbf     d1,loc_5686E
                clr.w   (Events_bg+$06).w
                addq.w  #4,(Events_bg+$08).w

loc_5687C:
                jsr     loc_568DE(pc)
                tst.w   (Events_bg+$06).w
                beq.s   loc_5689A
                subq.w  #1,(Events_bg+$06).w
                bne.w   loc_56936
                clr.w   (Events_bg+$0A).w
                clr.w   (Events_bg+$08).w
                bra.w   loc_56936
; ---------------------------------------------------------------------------

loc_5689A:
                lea     (HScroll_table+$144).w,a1
                lea     $40(a1),a5
                lea     $3F(a5),a6
                moveq   #9,d0
                moveq   #9-1,d1

loc_568AA:
                tst.b   (a6)
                beq.s   loc_568B8
                bpl.s   loc_568B4
                subq.w  #1,d0
                bra.s   loc_568C8
; ---------------------------------------------------------------------------

loc_568B4:
                subq.b  #1,(a6)
                bra.s   loc_568C8
; ---------------------------------------------------------------------------

loc_568B8:
                move.l  (a5),d2
                subi.l  #$2800,(a5)
                sub.l   d2,(a1)
                bmi.s   loc_568C8
                clr.l   (a1)
                st      (a6)

loc_568C8:
                addq.w  #4,a1
                addq.w  #4,a5
                addq.w  #2,a6
                dbf     d1,loc_568AA
                tst.w   d0
                bne.s   loc_56936
                move.w  #$F,(Events_bg+$06).w
                bra.s   loc_56936
; ---------------------------------------------------------------------------

loc_568DE:
                tst.w   (Events_fg_5).w
                bne.s   loc_568E6
                rts
; ---------------------------------------------------------------------------

loc_568E6:
                lea     (HScroll_table+$1C2).w,a1
                moveq   #0,d0
                moveq   #$C-1,d1

loc_568EE:
                move.w  d0,(a1)+
                addq.w  #5,d0
                dbf     d1,loc_568EE
                move.w  #$5140,(Camera_max_X_pos).w
                move.w  #$14,(Events_bg+$08).w
                addq.w  #4,sp

loc_56904:
                lea     (HScroll_table+$144).w,a1
                lea     $7E(a1),a5
                moveq   #$C,d0
                moveq   #$C-1,d1

loc_56910:
                tst.w   (a5)
                beq.s   loc_56918
                subq.w  #1,(a5)
                bra.s   loc_56926
; ---------------------------------------------------------------------------

loc_56918:
                subq.w  #5,(a1)
                cmpi.w  #-$100,(a1)
                bgt.s   loc_56926
                move.w  #-$100,(a1)
                subq.w  #1,d0

loc_56926:
                addq.w  #4,a1
                addq.w  #2,a5
                dbf     d1,loc_56910
                tst.w   d0
                bne.s   loc_56936
                st      (Events_fg_5).w

loc_56936:
                move.l  a0,-(sp)
                lea     (HScroll_table).w,a0
                lea     $100(a0),a1
                lea     $20(a1),a5
                lea     $20(a5),a6
                move.w  (Camera_X_pos_BG_copy).w,d0
                moveq   #$D-1,d1

loc_5694E:
                move.w  (a5)+,d2
                add.w   (a6),d2
                add.w   d0,d2
                move.w  d2,(a0)
                move.w  d2,(a1)+
                addq.w  #4,a0
                addq.w  #4,a6
                dbf     d1,loc_5694E
                movea.l (sp)+,a0
                rts
; End of function UpdateSoz2BossPlaneBandAnimation

; =============== S U B R O U T I N E =======================================

SetSoz2PostBossBackgroundCoordinates:
                move.w  (Camera_Y_pos_copy).w,d0
                asr.w   #1,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                asr.w   #1,d0
                addi.w  #$200,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                rts
; End of function SetSoz2PostBossBackgroundCoordinates

; =============== S U B R O U T I N E =======================================

ClearSoz2EntranceBackgroundChunkStrip:
                movea.w $38(a3),a5
                movea.w $3C(a3),a6
                lea     $17(a5),a5
                lea     $17(a6),a6
                moveq   #$A-1,d0

loc_56990:
                clr.b   (a5)+
                clr.b   (a6)+
                dbf     d0,loc_56990
                rts
; End of function ClearSoz2EntranceBackgroundChunkStrip

; =============== S U B R O U T I N E =======================================

IsPlayerInSoz2RisingSandExitWindow:
                cmpi.w  #$2A00,(Player_1+x_pos).w
                blo.s   loc_569B6
                move.w  (Player_1+y_pos).w,d0
                cmpi.w  #$140,d0
                blo.s   loc_569B6
                cmpi.w  #$180,d0
                bhi.s   loc_569B6
                moveq   #-1,d0
                rts
; ---------------------------------------------------------------------------

loc_569B6:
                moveq   #0,d0
                rts
; End of function IsPlayerInSoz2RisingSandExitWindow

; ---------------------------------------------------------------------------

loc_569BA:
                st      (Background_collision_flag).w
                addi.l  #$A000,(_unkEE9C).w
                move.w  #$2E0,d0
                add.w   (_unkEE9C).w,d0
                neg.w   d0
                move.w  d0,(Camera_Y_diff).w
                move.w  #$1930,(Camera_X_diff).w
                rts
; ---------------------------------------------------------------------------

Go_CheckPlayerRelease:
                movem.l d7-a0/a2-a3,-(sp)
                lea     (Player_1).w,a1
                btst    #Status_OnObj,status(a1)
                beq.s   loc_569F6
                movea.w interact(a1),a0
                jsr     (CheckPlayerReleaseFromObj).l

loc_569F6:
                lea     (Player_2).w,a1
                btst    #Status_OnObj,status(a1)
                beq.s   loc_56A0C
                movea.w interact(a1),a0
                jsr     (CheckPlayerReleaseFromObj).l

loc_56A0C:
                movem.l (sp)+,d7-a0/a2-a3
                rts

; =============== S U B R O U T I N E =======================================

SpawnSoz2BossBandCollisionProxies:
                jsr     (AllocateObject).l
                bne.s   locret_56A32
                move.l  #loc_56A34,d1
                moveq   #8-1,d2

loc_56A22:
                move.l  d1,(a1)
                move.w  d2,subtype(a1)
                jsr     (CreateNewSprite4).l
                dbne    d2,loc_56A22

locret_56A32:
                rts
; End of function SpawnSoz2BossBandCollisionProxies

; ---------------------------------------------------------------------------

loc_56A34:
                move.b  #$40,width_pixels(a0)
                bset    #7,status(a0)
                move.w  subtype(a0),d0
                lsl.w   #4,d0
                addi.w  #$458,d0
                sub.w   (Camera_Y_pos_BG_copy).w,d0
                add.w   (Camera_Y_pos_copy).w,d0
                move.w  d0,y_pos(a0)
                move.w  subtype(a0),d0
                add.w   d0,d0
                lea     word_56AF4(pc),a1
                move.w  (a1,d0.w),d4
                add.w   d0,d0
                lea     (HScroll_table+$008).w,a1
                sub.w   (a1,d0.w),d4
                add.w   (Camera_X_pos_copy).w,d4
                cmpi.w  #$10,(Events_bg+$08).w
                beq.s   loc_56A7E
                move.w  #$7FFF,d4

loc_56A7E:
                move.w  d4,x_pos(a0)
                moveq   #$4B,d1
                moveq   #8,d2
                moveq   #8,d3
                jsr     (SolidObjectFull2).l
                move.w  #-$300,d0
                lea     (Player_1).w,a1
                btst    #$10,d6
                beq.s   loc_56AA4
                move.w  d0,x_vel(a1)
                move.w  d0,y_vel(a1)

loc_56AA4:
                lea     (Player_2).w,a1
                btst    #$11,d6
                beq.s   locret_56AB6
                move.w  d0,x_vel(a1)
                move.w  d0,y_vel(a1)

locret_56AB6:
                rts
; ---------------------------------------------------------------------------
SOZ2_BGDrawArray:
                dc.w    $440,   $10,   $10,   $10,   $10,   $10,   $10,   $10,   $10,   $10,   $10,   $10, $7FFF
                dc.w    $1800
                dc.w    $1502
                dc.w    $1204
                dc.w    $0F06
                dc.w    $0C08
                dc.w    $090A
                dc.w    $060C
                dc.w    $030E
word_56AE2:
                dc.w    $0010
                dc.w    $030E
                dc.w    $060C
                dc.w    $090A
                dc.w    $0C08
                dc.w    $0F06
                dc.w    $1204
                dc.w    $1502
                dc.w    $1800
word_56AF4:
                dc.w    $1268
                dc.w    $1260
                dc.w    $1260
                dc.w    $125C
                dc.w    $1254
                dc.w    $1248
                dc.w    $1248
                dc.w    $1248
