; Owner: objects/terrain/icz/sk
; Responsibility: IceCap ice-spike hazards and their private child construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZIceSpikes:
                jsr     Obj_WaitOffscreen(pc)
                lea     ObjDat_ICZIceSpikes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                tst.b   subtype(a0)
                bne.s   SKICZIceSpike_InitFallingSpike
                move.l  #SKICZIceSpike_UpdateStationarySpike,(a0)
                lea     SKICZIceSpike_LowerContactChild(pc),a2
                btst    #1,render_flags(a0)
                beq.s   SKICZIceSpike_SpawnContactChild
                lea     SKICZIceSpike_UpperContactChild(pc),a2

SKICZIceSpike_SpawnContactChild:
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

SKICZIceSpike_InitFallingSpike:
                move.l  #SKICZIceSpike_TryArmShake,(a0)
                move.b  #$92,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

SKICZIceSpike_UpdateStationarySpike:
                moveq   #$17,d1
                moveq   #8,d2
                moveq   #8,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

SKICZIceSpike_TryArmShake:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   SKICZIceSpike_DrawAndCheckTouch
                move.l  #SKICZIceSpike_ChooseShakeOffset,(a0)
                move.w  #$F,$2E(a0)
                move.l  #SKICZIceSpike_BeginFall,$34(a0)

SKICZIceSpike_DrawAndCheckTouch:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

SKICZIceSpike_ChooseShakeOffset:
                moveq   #2,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   SKICZIceSpike_ShakeAndTickRelease
                neg.w   d0

SKICZIceSpike_ShakeAndTickRelease:
                add.w   d0,x_pos(a0)
                jsr     Obj_Wait(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

SKICZIceSpike_BeginFall:
                move.l  #MoveTouchChkDel,(a0)

SKICZIceSpike_UpdateReturn:
                rts
; ---------------------------------------------------------------------------

SKICZIceSpike_UpdateContactChild:
                move.b  #$98,collision_flags(a0)
                jsr     (Add_SpriteToCollisionResponseList).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.w   SKICZIceSpike_UpdateReturn
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
ObjDat_ICZIceSpikes:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $C, $10,   5,   0
SKICZIceSpike_LowerContactChild:
                dc.w    1-1
                dc.l    SKICZIceSpike_UpdateContactChild
                dc.b    0,  $C
SKICZIceSpike_UpperContactChild:
                dc.w    1-1
                dc.l    SKICZIceSpike_UpdateContactChild
                dc.b    0, -$C
