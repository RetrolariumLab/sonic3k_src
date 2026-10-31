; Owner: objects/bosses/lbz/final_boss_2/s3
; Responsibility: Launch Base second final boss defeat, ending pose actors, palette transition and ending handoff
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_516A4:
                lea     ObjDat3_51F78(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_516FA,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                beq.s   loc_516C0
                move.l  #loc_5173E,(a0)

loc_516C0:
                move.w  word_516EA(pc,d0.w),y_vel(a0)
                lea     byte_516DC(pc,d0.w),a1
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,d0
                or.b    d0,render_flags(a0)
                lea     Pal_LBZEnding(pc),a1
                jmp     PalLoad_Line1(pc)
; ---------------------------------------------------------------------------
byte_516DC:
                dc.b    0,   0
                dc.b    1,   0
                dc.b    1,   0
                dc.b    2,   0
                dc.b    2,   1
                dc.b    2,   2
                dc.b    2,   3
                even
word_516EA:
                dc.w    $40
                dc.w    $38
                dc.w    $3C
                dc.w    $40
                dc.w    $44
                dc.w    $48
                dc.w    $4C
                dc.w    $50
; ---------------------------------------------------------------------------

loc_516FA:
                bsr.w   sub_5174A
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$F,d0
                bne.s   loc_51730
                lea     ChildObjDat_52042(pc),a2
                jsr     CreateChild6_Simple(pc)
                jsr     (Random_Number).l
                andi.w  #$1F,d0
                subi.w  #$10,d0
                add.w   d0,x_pos(a1)
                swap    d0
                andi.w  #$1F,d0
                subi.w  #$10,d0
                add.w   d0,y_pos(a1)

loc_51730:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$A0,d0
                cmp.w   y_pos(a0),d0
                bcs.s   loc_51764

loc_5173E:
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_5174A:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                cmp.w   y_pos(a0),d0
                bcc.s   locret_51762
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.l  (sp),(a0)

locret_51762:
                rts
; End of function sub_5174A

; ---------------------------------------------------------------------------

loc_51764:
                lea     ChildObjDat_5204E(pc),a2
                jsr     CreateChild6_Simple(pc)
                bne.w   locret_50DD2
                move.w  a1,$44(a0)
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($80),d0

loc_5177E:
                move.l  (a1)+,(a2)+
                dbf     d0,loc_5177E
                move.l  #loc_517BA,(a0)
                moveq   #signextendB(sfx_FlamethrowerQuiet),d0
                jsr     (Play_SFX).l
                moveq   #signextendB(mus_Ending),d0
                jsr     (Play_Music).l
                jsr     sub_5439C(pc)
                lsl.w   #2,d0
                movea.l off_517AE(pc,d0.w),a1
                move.w  #tiles_to_bytes(ArtTile_Ending_S3EndPose),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------
off_517AE:
                dc.l    ArtKosM_SonicEndPose
                dc.l    ArtKosM_TailsEndPose
                dc.l    ArtKosM_SuperSonicEndPose
; ---------------------------------------------------------------------------

loc_517BA:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.s   loc_517DE
                clr.b   (Level_started_flag).w
                lea     ChildObjDat_52054(pc),a2
                jsr     CreateChild6_Simple(pc)
                bne.s   loc_517DE
                move.w  a1,$44(a0)
                move.l  #loc_517E4,(a0)

loc_517DE:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_517E4:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.w   locret_50DD2
                bset    #1,(_unkFA88).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_517FE:
                move.l  #loc_5182A,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                movea.l off_51822(pc,d0.w),a1
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                move.l  #Go_Delete_Sprite,(Palette_rotation_custom).w
                rts
; ---------------------------------------------------------------------------
off_51822:
                dc.l    PalSPtr_LBZFinalBoss2_FadeIn
                dc.l    PalSPtr_LBZFinalBoss2_FadeOut
; ---------------------------------------------------------------------------

loc_5182A:
                jmp     Run_PalRotationScript(pc)
; ---------------------------------------------------------------------------

loc_5182E:
                btst    #0,(_unkFA88).w
                beq.w   locret_50DD2
                move.l  #loc_5185A,(a0)
                move.l  #loc_51868,$34(a0)
                clr.b   (Ctrl_1_locked).w
                lea     (Player_1).w,a1
                move.b  #$53,object_control(a1)
                move.b  #0,anim(a1)

loc_5185A:
                lea     byte_52070(pc),a1
                bsr.w   Animate_ExternalPlayerSprite
                jmp     (Player_Load_PLC).l
; ---------------------------------------------------------------------------

loc_51868:
                move.l  #loc_5186E,(a0)

loc_5186E:
                btst    #1,(_unkFA88).w
                beq.w   locret_50DD2
                move.l  #loc_5188E,(a0)
                move.l  #loc_5189C,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)

loc_5188E:
                lea     byte_5207A(pc),a1
                bsr.w   Animate_ExternalPlayerSprite
                jmp     (Player_Load_PLC).l
; ---------------------------------------------------------------------------

loc_5189C:
                move.l  #loc_518CE,(a0)
                move.w  #$FF,$2E(a0)
                move.l  #loc_518E2,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                lea     (Player_1).w,a1
                moveq   #0,d0
                move.b  character_id(a1),d0
                lsl.w   #2,d0
                lea     off_52090(pc),a2
                move.l  (a2,d0.w),$30(a0)

loc_518CE:
                movea.l $30(a0),a1
                bsr.w   Animate_ExternalPlayerSprite
                jsr     (Player_Load_PLC).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_518E2:
                move.l  #loc_518E8,(a0)

loc_518E8:
                lea     ObjDat3_51FA8(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     (Player_1).w,a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                movea.w (_unkFAA4).w,a1
                move.l  #Go_Delete_Sprite,(a1)
                jsr     sub_5439C(pc)
                moveq   #0,d1
                subq.w  #1,d0
                beq.s   loc_51920
                bmi.s   loc_51922
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   loc_5191E
                addq.w  #4,d1

loc_5191E:
                addq.w  #4,d1

loc_51920:
                addq.w  #4,d1

loc_51922:
                move.l  off_5192C(pc,d1.w),(a0)
                move.w  d1,$3A(a0)
                rts
; ---------------------------------------------------------------------------
off_5192C:
                dc.l    loc_5193C
                dc.l    loc_51994
                dc.l    loc_519B8
                dc.l    loc_51A62
; ---------------------------------------------------------------------------

loc_5193C:
                move.l  #loc_5195E,(a0)
                move.w  #6,$2E(a0)
                move.b  #0,mapping_frame(a0)
                subi.w  #$10,y_pos(a0)
                move.b  #0,(Player_1+mapping_frame).w
                bsr.w   sub_51EB0

loc_5195E:
                subq.w  #1,$2E(a0)
                bpl.s   loc_51982
                move.l  #Wait_Draw,(a0)
                addq.b  #1,mapping_frame(a0)
                move.w  #5*60,$2E(a0)
                move.l  #loc_51988,$34(a0)
                subi.w  #$20,y_pos(a0)

loc_51982:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_51988:
                move.b  #GameMode_S3Credits,(Game_mode).w
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_51994:
                move.l  #loc_5195E,(a0)
                move.w  #4,$2E(a0)
                move.b  #2,mapping_frame(a0)
                subi.w  #$10,y_pos(a0)
                move.b  #0,(Player_1+mapping_frame).w
                bsr.w   sub_51EB0
                bra.s   loc_5195E
; ---------------------------------------------------------------------------

loc_519B8:
                move.l  #loc_519E0,(a0)
                move.b  #4,mapping_frame(a0)
                move.w  #$100,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                lea     (Player_1).w,a1
                move.b  #$81,object_control(a1)
                move.b  #2,anim(a1)

loc_519E0:
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                jsr     (MoveSprite).l
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$140,d0
                cmp.w   y_pos(a0),d0
                bcs.s   loc_51A06
                rts
; ---------------------------------------------------------------------------

loc_51A06:
                move.l  #loc_51A34,(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$180,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$C0,d0
                move.w  d0,y_pos(a0)
                move.w  #-$800,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                bra.w   sub_51EB0
; ---------------------------------------------------------------------------

loc_51A34:
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                cmp.w   x_pos(a0),d0
                bcs.s   loc_51A5C
                move.l  #Wait_Draw,(a0)
                move.w  #3*60,$2E(a0)
                move.l  #loc_51988,$34(a0)

loc_51A5C:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_51A62:
                move.l  #loc_51A90,(a0)
                move.b  #4,mapping_frame(a0)
                move.w  #$600,x_vel(a0)
                lea     (Player_1).w,a1
                move.b  #$81,object_control(a1)
                move.b  #0,anim(a1)
                move.w  #$600,x_vel(a1)
                move.w  #$600,ground_vel(a1)

loc_51A90:
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$180,d0
                cmp.w   y_pos(a0),d0
                bcs.w   loc_51A06
                rts
; ---------------------------------------------------------------------------

loc_51AB8:
                lea     ObjDat3_51F84(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_51AE2,(a0)
                move.w  #-$40,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                lea     ChildObjDat_52048(pc),a2
                jsr     CreateChild6_Simple(pc)

loc_51AE2:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   loc_51B08
                move.b  $39(a0),d0
                addq.b  #1,d0
                move.b  d0,$39(a0)
                andi.b  #3,d0
                move.b  render_flags(a0),d1
                andi.b  #$FC,d1
                or.b    d0,d1
                move.b  d1,render_flags(a0)

loc_51B08:
                jsr     (MoveSprite2).l
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_51B18:
                lea     ObjDat3_51F90(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_51B3C,(a0)
                move.l  #byte_5206A,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.w  #$40,y_vel(a0)

loc_51B3C:
                jsr     Animate_Raw(pc)
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
