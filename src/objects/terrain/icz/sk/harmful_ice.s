; Owner: objects/terrain/icz/sk
; Responsibility: IceCap harmful ice collision controller and private object or child descriptors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZHarmfulIce:
                jsr     Obj_WaitOffscreen(pc)
                lea     ObjDat3_8B532(pc),a1
                move.l  #Sprite_CheckDeleteTouch,(a0)
                tst.b   subtype(a0)
                beq.s   loc_8B4E8
                lea     ObjDat3_8B53E(pc),a1
                move.l  #loc_8B4EC,(a0)

loc_8B4E8:
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_8B4EC:
                moveq   #0,d0
                move.b  collision_property(a0),d0
                bne.s   loc_8B4F8
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_8B4F8:
                add.w   d0,d0
                movea.w word_8B52C-2(pc,d0.w),a1
                btst    #Status_Invincible,status_secondary(a1)
                bne.s   loc_8B512
; Bug: no invulnerability check is performed,
; allowing flashing characters to be hurt
                movea.l a0,a2
                movea.l a1,a0
                jsr     (HurtCharacter).l
                movea.l a2,a0

loc_8B512:
                lea     ChildObjDat_8B54A(pc),a2
                jsr     CreateChild6_Simple(pc)
                jsr     Go_Delete_Sprite(pc)
                moveq   #signextendB(sfx_IceSpikes),d0
                jsr     (Play_SFX).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
word_8B52C:
                dc.w    Player_1
                dc.w    Player_2
                dc.w    Player_2
ObjDat3_8B532:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $10, $18,   5, $82
ObjDat3_8B53E:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $10, $10,   4, $D7
ChildObjDat_8B54A:
                dc.w    $C-1
                dc.l    loc_8B230
; End of function Obj_ICZHarmfulIce
