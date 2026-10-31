; Owner: objects/terrain/icz/sk
; Responsibility: IceCap falling stalactite state, trigger helper and private child data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZStalagtite:
                jsr     Obj_WaitOffscreen(pc)
                lea     ObjDat_ICZStalagtite(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_8B1AE,(a0)
                move.b  #$10,y_radius(a0)
                rts
; ---------------------------------------------------------------------------

loc_8B1AE:
                bsr.w   sub_8B26A
                jsr     Find_SonicTails(pc)
                cmpi.w  #$70,d2
                bhs.s   loc_8B1D0
                move.l  #loc_8B1D4,(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_8B1EC,$34(a0)

loc_8B1D0:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_8B1D4:
                moveq   #2,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   loc_8B1E0
                neg.w   d0

loc_8B1E0:
                add.w   d0,x_pos(a0)
                jsr     Obj_Wait(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_8B1EC:
                move.l  #loc_8B1FA,(a0)
                move.b  #$82,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_8B1FA:
                jsr     (MoveSprite).l
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   loc_8B224
                move.l  #loc_8B228,(a0)
                clr.b   collision_flags(a0)
                lea     ChildObjDat_8B292(pc),a2
                jsr     CreateChild6_Simple(pc)
                moveq   #signextendB(sfx_FloorThump),d0
                jsr     (Play_SFX).l

loc_8B224:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_8B228:
                bsr.w   sub_8B26A
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_8B230:
                lea     ObjDat3_8B286(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AnimateRaw_MoveChkDel,(a0)
                move.l  #byte_8AB46,$30(a0)
                cmpi.b  #6,subtype(a0)
                bhs.s   loc_8B256
                move.l  #byte_8AB3E,$30(a0)

loc_8B256:
                jsr     (Random_Number).l
                andi.b  #3,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d0
                jmp     Set_IndexedVelocity(pc)

; =============== S U B R O U T I N E =======================================

sub_8B26A:
                moveq   #$1B,d1
                moveq   #$20,d2
                moveq   #$20,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function sub_8B26A

; ---------------------------------------------------------------------------
ObjDat_ICZStalagtite:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $10, $20,   7,   0
ObjDat3_8B286:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,1)
                dc.w    $280
                dc.b    4,   4,  $F,   0
ChildObjDat_8B292:
                dc.w    $C-1
                dc.l    loc_8B230
                dc.b    0, $27
                dc.b    $F, $27, $10, $27, $11, $FC
                even
