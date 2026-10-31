; Owner: objects/terrain/icz/s3
; Responsibility: IceCap ice-spike hazards and their private child construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZIceSpikes:
                jsr     Obj_WaitOffscreen(pc)
                lea     ObjDat_ICZIceSpikes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                tst.b   subtype(a0)
                bne.s   loc_58A84
                move.l  #loc_58A92,(a0)
                lea     ChildObjDat_58B14(pc),a2
                btst    #1,render_flags(a0)
                beq.s   loc_58A80
                lea     ChildObjDat_58B1C(pc),a2

loc_58A80:
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_58A84:
                move.l  #loc_58AA6,(a0)
                move.b  #$92,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_58A92:
                moveq   #$17,d1
                moveq   #8,d2
                moveq   #8,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_58AA6:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   loc_58AC4
                move.l  #loc_58AC8,(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_58AE0,$34(a0)

loc_58AC4:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_58AC8:
                moveq   #2,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   loc_58AD4
                neg.w   d0

loc_58AD4:
                add.w   d0,x_pos(a0)
                jsr     Obj_Wait(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_58AE0:
                move.l  #MoveTouchChkDel,(a0)

locret_58AE6:
                rts
; ---------------------------------------------------------------------------

loc_58AE8:
                move.b  #$98,collision_flags(a0)
                jsr     (Add_SpriteToCollisionResponseList).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.w   locret_58AE6
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
ObjDat_ICZIceSpikes:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $C, $10,   5,   0
ChildObjDat_58B14:
                dc.w    1-1
                dc.l    loc_58AE8
                dc.b    0,  $C
ChildObjDat_58B1C:
                dc.w    1-1
                dc.l    loc_58AE8
                dc.b    0, -$C
