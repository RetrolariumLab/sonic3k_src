; Owner: objects/bosses/mgz/miniboss/s3
; Responsibility: Marble Garden Tunnelbot and miniboss state machines, spawned spires, movement helpers and private palette constants
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Tunnelbot:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Tunnelbot_Index(pc,d0.w),d1
                jsr     Tunnelbot_Index(pc,d1.w)
                bsr.w   HandleMGZTunnelbotHitFlashOrDefeat
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Tunnelbot_Index:
                dc.w    loc_5626C-Tunnelbot_Index
                dc.w    loc_5628E-Tunnelbot_Index
                dc.w    loc_562BE-Tunnelbot_Index
                dc.w    loc_562E6-Tunnelbot_Index
                dc.w    loc_5631A-Tunnelbot_Index
; ---------------------------------------------------------------------------

loc_5626C:
                lea     ObjDat_Tunnelbot(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #-2,collision_property(a0)
                move.b  #$28,y_radius(a0)
                jsr     (Swing_Setup1).l
                lea     ChildObjDat_568EA(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_5628E:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                bhs.w   locret_562BC
                move.b  #4,routine(a0)
                move.l  #byte_56931,$30(a0)
                move.l  #loc_562CE,$34(a0)

locret_562BC:
                rts
; ---------------------------------------------------------------------------

loc_562BE:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     Animate_RawGetFaster(pc)
; ---------------------------------------------------------------------------

loc_562CE:
                move.b  #6,routine(a0)
                move.l  #byte_56937,$30(a0)
                move.l  #loc_56300,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_562E6:
                jsr     Animate_Raw(pc)
                subq.w  #1,y_pos(a0)
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   locret_562FE
                movea.l $34(a0),a1
                jsr     (a1)

locret_562FE:
                rts
; ---------------------------------------------------------------------------

loc_56300:
                move.b  #8,routine(a0)
                st      (Screen_shake_flag).w
                move.w  #$BF,$2E(a0)
                move.l  #loc_56346,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5631A:
                jsr     Animate_Raw(pc)
                moveq   #-2,d0
                move.b  (V_int_run_count+3).w,d1
                btst    #0,d1
                beq.s   loc_5632C
                moveq   #1,d0

loc_5632C:
                add.w   d0,y_pos(a0)
                andi.b  #7,d1
                bne.s   loc_56342
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l
                bsr.w   SpawnMGZTremorDebrisAtRandomScreenX

loc_56342:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_56346:
                clr.w   (Screen_shake_flag).w
                st      (Level_trigger_array+8).w
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

Obj_MGZMiniboss:
                lea     word_56388(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MGZMiniboss_Index(pc,d0.w),d1
                jsr     MGZMiniboss_Index(pc,d1.w)
                bsr.w   HandleMGZTunnelbotHitFlashOrDefeat
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
MGZMiniboss_Index:
                dc.w    loc_56390-MGZMiniboss_Index
                dc.w    loc_563F0-MGZMiniboss_Index
                dc.w    loc_562BE-MGZMiniboss_Index
                dc.w    loc_562E6-MGZMiniboss_Index
                dc.w    loc_5631A-MGZMiniboss_Index
                dc.w    loc_56466-MGZMiniboss_Index
                dc.w    loc_564D4-MGZMiniboss_Index
                dc.w    loc_56530-MGZMiniboss_Index
                dc.w    loc_56552-MGZMiniboss_Index
                dc.w    loc_56578-MGZMiniboss_Index
word_56388:
                dc.w    $D20,  $EC0, $2B80, $3080
; ---------------------------------------------------------------------------

loc_56390:
                lea     ObjDat_Tunnelbot(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #6,collision_property(a0)
                move.b  #$28,y_radius(a0)
                move.w  #$2E00,(Camera_max_X_pos).w
                move.w  #$E10,(Camera_target_max_Y_pos).w
                move.w  #$2E00,$3A(a0)
                move.l  #loc_56402,$34(a0)
                jsr     (Swing_Setup1).l
                bset    #1,$38(a0)
                lea     PLC_MGZMiniboss(pc),a1
                jsr     (Load_PLC_Raw).l
                jsr     (AllocateObject).l
                bne.s   loc_563E8
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Miniboss,subtype(a1)

loc_563E8:
                lea     ChildObjDat_568EA(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_563F0:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (S3EndCamera_TrackMinXAndCheckY).l
; ---------------------------------------------------------------------------

loc_56402:
                move.b  #4,routine(a0)
                move.l  #byte_56931,$30(a0)
                move.l  #loc_5641A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5641A:
                move.b  #6,routine(a0)
                move.l  #byte_56937,$30(a0)
                move.l  #loc_56432,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_56432:
                move.b  #8,routine(a0)
                st      (Screen_shake_flag).w
                move.w  #$7F,$2E(a0)
                move.l  #loc_5644C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5644C:
                move.b  #$A,routine(a0)
                clr.w   (Screen_shake_flag).w
                move.w  #$3F,$2E(a0)
                move.l  #loc_5646A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_56466:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5646A:
                move.b  #$C,routine(a0)
                bset    #1,render_flags(a0)
                st      (Screen_shake_flag).w
                move.w  #$7F,$2E(a0)
                move.l  #loc_56500,$34(a0)
                move.w  (Camera_X_pos).w,x_pos(a0)
                jsr     (Random_Number).l
                andi.w  #$E,d0
                move.w  word_564C4(pc,d0.w),d1
                add.w   d1,x_pos(a0)
                subi.w  #$40,y_pos(a0)
                tst.b   (_unkFA80+1).w
                beq.s   locret_564C2
                move.w  d0,d3
                lea     ChildObjDat_56920(pc),a2
                jsr     CreateChild1_Normal(pc)
                cmpi.w  #8,d3
                bhs.s   locret_564C2
                bset    #0,render_flags(a1)

locret_564C2:
                rts
; ---------------------------------------------------------------------------
word_564C4:
                dc.w    $30,   $48,   $60,   $78,   $C8,   $E0,   $F8,  $110
; ---------------------------------------------------------------------------

loc_564D4:
                jsr     Animate_Raw(pc)
                moveq   #2,d0
                move.b  (V_int_run_count+3).w,d1
                btst    #0,d1
                beq.s   loc_564E6
                moveq   #-1,d0

loc_564E6:
                add.w   d0,y_pos(a0)
                andi.b  #7,d1
                bne.s   loc_564FC
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l
                bsr.w   SpawnMGZTremorDebrisAtRandomScreenX

loc_564FC:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_56500:
                move.b  #$E,routine(a0)
                clr.w   (Screen_shake_flag).w
                tst.b   (_unkFA80+1).w
                bne.s   loc_56520
                move.w  #$2F,$2E(a0)
                move.l  #loc_5653C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_56520:
                move.w  #$17,$2E(a0)
                move.l  #loc_5655E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_56530:
                addq.w  #4,y_pos(a0)
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5653C:
                move.b  #$10,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_5655E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_56552:
                jsr     Animate_Raw(pc)
                subq.w  #1,y_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5655E:
                move.b  #$12,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_5658C,$34(a0)
                jmp     (Swing_Setup1).l
; ---------------------------------------------------------------------------

loc_56578:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5658C:
                bclr    #1,render_flags(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_565A2,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_565A2:
                move.b  #6,routine(a0)
                move.l  #loc_56432,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_565B2:
                jsr     (Obj_EndSignControl).l
                lea     ChildObjDat_56900(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_565C2:
                move.l  #loc_565D0,(a0)
                move.b  #$9E,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_565D0:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_565E6
                jsr     Refresh_ChildPositionAdjusted(pc)
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

loc_565E6:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_565EC:
                lea     ObjDat3_568C0(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bset    #3,shield_reaction(a0)
                jsr     (Random_Number).l
                andi.b  #3,d0
                move.b  d0,mapping_frame(a0)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_56620
                tst.b   d0
                bne.s   loc_56620
                lea     ObjDat3_568CC(pc),a1
                jsr     SetUp_ObjAttributes(pc)

loc_56620:
                move.l  #MoveDraw_SpriteTimed2,(a0)
                move.w  #$5F,$2E(a0)
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_56630:
                lea     ObjDat3_568DE(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_56672,(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$30,d0
                btst    #0,render_flags(a0)
                beq.s   loc_56652
                addi.w  #$E0,d0

loc_56652:
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$F0,d0
                move.w  d0,y_pos(a0)
                move.w  d0,$3A(a0)
                clr.b   routine(a0)
                move.w  #$F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_56672:
                btst    #4,$38(a0)
                bne.w   loc_5670E
                move.w  x_pos(a0),-(sp)
                bsr.w   UpdateMGZMinibossSpireMotionState
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                swap    d6
                andi.w  #1|2,d6
                beq.s   loc_566F2
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   loc_566CE
                bclr    #5,status(a0)
                lea     (Player_1).w,a1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$28,d0
                bmi.s   loc_566CE
                jsr     (HurtPlayerFromSolidHazard).l

loc_566CE:
                andi.b  #2,d6
                beq.s   loc_566F2
                bclr    #6,status(a0)
                lea     (Player_2).w,a1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$28,d0
                bmi.s   loc_566F2
                jsr     (HurtPlayerFromSolidHazard).l

loc_566F2:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_56708
                move.b  #7,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)

loc_56708:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5670E:
                jsr     Displace_PlayerOffObject(pc)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_56718:
                lea     word_568D8(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  RawAni_5673C(pc,d0.w),mapping_frame(a0)
                moveq   #4,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------
RawAni_5673C:
                dc.b    4,   3,   5,   6,   6
                even

; =============== S U B R O U T I N E =======================================

UpdateMGZMinibossSpireMotionState:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_56750(pc,d0.w),d1
                jmp     off_56750(pc,d1.w)
; End of function UpdateMGZMinibossSpireMotionState

; ---------------------------------------------------------------------------
off_56750:
                dc.w    loc_5675A-off_56750
                dc.w    loc_56774-off_56750
                dc.w    loc_567B4-off_56750
                dc.w    loc_567D4-off_56750
                dc.w    loc_567E4-off_56750
; ---------------------------------------------------------------------------

loc_5675A:
                subq.w  #4,y_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.w   locret_562BC
                move.b  #2,routine(a0)
                move.w  #$3F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_56774:
                subq.w  #1,$2E(a0)
                bpl.w   locret_562BC
                move.b  #4,routine(a0)
                move.w  #$100,d0
                btst    #0,render_flags(a0)
                beq.s   loc_56790
                neg.w   d0

loc_56790:
                add.w   d0,x_vel(a0)
                move.w  #$DF,$2E(a0)
                move.w  #$100,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_567B4:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.w   locret_562BC
                move.b  #6,routine(a0)
                move.w  #$3F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_567D4:
                subq.w  #1,$2E(a0)
                bpl.w   locret_562BC
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_567E4:
                move.w  y_pos(a0),d0
                addq.w  #2,d0
                move.w  d0,y_pos(a0)
                cmp.w   $3A(a0),d0
                blo.w   locret_562BC
                bset    #4,$38(a0)
                rts

; =============== S U B R O U T I N E =======================================

SpawnMGZTremorDebrisAtRandomScreenX:
                lea     ChildObjDat_568F8(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   locret_5682C
                jsr     (Random_Number).l
                andi.w  #$1FF,d0
                move.w  (Camera_X_pos).w,d1
                subi.w  #$40,d1
                add.w   d0,d1
                move.w  d1,x_pos(a1)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,y_pos(a1)

locret_5682C:
                rts
; End of function SpawnMGZTremorDebrisAtRandomScreenX

; =============== S U B R O U T I N E =======================================

HandleMGZTunnelbotHitFlashOrDefeat:
                tst.b   collision_flags(a0)
                bne.s   locret_5687E
                tst.b   collision_property(a0)
                beq.s   loc_56880
                tst.b   $20(a0)
                bne.s   loc_56854
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

loc_56854:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_56860
                addq.w  #2*3,d0

loc_56860:
                lea     word_568A2(pc),a1
                lea     word_568A8(pc,d0.w),a2
                jsr     CopyWordData_3(pc)
                subq.b  #1,$20(a0)
                bne.s   locret_5687E
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_5687E:
                rts
; ---------------------------------------------------------------------------

loc_56880:
                move.l  #Wait_Draw,(a0)
                clr.w   (Screen_shake_flag).w
                move.l  #loc_565B2,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                jmp     BossDefeated_StopTimer(pc)
; End of function HandleMGZTunnelbotHitFlashOrDefeat

; ---------------------------------------------------------------------------
word_568A2:
                dc.w    Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
word_568A8:
                dc.w    $CAA,  $866,  $644
                dc.w    $EEE,  $EEE,  $EEE
