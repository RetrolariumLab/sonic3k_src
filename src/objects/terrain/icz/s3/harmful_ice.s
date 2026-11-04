; Owner: objects/terrain/icz/s3
; Responsibility: IceCap harmful ice collision controller and private object or child descriptors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZHarmfulIce:
                jsr     Obj_WaitOffscreen(pc)
                lea     S3ICZHarmIce_SolidHazardAttrs(pc),a1
                move.l  #Sprite_CheckDeleteTouch,(a0)
                tst.b   subtype(a0)
                beq.s   S3ICZHarmIce_ApplySubtypeAttrs
                lea     S3ICZHarmIce_ShatteringHazardAttrs(pc),a1
                move.l  #S3ICZHarmIce_CheckRecordedContact,(a0)

S3ICZHarmIce_ApplySubtypeAttrs:
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

S3ICZHarmIce_CheckRecordedContact:
                moveq   #0,d0
                move.b  collision_property(a0),d0
                bne.s   S3ICZHarmIce_TryHurtContactPlayer
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

S3ICZHarmIce_TryHurtContactPlayer:
                add.w   d0,d0
                movea.w S3ICZHarmIce_ContactPlayerTable-2(pc,d0.w),a1
; Bug: no invincibility or invulnerability checks are performed,
; allowing Super Sonic to be hurt
                movea.l a0,a2
                movea.l a1,a0
                jsr     (HurtCharacter).l
                movea.l a2,a0

                lea     S3ICZHarmIce_IceShardChildren(pc),a2
                jsr     CreateChild6_Simple(pc)
                jsr     Go_Delete_Sprite(pc)
                moveq   #signextendB(sfx_IceSpikes),d0
                jsr     (Play_SFX).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
S3ICZHarmIce_ContactPlayerTable:
                dc.w    Player_1
                dc.w    Player_2
                dc.w    Player_1
S3ICZHarmIce_SolidHazardAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $10, $18,   5, $82
S3ICZHarmIce_ShatteringHazardAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $10, $10,   4, $D7
S3ICZHarmIce_IceShardChildren:
                dc.w    $C-1
                dc.l    S3ICZStalactite_InitIceShard
; End of function Obj_ICZHarmfulIce
