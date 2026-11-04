; Owner: objects/effects/sk
; Responsibility: Boss or ordinary explosion spawning, timed effect controllers, child actors and private parameter records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CreateBossExplosion:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     CreateBossExpParameterIndex(pc),a1
                adda.w  (a1,d0.w),a1
                move.b  (a1)+,$39(a0)
                move.b  (a1)+,$3A(a0)
                move.b  (a1)+,$3B(a0)
                move.b  (a1)+,d0
                lea     CreateBossExpRoutineSet(pc,d0.w),a1
                movea.l (a1)+,a2
                move.l  a2,(a0)
                move.l  (a1)+,$34(a0)
                jmp     (a2)
; ---------------------------------------------------------------------------
CreateBossExpRoutineSet:
                dc.l    Obj_Wait
                dc.l    Obj_BossExpControl1
                dc.l    Obj_WaitForParent
                dc.l    Obj_BossExpControl1
                dc.l    Obj_Wait
                dc.l    Obj_NormalExpControl
                dc.l    Obj_Wait
                dc.l    Obj_BossExpControl2
                dc.l    Obj_WaitForParent
                dc.l    Obj_BossExpControl2
                dc.l    Obj_WaitForParent
                dc.l    Obj_NormalExpControl
                dc.l    Obj_WaitForParent
                dc.l    Obj_BossExpControlOff
CreateBossExpParameterIndex:
                dc.w    CreateBossExp00-CreateBossExpParameterIndex
                dc.w    CreateBossExp02-CreateBossExpParameterIndex
                dc.w    CreateBossExp04-CreateBossExpParameterIndex
                dc.w    CreateBossExp06-CreateBossExpParameterIndex
                dc.w    CreateBossExp08-CreateBossExpParameterIndex
                dc.w    CreateBossExp0A-CreateBossExpParameterIndex
                dc.w    CreateBossExp0C-CreateBossExpParameterIndex
                dc.w    CreateBossExp0E-CreateBossExpParameterIndex
                dc.w    CreateBossExp10-CreateBossExpParameterIndex
                dc.w    CreateBossExp12-CreateBossExpParameterIndex
                dc.w    CreateBossExp14-CreateBossExpParameterIndex
                dc.w    CreateBossExp16-CreateBossExpParameterIndex
                dc.w    CreateBossExp18-CreateBossExpParameterIndex
                dc.w    CreateBossExp1A-CreateBossExpParameterIndex
                dc.w    CreateBossExp1C-CreateBossExpParameterIndex
                dc.w    CreateBossExp1E-CreateBossExpParameterIndex
                dc.w    CreateBossExp20-CreateBossExpParameterIndex
CreateBossExp00:    dc.b    $20, $20, $20,   0          ; Explosion timer, X offset range, Y offset range, routine set
CreateBossExp02:    dc.b    $28, $80, $80, $18
CreateBossExp04:    dc.b    $80, $20, $20,   8
CreateBossExp06:    dc.b    4, $10, $10,   0
CreateBossExp08:    dc.b    8, $20, $20, $10
CreateBossExp0A:    dc.b    $20, $20, $20,   0
CreateBossExp0C:    dc.b    $40, $80, $20,   0
CreateBossExp0E:    dc.b    $80, $40, $40,   8
CreateBossExp10:    dc.b    $20, $20, $20, $18
CreateBossExp12:    dc.b    $80, $20, $20, $20
CreateBossExp14:    dc.b    8, $80, $20, $10
CreateBossExp16:    dc.b    $80, $80, $80,   8
CreateBossExp18:    dc.b    $80, $80, $80, $28
CreateBossExp1A:    dc.b    $80, $40, $40, $28
CreateBossExp1C:    dc.b    $80, $80, $40,   8
CreateBossExp1E:    dc.b    $80, $10, $10,   8
CreateBossExp20:    dc.b    $80, $20, $20, $30
; ---------------------------------------------------------------------------

Obj_WaitForParent:
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.w   SKBossExpl_DeleteController
                tst.l   (a1)
                beq.w   SKBossExpl_DeleteController
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Obj_BossExpControl1:
                move.b  $39(a0),d0
                bmi.s   SKBossExpl_ResetSpawnWait       ; If negative, explosions are constantly created every three frames
                subq.b  #1,d0
                move.b  d0,$39(a0)                      ; Otherwise, continue making explosions until timer runs out
                beq.s   SKBossExpl_DeleteController

SKBossExpl_ResetSpawnWait:
                move.w  #2,$2E(a0)

; =============== S U B R O U T I N E =======================================

BossExplosionSKSpawnAtMaskedRandomOffset:
                lea     Child6_MakeBossExplosion1(pc),a2
                jsr     CreateChild6_Simple(pc)
                bne.w   SKBossExpl_SpawnReturn

SKBossExpl_ApplyRandomOffset:
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

SKBossExpl_SpawnReturn:
                rts
; End of function BossExplosionSKSpawnAtMaskedRandomOffset

; ---------------------------------------------------------------------------

SKBossExpl_DeleteController:
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

Obj_NormalExpControl:
                subq.b  #1,$39(a0)                      ; Same as above, but uses regular explosions (no animals of course)
                beq.s   SKBossExpl_DeleteController
                move.w  #2,$2E(a0)
                lea     Child6_MakeNormalExplosion(pc),a2
                jsr     CreateChild6_Simple(pc)
                bne.w   SKBossExpl_SpawnReturn
                move.b  #2,routine(a1)
                bset    #7,art_tile(a1)
                bra.s   SKBossExpl_ApplyRandomOffset
; ---------------------------------------------------------------------------

Obj_BossExpControl2:
                subq.b  #1,$39(a0)
                beq.s   SKBossExpl_DeleteController
                move.w  #2,$2E(a0)
                lea     Child6_MakeBossExplosion2(pc),a2
                jsr     CreateChild6_Simple(pc)
                bne.w   SKBossExpl_SpawnReturn
                bra.s   SKBossExpl_ApplyRandomOffset
; ---------------------------------------------------------------------------

Obj_BossExpControlOff:
                subq.b  #1,$39(a0)
                beq.s   SKBossExpl_DeleteController
                move.w  #2,$2E(a0)
                lea     Child6_MakeBossExplosionOff(pc),a2
                jsr     CreateChild6_Simple(pc)
                bne.w   SKBossExpl_SpawnReturn
                bra.w   SKBossExpl_ApplyRandomOffset
; ---------------------------------------------------------------------------

Obj_BossExplosionSpecial:
                move.w  #2,$2E(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #320/2,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #224/2,d0
                move.w  d0,y_pos(a0)
                move.b  #2,subtype(a0)
                bra.w   Obj_CreateBossExplosion
; ---------------------------------------------------------------------------

Obj_BossExplosion1:
                lea     ObjDat_BossExplosion1(pc),a1
                jsr     SetUp_ObjAttributes(pc)

SKBossExpl_InitRawAnimAndSound:
                move.l  #Obj_BossExplosionAnim,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                moveq   #signextendB(sfx_Explode),d0
                jsr     (Play_SFX).l

Obj_BossExplosionAnim:
                lea     AniRaw_BossExplosion(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_BossExplosion2:
                lea     ObjDat_BossExplosion2(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bra.s   SKBossExpl_InitRawAnimAndSound
; ---------------------------------------------------------------------------

Obj_BossExplosionOffset:
                lea     ObjDat_BossExplosion1(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #Obj_BossExplosionOffsetAnim,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                moveq   #signextendB(sfx_Explode),d0
                jsr     (Play_SFX).l

Obj_BossExplosionOffsetAnim:
                move.w  (Level_repeat_offset).w,d0
                sub.w   d0,x_pos(a0)
                lea     AniRaw_BossExplosion(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
ObjDat_BossExplosion1:
                dc.l    Map_BossExplosion
                dc.w    make_art_tile(ArtTile_BossExplosion,0,1)
                dc.w    0
                dc.b    $C,  $C,   0,   0
ObjDat_BossExplosion2:
                dc.l    Map_BossExplosion
                dc.w    make_art_tile(ArtTile_BossExplosion2,0,1)
                dc.w    0
                dc.b    $C,  $C,   0,   0
AniRaw_BossExplosion:
                dc.b    0,   0,   0,   1,   1,   1,   2,   2,   3,   3,   4,   4,   5,   4, $F4
                even
Child6_MakeBossExplosion1:
                dc.w    1-1
                dc.l    Obj_BossExplosion1
Child6_MakeBossExplosion2:
                dc.w    1-1
                dc.l    Obj_BossExplosion2
Child6_MakeBossExplosionOff:
                dc.w    1-1
                dc.l    Obj_BossExplosionOffset
Child6_CreateBossExplosion:
                dc.w    1-1
                dc.l    Obj_CreateBossExplosion
                dc.b    0,   0
Child6_MakeNormalExplosion:
                dc.w    1-1
                dc.l    Obj_Explosion
Map_BossExplosion:
                include "src/objects/shared/boss_explosion/mappings/boss_explosion.s"
; End of function SKBossExpl_DeleteController
