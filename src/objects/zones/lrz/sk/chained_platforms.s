; Owner: objects/zones/lrz/sk
; Responsibility: Lava Reef chained platform coordination, movement, player riding and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_LRZChainedPlatforms:
                move.b  subtype(a0),d0
                bmi.w   SKLRZChainPlat_InitPlatformGroup
                move.l  #Map_LRZChainedPlatforms,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZ2Misc,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.w  #$200,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #3,d0
                andi.w  #$1E,d0
                lea     SKLRZChainPlat_RouteOffsets(pc),a2
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,$3C(a0)
                move.l  a2,$40(a0)
                andi.w  #$F,d1
                lsl.w   #2,d1
                move.b  d1,$3C(a0)
                move.b  #4,$3E(a0)
                btst    #0,status(a0)
                beq.s   SKLRZChainPlat_LoadStartTargetAndMove
                neg.b   $3E(a0)
                moveq   #0,d1
                move.b  $3C(a0),d1
                add.b   $3E(a0),d1
                cmp.b   $3D(a0),d1
                blo.s   SKLRZChainPlat_StoreStartWaypoint
                move.b  d1,d0
                moveq   #0,d1
                tst.b   d0
                bpl.s   SKLRZChainPlat_StoreStartWaypoint
                move.b  $3D(a0),d1
                subq.b  #4,d1

SKLRZChainPlat_StoreStartWaypoint:
                move.b  d1,$3C(a0)

SKLRZChainPlat_LoadStartTargetAndMove:
                move.w  (a2,d1.w),d0
                add.w   $34(a0),d0
                move.w  d0,$38(a0)
                move.w  2(a2,d1.w),d0
                add.w   $36(a0),d0
                move.w  d0,$3A(a0)
                bsr.w   AimLrzChainedPlatformAtWaypoint
                move.l  #SKLRZChainPlat_MoveAndCheckSolid,(a0)
                bra.w   SKLRZChainPlat_MoveAndCheckSolid
; ---------------------------------------------------------------------------

SKLRZChainPlat_InitPlatformGroup:
                andi.w  #$7F,d0
                add.w   d0,d0
                lea     (SKLRZChainPlat_GroupOffsets).l,a2
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d1
                movea.l a0,a1
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                bra.s   SKLRZChainPlat_InitGroupMember
; ---------------------------------------------------------------------------

SKLRZChainPlat_TryAllocGroupMember:
                jsr     (AllocateObject).l
                bne.s   SKLRZChainPlat_AdvanceGroupAttempt

SKLRZChainPlat_InitGroupMember:
                move.l  #Obj_LRZChainedPlatforms,(a1)
                move.w  (a2)+,d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                move.w  (a2)+,d0
                add.w   d3,d0
                move.w  d0,y_pos(a1)
                move.w  d2,$34(a1)
                move.w  d3,$36(a1)
                move.w  (a2)+,d0
                move.b  d0,subtype(a1)
                move.b  status(a0),status(a1)

; An allocation failure consumes an attempt and leaves the record cursor at the same member
SKLRZChainPlat_AdvanceGroupAttempt:
                dbf     d1,SKLRZChainPlat_TryAllocGroupMember
                rts
; ---------------------------------------------------------------------------

SKLRZChainPlat_MoveAndCheckSolid:
                move.w  x_pos(a0),-(sp)
                bsr.w   AdvanceLrzChainedPlatformPath
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                swap    d6
                andi.w  #4|8,d6
                beq.s   SKLRZChainPlat_TryPlayChainTick
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   SKLRZChainPlat_TryHurtP2
                lea     (Player_1).w,a1
                jsr     (HurtPlayerFromSolidHazard).l

SKLRZChainPlat_TryHurtP2:
                andi.b  #8,d6
                beq.s   SKLRZChainPlat_TryPlayChainTick
                lea     (Player_2).w,a1
                jsr     (HurtPlayerFromSolidHazard).l

SKLRZChainPlat_TryPlayChainTick:
                tst.b   render_flags(a0)
                bpl.s   SKLRZChainPlat_CullAtGroupOrigin
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   SKLRZChainPlat_CullAtGroupOrigin
                moveq   #signextendB(sfx_ChainTick),d0
                jsr     (Play_SFX).l

SKLRZChainPlat_CullAtGroupOrigin:
                move.w  $34(a0),d0
                jmp     (Sprite_OnScreen_Test2).l

; =============== S U B R O U T I N E =======================================

AdvanceLrzChainedPlatformPath:
                move.w  x_pos(a0),d0
                cmp.w   $38(a0),d0
                bne.s   SKLRZChainPlat_MoveAlongSegment
                move.w  y_pos(a0),d0
                cmp.w   $3A(a0),d0
                bne.s   SKLRZChainPlat_MoveAlongSegment
                moveq   #0,d1
                move.b  $3C(a0),d1
                add.b   $3E(a0),d1
                cmp.b   $3D(a0),d1
                blo.s   SKLRZChainPlat_SetTargetAndRecalcSpeed
                move.b  d1,d0
                moveq   #0,d1
                tst.b   d0
                bpl.s   SKLRZChainPlat_SetTargetAndRecalcSpeed
                move.b  $3D(a0),d1
                subq.b  #4,d1

SKLRZChainPlat_SetTargetAndRecalcSpeed:
                move.b  d1,$3C(a0)
                movea.l $40(a0),a1
                move.w  (a1,d1.w),d0
                add.w   $34(a0),d0
                move.w  d0,$38(a0)
                move.w  2(a1,d1.w),d0
                add.w   $36(a0),d0
                move.w  d0,$3A(a0)
                bsr.w   AimLrzChainedPlatformAtWaypoint

SKLRZChainPlat_MoveAlongSegment:
                jsr     (MoveSprite2).l
                rts
; End of function AdvanceLrzChainedPlatformPath

; =============== S U B R O U T I N E =======================================

AimLrzChainedPlatformAtWaypoint:
                moveq   #0,d0
                move.w  #-$100,d2
                move.w  x_pos(a0),d0
                sub.w   $38(a0),d0
                bcc.s   SKLRZChainPlat_GetYDistanceAndSign
                neg.w   d0
                neg.w   d2

SKLRZChainPlat_GetYDistanceAndSign:
                moveq   #0,d1
                move.w  #-$100,d3
                move.w  y_pos(a0),d1
                sub.w   $3A(a0),d1
                bcc.s   SKLRZChainPlat_SelectDominantAxis
                neg.w   d1
                neg.w   d3

SKLRZChainPlat_SelectDominantAxis:
                cmp.w   d0,d1
                blo.s   SKLRZChainPlat_CalcMinorYSpeed
                move.w  x_pos(a0),d0
                sub.w   $38(a0),d0
                beq.s   SKLRZChainPlat_StoreYDominantSpeed
                ext.l   d0
                asl.l   #8,d0
                divs.w  d1,d0
                neg.w   d0

; Store the division remainder in fractional X and clear fractional Y
SKLRZChainPlat_StoreYDominantSpeed:
                move.w  d0,x_vel(a0)
                move.w  d3,y_vel(a0)
                swap    d0
                move.w  d0,$12(a0)
                clr.w   $16(a0)
                rts
; ---------------------------------------------------------------------------

SKLRZChainPlat_CalcMinorYSpeed:
                move.w  y_pos(a0),d1
                sub.w   $3A(a0),d1
                beq.s   SKLRZChainPlat_StoreXDominantSpeed
                ext.l   d1
                asl.l   #8,d1
                divs.w  d0,d1
                neg.w   d1

; Store the division remainder in fractional Y and clear fractional X
SKLRZChainPlat_StoreXDominantSpeed:
                move.w  d1,y_vel(a0)
                move.w  d2,x_vel(a0)
                swap    d1
                move.w  d1,$16(a0)
                clr.w   $12(a0)
                rts
; End of function AimLrzChainedPlatformAtWaypoint

; ---------------------------------------------------------------------------
SKLRZChainPlat_RouteOffsets:
                dc.w    SKLRZChainPlat_ShortLoopWaypoints-SKLRZChainPlat_RouteOffsets
                dc.w    SKLRZChainPlat_MediumLoopWaypoints-SKLRZChainPlat_RouteOffsets
                dc.w    SKLRZChainPlat_TallLoopWaypoints-SKLRZChainPlat_RouteOffsets
SKLRZChainPlat_ShortLoopWaypoints:  dc.w    $28
                dc.w    0,     0
                dc.w    -$16,    $A
                dc.w    -$20,   $20
                dc.w    -$20,   $C0
                dc.w    -$16,   $D6
                dc.w    0,   $E0
                dc.w    $16,   $D6
                dc.w    $20,   $C0
                dc.w    $20,   $20
                dc.w    $16,    $A
SKLRZChainPlat_MediumLoopWaypoints: dc.w    $28
                dc.w    0,     0
                dc.w    -$16,    $A
                dc.w    -$20,   $20
                dc.w    -$20,  $140
                dc.w    -$16,  $156
                dc.w    0,  $160
                dc.w    $16,  $156
                dc.w    $20,  $140
                dc.w    $20,   $20
                dc.w    $16,    $A
SKLRZChainPlat_TallLoopWaypoints:   dc.w    $28
                dc.w    0,     0
                dc.w    -$16,    $A
                dc.w    -$20,   $20
                dc.w    -$20,  $1C0
                dc.w    -$16,  $1D6
                dc.w    0,  $1E0
                dc.w    $16,  $1D6
                dc.w    $20,  $1C0
                dc.w    $20,   $20
                dc.w    $16,    $A
SKLRZChainPlat_GroupOffsets:
                dc.w    SKLRZChainPlat_ShortLoopGroup-SKLRZChainPlat_GroupOffsets
                dc.w    SKLRZChainPlat_MediumLoopGroup-SKLRZChainPlat_GroupOffsets
                dc.w    SKLRZChainPlat_TallLoopGroup-SKLRZChainPlat_GroupOffsets
SKLRZChainPlat_ShortLoopGroup:  dc.w    4-1
                dc.w    0,     0,     1
                dc.w    -$20,   $70,     3
                dc.w    0,   $E0,     6
                dc.w    $20,   $70,     8
SKLRZChainPlat_MediumLoopGroup: dc.w    4-1
                dc.w    0,     0,   $11
                dc.w    -$20,   $B0,   $13
                dc.w    0,  $160,   $16
                dc.w    $20,   $B0,   $18
SKLRZChainPlat_TallLoopGroup:   dc.w    8-1
                dc.w    0,     0,   $21
                dc.w    -$20,   $72,   $23
                dc.w    -$20,   $F0,   $23
                dc.w    -$20,  $16E,   $23
                dc.w    0,  $1E0,   $26
                dc.w    $20,  $16E,   $28
                dc.w    $20,   $F0,   $28
                dc.w    $20,   $72,   $28
Map_LRZChainedPlatforms:
                include "src/objects/shared/zones/lrz/mappings/chained_platforms.s"
