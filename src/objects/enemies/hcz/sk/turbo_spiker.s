; Owner: objects/enemies/hcz/sk
; Responsibility: Turbo Spiker attack states, detached spikes, motion helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_TurboSpiker:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  TurboSpiker_Index(pc,d0.w),d1
                jsr     TurboSpiker_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
TurboSpiker_Index:
                dc.w    loc_87BEC-TurboSpiker_Index
                dc.w    loc_87C48-TurboSpiker_Index
                dc.w    loc_87CAE-TurboSpiker_Index
                dc.w    loc_87CCE-TurboSpiker_Index
                dc.w    loc_87CEC-TurboSpiker_Index
                dc.w    loc_87CFA-TurboSpiker_Index
                dc.w    loc_87D20-TurboSpiker_Index
                dc.w    loc_87D3C-TurboSpiker_Index
; ---------------------------------------------------------------------------

loc_87BEC:
                lea     ObjDat_TurboSpiker(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bclr    #1,render_flags(a0)
                beq.s   loc_87C0A
                move.b  #$A,routine(a0)
                lea     ChildObjDat_87F1E(pc),a2
                jsr     CreateChild1_Normal(pc)

loc_87C0A:
                move.b  #$10,x_radius(a0)
                move.b  #$F,y_radius(a0)
                move.l  #byte_87F26,$30(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  d0,$2E(a0)
                add.w   d0,d0
                move.w  d0,$3C(a0)
                move.l  #loc_87C72,$34(a0)
                move.w  #-$80,d4
                jsr     Set_VelocityXTrackSonic(pc)
                lea     ChildObjDat_87EE6(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_87C48:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                bhs.s   loc_87C60
                btst    #0,render_flags(a0)
                beq.s   loc_87C5C
                subq.w  #2,d0

loc_87C5C:
                tst.w   d0
                beq.s   loc_87C8E

loc_87C60:
                jsr     Animate_Raw(pc)
                jsr     (MoveSprite2).l
                jsr     Obj_Wait(pc)
                jmp     ObjHitFloor2_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_87C72:
                move.b  routine(a0),d0
                cmpi.b  #4,d0
                beq.s   locret_87C8C
                move.b  d0,$3A(a0)
                move.b  #4,routine(a0)
                move.w  #$F,$2E(a0)

locret_87C8C:
                rts
; ---------------------------------------------------------------------------

loc_87C8E:
                move.b  #6,routine(a0)
                move.w  #$F,$2E(a0)
                move.w  #$200,d0
                bchg    #0,render_flags(a0)
                beq.s   loc_87CA8
                neg.w   d0

loc_87CA8:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_87CAE:
                subq.w  #1,$2E(a0)
                bmi.s   loc_87CB6
                rts
; ---------------------------------------------------------------------------

loc_87CB6:
                move.b  $3A(a0),routine(a0)
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  $3C(a0),$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_87CCE:
                subq.w  #1,$2E(a0)
                bmi.s   loc_87CD6
                rts
; ---------------------------------------------------------------------------

loc_87CD6:
                move.b  #8,routine(a0)
                bset    #1,$38(a0)
                move.l  #byte_87F2B,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_87CEC:
                jsr     Animate_Raw(pc)
                jsr     (MoveSprite2).l
                jmp     ObjHitFloor2_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_87CFA:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                blo.s   loc_87D06
                rts
; ---------------------------------------------------------------------------

loc_87D06:
                move.b  #$C,routine(a0)
                bset    #0,$38(a0)
                move.w  #3,$2E(a0)
                lea     ChildObjDat_87EFE(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_87D20:
                subq.w  #1,$2E(a0)
                bmi.s   loc_87D28
                rts
; ---------------------------------------------------------------------------

loc_87D28:
                move.b  #$E,routine(a0)
                move.w  #$180,priority(a0)
                move.w  #$F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_87D3C:
                subq.w  #1,$2E(a0)
                bmi.s   loc_87D44
                rts
; ---------------------------------------------------------------------------

loc_87D44:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_87D4C:
                lea     word_87EC0(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_87D5E,(a0)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_87D5E:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_87D72
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_87D72:
                move.l  #loc_87DA4,(a0)
                move.w  #$100,d0
                btst    #0,render_flags(a0)
                beq.s   loc_87D86
                neg.w   d0

loc_87D86:
                move.w  d0,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                moveq   #signextendB(sfx_FloorLauncher),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_87EEE(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------

loc_87DA4:
                jsr     (MoveSprite2).l
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------

loc_87DAE:
                lea     word_87EC6(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_87DC0,(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_87DC0:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_87DE4
                bsr.w   sub_87DE8
                bchg    #0,$38(a0)
                beq.w   locret_87C8C
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_87DE4:
                jmp     Go_Delete_Sprite(pc)

; =============== S U B R O U T I N E =======================================

sub_87DE8:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   locret_87E18
                lea     ChildObjDat_87EF6(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   locret_87E18
                jsr     (Random_Number).l
                andi.w  #7,d0
                subq.w  #3,d0
                add.w   d0,x_pos(a1)
                swap    d0
                andi.w  #7,d0
                subq.w  #3,d0
                add.w   d0,y_pos(a1)

locret_87E18:
                rts
; End of function sub_87DE8

; ---------------------------------------------------------------------------

loc_87E1A:
                lea     word_87ECC(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_87E3E,(a0)
                move.l  #byte_87F30,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_87E3E:
                jsr     Animate_Raw(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_87E48:
                lea     word_87ED2(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_87E66,(a0)
                move.b  subtype(a0),$2F(a0)
                moveq   #signextendB(sfx_Splash),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_87E66:
                subq.w  #1,$2E(a0)
                bmi.s   loc_87E6E
                rts
; ---------------------------------------------------------------------------

loc_87E6E:
                move.l  #loc_87E86,(a0)
                move.l  #byte_87F37,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_87E86:
                jsr     Animate_Raw(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_87E90:
                move.l  #loc_87E9E,(a0)
                lea     ObjDat3_87EDA(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_87E9E:
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                bne.s   loc_87EAE
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_87EAE:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
ObjDat_TurboSpiker:
                dc.l    Map_TurboSpiker
                dc.w    make_art_tile(ArtTile_TurboSpiker,1,0)
                dc.w    $280
                dc.b    $20, $20,   0, $1A
word_87EC0:
                dc.w    $280
                dc.b    8, $10,   3, $9E
word_87EC6:
                dc.w    $200
                dc.b    4,   8,   4,   0
word_87ECC:
                dc.w    $280
                dc.b    4,   4,   5,   0
word_87ED2:
                dc.w    make_art_tile(ArtTile_TurboSpiker,0,1)
                dc.w    $200
                dc.b    8,   8,   8,   0
ObjDat3_87EDA:
                dc.l    Map_TurboSpikerHidden
                dc.w    make_art_tile($001,2,1)
                dc.w    $180
                dc.b    $10, $10,   0,   0
ChildObjDat_87EE6:
                dc.w    1-1
                dc.l    loc_87D4C
                dc.b    4,   0
ChildObjDat_87EEE:
                dc.w    1-1
                dc.l    loc_87DAE
                dc.b    -4, $14
ChildObjDat_87EF6:
                dc.w    1-1
                dc.l    loc_87E1A
                dc.b    0,   4
ChildObjDat_87EFE:
                dc.w    5-1
                dc.l    loc_87E48
                dc.b    4,  -8
                dc.l    loc_87E48
                dc.b    -6,   0
                dc.l    loc_87E48
                dc.b    6,   0
                dc.l    loc_87E48
                dc.b    -8,   0
                dc.l    loc_87E48
                dc.b    8,   0
ChildObjDat_87F1E:
                dc.w    1-1
                dc.l    loc_87E90
                dc.b    0,   0
byte_87F26:
                dc.b    5,   0,   1,   2, $FC
byte_87F2B:
                dc.b    1,   0,   1,   2, $FC
byte_87F30:
                dc.b    0,   5,   5,   5,   6,   7, $F4
byte_87F37:
                dc.b    1,   8,   9,  $A,  $B,  $C,  $D, $F4
                even
Map_TurboSpikerHidden:
                include "src/objects/shared/turbo_spiker/mappings/hidden.s"
