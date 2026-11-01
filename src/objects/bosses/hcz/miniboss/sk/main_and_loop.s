; Owner: objects/bosses/hcz/miniboss/sk
; Responsibility: Hydrocity miniboss initialization, battle control and looping chassis states
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZMiniboss:
                lea     word_69ED2(pc),a1
                jsr     (Check_CameraInRange).l
                move.l  #loc_69EDA,(a0)
                move.b  #1,(Boss_flag).w
                st      (Events_bg+$16).w
                moveq   #PLCID_5B,d0
                jsr     (Load_PLC).l
                move.w  #$300,(Camera_min_Y_pos).w
                lea     ChildObjDat_6AD6E(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------
word_69ED2:
                dc.w    $300,  $400, $3500, $3700
; ---------------------------------------------------------------------------

loc_69EDA:
                btst    #0,$38(a0)
                bne.s   loc_69EFE
                move.w  #$638,d0
                cmp.w   (Camera_Y_pos).w,d0
                bhi.s   loc_69EFE
                bset    #0,$38(a0)
                move.w  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w

loc_69EFE:
                btst    #1,$38(a0)
                move.w  #$3680,d0
                move.w  (Camera_X_pos).w,d1
                move.w  d1,(Camera_min_X_pos).w
                cmp.w   d1,d0
                bhi.s   loc_69F22
                bset    #1,$38(a0)
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w

loc_69F22:
                cmpi.b  #3,$38(a0)
                beq.s   loc_69F2C
                rts
; ---------------------------------------------------------------------------

loc_69F2C:
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  y_pos(a0),$44(a0)
                move.l  #Obj_Wait,(a0)
                move.w  #2*60,$2E(a0)
                move.l  #loc_69F64,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                bset    #3,$38(a0)
                lea     Pal_HCZMiniboss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_69F64:
                move.l  #Obj_HCZ_MinibossLoop,(a0)
                moveq   #signextendB(mus_Miniboss),d0
                jsr     (Play_Music).l
                move.b  #mus_Miniboss,(Current_music+1).w

locret_69F78:
                rts
; ---------------------------------------------------------------------------

Obj_HCZ_MinibossLoop:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  HCZ_MinibossLoop_Index(pc,d0.w),d1
                jsr     HCZ_MinibossLoop_Index(pc,d1.w)
                bsr.w   HandleHCZMinibossHitFlashOrDefeat
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
HCZ_MinibossLoop_Index:
                dc.w    loc_69FAA-HCZ_MinibossLoop_Index
                dc.w    loc_69FE4-HCZ_MinibossLoop_Index
                dc.w    loc_6A00A-HCZ_MinibossLoop_Index
                dc.w    loc_69FE4-HCZ_MinibossLoop_Index
                dc.w    loc_6A00A-HCZ_MinibossLoop_Index
                dc.w    loc_6A076-HCZ_MinibossLoop_Index
                dc.w    loc_6A0C2-HCZ_MinibossLoop_Index
                dc.w    loc_6A0F8-HCZ_MinibossLoop_Index
                dc.w    loc_6A110-HCZ_MinibossLoop_Index
                dc.w    loc_6A15A-HCZ_MinibossLoop_Index
                dc.w    loc_6A00A-HCZ_MinibossLoop_Index
                dc.w    loc_6A216-HCZ_MinibossLoop_Index
; ---------------------------------------------------------------------------

loc_69FAA:
                lea     ObjDat_HCZMiniboss_Loop(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #6,collision_property(a0)
                move.b  #$28,y_radius(a0)
                bset    #3,$38(a0)
                move.w  #$100,y_vel(a0)
                move.w  #$DF,$2E(a0)
                move.l  #loc_69FF0,$34(a0)
                lea     Child1_HCZMiniboss_RocketsEngine(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_69FE4:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_69FF0:
                move.b  #4,routine(a0)
                clr.w   y_vel(a0)
                move.w  #60-1,$2E(a0)
                move.l  #loc_6A010,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A00A:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6A010:
                move.b  #6,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$37,$2E(a0)
                move.l  #loc_6A02C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A02C:
                move.b  #8,routine(a0)
                move.w  #60-1,$2E(a0)
                move.l  #loc_6A042,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A042:
                bsr.w   SelectHCZBossDiveLaneAndRepeatCount

loc_6A046:
                move.b  #$A,routine(a0)
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l
                bset    #6,$38(a0)
                bclr    #7,$38(a0)
                move.w  #$400,y_vel(a0)
                move.w  #$47,$2E(a0)
                move.l  #loc_6A098,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A076:
                btst    #7,$38(a0)
                bne.s   loc_6A08C
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                blo.s   loc_6A08C
                bsr.w   CreateHCZBossSurfaceSplash

loc_6A08C:
                jsr     (MoveSprite2).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

loc_6A098:
                move.b  #$C,routine(a0)
                move.w  $40(a0),x_vel(a0)
                neg.w   $40(a0)
                clr.w   y_vel(a0)
                move.w  #$2F,$2E(a0)
                move.l  #loc_6A0D8,$34(a0)
                bclr    #7,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A0C2:
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                add.w   d1,y_pos(a0)
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6A0D8:
                move.w  #-$400,y_vel(a0)
                clr.w   x_vel(a0)
                subq.b  #1,$39(a0)
                bmi.s   loc_6A0F0
                move.b  #$E,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A0F0:
                move.b  #$10,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A0F8:
                bsr.w   TriggerHCZBossSplashIfSubmerged
                jsr     (MoveSprite2).l
                move.w  y_pos(a0),d0
                cmp.w   $44(a0),d0
                bls.w   loc_6A046
                rts
; ---------------------------------------------------------------------------

loc_6A110:
                bsr.w   TriggerHCZBossSplashIfSubmerged
                jsr     (MoveSprite2).l
                move.w  $44(a0),d0
                addi.w  #$108,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_6A12A
                rts
; ---------------------------------------------------------------------------

loc_6A12A:
                move.b  #$12,routine(a0)
                bclr    #7,$38(a0)
                move.w  d0,y_pos(a0)
                move.w  #$180,d0
                tst.w   $40(a0)
                bpl.s   loc_6A146
                neg.w   d0

loc_6A146:
                move.w  d0,x_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_6A16C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A15A:
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6A16C:
                move.b  #$14,routine(a0)
                moveq   #signextendB(sfx_DoorClose),d0
                jsr     (Play_SFX).l
                bclr    #3,$38(a0)
                move.w  #$9F,$2E(a0)
                move.l  #loc_6A194,$34(a0)
                clr.w   x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A194:
                bset    #2,$38(a0)
                move.w  #$17F,$2E(a0)
                move.l  #loc_6A1AA,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A1AA:
                bclr    #2,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_6A1C0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A1C0:
                bset    #3,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_6A1C0,$34(a0)
                move.l  #loc_6A1DE,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A1DE:
                move.b  #2,routine(a0)
                move.w  #-$20,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_6A1FA,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A1FA:
                move.b  #$16,routine(a0)
                bclr    #6,$38(a0)
                move.w  #-$400,y_vel(a0)
                moveq   #signextendB(sfx_LavaBall),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_6A216:
                jsr     (MoveSprite2).l
                move.w  y_pos(a0),d0
                cmp.w   $44(a0),d0
                bls.w   loc_6A042
                rts
; ---------------------------------------------------------------------------

loc_6A22A:
                st      (_unkFAA2).w
                jsr     (Obj_EndSignControl).l
                jsr     (AllocateObject).l
                bne.s   loc_6A242
                move.l  #loc_6A24C,(a1)

loc_6A242:
                lea     ChildObjDat_6ADAA(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6A24C:
                tst.b   (_unkFAA8).w
                bne.w   locret_69F78
                move.l  #loc_6A270,(a0)
                clr.w   (Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                st      (Ctrl_1_locked).w
                st      (Ctrl_2_locked).w
                move.b  #$80,(Player_1+object_control).w

loc_6A270:
                tst.b   (End_of_level_flag).w
                beq.w   locret_69F78
                move.l  #loc_6A2A0,(a0)
                lea     ChildObjDat_6ADA4(pc),a2
                tst.b   (Player_mode+1).w
                beq.s   loc_6A28C
                lea     ChildObjDat_6AD9E(pc),a2

loc_6A28C:
                jsr     (CreateChild6_Simple).l
                move.w  #$2F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

loc_6A2A0:
                btst    #0,$38(a0)
                beq.w   locret_69F78
                lea     ChildObjDat_6AD98(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Obj_Wait).l
