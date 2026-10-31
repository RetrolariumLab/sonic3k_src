; Owner: objects/terrain/icz/sk
; Responsibility: IceCap ice-spike hazards and their private child construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZIceSpikes:
                jsr     Obj_WaitOffscreen(pc)
                lea     ObjDat_ICZIceSpikes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                tst.b   subtype(a0)
                bne.s   loc_8B2CC
                move.l  #loc_8B2DA,(a0)
                lea     ChildObjDat_8B35C(pc),a2
                btst    #1,render_flags(a0)
                beq.s   loc_8B2C8
                lea     ChildObjDat_8B364(pc),a2

loc_8B2C8:
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_8B2CC:
                move.l  #loc_8B2EE,(a0)
                move.b  #$92,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_8B2DA:
                moveq   #$17,d1
                moveq   #8,d2
                moveq   #8,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_8B2EE:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   loc_8B30C
                move.l  #loc_8B310,(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_8B328,$34(a0)

loc_8B30C:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_8B310:
                moveq   #2,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   loc_8B31C
                neg.w   d0

loc_8B31C:
                add.w   d0,x_pos(a0)
                jsr     Obj_Wait(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_8B328:
                move.l  #MoveTouchChkDel,(a0)

locret_8B32E:
                rts
; ---------------------------------------------------------------------------

loc_8B330:
                move.b  #$98,collision_flags(a0)
                jsr     (Add_SpriteToCollisionResponseList).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.w   locret_8B32E
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
ObjDat_ICZIceSpikes:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $C, $10,   5,   0
ChildObjDat_8B35C:
                dc.w    1-1
                dc.l    loc_8B330
                dc.b    0,  $C
ChildObjDat_8B364:
                dc.w    1-1
                dc.l    loc_8B330
                dc.b    0, -$C
