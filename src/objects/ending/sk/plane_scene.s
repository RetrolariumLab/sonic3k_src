; Owner: objects/ending/sk
; Responsibility: Ending player poses, rescued animals, plane sequence and final camera or palette transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Ending:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5E1AE(pc,d0.w),d1
                jsr     off_5E1AE(pc,d1.w)
                subq.w  #2,(_unkEE98).w
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                rts
; ---------------------------------------------------------------------------
off_5E1AE:
                dc.w    loc_5E1C2-off_5E1AE
                dc.w    loc_5E288-off_5E1AE
                dc.w    loc_5E2C2-off_5E1AE
                dc.w    loc_5E334-off_5E1AE
                dc.w    loc_5E3EE-off_5E1AE
                dc.w    loc_5E412-off_5E1AE
                dc.w    loc_5E45A-off_5E1AE
                dc.w    loc_5E474-off_5E1AE
                dc.w    loc_5E4B6-off_5E1AE
                dc.w    loc_5E4E2-off_5E1AE
; ---------------------------------------------------------------------------

loc_5E1C2:
                move.b  #2,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #$C0,x_pos(a0)
                move.w  #$E0,y_pos(a0)
                jsr     (Swing_Setup1).l
                cmpi.b  #2,(_unkFA88).w
                beq.s   loc_5E1F0
                moveq   #signextendB(mus_CreditsK),d0
                jsr     (Play_Music).l

loc_5E1F0:
                lea     (Player_1).w,a1
                bset    #0,render_flags(a1)
                bset    #0,status(a1)
                bclr    #7,art_tile(a1)
                move.b  #$83,$2E(a1)
                move.b  #5,anim(a1)
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_5E228
                lea     (Tails_tails).w,a2
                move.l  #Obj_Tails_Tail,(a2)
                move.w  a1,$30(a2)

loc_5E228:
                bsr.w   Ending_SetP1PoseAndLoadArt
                lea     ChildObjDat_601BA(pc),a2
                jsr     (CreateChild1_Normal).l
                bne.s   loc_5E23E
                bset    #2,$38(a1)

loc_5E23E:
                tst.b   (_unkFA88).w
                bmi.s   loc_5E258
                lea     ChildObjDat_60214(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     ChildObjDat_6021A(pc),a2
                jsr     (CreateChild6_Simple).l

loc_5E258:
                lea     (ArtKosM_SonicPlane).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_Plane),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_SonicPlaneEnding).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_PlaneExtra),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_EndingAnimals).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_Animals),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

loc_5E288:
                bclr    #2,(Tails_tails+render_flags).w
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                tst.b   (_unkFACC).w
                beq.w   locret_5FF1A
                move.b  #4,routine(a0)
                move.w  #$1F,$2E(a0)
                lea     (Player_1).w,a1
                move.b  #$58,mapping_frame(a1)
                clr.b   anim(a1)
                jmp     (Player_Load_PLC).l
; ---------------------------------------------------------------------------

loc_5E2C2:
                subq.w  #1,$2E(a0)
                bpl.w   locret_5FF1A
                move.b  #6,routine(a0)
                bset    #2,$38(a0)
                move.w  #$300,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                lea     (Player_1).w,a1
                bclr    #0,render_flags(a1)
                bclr    #0,status(a1)
                move.b  #$81,$2E(a1)
                move.w  #$200,anim(a1)
                clr.l   (Tails_tails).w
                moveq   #0,d0
                cmpi.w  #2,(Player_mode).w
                beq.s   loc_5E316
                moveq   #4,d0
                tst.b   (_unkFA88).w
                bmi.s   loc_5E316
                moveq   #8,d0

loc_5E316:
                move.w  d0,(Camera_stored_max_X_pos).w
                movea.l off_5E328(pc,d0.w),a1
                move.w  #tiles_to_bytes(ArtTile_Ending_SonicTailsEndPose),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------
off_5E328:
                dc.l    ArtKosM_TailsEndPose
                dc.l    ArtKosM_SonicEndPose
                dc.l    ArtKosM_SuperSonicEndPose
; ---------------------------------------------------------------------------

loc_5E334:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   locret_5FF1A
                cmpi.w  #$E0,y_pos(a0)
                blo.w   locret_5FF1A
                move.l  #Map_SonicTailsEndPoses,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_SonicTailsEndPose,2,0),art_tile(a0)
                move.w  #$100,priority(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #$80,height_pixels(a0)
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_5E37A
                move.b  #3,mapping_frame(a0)

loc_5E37A:
                move.w  (Camera_stored_max_X_pos).w,d0
                movea.l off_5E3B4(pc,d0.w),a1
                lea     (Normal_palette_line_3).w,a2
                moveq   #bytesToLcnt($20),d0

loc_5E388:
                move.l  (a1)+,(a2)+
                dbf     d0,loc_5E388
                tst.b   (_unkFA88).w
                bmi.s   loc_5E3C0
                bne.s   loc_5E39E
                cmpi.w  #2,(Player_mode).w
                bhs.s   loc_5E3C0

loc_5E39E:
                move.b  #$A,routine(a0)
                move.b  #1,(Update_HUD_timer).w
                clr.w   (Palette_frame).w
                jmp     (Ending_Give_SuperSonic).l
; ---------------------------------------------------------------------------
off_5E3B4:
                dc.l    Pal_TailsEndPose
                dc.l    Pal_SonicEndPose
                dc.l    Pal_SuperSonicEndPose
; ---------------------------------------------------------------------------

loc_5E3C0:
                move.b  #8,routine(a0)
                move.w  #5,$2E(a0)
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_5E3DA
                bset    #0,render_flags(a0)

loc_5E3DA:
                lea     (Player_1).w,a1
                move.b  #$83,$2E(a1)
                clr.b   mapping_frame(a1)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5E3EE:
                subq.w  #1,$2E(a0)
                bpl.s   loc_5E40C
                move.b  #$12,routine(a0)
                addq.b  #1,mapping_frame(a0)
                jsr     (AllocateObject).l
                bne.s   loc_5E40C
                move.l  #Obj_5EF68,(a1)

loc_5E40C:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5E412:
                lea     (Player_1).w,a1
                tst.b   $2E(a1)
                bne.s   locret_5E440
                cmpi.w  #2,(Player_mode).w
                beq.s   loc_5E442
                move.b  #$C,routine(a0)
                move.b  #$81,$2E(a1)
                clr.b   anim(a1)
                move.w  #$800,x_vel(a1)
                move.w  #$800,ground_vel(a1)

locret_5E440:
                rts
; ---------------------------------------------------------------------------

loc_5E442:
                jsr     (AllocateObject).l
                bne.s   loc_5E450
                move.l  #loc_5FCDC,(a1)

loc_5E450:
                bset    #0,render_flags(a0)
                bra.w   loc_5E3C0
; ---------------------------------------------------------------------------

loc_5E45A:
                addq.w  #4,x_pos(a0)
                cmpi.w  #$200,x_pos(a0)
                blo.s   locret_5E472
                move.b  #$E,routine(a0)
                move.w  #$1F,$2E(a0)

locret_5E472:
                rts
; ---------------------------------------------------------------------------

loc_5E474:
                subq.w  #1,$2E(a0)
                bpl.s   locret_5E4B4
                move.b  #$10,routine(a0)
                move.b  #2,mapping_frame(a0)
                bclr    #0,render_flags(a0)
                lea     (Player_1).w,a1
                move.b  #$83,$2E(a1)
                clr.b   mapping_frame(a1)
                jsr     (AllocateObject).l
                bne.s   locret_5E4B4
                move.l  #loc_5FCFC,(a1)
                tst.b   (_unkFA88).w
                beq.s   locret_5E4B4
                move.b  #2,subtype(a1)

locret_5E4B4:
                rts
; ---------------------------------------------------------------------------

loc_5E4B6:
                subq.w  #8,x_pos(a0)
                cmpi.w  #$160,x_pos(a0)
                bhi.s   loc_5E4DC
                move.b  #$12,routine(a0)
                move.w  #$160,x_pos(a0)
                jsr     (AllocateObject).l
                bne.s   loc_5E4DC
                move.l  #Obj_5EF68,(a1)

loc_5E4DC:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5E4E2:
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_5E4F0
                move.b  #$7F,(Palette_timer).w

loc_5E4F0:
                btst    #3,(_unkFAB8).w
                bne.s   loc_5E4FE
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5E4FE:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_5E504:
                move.l  #loc_5E568,(a0)
                move.l  #Map_EndingAnimals,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Animals,0,0),art_tile(a0)
                move.w  #$380,priority(a0)
                move.b  #2,mapping_frame(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     word_5E554(pc,d0.w),a1
                move.w  (a1)+,x_pos(a0)
                move.w  (a1)+,y_pos(a0)
                lsl.w   #2,d0
                move.w  d0,$2E(a0)
                move.w  x_pos(a0),$3A(a0)
                bra.w   EndingInitializeGentleVerticalSwing
; ---------------------------------------------------------------------------
word_5E554:
                dc.w    $170,   $B0
                dc.w    $150,   $C0
                dc.w    $190,   $D0
                dc.w    $140,   $E0
                dc.w    $168,   $F0
; ---------------------------------------------------------------------------

loc_5E568:
                btst    #3,(_unkFAB8).w
                bne.w   loc_5EC36
                lea     AniRaw_602A1(pc),a1
                jsr     (Animate_RawNoSST).l
                subq.w  #1,$2E(a0)
                bpl.s   loc_5E58E
                move.l  #loc_5E594,(a0)
                move.w  #-$40,x_vel(a0)

loc_5E58E:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5E594:
                btst    #3,(_unkFAB8).w
                bne.w   loc_5EC36
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                lea     AniRaw_602A1(pc),a1
                jsr     (Animate_RawNoSST).l
                move.w  $3A(a0),d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$30,d0
                blt.s   loc_5E5D4
                move.l  #loc_5E5DA,(a0)
                move.w  #$80,x_vel(a0)
                move.b  #2,mapping_frame(a0)

loc_5E5D4:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5E5DA:
                btst    #3,(_unkFAB8).w
                bne.w   loc_5EC36
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                move.w  $3A(a0),d0
                sub.w   x_pos(a0),d0
                bcc.s   loc_5E60C
                move.l  #loc_5E594,(a0)
                move.w  #-$40,x_vel(a0)
                move.w  $3A(a0),x_pos(a0)

loc_5E60C:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5E612:
                move.l  #loc_5E64A,(a0)
                move.l  #Map_EndingAnimals,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Animals,3,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                addi.w  #$60,d0
                move.w  d0,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_5E64A:
                btst    #3,(_unkFAB8).w
                bne.w   loc_5EC36
                subq.w  #1,$2E(a0)
                bpl.s   locret_5E684
                move.l  #loc_5E686,(a0)
                jsr     (Random_Number).l
                andi.w  #$3F,d0
                addi.w  #$180,d0
                move.w  d0,x_pos(a0)
                move.w  #$180,y_pos(a0)
                move.w  #-$300,x_vel(a0)
                move.w  #-$600,y_vel(a0)

locret_5E684:
                rts
; ---------------------------------------------------------------------------

loc_5E686:
                btst    #3,(_unkFAB8).w
                bne.w   loc_5EC36
                jsr     (MoveSprite).l
                clr.b   mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   loc_5E6BA
                move.b  #1,mapping_frame(a0)
                cmpi.w  #$180,y_pos(a0)
                blo.s   loc_5E6BA
                move.l  #loc_5E64A,(a0)
                move.w  #60-1,$2E(a0)

loc_5E6BA:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5E6C0:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  VInt_TableFC(pc,d0.w),d1
                jsr     VInt_TableFC(pc,d1.w)
                tst.b   (_unkFA88).w
                beq.s   loc_5E6E6
                bmi.s   loc_5E6E6
                lea     (off_7DD5A).l,a1
                lea     (Normal_palette_line_3+$1C).w,a2
                jsr     (Run_PalRotationScript2).l

loc_5E6E6:
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
VInt_TableFC:
                dc.w    loc_5E70E-VInt_TableFC
                dc.w    loc_5E80A-VInt_TableFC
                dc.w    loc_5E832-VInt_TableFC
                dc.w    loc_5E86A-VInt_TableFC
                dc.w    loc_5E890-VInt_TableFC
                dc.w    loc_5E916-VInt_TableFC
                dc.w    loc_5E98A-VInt_TableFC
                dc.w    loc_5E9C2-VInt_TableFC
                dc.w    loc_5E9E2-VInt_TableFC
; ---------------------------------------------------------------------------

loc_5E70E:
                lea     ObjDat3_600C2(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  #(5*60)-1,$2E(a0)
                lea     (Player_1).w,a1
                move.b  #$83,$2E(a1)
                clr.b   mapping_frame(a1)
                st      (Scroll_lock).w
                clr.b   (_unkFAB8).w
                clr.b   (Level_started_flag).w
                clr.w   (Screen_shake_flag).w
                clr.l   (Timer).w
                move.w  (Camera_X_pos).w,d0
                addi.w  #$C0,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$110,d0
                move.w  d0,y_pos(a0)
                lea     ChildObjDat_601BA(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #AniRaw_60236,$30(a0)
                bsr.w   Ending_InitEmeraldOutcome
                tst.b   (_unkFA88).w
                bmi.s   loc_5E7C0
                move.b  #4,mapping_frame(a0)
                move.l  #AniRaw_6023F,$30(a0)
                lea     ChildObjDat_601B2(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     (ArtKosM_EndingMasterEmerald).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_MasterEmerald),d2
                jsr     (Queue_Kos_Module).l
                tst.b   (_unkFA88).w
                beq.s   loc_5E7C0
                move.b  #1,(Update_HUD_timer).w
                move.b  #-1,(Super_palette_status).w
                move.b  #$F,(Palette_timer).w
                move.b  #1,(Super_Sonic_Knux_flag).w
                move.w  #$7FFF,(Super_frame_count).w

loc_5E7C0:
                lea     (Pal_SonicTails).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_5E7CC:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_5E7CC
                move.l  #$EE0088,(Target_palette_line_2+$A).w
                lea     (ArtKosM_KnuxEnding).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_SSZKnuckles),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_SonicPlane).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_Plane),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_SonicPlaneEnding).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_PlaneExtra),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

loc_5E80A:
                moveq   #signextendB(sfx_WindQuiet),d0
                jsr     (Play_SFX_Continuous).l
                jsr     (Animate_RawMultiDelay).l
                subq.w  #1,$2E(a0)
                bpl.s   locret_5E830
                move.b  #4,routine(a0)
                move.w  #-$6C0,y_vel(a0)
                jsr     (Restore_LevelMusic).l

locret_5E830:
                rts
; ---------------------------------------------------------------------------

loc_5E832:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite_LightGravity).l
                tst.w   y_vel(a0)
                bmi.s   locret_5E868
                move.b  #6,routine(a0)
                jsr     (Swing_Setup1).l
                move.w  #(3*60)-1,$2E(a0)
                tst.b   (_unkFA88).w
                bmi.s   locret_5E868
                lea     (AniRaw_60244).l,a1
                jsr     (Set_Raw_Animation).l

locret_5E868:
                rts
; ---------------------------------------------------------------------------

loc_5E86A:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (Animate_RawMultiDelay).l
                subq.w  #1,$2E(a0)
                bpl.s   locret_5E88E
                move.b  #8,routine(a0)
                move.w  #$400,x_vel(a0)

locret_5E88E:
                rts
; ---------------------------------------------------------------------------

loc_5E890:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (Animate_RawMultiDelay).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$200,d0
                cmp.w   x_pos(a0),d0
                bhi.w   locret_5FF1A
                move.b  #$A,routine(a0)
                move.l  #Map_SonicPlaneEnding,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_PlaneExtra,0,1),art_tile(a0)
                move.b  #1,mapping_frame(a0)
                bset    #0,render_flags(a0)
                bset    #7,status(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$50,d0
                move.w  d0,y_pos(a0)
                move.w  #-$200,x_vel(a0)
                bsr.w   EndingInitializeGentleVerticalSwing
                lea     AniRaw_60253(pc),a1
                jsr     (Set_Raw_Animation).l
                lea     ChildObjDat_601D8(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     ChildObjDat_601CA(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     ChildObjDat_601D0(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_5E916:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d3
                addi.w  #$60,d3
                cmp.w   x_pos(a0),d3
                blo.s   loc_5E936
                jsr     (Animate_RawMultiDelay).l

loc_5E936:
                subi.w  #$A0,d3
                cmp.w   x_pos(a0),d3
                blo.w   locret_5FF1A
                move.b  #$C,routine(a0)
                move.w  #make_art_tile(ArtTile_Ending_PlaneExtra,1,0),art_tile(a0)
                move.b  #6,mapping_frame(a0)
                bclr    #0,render_flags(a0)
                bset    #4,$38(a0)
                move.w  (_unkEE9C).w,d0
                addi.w  #$448,d0
                move.w  d0,y_pos(a0)
                move.w  #$100,x_vel(a0)
                clr.w   y_vel(a0)
                lea     ChildObjDat_6022E(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     Pal_EndingSmallPlane(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_5E98A:
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                cmp.w   x_pos(a0),d0
                bhs.s   locret_5E9C0
                move.b  #$E,routine(a0)
                clr.b   mapping_frame(a0)
                st      (Events_fg_4).w
                tst.b   (_unkFA88).w
                bmi.s   locret_5E9C0
                jsr     (AllocateObject).l
                bne.s   locret_5E9C0
                move.l  #EndLine3Flash_InitRaise,(a1)

locret_5E9C0:
                rts
; ---------------------------------------------------------------------------

loc_5E9C2:
                tst.b   (_unkFAA9).w
                beq.s   locret_5E9E0
                move.b  #$10,routine(a0)
                move.b  #$1A,mapping_frame(a0)
                move.w  (_unkEE9C).w,d0
                addi.w  #$448,d0
                move.w  d0,y_pos(a0)

locret_5E9E0:
                rts
; ---------------------------------------------------------------------------

loc_5E9E2:
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bmi.s   locret_5EA18
                move.l  #loc_5EA1A,(a0)
                move.w  #(6*60)-1,$2E(a0)
                move.b  #2,(Super_palette_status).w
                move.w  #$1E,(Palette_frame).w
                move.b  #0,(Super_Sonic_Knux_flag).w
                move.b  #0,(Super_Tails_flag).w
                bset    #1,$38(a0)

locret_5EA18:
                rts
; ---------------------------------------------------------------------------

loc_5EA1A:
                subq.w  #1,$2E(a0)
                bpl.w   locret_5FF1A
                jsr     (AllocateObject).l
                bne.s   loc_5EA30
                move.l  #loc_5F94C,(a1)

loc_5EA30:
                move.b  #$3F,(_unkFAB9).w
                clr.w   (_unkFAC2).w
                move.w  #-$80,(_unkFAC4).w
                tst.b   (_unkFA88).w
                bmi.s   loc_5EA4C
                move.w  #$80,(_unkFAC4).w

loc_5EA4C:
                jmp     (Delete_Current_Sprite).l
