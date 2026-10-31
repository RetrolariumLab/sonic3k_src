; Owner: objects/bosses/mgz/miniboss/sk
; Responsibility: Marble Garden Tunnelbot and miniboss state machines, spawned spires, movement helpers and private palette constants
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Tunnelbot:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Tunnelbot_Index(pc,d0.w),d1
                jsr     Tunnelbot_Index(pc,d1.w)
                bsr.w   sub_88A62
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Tunnelbot_Index:
                dc.w    loc_88480-Tunnelbot_Index
                dc.w    loc_884A2-Tunnelbot_Index
                dc.w    loc_884D2-Tunnelbot_Index
                dc.w    loc_884FA-Tunnelbot_Index
                dc.w    loc_8852E-Tunnelbot_Index
; ---------------------------------------------------------------------------

loc_88480:
                lea     ObjDat_Tunnelbot(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #-2,collision_property(a0)
                move.b  #$28,y_radius(a0)
                jsr     (Swing_Setup1).l
                lea     ChildObjDat_88B2C(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_884A2:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                bhs.w   locret_884D0
                move.b  #4,routine(a0)
                move.l  #byte_88B73,$30(a0)
                move.l  #loc_884E2,$34(a0)

locret_884D0:
                rts
; ---------------------------------------------------------------------------

loc_884D2:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     Animate_RawGetFaster(pc)
; ---------------------------------------------------------------------------

loc_884E2:
                move.b  #6,routine(a0)
                move.l  #byte_88B79,$30(a0)
                move.l  #loc_88514,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_884FA:
                jsr     Animate_Raw(pc)
                subq.w  #1,y_pos(a0)
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   locret_88512
                movea.l $34(a0),a1
                jsr     (a1)

locret_88512:
                rts
; ---------------------------------------------------------------------------

loc_88514:
                move.b  #8,routine(a0)
                st      (Screen_shake_flag).w
                move.w  #$BF,$2E(a0)
                move.l  #loc_8855A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8852E:
                jsr     Animate_Raw(pc)
                moveq   #-2,d0
                move.b  (V_int_run_count+3).w,d1
                btst    #0,d1
                beq.s   loc_88540
                moveq   #1,d0

loc_88540:
                add.w   d0,y_pos(a0)
                andi.b  #7,d1
                bne.s   loc_88556
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l
                bsr.w   sub_88A32

loc_88556:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_8855A:
                clr.w   (Screen_shake_flag).w
                st      (Level_trigger_array+8).w
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

Obj_MGZMiniboss:
                lea     word_8859C(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MGZMiniboss_Index(pc,d0.w),d1
                jsr     MGZMiniboss_Index(pc,d1.w)
                bsr.w   sub_88A62
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
MGZMiniboss_Index:
                dc.w    loc_885A4-MGZMiniboss_Index
                dc.w    loc_88604-MGZMiniboss_Index
                dc.w    loc_884D2-MGZMiniboss_Index
                dc.w    loc_884FA-MGZMiniboss_Index
                dc.w    loc_8852E-MGZMiniboss_Index
                dc.w    loc_8867A-MGZMiniboss_Index
                dc.w    loc_886EA-MGZMiniboss_Index
                dc.w    loc_88748-MGZMiniboss_Index
                dc.w    loc_8876A-MGZMiniboss_Index
                dc.w    loc_88790-MGZMiniboss_Index
word_8859C:
                dc.w    $D20,  $EC0, $2B80, $3080
; ---------------------------------------------------------------------------

loc_885A4:
                lea     ObjDat_Tunnelbot(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #6,collision_property(a0)
                move.b  #$28,y_radius(a0)
                move.w  #$2E00,(Camera_max_X_pos).w
                move.w  #$E10,(Camera_target_max_Y_pos).w
                move.w  #$2E00,$3A(a0)
                move.l  #loc_88616,$34(a0)
                jsr     (Swing_Setup1).l
                bset    #1,$38(a0)
                lea     PLC_MGZMiniboss(pc),a1
                jsr     (Load_PLC_Raw).l
                jsr     (AllocateObject).l
                bne.s   loc_885FC
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Miniboss,subtype(a1)

loc_885FC:
                lea     ChildObjDat_88B2C(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_88604:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (loc_85C7E).l
; ---------------------------------------------------------------------------

loc_88616:
                move.b  #4,routine(a0)
                move.l  #byte_88B73,$30(a0)
                move.l  #loc_8862E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8862E:
                move.b  #6,routine(a0)
                move.l  #byte_88B79,$30(a0)
                move.l  #loc_88646,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_88646:
                move.b  #8,routine(a0)
                st      (Screen_shake_flag).w
                move.w  #$7F,$2E(a0)
                move.l  #loc_88660,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_88660:
                move.b  #$A,routine(a0)
                clr.w   (Screen_shake_flag).w
                move.w  #$3F,$2E(a0)
                move.l  #loc_8867E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8867A:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_8867E:
                move.b  #$C,routine(a0)
                bset    #1,render_flags(a0)
                st      (Screen_shake_flag).w
                move.w  #$7F,$2E(a0)
                move.l  #loc_88716,$34(a0)
                move.w  (Camera_X_pos).w,x_pos(a0)
                jsr     (Random_Number).l
                andi.w  #$E,d0
                move.w  word_886DA(pc,d0.w),d1
                add.w   d1,x_pos(a0)
                subi.w  #$40,y_pos(a0)
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   locret_886D8
                move.w  d0,d3
                lea     ChildObjDat_88B62(pc),a2
                jsr     CreateChild1_Normal(pc)
                cmpi.w  #8,d3
                bhs.s   locret_886D8
                bset    #0,render_flags(a1)

locret_886D8:
                rts
; ---------------------------------------------------------------------------
word_886DA:
                dc.w    $30,   $48,   $60,   $78,   $C8,   $E0,   $F8,  $110
; ---------------------------------------------------------------------------

loc_886EA:
                jsr     Animate_Raw(pc)
                moveq   #2,d0
                move.b  (V_int_run_count+3).w,d1
                btst    #0,d1
                beq.s   loc_886FC
                moveq   #-1,d0

loc_886FC:
                add.w   d0,y_pos(a0)
                andi.b  #7,d1
                bne.s   loc_88712
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l
                bsr.w   sub_88A32

loc_88712:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_88716:
                move.b  #$E,routine(a0)
                clr.w   (Screen_shake_flag).w
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   loc_88738
                move.w  #$2F,$2E(a0)
                move.l  #loc_88754,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_88738:
                move.w  #$17,$2E(a0)
                move.l  #loc_88776,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_88748:
                addq.w  #4,y_pos(a0)
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_88754:
                move.b  #$10,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_88776,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8876A:
                jsr     Animate_Raw(pc)
                subq.w  #1,y_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_88776:
                move.b  #$12,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_887A4,$34(a0)
                jmp     (Swing_Setup1).l
; ---------------------------------------------------------------------------

loc_88790:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_887A4:
                bclr    #1,render_flags(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_887BA,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_887BA:
                move.b  #6,routine(a0)
                move.l  #loc_88646,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_887CA:
                jsr     (Obj_EndSignControl).l
                lea     ChildObjDat_88B42(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_887DA:
                move.w  (Camera_X_pos).w,d0
                addq.w  #1,d0
                move.w  d0,(Camera_X_pos).w
                move.w  d0,(Camera_min_X_pos).w
                cmpi.w  #$2E00,d0
                blo.w   locret_884D0
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_887F6:
                move.l  #loc_88804,(a0)
                move.b  #$9E,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_88804:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_8881A
                jsr     Refresh_ChildPositionAdjusted(pc)
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

loc_8881A:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_88820:
                lea     ObjDat3_88B02(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bset    #3,shield_reaction(a0)
                jsr     (Random_Number).l
                andi.b  #3,d0
                move.b  d0,mapping_frame(a0)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_88854
                tst.b   d0
                bne.s   loc_88854
                lea     ObjDat3_88B0E(pc),a1
                jsr     SetUp_ObjAttributes(pc)

loc_88854:
                move.l  #MoveDraw_SpriteTimed2,(a0)
                move.w  #$5F,$2E(a0)
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_88864:
                lea     ObjDat3_88B20(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_888A6,(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$30,d0
                btst    #0,render_flags(a0)
                beq.s   loc_88886
                addi.w  #$E0,d0

loc_88886:
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$F0,d0
                move.w  d0,y_pos(a0)
                move.w  d0,$3A(a0)
                clr.b   routine(a0)
                move.w  #$F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_888A6:
                btst    #4,$38(a0)
                bne.w   loc_88942
                move.w  x_pos(a0),-(sp)
                bsr.w   sub_88976
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
                beq.s   loc_88926
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   loc_88902
                bclr    #5,status(a0)
                lea     (Player_1).w,a1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$28,d0
                bmi.s   loc_88902
                jsr     (sub_24280).l

loc_88902:
                andi.b  #2,d6
                beq.s   loc_88926
                bclr    #6,status(a0)
                lea     (Player_2).w,a1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$28,d0
                bmi.s   loc_88926
                jsr     (sub_24280).l

loc_88926:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_8893C
                move.b  #7,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)

loc_8893C:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_88942:
                jsr     Displace_PlayerOffObject(pc)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_8894C:
                lea     word_88B1A(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  RawAni_88970(pc,d0.w),mapping_frame(a0)
                moveq   #4,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------
RawAni_88970:
                dc.b    4,   3,   5,   6,   6
                even

; =============== S U B R O U T I N E =======================================

sub_88976:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_88984(pc,d0.w),d1
                jmp     off_88984(pc,d1.w)
; End of function sub_88976

; ---------------------------------------------------------------------------
off_88984:
                dc.w    loc_8898E-off_88984
                dc.w    loc_889A8-off_88984
                dc.w    loc_889E8-off_88984
                dc.w    loc_88A08-off_88984
                dc.w    loc_88A18-off_88984
; ---------------------------------------------------------------------------

loc_8898E:
                subq.w  #4,y_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.w   locret_884D0
                move.b  #2,routine(a0)
                move.w  #$3F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_889A8:
                subq.w  #1,$2E(a0)
                bpl.w   locret_884D0
                move.b  #4,routine(a0)
                move.w  #$100,d0
                btst    #0,render_flags(a0)
                beq.s   loc_889C4
                neg.w   d0

loc_889C4:
                add.w   d0,x_vel(a0)
                move.w  #$DF,$2E(a0)
                move.w  #$100,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_889E8:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.w   locret_884D0
                move.b  #6,routine(a0)
                move.w  #$3F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_88A08:
                subq.w  #1,$2E(a0)
                bpl.w   locret_884D0
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_88A18:
                move.w  y_pos(a0),d0
                addq.w  #2,d0
                move.w  d0,y_pos(a0)
                cmp.w   $3A(a0),d0
                blo.w   locret_884D0
                bset    #4,$38(a0)
                rts

; =============== S U B R O U T I N E =======================================

sub_88A32:
                lea     ChildObjDat_88B3A(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   locret_88A60
                jsr     (Random_Number).l
                andi.w  #$1FF,d0
                move.w  (Camera_X_pos).w,d1
                subi.w  #$40,d1
                add.w   d0,d1
                move.w  d1,x_pos(a1)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,y_pos(a1)

locret_88A60:
                rts
; End of function sub_88A32

; =============== S U B R O U T I N E =======================================

sub_88A62:
                tst.b   collision_flags(a0)
                bne.s   locret_88AB2
                tst.b   collision_property(a0)
                beq.s   loc_88AB4
                tst.b   $20(a0)
                bne.s   loc_88A88
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

loc_88A88:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_88A94
                addq.w  #2*3,d0

loc_88A94:
                lea     word_88AE4(pc),a1
                lea     word_88AEA(pc,d0.w),a2
                jsr     CopyWordData_3(pc)
                subq.b  #1,$20(a0)
                bne.s   locret_88AB2
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_88AB2:
                rts
; ---------------------------------------------------------------------------

loc_88AB4:
                move.l  #Wait_FadeToLevelMusic,(a0)
                clr.w   (Screen_shake_flag).w
                move.l  #loc_887CA,$34(a0)
                jsr     (AllocateObject).l
                bne.s   loc_88AD4
                move.l  #loc_887DA,(a1)

loc_88AD4:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                jmp     BossDefeated_StopTimer(pc)
; End of function sub_88A62

; ---------------------------------------------------------------------------
word_88AE4:
                dc.w    Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
word_88AEA:
                dc.w    $CAA,  $866,  $644
                dc.w    $EEE,  $EEE,  $EEE
