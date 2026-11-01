; Owner: objects/enemies/hcz/s3
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
                dc.w    loc_559D2-TurboSpiker_Index
                dc.w    loc_55A2E-TurboSpiker_Index
                dc.w    loc_55A94-TurboSpiker_Index
                dc.w    loc_55AB4-TurboSpiker_Index
                dc.w    loc_55AD2-TurboSpiker_Index
                dc.w    loc_55AE0-TurboSpiker_Index
                dc.w    loc_55B06-TurboSpiker_Index
                dc.w    loc_55B22-TurboSpiker_Index
; ---------------------------------------------------------------------------

loc_559D2:
                lea     ObjDat_TurboSpiker(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bclr    #1,render_flags(a0)
                beq.s   loc_559F0
                move.b  #$A,routine(a0)
                lea     ChildObjDat_55D04(pc),a2
                jsr     CreateChild1_Normal(pc)

loc_559F0:
                move.b  #$10,x_radius(a0)
                move.b  #$F,y_radius(a0)
                move.l  #byte_55D0C,$30(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  d0,$2E(a0)
                add.w   d0,d0
                move.w  d0,$3C(a0)
                move.l  #loc_55A58,$34(a0)
                move.w  #-$80,d4
                jsr     Set_VelocityXTrackSonic(pc)
                lea     ChildObjDat_55CCC(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_55A2E:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                bhs.s   loc_55A46
                btst    #0,render_flags(a0)
                beq.s   loc_55A42
                subq.w  #2,d0

loc_55A42:
                tst.w   d0
                beq.s   loc_55A74

loc_55A46:
                jsr     Animate_Raw(pc)
                jsr     (MoveSprite2).l
                jsr     Obj_Wait(pc)
                jmp     ObjHitFloor2_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_55A58:
                move.b  routine(a0),d0
                cmpi.b  #4,d0
                beq.s   locret_55A72
                move.b  d0,$3A(a0)
                move.b  #4,routine(a0)
                move.w  #$F,$2E(a0)

locret_55A72:
                rts
; ---------------------------------------------------------------------------

loc_55A74:
                move.b  #6,routine(a0)
                move.w  #$F,$2E(a0)
                move.w  #$200,d0
                bchg    #0,render_flags(a0)
                beq.s   loc_55A8E
                neg.w   d0

loc_55A8E:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_55A94:
                subq.w  #1,$2E(a0)
                bmi.s   loc_55A9C
                rts
; ---------------------------------------------------------------------------

loc_55A9C:
                move.b  $3A(a0),routine(a0)
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  $3C(a0),$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_55AB4:
                subq.w  #1,$2E(a0)
                bmi.s   loc_55ABC
                rts
; ---------------------------------------------------------------------------

loc_55ABC:
                move.b  #8,routine(a0)
                bset    #1,$38(a0)
                move.l  #byte_55D11,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_55AD2:
                jsr     Animate_Raw(pc)
                jsr     (MoveSprite2).l
                jmp     ObjHitFloor2_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_55AE0:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                blo.s   loc_55AEC
                rts
; ---------------------------------------------------------------------------

loc_55AEC:
                move.b  #$C,routine(a0)
                bset    #0,$38(a0)
                move.w  #3,$2E(a0)
                lea     ChildObjDat_55CE4(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_55B06:
                subq.w  #1,$2E(a0)
                bmi.s   loc_55B0E
                rts
; ---------------------------------------------------------------------------

loc_55B0E:
                move.b  #$E,routine(a0)
                move.w  #$180,priority(a0)
                move.w  #$F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_55B22:
                subq.w  #1,$2E(a0)
                bmi.s   loc_55B2A
                rts
; ---------------------------------------------------------------------------

loc_55B2A:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_55B32:
                lea     word_55CA6(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_55B44,(a0)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_55B44:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_55B58
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_55B58:
                move.l  #loc_55B8A,(a0)
                move.w  #$100,d0
                btst    #0,render_flags(a0)
                beq.s   loc_55B6C
                neg.w   d0

loc_55B6C:
                move.w  d0,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                moveq   #signextendB(sfx_FloorLauncher),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_55CD4(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------

loc_55B8A:
                jsr     (MoveSprite2).l
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------

loc_55B94:
                lea     word_55CAC(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_55BA6,(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_55BA6:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_55BCA
                bsr.w   SpawnTurboSpikerTrailPuffOnVblankPhase
                bchg    #0,$38(a0)
                beq.w   locret_55A72
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_55BCA:
                jmp     Go_Delete_Sprite(pc)

; =============== S U B R O U T I N E =======================================

SpawnTurboSpikerTrailPuffOnVblankPhase:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   locret_55BFE
                lea     ChildObjDat_55CDC(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   locret_55BFE
                jsr     (Random_Number).l
                andi.w  #7,d0
                subq.w  #3,d0
                add.w   d0,x_pos(a1)
                swap    d0
                andi.w  #7,d0
                subq.w  #3,d0
                add.w   d0,y_pos(a1)

locret_55BFE:
                rts
; End of function SpawnTurboSpikerTrailPuffOnVblankPhase

; ---------------------------------------------------------------------------

loc_55C00:
                lea     word_55CB2(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_55C24,(a0)
                move.l  #byte_55D16,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_55C24:
                jsr     Animate_Raw(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_55C2E:
                lea     word_55CB8(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_55C4C,(a0)
                move.b  subtype(a0),$2F(a0)
                moveq   #signextendB(sfx_Splash),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_55C4C:
                subq.w  #1,$2E(a0)
                bmi.s   loc_55C54
                rts
; ---------------------------------------------------------------------------

loc_55C54:
                move.l  #loc_55C6C,(a0)
                move.l  #byte_55D1D,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_55C6C:
                jsr     Animate_Raw(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_55C76:
                move.l  #loc_55C84,(a0)
                lea     ObjDat3_55CC0(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_55C84:
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                bne.s   loc_55C94
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_55C94:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
ObjDat_TurboSpiker:
                dc.l    Map_TurboSpiker
                dc.w    make_art_tile(ArtTile_TurboSpiker,1,0)
                dc.w    $280
                dc.b    $20, $20,   0, $1A
word_55CA6:
                dc.w    $280
                dc.b    8, $10,   3, $9E
word_55CAC:
                dc.w    $200
                dc.b    4,   8,   4,   0
word_55CB2:
                dc.w    $280
                dc.b    4,   4,   5,   0
word_55CB8:
                dc.w    make_art_tile(ArtTile_TurboSpiker,0,1)
                dc.w    $200
                dc.b    8,   8,   8,   0
ObjDat3_55CC0:
                dc.l    Map_TurboSpikerHidden
                dc.w    make_art_tile($001,2,1)
                dc.w    $180
                dc.b    $10, $10,   0,   0
ChildObjDat_55CCC:
                dc.w    1-1
                dc.l    loc_55B32
                dc.b    4,   0
ChildObjDat_55CD4:
                dc.w    1-1
                dc.l    loc_55B94
                dc.b    -4, $14
ChildObjDat_55CDC:
                dc.w    1-1
                dc.l    loc_55C00
                dc.b    0,   4
ChildObjDat_55CE4:
                dc.w    5-1
                dc.l    loc_55C2E
                dc.b    4,  -8
                dc.l    loc_55C2E
                dc.b    -6,   0
                dc.l    loc_55C2E
                dc.b    6,   0
                dc.l    loc_55C2E
                dc.b    -8,   0
                dc.l    loc_55C2E
                dc.b    8,   0
ChildObjDat_55D04:
                dc.w    1-1
                dc.l    loc_55C76
                dc.b    0,   0
byte_55D0C:
                dc.b    5,   0,   1,   2, $FC
byte_55D11:
                dc.b    1,   0,   1,   2, $FC
byte_55D16:
                dc.b    0,   5,   5,   5,   6,   7, $F4
byte_55D1D:
                dc.b    1,   8,   9,  $A,  $B,  $C,  $D, $F4
                even
Map_TurboSpikerHidden:
                include "src/objects/shared/turbo_spiker/mappings/hidden.s"
