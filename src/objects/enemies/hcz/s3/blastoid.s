; Owner: objects/enemies/hcz/s3
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
                dc.w    S3Blastoid_InitLauncher-Blastoid_Index
                dc.w    S3Blastoid_WaitForNearbyTarget-Blastoid_Index
                dc.w    S3Blastoid_AnimateAndTryFire-Blastoid_Index
; ---------------------------------------------------------------------------

S3Blastoid_InitLauncher:
                lea     ObjDat_Blastoid(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

S3Blastoid_WaitForNearbyTarget:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$80,d2
                blo.s   HCZBlastoidS3_StartPairedFiringSequence
                rts
; ---------------------------------------------------------------------------

HCZBlastoidS3_StartPairedFiringSequence:
                move.b  #4,routine(a0)
                move.l  #HCZBlastoidS3_PairedLauncherFiringStream,$30(a0)
                move.l  #S3Blastoid_RestartProximityWait,$34(a0)

S3Blastoid_UpdateReturn:
                rts
; ---------------------------------------------------------------------------

S3Blastoid_AnimateAndTryFire:
                jsr     Animate_RawMultiDelay(pc)
                tst.w   d2
                beq.s   S3Blastoid_UpdateReturn
                bmi.s   S3Blastoid_UpdateReturn
                cmpi.b  #1,mapping_frame(a0)
                bne.s   S3Blastoid_UpdateReturn
                tst.b   render_flags(a0)
                bpl.w   S3Blastoid_UpdateReturn
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                lea     S3Blastoid_ShotChildRecord(pc),a2
                jmp     CreateChild5_ComplexAdjusted(pc)
; ---------------------------------------------------------------------------

S3Blastoid_RestartProximityWait:
                move.b  #2,routine(a0)
                rts

; =============== S U B R O U T I N E =======================================

ResolveBlastoidContactAndLevelTrigger:
                jsr     Check_PlayerCollision(pc)
                beq.w   S3Blastoid_UpdateReturn
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                st      (a3,d0.w)
                jmp     EnemyDefeat_Score(pc)
; End of function ResolveBlastoidContactAndLevelTrigger

; ---------------------------------------------------------------------------
; unused
                dc.w    Player_1
                dc.w    Player_2
ObjDat_Blastoid:
                dc.l    Map_Blastoid
                dc.w    make_art_tile(ArtTile_Blastoid,1,1)
                dc.w    $280
                dc.b    $14,  $C,   0, $D7
HCZBlastoidS3_ProjectileFullAttributes:
                dc.l    Map_Blastoid
                dc.w    make_art_tile(ArtTile_Blastoid,1,1)
                dc.w    $280
                dc.b    4,   4,   2, $98
S3Blastoid_ShotChildRecord:
                dc.w    1-1
                dc.l    S3CallbackShot_InitDeflectable
                dc.l    HCZBlastoidS3_ProjectileFullAttributes
                dc.l    S3Blastoid_ShotAnim
                dc.l    Move_AnimateRaw
                dc.b    -$14,  -7
                dc.w    -$200, -$100
HCZBlastoidS3_PairedLauncherFiringStream:
                dc.b    0, $7F
                dc.b    1,   4
                dc.b    0,   9
                dc.b    1,   4
                dc.b    0,   9
                dc.b    1,   4
                dc.b    0, $3F
                dc.b    $F4
S3Blastoid_ShotAnim:
                dc.b    0,   2,   3, $FC
                even
