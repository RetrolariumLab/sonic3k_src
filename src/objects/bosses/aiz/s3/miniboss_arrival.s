; Owner: objects/bosses/aiz/s3
; Responsibility: Angel Island miniboss arrival cutscene, flame actors and scene transitions
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZMinibossCutscene:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMinibossCutscene_Index(pc,d0.w),d1
                jsr     AIZMinibossCutscene_Index(pc,d1.w)
                bra.w   loc_46E80
; ---------------------------------------------------------------------------
AIZMinibossCutscene_Index:
                dc.w    loc_4645E-AIZMinibossCutscene_Index
                dc.w    loc_46482-AIZMinibossCutscene_Index
                dc.w    loc_464CA-AIZMinibossCutscene_Index
                dc.w    loc_46508-AIZMinibossCutscene_Index
                dc.w    loc_4654C-AIZMinibossCutscene_Index
; ---------------------------------------------------------------------------

loc_4645E:
                lea     ObjDat_AIZMiniboss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #$60,collision_property(a0)
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.b  #1,(Boss_flag).w
                moveq   #PLCID_5A,d0
                jmp     (Load_PLC).l
; ---------------------------------------------------------------------------

loc_46482:
                move.w  (Camera_X_pos).w,d0
                move.w  #$2F10,d5
                cmp.w   d5,d0
                bhs.s   loc_46490
                rts
; ---------------------------------------------------------------------------

loc_46490:
                move.l  #loc_464D0,$34(a0)
                lea     ChildObjDat_46F80(pc),a2
                jsr     (CreateChild3_NormalRepeated).l
                lea     Pal_AIZMiniboss(pc),a1
                jsr     (PalLoad_Line1).l

loc_464AC:
                move.b  #4,routine(a0)
                move.w  #3*60,$2E(a0)
                move.w  d5,(Camera_min_X_pos).w
                move.w  d5,(Camera_max_X_pos).w
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l

locret_464C8:
                rts
; ---------------------------------------------------------------------------

loc_464CA:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_464D0:
                move.l  #loc_4650E,$34(a0)
                move.b  #6,routine(a0)
                lea     ChildObjDat_46F72(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     ChildObjDat_46F88(pc),a2
                jsr     (CreateChild1_Normal).l

; =============== S U B R O U T I N E =======================================

sub_464F2:
                move.w  #$100,y_vel(a0)
                move.w  #$AF,$2E(a0)
                moveq   #signextendB(mus_Miniboss),d0
                jsr     (Play_Music).l
                rts
; End of function sub_464F2

; ---------------------------------------------------------------------------

loc_46508:
                jmp     (MoveWaitTouch).l
; ---------------------------------------------------------------------------

loc_4650E:
                move.w  #$7F,$2E(a0)
                move.l  #loc_4657E,$34(a0)
                move.b  #3,$39(a0)
                bset    #1,$38(a0)

loc_46528:
                move.b  #8,routine(a0)
                clr.w   y_vel(a0)

; =============== S U B R O U T I N E =======================================

Swing_Setup1:
                move.w  #$C0,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)
                rts
; End of function Swing_Setup1

; ---------------------------------------------------------------------------

loc_4654C:
                jsr     (Swing_UpAndDown).l
                jmp     (MoveWaitTouch).l
; ---------------------------------------------------------------------------
; unused
                subq.b  #1,$39(a0)
                bpl.s   loc_46566
                move.l  #loc_4657E,$34(a0)

loc_46566:
                move.w  #$40,$2E(a0)
                moveq   #signextendB(sfx_FlamethrowerQuiet),d0
                jsr     (Play_SFX).l
                lea     Child1_AIZ_MinibossFlames(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_4657E:
                move.w  #$10,$2E(a0)
                move.l  #loc_46596,$34(a0)
                lea     ChildObjDat_4701A(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_46596:
                move.l  #loc_465E0,(a0)
                lea     Pal_AIZMiniboss(pc),a1
                jsr     (PalLoad_Line1).l
                move.b  #$F,collision_flags(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #$400,x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$40,$2E(a0)
                cmpi.w  #0,(Current_zone_and_act).w
                bne.s   loc_465D2
                move.w  #$120,$2E(a0)

loc_465D2:
                move.l  #Go_Delete_Sprite,$34(a0)
                st      (Events_fg_5).w
                rts
; ---------------------------------------------------------------------------

loc_465E0:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bmi.s   loc_465F2
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_465F2:
                clr.b   (Boss_flag).w
                jsr     (Restore_LevelMusic).l
                lea     (PLC_Monitors).l,a1
                jsr     (Load_PLC_Raw).l
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

loc_4660E:
                jsr     (Refresh_ChildPositionAdjusted).l
                lea     word_46F20(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                bset    #4,shield_reaction(a0)
                move.l  #byte_4703C,$30(a0)
                move.l  #loc_46638,(a0)
                jmp     (Child_DrawTouch_Sprite2).l
; ---------------------------------------------------------------------------

loc_46638:
                jsr     (Refresh_ChildPositionAdjusted).l
                jsr     (Animate_Raw).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.s   loc_46654
                clr.b   collision_flags(a0)

loc_46654:
                jmp     (Child_DrawTouch_Sprite2).l
; ---------------------------------------------------------------------------

loc_4665A:
                jsr     (Refresh_ChildPositionAdjusted).l
                move.l  #loc_46670,(a0)
                lea     word_46F28(pc),a1
                jmp     (SetUp_ObjAttributes2).l
; ---------------------------------------------------------------------------

loc_46670:
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_4667C:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_46696(pc,d0.w),d1
                jsr     off_46696(pc,d1.w)
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
off_46696:
                dc.w    loc_466A4-off_46696
                dc.w    loc_466AE-off_46696
                dc.w    loc_466CE-off_46696
                dc.w    loc_466EC-off_46696
                dc.w    loc_4672C-off_46696
                dc.w    loc_466EC-off_46696
                dc.w    locret_464C8-off_46696
; ---------------------------------------------------------------------------

loc_466A4:
                lea     word_46F30(pc),a1
                jmp     (SetUp_ObjAttributes2).l
; ---------------------------------------------------------------------------

loc_466AE:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_466BC
                rts
; ---------------------------------------------------------------------------

loc_466BC:
                move.b  #4,routine(a0)
                move.l  #loc_466D4,$34(a0)
                bra.w   loc_46DDE
; ---------------------------------------------------------------------------

loc_466CE:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_466D4:
                move.l  #loc_466F2,$34(a0)

loc_466DC:
                move.b  #6,routine(a0)
                move.l  #byte_47045,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_466EC:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_466F2:
                move.b  #8,routine(a0)
                move.b  #3,$39(a0)
                move.l  #loc_46706,$34(a0)

loc_46706:
                move.w  #$1C,$2E(a0)
                subq.b  #1,$39(a0)
                cmpi.b  #1,$39(a0)
                beq.s   loc_46722
                lea     ChildObjDat_46FB0(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_46722:
                lea     ChildObjDat_46FBE(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_4672C:
                jsr     (Obj_Wait).l
                tst.b   $39(a0)
                bmi.s   loc_4673A
                rts
; ---------------------------------------------------------------------------

loc_4673A:
                move.b  #$A,routine(a0)
                move.l  #byte_4704C,$30(a0)
                move.l  #loc_46752,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_46752:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_4675A:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_46774(pc,d0.w),d1
                jsr     off_46774(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_46774:
                dc.w    loc_46778-off_46774
                dc.w    loc_466EC-off_46774
; ---------------------------------------------------------------------------

loc_46778:
                lea     word_46F38(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #byte_47055,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_46794:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_467A2(pc,d0.w),d1
                jmp     off_467A2(pc,d1.w)
; ---------------------------------------------------------------------------
off_467A2:
                dc.w    sub_467AA-off_467A2
                dc.w    loc_467DE-off_467A2
                dc.w    loc_464CA-off_467A2
                dc.w    loc_467DE-off_467A2

; =============== S U B R O U T I N E =======================================

sub_467AA:
                lea     word_46F40(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                move.l  #byte_47062,$30(a0)
                move.l  #loc_467EA,$34(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$60,$2E(a0)
                jmp     (Draw_Sprite).l
; End of function sub_467AA

; ---------------------------------------------------------------------------

loc_467DE:
                jsr     (Move_AnimateRaw_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_467EA:
                move.b  #4,routine(a0)
                move.w  #8,$2E(a0)
                move.l  #loc_46800,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_46800:
                move.b  #6,routine(a0)
                moveq   #signextendB(sfx_MissileThrow),d0
                jsr     (Play_SFX).l
                move.w  #$80,priority(a0)
                bset    #1,render_flags(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.w  #$60,$2E(a0)
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  subtype(a1),d0
                bsr.w   loc_46E02
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

Obj_AIZMiniboss_Flame:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMiniboss_Flame_Index(pc,d0.w),d1
                jmp     AIZMiniboss_Flame_Index(pc,d1.w)
; ---------------------------------------------------------------------------
AIZMiniboss_Flame_Index:
                dc.w    sub_4685E-AIZMiniboss_Flame_Index
                dc.w    loc_464CA-AIZMiniboss_Flame_Index
                dc.w    loc_468A6-AIZMiniboss_Flame_Index

; =============== S U B R O U T I N E =======================================

sub_4685E:
                lea     ObjDat_AIZMiniboss_Flame(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #4,shield_reaction(a0)
                move.l  #loc_4688E,$34(a0)
                moveq   #6,d1

loc_46878:
                moveq   #0,d0
                move.b  subtype(a0),d0
                sub.w   d0,d1
                add.b   d1,d1
                move.w  d1,$2E(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_4688E:
                move.b  #4,routine(a0)
                move.l  #byte_47075,$30(a0)
                move.l  #loc_468B2,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_468A6:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_468B2:
                move.l  #Map_BossExplosion,mappings(a0)
                move.w  #make_art_tile(ArtTile_BossExplosion2,0,1),art_tile(a0)
                move.l  #byte_4707A,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                cmpi.b  #6,subtype(a0)
                bne.w   locret_464C8
                lea     ChildObjDat_46FE6(pc),a2
                jmp     (CreateChild1_Normal).l
; End of function sub_4685E

; ---------------------------------------------------------------------------

loc_468E4:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_468F8(pc,d0.w),d1
                jsr     off_468F8(pc,d1.w)
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
off_468F8:
                dc.w    loc_468FC-off_468F8
                dc.w    loc_46948-off_468F8
; ---------------------------------------------------------------------------

loc_468FC:
                bsr.w   sub_4685E
                move.w  #$100,priority(a0)
                move.l  #byte_47085,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a1
                move.w  a1,parent3(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.w  #-$60,d0
                btst    #0,render_flags(a1)
                beq.s   loc_4693C
                neg.w   d0
                bset    #0,render_flags(a0)

loc_4693C:
                move.w  x_pos(a1),d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_46948:
                jsr     (Animate_RawMultiDelay).l
                tst.w   d2
                beq.s   locret_46966
                bmi.s   locret_46966
                move.w  word_46968(pc,d0.w),d0
                btst    #0,render_flags(a0)
                bne.s   loc_46962
                neg.w   d0

loc_46962:
                add.w   d0,x_pos(a0)

locret_46966:
                rts
; ---------------------------------------------------------------------------
word_46968:
                dc.w    0
                dc.w    0
                dc.w    0
                dc.w    $10
                dc.w    8
                dc.w    8
