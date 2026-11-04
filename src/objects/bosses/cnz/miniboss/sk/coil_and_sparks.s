; Owner: objects/bosses/cnz/miniboss/sk
; Responsibility: Carnival Night miniboss coil, timed sparks, bounce effect and debris actors
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_CNZMinibossCoil:
                move.l  #Obj_CNZMinibossCoilClose,(a0)
                move.b  #$1A,collision_flags(a0)
                move.b  #$70,collision_property(a0)
                bclr    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

Obj_CNZMinibossCoilClose:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   CNZMiniSK_DeleteCoilOrSpark
                btst    #6,$38(a1)
                bne.s   CNZMiniSK_CoilBeginOpenTouch
                jsr     (Refresh_ChildPosition).l       ; If base is not open
                movea.w parent3(a0),a1
                tst.b   collision_flags(a0)
                bne.s   CNZMiniSK_ClosedCoilResetTouch  ; Skip if collision is set
                bset    #2,$38(a0)
                bne.s   CNZMiniSK_ClosedCoilTickStun    ; If $38 already set, branch
                move.b  #$10,$3A(a0)
                btst    #2,$38(a1)
                bne.s   CNZMiniSK_ClosedCoilTickStun    ; If base has been stunned already, branch
                move.b  collision_flags(a1),$25(a1)     ; Backup parent collision
                clr.b   collision_flags(a1)             ; Unset parent collision
                subq.b  #1,collision_property(a1)       ; Remove a hit

CNZMiniSK_ClosedCoilTickStun:
                subq.b  #1,$3A(a0)
                bpl.w   CNZMiniSK_SharedReturn
                bclr    #2,$38(a0)
                move.b  $25(a0),collision_flags(a0)     ; Restore collision

CNZMiniSK_ClosedCoilResetTouch:
                move.b  #$70,collision_property(a0)
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

CNZMiniSK_CoilBeginOpenTouch:
                move.l  #Obj_CNZMinibossCoilOpen,(a0)
                move.b  #$A9,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

CNZMiniSK_DeleteCoilOrSpark:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_CNZMinibossCoilOpen:
                jsr     (Refresh_ChildPosition).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   CNZMiniSK_DeleteCoilOrSpark
                btst    #6,$38(a1)
                beq.w   Obj_CNZMinibossCoil             ; If parent closes up
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

CNZMiniSK_InitAuxiliaryTouchActor:
                move.l  #CNZMiniSK_AuxiliaryFollowAndTouch,(a0)
                move.b  #$AA,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

CNZMiniSK_AuxiliaryFollowAndTouch:
                jsr     (Refresh_ChildPosition).l
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

Obj_CNZMinibossTimedSparks:
                lea     ObjDat3_CNZMinibossSpark(pc),a1  ; Temporary sparks when boss is closed
                jsr     (SetUp_ObjAttributes3).l
                bset    #5,shield_reaction(a0)
                move.l  #Obj_Wait,(a0)
                move.l  #Obj_CNZMinibossTimedSparksGo,$34(a0)
                move.l  #AniRaw_CNZMinibossTimedSparkLeft,$30(a0)
                tst.b   subtype(a0)
                beq.s   CNZMiniSK_TimedSparkInitReturn
                move.l  #AniRaw_CNZMinibossTimedSparkRight,$30(a0)
                move.w  #2,$2E(a0)

CNZMiniSK_TimedSparkInitReturn:
                rts
; ---------------------------------------------------------------------------

Obj_CNZMinibossTimedSparksGo:
                move.l  #Obj_CNZMinibossTimedSparksMain,(a0)
                move.w  #$7F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

Obj_CNZMinibossTimedSparksMain:
                jsr     (Refresh_ChildPosition).l
                jsr     (Animate_RawMultiDelay).l
                jsr     (Obj_Wait).l
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------

Obj_CNZMinibossSparks:
                lea     ObjDat3_CNZMinibossSpark(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                bset    #5,shield_reaction(a0)          ; Player isn't hurt with Lightning Shield
                move.l  #Obj_CNZMinibossSparksMain,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.l  CNZMiniSK_OpenSparkAnimationPointers(pc,d0.w),$30(a0)
                rts
; ---------------------------------------------------------------------------
CNZMiniSK_OpenSparkAnimationPointers:
                dc.l    AniRaw_CNZMinibossSparks1
                dc.l    AniRaw_CNZMinibossSparks2
                dc.l    AniRaw_CNZMinibossSparks3
; ---------------------------------------------------------------------------

Obj_CNZMinibossSparksMain:
                movea.w parent3(a0),a1
                btst    #6,$38(a1)
                beq.w   CNZMiniSK_DeleteCoilOrSpark
                jsr     (Refresh_ChildPosition).l
                jsr     (Animate_RawMultiDelay).l
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------

Obj_CNZMinibossBounceEffect:
                lea     ObjDat3_CNZMbossBounceEffect(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                bset    #5,shield_reaction(a0)
                move.l  #AnimateRaw_DrawTouch,(a0)
                move.w  #$3208,x_pos(a0)
                btst    #0,render_flags(a0)
                beq.s   CNZMiniSK_WallBounceSetDeleteCallback
                move.w  #$3378,x_pos(a0)

CNZMiniSK_WallBounceSetDeleteCallback:
                move.l  #AniRaw_CNZMBossBoundEffect,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

Obj_CNZMinibossDebris:
                lea     ObjDat_CNZMinibossDebris(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  CNZMiniSK_DebrisPlacementOffsets(pc,d0.w),child_dx(a0)  ; and child_dy
                lsr.w   #1,d0
                move.b  CNZMinibossDebris_Frames(pc,d0.w),mapping_frame(a0)
                jsr     (Refresh_ChildPosition).l
                moveq   #0,d0
                jmp     (Set_IndexedVelocity).l
; ---------------------------------------------------------------------------
CNZMiniSK_DebrisPlacementOffsets:
                dc.b    -$10,   0
                dc.b    $10,   0
                dc.b    0, $14
                dc.b    0, $1C
                dc.b    0, $24
                dc.b    0, $2C
                dc.b    0, $34
                dc.b    0, $3C
                dc.b    0, $48
CNZMinibossDebris_Frames:
                dc.b    $12, $13, $14, $14, $14, $14, $14, $14, $15
                even
