; Owner: objects/bosses/lbz/final_boss_1/sk
; Responsibility: Launch Base first final-boss battle controller, attack state and helper callbacks for Sonic or Tails
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZFinalBoss1:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZFinalBoss1_Index(pc,d0.w),d1
                jsr     LBZFinalBoss1_Index(pc,d1.w)
                bsr.w   sub_734FA
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
LBZFinalBoss1_Index:
                dc.w    loc_729DE-LBZFinalBoss1_Index
                dc.w    loc_72A54-LBZFinalBoss1_Index
                dc.w    loc_72A70-LBZFinalBoss1_Index
                dc.w    locret_72AEC-LBZFinalBoss1_Index
                dc.w    loc_72AEE-LBZFinalBoss1_Index
                dc.w    loc_72B04-LBZFinalBoss1_Index
; ---------------------------------------------------------------------------

loc_729DE:
                lea     ObjDat_LBZFinalBoss1(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #9,collision_property(a0)
                move.b  #1,(Boss_flag).w
                move.l  #loc_72A5A,$34(a0)
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   loc_72A2A
                move.w  #$7F,$2E(a0)
                st      (Update_HUD_timer).w
                moveq   #PLCID_71,d0
                jsr     (Load_PLC).l
                jsr     (AllocateObject).l
                bne.s   loc_72A2A
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_EndBoss,subtype(a1)

loc_72A2A:
                lea     (Child1_MakeRoboHead3).l,a2
                jsr     (CreateChild1_Normal).l
                lea     ChildObjDat_737F0(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     ChildObjDat_73766(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     ChildObjDat_737E8(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

loc_72A54:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_72A5A:
                move.b  #4,routine(a0)
                move.w  #-$100,y_vel(a0)
                lea     Pal_LBZFinalBoss1(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_72A70:
                move.w  y_pos(a0),d0
                move.w  (Camera_Y_pos).w,d1
                tst.w   y_vel(a0)
                bmi.s   loc_72A8C
                addi.w  #$118,d1
                cmp.w   d1,d0
                bhs.s   loc_72A9A
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_72A8C:
                subi.w  #$B0,d1
                cmp.w   d1,d0
                bls.s   loc_72A9A
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_72A9A:
                cmpi.b  #2,collision_property(a0)
                bls.s   loc_72AAA
                btst    #3,$38(a0)
                beq.s   locret_72AE6

loc_72AAA:
                jsr     (Random_Number).l
                swap    d0
                moveq   #0,d1
                bclr    #0,render_flags(a0)
                btst    #0,d0
                beq.s   loc_72AC8
                moveq   #2,d1
                bset    #0,render_flags(a0)

loc_72AC8:
                move.w  word_72AE8(pc,d1.w),d1
                move.w  (Camera_X_pos).w,d2
                add.w   d1,d2
                move.w  d2,x_pos(a0)
                move.w  #$100,d0
                tst.w   y_vel(a0)
                bmi.s   loc_72AE2
                neg.w   d0

loc_72AE2:
                move.w  d0,y_vel(a0)

locret_72AE6:
                rts
; ---------------------------------------------------------------------------
word_72AE8:
                dc.w    $110
                dc.w    $30
; ---------------------------------------------------------------------------

locret_72AEC:
                rts
; ---------------------------------------------------------------------------

loc_72AEE:
                subq.b  #1,$40(a0)
                bmi.s   loc_72AF6
                rts
; ---------------------------------------------------------------------------

loc_72AF6:
                move.b  #$A,routine(a0)
                move.b  #4,$40(a0)

locret_72B02:
                rts
; ---------------------------------------------------------------------------

loc_72B04:
                addq.w  #8,y_pos(a0)
                subq.b  #1,$40(a0)
                bmi.s   loc_72B10
                rts
; ---------------------------------------------------------------------------

loc_72B10:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_72B18:
                move.w  y_pos(a0),d0
                addq.w  #1,d0
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$140,d1
                cmp.w   d1,d0
                bhs.s   loc_72B34
                move.w  d0,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_72B34:
                move.l  #loc_72B46,(a0)
                move.w  #$3F,$2E(a0)
                st      (Ctrl_2_locked).w
                rts
; ---------------------------------------------------------------------------

loc_72B46:
                subq.w  #1,$2E(a0)
                bpl.s   locret_72B94
                lea     (Player_1).w,a1
                btst    #7,status(a1)
                bne.s   locret_72B94
                btst    #Status_InAir,status(a1)
                bne.s   locret_72B94
                cmpi.b  #6,routine(a1)
                bhs.s   locret_72B94
                move.l  #loc_72B96,(a0)
                jsr     (Set_PlayerEndingPose).l
                clr.b   (End_of_level_flag).w
                jsr     (AllocateObject).l
                bne.s   loc_72B86
                move.l  #Obj_LevelResults,(a1)

loc_72B86:
                jsr     (AllocateObject).l
                bne.s   locret_72B94
                move.l  #loc_72CFA,(a1)

locret_72B94:
                rts
; ---------------------------------------------------------------------------

loc_72B96:
                tst.b   (End_of_level_flag).w
                beq.w   locret_72B02
                move.l  #loc_72BBC,(a0)
                jsr     (Restore_LevelMusic).l
                move.w  #$1F,$2E(a0)
                lea     (PLC_BossExplosion).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

loc_72BBC:
                subq.w  #1,$2E(a0)
                bpl.w   locret_72B02
                move.l  #loc_72C0A,(a0)
                bset    #5,$38(a0)
                move.w  a0,(_unkFAA4).w
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                st      (Ctrl_1_locked).w
                clr.w   (Ctrl_1_logical).w
                jsr     (AllocateObject).l
                bne.s   loc_72BFA
                move.l  #loc_863C0,(a1)

loc_72BFA:
                lea     (ArtKosM_LBZ2DeathEggSmall).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZ2DeathEggSmall),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

loc_72C0A:
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   locret_72C3A
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                sub.w   x_pos(a1),d0
                scs     d2
                bpl.s   loc_72C28
                neg.w   d0

loc_72C28:
                cmpi.w  #4,d0
                blo.s   loc_72C3C
                moveq   #button_right,d1
                tst.b   d2
                beq.s   loc_72C36
                moveq   #button_left,d1

loc_72C36:
                bset    d1,(Ctrl_1_held_logical).w

locret_72C3A:
                rts
; ---------------------------------------------------------------------------

loc_72C3C:
                move.l  #loc_72C68,(a0)
                clr.b   (_unkFA88).w
                jsr     (Stop_Object).l
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_1_logical).w
                lea     ChildObjDat_73806(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_72C68:
                btst    #0,(_unkFA88).w
                beq.s   locret_72C9C
                move.l  #loc_72C9E,(a0)
                move.l  #loc_72CBE,$34(a0)
                lea     (Player_1).w,a1
                bsr.w   sub_72C8E
                lea     (Player_2).w,a1
; Bug: this tries to hide Tails' tails by clearing his anim, but Tails is
; in a1. loc_72C9E fixes this, but only for player 2. Conversely, S3 only
; clears player 1's anim here, as P2 is absent from the final boss
                clr.b   anim(a0)

sub_72C8E:
                move.b  #$83,object_control(a1)
                clr.b   anim_frame_timer(a1)
                clr.b   anim_frame(a1)

locret_72C9C:
                rts
; ---------------------------------------------------------------------------

loc_72C9E:
                lea     (Player_1).w,a1
                lea     byte_7386A(pc),a2
                jsr     (Animate_ExternalPlayerSprite).l
                lea     (Player_2).w,a1
                clr.b   anim(a1)
                lea     byte_73874(pc),a2
                jmp     (Animate_ExternalPlayerSprite).l
; ---------------------------------------------------------------------------

loc_72CBE:
                move.l  #loc_72CC6,(a0)
                rts
; ---------------------------------------------------------------------------

loc_72CC6:
                btst    #1,(_unkFA88).w
                beq.s   locret_72CD8
                move.l  #loc_72CDA,(a0)
                st      (Events_fg_5).w

locret_72CD8:
                rts
; ---------------------------------------------------------------------------

loc_72CDA:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$120,d0
                cmp.w   (Player_1+y_pos).w,d0
                bhi.w   locret_72B02
                move.w  #$700,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_72CFA:
                lea     (Player_2).w,a1
                btst    #7,status(a1)
                bne.s   locret_72D16
                btst    #Status_InAir,status(a1)
                bne.s   locret_72D16
                cmpi.b  #6,routine(a1)
                blo.s   loc_72D18

locret_72D16:
                rts
; ---------------------------------------------------------------------------

loc_72D18:
                jsr     (Set_PlayerEndingPose).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_72D24:
                move.l  #loc_72D5A,(a0)
                move.w  #$4430,x_pos(a0)
                move.w  #$728,y_pos(a0)
                move.w  #$1010,$3A(a0)
                move.w  #$200,d0
                tst.b   subtype(a0)
                beq.s   loc_72D48
                neg.w   d0

loc_72D48:
                move.w  d0,x_vel(a0)
                move.w  #$41,$2E(a0)
                move.l  #loc_72D78,$34(a0)

loc_72D5A:
                subq.b  #1,$39(a0)
                bpl.s   loc_72D6C
                move.b  #3,$39(a0)
                jsr     (sub_83E84).l

loc_72D6C:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_72D78:
                clr.w   x_vel(a0)
                move.w  #-$200,y_vel(a0)
                move.w  #$57,$2E(a0)
                move.l  #loc_72D92,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_72D92:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   loc_72DB2
                move.w  #$4430,x_pos(a1)
                move.w  #$678,y_pos(a1)
                move.b  #$C,subtype(a1)

loc_72DB2:
                tst.b   subtype(a0)
                bne.s   loc_72DE4
                jsr     (AllocateObject).l
                bne.s   loc_72DE4
                move.l  #loc_72DEA,(a1)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$D0,d0
                move.w  d0,x_pos(a1)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,y_pos(a1)
                move.w  #5,$3A(a1)

loc_72DE4:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_72DEA:
                subq.w  #1,$2E(a0)
                bpl.s   locret_72E20
                addq.b  #1,$39(a0)
                cmpi.b  #8,$39(a0)
                bne.s   loc_72E00
                st      (Events_fg_5).w

loc_72E00:
                cmpi.b  #$18,$39(a0)
                bhs.s   loc_72E22
                move.w  $3A(a0),$2E(a0)
                addq.w  #1,$3A(a0)
                jsr     (AllocateObject).l
                bne.s   locret_72E20
                move.l  #loc_72E54,(a1)

locret_72E20:
                rts
; ---------------------------------------------------------------------------

loc_72E22:
                move.l  #loc_72E2E,(a0)
                move.w  #$17F,$2E(a0)

loc_72E2E:
                subq.w  #1,$2E(a0)
                bmi.s   loc_72E36
                rts
; ---------------------------------------------------------------------------

loc_72E36:
                bset    #0,(_unkFA88).w
                clr.b   $39(a0)
                clr.w   $2E(a0)
                lea     ChildObjDat_7380C(pc),a2
                jsr     (CreateChild1_Normal).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_72E54:
                lea     ObjDat3_73736(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #MoveChkDel,(a0)
                jsr     (Random_Number).l
                andi.w  #7,d0
                move.b  RawAni_72E96(pc,d0.w),mapping_frame(a0)
                swap    d0
                andi.w  #$FF,d0
                move.w  (Camera_X_pos).w,d1
                addi.w  #$20,d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
RawAni_72E96:
                dc.b    7,   8,   9,  $A,  $B,   7,   8,   9
                even
; ---------------------------------------------------------------------------

loc_72E9E:
                lea     ObjDat3_73742(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_72EF8,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                beq.s   loc_72EBC
                move.l  #loc_72F40,(a0)

loc_72EBC:
                move.w  word_72EE8(pc,d0.w),y_vel(a0)
                lea     byte_72EDA(pc,d0.w),a1
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,d0
                or.b    d0,render_flags(a0)
                lea     Pal_LBZEnding(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------
byte_72EDA:
                dc.b    0,   0
                dc.b    1,   0
                dc.b    1,   0
                dc.b    2,   0
                dc.b    2,   1
                dc.b    2,   2
                dc.b    2,   3
word_72EE8:
                dc.w    $40
                dc.w    $38
                dc.w    $3C
                dc.w    $40
                dc.w    $44
                dc.w    $48
                dc.w    $4C
                dc.w    $50
; ---------------------------------------------------------------------------

loc_72EF8:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$F,d0
                bne.s   loc_72F2C
                lea     ChildObjDat_73838(pc),a2
                jsr     (CreateChild6_Simple).l
                jsr     (Random_Number).l
                andi.w  #$1F,d0
                subi.w  #$10,d0
                add.w   d0,x_pos(a1)
                swap    d0
                andi.w  #$1F,d0
                subi.w  #$10,d0
                add.w   d0,y_pos(a1)

loc_72F2C:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_72F40
                bset    #1,(_unkFA88).w

loc_72F40:
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_72F4C:
                lea     ObjDat3_7374E(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_72F7A,(a0)
                move.w  #-$40,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                lea     ChildObjDat_7383E(pc),a2
                jsr     (CreateChild6_Simple).l

loc_72F7A:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   loc_72FA0
                move.b  $39(a0),d0
                addq.b  #1,d0
                move.b  d0,$39(a0)
                andi.b  #3,d0
                move.b  render_flags(a0),d1
                andi.b  #$FC,d1
                or.b    d0,d1
                move.b  d1,render_flags(a0)

loc_72FA0:
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_72FB2:
                lea     ObjDat3_7375A(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_72FD8,(a0)
                move.l  #byte_73864,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.w  #$40,y_vel(a0)

loc_72FD8:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
word_72FEA:
                dc.w    0,  $428, $4280, $4380
                dc.w    $328,  $328, $4300, $4300
