; Owner: objects/bosses/aiz/sk
; Responsibility: Angel Island miniboss arrival cutscene, fire effects, movement helpers and private scene resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZMinibossCutscene:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZMinibossCutscene_Index(pc,d0.w),d1
                jsr     AIZMinibossCutscene_Index(pc,d1.w)
                bra.w   loc_68F62
; ---------------------------------------------------------------------------
AIZMinibossCutscene_Index:
                dc.w    loc_68508-AIZMinibossCutscene_Index
                dc.w    loc_6852C-AIZMinibossCutscene_Index
                dc.w    loc_68574-AIZMinibossCutscene_Index
                dc.w    loc_685B8-AIZMinibossCutscene_Index
                dc.w    loc_685FC-AIZMinibossCutscene_Index
; ---------------------------------------------------------------------------

loc_68508:
                lea     ObjDat_AIZMiniboss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #$60,collision_property(a0)
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.b  #1,(Boss_flag).w
                moveq   #PLCID_5A,d0
                jmp     (Load_PLC).l
; ---------------------------------------------------------------------------

loc_6852C:
                move.w  (Camera_X_pos).w,d0
                move.w  #$2F10,d5
                cmp.w   d5,d0
                bhs.s   loc_6853A
                rts
; ---------------------------------------------------------------------------

loc_6853A:
                move.l  #loc_6857A,$34(a0)
                lea     ChildObjDat_6906A(pc),a2
                jsr     (CreateChild3_NormalRepeated).l
                lea     Pal_AIZMiniboss(pc),a1
                jsr     (PalLoad_Line1).l

loc_68556:
                move.b  #4,routine(a0)
                move.w  #3*60,$2E(a0)
                move.w  d5,(Camera_min_X_pos).w
                move.w  d5,(Camera_max_X_pos).w
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l

locret_68572:
                rts
; ---------------------------------------------------------------------------

loc_68574:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6857A:
                move.l  #loc_685BE,$34(a0)
                move.b  #6,routine(a0)
                lea     ChildObjDat_6905C(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     ChildObjDat_69072(pc),a2
                jsr     (CreateChild1_Normal).l

; =============== S U B R O U T I N E =======================================

sub_6859C:
                move.w  #$100,y_vel(a0)
                move.w  #$AF,$2E(a0)
                moveq   #signextendB(mus_Miniboss),d0
                jsr     (Play_Music).l
                move.b  #mus_Miniboss,(Current_music+1).w
                rts
; End of function sub_6859C

; ---------------------------------------------------------------------------

loc_685B8:
                jmp     (MoveWaitTouch).l
; ---------------------------------------------------------------------------

loc_685BE:
                move.w  #$7F,$2E(a0)
                move.l  #loc_6862E,$34(a0)
                move.b  #3,$39(a0)
                bset    #1,$38(a0)

loc_685D8:
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

loc_685FC:
                jsr     (Swing_UpAndDown).l
                jmp     (MoveWaitTouch).l
; ---------------------------------------------------------------------------
; unused
                subq.b  #1,$39(a0)
                bpl.s   loc_68616
                move.l  #loc_6862E,$34(a0)

loc_68616:
                move.w  #$40,$2E(a0)
                moveq   #signextendB(sfx_FlamethrowerQuiet),d0
                jsr     (Play_SFX).l
                lea     Child1_AIZ_MinibossFlames(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6862E:
                move.w  #$10,$2E(a0)
                move.l  #loc_68646,$34(a0)
                lea     ChildObjDat_69104(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_68646:
                move.l  #loc_68690,(a0)
                lea     Pal_AIZMiniboss(pc),a1
                jsr     (PalLoad_Line1).l
                move.b  #$F,collision_flags(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #$400,x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$40,$2E(a0)
                cmpi.w  #0,(Current_zone_and_act).w
                bne.s   loc_68682
                move.w  #$120,$2E(a0)

loc_68682:
                move.l  #Go_Delete_Sprite,$34(a0)
                st      (Events_fg_5).w
                rts
; ---------------------------------------------------------------------------

loc_68690:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bmi.s   loc_686A2
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_686A2:
                clr.b   (Boss_flag).w
                jsr     (Restore_LevelMusic).l
                lea     (PLC_Monitors).l,a1
                jsr     (Load_PLC_Raw).l
                jmp     (Go_Delete_Sprite_2).l
; ---------------------------------------------------------------------------

loc_686BE:
                jsr     (Refresh_ChildPositionAdjusted).l
                lea     word_6900A(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                bset    #4,shield_reaction(a0)
                move.l  #byte_69126,$30(a0)
                move.l  #loc_686E8,(a0)
                jmp     (Child_DrawTouch_Sprite2).l
; ---------------------------------------------------------------------------

loc_686E8:
                jsr     (Refresh_ChildPositionAdjusted).l
                jsr     (Animate_Raw).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.s   loc_68704
                clr.b   collision_flags(a0)

loc_68704:
                jmp     (Child_DrawTouch_Sprite2).l
; ---------------------------------------------------------------------------

loc_6870A:
                jsr     (Refresh_ChildPositionAdjusted).l
                move.l  #loc_68720,(a0)
                lea     word_69012(pc),a1
                jmp     (SetUp_ObjAttributes2).l
; ---------------------------------------------------------------------------

loc_68720:
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_6872C:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_68746(pc,d0.w),d1
                jsr     off_68746(pc,d1.w)
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
off_68746:
                dc.w    loc_68754-off_68746
                dc.w    loc_6875E-off_68746
                dc.w    loc_6877E-off_68746
                dc.w    loc_6879C-off_68746
                dc.w    loc_687DC-off_68746
                dc.w    loc_6879C-off_68746
                dc.w    locret_68572-off_68746
; ---------------------------------------------------------------------------

loc_68754:
                lea     word_6901A(pc),a1
                jmp     (SetUp_ObjAttributes2).l
; ---------------------------------------------------------------------------

loc_6875E:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_6876C
                rts
; ---------------------------------------------------------------------------

loc_6876C:
                move.b  #4,routine(a0)
                move.l  #loc_68784,$34(a0)
                bra.w   loc_68EC0
; ---------------------------------------------------------------------------

loc_6877E:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_68784:
                move.l  #loc_687A2,$34(a0)

loc_6878C:
                move.b  #6,routine(a0)
                move.l  #byte_6912F,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_6879C:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_687A2:
                move.b  #8,routine(a0)
                move.b  #3,$39(a0)
                move.l  #loc_687B6,$34(a0)

loc_687B6:
                move.w  #$1C,$2E(a0)
                subq.b  #1,$39(a0)
                cmpi.b  #1,$39(a0)
                beq.s   loc_687D2
                lea     ChildObjDat_6909A(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_687D2:
                lea     ChildObjDat_690A8(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_687DC:
                jsr     (Obj_Wait).l
                tst.b   $39(a0)
                bmi.s   loc_687EA
                rts
; ---------------------------------------------------------------------------

loc_687EA:
                move.b  #$A,routine(a0)
                move.l  #byte_69136,$30(a0)
                move.l  #loc_68802,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_68802:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_6880A:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_68824(pc,d0.w),d1
                jsr     off_68824(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_68824:
                dc.w    loc_68828-off_68824
                dc.w    loc_6879C-off_68824
; ---------------------------------------------------------------------------

loc_68828:
                lea     byte_69022(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #byte_6913F,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_68844:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_68852(pc,d0.w),d1
                jmp     off_68852(pc,d1.w)
; ---------------------------------------------------------------------------
off_68852:
                dc.w    sub_6885A-off_68852
                dc.w    loc_6888E-off_68852
                dc.w    loc_68574-off_68852
                dc.w    loc_6888E-off_68852

; =============== S U B R O U T I N E =======================================

sub_6885A:
                lea     word_6902A(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                move.l  #byte_6914C,$30(a0)
                move.l  #loc_6889A,$34(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$60,$2E(a0)
                jmp     (Draw_Sprite).l
; End of function sub_6885A

; ---------------------------------------------------------------------------

loc_6888E:
                jsr     (Move_AnimateRaw_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6889A:
                move.b  #4,routine(a0)
                move.w  #8,$2E(a0)
                move.l  #loc_688B0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_688B0:
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
                bsr.w   sub_68EE4
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
                dc.w    sub_6890E-AIZMiniboss_Flame_Index
                dc.w    loc_68574-AIZMiniboss_Flame_Index
                dc.w    loc_68956-AIZMiniboss_Flame_Index

; =============== S U B R O U T I N E =======================================

sub_6890E:
                lea     ObjDat_AIZMiniboss_Flame(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #4,shield_reaction(a0)
                move.l  #loc_6893E,$34(a0)
                moveq   #6,d1

loc_68928:
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

loc_6893E:
                move.b  #4,routine(a0)
                move.l  #byte_6915F,$30(a0)
                move.l  #loc_68962,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_68956:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_68962:
                move.l  #Map_BossExplosion,mappings(a0)
                move.w  #make_art_tile(ArtTile_BossExplosion2,0,1),art_tile(a0)
                move.l  #byte_69164,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                cmpi.b  #6,subtype(a0)
                bne.w   locret_68572
                lea     ChildObjDat_690D0(pc),a2
                jmp     (CreateChild1_Normal).l
; End of function sub_6890E

; ---------------------------------------------------------------------------

loc_68994:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_689A8(pc,d0.w),d1
                jsr     off_689A8(pc,d1.w)
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
off_689A8:
                dc.w    loc_689AC-off_689A8
                dc.w    loc_689F8-off_689A8
; ---------------------------------------------------------------------------

loc_689AC:
                bsr.w   sub_6890E
                move.w  #$100,priority(a0)
                move.l  #byte_6916F,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a1
                move.w  a1,parent3(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.w  #-$60,d0
                btst    #0,render_flags(a1)
                beq.s   loc_689EC
                neg.w   d0
                bset    #0,render_flags(a0)

loc_689EC:
                move.w  x_pos(a1),d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_689F8:
                jsr     (Animate_RawMultiDelay).l
                tst.w   d2
                beq.s   locret_68A16
                bmi.s   locret_68A16
                move.w  word_68A18(pc,d0.w),d0
                btst    #0,render_flags(a0)
                bne.s   loc_68A12
                neg.w   d0

loc_68A12:
                add.w   d0,x_pos(a0)

locret_68A16:
                rts
; ---------------------------------------------------------------------------
word_68A18:
                dc.w    0
                dc.w    0
                dc.w    0
                dc.w    $10
                dc.w    8
                dc.w    8
