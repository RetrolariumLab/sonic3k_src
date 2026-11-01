; Owner: objects/bosses/hcz/miniboss/s3
; Responsibility: Hydrocity miniboss initialization, battle control and looping chassis states
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZMiniboss:
                lea     word_47D28(pc),a1
                jsr     (Check_CameraInRange).l
                move.l  #loc_47D30,(a0)
                move.b  #1,(Boss_flag).w
                st      (Events_bg+$16).w
                moveq   #PLCID_5B,d0
                jsr     (Load_PLC).l
                move.w  #$300,(Camera_min_Y_pos).w
                lea     ChildObjDat_48BB2(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------
word_47D28:
                dc.w    $300,  $400, $3500, $3700
; ---------------------------------------------------------------------------

loc_47D30:
                btst    #0,$38(a0)
                bne.s   loc_47D54
                move.w  #$638,d0
                cmp.w   (Camera_Y_pos).w,d0
                bhi.s   loc_47D54
                bset    #0,$38(a0)
                move.w  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w

loc_47D54:
                btst    #1,$38(a0)
                move.w  #$3680,d0
                move.w  (Camera_X_pos).w,d1
                move.w  d1,(Camera_min_X_pos).w
                cmp.w   d1,d0
                bhi.s   loc_47D78
                bset    #1,$38(a0)
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w

loc_47D78:
                cmpi.b  #3,$38(a0)
                beq.s   loc_47D82
                rts
; ---------------------------------------------------------------------------

loc_47D82:
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  y_pos(a0),$44(a0)
                move.l  #Obj_Wait,(a0)
                move.w  #2*60,$2E(a0)
                move.l  #loc_47DBA,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                bset    #3,$38(a0)
                lea     Pal_HCZMiniboss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_47DBA:
                move.l  #Obj_HCZ_MinibossLoop,(a0)
; Bug: This is incorrectly using the End Boss music for a Miniboss
                moveq   #signextendB(mus_EndBoss),d0
                jsr     (Play_Music).l

locret_47DC8:
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
                dc.w    loc_47DFA-HCZ_MinibossLoop_Index
                dc.w    loc_47E34-HCZ_MinibossLoop_Index
                dc.w    loc_47E5A-HCZ_MinibossLoop_Index
                dc.w    loc_47E34-HCZ_MinibossLoop_Index
                dc.w    loc_47E5A-HCZ_MinibossLoop_Index
                dc.w    loc_47EC6-HCZ_MinibossLoop_Index
                dc.w    loc_47F12-HCZ_MinibossLoop_Index
                dc.w    loc_47F48-HCZ_MinibossLoop_Index
                dc.w    loc_47F60-HCZ_MinibossLoop_Index
                dc.w    loc_47FAA-HCZ_MinibossLoop_Index
                dc.w    loc_47E5A-HCZ_MinibossLoop_Index
                dc.w    loc_48066-HCZ_MinibossLoop_Index
; ---------------------------------------------------------------------------

loc_47DFA:
                lea     ObjDat_HCZMiniboss_Loop(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #6,collision_property(a0)
                move.b  #$28,y_radius(a0)
                bset    #3,$38(a0)
                move.w  #$100,y_vel(a0)
                move.w  #$DF,$2E(a0)
                move.l  #loc_47E40,$34(a0)
                lea     Child1_HCZMiniboss_RocketsEngine(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_47E34:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_47E40:
                move.b  #4,routine(a0)
                clr.w   y_vel(a0)
                move.w  #60-1,$2E(a0)
                move.l  #loc_47E60,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_47E5A:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_47E60:
                move.b  #6,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$37,$2E(a0)
                move.l  #loc_47E7C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_47E7C:
                move.b  #8,routine(a0)
                move.w  #60-1,$2E(a0)
                move.l  #loc_47E92,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_47E92:
                bsr.w   SelectHCZBossDiveLaneAndRepeatCount

loc_47E96:
                move.b  #$A,routine(a0)
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l
                bset    #6,$38(a0)
                bclr    #7,$38(a0)
                move.w  #$400,y_vel(a0)
                move.w  #$47,$2E(a0)
                move.l  #loc_47EE8,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_47EC6:
                btst    #7,$38(a0)
                bne.s   loc_47EDC
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                blo.s   loc_47EDC
                bsr.w   CreateHCZBossSurfaceSplash

loc_47EDC:
                jsr     (MoveSprite2).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

loc_47EE8:
                move.b  #$C,routine(a0)
                move.w  $40(a0),x_vel(a0)
                neg.w   $40(a0)
                clr.w   y_vel(a0)
                move.w  #$2F,$2E(a0)
                move.l  #loc_47F28,$34(a0)
                bclr    #7,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_47F12:
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                add.w   d1,y_pos(a0)
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_47F28:
                move.w  #-$400,y_vel(a0)
                clr.w   x_vel(a0)
                subq.b  #1,$39(a0)
                bmi.s   loc_47F40
                move.b  #$E,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_47F40:
                move.b  #$10,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_47F48:
                bsr.w   TriggerHCZBossSplashIfSubmerged
                jsr     (MoveSprite2).l
                move.w  y_pos(a0),d0
                cmp.w   $44(a0),d0
                bls.w   loc_47E96
                rts
; ---------------------------------------------------------------------------

loc_47F60:
                bsr.w   TriggerHCZBossSplashIfSubmerged
                jsr     (MoveSprite2).l
                move.w  $44(a0),d0
                addi.w  #$108,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_47F7A
                rts
; ---------------------------------------------------------------------------

loc_47F7A:
                move.b  #$12,routine(a0)
                bclr    #7,$38(a0)
                move.w  d0,y_pos(a0)
                move.w  #$180,d0
                tst.w   $40(a0)
                bpl.s   loc_47F96
                neg.w   d0

loc_47F96:
                move.w  d0,x_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_47FBC,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_47FAA:
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_47FBC:
                move.b  #$14,routine(a0)
                moveq   #signextendB(sfx_DoorClose),d0
                jsr     (Play_SFX).l
                bclr    #3,$38(a0)
                move.w  #$9F,$2E(a0)
                move.l  #loc_47FE4,$34(a0)
                clr.w   x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_47FE4:
                bset    #2,$38(a0)
                move.w  #$17F,$2E(a0)
                move.l  #loc_47FFA,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_47FFA:
                bclr    #2,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_48010,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_48010:
                bset    #3,$38(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_48010,$34(a0)
                move.l  #loc_4802E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4802E:
                move.b  #2,routine(a0)
                move.w  #-$20,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_4804A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4804A:
                move.b  #$16,routine(a0)
                bclr    #6,$38(a0)
                move.w  #-$400,y_vel(a0)
                moveq   #signextendB(sfx_LavaBall),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_48066:
                jsr     (MoveSprite2).l
                move.w  y_pos(a0),d0
                cmp.w   $44(a0),d0
                bls.w   loc_47E92
                rts
; ---------------------------------------------------------------------------

loc_4807A:
                st      (_unkFAA2).w
                jsr     (Obj_EndSignControl).l
                jsr     (AllocateObject).l
                bne.s   loc_48092
                move.l  #loc_4809C,(a1)

loc_48092:
                lea     ChildObjDat_48BEE(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_4809C:
                tst.b   (_unkFAA8).w
                bne.w   locret_47DC8
                move.l  #loc_480C0,(a0)
                clr.w   (Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                st      (Ctrl_1_locked).w
                st      (Ctrl_2_locked).w
                move.b  #$80,(Player_1+object_control).w

loc_480C0:
                tst.b   (End_of_level_flag).w
                beq.w   locret_47DC8
                move.l  #loc_480F0,(a0)
                lea     ChildObjDat_48BE8(pc),a2
                tst.b   (Player_mode+1).w
                beq.s   loc_480DC
                lea     ChildObjDat_48BE2(pc),a2

loc_480DC:
                jsr     (CreateChild6_Simple).l
                move.w  #$2F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

loc_480F0:
                btst    #0,$38(a0)
                beq.w   locret_47DC8
                lea     ChildObjDat_48BDC(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Obj_Wait).l
