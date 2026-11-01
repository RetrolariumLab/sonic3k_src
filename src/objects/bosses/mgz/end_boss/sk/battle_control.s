; Owner: objects/bosses/mgz/end_boss/sk
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
                dc.w    loc_6C354-MGZEndBoss_Index
                dc.w    loc_6C3E6-MGZEndBoss_Index
                dc.w    loc_6C416-MGZEndBoss_Index
                dc.w    loc_6C43A-MGZEndBoss_Index
                dc.w    loc_6C45A-MGZEndBoss_Index
                dc.w    loc_6C3E6-MGZEndBoss_Index
                dc.w    loc_6C4B2-MGZEndBoss_Index
                dc.w    loc_6C4F2-MGZEndBoss_Index
                dc.w    loc_6C514-MGZEndBoss_Index
                dc.w    loc_6C3E6-MGZEndBoss_Index
                dc.w    loc_6C546-MGZEndBoss_Index
                dc.w    loc_6C3E6-MGZEndBoss_Index
                dc.w    loc_6C514-MGZEndBoss_Index
                dc.w    loc_6C5C4-MGZEndBoss_Index
                dc.w    loc_6C5FE-MGZEndBoss_Index
                dc.w    loc_6C4F2-MGZEndBoss_Index
                dc.w    loc_6C514-MGZEndBoss_Index
; ---------------------------------------------------------------------------

loc_6C354:
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
                move.l  #loc_6C3EC,$34(a0)
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
                bne.s   loc_6C3DC
                move.b  #9,subtype(a1)

loc_6C3DC:
                lea     ChildObjDat_6D7C0(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6C3E6:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6C3EC:
                move.b  #4,routine(a0)
                moveq   #signextendB(mus_EndBoss),d0
                jsr     (Play_Music).l
                move.b  #mus_EndBoss,(Current_music+1).w
                move.w  #$80,y_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #loc_6C422,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C416:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6C422:
                move.b  #6,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_6C44C,$34(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

loc_6C43A:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6C44C:
                move.b  #8,routine(a0)
                move.w  #3,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C45A:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   locret_6C47E
                move.w  #3,$2E(a0)
                subq.w  #2,angle(a0)
                cmpi.w  #4,angle(a0)
                bls.s   loc_6C480

locret_6C47E:
                rts
; ---------------------------------------------------------------------------

loc_6C480:
                move.b  #$A,routine(a0)
                bset    #3,$38(a0)
                move.w  #$5F,$2E(a0)
                move.l  #loc_6C49C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C49C:
                move.b  #$C,routine(a0)
                move.w  #$400,y_vel(a0)
                move.l  #loc_6C4BE,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C4B2:
                jsr     (MoveSprite2).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

loc_6C4BE:
                move.b  #$E,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_6C4F8,$34(a0)
                st      (Events_fg_4).w
                st      (Disable_death_plane).w
                moveq   #signextendB(sfx_BossHitFloor),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   locret_6C4F0
                move.l  #Obj_MGZ2_BossTransition,(a1)

locret_6C4F0:
                rts
; ---------------------------------------------------------------------------

loc_6C4F2:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6C4F8:
                move.b  #$10,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$17,$2E(a0)
                move.l  #loc_6C51A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C514:
                jmp     (Move_WaitNoFall).l
; ---------------------------------------------------------------------------

loc_6C51A:
                move.b  #$12,routine(a0)
                bclr    #3,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_6C538,$34(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

loc_6C538:
                move.b  #$14,routine(a0)
                move.w  #3,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C546:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   locret_6C564
                move.w  #3,$2E(a0)
                subq.w  #2,angle(a0)
                beq.s   loc_6C566

locret_6C564:
                rts
; ---------------------------------------------------------------------------

loc_6C566:
                move.b  #$16,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_6C57C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C57C:
                move.b  #$18,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_6C598,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C598:
                move.b  #$1A,routine(a0)
                clr.b   $46(a0)
                bset    #0,render_flags(a0)
                move.w  #$3E80,x_pos(a0)
                move.w  #$700,y_pos(a0)
                move.w  #-$80,x_vel(a0)
                move.b  #6,$3A(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

loc_6C5C4:
                jsr     (MoveSprite2).l
                btst    #6,status(a0)
                bne.s   loc_6C5E8
                move.w  (Player_1+x_pos).w,d0
                cmp.w   x_pos(a0),d0
                bhs.s   loc_6C5E8
                jsr     (Swing_UpAndDown).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_6C5E8:
                move.b  #$1C,routine(a0)
                move.w  #$200,x_vel(a0)
                move.l  #loc_6C614,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C5FE:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                cmpi.w  #$3E00,x_pos(a0)
                blo.w   locret_6BF96

loc_6C614:
                move.b  #$1E,routine(a0)
                moveq   #signextendB(sfx_BossZoom),d0
                jsr     (Play_SFX).l
                bclr    #3,$38(a0)
                bclr    #2,$38(a0)
                move.w  #$9F,$2E(a0)
                move.l  #loc_6C646,$34(a0)
                lea     ChildObjDat_6D836(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6C646:
                move.w  #$1F,$2E(a0)
                move.l  #loc_6C658,$34(a0)
                bra.w   loc_6D710
; ---------------------------------------------------------------------------

loc_6C658:
                bset    #3,$38(a0)
                move.w  #$9F,$2E(a0)
                move.l  #loc_6C66C,$34(a0)

loc_6C66C:
                move.b  #$20,routine(a0)
                move.w  #$FF,$2E(a0)
                move.l  #loc_6C614,$34(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------
word_6C688:
                dc.w    0,  $128, $3C78, $3E78
                dc.w    $28,   $28, $3D78, $3D78
; ---------------------------------------------------------------------------

Obj_MGZEndBossKnux:
                lea     word_6C688(pc),a1
                jsr     (Check_CameraInRange).l
                move.b  #mus_Miniboss,boss_saved_mus(a0)  ; different song than other end bosses
                jsr     (BeginBossCameraTransitionSaveBoundsAndFadeMusic).l
                move.l  #loc_6C6F4,(a0)
                move.l  #loc_6C6FA,$34(a0)
                lea     (ArtKosM_MGZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_MGZEndBoss),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_MGZEndBossDebris).l,a1
                move.w  #tiles_to_bytes(ArtTile_MGZEndBossDebris),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_6D,d0
                jsr     (Load_PLC).l
                cmpi.b  #2,(Player_1+character_id).w
                lea     Pal_MGZEndBoss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_6C6F4:
                jmp     (loc_85CA4).l
; ---------------------------------------------------------------------------

loc_6C6FA:
                move.l  #loc_6C702,(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C702:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MGZEndBossKnux_Index(pc,d0.w),d1
                jsr     MGZEndBossKnux_Index(pc,d1.w)
                bsr.w   loc_6D61E
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
MGZEndBossKnux_Index:
                dc.w    loc_6C72A-MGZEndBossKnux_Index
                dc.w    loc_6C782-MGZEndBossKnux_Index
                dc.w    loc_6C796-MGZEndBossKnux_Index
                dc.w    loc_6C814-MGZEndBossKnux_Index
                dc.w    loc_6C7D8-MGZEndBossKnux_Index
                dc.w    loc_6C814-MGZEndBossKnux_Index
                dc.w    loc_6C83C-MGZEndBossKnux_Index
                dc.w    loc_6C88A-MGZEndBossKnux_Index
; ---------------------------------------------------------------------------

loc_6C72A:
                lea     ObjDat_MGZDrillBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                st      $46(a0)
                move.b  #8,collision_property(a0)
                move.b  #$1C,y_radius(a0)
                move.w  #$C,angle(a0)
                move.b  #2,subtype(a0)
                bset    #3,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_6C788,$34(a0)
                lea     (Child1_MakeRoboShip3).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   loc_6C778
                move.b  #9,subtype(a1)

loc_6C778:
                lea     ChildObjDat_6D7C0(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6C782:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6C788:
                move.b  #4,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C796:
                btst    #2,$38(a0)
                bne.s   loc_6C7A0
                rts
; ---------------------------------------------------------------------------

loc_6C7A0:
                move.b  #6,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_6C7BC,$34(a0)
                move.b  #0,subtype(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C7BC:
                move.b  #8,routine(a0)
                move.w  #$87,$2E(a0)
                move.l  #loc_6C7FE,$34(a0)
                lea     (_unkFA82).w,a1
                bra.w   loc_6D51A
; ---------------------------------------------------------------------------

loc_6C7D8:
                cmpi.w  #$28,$2E(a0)
                bne.s   loc_6C7F2
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_6D83E(pc),a2
                jsr     (CreateChild6_Simple).l

loc_6C7F2:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6C7FE:
                move.b  #$A,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_6C81A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C814:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6C81A:
                move.b  #$C,routine(a0)
                move.w  #$9F,$2E(a0)
                move.l  #loc_6C862,$34(a0)
                move.b  #2,subtype(a0)
                lea     (_unkFA8A).w,a1
                bra.w   loc_6D51A
; ---------------------------------------------------------------------------

loc_6C83C:
                cmpi.w  #$48,$2E(a0)
                bne.s   loc_6C856
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_6D83E(pc),a2
                jsr     (CreateChild6_Simple).l

loc_6C856:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6C862:
                move.b  #$E,routine(a0)
                move.w  #$3E18,x_pos(a0)
                move.w  #-$58,y_pos(a0)
                move.w  #(2*60)-1,$2E(a0)
                move.l  #loc_6C788,$34(a0)
                bclr    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C88A:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6C890:
                move.l  #Obj_Wait,(a0)
                move.w  #$200,priority(a0)
                move.l  #loc_6C8B4,$34(a0)
                bset    #4,$38(a0)
                lea     ChildObjDat_6D822(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6C8B4:
                move.l  #loc_6C8F4,(a0)
                st      (_unkFAA8).w
                clr.b   (Boss_flag).w
                jsr     (AllocateObject).l
                bne.s   loc_6C8DC
                move.l  #Obj_EggCapsule,(a1)
                move.w  #$3F40,x_pos(a1)
                move.w  #$B0,y_pos(a1)

loc_6C8DC:
                move.w  (_unkFAB4).w,d0
                addi.w  #$118,d0
                move.w  d0,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_6C8F4:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                tst.b   (_unkFAA8).w
                bne.w   locret_6BF96
                move.l  #loc_6C932,(a0)
                clr.b   (_unkFAA8).w
                jsr     (Restore_PlayerControl).l
                jsr     (Restore_LevelMusic).l
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                clr.w   $2E(a0)
                move.b  #1,(Scroll_lock).w
                addi.w  #$30,(Camera_max_X_pos).w
                rts
; ---------------------------------------------------------------------------

loc_6C932:
                move.w  (Camera_X_pos).w,d0
                addi.w  #$150,d0
                cmp.w   (Player_1+x_pos).w,d0
                bls.w   loc_6D13C
                jmp     (loc_86334).l
