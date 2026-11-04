; Owner: objects/terrain/icz/sk
; Responsibility: IceCap segmented column movement, collision and private child records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZSegmentColumn:
                lea     ObjDat_ICZSegmentColumn(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #Sprite_CheckDelete2,(a0)
                lea     SKICZSegColumn_ThreeSegmentChildren(pc),a2
                tst.b   subtype(a0)
                beq.s   SKICZSegColumn_SpawnLinkedSegments
                lea     SKICZSegColumn_FourSegmentChildren(pc),a2

SKICZSegColumn_SpawnLinkedSegments:
                jmp     CreateChild8_TreeListRepeated(pc)
; ---------------------------------------------------------------------------
; unused
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   SKICZSegColumn_UnusedCullDelete
                rts
; ---------------------------------------------------------------------------

SKICZSegColumn_UnusedCullDelete:
                jmp     SKCull_ReleaseRespawnForPrivateDelete(pc)
; ---------------------------------------------------------------------------

SKICZSegColumn_InitColumnSegment:
                lea     SKICZSegColumn_SegmentAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #SKICZSegColumn_CheckPredecessorBreak,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                cmpi.b  #6,d0
                bne.s   SKICZSegColumn_PlaceSegmentBySubtype
                move.b  #3,mapping_frame(a0)

SKICZSegColumn_PlaceSegmentBySubtype:
                lsl.w   #4,d0
                sub.w   d0,y_pos(a0)
                bra.w   SKICZSegColumn_DrawWhileRootActive
; ---------------------------------------------------------------------------

SKICZSegColumn_CheckPredecessorBreak:
                tst.b   subtype(a0)
                beq.s   SKICZSegColumn_CheckBottomBreak
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                bne.s   SKICZSegColumn_BeginStaggeredCollapse

SKICZSegColumn_CheckBottomBreak:
                move.w  (Player_1+x_vel).w,-(sp)
                move.w  (Player_2+x_vel).w,-(sp)
                bsr.w   CollideIczColumnSegmentAsSolidRectangle
                move.l  (sp)+,d0
                moveq   #p1_pushing_bit,d1
                cmpi.b  #3,mapping_frame(a0)
                beq.s   SKICZSegColumn_DrawAfterSolidPass
                tst.b   subtype(a0)
                bne.s   SKICZSegColumn_DrawAfterSolidPass
                lea     (Player_1).w,a1
                bsr.w   ICZColumn_TryBreakBaseOnRoll
                lea     (Player_2).w,a1
                swap    d0
                addq.b  #p2_pushing_bit-p1_pushing_bit,d1
                bsr.w   ICZColumn_TryBreakBaseOnRoll

SKICZSegColumn_DrawAfterSolidPass:
                bra.w   SKICZSegColumn_DrawWhileRootActive
; ---------------------------------------------------------------------------

SKICZSegColumn_BeginStaggeredCollapse:
                move.l  #SKICZSegColumn_TickCollapseDelay,(a0)
                bset    #0,$38(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #2,d0
                addi.w  #$F,d0
                move.w  d0,$2E(a0)
                move.l  #SKICZSegColumn_BeginSegmentDrop,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKICZSegColumn_TickCollapseDelay:
                bsr.w   CollideIczColumnSegmentAsSolidRectangle
                jsr     Obj_Wait(pc)
                bra.w   SKICZSegColumn_DrawWhileRootActive
; ---------------------------------------------------------------------------

SKICZSegColumn_BeginSegmentDrop:
                move.l  #SKICZSegColumn_DropSolidSegment,(a0)
                move.w  #7,$2E(a0)
                move.l  #SKICZSegColumn_FinishDropAndShake,$34(a0)
                subq.b  #2,subtype(a0)
                rts
; ---------------------------------------------------------------------------

SKICZSegColumn_DropSolidSegment:
                bsr.w   CollideIczColumnSegmentAsSolidRectangle
                addq.w  #4,y_pos(a0)
                jsr     Obj_Wait(pc)
                bra.w   SKICZSegColumn_DrawWhileRootActive
; ---------------------------------------------------------------------------

SKICZSegColumn_FinishDropAndShake:
                move.l  #SKICZSegColumn_CheckPredecessorBreak,(a0)
                bclr    #0,$38(a0)
                move.w  #$10,(Screen_shake_flag).w
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                rts

; =============== S U B R O U T I N E =======================================

CollideIczColumnSegmentAsSolidRectangle:
                moveq   #$2B,d1
                moveq   #$10,d2
                moveq   #$10,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function CollideIczColumnSegmentAsSolidRectangle

; =============== S U B R O U T I N E =======================================

; Require a pushing rolling player with saved speed magnitude of at least $600. On break, skip the caller's remaining update
ICZColumn_TryBreakBaseOnRoll:
                btst    d1,status(a0)
                beq.s   SKICZSegColumn_BreakCheckReturn
                move.w  d0,d3
                tst.w   d3
                bpl.s   SKICZSegColumn_TryBreakRollingBase
                neg.w   d3

; Test the saved pre-collision speed and restore it on a successful break
SKICZSegColumn_TryBreakRollingBase:
                cmpi.b  #2,anim(a1)
                bne.s   SKICZSegColumn_BreakCheckReturn
                cmpi.w  #$600,d3
                blo.s   SKICZSegColumn_BreakCheckReturn
                move.w  d0,x_vel(a1)
                move.w  d0,ground_vel(a1)
                bclr    d1,status(a0)
                bclr    d1,status(a1)
                bset    #0,$38(a0)
                lea     SKICZFreezer_ShellShardChildren(pc),a2
                jsr     CreateChild1_Normal(pc)
                jsr     Displace_PlayerOffObject(pc)
                jsr     Go_Delete_Sprite(pc)
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                addq.w  #4,sp

; A successful break discards the caller's return address to skip the normal draw path
SKICZSegColumn_BreakCheckReturn:
                rts
; End of function ICZColumn_TryBreakBaseOnRoll

; ---------------------------------------------------------------------------

SKICZSegColumn_DrawWhileRootActive:
                movea.w $44(a0),a1
                btst    #4,$38(a1)
                bne.w   Go_Delete_Sprite_2
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
ObjDat_ICZSegmentColumn:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $20, $10,  $B,   0
SKICZSegColumn_SegmentAttrs:
                dc.w    $280
                dc.b    $20, $10,  $A,   0
SKICZSegColumn_ThreeSegmentChildren:
                dc.w    3-1
                dc.l    SKICZSegColumn_InitColumnSegment
                dc.b    0,   0
SKICZSegColumn_FourSegmentChildren:
                dc.w    4-1
                dc.l    SKICZSegColumn_InitColumnSegment
                dc.b    0,   0
