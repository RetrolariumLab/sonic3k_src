; Owner: objects/effects/s3
; Responsibility: Boss and ordinary explosion controllers, spawning parameters, child actors and private animation records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CreateBossExplosion:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CreateBossExplosion_Index(pc,d0.w),d1
                jmp     CreateBossExplosion_Index(pc,d1.w)
; ---------------------------------------------------------------------------
CreateBossExplosion_Index:
                dc.w    Obj_BossExpControl-CreateBossExplosion_Index
                dc.w    loc_5281C-CreateBossExplosion_Index
                dc.w    Obj_WaitForParent-CreateBossExplosion_Index

; =============== S U B R O U T I N E =======================================

Obj_BossExpControl:
                lea     ObjDat_BossExplosion(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #Obj_NormalExpControl,$34(a0)
                cmpi.b  #8,subtype(a0)
                bne.s   loc_52812
                move.l  #loc_5289A,$34(a0)

loc_52812:
                move.w  #3-1,$2E(a0)
                bra.w   loc_528BA
; ---------------------------------------------------------------------------

loc_5281C:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Obj_WaitForParent:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.w   loc_52896
                tst.l   (a1)
                beq.w   loc_52896
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Obj_NormalExpControl:
                subq.b  #1,$39(a0)
                bmi.s   loc_52896
                move.w  #3-1,$2E(a0)
; End of function Obj_BossExpControl

; =============== S U B R O U T I N E =======================================

BossExplosionS3SpawnAtMaskedRandomOffset:
                moveq   #signextendB(sfx_Explode),d0
                jsr     (Play_SFX).l
                lea     Child1_MakeBossExplosion(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.w   locret_5293E

loc_52864:
                jsr     (Random_Number).l               ; Offset the explosion by a random amount capped by an effective range
                moveq   #0,d1
                move.b  $3A(a0),d1
                move.w  d1,d2
                add.w   d2,d2
                subq.w  #1,d2
                and.w   d2,d0
                sub.w   d1,d0
                add.w   d0,x_pos(a1)
                swap    d0
                moveq   #0,d1
                move.b  $3B(a0),d1
                move.w  d1,d2
                add.w   d2,d2
                subq.w  #1,d2
                and.w   d2,d0
                sub.w   d1,d0
                add.w   d0,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

loc_52896:
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

loc_5289A:
                subq.b  #1,$39(a0)                      ; Same as above, but uses regular explosions (no animals of course)
                bmi.s   loc_52896
                move.w  #2,$2E(a0)
                lea     Child1_MakeNormalExplosion(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.w   locret_5293E
                move.b  #2,routine(a1)
                bra.s   loc_52864
; ---------------------------------------------------------------------------

loc_528BA:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     CreateBossExpParameterIndex(pc),a1
                adda.w  (a1,d0.w),a1
                move.b  (a1)+,$39(a0)
                move.b  (a1)+,$3A(a0)
                move.b  (a1)+,$3B(a0)
                move.b  (a1)+,routine(a0)
                rts
; ---------------------------------------------------------------------------
CreateBossExpParameterIndex:
                dc.w    CreateBossExp00-CreateBossExpParameterIndex
                dc.w    CreateBossExp02-CreateBossExpParameterIndex
                dc.w    CreateBossExp04-CreateBossExpParameterIndex
                dc.w    CreateBossExp06-CreateBossExpParameterIndex
                dc.w    CreateBossExp08-CreateBossExpParameterIndex
                dc.w    CreateBossExp0A-CreateBossExpParameterIndex
                dc.w    CreateBossExp0C-CreateBossExpParameterIndex
CreateBossExp00:    dc.b    $20, $20, $20,   2
CreateBossExp02:    dc.b    $28, $80, $80,   2
CreateBossExp04:    dc.b    $80, $20, $20,   4
CreateBossExp06:    dc.b    4,   8,   8,   2
CreateBossExp08:    dc.b    8, $20, $20,   2
CreateBossExp0A:    dc.b    $20, $20, $20,   2
CreateBossExp0C:    dc.b    $40, $80, $20,   2
; ---------------------------------------------------------------------------

Obj_BossExplosionSpecial:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  BossExplosionSpecial_Index(pc,d0.w),d1
                jmp     BossExplosionSpecial_Index(pc,d1.w)
; ---------------------------------------------------------------------------
BossExplosionSpecial_Index:
                dc.w    loc_52916-BossExplosionSpecial_Index
                dc.w    loc_5281C-BossExplosionSpecial_Index
; ---------------------------------------------------------------------------

loc_52916:
                move.b  #2,subtype(a0)
                bsr.w   Obj_BossExpControl
                move.w  #2,$2E(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #320/2,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #224/2,d0
                move.w  d0,y_pos(a0)

locret_5293E:
                rts
; End of function BossExplosionS3SpawnAtMaskedRandomOffset

; ---------------------------------------------------------------------------

Obj_BossExplosion:
                lea     ObjDat_BossExplosion(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                tst.b   (Current_zone).w
                bne.s   loc_52954
                move.w  #make_art_tile(ArtTile_BossExplosion2,0,1),art_tile(a0)

loc_52954:
                move.l  #Obj_BossExplosionAnim,(a0)
                move.l  #AniRaw_BossExplosion,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

Obj_BossExplosionAnim:
                jsr     Animate_RawMultiDelay(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
ObjDat_BossExplosion:
                dc.l    Map_BossExplosion
                dc.w    make_art_tile(ArtTile_BossExplosion,0,1)
                dc.w    0
                dc.b    $C,  $C,   0,   0
AniRaw_BossExplosion:
                dc.b    0,   0,   0,   1,   1,   1,   2,   2,   3,   3,   4,   4,   5,   4, $F4
                even
Child1_MakeBossExplosion:
                dc.w    1-1
                dc.l    Obj_BossExplosion
                dc.b    0,   0
Child6_CreateBossExplosion:
                dc.w    1-1
                dc.l    Obj_CreateBossExplosion
                dc.b    0,   0
Child1_MakeNormalExplosion:
                dc.w    1-1
                dc.l    Obj_Explosion
                dc.b    0,   0
