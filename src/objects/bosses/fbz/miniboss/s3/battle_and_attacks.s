; Owner: objects/bosses/fbz/miniboss/s3
; Responsibility: Flying Battery miniboss battle state, attacks and coordinated child actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZMiniboss:
                lea     word_4C96E(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZMiniboss_Index(pc,d0.w),d1
                jsr     FBZMiniboss_Index(pc,d1.w)
                bsr.w   FBZMini_SolidBodyOrCapsule
                bsr.w   ProcessFBZMinibossArmSelfHitAndDefeat
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
FBZMiniboss_Index:
                dc.w    loc_4C976-FBZMiniboss_Index
                dc.w    loc_4C9C4-FBZMiniboss_Index
                dc.w    loc_4C9E4-FBZMiniboss_Index
                dc.w    loc_4CA0C-FBZMiniboss_Index
                dc.w    loc_4CA20-FBZMiniboss_Index
word_4C96E:
                dc.w    $440,  $600, $2D00, $2F00
; ---------------------------------------------------------------------------

loc_4C976:
                lea     ObjDat_FBZMiniboss(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #6,collision_property(a0)
                move.b  #1,(Boss_flag).w
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  (Camera_max_Y_pos).w,(Camera_stored_max_Y_pos).w
                move.w  #$540,(Camera_target_max_Y_pos).w
                move.w  #$2E20,$3A(a0)
                move.l  #loc_4C9CA,$34(a0)
                moveq   #PLCID_5E,d0
                jsr     (Load_PLC).l
                lea     Pal_FBZMiniboss(pc),a1
                jsr     (PalLoad_Line1).l
                lea     ChildObjDat_4D4B6(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_4C9C4:
                jmp     (S3EndCamera_TrackMinXAndCheckY).l
; ---------------------------------------------------------------------------

loc_4C9CA:
                move.b  #4,routine(a0)
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  d0,(Camera_min_X_pos).w
                addi.w  #$40,d0
                move.w  d0,(Camera_max_X_pos).w
                rts
; ---------------------------------------------------------------------------

loc_4C9E4:
                btst    #0,$38(a0)
                bne.s   loc_4C9EE
                rts
; ---------------------------------------------------------------------------

loc_4C9EE:
                move.b  #6,routine(a0)
                move.l  #loc_4CA10,$34(a0)
                move.w  #2*60,$2E(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l

locret_4CA0A:
                rts
; ---------------------------------------------------------------------------

loc_4CA0C:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4CA10:
                move.b  #8,routine(a0)
                moveq   #signextendB(mus_Miniboss),d0
                jsr     (Play_Music).l
                rts
; ---------------------------------------------------------------------------

loc_4CA20:
                bclr    #7,$38(a0)
                beq.s   locret_4CA0A
                lea     ChildObjDat_4D4E8(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_4CA30:
                jsr     (Obj_EndSignControl).l
                lea     ChildObjDat_4D4F0(pc),a2
                jsr     CreateChild6_Simple(pc)
                lea     ChildObjDat_4D4F6(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     (S3Capsule_FiveReleasedFragmentChildList).l,a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_4CA50:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4CA68(pc,d0.w),d1
                jsr     off_4CA68(pc,d1.w)
                bsr.w   SolidifyFBZMinibossTopButton
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
off_4CA68:
                dc.w    loc_4CA6C-off_4CA68
                dc.w    loc_4CA7C-off_4CA68
; ---------------------------------------------------------------------------

loc_4CA6C:
                lea     word_4D498(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.w  y_pos(a0),$3E(a0)
                rts
; ---------------------------------------------------------------------------

loc_4CA7C:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_4CAB6
                move.w  $3E(a0),d0
                btst    #3,status(a0)
                bne.s   loc_4CAA8
                btst    #2,$38(a1)
                bne.s   loc_4CAA8
                bclr    #0,$38(a1)
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_4CAA8:
                bset    #0,$38(a1)
                addq.w  #4,d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_4CAB6:
                move.l  #loc_4CAD6,(a0)
                move.l  #Map_EggCapsule,mappings(a0)
                move.w  #make_art_tile(ArtTile_EggCapsule-$46,0,1),art_tile(a0)
                move.b  #5,mapping_frame(a0)
                addq.w  #8,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_4CAD6:
                bsr.w   SolidifyFBZMinibossTopButton
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_4CAE0:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4CAF2(pc,d0.w),d1
                jsr     off_4CAF2(pc,d1.w)
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------
off_4CAF2:
                dc.w    loc_4CAFA-off_4CAF2
                dc.w    loc_4CB02-off_4CAF2
                dc.w    loc_4CB26-off_4CAF2
                dc.w    loc_4CB32-off_4CAF2
; ---------------------------------------------------------------------------

loc_4CAFA:
                lea     word_4D48C(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_4CB02:
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                bne.s   loc_4CB10
                rts
; ---------------------------------------------------------------------------

loc_4CB10:
                move.b  #4,routine(a0)
                move.w  #$40,$2E(a0)
                move.l  #loc_4CB2A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4CB26:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4CB2A:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_4CB32:
                btst    #2,(V_int_run_count+3).w
                jsr     Find_SonicTails8Way(pc)
                addi.w  #9,d4
                move.b  d4,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_4CB46:
                lea     word_4D492(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_4CB78,(a0)
                move.w  #$EEE,(Normal_palette_line_2+$1E).w
                lea     (word_4D540).l,a1
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                move.l  #Go_Delete_Sprite,(Palette_rotation_custom).w
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4CB78:
                jsr     (Run_PalRotationScript).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4CB84:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4CB96(pc,d0.w),d1
                jsr     off_4CB96(pc,d1.w)
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------
off_4CB96:
                dc.w    loc_4CB9E-off_4CB96
                dc.w    loc_4CBB4-off_4CB96
                dc.w    loc_4CBD4-off_4CB96
                dc.w    locret_4CBE6-off_4CB96
; ---------------------------------------------------------------------------

loc_4CB9E:
                lea     word_4D474(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                addq.b  #1,d0
                move.b  d0,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_4CBB4:
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                bne.s   loc_4CBC2
                rts
; ---------------------------------------------------------------------------

loc_4CBC2:
                move.b  #4,routine(a0)
                move.l  #loc_4CBDE,$34(a0)
                bra.w   loc_4D1D8
; ---------------------------------------------------------------------------

loc_4CBD4:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4CBDE:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

locret_4CBE6:
                rts
; ---------------------------------------------------------------------------

loc_4CBE8:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4CC00(pc,d0.w),d1
                jsr     off_4CC00(pc,d1.w)
                bsr.w   EnterFBZMinibossArmParentDefeatWait
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_4CC00:
                dc.w    loc_4CC16-off_4CC00
                dc.w    loc_4CC44-off_4CC00
                dc.w    loc_4CC62-off_4CC00
                dc.w    loc_4CC84-off_4CC00
                dc.w    loc_4CC62-off_4CC00
                dc.w    loc_4CD08-off_4CC00
                dc.w    loc_4CDA0-off_4CC00
                dc.w    loc_4CC62-off_4CC00
                dc.w    loc_4CDE0-off_4CC00
                dc.w    loc_4CDEC-off_4CC00
                dc.w    loc_4CC62-off_4CC00
; ---------------------------------------------------------------------------

loc_4CC16:
                lea     word_4D47A(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.w  #-$140,d0
                subi.b  #$A,subtype(a0)
                beq.s   loc_4CC38
                neg.w   d0
                bset    #0,render_flags(a0)
                move.w  #$3F,$2E(a0)

loc_4CC38:
                move.w  d0,x_vel(a0)
                move.w  #-$D0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_4CC44:
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                bne.s   loc_4CC52
                rts
; ---------------------------------------------------------------------------

loc_4CC52:
                move.b  #4,routine(a0)
                move.l  #loc_4CC66,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4CC62:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4CC66:
                move.b  #6,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_4CC8E,$34(a0)
                lea     word_4D4E2(pc),a2
                jmp     (CreateChild4_LinkListRepeated).l
; ---------------------------------------------------------------------------

loc_4CC84:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4CC8E:
                move.b  #8,routine(a0)
                bset    #3,$38(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_4CCAA,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4CCAA:
                move.b  #$A,routine(a0)
                bset    #2,$38(a0)
                bclr    #3,$38(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                bclr    #1,$38(a0)
                bclr    #6,$38(a1)
                bclr    #6,$38(a0)
                move.w  #2*60,$2E(a0)
                move.l  #loc_4CD10,$34(a0)
                move.b  #-$60,$3C(a0)
                move.b  #2,$40(a0)
                btst    #0,render_flags(a0)
                beq.s   locret_4CD06
                move.b  #$60,$3C(a0)
                move.b  #-2,$40(a0)

locret_4CD06:
                rts
; ---------------------------------------------------------------------------

loc_4CD08:
                bsr.w   OscillateFBZMinibossArmAngle
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4CD10:
                move.w  #$F0,$2E(a0)
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                beq.s   loc_4CD4C
                btst    #1,$38(a1)
                bne.w   locret_4CA0A
                move.b  #$C,routine(a0)
                bclr    #2,$38(a0)
                bset    #1,$38(a1)
                bset    #1,$38(a0)
                bset    #7,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_4CD4C:
                btst    #6,$38(a1)
                bne.w   locret_4CA0A
                lea     (Player_1).w,a2
                tst.b   $40(a2)
                bne.w   locret_4CA0A
                move.w  x_pos(a2),d0
                cmp.w   x_pos(a1),d0
                bhs.s   loc_4CD76
                btst    #0,render_flags(a0)
                beq.s   loc_4CD80
                rts
; ---------------------------------------------------------------------------

loc_4CD76:
                btst    #0,render_flags(a0)
                beq.w   locret_4CA0A

loc_4CD80:
                move.b  #$12,routine(a0)
                bclr    #2,$38(a0)
                bset    #6,$38(a1)
                bset    #6,$38(a0)
                bset    #7,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_4CDA0:
                btst    #3,$38(a0)
                bne.s   loc_4CDAC
                bra.w   ExtendFBZMinibossArmToSideAngle
; ---------------------------------------------------------------------------

loc_4CDAC:
                move.b  #$E,routine(a0)
                move.b  #2,$40(a0)
                move.w  #$60,$2E(a0)
                move.l  #loc_4CDC8,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4CDC8:
                move.b  #$10,routine(a0)
                bclr    #3,$38(a0)
                movea.w parent3(a0),a1
                bclr    #2,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_4CDE0:
                btst    #2,$38(a0)
                bne.w   loc_4CCAA
                rts
; ---------------------------------------------------------------------------

loc_4CDEC:
                bclr    #3,$38(a0)
                bne.s   loc_4CDF6
                rts
; ---------------------------------------------------------------------------

loc_4CDF6:
                move.b  #$14,routine(a0)
                move.w  #$10,$2E(a0)
                move.l  #loc_4CE0C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4CE0C:
                move.b  #$10,routine(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_4CE1A:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_4CE2C
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4CE2C:
                move.l  #Obj_FlickerMove,(a0)
                bset    #4,$38(a0)
                move.w  #$3F,$2E(a0)
                moveq   #0,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------

loc_4CE44:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4CE5A(pc,d0.w),d1
                jsr     off_4CE5A(pc,d1.w)
                bsr.w   EnterFBZMinibossArmParentDefeatWait
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
off_4CE5A:
                dc.w    loc_4CE7A-off_4CE5A
                dc.w    loc_4CECA-off_4CE5A
                dc.w    loc_4CF1E-off_4CE5A
                dc.w    loc_4CF52-off_4CE5A
                dc.w    loc_4CF9A-off_4CE5A
                dc.w    loc_4CFAE-off_4CE5A
                dc.w    loc_4D010-off_4CE5A
                dc.w    loc_4D036-off_4CE5A
                dc.w    loc_4D066-off_4CE5A
                dc.w    loc_4D072-off_4CE5A
                dc.w    loc_4D082-off_4CE5A
                dc.w    loc_4D09E-off_4CE5A
                dc.w    loc_4D0CC-off_4CE5A
                dc.w    loc_4D0F2-off_4CE5A
                dc.w    loc_4D12E-off_4CE5A
                dc.w    loc_4D166-off_4CE5A
; ---------------------------------------------------------------------------

loc_4CE7A:
                addq.b  #2,subtype(a0)
                cmpi.b  #$A,subtype(a0)
                beq.s   loc_4CE94
                lea     word_4D480(pc),a1
                move.w  #4,$3E(a0)
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_4CE94:
                lea     word_4D486(pc),a1
                move.w  #3,$3E(a0)
                jsr     SetUp_ObjAttributes3(pc)
                move.b  #$86,collision_flags(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a1
                movea.w parent3(a1),a1
                movea.w parent3(a1),a1
                movea.w parent3(a1),a1
                move.w  a1,$44(a0)
                move.w  a1,$30(a1)
                move.w  a0,$32(a1)
                rts
; ---------------------------------------------------------------------------

loc_4CECA:
                jsr     Refresh_ChildPosition(pc)
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_4CEDC
                rts
; ---------------------------------------------------------------------------

loc_4CEDC:
                move.b  #4,routine(a0)
                bset    #3,$38(a0)
                bsr.w   SetFBZMinibossLinkDeploymentVelocity
                move.w  #$F,$2E(a0)
                move.l  #loc_4CF28,$34(a0)
                movea.w parent3(a0),a1
                move.w  $30(a1),$30(a0)
                move.w  $32(a1),$32(a0)
                btst    #0,render_flags(a1)
                beq.s   locret_4CF1C
                bset    #0,render_flags(a0)
                neg.w   x_vel(a0)

locret_4CF1C:
                rts
; ---------------------------------------------------------------------------

loc_4CF1E:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4CF28:
                move.b  #6,routine(a0)
                bclr    #3,$38(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$80,priority(a0)
                cmpi.b  #$A,subtype(a0)
                beq.s   locret_4CF50
                move.w  #$180,priority(a0)

locret_4CF50:
                rts
; ---------------------------------------------------------------------------

loc_4CF52:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_4CF60
                rts
; ---------------------------------------------------------------------------

loc_4CF60:
                move.b  #8,routine(a0)
                bset    #2,$38(a0)
                bclr    #3,$38(a0)
                bclr    #6,$38(a0)
                bclr    #1,$38(a0)
                move.b  $3C(a1),$3C(a0)
                move.b  $40(a1),$40(a0)
                move.b  subtype(a0),d0
                add.b   d0,d0
                move.b  d0,$3B(a0)
                move.b  d0,$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_4CF9A:
                subq.b  #1,$3B(a0)
                bpl.s   loc_4CFA6
                move.b  #$A,routine(a0)

loc_4CFA6:
                move.w  $3E(a0),d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------

loc_4CFAE:
                bsr.w   OscillateFBZMinibossArmAngle
                move.w  $3E(a0),d2
                jsr     MoveSprite_CircularSimple(pc)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_4CFD0
                btst    #6,$38(a1)
                bne.s   loc_4CFE4
                rts
; ---------------------------------------------------------------------------

loc_4CFD0:
                move.b  #$C,routine(a0)
                bset    #1,$38(a0)
                bclr    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_4CFE4:
                move.b  #$18,routine(a0)
                bset    #6,$38(a0)
                bclr    #2,$38(a0)
                cmpi.b  #$A,subtype(a0)
                bne.s   locret_4D00E
                lea     (Player_1).w,a1
                move.w  x_pos(a1),$30(a0)
                move.w  y_pos(a1),$32(a0)

locret_4D00E:
                rts
; ---------------------------------------------------------------------------

loc_4D010:
                bsr.w   ExtendFBZMinibossArmToSideAngle
                beq.s   loc_4D02E
                move.b  #$E,routine(a0)
                cmpi.b  #$A,subtype(a0)
                bne.s   loc_4D02E
                movea.w $44(a0),a1
                bset    #3,$38(a1)

loc_4D02E:
                move.w  $3E(a0),d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------

loc_4D036:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_4D04A
                move.w  $3E(a0),d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------

loc_4D04A:
                move.b  #$10,routine(a0)
                bset    #3,$38(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_4D06A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D066:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4D06A:
                move.b  #$12,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D072:
                move.b  #$14,d4
                bsr.w   FoldFBZMinibossLinksForBodyStrike
                move.w  $3E(a0),d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------

loc_4D082:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   loc_4D090
                rts
; ---------------------------------------------------------------------------

loc_4D090:
                move.b  #$16,routine(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D09E:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.w   loc_4CF60
                bsr.w   ReturnFBZMinibossArmToRestAngle
                beq.s   loc_4D0C4
                cmpi.b  #$A,subtype(a0)
                bne.s   loc_4D0C4
                movea.w $44(a0),a1
                bset    #2,$38(a1)

loc_4D0C4:
                move.w  $3E(a0),d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------

loc_4D0CC:
                bsr.w   RaiseFBZMinibossArmToVerticalAngle
                beq.s   loc_4D0EA
                move.b  #$1A,routine(a0)
                cmpi.b  #$A,subtype(a0)
                bne.s   loc_4D0EA
                movea.w $44(a0),a1
                bset    #3,$38(a1)

loc_4D0EA:
                move.w  $3E(a0),d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------

loc_4D0F2:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_4D106
                move.w  $3E(a0),d2
                jmp     MoveSprite_CircularSimple(pc)
; ---------------------------------------------------------------------------

loc_4D106:
                move.b  #$1C,routine(a0)
                bset    #3,$38(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_4D148,$34(a0)
                cmpi.b  #$A,subtype(a0)
                bne.w   locret_4CA0A
                bra.w   loc_4D34E
; ---------------------------------------------------------------------------

loc_4D12E:
                cmpi.b  #$A,subtype(a0)
                beq.s   loc_4D13E
                bsr.w   FBZMiniPunch_InterpolateLink
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4D13E:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4D148:
                move.b  #$1E,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_4D16A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D15E:
                move.b  #$16,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D166:
                jsr     Obj_Wait(pc)

loc_4D16A:
                move.b  #$1C,routine(a0)
                neg.w   x_vel(a0)
                neg.w   y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_4D15E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D188:
                move.l  #loc_4D196,(a0)
                lea     ObjDat3_4D4AA(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_4D196:
                bsr.w   FBZMini_SolidBodyOrCapsule
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_4D1B2
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4D1B2:
                jmp     (Delete_Current_Sprite).l
