; Owner: objects/zones/aiz/s3
; Responsibility: Angel Island opening plane scene, coordinated character motion and transition control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZPlaneIntro:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZPlaneIntro_Index(pc,d0.w),d1
                jsr     AIZPlaneIntro_Index(pc,d1.w)
                jsr     (Sonic_Load_PLC).l
                bsr.w   AdvanceAizPlaneIntroScrollOrPlayer
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
AIZPlaneIntro_Index:
                dc.w    S3PlaneIntro_InitSonicStandIn-AIZPlaneIntro_Index
                dc.w    S3PlaneIntro_WaitForFlightStart-AIZPlaneIntro_Index
                dc.w    S3PlaneIntro_BrakeDescent-AIZPlaneIntro_Index
                dc.w    S3PlaneIntro_HoverUntilJump-AIZPlaneIntro_Index
                dc.w    S3PlaneIntro_StepJumpAndCheckLanding-AIZPlaneIntro_Index
                dc.w    S3PlaneIntro_BrakeUntilLeftMark-AIZPlaneIntro_Index
                dc.w    S3PlaneIntro_WaitForSuperFlight-AIZPlaneIntro_Index
                dc.w    S3PlaneIntro_FlySuperRight-AIZPlaneIntro_Index
                dc.w    S3PlaneIntro_WaitFirstFlightPause-AIZPlaneIntro_Index
                dc.w    S3PlaneIntro_FlySuperLeft-AIZPlaneIntro_Index
                dc.w    S3PlaneIntro_WaitSecondFlightPause-AIZPlaneIntro_Index
                dc.w    S3PlaneIntro_WaitForKnuxSpawnX-AIZPlaneIntro_Index
                dc.w    S3PlaneIntro_WaitForStandInRaiseX-AIZPlaneIntro_Index
                dc.w    S3PlaneIntro_WaitForPlayerReleaseX-AIZPlaneIntro_Index
; ---------------------------------------------------------------------------

S3PlaneIntro_InitSonicStandIn:
                addq.b  #2,routine(a0)
                move.l  #Map_Sonic,mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #$BA,mapping_frame(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  #$60,x_pos(a0)
                move.w  #$30,y_pos(a0)
                move.w  #$40,$2E(a0)
                move.l  #S3PlaneIntro_StartDescentAndTryPlane,$34(a0)
                move.w  #8,$40(a0)
                move.w  #$E918,(Events_fg_1).w
                move.b  #-1,(Player_prev_frame).w
                lea     (Player_1).w,a1
                move.b  #0,mapping_frame(a1)
                move.b  #$53,object_control(a1)

S3PlaneIntro_StateReturn:
                rts
; ---------------------------------------------------------------------------

S3PlaneIntro_WaitForFlightStart:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

S3PlaneIntro_StartDescentAndTryPlane:
                move.b  #4,routine(a0)
                move.w  #$300,x_vel(a0)
                move.w  #$600,y_vel(a0)
                lea     S3PlaneIntro_PlaneChildRecord(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

; Enter the hover state when vertical velocity reaches exactly zero
S3PlaneIntro_BrakeDescent:
                subi.w  #$18,y_vel(a0)
                beq.s   S3PlaneIntro_StartHover
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

S3PlaneIntro_StartHover:
                move.b  #6,routine(a0)
                clr.w   x_vel(a0)
                move.w  #$5F,$2E(a0)
                move.l  #S3PlaneIntro_StartPlaneJump,$34(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

S3PlaneIntro_HoverUntilJump:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

S3PlaneIntro_StartPlaneJump:
                move.b  #8,routine(a0)
                move.w  #$400,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                move.l  #S3PlaneIntro_CountedJumpFrames,$30(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

S3PlaneIntro_StepJumpAndCheckLanding:
                subi.w  #$40,x_vel(a0)
                jsr     (MoveSprite).l
                cmpi.w  #$130,y_pos(a0)
                bhs.s   S3PlaneIntro_LandAndStartBraking
                jmp     (S3PlaneIntro_TickCountedFrames).l
; ---------------------------------------------------------------------------

S3PlaneIntro_LandAndStartBraking:
                move.b  #$A,routine(a0)
                move.w  #$130,y_pos(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3PlaneIntro_BrakeUntilLeftMark:
                subi.w  #$40,x_vel(a0)
                jsr     (MoveSprite2).l
                cmpi.w  #$40,x_pos(a0)
                blo.s   S3PlaneIntro_StopAndPrepareSuper
                rts
; ---------------------------------------------------------------------------

S3PlaneIntro_StopAndPrepareSuper:
                move.b  #$C,routine(a0)
                move.w  #$40,x_pos(a0)
                move.w  #5,$2E(a0)
                move.l  #S3PlaneIntro_TrySpawnWake,$34(a0)
                move.w  #$3F,$3A(a0)
                bra.w   S3PlaneIntro_InitSuperAppearance
; ---------------------------------------------------------------------------

S3PlaneIntro_TrySpawnWake:
                move.w  #5,$2E(a0)
                cmpi.w  #$80,x_pos(a0)
                blo.w   S3PlaneIntro_StateReturn
                lea     S3PlaneIntro_WakeChildRecord(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

S3PlaneIntro_WaitForSuperFlight:
                subq.w  #1,$3A(a0)
                bpl.w   S3PlaneIntro_StateReturn
                move.b  #$E,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3PlaneIntro_FlySuperRight:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                jsr     (Obj_Wait).l
                move.w  x_pos(a0),d0
                addq.w  #4,d0
                move.w  d0,x_pos(a0)
                cmpi.w  #$200,d0
                bhs.s   S3PlaneIntro_BeginFirstFlightPause
                rts
; ---------------------------------------------------------------------------

S3PlaneIntro_BeginFirstFlightPause:
                move.b  #$10,routine(a0)
                move.w  #$1F,$3A(a0)
                rts
; ---------------------------------------------------------------------------

S3PlaneIntro_WaitFirstFlightPause:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                jsr     (Obj_Wait).l
                subq.w  #1,$3A(a0)
                bpl.w   S3PlaneIntro_StateReturn
                move.b  #$12,routine(a0)
                bset    #2,$38(a0)
                move.w  #$C,$40(a0)
                rts
; ---------------------------------------------------------------------------

S3PlaneIntro_FlySuperLeft:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                jsr     (Obj_Wait).l
                move.w  x_pos(a0),d0
                subi.w  #4,d0
                move.w  d0,x_pos(a0)
                cmpi.w  #$120,d0
                bls.s   S3PlaneIntro_BeginSecondPauseAndScroll
                rts
; ---------------------------------------------------------------------------

S3PlaneIntro_BeginSecondPauseAndScroll:
                move.b  #$14,routine(a0)
                bset    #2,$38(a0)
                move.w  #$1F,$3A(a0)
                move.w  #$10,$40(a0)
                rts
; ---------------------------------------------------------------------------

S3PlaneIntro_WaitSecondFlightPause:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                jsr     (Obj_Wait).l
                subq.w  #1,$3A(a0)
                bpl.w   S3PlaneIntro_StateReturn
                move.b  #$16,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3PlaneIntro_WaitForKnuxSpawnX:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                cmpi.w  #$918,(Player_1+x_pos).w
                bhs.s   S3PlaneIntro_AdvanceAndTrySpawnKnux
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

S3PlaneIntro_AdvanceAndTrySpawnKnux:
                move.b  #$18,routine(a0)
                lea     S3PlaneIntro_KnuxChildRecord(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

S3PlaneIntro_WaitForStandInRaiseX:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                cmpi.w  #$1240,(Player_1+x_pos).w
                bhs.s   S3PlaneIntro_RaiseStandIn
                rts
; ---------------------------------------------------------------------------

S3PlaneIntro_RaiseStandIn:
                move.b  #$1A,routine(a0)
                subi.w  #$20,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3PlaneIntro_WaitForPlayerReleaseX:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                cmpi.w  #$13D0,(Player_1+x_pos).w
                bhs.s   S3PlaneIntro_ReleasePlayerAndRestorePal
                rts
; ---------------------------------------------------------------------------

S3PlaneIntro_ReleasePlayerAndRestorePal:
                st      (Palette_cycle_counters+$00).w
                lea     (Player_1).w,a1
                move.b  #4,routine(a1)
                bset    #Status_InAir,status(a1)
                move.w  #-$400,y_vel(a1)
                move.w  #-$200,x_vel(a1)
                move.w  #0,ground_vel(a1)
                move.b  #$1A,anim(a1)
                clr.b   object_control(a1)
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                clr.b   (Super_Sonic_Knux_flag).w
                move.b  #2,(Super_palette_status).w
                move.w  #$1E,(Palette_frame).w
                lea     Pal_AIZIntroEmeralds(pc),a1
                lea     (Normal_palette_line_4).w,a2
                moveq   #bytesToLcnt($20),d0

S3PlaneIntro_CopyPaletteAndSpawnEmeralds:
                move.l  (a1)+,(a2)+
                dbf     d0,S3PlaneIntro_CopyPaletteAndSpawnEmeralds
                lea     S3PlaneIntro_EmeraldChildRecord(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

S3PlaneIntro_InitPlaneAndAttachments:
                move.l  #S3PlaneIntro_HoverPlaneAndCheckExit,(a0)
                move.l  #Map_AIZIntroPlane,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZIntroPlane,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #$40,width_pixels(a0)
; Bug: This is missing the height, and it overwrites what the previous line did
                move.b  #$20,width_pixels(a0)
                jsr     Swing_Setup1(pc)
                lea     (ArtKosM_AIZIntroPlane).l,a1
                move.w  #tiles_to_bytes(ArtTile_AIZIntroPlane),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_AIZIntroEmeralds).l,a1
                move.w  #tiles_to_bytes(ArtTile_AIZIntroEmeralds),d2
                jsr     (Queue_Kos_Module).l
                lea     S3PlaneIntro_PlaneAttachmentRecords(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

S3PlaneIntro_HoverPlaneAndCheckExit:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   S3PlaneIntro_FollowBeforeJump
                move.l  #S3PlaneIntro_FlyPlaneOffLeft,(a0)

S3PlaneIntro_FollowBeforeJump:
                btst    #3,$38(a1)
                bne.s   S3PlaneIntro_DrawHoveringPlane
                jsr     (Refresh_ChildPosition).l

S3PlaneIntro_DrawHoveringPlane:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3PlaneIntro_FlyPlaneOffLeft:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                subq.w  #4,x_pos(a0)
                cmpi.w  #$20,x_pos(a0)
                blo.s   S3PlaneIntro_DeletePlaneAtExit
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3PlaneIntro_DeletePlaneAtExit:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

S3PlaneIntro_InitPlaneAttachmentA:
                move.l  #Map_AIZIntroPlane,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZIntroPlane,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #4,width_pixels(a0)
; Bug: This is missing the height, and it overwrites what the previous line did
                move.b  #$C,width_pixels(a0)
                move.l  #S3PlaneIntro_DrawPlaneAttachmentA,(a0)

S3PlaneIntro_DrawPlaneAttachmentA:
                lea     (S3PlaneIntro_PlaneAttachmentAAnim).l,a1
                jsr     (Animate_RawNoSST).l
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

S3PlaneIntro_InitPlaneAttachmentB:
                move.l  #Map_AIZIntroPlane,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZIntroPlane,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #4,width_pixels(a0)
; Bug: This is missing the height, and it overwrites what the previous line did
                move.b  #$C,width_pixels(a0)
                move.l  #S3PlaneIntro_DrawPlaneAttachmentB,(a0)

S3PlaneIntro_DrawPlaneAttachmentB:
                lea     (S3PlaneIntro_PlaneAttachmentBAnim).l,a1
                jsr     (Animate_RawNoSST).l
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

S3PlaneIntro_InitMirroredWake:
                move.l  #S3PlaneIntro_MoveAndAnimateWake,(a0)
                move.l  #Map_AIZIntroWaves,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZIntroSprites,0,0),art_tile(a0)
                move.w  #$100,priority(a0)
                move.b  #$10,width_pixels(a0)
                bset    #0,render_flags(a0)
                movea.w parent3(a0),a1
                move.l  #S3PlaneIntro_WakeAnim,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

S3PlaneIntro_MoveAndAnimateWake:
                cmpi.w  #$60,x_pos(a0)
                blo.s   S3PlaneIntro_DeleteWakeAtLeftMark
                movea.w parent3(a0),a1
                move.w  $40(a1),d0
                sub.w   d0,x_pos(a0)
                jsr     (Animate_RawMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3PlaneIntro_DeleteWakeAtLeftMark:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3PlaneIntro_InitScatteredEmerald:
                lea     S3PlaneIntro_EmeraldAttrs(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                move.b  d0,mapping_frame(a0)
                move.l  #S3PlaneIntro_MoveAndLandEmerald,(a0)
                move.b  #4,y_radius(a0)
                lea     (Player_1).w,a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                moveq   #$40,d0
                jsr     (Set_IndexedVelocity).l

; Check the pre-gravity vertical displacement before probing the floor
S3PlaneIntro_MoveAndLandEmerald:
                jsr     (MoveSprite).l
                tst.l   d0
                bmi.s   S3PlaneIntro_DrawMovingEmerald
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   S3PlaneIntro_DrawMovingEmerald
                add.w   d1,y_pos(a0)
                move.l  #S3PlaneIntro_WaitForKnuxPickup,(a0)

S3PlaneIntro_DrawMovingEmerald:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3PlaneIntro_WaitForKnuxPickup:
                movea.w (SceneControllerObjectAddress).w,a1
                move.w  x_pos(a0),d0
                move.w  x_pos(a1),d1
                subq.w  #8,d0
                cmp.w   d0,d1
                blo.s   S3PlaneIntro_DrawWaitingEmerald
                addi.w  #2*8,d0
                cmp.w   d0,d1
                blo.s   S3PlaneIntro_ReadKnuxPickupVelocity

S3PlaneIntro_DrawWaitingEmerald:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3PlaneIntro_ReadKnuxPickupVelocity:
                move.w  x_vel(a1),d0
                btst    #1,subtype(a0)
                beq.s   S3PlaneIntro_TryDeleteCollectedEmerald
                neg.w   d0

S3PlaneIntro_TryDeleteCollectedEmerald:
                tst.w   d0
                bmi.w   S3PlaneIntro_StateReturn
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3PlaneIntro_InitSuperAppearance:
                move.l  #Map_SuperSonic,mappings(a0)
                move.b  #$21,mapping_frame(a0)
                move.b  #0,(Palette_timer).w
                move.w  #$24,(Palette_frame).w
                move.w  #$7FFF,(Super_frame_count).w
                rts

; =============== S U B R O U T I N E =======================================

AnimateAizPlaneIntroSuperAppearance:
                move.b  #1,(Super_Sonic_Knux_flag).w
                move.b  #$21,mapping_frame(a0)
                btst    #1,(V_int_run_count+3).w
                beq.s   S3PlaneIntro_TickSuperPalette
                move.b  #$22,mapping_frame(a0)

S3PlaneIntro_TickSuperPalette:
                subq.b  #1,(Palette_timer).w
                bpl.s   S3PlaneIntro_SuperPaletteReturn
                move.b  #6,(Palette_timer).w
                lea     (PalCycle_SuperSonic).l,a1
                move.w  (Palette_frame).w,d0
                addq.w  #6,(Palette_frame).w
                cmpi.w  #$36,(Palette_frame).w
; This condition causes the last frame to be skipped
                blo.s   S3PlaneIntro_CopySuperColors
                move.w  #$24,(Palette_frame).w

S3PlaneIntro_CopySuperColors:
                lea     (Normal_palette+$4).w,a2
                move.l  (a1,d0.w),(a2)+
                move.w  4(a1,d0.w),(a2)

S3PlaneIntro_SuperPaletteReturn:
                rts
; End of function AnimateAizPlaneIntroSuperAppearance

; =============== S U B R O U T I N E =======================================

AdvanceAizPlaneIntroScrollOrPlayer:
                move.w  $40(a0),d1
                move.w  (Events_fg_1).w,d0
                bpl.s   S3PlaneIntro_AdvancePlayerForScroll
                add.w   d1,d0
                move.w  d0,(Events_fg_1).w
                rts
; ---------------------------------------------------------------------------

S3PlaneIntro_AdvancePlayerForScroll:
                add.w   d1,(Player_1+x_pos).w
                rts
; End of function AdvanceAizPlaneIntroScrollOrPlayer

; ---------------------------------------------------------------------------

S3PlaneIntro_TickCountedFrames:
                movea.l $30(a0),a1
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3PlaneIntro_CountedFrameReturn
                move.b  (a1),anim_frame_timer(a0)
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                cmp.b   1(a1),d0
                blo.s   S3PlaneIntro_StoreCountedFrame
                moveq   #0,d0

S3PlaneIntro_StoreCountedFrame:
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  2(a1,d0.w),d1
                move.b  d1,mapping_frame(a0)

S3PlaneIntro_CountedFrameReturn:
                rts
; ---------------------------------------------------------------------------
S3PlaneIntro_EmeraldAttrs:
                dc.l    Map_AIZIntroEmeralds
                dc.w    make_art_tile(ArtTile_AIZIntroEmeralds,3,0)
                dc.w    $280
                dc.b    4,   4,   1,   0
S3PlaneIntro_PlaneChildRecord:
                dc.w    1-1
                dc.l    S3PlaneIntro_InitPlaneAndAttachments
                dc.b    -$22, $2C
S3PlaneIntro_PlaneAttachmentRecords:
                dc.w    2-1
                dc.l    S3PlaneIntro_InitPlaneAttachmentA
                dc.b    $38,   4
                dc.l    S3PlaneIntro_InitPlaneAttachmentB
                dc.b    $18, $18
S3PlaneIntro_WakeChildRecord:
                dc.w    1-1
                dc.l    S3PlaneIntro_InitMirroredWake
                dc.b    0, $18
S3PlaneIntro_KnuxChildRecord:
                dc.w    1-1
                dc.l    Obj_CutsceneKnuckles
S3PlaneIntro_EmeraldChildRecord:
                dc.w    7-1
                dc.l    S3PlaneIntro_InitScatteredEmerald
; The count covers eight frames. The trailing raw restart byte is outside the count
S3PlaneIntro_CountedJumpFrames:
                dc.b    3,   8
                dc.b    $97, $96
                dc.b    $98, $96
                dc.b    $99, $96
                dc.b    $9A, $96
                dc.b    $FC
S3PlaneIntro_PlaneAttachmentAAnim:
                dc.b    0,   1,   2,   3,   4,   3,   2, $FC
S3PlaneIntro_PlaneAttachmentBAnim:
                dc.b    0,   5,   6, $FC
S3PlaneIntro_WakeAnim:
                dc.b    0,   1
                dc.b    0,   0
                dc.b    1,   1
                dc.b    2,   2
                dc.b    3,   2
                dc.b    4,   1
                dc.b    5,   1
                dc.b    $F4
                even
Pal_AIZIntroEmeralds:
                binclude "data/Levels/AIZ/Palettes/Intro Emeralds.bin"
                even
