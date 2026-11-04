; Owner: objects/terrain/icz/sk
; Responsibility: IceCap harmful ice collision controller and private object or child descriptors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZHarmfulIce:
                jsr     Obj_WaitOffscreen(pc)
                lea     SKICZHarmIce_SolidHazardAttrs(pc),a1
                move.l  #Sprite_CheckDeleteTouch,(a0)
                tst.b   subtype(a0)
                beq.s   SKICZHarmIce_ApplySubtypeAttrs
                lea     SKICZHarmIce_ShatteringHazardAttrs(pc),a1
                move.l  #SKICZHarmIce_CheckRecordedContact,(a0)

SKICZHarmIce_ApplySubtypeAttrs:
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

SKICZHarmIce_CheckRecordedContact:
                moveq   #0,d0
                move.b  collision_property(a0),d0
                bne.s   SKICZHarmIce_TryHurtContactPlayer
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

SKICZHarmIce_TryHurtContactPlayer:
                add.w   d0,d0
                movea.w SKICZHarmIce_ContactPlayerTable-2(pc,d0.w),a1
                btst    #Status_Invincible,status_secondary(a1)
                bne.s   SKICZHarmIce_Shatter
; Bug: no invulnerability check is performed,
; allowing flashing characters to be hurt
                movea.l a0,a2
                movea.l a1,a0
                jsr     (HurtCharacter).l
                movea.l a2,a0

SKICZHarmIce_Shatter:
                lea     SKICZHarmIce_IceShardChildren(pc),a2
                jsr     CreateChild6_Simple(pc)
                jsr     Go_Delete_Sprite(pc)
                moveq   #signextendB(sfx_IceSpikes),d0
                jsr     (Play_SFX).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
SKICZHarmIce_ContactPlayerTable:
                dc.w    Player_1
                dc.w    Player_2
                dc.w    Player_2
SKICZHarmIce_SolidHazardAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $10, $18,   5, $82
SKICZHarmIce_ShatteringHazardAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $10, $10,   4, $D7
SKICZHarmIce_IceShardChildren:
                dc.w    $C-1
                dc.l    SKICZStalactite_InitIceShard
; End of function Obj_ICZHarmfulIce
