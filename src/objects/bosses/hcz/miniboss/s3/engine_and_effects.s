; Owner: objects/bosses/hcz/miniboss/s3
; Responsibility: Hydrocity miniboss engine actors, coordinated effects, defeat sequence and debris states
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZMiniboss_Engine:
                lea     ObjDat2_HCZMiniboss_Engine(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_48304,(a0)
                rts
; ---------------------------------------------------------------------------

loc_48304:
                jsr     (Refresh_ChildPosition).l
                bra.s   loc_482C6
; ---------------------------------------------------------------------------

loc_4830C:
                lea     ObjSlot_48B74(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.w  (Water_level).w,y_pos(a0)
                move.l  #Obj_Wait,(a0)
                tst.b   subtype(a0)
                beq.s   loc_4832E
                move.w  #7,$2E(a0)

loc_4832E:
                move.l  #loc_48338,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_48338:
                move.l  #loc_48348,(a0)
                move.l  #Go_Delete_SpriteSlotted3,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_48348:
                lea     byte_48C7F(pc),a1
                jsr     (Animate_RawNoSST).l
                lea     DPLCPtr_HCZMinibossSplash(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_48362:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4837A(pc,d0.w),d1
                jsr     off_4837A(pc,d1.w)
                bsr.w   SwitchHCZVortexToParentDefeatState
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
off_4837A:
                dc.w    loc_48386-off_4837A
                dc.w    loc_483A0-off_4837A
                dc.w    loc_483C0-off_4837A
                dc.w    loc_483F6-off_4837A
                dc.w    loc_4841C-off_4837A
                dc.w    loc_4845C-off_4837A
; ---------------------------------------------------------------------------

loc_48386:
                lea     ObjDat3_48B5C(pc),a1
                jsr     (SetUp_ObjAttributes).l
                addi.w  #$148,y_pos(a0)
                clr.w   $42(a0)
                clr.w   $44(a0)
                rts
; ---------------------------------------------------------------------------

loc_483A0:
                tst.b   render_flags(a0)
                bpl.w   locret_47DC8
                move.b  #4,routine(a0)
                lea     Pal_HCZMinibossWater(pc),a1
                lea     (Water_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d0

loc_483B8:
                move.l  (a1)+,(a2)+
                dbf     d0,loc_483B8
                rts
; ---------------------------------------------------------------------------

loc_483C0:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.w   locret_47DC8
                move.b  #6,routine(a0)
                move.l  #byte_48C30,$30(a0)
                move.l  #loc_48400,$34(a0)
                moveq   #signextendB(sfx_FanBig),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_48BD6(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_483F6:
                lea     byte_48C30(pc),a1
                jmp     (Animate_RawNoSSTMultiDelay).l
; ---------------------------------------------------------------------------

loc_48400:
                move.b  #8,routine(a0)
                move.l  #byte_48C30,$30(a0)
                move.l  #loc_48466,$34(a0)
                clr.b   collision_property(a0)
                rts
; ---------------------------------------------------------------------------

loc_4841C:
                bsr.w   CapturePlayersInHCZMinibossVortex
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   loc_4843E
                moveq   #signextendB(sfx_BossRotate),d0
                jsr     (Play_SFX_Continuous).l
                lea     byte_48C55(pc),a1
                jmp     (Animate_RawNoSST).l
; ---------------------------------------------------------------------------

loc_4843E:
                move.b  #$A,routine(a0)
                bset    #3,$38(a0)
                move.l  #loc_48466,$34(a0)
                bsr.w   loc_487CA
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_4845C:
                lea     byte_48C5A(pc),a1
                jmp     (Animate_RawNoSSTMultiDelay).l
; ---------------------------------------------------------------------------

loc_48466:
                move.b  #4,routine(a0)
                move.b  #$16,mapping_frame(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_4847A:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                beq.s   loc_4849A
                lea     ChildObjDat_48C08(pc),a2
                jsr     (CreateChild1_Normal).l
                bsr.w   loc_487CA
                jsr     (Go_Delete_Sprite_2).l

loc_4849A:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_484A0:
                lea     ObjDat3_48B68(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_484FC,(a0)
                jsr     (Random_Number).l
                andi.w  #$FF,d0
                ext.w   d0
                add.w   d0,x_pos(a0)
                swap    d0
                andi.w  #$3F,d0
                subq.w  #8,d0
                add.w   d0,y_pos(a0)
                andi.w  #3,d0
                move.b  d0,mapping_frame(a0)
                lsl.w   #2,d0
                move.l  off_484EC(pc,d0.w),$30(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_48516,$34(a0)
                rts
; ---------------------------------------------------------------------------
off_484EC:
                dc.l    byte_48C8A
                dc.l    byte_48C8E
                dc.l    byte_48C92
                dc.l    byte_48C96
; ---------------------------------------------------------------------------

loc_484FC:
                movea.w parent3(a0),a3
                bsr.w   MoveHCZVortexParticleAroundParent
                jsr     (Animate_Raw).l
                jsr     (Obj_Wait).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_48516:
                move.l  #loc_48528,(a0)
                movea.l $30(a0),a1
                move.b  1(a1),mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_48528:
                movea.w parent3(a0),a3
                btst    #3,$38(a3)
                bne.s   loc_4853E
                bsr.w   MoveHCZVortexParticleAroundParent
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_4853E:
                move.l  #loc_484FC,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_48554:
                lea     ObjDat3_48B68(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_485E0,(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                move.w  d0,x_pos(a0)
                move.w  d0,$3A(a0)
                move.w  (Water_level).w,d0
                addq.w  #8,d0
                move.w  d0,y_pos(a0)
                jsr     (Random_Number).l
                andi.w  #$FF,d0
                move.w  d0,d1
                ext.w   d0
                bpl.s   loc_48592
                st      $3C(a0)

loc_48592:
                add.w   d0,x_pos(a0)
                bsr.w   SetHCZVortexLaunchVelocityFromOffset
                lsl.w   #4,d0
                move.w  d0,x_vel(a0)
                andi.b  #1,d1
                move.b  d1,anim_frame(a0)
                swap    d0
                andi.w  #$1F,d0
                add.w   d0,y_pos(a0)
                andi.w  #3,d0
                move.b  d0,mapping_frame(a0)
                lsl.w   #2,d0
                lea     off_484EC(pc),a1
                move.l  (a1,d0.w),$30(a0)
                move.w  #$200,y_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_485E0:
                tst.b   render_flags(a0)
                bpl.s   loc_48602
                bsr.w   AccelerateHCZVortexActorTowardCenterX
                jsr     (MoveSprite2).l
                jsr     (Animate_Raw).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_48602:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_48608:
                lea     (Player_1).w,a1
                btst    #Status_Underwater,status(a1)
                beq.w   locret_47DC8
                move.l  #loc_486B6,(a0)
                clr.b   (_unkFAA2).w
                movea.w parent3(a0),a1
                bset    #0,$38(a1)
                move.b  #4,render_flags(a0)
                lea     (Player_1).w,a1
                lea     (Ctrl_1_locked).w,a2
                tst.b   subtype(a0)
                beq.s   loc_48650
                lea     (Player_2).w,a1
                lea     (Ctrl_2_locked).w,a2
                btst    #Status_Underwater,status(a1)
                beq.w   loc_486B0

loc_48650:
                clr.b   (a2)
                tst.l   (a1)
                beq.s   loc_486B0
                move.w  a1,$44(a0)
                bclr    #7,art_tile(a0)
                move.w  x_pos(a1),d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.w  (Camera_X_pos).w,d1
                addi.w  #$A0,d1
                move.w  d1,$3A(a0)
                sub.w   d1,d0
                bpl.s   loc_48682
                st      $3C(a0)

loc_48682:
                bsr.w   SetHCZVortexLaunchVelocityFromOffset
                move.w  #$200,y_vel(a0)
                bset    #Status_InAir,status(a1)
                move.b  #1,object_control(a1)
                move.b  #$F,anim(a1)
                clr.b   spin_dash_flag(a1)
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_486B0:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_486B6:
                bsr.w   AccelerateHCZVortexActorTowardCenterX
                jsr     (MoveSprite2).l
                movea.w $44(a0),a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),d0
                move.w  d0,y_pos(a1)
                cmpi.w  #$828,d0
                bhs.s   loc_486DA
                rts
; ---------------------------------------------------------------------------

loc_486DA:
                tst.b   subtype(a0)
                beq.s   loc_486F2
                lea     (Player_2).w,a1
                tst.l   (a1)
                beq.s   loc_48704
                jsr     (Restore_PlayerControl2).l
                bra.w   loc_48704
; ---------------------------------------------------------------------------

loc_486F2:
                jsr     (Restore_PlayerControl).l
                move.w  #0,(Camera_stored_min_Y_pos).w
                jsr     (Make_LevelSizeObj).l

loc_48704:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_4870A:
                lea     word_48B86(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$1B,d0
                move.b  d0,mapping_frame(a0)
                moveq   #$20,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------

loc_48732:
                lea     word_48B8C(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #MoveChkDel,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$1F,d0
                move.b  d0,mapping_frame(a0)
                moveq   #$1C,d0
                jmp     (Set_IndexedVelocity).l
; End of function loc_48732
