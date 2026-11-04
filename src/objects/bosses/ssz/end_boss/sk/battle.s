; Owner: objects/bosses/ssz/end_boss/sk
; Responsibility: Sky Sanctuary Mecha Sonic battle controller, coordinated attacks, player response and defeat progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SSZEndBoss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SSZEndBoss_Index(pc,d0.w),d1
                jsr     SSZEndBoss_Index(pc,d1.w)
                lea     SSZMecha_BeginScoredDefeatScene(pc),a4
                bsr.w   SSZMecha_HandleHitFlashOrDefeat
                bsr.w   SSZMecha_TrySetCollisionFromFrame
                lea     DPLCPtr_MechaSonic(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
SSZEndBoss_Index:
                dc.w    loc_7B2DC-SSZEndBoss_Index
                dc.w    loc_7B3AC-SSZEndBoss_Index
                dc.w    loc_7B3E6-SSZEndBoss_Index
                dc.w    loc_7B416-SSZEndBoss_Index
                dc.w    loc_7B44A-SSZEndBoss_Index
                dc.w    loc_7B478-SSZEndBoss_Index
                dc.w    loc_7B4DA-SSZEndBoss_Index
                dc.w    loc_7B53E-SSZEndBoss_Index
                dc.w    loc_7B5AC-SSZEndBoss_Index
                dc.w    loc_7B53E-SSZEndBoss_Index
                dc.w    loc_7B53E-SSZEndBoss_Index
                dc.w    loc_7B63A-SSZEndBoss_Index
                dc.w    loc_7B67C-SSZEndBoss_Index
                dc.w    loc_7B6A0-SSZEndBoss_Index
                dc.w    loc_7B6DA-SSZEndBoss_Index
                dc.w    loc_7B6EE-SSZEndBoss_Index
                dc.w    loc_7B748-SSZEndBoss_Index
                dc.w    loc_7B77E-SSZEndBoss_Index
                dc.w    loc_7B7BA-SSZEndBoss_Index
                dc.w    loc_7B748-SSZEndBoss_Index
                dc.w    loc_7B804-SSZEndBoss_Index
; ---------------------------------------------------------------------------

loc_7B2DC:
                lea     ObjSlot_MechaSonic(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.b  #8,collision_property(a0)
                move.l  (V_int_run_count).w,(RNG_seed).w
                tst.b   (Current_act).w
                beq.s   loc_7B308
                move.w  #$220,x_pos(a0)
                move.w  #$4A0,y_pos(a0)
                bra.w   loc_7B35A
; ---------------------------------------------------------------------------

loc_7B308:
                move.b  #4,routine(a0)
                move.b  #2,mapping_frame(a0)
                move.w  #-$800,x_vel(a0)
                bset    #2,$38(a0)
                lea     ChildObjDat_7D47A(pc),a2
                jsr     (CreateChild6_Simple).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$20,d0
                move.w  d0,(_unkFAB4).w
                addi.w  #$100,d0
                move.w  d0,(_unkFAB6).w
                addi.w  #$40,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$30,d0
                move.w  d0,(_unkFAB0).w
                addi.w  #$70,d0
                move.w  d0,y_pos(a0)

loc_7B35A:
                lea     (ArtKosM_MechaSonicExtra).l,a1
                move.w  #tiles_to_bytes(ArtTile_MechaSonicExtra),d2
                jsr     (Queue_Kos_Module).l
                lea     (PLC_BossExplosion).l,a1
                jsr     (Load_PLC_Raw).l
                lea     (Pal_SSZGHZMisc).l,a1
                jsr     (PalLoad_Line1).l
                tst.b   (Current_act).w
                bne.s   loc_7B39C
                jsr     (AllocateObject).l
                bne.s   loc_7B39C
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_EndBoss,subtype(a1)

loc_7B39C:
                lea     ChildObjDat_7D474(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (AllocateObject).l
; ---------------------------------------------------------------------------

loc_7B3AC:
                btst    #4,(_unkFAB8).w
                beq.w   locret_7B448
                move.b  #$14,routine(a0)
                move.b  #2,$3B(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$20,d0
                move.w  d0,(_unkFAB4).w
                addi.w  #$100,d0
                move.w  d0,(_unkFAB6).w
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$30,d0
                move.w  d0,(_unkFAB0).w
                bra.w   loc_7B57A
; ---------------------------------------------------------------------------

loc_7B3E6:
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                subi.w  #$20,d0
                cmp.w   x_pos(a0),d0
                blo.s   locret_7B414
                move.b  #6,routine(a0)
                bclr    #2,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_7B41C,$34(a0)

locret_7B414:
                rts
; ---------------------------------------------------------------------------

loc_7B416:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7B41C:
                move.b  #8,routine(a0)
                bset    #0,render_flags(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$40,d0
                move.w  d0,y_pos(a0)
                move.w  #$400,x_vel(a0)
                move.b  #3,mapping_frame(a0)
                move.l  #byte_7D523,$30(a0)

locret_7B448:
                rts
; ---------------------------------------------------------------------------

loc_7B44A:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite2).l
                move.w  x_pos(a0),d0
                cmp.w   (_unkFAB6).w,d0
                bhs.s   loc_7B462
                rts
; ---------------------------------------------------------------------------

loc_7B462:
                move.b  #$A,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_7B484,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7B478:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7B484:
                move.b  #$C,routine(a0)
                move.b  #$1F,y_radius(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #loc_7B4EC,$34(a0)
                jsr     (Random_Number).l
                tst.w   d0
                bmi.s   loc_7B4CA
                bclr    #4,(_unkFAB8).w
                bne.s   loc_7B4CA
                move.l  #byte_7D4DE,$30(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_7B4CA:
                move.l  #byte_7D4EF,$30(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_7B4DA:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite_LightGravity).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

loc_7B4EC:
                move.b  #$E,routine(a0)
                clr.w   $16(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                btst    #3,$38(a0)
                bne.s   loc_7B520
                move.l  #byte_7D596,$30(a0)
                move.l  #loc_7B544,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7B520:
                bchg    #0,render_flags(a0)
                move.b  #1,mapping_frame(a0)
                move.l  #byte_7D5A2,$30(a0)
                move.l  #loc_7B57A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7B53E:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_7B544:
                move.b  #$10,routine(a0)
                move.w  #$820,d0
                move.w  #-$20,d1
                btst    #0,render_flags(a0)
                beq.s   loc_7B55E
                neg.w   d0
                neg.w   d1

loc_7B55E:
                move.w  d0,x_vel(a0)
                move.w  d1,$40(a0)
                clr.w   y_vel(a0)
                bset    #2,$38(a0)
                lea     ChildObjDat_7D486(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_7B57A:
                move.b  #$14,routine(a0)
                move.l  #byte_7D541,$30(a0)
                move.l  #loc_7B5E8,$34(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                bset    #0,render_flags(a0)
                cmp.w   x_pos(a0),d0
                bhs.s   locret_7B5AA
                bclr    #0,render_flags(a0)

locret_7B5AA:
                rts
; ---------------------------------------------------------------------------

loc_7B5AC:
                move.w  $40(a0),d0
                add.w   d0,x_vel(a0)
                jsr     (MoveSprite2).l
                lea     loc_7B5C2(pc),a1
                bra.w   loc_7D216
; ---------------------------------------------------------------------------

loc_7B5C2:
                move.b  #$12,routine(a0)
                move.w  d0,x_pos(a0)
                clr.w   $12(a0)
                bclr    #2,$38(a0)
                move.l  #byte_7D59B,$30(a0)
                move.l  #loc_7B57A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7B5E8:
                move.b  #$F,y_radius(a0)
                lea     byte_7D54A(pc),a1
                jsr     (Set_Raw_Animation).l
                move.w  #$200,d0
                btst    #0,render_flags(a0)
                bne.s   loc_7B606
                neg.w   d0

loc_7B606:
                move.w  d0,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                move.b  $3B(a0),d0
                addq.b  #1,$3B(a0)
                andi.w  #7,d0
                moveq   #0,d1
                move.b  byte_7B62E(pc,d0.w),d1
                move.b  d1,$3A(a0)
                move.b  byte_7B636(pc,d1.w),routine(a0)
                rts
; ---------------------------------------------------------------------------
byte_7B62E:
                dc.b    0,   1,   2,   0,   1,   2,   0,   1
byte_7B636:
                dc.b    $16, $1A, $1E
                even
; ---------------------------------------------------------------------------

loc_7B63A:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bpl.s   loc_7B64E
                rts
; ---------------------------------------------------------------------------

loc_7B64E:
                move.b  #$18,routine(a0)
                move.w  #$780,d0
                moveq   #-$20,d1
                btst    #0,render_flags(a0)
                bne.s   loc_7B666
                neg.w   d0
                neg.w   d1

loc_7B666:
                move.w  d0,x_vel(a0)
                move.w  d1,$40(a0)
                clr.w   y_vel(a0)
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_7B67C:
                jsr     (Animate_RawMultiDelay).l
                move.w  $40(a0),d0
                add.w   d0,x_vel(a0)
                jsr     (MoveSprite2).l
                lea     loc_7B698(pc),a1
                bra.w   loc_7D216
; ---------------------------------------------------------------------------

loc_7B698:
                move.w  d0,x_pos(a0)
                bra.w   loc_7B462
; ---------------------------------------------------------------------------

loc_7B6A0:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   locret_7B6BE
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_7B6C0
                beq.s   loc_7B6C0

locret_7B6BE:
                rts
; ---------------------------------------------------------------------------

loc_7B6C0:
                add.w   d1,y_pos(a0)
                move.b  #$1C,routine(a0)
                move.w  #-$900,y_vel(a0)
                moveq   #signextendB(sfx_Thump),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_7B6DA:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite).l
                lea     loc_7B462(pc),a1
                bra.w   loc_7D216
; ---------------------------------------------------------------------------

loc_7B6EE:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   locret_7B70C
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_7B70E
                beq.s   loc_7B70E

locret_7B70C:
                rts
; ---------------------------------------------------------------------------

loc_7B70E:
                add.w   d1,y_pos(a0)
                move.b  #$20,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_7B754,$34(a0)
                bset    #2,$38(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_7D480(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   locret_7B70C
                move.b  #8,subtype(a1)
                rts
; ---------------------------------------------------------------------------

loc_7B748:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7B754:
                move.b  #$22,routine(a0)
                move.w  #$100,d0
                tst.w   x_vel(a0)
                bmi.s   loc_7B766
                neg.w   d0

loc_7B766:
                move.w  d0,x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #7,$2E(a0)
                move.l  #loc_7B790,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7B77E:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7B790:
                move.b  #$24,routine(a0)
                move.w  #$640,d0
                move.w  #-$20,d1
                tst.w   x_vel(a0)
                bmi.s   loc_7B7A8
                neg.w   d0
                neg.w   d1

loc_7B7A8:
                move.w  d0,x_vel(a0)
                move.w  d1,$40(a0)
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_7B7BA:
                jsr     (Animate_RawMultiDelay).l
                move.w  $40(a0),d0
                add.w   d0,x_vel(a0)
                jsr     (MoveSprite2).l
                lea     loc_7B7D6(pc),a1
                bra.w   loc_7D216
; ---------------------------------------------------------------------------

loc_7B7D6:
                move.b  #$26,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_7B7EC,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7B7EC:
                move.b  #$28,routine(a0)
                bclr    #2,$38(a0)
                clr.w   x_vel(a0)
                move.w  #-$640,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_7B804:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bpl.w   loc_7B462
                rts
; ---------------------------------------------------------------------------

loc_7B81A:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_7B838(pc,d0.w),d1
                jsr     off_7B838(pc,d1.w)
                lea     DPLCPtr_MechaSonic(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_7B838:
                dc.w    loc_7B852-off_7B838
                dc.w    loc_7B87C-off_7B838
                dc.w    loc_7B93E-off_7B838
                dc.w    loc_7B972-off_7B838
                dc.w    loc_7B984-off_7B838
                dc.w    loc_7B9D2-off_7B838
                dc.w    loc_7B9FA-off_7B838
                dc.w    loc_7BA28-off_7B838
                dc.w    loc_7BA90-off_7B838
                dc.w    loc_7BABE-off_7B838
                dc.w    loc_7BB06-off_7B838
                dc.w    loc_7BBAC-off_7B838
                dc.w    loc_7BBE0-off_7B838
; ---------------------------------------------------------------------------

loc_7B852:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7B858:
                move.b  #2,routine(a0)
                move.b  #$E,mapping_frame(a0)
                move.b  #$1F,y_radius(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.l  #loc_7B888,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7B87C:
                jsr     (MoveSprite_LightGravity).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

loc_7B888:
                move.b  #$23,y_radius(a0)
                lea     byte_7D5E4(pc),a1
                jsr     (Set_Raw_Animation).l
                lea     (word_7D842).l,a1
                bsr.w   InstallSingleGlobalPaletteRotationScript
                lea     ChildObjDat_7D48C(pc),a2
                jsr     (CreateChild6_Simple).l
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                tst.b   (Current_act).w
                bne.s   loc_7B8E6
                move.b  #4,routine(a0)
                st      (_unkFAA8).w
                bset    #5,$38(a0)
                bclr    #3,$38(a0)
                move.w  #(2*60)-1,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   locret_7B8E4
                move.l  #loc_7D056,(a1)

locret_7B8E4:
                rts
; ---------------------------------------------------------------------------

loc_7B8E6:
                btst    #7,$38(a0)
                bne.s   loc_7B916
                bset    #5,$38(a0)
                move.b  #8,routine(a0)
                move.w  #$BF,$2E(a0)
                move.l  #loc_7B996,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                st      (Ctrl_2_locked).w
                rts
; ---------------------------------------------------------------------------

loc_7B916:
                move.l  #loc_7BC32,(a0)
                clr.b   (Update_HUD_timer).w
                move.w  #$BF,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   loc_7B934
                move.l  #loc_8642E,(a1)

loc_7B934:
                lea     ChildObjDat_7D4D0(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_7B93E:
                jsr     (Run_PalRotationScript).l
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------
; unused
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.w   locret_7B448
                beq.w   locret_7B448
                move.b  #6,routine(a0)
                bset    #7,art_tile(a0)
                lea     (Pal_SSZGHZMisc).l,a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_7B972:
                tst.b   render_flags(a0)
                bpl.s   loc_7B97E
                jmp     (MoveSprite).l
; ---------------------------------------------------------------------------

loc_7B97E:
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

loc_7B984:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7B996:
                move.b  #$A,routine(a0)
                move.b  #1,(Update_HUD_timer).w
                clr.b   status(a0)
                clr.b   $38(a0)
                ori.b   #$50,$38(a0)
                moveq   #signextendB(mus_DDZ),d0
                jsr     (Play_Music).l
                lea     ChildObjDat_7D492(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     (ArtKosM_EndingMasterEmerald).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_MasterEmerald),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

loc_7B9D2:
                btst    #6,$38(a0)
                bne.s   locret_7B9F8
                move.b  #$C,routine(a0)
                lea     byte_7D5EF(pc),a1
                jsr     (Set_Raw_Animation).l
                move.b  #$E,mapping_frame(a0)
                move.l  #loc_7BA00,$34(a0)

locret_7B9F8:
                rts
; ---------------------------------------------------------------------------

loc_7B9FA:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_7BA00:
                move.b  #$E,routine(a0)
                move.w  #$3B,$2E(a0)
                bset    #2,$38(a0)
                lea     ChildObjDat_7D486(pc),a2
                btst    #0,render_flags(a0)
                beq.s   loc_7BA22
                lea     ChildObjDat_7D47A(pc),a2

loc_7BA22:
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_7BA28:
                moveq   #signextendB(sfx_Spindash),d0
                jsr     (Play_SFX_Continuous).l
                subq.w  #1,$2E(a0)
                bmi.s   loc_7BA38
                rts
; ---------------------------------------------------------------------------

loc_7BA38:
                move.b  #$10,routine(a0)
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                lea     (Player_1).w,a1
                jsr     (Stop_Object).l
                move.w  (Camera_max_X_pos).w,d0
                addi.w  #$140,d0
                move.w  d0,(Camera_max_X_pos).w
                addi.w  #$100,d0
                move.w  d0,(_unkFAB6).w
                move.w  #$600,x_vel(a0)
                clr.w   y_vel(a0)
                jsr     (AllocateObject).l
                bne.s   loc_7BA80
                move.l  #loc_7C818,(a1)
                move.w  a1,$44(a0)

loc_7BA80:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_7BA8E
                move.l  #loc_7C9E8,(a1)

locret_7BA8E:
                rts
; ---------------------------------------------------------------------------

loc_7BA90:
                jsr     (MoveSprite2).l
                move.w  (_unkFAB6).w,d0
                subi.w  #$AA,d0
                cmp.w   x_pos(a0),d0
                bls.s   loc_7BAA6
                rts
; ---------------------------------------------------------------------------

loc_7BAA6:
                move.b  #$12,routine(a0)
                move.l  #loc_7BAD0,$34(a0)
                lea     byte_7D5F6(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_7BABE:
                addi.w  #-$30,x_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_7BAD0:
                move.b  #$14,routine(a0)
                bclr    #2,$38(a0)
                move.w  #-$400,y_vel(a0)
                move.b  #$4B,y_radius(a0)
                move.l  #loc_7BB20,$34(a0)
                lea     byte_7D61A(pc),a1
                btst    #0,render_flags(a0)
                beq.s   loc_7BB00
                lea     byte_7D60A(pc),a1

loc_7BB00:
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_7BB06:
                jsr     (Animate_RawMultiDelayFlipX).l
                jsr     (MoveSprite_LightGravity).l
                tst.w   y_vel(a0)
                bmi.w   locret_7B448
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

loc_7BB20:
                move.w  (Camera_min_X_pos).w,d0
                addi.w  #$A0,d0
                move.w  d0,(Camera_min_X_pos).w
                addi.w  #$10,d0
                move.w  d0,(_unkFA82).w
                addi.w  #$50,d0
                move.w  d0,(_unkFA84).w
                addi.w  #$50,d0
                move.w  d0,(_unkFA86).w
                addi.w  #$40,d0
                move.w  d0,(_unkFA88).w
                addi.w  #$40,d0
                move.w  d0,(_unkFA8A).w
                addi.w  #$50,d0
                move.w  d0,(_unkFA8C).w
                addi.w  #$50,d0
                move.w  d0,(_unkFA8E).w
                move.b  #$16,routine(a0)
                move.l  #loc_7BBC6,$34(a0)
                lea     byte_7D5AB(pc),a1
                jsr     (Set_Raw_Animation).l

loc_7BB7C:
                clr.b   $38(a0)
                bset    #7,$38(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                lea     (word_7D9EA).l,a1
                bsr.w   InstallSingleGlobalPaletteRotationScript
                lea     ChildObjDat_7D48C(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   locret_7BBAA
                move.b  #8,subtype(a1)

locret_7BBAA:
                rts
; ---------------------------------------------------------------------------

loc_7BBAC:
                moveq   #signextendB(sfx_MechaTransform),d0
                jsr     (Play_SFX_Continuous).l
                jsr     (Run_PalRotationScript).l
                bchg    #6,(_unkFAB8).w
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_7BBC6:
                move.b  #$18,routine(a0)
                lea     (Player_1).w,a1
                clr.b   status(a1)
                clr.b   spin_dash_flag(a1)
                move.w  #$782,spin_dash_counter(a1)
                rts
; ---------------------------------------------------------------------------

loc_7BBE0:
                jsr     (Run_PalRotationScript).l
                bchg    #6,(_unkFAB8).w
                move.w  #(button_right_mask<<8)|button_right_mask,(Ctrl_1_logical).w
                lea     (Player_1).w,a1
                move.w  x_pos(a1),d0
                move.w  (_unkFA8A).w,d1
                addi.w  #$10,d1
                cmp.w   d1,d0
                blo.w   locret_7B448
                clr.b   (Scroll_lock).w
                clr.w   (H_scroll_frame_offset).w
                clr.w   (Ctrl_1_logical).w
                clr.b   (Ctrl_1_locked).w
                bsr.w   SSZScene_ClearP1Velocities
                move.l  #Obj_SSZ2_Boss,(a0)
                move.b  #8,collision_property(a0)
                move.b  #$23,collision_flags(a0)
                bra.w   loc_7BDD8
; ---------------------------------------------------------------------------

loc_7BC32:
                subq.w  #1,$2E(a0)
                bmi.s   loc_7BC3E
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7BC3E:
                move.l  #Obj_Wait,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_7BC70,$34(a0)
                bclr    #7,render_flags(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                addi.w  #$20,y_pos(a0)
                lea     ChildObjDat_7D4CA(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_7BC70:
                move.l  #loc_7BCB0,(a0)
                bset    #5,$38(a0)
                clr.w   $3A(a0)
                move.b  #4,$39(a0)
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($80),d6

loc_7BC90:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_7BC90
                jsr     (AllocateObject).l
                bne.s   locret_7BCAE
                move.w  a1,$44(a0)
                move.l  #SKPalEffect_InitWhiteAndLockRotation,(a1)
                move.w  #7,$3A(a1)

locret_7BCAE:
                rts
; ---------------------------------------------------------------------------

loc_7BCB0:
                bsr.w   TickSSZPostBossExplosionSoundBurst
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.w   locret_7B448
                move.l  #loc_7BCFC,(a0)
                move.w  #(2*60)-1,$2E(a0)
                st      (_unkFAA2).w
                st      (Events_fg_4+1).w
                lea     (Player_1).w,a1
                move.b  #$83,object_control(a1)
                clr.b   mapping_frame(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                st      (SRAM_mask_interrupts_flag).w
                jmp     (SaveGame).l
; ---------------------------------------------------------------------------

loc_7BCFC:
                bsr.w   TickSSZPostBossExplosionSoundBurst
                subq.w  #1,$2E(a0)
                bpl.w   locret_7B448
                move.w  #3,(Player_mode).w
                jsr     (AllocateObject).l
                bne.s   loc_7BD1C
                move.l  #loc_5E6C0,(a1)

loc_7BD1C:
                jsr     (AllocateObject).l
                bne.s   loc_7BD2A
                move.l  #SKPalEffect_InitTargetPasses,(a1)

loc_7BD2A:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

TickSSZPostBossExplosionSoundBurst:
                subq.w  #1,$3A(a0)
                bpl.s   locret_7BD4A
                move.w  #$1F,$3A(a0)
                subq.b  #1,$39(a0)
                bmi.s   locret_7BD4A
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l

locret_7BD4A:
                rts
; End of function TickSSZPostBossExplosionSoundBurst
