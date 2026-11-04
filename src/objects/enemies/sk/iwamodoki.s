; Owner: objects/enemies/sk
; Responsibility: Iwamodoki enemy movement, player interaction and private construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Iwamodoki:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Iwamodoki_Index(pc,d0.w),d1
                jsr     Iwamodoki_Index(pc,d1.w)
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   SKIwamodoki_ReleaseRidersAndCull
                btst    #7,status(a0)
                bne.s   SKIwamodoki_ReleaseRidersOnDeath
                moveq   #$17,d1
                moveq   #$C,d2
                moveq   #$B,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKIwamodoki_ReleaseRidersAndCull:
                jsr     (Displace_PlayerOffObject).l
                jmp     (SKCull_ReleaseRespawnForStatusDelete).l
; ---------------------------------------------------------------------------

SKIwamodoki_ReleaseRidersOnDeath:
                jmp     (Displace_PlayerOffObject).l
; ---------------------------------------------------------------------------
Iwamodoki_Index:
                dc.w    SKIwamodoki_InitSolidRock-Iwamodoki_Index
                dc.w    SKIwamodoki_TryStartWarning-Iwamodoki_Index
                dc.w    SKIwamodoki_AnimateWarning-Iwamodoki_Index
; ---------------------------------------------------------------------------

SKIwamodoki_InitSolidRock:
                lea     ObjDat_Iwamodoki(pc),a1
                jmp     (SetUp_ObjAttributes).l
; ---------------------------------------------------------------------------

SKIwamodoki_TryStartWarning:
                jsr     (Find_SonicTails).l
                cmpi.w  #$40,d2
                bhs.s   SKIwamodoki_WarningSetupReturn
                move.b  #4,routine(a0)
                move.l  #SKIwamodoki_WarningAnimation,$30(a0)
                move.l  #SKIwamodoki_ExplodeAndTrySpawnShards,$34(a0)

SKIwamodoki_WarningSetupReturn:
                rts
; ---------------------------------------------------------------------------

SKIwamodoki_AnimateWarning:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

SKIwamodoki_ExplodeAndTrySpawnShards:
; Bug: When Iwamodoki explodes, 100 points is never actually given out
                move.l  #Obj_Explosion,(a0)
                bset    #7,status(a0)
                clr.b   routine(a0)
                lea     SKIwamodoki_ShardChildren(pc),a2
                jmp     (CreateChild2_Complex).l
; ---------------------------------------------------------------------------

SKIwamodokiShard_InitShard:
                movea.l $3E(a0),a1
                jsr     (SetUp_ObjAttributes3).l
                bset    #3,shield_reaction(a0)
                move.l  #SKCallbackShot_UpdateAndDraw,(a0)
                move.b  subtype(a0),d0
                lsr.b   #2,d0
                addq.b  #6,d0
                move.b  d0,mapping_frame(a0)
                jmp     (Sprite_CheckDeleteTouchXY).l
; ---------------------------------------------------------------------------

SKIwamodokiShard_FallAndAnimate:
                jsr     (MoveSprite).l
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------
ObjDat_Iwamodoki:
                dc.l    Map_Iwamodoki
                dc.w    make_art_tile(ArtTile_Iwamodoki,0,0)
                dc.w    $280
                dc.b    $C,  $C,   0,   0
IwamodokiSK_Shard_PartialAttributePrefix:
                dc.w    $280
                dc.b    8,   4,   0, $98
SKIwamodoki_ShardChildren:
                dc.w    4-1
                dc.l    SKIwamodokiShard_InitShard
                dc.l    IwamodokiSK_Shard_PartialAttributePrefix
                dc.l    SKIwamodokiShard_Frames7And9
                dc.l    SKIwamodokiShard_FallAndAnimate
                dc.b    -4,   4
                dc.w    -$400, -$200
                dc.l    SKIwamodokiShard_InitShard
                dc.l    IwamodokiSK_Shard_PartialAttributePrefix
                dc.l    SKIwamodokiShard_Frames7And9
                dc.l    SKIwamodokiShard_FallAndAnimate
                dc.b    4,   4
                dc.w    $400, -$200
                dc.l    SKIwamodokiShard_InitShard
                dc.l    IwamodokiSK_Shard_PartialAttributePrefix
                dc.l    SKIwamodokiShard_Frames6And8
                dc.l    SKIwamodokiShard_FallAndAnimate
                dc.b    -8,  -8
                dc.w    -$200, -$400
                dc.l    SKIwamodokiShard_InitShard
                dc.l    IwamodokiSK_Shard_PartialAttributePrefix
                dc.l    SKIwamodokiShard_Frames6And8
                dc.l    SKIwamodokiShard_FallAndAnimate
                dc.b    8,  -8
                dc.w    $200, -$400
SKIwamodoki_WarningAnimation:
                dc.b    0,   7
                dc.b    1,   7
                dc.b    2,   7
                dc.b    3, $2F
                dc.b    4,   5
                dc.b    3,   5
                dc.b    4,   4
                dc.b    3,   4
                dc.b    4,   3
                dc.b    3,   3
                dc.b    4,   2
                dc.b    3,   2
                dc.b    4,   1
                dc.b    3,   1
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    4,   0
                dc.b    3,   0
                dc.b    5, $1F
                dc.b    $F4
SKIwamodokiShard_Frames6And8:
                dc.b    0,   6,   8, $FC
SKIwamodokiShard_Frames7And9:
                dc.b    0,   7,   9, $FC
                even
Map_Iwamodoki:
                include "src/objects/shared/iwamodoki/mappings/iwamodoki.s"
