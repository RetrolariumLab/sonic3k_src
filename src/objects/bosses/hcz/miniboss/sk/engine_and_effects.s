; Owner: objects/bosses/hcz/miniboss/sk
; Responsibility: Hydrocity miniboss engine actors, coordinated effects, defeat sequence and debris states
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZMiniboss_Engine:
                lea     ObjDat2_HCZMiniboss_Engine(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_6A4C0,(a0)
                bset    #4,shield_reaction(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A4C0:
                jsr     (Refresh_ChildPosition).l
                bra.s   loc_6A47C
; ---------------------------------------------------------------------------

loc_6A4C8:
                lea     ObjSlot_6AD30(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.w  (Water_level).w,y_pos(a0)
                move.l  #Obj_Wait,(a0)
                tst.b   subtype(a0)
                beq.s   loc_6A4EA
                move.w  #7,$2E(a0)

loc_6A4EA:
                move.l  #loc_6A4F4,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A4F4:
                move.l  #loc_6A504,(a0)
                move.l  #Go_Delete_SpriteSlotted3,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A504:
                lea     byte_6AE3B(pc),a1
                jsr     (Animate_RawNoSST).l
                lea     DPLCPtr_HCZMinibossSplash(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6A51E:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_6A536(pc,d0.w),d1
                jsr     off_6A536(pc,d1.w)
                bsr.w   SwitchHCZVortexToParentDefeatState
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
off_6A536:
                dc.w    loc_6A542-off_6A536
                dc.w    loc_6A55C-off_6A536
                dc.w    loc_6A57C-off_6A536
                dc.w    loc_6A5B2-off_6A536
                dc.w    loc_6A5D8-off_6A536
                dc.w    loc_6A618-off_6A536
; ---------------------------------------------------------------------------

loc_6A542:
                lea     ObjDat3_6AD18(pc),a1
                jsr     (SetUp_ObjAttributes).l
                addi.w  #$148,y_pos(a0)
                clr.w   $42(a0)
                clr.w   $44(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A55C:
                tst.b   render_flags(a0)
                bpl.w   locret_69F78
                move.b  #4,routine(a0)
                lea     Pal_HCZMinibossWater(pc),a1
                lea     (Water_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d0

loc_6A574:
                move.l  (a1)+,(a2)+
                dbf     d0,loc_6A574
                rts
; ---------------------------------------------------------------------------

loc_6A57C:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.w   locret_69F78
                move.b  #6,routine(a0)
                move.l  #byte_6ADEC,$30(a0)
                move.l  #loc_6A5BC,$34(a0)
                moveq   #signextendB(sfx_FanBig),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_6AD92(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_6A5B2:
                lea     byte_6ADEC(pc),a1
                jmp     (Animate_RawNoSSTMultiDelay).l
; ---------------------------------------------------------------------------

loc_6A5BC:
                move.b  #8,routine(a0)
                move.l  #byte_6ADEC,$30(a0)
                move.l  #loc_6A622,$34(a0)
                clr.b   collision_property(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A5D8:
                bsr.w   CapturePlayersInHCZMinibossVortex
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   loc_6A5FA
                moveq   #signextendB(sfx_BossRotate),d0
                jsr     (Play_SFX_Continuous).l
                lea     byte_6AE11(pc),a1
                jmp     (Animate_RawNoSST).l
; ---------------------------------------------------------------------------

loc_6A5FA:
                move.b  #$A,routine(a0)
                bset    #3,$38(a0)
                move.l  #loc_6A622,$34(a0)
                bsr.w   loc_6A986
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_6A618:
                lea     byte_6AE16(pc),a1
                jmp     (Animate_RawNoSSTMultiDelay).l
; ---------------------------------------------------------------------------

loc_6A622:
                move.b  #4,routine(a0)
                move.b  #$16,mapping_frame(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A636:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                beq.s   loc_6A656
                lea     ChildObjDat_6ADC4(pc),a2
                jsr     (CreateChild1_Normal).l
                bsr.w   loc_6A986
                jsr     (Go_Delete_Sprite_2).l

loc_6A656:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6A65C:
                lea     ObjDat3_6AD24(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_6A6B8,(a0)
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
                move.l  off_6A6A8(pc,d0.w),$30(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_6A6D2,$34(a0)
                rts
; ---------------------------------------------------------------------------
off_6A6A8:
                dc.l    byte_6AE46
                dc.l    byte_6AE4A
                dc.l    byte_6AE4E
                dc.l    byte_6AE52
; ---------------------------------------------------------------------------

loc_6A6B8:
                movea.w parent3(a0),a3
                bsr.w   MoveHCZVortexParticleAroundParent
                jsr     (Animate_Raw).l
                jsr     (Obj_Wait).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_6A6D2:
                move.l  #loc_6A6E4,(a0)
                movea.l $30(a0),a1
                move.b  1(a1),mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A6E4:
                movea.w parent3(a0),a3
                btst    #3,$38(a3)
                bne.s   loc_6A6FA
                bsr.w   MoveHCZVortexParticleAroundParent
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_6A6FA:
                move.l  #loc_6A6B8,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A710:
                lea     ObjDat3_6AD24(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_6A79C,(a0)
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
                bpl.s   loc_6A74E
                st      $3C(a0)

loc_6A74E:
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
                lea     off_6A6A8(pc),a1
                move.l  (a1,d0.w),$30(a0)
                move.w  #$200,y_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6A79C:
                tst.b   render_flags(a0)
                bpl.s   loc_6A7BE
                bsr.w   AccelerateHCZVortexActorTowardCenterX
                jsr     (MoveSprite2).l
                jsr     (Animate_Raw).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6A7BE:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_6A7C4:
                lea     (Player_1).w,a1
                btst    #Status_Underwater,status(a1)
                beq.w   locret_69F78
                move.l  #loc_6A872,(a0)
                clr.b   (_unkFAA2).w
                movea.w parent3(a0),a1
                bset    #0,$38(a1)
                move.b  #4,render_flags(a0)
                lea     (Player_1).w,a1
                lea     (Ctrl_1_locked).w,a2
                tst.b   subtype(a0)
                beq.s   loc_6A80C
                lea     (Player_2).w,a1
                lea     (Ctrl_2_locked).w,a2
                btst    #Status_Underwater,status(a1)
                beq.w   loc_6A86C

loc_6A80C:
                clr.b   (a2)
                tst.l   (a1)
                beq.s   loc_6A86C
                move.w  a1,$44(a0)
                bclr    #7,art_tile(a0)
                move.w  x_pos(a1),d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.w  (Camera_X_pos).w,d1
                addi.w  #$A0,d1
                move.w  d1,$3A(a0)
                sub.w   d1,d0
                bpl.s   loc_6A83E
                st      $3C(a0)

loc_6A83E:
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

loc_6A86C:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_6A872:
                bsr.w   AccelerateHCZVortexActorTowardCenterX
                jsr     (MoveSprite2).l
                movea.w $44(a0),a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),d0
                move.w  d0,y_pos(a1)
                cmpi.w  #$828,d0
                bhs.s   loc_6A896
                rts
; ---------------------------------------------------------------------------

loc_6A896:
                tst.b   subtype(a0)
                beq.s   loc_6A8AE
                lea     (Player_2).w,a1
                tst.l   (a1)
                beq.s   loc_6A8C0
                jsr     (Restore_PlayerControl2).l
                bra.w   loc_6A8C0
; ---------------------------------------------------------------------------

loc_6A8AE:
                jsr     (Restore_PlayerControl).l
                move.w  #0,(Camera_stored_min_Y_pos).w
                jsr     (Make_LevelSizeObj).l

loc_6A8C0:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_6A8C6:
                lea     word_6AD42(pc),a1
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

loc_6A8EE:
                lea     word_6AD48(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #MoveChkDel,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$1F,d0
                move.b  d0,mapping_frame(a0)
                moveq   #$1C,d0
                jmp     (Set_IndexedVelocity).l
; End of function loc_6A8EE
