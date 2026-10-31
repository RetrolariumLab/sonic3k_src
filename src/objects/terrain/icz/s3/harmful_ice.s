; Owner: objects/terrain/icz/s3
; Responsibility: IceCap harmful ice collision controller and private object or child descriptors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZHarmfulIce:
                jsr     Obj_WaitOffscreen(pc)
                lea     ObjDat3_58CCA(pc),a1
                move.l  #Sprite_CheckDeleteTouch,(a0)
                tst.b   subtype(a0)
                beq.s   loc_58C88
                lea     ObjDat3_58CD6(pc),a1
                move.l  #loc_58C8C,(a0)

loc_58C88:
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_58C8C:
                moveq   #0,d0
                move.b  collision_property(a0),d0
                bne.s   loc_58C98
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_58C98:
                add.w   d0,d0
                movea.w word_58CC4-2(pc,d0.w),a1
; Bug: no invincibility or invulnerability checks are performed,
; allowing Super Sonic to be hurt
                movea.l a0,a2
                movea.l a1,a0
                jsr     (HurtCharacter).l
                movea.l a2,a0

                lea     ChildObjDat_58CE2(pc),a2
                jsr     CreateChild6_Simple(pc)
                jsr     Go_Delete_Sprite(pc)
                moveq   #signextendB(sfx_IceSpikes),d0
                jsr     (Play_SFX).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
word_58CC4:
                dc.w    Player_1
                dc.w    Player_2
                dc.w    Player_1
ObjDat3_58CCA:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $10, $18,   5, $82
ObjDat3_58CD6:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $10, $10,   4, $D7
ChildObjDat_58CE2:
                dc.w    $C-1
                dc.l    loc_589E8
; End of function Obj_ICZHarmfulIce
