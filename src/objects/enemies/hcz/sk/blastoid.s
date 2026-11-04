; Owner: objects/enemies/hcz/sk
; Responsibility: Blastoid launcher, projectiles, helper callback and private construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Blastoid:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Blastoid_Index(pc,d0.w),d1
                jsr     Blastoid_Index(pc,d1.w)
                bsr.w   ResolveBlastoidContactAndLevelTrigger
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Blastoid_Index:
                dc.w    SKBlastoid_InitLauncher-Blastoid_Index
                dc.w    SKBlastoid_WaitForNearbyTarget-Blastoid_Index
                dc.w    SKBlastoid_AnimateAndTryFire-Blastoid_Index
; ---------------------------------------------------------------------------

SKBlastoid_InitLauncher:
                lea     ObjDat_Blastoid(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

SKBlastoid_WaitForNearbyTarget:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$80,d2
                blo.s   HCZBlastoidSK_StartPairedFiringSequence
                rts
; ---------------------------------------------------------------------------

HCZBlastoidSK_StartPairedFiringSequence:
                move.b  #4,routine(a0)
                move.l  #HCZBlastoidSK_PairedLauncherFiringStream,$30(a0)
                move.l  #SKBlastoid_RestartProximityWait,$34(a0)

SKBlastoid_UpdateReturn:
                rts
; ---------------------------------------------------------------------------

SKBlastoid_AnimateAndTryFire:
                jsr     Animate_RawMultiDelay(pc)
                tst.w   d2
                beq.s   SKBlastoid_UpdateReturn
                bmi.s   SKBlastoid_UpdateReturn
                cmpi.b  #1,mapping_frame(a0)
                bne.s   SKBlastoid_UpdateReturn
                tst.b   render_flags(a0)
                bpl.w   SKBlastoid_UpdateReturn
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                lea     SKBlastoid_ShotChildRecord(pc),a2
                jmp     CreateChild5_ComplexAdjusted(pc)
; ---------------------------------------------------------------------------

SKBlastoid_RestartProximityWait:
                move.b  #2,routine(a0)
                rts

; =============== S U B R O U T I N E =======================================

ResolveBlastoidContactAndLevelTrigger:
                jsr     Check_PlayerCollision(pc)
                beq.w   SKBlastoid_UpdateReturn
                jsr     Check_PlayerAttack(pc)
                bne.s   SKBlastoid_TriggerDefeatAndDraw
                tst.b   invulnerability_timer(a1)
                bne.w   SKBlastoid_UpdateReturn
                jmp     (HurtCharacter_Directly).l
; ---------------------------------------------------------------------------

; Discard the caller's return address to bypass the rest of the root update
SKBlastoid_TriggerDefeatAndDraw:
                addq.w  #4,sp
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                st      (a3,d0.w)
                jsr     EnemyDefeated(pc)
                jmp     (Draw_Sprite).l
; End of function ResolveBlastoidContactAndLevelTrigger

; ---------------------------------------------------------------------------
ObjDat_Blastoid:
                dc.l    Map_Blastoid
                dc.w    make_art_tile(ArtTile_Blastoid,1,1)
                dc.w    $280
                dc.b    $14,  $C,   0, $D7
HCZBlastoidSK_ProjectileFullAttributes:
                dc.l    Map_Blastoid
                dc.w    make_art_tile(ArtTile_Blastoid,1,1)
                dc.w    $280
                dc.b    4,   4,   2, $98
SKBlastoid_ShotChildRecord:
                dc.w    1-1
                dc.l    SKCallbackShot_InitDeflectable
                dc.l    HCZBlastoidSK_ProjectileFullAttributes
                dc.l    SKBlastoid_ShotAnim
                dc.l    Move_AnimateRaw
                dc.b    -$14,  -7
                dc.w    -$200, -$100
HCZBlastoidSK_PairedLauncherFiringStream:
                dc.b    0, $7F
                dc.b    1,   4
                dc.b    0,   9
                dc.b    1,   4
                dc.b    0,   9
                dc.b    1,   4
                dc.b    0, $3F
                dc.b    $F4
SKBlastoid_ShotAnim:
                dc.b    0,   2,   3, $FC
                even
