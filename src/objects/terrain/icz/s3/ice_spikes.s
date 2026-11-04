; Owner: objects/terrain/icz/s3
; Responsibility: IceCap ice-spike hazards and their private child construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZIceSpikes:
                jsr     Obj_WaitOffscreen(pc)
                lea     ObjDat_ICZIceSpikes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                tst.b   subtype(a0)
                bne.s   S3ICZIceSpike_InitFallingSpike
                move.l  #S3ICZIceSpike_UpdateStationarySpike,(a0)
                lea     S3ICZIceSpike_LowerContactChild(pc),a2
                btst    #1,render_flags(a0)
                beq.s   S3ICZIceSpike_SpawnContactChild
                lea     S3ICZIceSpike_UpperContactChild(pc),a2

S3ICZIceSpike_SpawnContactChild:
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

S3ICZIceSpike_InitFallingSpike:
                move.l  #S3ICZIceSpike_TryArmShake,(a0)
                move.b  #$92,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZIceSpike_UpdateStationarySpike:
                moveq   #$17,d1
                moveq   #8,d2
                moveq   #8,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

S3ICZIceSpike_TryArmShake:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   S3ICZIceSpike_DrawAndCheckTouch
                move.l  #S3ICZIceSpike_ChooseShakeOffset,(a0)
                move.w  #$F,$2E(a0)
                move.l  #S3ICZIceSpike_BeginFall,$34(a0)

S3ICZIceSpike_DrawAndCheckTouch:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

S3ICZIceSpike_ChooseShakeOffset:
                moveq   #2,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   S3ICZIceSpike_ShakeAndTickRelease
                neg.w   d0

S3ICZIceSpike_ShakeAndTickRelease:
                add.w   d0,x_pos(a0)
                jsr     Obj_Wait(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

S3ICZIceSpike_BeginFall:
                move.l  #MoveTouchChkDel,(a0)

S3ICZIceSpike_UpdateReturn:
                rts
; ---------------------------------------------------------------------------

S3ICZIceSpike_UpdateContactChild:
                move.b  #$98,collision_flags(a0)
                jsr     (Add_SpriteToCollisionResponseList).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.w   S3ICZIceSpike_UpdateReturn
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
ObjDat_ICZIceSpikes:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $C, $10,   5,   0
S3ICZIceSpike_LowerContactChild:
                dc.w    1-1
                dc.l    S3ICZIceSpike_UpdateContactChild
                dc.b    0,  $C
S3ICZIceSpike_UpperContactChild:
                dc.w    1-1
                dc.l    S3ICZIceSpike_UpdateContactChild
                dc.b    0, -$C
