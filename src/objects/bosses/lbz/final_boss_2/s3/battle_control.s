; Owner: objects/bosses/lbz/final_boss_2/s3
; Responsibility: Launch Base second final boss initialization, battle state, player interaction and defeat control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZFinalBoss2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LBZFinalBoss2_Index(pc,d0.w),d1
                jsr     LBZFinalBoss2_Index(pc,d1.w)
                jsr     (HandleLBZFinalBoss2SixColorHitOrDefeat).l
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
LBZFinalBoss2_Index:
                dc.w    loc_50CEE-LBZFinalBoss2_Index
                dc.w    loc_50D28-LBZFinalBoss2_Index
                dc.w    loc_50D74-LBZFinalBoss2_Index
                dc.w    loc_50D8C-LBZFinalBoss2_Index
                dc.w    loc_50D74-LBZFinalBoss2_Index
                dc.w    loc_50E2C-LBZFinalBoss2_Index
                dc.w    loc_50E6E-LBZFinalBoss2_Index
                dc.w    loc_50E9C-LBZFinalBoss2_Index
                dc.w    loc_50EAE-LBZFinalBoss2_Index
                dc.w    loc_50ED0-LBZFinalBoss2_Index
                dc.w    loc_50EFA-LBZFinalBoss2_Index
                dc.w    loc_50F3A-LBZFinalBoss2_Index
                dc.w    loc_50F50-LBZFinalBoss2_Index
                dc.w    loc_50F7A-LBZFinalBoss2_Index
                dc.w    loc_50F92-LBZFinalBoss2_Index
                dc.w    loc_50FAC-LBZFinalBoss2_Index
                dc.w    loc_50FC4-LBZFinalBoss2_Index
                dc.w    loc_50FF0-LBZFinalBoss2_Index
                dc.w    loc_5102E-LBZFinalBoss2_Index
                dc.w    loc_51064-LBZFinalBoss2_Index
                dc.w    loc_51086-LBZFinalBoss2_Index
                dc.w    loc_510CE-LBZFinalBoss2_Index
; ---------------------------------------------------------------------------

loc_50CEE:
                lea     ObjDat_LBZFinalBoss2(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #8,collision_property(a0)
                bset    #3,$38(a0)
                st      (Disable_death_plane).w
                lea     Pal_LBZFinalBoss2(pc),a1
                jsr     PalLoad_Line1(pc)
                lea     (ArtKosM_LBZFinalBoss2).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZFinalBoss2),d2
                jsr     (Queue_Kos_Module).l
                lea     (Child1_MakeRoboHead4).l,a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_50D28:
                subq.w  #1,y_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$40,d0
                cmp.w   y_pos(a0),d0
                bcc.s   loc_50D3C
                rts
; ---------------------------------------------------------------------------

loc_50D3C:
                move.b  #4,routine(a0)
                move.w  #$9F,$2E(a0)
                move.l  #loc_50D78,$34(a0)
                jsr     (AllocateObject).l
                bne.s   loc_50D64
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_FinalBoss,subtype(a1)

loc_50D64:
                jsr     (AllocateObject).l
                bne.s   locret_50D72
                move.l  #loc_517FE,(a1)

locret_50D72:
                rts
; ---------------------------------------------------------------------------

loc_50D74:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_50D78:
                move.b  #6,routine(a0)
                move.b  #8,mapping_frame(a0)
                lea     ChildObjDat_51FB4(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_50D8C:
                jsr     MoveSprite_LightGravity(pc)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$120,d0
                cmp.w   y_pos(a0),d0
                blo.s   loc_50DA0
                rts
; ---------------------------------------------------------------------------

loc_50DA0:
                bset    #7,art_tile(a0)
                clr.w   y_vel(a0)
                move.b  #$F,collision_flags(a0)
                bchg    #0,render_flags(a0)
                lea     ChildObjDat_51FCE(pc),a2
                jsr     CreateChild1_Normal(pc)

loc_50DBE:
                move.b  #8,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_50DD4,$34(a0)

locret_50DD2:
                rts
; ---------------------------------------------------------------------------

loc_50DD4:
                bchg    #0,render_flags(a0)
                move.b  $39(a0),d0
                addq.b  #1,$39(a0)
                btst    #1,d0
                bne.s   loc_50E0C
                move.b  #$A,routine(a0)
                bclr    #3,$38(a0)
                bclr    #2,$38(a0)
                move.w  #$AF,$2E(a0)
                move.l  #loc_50DBE,$34(a0)
                bra.w   loc_51C30
; ---------------------------------------------------------------------------

loc_50E0C:
                move.b  #$C,routine(a0)
                clr.b   $39(a0)
                clr.w   y_vel(a0)
                move.l  #loc_50E82,$34(a0)
                move.w  (Camera_Y_pos).w,y_pos(a0)
                bra.w   loc_51C8E
; ---------------------------------------------------------------------------

loc_50E2C:
                move.w  $3A(a0),d0
                move.w  off_50E42(pc,d0.w),d0
                jsr     off_50E42(pc,d0.w)
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------
off_50E42:
                dc.w    locret_50E50-off_50E42
                dc.w    loc_50E4C-off_50E42
                dc.w    loc_50E52-off_50E42
                dc.w    locret_50E50-off_50E42
                dc.w    loc_50E68-off_50E42
; ---------------------------------------------------------------------------

loc_50E4C:
                subq.w  #4,y_vel(a0)

locret_50E50:
                rts
; ---------------------------------------------------------------------------

loc_50E52:
                move.w  y_vel(a0),d0
                add.w   $3C(a0),d0
                move.w  d0,y_vel(a0)
                bne.s   locret_50E66
                move.w  #2,$3C(a0)

locret_50E66:
                rts
; ---------------------------------------------------------------------------

loc_50E68:
                subq.w  #4,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_50E6E:
                moveq   #$50,d1
                move.w  #$F0,d2
                bsr.w   ReverseLBZFinalBoss2AtCameraRelativeBounds
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_50E82:
                move.b  #$E,routine(a0)
                clr.w   x_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_50EA0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_50E9C:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_50EA0:
                move.b  #$10,routine(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_50EAE:
                jsr     MoveSprite_LightGravity(pc)
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$C0,d0
                cmp.w   y_pos(a0),d0
                blo.s   loc_50EC2
                rts
; ---------------------------------------------------------------------------

loc_50EC2:
                move.b  #$12,routine(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_50ED0:
                addi.w  #-$80,y_vel(a0)
                jsr     (MoveSprite2).l
                tst.w   y_vel(a0)
                bpl.s   locret_50EF0
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_50EF2

locret_50EF0:
                rts
; ---------------------------------------------------------------------------

loc_50EF2:
                move.b  #$14,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_50EFA:
                addi.w  #$40,y_vel(a0)
                jsr     (MoveSprite2).l
                tst.w   y_vel(a0)
                bmi.s   locret_50F1A
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$D0,d0
                cmp.w   y_pos(a0),d0
                bls.s   loc_50F1C

locret_50F1A:
                rts
; ---------------------------------------------------------------------------

loc_50F1C:
                move.b  #$16,routine(a0)
                move.w  d0,y_pos(a0)
                clr.w   y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_50F3E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_50F3A:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_50F3E:
                move.b  #$18,routine(a0)
                move.l  #loc_50F64,$34(a0)
                bra.w   loc_51C8E
; ---------------------------------------------------------------------------

loc_50F50:
                moveq   #$30,d1
                move.w  #$110,d2
                bsr.w   ReverseLBZFinalBoss2AtCameraRelativeBounds
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_50F64:
                move.b  #$1A,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_50F7E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_50F7A:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_50F7E:
                move.b  #$1C,routine(a0)
                move.w  #-$400,y_vel(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_50F92:
                jsr     (MoveSprite2).l
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$60,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_50FA8
                rts
; ---------------------------------------------------------------------------

loc_50FA8:
                bra.w   loc_50DBE
; ---------------------------------------------------------------------------

loc_50FAC:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_50FB0:
                move.b  #$20,routine(a0)
                move.w  #-$400,y_vel(a0)
                bchg    #1,$39(a0)
                rts
; ---------------------------------------------------------------------------

loc_50FC4:
                jsr     (MoveSprite2).l
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$60,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_50FDA
                rts
; ---------------------------------------------------------------------------

loc_50FDA:
                move.b  #$22,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_50FF4,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_50FF0:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_50FF4:
                move.b  #$24,routine(a0)
                movea.w $44(a0),a1
                clr.b   $3C(a1)
                move.w  (Camera_X_pos).w,d0
                move.w  d0,d1
                addi.w  #$A0,d0
                bclr    #0,render_flags(a0)
                move.w  #$E0,d2
                cmp.w   x_pos(a0),d0
                blo.s   loc_51026
                bset    #0,render_flags(a0)
                move.w  #$60,d2

loc_51026:
                add.w   d2,d1
                move.w  d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_5102E:
                move.w  (Camera_Y_pos_copy).w,d0
                addi.w  #$88,d0
                cmp.w   y_pos(a0),d0
                bls.s   loc_51042
                addq.w  #8,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_51042:
                move.b  #$26,routine(a0)
                bset    #1,$38(a0)
                move.w  #$14,(Screen_shake_flag).w
                move.w  #3,$2E(a0)
                moveq   #signextendB(sfx_BossHitFloor),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_51064:
                addq.w  #4,y_pos(a0)
                subq.w  #1,$2E(a0)
                bmi.s   loc_51070
                rts
; ---------------------------------------------------------------------------

loc_51070:
                move.b  #$28,routine(a0)
                move.w  #7,$2E(a0)
                move.l  #loc_5108A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_51086:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5108A:
                move.b  #$2A,routine(a0)
                clr.b   $30(a0)
                subi.w  #$10,y_pos(a0)
                bclr    #1,$38(a0)
                move.w  #$400,d0
                btst    #0,render_flags(a0)
                beq.s   loc_510AE
                neg.w   d0

loc_510AE:
                move.w  d0,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                move.w  #$3F,$2E(a0)
                movea.l a0,a2
                lea     (Player_1).w,a0
                jsr     (HurtCharacter).l
                movea.l a2,a0
                rts
; ---------------------------------------------------------------------------

loc_510CE:
                jsr     (MoveSprite).l
                subq.w  #1,$2E(a0)
                bmi.w   loc_50DBE
                rts
; ---------------------------------------------------------------------------

loc_510DE:
                move.l  #loc_510F8,(a0)
                move.b  #5,mapping_frame(a0)
                bset    #4,$38(a0)
                lea     ChildObjDat_51FF0(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_510F8:
                move.w  y_pos(a0),d0
                addq.w  #1,d0
                move.w  d0,y_pos(a0)
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$140,d1
                cmp.w   d1,d0
                blo.s   loc_51142
                move.l  #loc_51148,(a0)
                bclr    #7,render_flags(a0)
                bset    #5,$38(a0)
                move.w  a0,(_unkFAA4).w
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                move.b  #$80,(Player_1+object_control).w
                lea     (ArtKosM_LBZ2DeathEggSmall).l,a1
                move.w  #tiles_to_bytes(ArtTile_LBZ2DeathEggSmall),d2
                jsr     (Queue_Kos_Module).l

loc_51142:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_51148:
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   locret_51178
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                sub.w   x_pos(a1),d0
                scs     d2
                bpl.s   loc_51166
                neg.w   d0

loc_51166:
                cmpi.w  #4,d0
                blo.s   loc_5117A
                moveq   #button_right,d1
                tst.b   d2
                beq.s   loc_51174
                moveq   #button_left,d1

loc_51174:
                bset    d1,(Ctrl_1_held_logical).w

locret_51178:
                rts
; ---------------------------------------------------------------------------

loc_5117A:
                move.l  #locret_511CC,(a0)
                clr.b   (_unkFA88).w
                clr.w   ground_vel(a1)
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                jsr     (AllocateObject).l
                bne.s   loc_511C4
                move.l  #loc_5182E,(a1)
                lea     (Player_1).w,a2
                move.w  x_pos(a2),x_pos(a1)
                move.w  y_pos(a2),y_pos(a1)

loc_511C4:
                lea     ChildObjDat_52010(pc),a2
                jmp     CreateChild6_Simple(pc)
; ---------------------------------------------------------------------------

locret_511CC:
                rts
