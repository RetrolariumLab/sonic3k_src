; Owner: game/level/zones/ssz/sk
; Responsibility: Sky Sanctuary act-one screen initialization, event dispatch and progression control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

SSZ1_ScreenInit:
                tst.b   (Last_star_post_hit).w
                bne.s   loc_57246
                jsr     (AllocateObject).l
                bne.s   loc_57246
                move.l  #Obj_57C1E,(a1)
                move.w  #$100,x_pos(a1)
                move.b  #$6C,$2D(a1)
                st      (Events_bg+$05).w
                move.w  #$200,(Camera_max_X_pos).w
                move.w  #$BC0,d0
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                moveq   #$60,d0
                move.w  d0,(Camera_X_pos_copy).w
                move.w  d0,(Camera_X_pos).w
                move.w  #$F49,d0
                move.w  d0,(Camera_Y_pos_copy).w
                move.w  d0,(Camera_Y_pos).w
                st      (Scroll_lock).w

loc_57246:
                clr.w   (_unkEE98).w
                clr.w   (_unkEE9C).w
                lea     (HScroll_table+$1F6).w,a1
                lea     (a1),a5
                moveq   #5-1,d0

loc_57256:
                clr.w   (a1)+
                dbf     d0,loc_57256
                lea     word_58758(pc),a6
                moveq   #5-1,d1
                jsr     (AllocateObject).l
                bne.s   loc_5728E

loc_5726A:
                move.w  a1,(a5)+
                move.l  #loc_57BB2,(a1)
                move.w  (a6)+,$38(a1)
                move.w  (a6)+,$3A(a1)
                move.w  (a6)+,$40(a1)
                move.w  (a6)+,d2
                move.b  d2,mapping_frame(a1)
                jsr     (CreateNewSprite4).l
                dbne    d1,loc_5726A

loc_5728E:
                jsr     sub_5758A(pc)
                jsr     (Reset_TileOffsetPositionActual).l
                jmp     (Refresh_PlaneFull).l
; ---------------------------------------------------------------------------

SSZ1_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                move.w  (Events_routine_fg).w,d0
                jmp     SSZ1_ScreenEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

SSZ1_ScreenEvent_Index:
                bra.w   loc_572BA
; ---------------------------------------------------------------------------
                bra.w   loc_57344
; ---------------------------------------------------------------------------
                bra.w   loc_574B0
; ---------------------------------------------------------------------------

loc_572BA:
                tst.b   (End_of_level_flag).w
                bne.s   loc_572CE
                jsr     sub_575EA(pc)
                jsr     sub_5758A(pc)
                jmp     (DrawTilesAsYouMove).l
; ---------------------------------------------------------------------------

loc_572CE:
                jsr     (AllocateObject).l
                bne.s   loc_572E2
                move.l  #Obj_57E96,(a1)
                move.w  #$1E,$2E(a1)

loc_572E2:
                lea     (HScroll_table+$E0).w,a1
                lea     $20(a1),a5
                moveq   #$A-1,d0

loc_572EC:
                move.w  #-1,(a1)+
                clr.l   (a5)+
                clr.l   $3C(a5)
                dbf     d0,loc_572EC
                jsr     sub_5750C(pc)
                lea     (HScroll_table+$80).w,a1
                move.w  (Camera_Y_pos_mask).w,d0
                moveq   #$A-1,d1

loc_57308:
                move.w  (a1)+,(a1)
                and.w   d0,(a1)+
                dbf     d1,loc_57308
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                st      (Ctrl_1_locked).w
                st      (Ctrl_2_locked).w
                clr.w   (Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                st      (Scroll_lock).w
                st      (Screen_shake_flag).w
                move.w  #4,(Special_V_int_routine).w
                addq.w  #4,(Events_routine_fg).w
                bra.s   loc_5734E
; ---------------------------------------------------------------------------

loc_57344:
                tst.w   (Events_fg_4).w
                bne.s   loc_57360
                jsr     sub_5750C(pc)

loc_5734E:
                lea     word_577B2(pc),a4
                lea     (HScroll_table+$80).w,a5
                moveq   #$F,d6
                moveq   #$A,d5
                jmp     (DrawTilesVDeform).l
; ---------------------------------------------------------------------------

loc_57360:
                movem.l d7-a0/a2-a3,-(sp)
                lea     (SSZ1_128x128_Custom_Kos).l,a1
                lea     (Chunk_table+$180).l,a2
                jsr     (Queue_Kos).l
                lea     (SSZ1_16x16_Custom_Kos).l,a1
                lea     (Block_table+$B8).w,a2
                jsr     (Queue_Kos).l
                lea     (ArtKosM_SSZ1_Custom).l,a1
                move.w  #tiles_to_bytes($073),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_SSZSpiralRamp).l,a1
                move.w  #tiles_to_bytes(ArtTile_SSZSpiralRamp),d2
                jsr     (Queue_Kos_Module).l
                movem.l (sp)+,d7-a0/a2-a3
                move.w  -8(a3),d0
                subq.w  #3,d0
                movea.w (a3),a1
                move.b  #4,(a1,d0.w)
                move.b  #5,1(a1,d0.w)
                move.b  #6,2(a1,d0.w)
                movea.w 4(a3),a1
                move.b  #7,(a1,d0.w)
                move.b  #8,1(a1,d0.w)
                move.b  #9,2(a1,d0.w)
                lea     (Normal_palette_line_2).w,a1
                lea     Pal_SSZDeathEgg(pc),a5
                moveq   #bytesToLcnt($20),d0

loc_573E4:
                move.l  (a5)+,(a1)+
                dbf     d0,loc_573E4
                jsr     sub_574DC(pc)
                move.w  (_unkEEEA).w,d0
                move.w  d0,d1
                andi.w  #$FFF0,d0
                move.w  d0,(_unkEEF2).w
                move.w  (_unkEEEE).w,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(_unkEEF4).w
                st      (_unkEE98).w
                clr.l   (_unkEEF6).w
                clr.w   (_unkEEFA).w
                jsr     (AllocateObject).l
                bne.w   loc_574A0
                move.w  #$5A8,d1
                move.w  #$58C,d2
                move.w  #$554,d3
                moveq   #$A-1,d4

loc_5742C:
                move.l  #loc_58234,(a1)
                move.w  #$1A38,x_pos(a1)
                move.w  d1,y_pos(a1)
                jsr     (CreateNewSprite4).l
                bne.s   loc_574A0
                move.l  #loc_58360,(a1)
                move.w  #$1A80,x_pos(a1)
                move.w  d2,y_pos(a1)
                tst.w   d4
                beq.s   loc_574A0
                jsr     (CreateNewSprite4).l
                bne.s   loc_574A0
                move.l  #loc_582AC,(a1)
                move.w  #$1A48,x_pos(a1)
                move.w  d1,y_pos(a1)
                subi.w  #$38,y_pos(a1)
                jsr     (CreateNewSprite4).l
                bne.s   loc_574A0
                move.l  #loc_581F2,(a1)
                move.w  #$19F8,x_pos(a1)
                move.w  d3,y_pos(a1)
                moveq   #$70,d5
                sub.w   d5,d1
                sub.w   d5,d2
                sub.w   d5,d3
                jsr     (CreateNewSprite4).l
                dbne    d4,loc_5742C

loc_574A0:
                st      (Events_fg_4).w
                move.w  #$C,(Special_V_int_routine).w
                addq.w  #4,(Events_routine_fg).w
                rts
; ---------------------------------------------------------------------------

loc_574B0:
                jsr     sub_574DC(pc)
                lea     (_unkEEEA).w,a6
                lea     (_unkEEF2).w,a5
                move.w  (_unkEEEE).w,d1
                moveq   #$F,d6
                jsr     (Draw_TileColumn).l
                lea     (_unkEEEE).w,a6
                lea     (_unkEEF4).w,a5
                move.w  (_unkEEEA).w,d1
                moveq   #$15,d6
                jmp     (Draw_TileRow).l

; =============== S U B R O U T I N E =======================================

sub_574DC:
                move.w  (Camera_X_pos_copy).w,(_unkEEEA).w
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$110,d0
                asr.w   #2,d0
                move.w  d0,(_unkEEEE).w
                cmpi.w  #$110,(Camera_Y_pos).w
                bne.w   sub_5758A
                addi.l  #$6000,(_unkEEF6).w
                move.w  (_unkEEF6).w,d0
                add.w   d0,(_unkEEEE).w
                bra.s   sub_5758A
; End of function sub_574DC

; =============== S U B R O U T I N E =======================================

sub_5750C:
                lea     (HScroll_table+$80).w,a5
                lea     $60(a5),a6
                move.w  (Camera_Y_pos_copy).w,d0
                moveq   #$A,d1
                moveq   #$A-1,d2

loc_5751C:
                tst.w   (a6)
                beq.s   loc_57526
                bmi.s   loc_57536
                subq.w  #1,(a6)
                bra.s   loc_57536
; ---------------------------------------------------------------------------

loc_57526:
                move.l  $80(a5),d3
                addi.l  #$800,$80(a5)
                sub.l   d3,$C0(a5)

loc_57536:
                move.w  $C0(a5),d3
                add.w   d0,d3
                cmpi.w  #$580,d3
                bhs.s   loc_5754C
                clr.l   $80(a5)
                move.w  #$580,d3
                subq.w  #1,d1

loc_5754C:
                move.w  d3,(a5)
                move.w  d3,-$20(a6)
                addq.w  #4,a5
                addq.w  #2,a6
                dbf     d2,loc_5751C
                movea.w (_unkFAA4).w,a1
                move.w  $10(a1),d0
                subi.w  #$19A0,d0
                lsr.w   #3,d0
                andi.w  #$FFFC,d0
                lea     (HScroll_table+$140).w,a5
                move.w  #$660,d2
                sub.w   (a5,d0.w),d2
                move.w  d2,$14(a1)
                tst.w   d1
                bne.s   sub_5758A
                st      (Events_fg_4+1).w
                move.l  #Delete_Current_Sprite,(a1)
; End of function sub_5750C

; =============== S U B R O U T I N E =======================================

sub_5758A:
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  (Screen_shake_offset).w,d3
                sub.w   d3,d0
                move.w  d0,d1
                asr.w   #2,d1
                add.w   d1,d0
                move.w  (_unkEE9C).w,d1
                move.w  d1,d2
                asr.w   #2,d2
                add.w   d2,d1
                asr.w   #1,d1
                add.w   d1,d0
                add.w   d3,d0
                move.w  (Camera_X_pos_copy).w,d1
                move.w  d1,d2
                asr.w   #2,d2
                add.w   d2,d1
                lea     (HScroll_table+$1F6).w,a5
                moveq   #5-1,d2

loc_575BA:
                move.w  (a5)+,d3
                beq.s   loc_575E4
                movea.w d3,a6
                move.w  $38(a6),d3
                sub.w   d0,d3
                andi.w  #$FF,d3
                addi.w  #$70,d3
                move.w  d3,$14(a6)
                move.w  $3A(a6),d3
                sub.w   d1,d3
                andi.w  #$1FF,d3
                addi.w  #$50,d3
                move.w  d3,$10(a6)

loc_575E4:
                dbf     d2,loc_575BA
                rts
; End of function sub_5758A

; =============== S U B R O U T I N E =======================================

sub_575EA:
                tst.b   (Events_bg+$06).w
                bne.w   locret_57788
                cmpi.w  #$19A0,(Camera_X_pos).w
                blo.s   loc_5761C
                cmpi.w  #$680,(Player_1+y_pos).w
                bhs.s   loc_5761C
                move.w  #$19A0,(Camera_min_X_pos).w
                move.w  #$5C0,d0
                move.w  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                st      (Events_bg+$06).w
                bra.w   locret_57788
; ---------------------------------------------------------------------------

loc_5761C:
                tst.b   (Events_bg+$05).w
                bne.w   locret_57788
                move.b  (Events_bg+$01).w,d0
                or.b    (Events_bg+$03).w,d0
                bne.s   loc_57686
                move.w  (Camera_Y_pos).w,d0
                cmpi.w  #$100,d0
                blo.s   loc_57674
                cmpi.w  #$E00,d0
                bhs.s   loc_57674
                lea     word_5778A(pc),a1
                move.w  (Player_1+x_pos).w,d1

loc_57646:
                cmp.w   (a1)+,d1
                blo.s   loc_5764E
                addq.w  #2,a1
                bra.s   loc_57646
; ---------------------------------------------------------------------------

loc_5764E:
                move.w  (a1),d2
                cmp.w   d0,d2
                bhi.s   loc_57658
                move.w  d2,(Camera_min_Y_pos).w

loc_57658:
                lea     word_5779A(pc),a1

loc_5765C:
                cmp.w   (a1)+,d1
                blo.s   loc_57664
                addq.w  #2,a1
                bra.s   loc_5765C
; ---------------------------------------------------------------------------

loc_57664:
                move.w  (a1),d2
                cmp.w   d0,d2
                blo.s   loc_57686
                move.w  d2,(Camera_max_Y_pos).w
                move.w  d2,(Camera_target_max_Y_pos).w
                bra.s   loc_57686
; ---------------------------------------------------------------------------

loc_57674:
                move.w  #-$100,(Camera_min_Y_pos).w
                move.w  #$1000,d0
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w

loc_57686:
                move.w  (Player_1+y_pos).w,d0
                cmpi.w  #$440,d0
                blo.s   loc_5770C
                cmpi.w  #$880,d0
                bhs.w   loc_5777E
                tst.b   (Events_bg+$00).w
                bmi.w   loc_5777E
                bne.w   locret_57788
                tst.b   (Events_bg+$01).w
                bne.s   loc_576E8
                move.w  #$160,(Camera_min_X_pos).w
                move.w  #$19A0,(Camera_max_X_pos).w
                cmpi.w  #$7C0,d0
                blo.w   locret_57788
                cmpi.w  #$160,(Camera_X_pos).w
                bne.w   locret_57788
                btst    #1,(Player_1+status).w
                bne.w   locret_57788
                move.w  #$160,(Camera_max_X_pos).w
                move.w  #$7C0,d0
                move.w  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                st      (Events_bg+$01).w

loc_576E8:
                cmpi.w  #$7C0,(Camera_Y_pos).w
                bne.w   locret_57788
                jsr     (AllocateObject).l
                bne.s   loc_5770A
                move.l  #Obj_SSZGHZBoss,(a1)
                st      (Events_bg+$05).w
                move.w  #$7F00,(Events_bg+$00).w

loc_5770A:
                bra.s   locret_57788
; ---------------------------------------------------------------------------

loc_5770C:
                tst.b   (Events_bg+$02).w
                bmi.s   loc_5777E
                bne.s   locret_57788
                tst.b   (Events_bg+$03).w
                bne.s   loc_5775C
                move.w  #$1660,(Camera_max_X_pos).w
                moveq   #0,d1
                tst.w   (Events_bg+$00).w
                bne.s   loc_5772C
                move.w  #$160,d1

loc_5772C:
                move.w  d1,(Camera_min_X_pos).w
                cmpi.w  #$420,d0
                blo.s   locret_57788
                cmpi.w  #$1660,(Camera_X_pos).w
                bne.s   locret_57788
                btst    #1,(Player_1+status).w
                bne.s   locret_57788
                move.w  #$1660,(Camera_min_X_pos).w
                move.w  #$380,d0
                move.w  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                st      (Events_bg+$03).w

loc_5775C:
                cmpi.w  #$380,(Camera_Y_pos).w
                bne.s   locret_57788
                jsr     (AllocateObject).l
                bne.s   loc_5777C
                move.l  #Obj_SSZMTZBoss,(a1)
                st      (Events_bg+$05).w
                move.w  #$7F00,(Events_bg+$02).w

loc_5777C:
                bra.s   locret_57788
; ---------------------------------------------------------------------------

loc_5777E:
                clr.w   (Camera_min_X_pos).w
                move.w  #$19A0,(Camera_max_X_pos).w

locret_57788:
                rts
; End of function sub_575EA

; ---------------------------------------------------------------------------
word_5778A:
                dc.w    $EE0,  $D00
                dc.w    $11E0,  $CC0
                dc.w    $1340,  $B20
                dc.w    $7FFF,     0
word_5779A:
                dc.w    $640,  $C60
                dc.w    $880,  $CA0
                dc.w    $1200,  $C60
                dc.w    $1380,  $A80
                dc.w    $13C0,  $660
                dc.w    $7FFF,  $3E0
word_577B2:
                dc.w    $19C0
                dc.w    $20
                dc.w    $20
                dc.w    $20
                dc.w    $20
                dc.w    $20
                dc.w    $20
                dc.w    $20
                dc.w    $20
                dc.w    $7FFF
word_577C6:
                dc.w    0,     9
                dc.w    $C,     6
                dc.w    3,    $C
                dc.w    0,     9
                dc.w    $C,     3
Pal_SSZDeathEgg:
                binclude "data/Levels/SSZ/Palettes/Death Egg.bin"
                even
