; Owner: objects/cutscenes/sk
; Responsibility: Launch Base Knuckles encounters in both acts and their local transition helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_LBZ1:
                cmpi.b  #2,(Player_1+character_id).w
                beq.w   CutsceneKnux_Delete
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_LBZ1_Index(pc,d0.w),d1
                jsr     CutsceneKnux_LBZ1_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Sprite_CheckDeleteTouchSlotted).l
; ---------------------------------------------------------------------------
CutsceneKnux_LBZ1_Index:
                dc.w    loc_62678-CutsceneKnux_LBZ1_Index
                dc.w    loc_626B2-CutsceneKnux_LBZ1_Index
                dc.w    loc_62014-CutsceneKnux_LBZ1_Index
                dc.w    loc_626EE-CutsceneKnux_LBZ1_Index
                dc.w    loc_62014-CutsceneKnux_LBZ1_Index
                dc.w    loc_62354-CutsceneKnux_LBZ1_Index
                dc.w    loc_62354-CutsceneKnux_LBZ1_Index
                dc.w    loc_62778-CutsceneKnux_LBZ1_Index
; ---------------------------------------------------------------------------

loc_62678:
                move.w  (Player_1+x_pos).w,d0
                cmp.w   x_pos(a0),d0
                bhs.s   loc_626AC
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.b  #$16,mapping_frame(a0)
                move.w  #$A0,(Camera_min_Y_pos).w
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                lea     ChildObjDat_6657C(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_626AC:
                jmp     (Go_Delete_SpriteSlotted2).l
; ---------------------------------------------------------------------------

loc_626B2:
                btst    #3,$38(a0)
                bne.s   loc_626BC
                rts
; ---------------------------------------------------------------------------

loc_626BC:
                move.b  #4,routine(a0)
                bsr.w   CutsceneSpawnKnucklesMusicFadeTransition
                move.w  #60-1,$2E(a0)
                move.l  #loc_626D6,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_626D6:
                move.b  #6,routine(a0)
                move.l  #byte_666C3,$30(a0)
                move.l  #loc_626F4,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_626EE:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_626F4:
                move.b  #8,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_62726,$34(a0)
                moveq   #signextendB(sfx_MissileThrow),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_66584(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     (PLC_BossExplosion).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

loc_62726:
                move.b  #$A,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_6273E,$34(a0)
                bra.w   loc_62056
; ---------------------------------------------------------------------------

loc_6273E:
                move.b  #$C,routine(a0)
                st      (Screen_shake_flag).w
                move.w  #$5F,$2E(a0)
                move.l  #loc_62760,$34(a0)
                lea     ChildObjDat_6658C(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_62760:
                move.b  #$E,routine(a0)
                move.l  #byte_6669F,$30(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_62778:
                tst.b   render_flags(a0)
                bpl.w   loc_6278A
                addq.w  #2,x_pos(a0)
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_6278A:
                clr.b   (_unkFAA9).w
                clr.b   (Player_1+object_control).w
                clr.b   (Player_2+object_control).w
                move.w  #$3B60,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jsr     (CreateChild6_Simple).l
                move.w  #$148,(Camera_target_max_Y_pos).w
                jsr     (Remove_From_TrackingSlot).l
                lea     (Pal_LBZ1).l,a1
                jsr     (PalLoad_Line1).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_627C6:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.w   CutsceneKnux_Delete
                lea     word_62822(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.l   d0
                beq.s   locret_627FE
                tst.w   d0
                beq.s   loc_627F4
                movea.w parent3(a0),a2
                bset    #3,$38(a2)
                bsr.w   SKLBZScene_LockPlayerFacingRight

loc_627F4:
                swap    d0
                tst.w   d0
                beq.s   locret_627FE
                bsr.w   SKLBZScene_LockPlayerFacingRight

locret_627FE:
                rts

; =============== S U B R O U T I N E =======================================

; Set the scene scratch flag and apply the pose to the selected player if still alive
SKLBZScene_LockPlayerFacingRight:
                st      (_unkFAA9).w
                movea.w d0,a1
                cmpi.b  #6,routine(a1)
                bhs.s   locret_627FE
                move.b  #$81,object_control(a1)
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                rts
; End of function SKLBZScene_LockPlayerFacingRight

; ---------------------------------------------------------------------------
word_62822:
                dc.w    -$40,   $80,  -$30,   $60
; ---------------------------------------------------------------------------

loc_6282A:
                lea     ObjDat3_6640E(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_6284E,(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                moveq   #signextendB(sfx_MissileThrow),d0
                jsr     (Play_SFX).l

loc_6284E:
                jsr     (MoveSprite_LightGravity).l
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

loc_6285A:
                move.l  #loc_628A0,(a0)
                move.l  #Obj_BossExpControl1,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     word_62890(pc,d0.w),a1
                move.w  (a1)+,x_pos(a0)
                move.w  (a1)+,y_pos(a0)
                move.b  #$20,$39(a0)
                move.b  #$20,$3A(a0)
                move.b  #$20,$3B(a0)
                rts
; ---------------------------------------------------------------------------
word_62890:
                dc.w    $3BC0,  $1A0
                dc.w    $3B80,  $1A0
                dc.w    $3B40,  $1A0
                dc.w    $3B00,  $1A0
; ---------------------------------------------------------------------------

loc_628A0:
                subq.w  #4,y_pos(a0)
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

CutsceneKnux_LBZ2:
                cmpi.b  #2,(Player_1+character_id).w
                beq.w   CutsceneKnux_Delete
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_LBZ2_Index(pc,d0.w),d1
                jsr     CutsceneKnux_LBZ2_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Sprite_CheckDeleteTouchSlotted).l
; ---------------------------------------------------------------------------
CutsceneKnux_LBZ2_Index:
                dc.w    loc_628E0-CutsceneKnux_LBZ2_Index
                dc.w    loc_6290E-CutsceneKnux_LBZ2_Index
                dc.w    loc_62928-CutsceneKnux_LBZ2_Index
                dc.w    loc_62942-CutsceneKnux_LBZ2_Index
                dc.w    loc_62964-CutsceneKnux_LBZ2_Index
                dc.w    loc_629A8-CutsceneKnux_LBZ2_Index
                dc.w    loc_629C0-CutsceneKnux_LBZ2_Index
; ---------------------------------------------------------------------------

loc_628E0:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                bset    #0,render_flags(a0)
                move.b  #$20,mapping_frame(a0)
                bsr.w   CutsceneSpawnKnucklesMusicFadeTransition
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                lea     ChildObjDat_66592(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

loc_6290E:
                btst    #1,$38(a0)
                bne.s   loc_62918
                rts
; ---------------------------------------------------------------------------

loc_62918:
                move.b  #4,routine(a0)
                move.l  #loc_62932,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_62928:
                lea     byte_666D2(pc),a1
                jmp     (Animate_RawNoSSTMultiDelay).l
; ---------------------------------------------------------------------------

loc_62932:
                move.b  #6,routine(a0)
                bclr    #0,render_flags(a0)
                bra.w   loc_62056
; ---------------------------------------------------------------------------

loc_62942:
                tst.b   (Screen_shake_flag).w
                beq.s   loc_6295E
                move.b  #8,routine(a0)
                move.l  #byte_6669A,$30(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)

loc_6295E:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_62964:
                btst    #3,$38(a0)
                bne.s   loc_6297A
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_6297A:
                move.b  #$A,routine(a0)
                bset    #0,render_flags(a0)
                move.b  #9,mapping_frame(a0)
                move.w  #$200,x_vel(a0)
                move.w  #-$100,y_vel(a0)
                jsr     (AllocateObject).l
                bne.s   locret_629A6
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

locret_629A6:
                rts
; ---------------------------------------------------------------------------

loc_629A8:
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                blo.s   loc_629C0
                moveq   #signextendB(sfx_Splash),d0
                jsr     (Play_SFX).l
                move.b  #$C,routine(a0)

loc_629C0:
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                jmp     (MoveSprite_LightGravity).l
; ---------------------------------------------------------------------------

loc_629CE:
                lea     ObjDat3_6641A(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_62A0A,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.l  word_629FA(pc,d0.w),$3E(a0)
                lsl.w   #3,d0
                add.w   d0,y_pos(a0)
                move.w  x_pos(a0),$3A(a0)
                rts
; ---------------------------------------------------------------------------
word_629FA:
                dc.w    $100,   $10
                dc.w    $C0,    $C
                dc.w    $80,     8
                dc.w    $40,     4
; ---------------------------------------------------------------------------

loc_62A0A:
                tst.b   (Screen_shake_flag).w
                beq.s   loc_62A22
                move.l  #loc_62A28,(a0)
                move.w  $3E(a0),x_vel(a0)
                move.b  #6,$39(a0)

loc_62A22:
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

loc_62A28:
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                move.w  x_pos(a0),d0
                move.w  $40(a0),d1
                cmp.w   $3A(a0),d0
                scs     d2
                bcs.s   loc_62A42
                neg.w   d1

loc_62A42:
                add.w   d1,x_vel(a0)
                cmp.b   $3C(a0),d2
                beq.s   loc_62A82
                move.b  d2,$3C(a0)
                cmpi.b  #3,$39(a0)
                bne.s   loc_62A6C
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.l  word_62A9E(pc,d0.w),$3E(a0)
                move.w  $3E(a0),x_vel(a0)

loc_62A6C:
                subq.b  #1,$39(a0)
                bne.s   loc_62A82
                move.l  #loc_62AAE,(a0)
                movea.w parent3(a0),a1
                bset    #3,$38(a1)

loc_62A82:
                jsr     (MoveSprite2).l
                tst.b   subtype(a0)
                bne.s   loc_62A98
                movea.w parent3(a0),a1
                move.w  x_pos(a0),x_pos(a1)

loc_62A98:
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------
word_62A9E:
                dc.w    $200,   $20
                dc.w    $180,   $18
                dc.w    $100,   $10
                dc.w    $80,     8
; ---------------------------------------------------------------------------

loc_62AAE:
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                jsr     (MoveSprite_LightGravity).l
                jmp     (Sprite_CheckDeleteXY).l
; End of function loc_629A8
