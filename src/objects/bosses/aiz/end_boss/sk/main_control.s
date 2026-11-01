; Owner: objects/bosses/aiz/end_boss/sk
; Responsibility: Angel Island end-boss initialization, battle state, defeat sequence and player transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZEndBoss:
                move.l  #Obj_AIZEndBossWait,(a0)
                lea     AIZBossSonicDat(pc),a1
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   loc_691BE
                lea     AIZBossKnuxDat(pc),a1

loc_691BE:
                lea     (_unkFA82).w,a2
                move.w  (a1)+,(a2)+
                move.w  (a1)+,(a2)+
                move.w  (a1)+,(a2)+                     ; Load relative positional data depending on the character

Obj_AIZEndBossWait:
                move.w  (_unkFA82).w,d0
                cmp.w   (Camera_X_pos).w,d0
                bls.s   loc_691D4                       ; Only branch if Sonic has reached the boss area
                rts
; ---------------------------------------------------------------------------

loc_691D4:
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                move.l  #Obj_Wait,(a0)                  ; Set up object to wait $78 frames
                move.w  #2*60,$2E(a0)
                move.l  #Obj_AIZEndBossMusic,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.b  #1,(Boss_flag).w                ; Lock the screen
                clr.b   (_unkFAA2).w
                clr.b   (_unkFAA3).w
                moveq   #PLCID_6B,d0
                jsr     (Load_PLC).l                    ; Load Robotnik's ship and explosions
                lea     (ArtKosM_AIZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_AIZEndBoss),d2
                jsr     (Queue_Kos_Module).l            ; Load the AIZ boss ship
                lea     Pal_AIZEndBoss(pc),a1
                jmp     (PalLoad_Line1).l               ; Load the AIZ boss palette
; ---------------------------------------------------------------------------

Obj_AIZEndBossMusic:
                move.l  #Obj_AIZEndBossMain,(a0)
                moveq   #signextendB(mus_EndBoss),d0    ; Play the boss music
                jsr     (Play_Music).l
                move.b  #mus_EndBoss,(Current_music+1).w
                rts
; ---------------------------------------------------------------------------

Obj_AIZEndBossMain:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZ_EndBossIndex(pc,d0.w),d1
                jsr     AIZ_EndBossIndex(pc,d1.w)
                btst    #6,$38(a0)
                bne.w   locret_69366                    ; Only draw and touch when boss has revealed itself
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
AIZ_EndBossIndex:
                dc.w    Obj_AIZEndBossInit-AIZ_EndBossIndex
                dc.w    loc_692E2-AIZ_EndBossIndex
                dc.w    loc_6932C-AIZ_EndBossIndex
                dc.w    loc_69368-AIZ_EndBossIndex
                dc.w    loc_693F0-AIZ_EndBossIndex
                dc.w    loc_692E2-AIZ_EndBossIndex
                dc.w    loc_69456-AIZ_EndBossIndex
                dc.w    loc_6946A-AIZ_EndBossIndex
; ---------------------------------------------------------------------------

Obj_AIZEndBossInit:
                lea     ObjDat_AIZEndBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #8,collision_property(a0)       ; 8 hits defeats it
                bset    #0,render_flags(a0)
                lea     (Child1_MakeRoboShip).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   loc_69296
                move.b  #8,subtype(a1)

loc_69296:
                lea     ChildObjDat_69D18(pc),a2
                jsr     (CreateChild1_Normal).l

loc_692A0:
                move.b  #2,routine(a0)
                moveq   #signextendB(sfx_WaterfallSplash),d0
                jsr     (Play_SFX).l
                ori.b   #$48,$38(a0)
                move.l  #loc_69302,$34(a0)
                clr.b   collision_flags(a0)
                bsr.w   ResetAIZBossHitFlashPalette
                bclr    #0,render_flags(a0)
                cmpi.w  #8,angle(a0)
                bhs.s   loc_692D8
                bset    #0,render_flags(a0)

loc_692D8:
                lea     ChildObjDat_69D2E(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_692E2:
                lea     byte_69D98(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                bclr    #6,$38(a0)
                cmpi.b  #$2B,mapping_frame(a0)
                bne.s   locret_69300
                bset    #6,$38(a0)

locret_69300:
                rts
; ---------------------------------------------------------------------------

loc_69302:
                move.b  #4,routine(a0)
                bclr    #6,$38(a0)
                bset    #7,art_tile(a0)
                move.b  #$16,collision_flags(a0)
                move.l  #loc_6933A,$34(a0)
                lea     ChildObjDat_69D36(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6932C:
                lea     byte_69DB3(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                bra.w   HandleAIZBossHitFlashOrDefeat
; ---------------------------------------------------------------------------

loc_6933A:
                move.b  #6,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_6937E,$34(a0)
                move.w  #$C0,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)

locret_69366:
                rts
; ---------------------------------------------------------------------------

loc_69368:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                bra.w   HandleAIZBossHitFlashOrDefeat
; ---------------------------------------------------------------------------

loc_6937E:
                bset    #1,$38(a0)
                btst    #7,$38(a0)
                bne.s   loc_693A2
                move.w  #4,angle(a0)
                move.w  #$2F,$2E(a0)
                move.l  #loc_693DC,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_693A2:
                move.w  #$BF,d0
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   loc_693B2
                move.w  #$FF,d0

loc_693B2:
                move.w  d0,$2E(a0)
                move.l  #loc_693C0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_693C0:
                move.b  #8,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_693FA,$34(a0)
                andi.b  #$F5,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_693DC:
                st      (_unkFAA2).w
                move.w  #$8F,$2E(a0)
                move.l  #loc_693C0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_693F0:
                bsr.w   HandleAIZBossHitFlashOrDefeat
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_693FA:
                move.b  #$A,routine(a0)
                moveq   #signextendB(sfx_WaterfallSplash),d0
                jsr     (Play_SFX).l
                move.l  #loc_6942A,$34(a0)
                clr.b   collision_flags(a0)
                bsr.w   ResetAIZBossHitFlashPalette
                lea     ChildObjDat_69D2E(pc),a2
                jsr     (CreateChild1_Normal).l
                move.b  #2,subtype(a1)
                rts
; ---------------------------------------------------------------------------

loc_6942A:
                move.b  #$C,routine(a0)
                bset    #7,$38(a0)
                beq.s   loc_6943E
                move.b  #$E,routine(a0)

loc_6943E:
                move.l  #loc_69476,$34(a0)
                bclr    #7,art_tile(a0)
                move.b  #0,mapping_frame(a0)
                bra.w   loc_69A66
; ---------------------------------------------------------------------------

loc_69456:
                move.w  (Camera_min_X_pos).w,d0
                addq.w  #2,d0
                cmp.w   (_unkFA84).w,d0
                bhi.s   loc_69466
                move.w  d0,(Camera_min_X_pos).w

loc_69466:
                addq.w  #2,(Camera_max_X_pos).w

loc_6946A:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_69476:
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                bra.w   loc_692A0
; ---------------------------------------------------------------------------

loc_69482:
                move.l  #loc_694A4,$34(a0)
                st      (_unkFAA3).w
                move.l  #Obj_Wait,(a0)
                bset    #4,$38(a0)
                lea     ChildObjDat_69D66(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_694A4:
                move.l  #loc_694D4,(a0)

loc_694AA:
                st      (_unkFAA8).w
                clr.b   (Boss_flag).w
                lea     (PLC_EggCapsule).l,a1
                jsr     (Load_PLC_Raw).l
                lea     ChildObjDat_69D8C(pc),a2
                jsr     (CreateChild6_Simple).l
                bset    #1,render_flags(a1)
                jmp     (PLCLoad_AnimalsAndExplosion).l
; ---------------------------------------------------------------------------

loc_694D4:
                tst.b   (_unkFAA8).w
                bne.w   locret_69366
                move.l  #loc_69526,(a0)
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                jsr     (Restore_LevelMusic).l
                st      (Ctrl_1_locked).w
                clr.w   (Ctrl_1_logical).w
                jsr     (AllocateObject).l
                bne.s   loc_6950E
                move.l  #loc_863C0,(a1)

loc_6950E:
                move.w  (_unkFA84).w,d0
                addi.w  #$158,d0
                move.w  d0,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_69526:
                move.b  #5,(Flying_picking_Sonic_timer).w
                lea     (Player_1).w,a1
                move.w  (_unkFA84).w,d0
                addi.w  #$1F8,d0
                cmp.w   x_pos(a1),d0
                bls.s   loc_69546
                move.w  #(button_right_mask<<8)|button_right_mask,(Ctrl_1_logical).w
                rts
; ---------------------------------------------------------------------------

loc_69546:
                jsr     (Stop_Object).l
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   loc_6957A
                move.l  #loc_69588,(a0)
                jsr     (AllocateObject).l
                bne.s   loc_6956E
                move.l  #Obj_CutsceneKnuckles,(a1)
                move.b  #4,subtype(a1)

loc_6956E:
                lea     (PLC_Explosion).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

loc_6957A:
                move.l  #loc_695CE,(a0)
                move.w  #(button_C_mask<<8)|button_C_mask,(Ctrl_1_logical).w
                rts
; ---------------------------------------------------------------------------

loc_69588:
                move.b  #5,(Flying_picking_Sonic_timer).w
                tst.b   (Ctrl_1_locked).w
                beq.s   loc_695A0
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

loc_695A0:
                move.l  #loc_695A8,(a0)
                rts
; ---------------------------------------------------------------------------

loc_695A8:
                move.b  #5,(Flying_picking_Sonic_timer).w

loc_695AE:
                move.w  (_unkFA86).w,d0
                addi.w  #$1E6,d0
                cmp.w   (Player_1+y_pos).w,d0
                bhi.w   locret_69366
                move.w  #$100,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_695CE:
                move.w  #button_C_mask<<8,(Ctrl_1_logical).w
                lea     (Player_1).w,a1
                bset    #7,art_tile(a1)
                tst.w   y_vel(a1)
                bmi.w   locret_69366
                move.l  #loc_69616,(a0)
                move.b  #$83,object_control(a1)
                move.b  #$CB,mapping_frame(a1)
                jsr     (Player_Load_PLC).l
                move.w  #$1000,d0
                move.w  d0,(Camera_stored_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                lea     (Child6_IncLevY).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_69616:
                lea     (Player_1).w,a1
                jsr     (MoveSprite_NormGravity).l
                bra.s   loc_695AE
