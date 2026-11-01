; Owner: objects/bosses/dez/final_boss/sk
; Responsibility: Death Egg final-boss escape ship state, defeat explosions, debris actors and end-of-scene progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_80160:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_8017A(pc,d0.w),d1
                jsr     off_8017A(pc,d1.w)
                jsr     (UpdateDEZEscapeShipHitFlashAndDefeatWait).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
off_8017A:
                dc.w    loc_80184-off_8017A
                dc.w    loc_801D8-off_8017A
                dc.w    loc_80208-off_8017A
                dc.w    loc_8023E-off_8017A
                dc.w    loc_80264-off_8017A
; ---------------------------------------------------------------------------

loc_80184:
                lea     ObjDat3_812EC(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #0,render_flags(a0)
                move.b  #$F,collision_flags(a0)
                move.b  #8,collision_property(a0)
                move.w  (Camera_X_pos_copy).w,d0
                addi.w  #$60,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$140,d0
                move.w  d0,y_pos(a0)
                jsr     (AllocateObject).l
                bne.s   loc_801C6
                move.l  #loc_8642E,(a1)

loc_801C6:
                lea     (Child1_MakeRoboHead3).l,a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_81330(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_801D8:
                subq.w  #1,y_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$50,d0
                cmp.w   y_pos(a0),d0
                blo.w   locret_80C88
                move.b  #4,routine(a0)
                move.w  #$500,x_vel(a0)
                lea     (Child1_MakeRoboShipFlame).l,a2
                jsr     CreateChild1_Normal(pc)
                jmp     (Swing_Setup1).l
; ---------------------------------------------------------------------------

loc_80208:
                bsr.w   AccelerateDEZEscapeCameraAndLockHorizontalLimits
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$100,d0
                cmp.w   x_pos(a0),d0
                bhi.s   locret_8023C
                move.b  #6,routine(a0)
                clr.w   x_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_80250,$34(a0)

locret_8023C:
                rts
; ---------------------------------------------------------------------------

loc_8023E:
                bsr.w   TrySpawnDEZEscapeFallingDebrisEverySixteenTicks
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_80250:
                move.b  #8,routine(a0)
                move.w  #$500,x_vel(a0)
                bset    #7,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_80264:
                bsr.w   AccelerateDEZEscapeCameraAndLockHorizontalLimits
                bsr.w   TrySpawnDEZEscapeFallingDebrisEverySixteenTicks
                jsr     Swing_UpAndDown(pc)
                move.w  x_vel(a0),d0
                cmpi.w  #$280,d0
                bls.s   loc_80282
                subi.w  #$10,d0
                move.w  d0,x_vel(a0)

loc_80282:
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$100,d0
                cmp.w   x_pos(a0),d0
                bls.s   locret_8029A
                move.w  d0,x_pos(a0)

locret_8029A:
                rts
; ---------------------------------------------------------------------------

loc_8029C:
                bset    #3,(_unkFAB8).w
                move.w  #$F,$2E(a0)
                move.l  #loc_802B2,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_802B2:
                move.l  #loc_802C0,(a0)
                bset    #4,(_unkFAB8).w
                rts
; ---------------------------------------------------------------------------

loc_802C0:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$180,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_802DE
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_802DE:
                move.l  #loc_8030E,(a0)
                bset    #5,(_unkFAB8).w
                ori.b   #$30,$38(a0)
                jsr     (AllocateObject).l
                bne.s   loc_802FE
                move.l  #loc_8642E,(a1)

loc_802FE:
                lea     (ArtKosM_BadnikExplosion).l,a1
                move.w  #tiles_to_bytes(ArtTile_Explosion),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

loc_8030E:
                move.l  #loc_80382,(a0)
                clr.b   $38(a0)
                move.w  (Camera_X_pos).w,d0
                subi.w  #$80,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                move.w  d0,y_pos(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_80344
                move.b  #$16,subtype(a1)

loc_80344:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_80358
                move.b  #$16,subtype(a1)

loc_80358:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_8036C
                move.b  #$18,subtype(a1)

loc_8036C:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   locret_80380
                move.b  #$18,subtype(a1)

locret_80380:
                rts
; ---------------------------------------------------------------------------

loc_80382:
                addq.w  #2,x_pos(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$80,d0
                cmp.w   x_pos(a0),d0
                bhs.s   locret_803D4
                move.l  #loc_803D6,(a0)
                jsr     (AllocateObject).l
                bne.s   loc_803B4
                move.l  #loc_85E64,(a1)
                move.w  a1,$44(a0)
                move.w  #3,$3A(a1)
                rts
; ---------------------------------------------------------------------------

loc_803B4:
                lea     (Dynamic_object_RAM+(object_size*61)).w,a1
                movea.l a1,a2
                moveq   #0,d0
                moveq   #bytesToWcnt(object_size),d1

loc_803BE:
                move.w  d0,(a1)+
                dbf     d1,loc_803BE
                move.l  #loc_85E64,(a2)
                move.w  a2,$44(a0)
                move.w  #3,$3A(a2)

locret_803D4:
                rts
; ---------------------------------------------------------------------------

loc_803D6:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.s   locret_80424
                st      (SRAM_mask_interrupts_flag).w
                jsr     (SaveGame).l
                jsr     (Go_Delete_Sprite).l
                cmpi.w  #2,(Player_mode).w
                bhs.s   loc_8040C
                cmpi.b  #7,(Chaos_emerald_count).w
                bne.s   loc_8040C
                move.w  #$C00,d0
                jmp     (StartNewLevel).l
; ---------------------------------------------------------------------------

loc_8040C:
                cmpi.w  #3,(Player_mode).w
                beq.s   loc_8041E
                move.w  #$D01,d0
                jmp     (StartNewLevel).l
; ---------------------------------------------------------------------------

loc_8041E:
                move.b  #GameMode_SegaScreen,(Game_mode).w

locret_80424:
                rts
; ---------------------------------------------------------------------------

loc_80426:
                lea     ObjDat3_81304(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_80494,(a0)
                jsr     (Random_Number).l
                move.w  #0,priority(a0)
                tst.w   d0
                bpl.s   loc_8044C
                move.w  #$300,priority(a0)

loc_8044C:
                andi.w  #$1FF,d0
                move.w  (Camera_X_pos).w,d1
                add.w   d0,d1
                addi.w  #$20,d1
                move.w  d1,x_pos(a0)
                move.w  (Camera_Y_pos).w,d1
                subi.w  #$20,d1
                move.w  d1,y_pos(a0)
                andi.b  #3,d0
                or.b    d0,render_flags(a0)
                swap    d0
                move.w  d0,d1
                andi.w  #3,d0
                lea     RawAni_80490(pc,d0.w),a1
                move.b  (a1)+,mapping_frame(a0)
                andi.w  #$300,d1
                addi.w  #$100,d1
                move.w  d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
RawAni_80490:
                dc.b    0,   1,   2,   1
                even
; ---------------------------------------------------------------------------

loc_80494:
                jsr     (MoveSprite2).l
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$108,d0
                cmp.w   y_pos(a0),d0
                blt.w   loc_810D0
                jmp     (Draw_And_Touch_Sprite).l
; End of function loc_80426
