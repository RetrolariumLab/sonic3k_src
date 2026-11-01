; Owner: objects/bosses/fbz/s3
; Responsibility: Flying Battery end-boss lifecycle, attacks, child actors, helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZEndBoss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZEndBoss_Index(pc,d0.w),d1
                jsr     FBZEndBoss_Index(pc,d1.w)
                bsr.w   HandleFBZEndBossFourColorHitOrDefeat
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
FBZEndBoss_Index:
                dc.w    loc_4DBC0-FBZEndBoss_Index
                dc.w    loc_4DC26-FBZEndBoss_Index
                dc.w    loc_4DC40-FBZEndBoss_Index
                dc.w    loc_4DC6A-FBZEndBoss_Index
                dc.w    loc_4DCDA-FBZEndBoss_Index
; ---------------------------------------------------------------------------

loc_4DBC0:
                lea     ObjDat_FBZEndBoss(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #8,collision_property(a0)
                move.b  #1,(Boss_flag).w
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  #$3090,(Camera_max_X_pos).w
                moveq   #PLCID_6F,d0
                jsr     (Load_PLC).l
                lea     Pal_FBZEndBoss(pc),a1
                jsr     (PalLoad_Line1).l
                move.w  #2*60,$2E(a0)
                move.l  #loc_4DC30,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                lea     (Child1_MakeFBZRoboShip).l,a2
                jsr     CreateChild1_Normal(pc)
                bne.s   loc_4DC1E
                move.b  #$B,subtype(a1)
                move.w  a1,$3E(a0)

loc_4DC1E:
                lea     ChildObjDat_4E2C0(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_4DC26:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4DC30:
                move.b  #4,routine(a0)
                moveq   #signextendB(mus_EndBoss),d0
                jsr     (Play_Music).l

locret_4DC3E:
                rts
; ---------------------------------------------------------------------------

loc_4DC40:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                move.w  #$3090,d0
                cmp.w   (Camera_X_pos).w,d0
                bls.s   loc_4DC52
                rts
; ---------------------------------------------------------------------------

loc_4DC52:
                move.w  d0,(Camera_min_X_pos).w

loc_4DC56:
                move.b  #6,routine(a0)
                move.w  #$3F,$2E(a0)
                move.b  #9,$39(a0)
                rts
; ---------------------------------------------------------------------------

loc_4DC6A:
                bsr.w   CenterFBZEndBossXBetweenSupports
                jsr     Find_SonicTails(pc)
                btst    #1,$38(a0)
                bne.s   locret_4DCB6
                cmpi.w  #$18,d2
                bhs.s   loc_4DC8E
                btst    #Status_InAir,status(a1)
                bne.s   loc_4DC8E
                bset    #1,$38(a0)

loc_4DC8E:
                subq.w  #1,$2E(a0)
                bpl.s   locret_4DCB6
                move.w  #$1F,$2E(a0)
                subq.b  #1,$39(a0)
                bmi.s   loc_4DCB8
                bset    #3,$38(a0)
                bclr    #0,render_flags(a0)
                tst.w   d0
                bne.s   locret_4DCB6
                bset    #0,render_flags(a0)

locret_4DCB6:
                rts
; ---------------------------------------------------------------------------

loc_4DCB8:
                move.b  #8,routine(a0)
                bset    #2,$38(a0)
                move.b  #2,$40(a0)
                move.w  #$1FF,$2E(a0)
                move.l  #loc_4DCF4,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4DCDA:
                move.b  $40(a0),d0
                add.b   d0,$3C(a0)
                lea     (FBZEndBoss_CircleLookup1).l,a2
                jsr     MoveSprite_AngleYLookup(pc)
                bsr.w   SetFBZEndBossBodyDepthFromPhase
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4DCF4:
                bclr    #2,$38(a0)
                bra.w   loc_4DC56
; ---------------------------------------------------------------------------

loc_4DCFE:
                tst.b   $3C(a0)
                beq.s   loc_4DD20
                move.b  $40(a0),d0
                add.b   d0,$3C(a0)
                lea     (FBZEndBoss_CircleLookup1).l,a2
                jsr     MoveSprite_AngleYLookup(pc)
                bsr.w   SetFBZEndBossBodyDepthFromPhase
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4DD20:
                move.l  #Wait_Draw,(a0)
                move.w  #$280,priority(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_4DD3C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4DD3C:
                move.l  #Obj_Wait,(a0)
                bset    #4,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_4DD66,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                lea     ChildObjDat_4E2EA(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_4DD66:
                move.l  #Obj_Wait,(a0)
                bclr    #7,render_flags(a0)
                st      (_unkFAA8).w
                move.w  #$7F,$2E(a0)
                move.l  #loc_4DD8A,$34(a0)
                jmp     (Restore_LevelMusic).l
; ---------------------------------------------------------------------------

loc_4DD8A:
                move.l  #loc_4DDA6,(a0)
                clr.b   (Boss_flag).w
                move.w  #$3170,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_4DDA6:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                tst.b   (_unkFAA8).w
                bne.w   locret_4DC3E
                clr.b   (_unkFAA8).w
                jsr     Restore_PlayerControl(pc)
                lea     (Player_2).w,a1
                jsr     Restore_PlayerControl2(pc)
                move.w  #$6000,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jsr     (CreateChild6_Simple).l
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

loc_4DDDC:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4DDEE(pc,d0.w),d1
                jsr     off_4DDEE(pc,d1.w)
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
off_4DDEE:
                dc.w    loc_4DDF6-off_4DDEE
                dc.w    loc_4DE1C-off_4DDEE
                dc.w    loc_4DE7C-off_4DDEE
                dc.w    loc_4DE96-off_4DDEE
; ---------------------------------------------------------------------------

loc_4DDF6:
                lea     word_4E284(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                lea     ChildObjDat_4E2D4(pc),a2
                jsr     CreateChild1_Normal(pc)
                movea.w parent3(a0),a1
                tst.b   subtype(a0)
                bne.s   loc_4DE16
                move.w  a0,$44(a1)
                rts
; ---------------------------------------------------------------------------

loc_4DE16:
                move.w  a0,parent3(a1)
                rts
; ---------------------------------------------------------------------------

loc_4DE1C:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_4DE60
                btst    #3,$38(a1)
                bne.s   loc_4DE32
                rts
; ---------------------------------------------------------------------------

loc_4DE32:
                move.b  #4,routine(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                btst    #0,render_flags(a1)
                beq.s   loc_4DE4A
                addq.w  #8,d0

loc_4DE4A:
                lea     word_4DE6C(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,$2E(a0)
                move.l  #loc_4DE80,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4DE60:
                lea     ChildObjDat_4E304(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     Go_Delete_Sprite_2(pc)
; ---------------------------------------------------------------------------
word_4DE6C:
                dc.w    $100,     7
                dc.w    $100,     0
                dc.w    -$100,     0
                dc.w    -$100,     7
; ---------------------------------------------------------------------------

loc_4DE7C:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4DE80:
                move.b  #6,routine(a0)
                move.w  #7,$2E(a0)
                move.l  #loc_4DEA0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4DE96:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4DEA0:
                move.b  #2,routine(a0)
                movea.w parent3(a0),a1
                bclr    #3,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_4DEB2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4DEC6(pc,d0.w),d1
                jsr     off_4DEC6(pc,d1.w)
                moveq   #0,d0
                jmp     Child_Draw_Sprite2_FlickerMove(pc)
; ---------------------------------------------------------------------------
off_4DEC6:
                dc.w    loc_4DECC-off_4DEC6
                dc.w    loc_4DEF2-off_4DEC6
                dc.w    loc_4DF20-off_4DEC6
; ---------------------------------------------------------------------------

loc_4DECC:
                lea     word_4E28A(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                movea.w parent3(a0),a1
                tst.b   subtype(a1)
                beq.s   loc_4DEE4
                bset    #0,render_flags(a0)

loc_4DEE4:
                move.w  parent3(a1),$44(a0)
                lea     ChildObjDat_4E2DC(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

loc_4DEF2:
                jsr     Refresh_ChildPosition(pc)
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_4DF04
                rts
; ---------------------------------------------------------------------------

loc_4DF04:
                move.b  #4,routine(a0)
                move.b  #2,$40(a0)
                move.w  #$1FF,$2E(a0)
                move.l  #loc_4DF3C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4DF20:
                movea.w $44(a0),a1
                move.b  $3C(a1),$3C(a0)
                lea     (FBZEndBoss_CircleLookup2).l,a2
                jsr     MoveSprite_AngleYLookup(pc)
                bsr.w   SetFBZEndBossHingeDepthFromPhase
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4DF3C:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_4DF44:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4DF58(pc,d0.w),d1
                jsr     off_4DF58(pc,d1.w)
                moveq   #8,d0
                jmp     Child_Draw_Sprite_FlickerMove(pc)
; ---------------------------------------------------------------------------
off_4DF58:
                dc.w    loc_4DF5C-off_4DF58
                dc.w    loc_4DF90-off_4DF58
; ---------------------------------------------------------------------------

loc_4DF5C:
                lea     word_4E28A(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                movea.w parent3(a0),a1
                moveq   #-$1C,d0
                btst    #0,render_flags(a1)
                beq.s   loc_4DF7A
                bset    #0,render_flags(a0)
                neg.w   d0

loc_4DF7A:
                movea.w parent3(a1),a1
                move.w  parent3(a1),$44(a0)
                move.b  d0,child_dx(a0)
                move.b  #2,child_dy(a0)
                rts
; ---------------------------------------------------------------------------

loc_4DF90:
                jsr     Child_GetPriority(pc)
                bra.w   loc_4E082
; ---------------------------------------------------------------------------

loc_4DF98:
                lea     word_4E290(pc),a1
                jsr     SetUp_ObjAttributes3(pc)

loc_4DFA0:
                move.l  #loc_4DFB2,(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_4DFB2:
                jsr     Child_GetPriority(pc)
                btst    #7,status(a1)
                bne.s   loc_4DFEC
                btst    #1,$38(a1)
                beq.s   loc_4DFE2
                move.l  #Refresh_ChildPosWait,(a0)
                move.w  #$5F,$2E(a0)
                move.l  #loc_4DFA0,$34(a0)
                lea     ChildObjDat_4E2E4(pc),a2
                jsr     CreateChild6_Simple(pc)

loc_4DFE2:
                jsr     Refresh_ChildPosition(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4DFEC:
                move.l  #loc_4E006,(a0)
                move.w  $3E(a1),$46(a0)
                subq.b  #4,child_dy(a0)
                jsr     Refresh_ChildPosition(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4E006:
                jsr     Refresh_ChildPosition(pc)
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_4E00E:
                bsr.w   InitializeFBZEndBossFlameColumnPart
                move.l  #Obj_Wait,(a0)
                move.l  #loc_4E022,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4E022:
                move.l  #loc_53CFA,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4E032:
                lea     word_4E296(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #8,d0
                move.b  d0,mapping_frame(a0)
                moveq   #$34,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------

loc_4E05A:
                lea     word_4E296(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$C,d0
                move.b  d0,mapping_frame(a0)
                moveq   #8,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------

loc_4E082:
                movea.w $44(a0),a1
                movea.w parent3(a0),a2
                move.w  x_pos(a1),d0
                move.b  child_dx(a0),d1
                ext.w   d1
                add.w   d0,d1
                move.w  x_pos(a2),d2
                sub.w   d2,d1
                moveq   #$10,d3
                moveq   #0,d4
                move.b  subtype(a0),d4
                bsr.w   PositionFBZEndBossConnectorAxisByQuarter
                move.w  y_pos(a1),d0
                move.b  child_dy(a0),d1
                ext.w   d1
                add.w   d0,d1
                move.w  y_pos(a2),d2
                sub.w   d2,d1
                moveq   #$14,d3
                bsr.w   PositionFBZEndBossConnectorAxisByQuarter
                tst.b   $3C(a2)
                beq.s   locret_4E0CE
                bmi.s   locret_4E0CE
                move.w  word_4E0D0(pc,d4.w),priority(a0)

locret_4E0CE:
                rts
; ---------------------------------------------------------------------------
word_4E0D0:
                dc.w    $200
                dc.w    $180
                dc.w    $100
                dc.w    $80

; =============== S U B R O U T I N E =======================================

PositionFBZEndBossConnectorAxisByQuarter:
                move.w  off_4E0E0(pc,d4.w),d5
                jmp     off_4E0E0(pc,d5.w)
; End of function PositionFBZEndBossConnectorAxisByQuarter

; ---------------------------------------------------------------------------
off_4E0E0:
                dc.w    loc_4E0E8-off_4E0E0
                dc.w    loc_4E0EE-off_4E0E0
                dc.w    loc_4E0F4-off_4E0E0
                dc.w    loc_4E0FC-off_4E0E0
; ---------------------------------------------------------------------------

loc_4E0E8:
                asr.w   #2,d1
                bra.w   loc_4E0FC
; ---------------------------------------------------------------------------

loc_4E0EE:
                asr.w   #1,d1
                bra.w   loc_4E0FC
; ---------------------------------------------------------------------------

loc_4E0F4:
                asr.w   #1,d1
                move.w  d1,d0
                asr.w   #1,d1
                add.w   d0,d1

loc_4E0FC:
                add.w   d1,d2
                move.w  d2,(a0,d3.w)
                rts

; =============== S U B R O U T I N E =======================================

InitializeFBZEndBossFlameColumnPart:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_4E130(pc,d0.w),$2E(a0)
                move.w  byte_4E142(pc,d0.w),child_dx(a0)  ; and child_dy
                add.w   d0,d0
                move.l  off_4E154(pc,d0.w),$30(a0)
                movea.l off_4E178(pc,d0.w),a1
                jsr     SetUp_ObjAttributes(pc)
                bset    #4,shield_reaction(a0)
                jmp     Refresh_ChildPosition(pc)
; End of function InitializeFBZEndBossFlameColumnPart

; ---------------------------------------------------------------------------
word_4E130:
                dc.w    $50
                dc.w    $4D
                dc.w    $4A
                dc.w    $47
                dc.w    $44
                dc.w    $41
                dc.w    $3E
                dc.w    $3B
                dc.w    0
byte_4E142:
                dc.b    0,-$68
                dc.b    8,-$5C
                dc.b    -8,-$5C
                dc.b    0,-$4C
                dc.b    0,-$3C
                dc.b    0,-$2C
                dc.b    0,-$1C
                dc.b    0, -$C
                dc.b    0,-$10
off_4E154:
                dc.l    byte_4E350
                dc.l    byte_4E350
                dc.l    byte_4E350
                dc.l    byte_4E341
                dc.l    byte_4E341
                dc.l    byte_4E341
                dc.l    byte_4E341
                dc.l    byte_4E341
                dc.l    byte_4E31E
off_4E178:
                dc.l    ObjDat3_4E2B4
                dc.l    ObjDat3_4E2B4
                dc.l    ObjDat3_4E2B4
                dc.l    ObjDat3_4E2A8
                dc.l    ObjDat3_4E2A8
                dc.l    ObjDat3_4E2A8
                dc.l    ObjDat3_4E2A8
                dc.l    ObjDat3_4E2A8
                dc.l    ObjDat3_4E29C

; =============== S U B R O U T I N E =======================================

CenterFBZEndBossXBetweenSupports:
                movea.w $44(a0),a1
                movea.w parent3(a0),a2
                move.w  x_pos(a1),d0
                move.w  x_pos(a2),d1
                sub.w   d0,d1
                asr.w   #1,d1
                add.w   d1,d0
                move.w  d0,x_pos(a0)
                rts
; End of function CenterFBZEndBossXBetweenSupports

; =============== S U B R O U T I N E =======================================

SetFBZEndBossBodyDepthFromPhase:
                tst.b   $3C(a0)
                beq.s   loc_4E1DC
                bmi.s   loc_4E1CE
                bset    #7,art_tile(a0)
                move.w  #$80,priority(a0)
                rts
; ---------------------------------------------------------------------------

loc_4E1CE:
                bclr    #7,art_tile(a0)
                move.w  #$380,priority(a0)
                rts
; ---------------------------------------------------------------------------

loc_4E1DC:
                bset    #7,art_tile(a0)
                move.w  #$380,priority(a0)
                rts
; End of function SetFBZEndBossBodyDepthFromPhase

; =============== S U B R O U T I N E =======================================

SetFBZEndBossHingeDepthFromPhase:
                tst.b   $3C(a0)
                beq.s   loc_4E1DC
                bmi.s   loc_4E1CE
                bset    #7,art_tile(a0)
                move.w  #$280,priority(a0)
                rts
; End of function SetFBZEndBossHingeDepthFromPhase

; =============== S U B R O U T I N E =======================================

HandleFBZEndBossFourColorHitOrDefeat:
                tst.l   (a0)
                beq.s   locret_4E254
                tst.b   collision_flags(a0)
                bne.s   locret_4E254
                tst.b   collision_property(a0)
                beq.s   loc_4E256
                tst.b   $20(a0)
                bne.s   loc_4E224
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_4E224:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_4E236
                addq.w  #2*4,d0

loc_4E236:
                lea     word_4E260(pc),a1
                lea     word_4E268(pc,d0.w),a2
                jsr     CopyWordData_4(pc)
                subq.b  #1,$20(a0)
                bne.s   locret_4E254
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_4E254:
                rts
; ---------------------------------------------------------------------------

loc_4E256:
                move.l  #loc_4DCFE,(a0)
                jmp     BossDefeated_StopTimer(pc)
; End of function HandleFBZEndBossFourColorHitOrDefeat

; ---------------------------------------------------------------------------
word_4E260:
                dc.w    Normal_palette_line_2+$06, Normal_palette_line_2+$08, Normal_palette_line_2+$12, Normal_palette_line_2+$1C
word_4E268:
                dc.w    $2A,   $26,   $20,  $644
                dc.w    $888,  $AAA,  $EEE,  $AAA
ObjDat_FBZEndBoss:
                dc.l    Map_FBZEndBoss
                dc.w    make_art_tile(ArtTile_FBZEndBoss-$20,1,1)
                dc.w    $280
                dc.b    $28, $18,   0, $16
word_4E284:
                dc.w    $300
                dc.b    $10, $20,   1, $A3
word_4E28A:
                dc.w    $280
                dc.b    8,   8,   2,   0
word_4E290:
                dc.w    $200
                dc.b    $C,   8,   3,   0
word_4E296:
                dc.w    $100
                dc.b    $14, $10,   8,   0
ObjDat3_4E29C:
                dc.l    Map_FBZEndBoss
                dc.w    make_art_tile(ArtTile_FBZEndBoss-$20,0,1)
                dc.w    $80
                dc.b    4,   8,   4, $8B
ObjDat3_4E2A8:
                dc.l    Map_BossExplosion
                dc.w    make_art_tile(ArtTile_BossExplosion,0,1)
                dc.w    $80
                dc.b    $10, $10,   0, $8B
ObjDat3_4E2B4:
                dc.l    Map_FBZEndBossFlame
                dc.w    make_art_tile(ArtTile_FBZEndBossFlame+$4,0,1)
                dc.w    $80
                dc.b    $10, $10,   0, $8B
ChildObjDat_4E2C0:
                dc.w    3-1
                dc.l    loc_4DDDC
                dc.b    -$30,-$48
                dc.l    loc_4DDDC
                dc.b    $30,-$48
                dc.l    loc_4DF98
                dc.b    0,-$28
ChildObjDat_4E2D4:
                dc.w    1-1
                dc.l    loc_4DEB2
                dc.b    0, $20
ChildObjDat_4E2DC:
                dc.w    4-1
                dc.l    loc_4DF44
                dc.b    0,   0
ChildObjDat_4E2E4:
                dc.w    9-1
                dc.l    loc_4E00E
ChildObjDat_4E2EA:
                dc.w    4-1
                dc.l    loc_4E032
                dc.b    -$14,   8
                dc.l    loc_4E032
                dc.b    $14,   8
                dc.l    loc_4E032
                dc.b    -$10, $20
                dc.l    loc_4E032
                dc.b    $10, $20
ChildObjDat_4E304:
                dc.w    4-1
                dc.l    loc_4E05A
                dc.b    -8,-$10
                dc.l    loc_4E05A
                dc.b    8,-$10
                dc.l    loc_4E05A
                dc.b    -8, $10
                dc.l    loc_4E05A
                dc.b    8, $10
byte_4E31E:
                dc.b    4,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    6,   3
                dc.b    7,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    6,   3
                dc.b    7,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    6,   3
                dc.b    7,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    6,   3
                dc.b    7,   3
                dc.b    $F4
byte_4E341:
                dc.b    0,   2
                dc.b    0,   2
                dc.b    1,   2
                dc.b    2,   3
                dc.b    3,   4
                dc.b    4,   5
                dc.b    5,   6
                dc.b    $F4
byte_4E350:
                dc.b    0,   2
                dc.b    0,   2
                dc.b    1,   3
                dc.b    2,   4
                dc.b    3,   5
                dc.b    4,   6
                dc.b    $F4
                even
Pal_FBZEndBoss:
                binclude "data/Levels/FBZ/Palettes/FBZ End Boss.bin"
                even
