; Owner: objects/enemies/aiz/sk
; Responsibility: Bloominator enemy states, projectiles and child resources, including the shared callback projectile initializer referenced by enemy child records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

SKCallbackShot_InitDeflectable:
                movea.l $3E(a0),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SKCallbackShot_UpdateAndDraw,(a0)
                bset    #3,shield_reaction(a0)

SKCallbackShot_UpdateAndDraw:
                movea.l $34(a0),a1
                jsr     (a1)
                jmp     (Sprite_CheckDeleteTouchXY).l
; ---------------------------------------------------------------------------

Obj_Bloominator:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Bloominator_Index(pc,d0.w),d1
                jsr     Bloominator_Index(pc,d1.w)
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------
Bloominator_Index:
                dc.w    SKBloominator_InitAndWait-Bloominator_Index
                dc.w    SKBloominator_TickVisibleWait-Bloominator_Index
                dc.w    SKBloominator_AnimateAndCheckShot-Bloominator_Index
; ---------------------------------------------------------------------------

SKBloominator_InitAndWait:
                lea     ObjDat_Bloominator(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  #$1F,$2E(a0)
                move.l  #SKBloominator_StartAttackAnim,$34(a0)

SKBloominator_StateReturn:
                rts
; ---------------------------------------------------------------------------

SKBloominator_TickVisibleWait:
                tst.b   render_flags(a0)
                bpl.w   SKBloominator_StateReturn
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

SKBloominator_StartAttackAnim:
                move.b  #4,routine(a0)
                move.l  #SKBloominator_AttackAnim,$30(a0)
                move.l  #SKBloominator_RearmAttackWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

; Shoot at raw animation cursor offsets $06 and $0E
SKBloominator_AnimateAndCheckShot:
                jsr     Animate_RawMultiDelay(pc)
                beq.s   SKBloominator_StateReturn
                cmpi.b  #6,d0
                beq.s   SKBloominator_TrySpawnAlternatingShot
                cmpi.b  #$E,d0
                bne.s   SKBloominator_StateReturn

; Advance the direction counter only after allocating a projectile
SKBloominator_TrySpawnAlternatingShot:
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                lea     SKBloominator_ShotChildRecord(pc),a2
                jsr     CreateChild2_Complex(pc)
                bne.s   BloominatorSK_ReturnAfterShotAttempt
                addq.b  #1,$39(a0)
                btst    #0,$39(a0)
                beq.s   BloominatorSK_ReturnAfterShotAttempt
                neg.w   x_vel(a1)

BloominatorSK_ReturnAfterShotAttempt:
                rts
; ---------------------------------------------------------------------------

SKBloominator_RearmAttackWait:
                move.b  #2,routine(a0)
                move.w  #2*60,$2E(a0)
                move.l  #SKBloominator_StartAttackAnim,$34(a0)
                rts
; ---------------------------------------------------------------------------
ObjDat_Bloominator:
                dc.l    Map_Bloominator
                dc.w    make_art_tile(ArtTile_Bloominator,1,0)
                dc.w    $200
                dc.b    $C, $18,   0, $23
BloominatorSK_ProjectileFullAttributes:
                dc.l    Map_Bloominator
                dc.w    make_art_tile(ArtTile_Bloominator,1,0)
                dc.w    $280
                dc.b    8,   8,   4, $98
SKBloominator_ShotChildRecord:
                dc.w    1-1
                dc.l    SKCallbackShot_InitDeflectable
                dc.l    BloominatorSK_ProjectileFullAttributes
                dc.l    0
                dc.l    MoveSprite
                dc.b    0,-$10
                dc.w    $100, -$500
SKBloominator_AttackAnim:
                dc.b    0,   7
                dc.b    1,   9
                dc.b    2,   4
                dc.b    3,   4
                dc.b    0,   9
                dc.b    1,   9
                dc.b    2,   4
                dc.b    3,   4
                dc.b    0,   0
                dc.b    $F4
                even
