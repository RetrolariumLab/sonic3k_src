; Owner: objects/terrain/icz/s3
; Responsibility: IceCap segmented column movement, collision and private child records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZSegmentColumn:
                lea     ObjDat_ICZSegmentColumn(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #Sprite_CheckDelete2,(a0)
                lea     S3ICZSegColumn_ThreeSegmentChildren(pc),a2
                tst.b   subtype(a0)
                beq.s   S3ICZSegColumn_SpawnLinkedSegments
                lea     S3ICZSegColumn_FourSegmentChildren(pc),a2

S3ICZSegColumn_SpawnLinkedSegments:
                jmp     CreateChild8_TreeListRepeated(pc)
; ---------------------------------------------------------------------------

S3ICZSegColumn_InitColumnSegment:
                lea     S3ICZSegColumn_SegmentAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #S3ICZSegColumn_CheckPredecessorBreak,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                cmpi.b  #6,d0
                bne.s   S3ICZSegColumn_PlaceSegmentBySubtype
                move.b  #3,mapping_frame(a0)

S3ICZSegColumn_PlaceSegmentBySubtype:
                lsl.w   #4,d0
                sub.w   d0,y_pos(a0)
                bra.w   S3ICZSegColumn_DrawWhileRootActive
; ---------------------------------------------------------------------------

S3ICZSegColumn_CheckPredecessorBreak:
                movea.w parent3(a0),a1
                btst    #0,$38(a1)
                bne.s   S3ICZSegColumn_BeginStaggeredCollapse
                move.w  (Player_1+x_vel).w,-(sp)
                move.w  (Player_2+x_vel).w,-(sp)
                bsr.w   CollideIczColumnSegmentAsSolidRectangle
                move.l  (sp)+,d0
                moveq   #p1_pushing_bit,d1
                cmpi.b  #3,mapping_frame(a0)
                beq.s   S3ICZSegColumn_DrawAfterSolidPass
                tst.b   subtype(a0)
                bne.s   S3ICZSegColumn_DrawAfterSolidPass
                lea     (Player_1).w,a1
                bsr.w   ICZColumn_TryBreakBaseOnRoll
                lea     (Player_2).w,a1
                swap    d0
                addq.b  #p2_pushing_bit-p1_pushing_bit,d1
                bsr.w   ICZColumn_TryBreakBaseOnRoll

S3ICZSegColumn_DrawAfterSolidPass:
                bra.w   S3ICZSegColumn_DrawWhileRootActive
; ---------------------------------------------------------------------------

S3ICZSegColumn_BeginStaggeredCollapse:
                move.l  #S3ICZSegColumn_TickCollapseDelay,(a0)
                bset    #0,$38(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #2,d0
                addi.w  #$F,d0
                move.w  d0,$2E(a0)
                move.l  #S3ICZSegColumn_BeginSegmentDrop,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZSegColumn_TickCollapseDelay:
                bsr.w   CollideIczColumnSegmentAsSolidRectangle
                jsr     Obj_Wait(pc)
                bra.w   S3ICZSegColumn_DrawWhileRootActive
; ---------------------------------------------------------------------------

S3ICZSegColumn_BeginSegmentDrop:
                move.l  #S3ICZSegColumn_DropSolidSegment,(a0)
                move.w  #7,$2E(a0)
                move.l  #S3ICZSegColumn_FinishDropAndShake,$34(a0)
                subq.b  #2,subtype(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZSegColumn_DropSolidSegment:
                bsr.w   CollideIczColumnSegmentAsSolidRectangle
                addq.w  #4,y_pos(a0)
                jsr     Obj_Wait(pc)
                bra.w   S3ICZSegColumn_DrawWhileRootActive
; ---------------------------------------------------------------------------

S3ICZSegColumn_FinishDropAndShake:
                move.l  #S3ICZSegColumn_CheckPredecessorBreak,(a0)
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
                beq.s   S3ICZSegColumn_BreakCheckReturn
                move.w  d0,d3
                tst.w   d3
                bpl.s   S3ICZSegColumn_TryBreakRollingBase
                neg.w   d3

; Test the saved pre-collision speed and restore it on a successful break
S3ICZSegColumn_TryBreakRollingBase:
                cmpi.b  #2,anim(a1)
                bne.s   S3ICZSegColumn_BreakCheckReturn
                cmpi.w  #$600,d3
                blo.s   S3ICZSegColumn_BreakCheckReturn
                move.w  d0,x_vel(a1)
                move.w  d0,ground_vel(a1)
                bclr    d1,status(a0)
                bclr    d1,status(a1)
                bset    #0,$38(a0)
                lea     S3ICZFreezer_ShellShardChildren(pc),a2
                jsr     CreateChild1_Normal(pc)
                jsr     Displace_PlayerOffObject(pc)
                jsr     Go_Delete_Sprite(pc)
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                addq.w  #4,sp

; A successful break discards the caller's return address to skip the normal draw path
S3ICZSegColumn_BreakCheckReturn:
                rts
; End of function ICZColumn_TryBreakBaseOnRoll

; ---------------------------------------------------------------------------

S3ICZSegColumn_DrawWhileRootActive:
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
S3ICZSegColumn_SegmentAttrs:
                dc.w    $280
                dc.b    $20, $10,  $A,   0
S3ICZSegColumn_ThreeSegmentChildren:
                dc.w    3-1
                dc.l    S3ICZSegColumn_InitColumnSegment
                dc.b    0,   0
S3ICZSegColumn_FourSegmentChildren:
                dc.w    4-1
                dc.l    S3ICZSegColumn_InitColumnSegment
                dc.b    0,   0
