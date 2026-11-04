; Owner: objects/bosses/mgz/end_boss/s3
; Responsibility: Marble Garden end-boss Sonic or Knuckles battle controllers, progression and defeat state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MGZEndBoss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MGZEndBoss_Index(pc,d0.w),d1
                jsr     MGZEndBoss_Index(pc,d1.w)
                bsr.w   MGZ2_SpecialCheckHit
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
MGZEndBoss_Index:
                dc.w    loc_4A132-MGZEndBoss_Index
                dc.w    loc_4A1C2-MGZEndBoss_Index
                dc.w    loc_4A1EC-MGZEndBoss_Index
                dc.w    loc_4A210-MGZEndBoss_Index
                dc.w    loc_4A230-MGZEndBoss_Index
                dc.w    loc_4A1C2-MGZEndBoss_Index
                dc.w    loc_4A288-MGZEndBoss_Index
                dc.w    loc_4A2C8-MGZEndBoss_Index
                dc.w    loc_4A2EA-MGZEndBoss_Index
                dc.w    loc_4A1C2-MGZEndBoss_Index
                dc.w    loc_4A31C-MGZEndBoss_Index
                dc.w    loc_4A1C2-MGZEndBoss_Index
                dc.w    loc_4A2EA-MGZEndBoss_Index
                dc.w    loc_4A39A-MGZEndBoss_Index
                dc.w    loc_4A3D4-MGZEndBoss_Index
                dc.w    loc_4A2C8-MGZEndBoss_Index
                dc.w    loc_4A2EA-MGZEndBoss_Index
; ---------------------------------------------------------------------------

loc_4A132:
                lea     ObjDat_MGZDrillBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #7,art_tile(a0)
                st      $46(a0)
                move.b  #8,collision_property(a0)
                move.b  #1,(Boss_flag).w
                move.b  #$1C,y_radius(a0)
                move.w  #$C,angle(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #2*60,$2E(a0)
                move.l  #loc_4A1C8,$34(a0)
                lea     (ArtKosM_MGZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_MGZEndBoss),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_MGZEndBossDebris).l,a1
                move.w  #tiles_to_bytes(ArtTile_MGZEndBossDebris),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_6D,d0
                jsr     (Load_PLC).l
                lea     Pal_MGZEndBoss(pc),a1
                jsr     (PalLoad_Line1).l
                lea     (Child1_MakeRoboShip3).l,a2
                jsr     (CreateChild1_Normal).l
                move.b  #9,subtype(a1)
                lea     ChildObjDat_4B3D4(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_4A1C2:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_4A1C8:
                move.b  #4,routine(a0)
                moveq   #signextendB(mus_EndBoss),d0
                jsr     (Play_Music).l
                move.w  #$80,y_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #loc_4A1F8,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A1EC:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_4A1F8:
                move.b  #6,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_4A222,$34(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

loc_4A210:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_4A222:
                move.b  #8,routine(a0)
                move.w  #3,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A230:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   locret_4A254
                move.w  #3,$2E(a0)
                subq.w  #2,angle(a0)
                cmpi.w  #4,angle(a0)
                bls.s   loc_4A256

locret_4A254:
                rts
; ---------------------------------------------------------------------------

loc_4A256:
                move.b  #$A,routine(a0)
                bset    #3,$38(a0)
                move.w  #$5F,$2E(a0)
                move.l  #loc_4A272,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A272:
                move.b  #$C,routine(a0)
                move.w  #$400,y_vel(a0)
                move.l  #loc_4A294,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A288:
                jsr     (MoveSprite2).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

loc_4A294:
                move.b  #$E,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_4A2CE,$34(a0)
                st      (Events_fg_4).w
                st      (Disable_death_plane).w
                moveq   #signextendB(sfx_BossHitFloor),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   locret_4A2C6
                move.l  #Obj_MGZ2_BossTransition,(a1)

locret_4A2C6:
                rts
; ---------------------------------------------------------------------------

loc_4A2C8:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_4A2CE:
                move.b  #$10,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$17,$2E(a0)
                move.l  #loc_4A2F0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A2EA:
                jmp     (Move_WaitNoFall).l
; ---------------------------------------------------------------------------

loc_4A2F0:
                move.b  #$12,routine(a0)
                bclr    #3,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_4A30E,$34(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

loc_4A30E:
                move.b  #$14,routine(a0)
                move.w  #3,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A31C:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   locret_4A33A
                move.w  #3,$2E(a0)
                subq.w  #2,angle(a0)
                beq.s   loc_4A33C

locret_4A33A:
                rts
; ---------------------------------------------------------------------------

loc_4A33C:
                move.b  #$16,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_4A352,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A352:
                move.b  #$18,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_4A36E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A36E:
                move.b  #$1A,routine(a0)
                clr.b   $46(a0)
                bset    #0,render_flags(a0)
                move.w  #$3E80,x_pos(a0)
                move.w  #$700,y_pos(a0)
                move.w  #-$80,x_vel(a0)
                move.b  #6,$3A(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

loc_4A39A:
                jsr     (MoveSprite2).l
                btst    #6,status(a0)
                bne.s   loc_4A3BE
                move.w  (Player_1+x_pos).w,d0
                cmp.w   x_pos(a0),d0
                bhs.s   loc_4A3BE
                jsr     (Swing_UpAndDown).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_4A3BE:
                move.b  #$1C,routine(a0)
                move.w  #$200,x_vel(a0)
                move.l  #loc_4A3EA,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A3D4:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                cmpi.w  #$3E00,x_pos(a0)
                blo.w   locret_49DD8

loc_4A3EA:
                move.b  #$1E,routine(a0)
                moveq   #signextendB(sfx_BossZoom),d0
                jsr     (Play_SFX).l
                bclr    #3,$38(a0)
                bclr    #2,$38(a0)
                move.w  #$9F,$2E(a0)
                move.l  #loc_4A41C,$34(a0)
                lea     ChildObjDat_4B44A(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_4A41C:
                move.w  #$1F,$2E(a0)
                move.l  #loc_4A42E,$34(a0)
                bra.w   loc_4B324
; ---------------------------------------------------------------------------

loc_4A42E:
                bset    #3,$38(a0)
                move.w  #$9F,$2E(a0)
                move.l  #loc_4A442,$34(a0)

loc_4A442:
                move.b  #$20,routine(a0)
                move.w  #$FF,$2E(a0)
                move.l  #loc_4A3EA,$34(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

Obj_MGZEndBossKnux:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MGZEndBossKnux_Index(pc,d0.w),d1
                jsr     MGZEndBossKnux_Index(pc,d1.w)
                bsr.w   MGZ2_SpecialCheckHit
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
MGZEndBossKnux_Index:
                dc.w    loc_4A132-MGZEndBossKnux_Index
                dc.w    loc_4A488-MGZEndBossKnux_Index
                dc.w    loc_4A4C2-MGZEndBossKnux_Index
                dc.w    loc_4A4DE-MGZEndBossKnux_Index
                dc.w    loc_4A542-MGZEndBossKnux_Index
                dc.w    loc_4A520-MGZEndBossKnux_Index
                dc.w    loc_4A542-MGZEndBossKnux_Index
                dc.w    loc_4A520-MGZEndBossKnux_Index
                dc.w    loc_4A542-MGZEndBossKnux_Index
; ---------------------------------------------------------------------------

loc_4A488:
                jsr     (Obj_Wait).l
                move.w  #$3A50,d0
                cmp.w   (Camera_X_pos).w,d0
                bls.s   loc_4A49A
                rts
; ---------------------------------------------------------------------------

loc_4A49A:
                move.b  #4,routine(a0)
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                move.w  #3*60,$30(a0)
                move.b  #2,subtype(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A4C2:
                jsr     (Obj_Wait).l
                subq.w  #1,$30(a0)
                bmi.s   loc_4A4D0
                rts
; ---------------------------------------------------------------------------

loc_4A4D0:
                move.b  #6,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A4DE:
                btst    #2,$38(a0)
                bne.s   loc_4A4E8
                rts
; ---------------------------------------------------------------------------

loc_4A4E8:
                move.b  #8,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_4A504,$34(a0)
                move.b  #0,subtype(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A504:
                move.b  #$A,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_4A52C,$34(a0)
                lea     (_unkFA82).w,a1
                bra.w   loc_4B184
; ---------------------------------------------------------------------------

loc_4A520:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_4A52C:
                move.b  #$C,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_4A548,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A542:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_4A548:
                move.b  #$E,routine(a0)
                move.w  #$9F,$2E(a0)
                move.l  #loc_4A56A,$34(a0)
                move.b  #2,subtype(a0)
                lea     (_unkFA8A).w,a1
                bra.w   loc_4B184
; ---------------------------------------------------------------------------

loc_4A56A:
                move.b  #$10,routine(a0)
                move.w  #$3AF0,x_pos(a0)
                move.w  #$4C0,y_pos(a0)
                move.w  #(2*60)-1,$2E(a0)
                move.l  #loc_4A4D0,$34(a0)
                bclr    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A592:
                move.l  #Obj_Wait,(a0)
                bclr    #7,render_flags(a0)
                bset    #4,$38(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #$7F,$2E(a0)
                move.l  #loc_4A5CA,$34(a0)
                move.w  #$200,priority(a0)
                lea     ChildObjDat_4B436(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_4A5CA:
                move.l  #loc_4A5D6,(a0)
                jmp     (AIZBossS3_SignalAndSpawnCapsule).l
; ---------------------------------------------------------------------------

loc_4A5D6:
                tst.b   (_unkFAA8).w
                bne.w   locret_49DD8
                move.l  #locret_4A5FA,(a0)
                bset    #4,$38(a0)
                jsr     (AllocateObject).l
                bne.s   locret_4A5F8
                move.l  #loc_4AE36,(a1)

locret_4A5F8:
                rts
; ---------------------------------------------------------------------------

locret_4A5FA:
                rts
