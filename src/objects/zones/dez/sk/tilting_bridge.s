; Owner: objects/zones/dez/sk
; Responsibility: Tilting bridge coordination, motion and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZTiltingBridge:
                move.w  x_pos(a0),d2
                move.w  d2,$44(a0)
                subi.w  #$70,d2
                moveq   #8-1,d1
                movea.l a0,a1
                moveq   #1,d4
                bra.s   SKDEZTiltBridge_InitSegmentAndRootLink
; ---------------------------------------------------------------------------

SKDEZTiltBridge_TryAllocNextSegment:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKDEZTiltBridge_InitRootUpdate

SKDEZTiltBridge_InitSegmentAndRootLink:
                move.l  #SKDEZTiltBridge_GetP1Influence,(a1)
                move.w  d2,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  $44(a0),$44(a1)
                move.w  y_pos(a0),$46(a1)
                move.l  #Map_DEZTiltingBridge,mappings(a1)
                move.w  #make_art_tile(ArtTile_DEZMisc,1,0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.w  #$280,priority(a1)
                bset    #7,status(a1)
                move.w  a0,$3E(a1)
                move.w  d4,$38(a1)
                addq.w  #1,d4
                addi.w  #$20,d2
                dbf     d1,SKDEZTiltBridge_TryAllocNextSegment

SKDEZTiltBridge_InitRootUpdate:
                move.l  #SKDEZTiltBridge_SaveRidersAndCheckTilt,(a0)

SKDEZTiltBridge_SaveRidersAndCheckTilt:
                move.w  $34(a0),$30(a0)
                move.w  $36(a0),$32(a0)
                move.w  #0,$34(a0)
                move.w  #0,$36(a0)
                move.w  y_pos(a0),d0
                sub.w   $46(a0),d0
                bpl.s   SKDEZTiltBridge_TryLatchBridgeBreak
                neg.w   d0

SKDEZTiltBridge_TryLatchBridgeBreak:
                cmpi.w  #$70,d0
                blo.s   SKDEZTiltBridge_GetP1Influence
                move.b  #1,$2E(a0)

SKDEZTiltBridge_GetP1Influence:
                movea.w $3E(a0),a1
                move.w  $30(a1),d0
                beq.s   SKDEZTiltBridge_GetP2Influence
                lsl.w   #3,d0
                add.w   $38(a0),d0
                subi.w  #9,d0
                move.b  SKDEZTiltBridge_RiderInfluenceTable(pc,d0.w),d0
                ext.w   d0
                add.w   d0,d0

SKDEZTiltBridge_GetP2Influence:
                move.w  $32(a1),d1
                beq.s   SKDEZTiltBridge_MoveSegmentAndTrackP1
                lsl.w   #3,d1
                add.w   $38(a0),d1
                subi.w  #9,d1
                move.b  SKDEZTiltBridge_RiderInfluenceTable(pc,d1.w),d1
                ext.w   d1
                add.w   d1,d1

SKDEZTiltBridge_MoveSegmentAndTrackP1:
                add.w   d1,d0
                ext.l   d0
                add.l   d0,$3A(a0)
                move.l  $3A(a0),d0
                add.l   d0,y_pos(a0)
                btst    #p1_standing_bit,status(a0)
                beq.s   SKDEZTiltBridge_TryTrackP2
                move.w  $38(a0),$34(a1)

SKDEZTiltBridge_TryTrackP2:
                btst    #p2_standing_bit,status(a0)
                beq.s   SKDEZTiltBridge_TryScheduleSegmentBreak
                move.w  $38(a0),$36(a1)

SKDEZTiltBridge_TryScheduleSegmentBreak:
                tst.b   $2E(a1)
                beq.s   SKDEZTiltBridge_CheckSolidAndCull
                move.l  #SKDEZTiltBridge_BeginSegmentFall,(a0)

SKDEZTiltBridge_CheckSolidAndCull:
                move.w  #$1B,d1
                move.w  #$10,d2
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.w  $44(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
; Each rider's segment selects one row of eight signed accelerations
SKDEZTiltBridge_RiderInfluenceTable:
                dc.b    $70, $50, $30, $10,-$10,-$30,-$50,-$70
                dc.b    $54, $3C, $24,  $C, -$C,-$24,-$3C,-$54
                dc.b    $38, $28, $18,   8,  -8,-$18,-$28,-$38
                dc.b    $1C, $14,  $C,   4,  -4, -$C,-$14,-$1C
                dc.b    -$1C,-$14, -$C,  -4,   4,  $C, $14, $1C
                dc.b    -$38,-$28,-$18,  -8,   8, $18, $28, $38
                dc.b    -$54,-$3C,-$24, -$C,  $C, $24, $3C, $54
                dc.b    -$70,-$50,-$30,-$10, $10, $30, $50, $70
                even
; ---------------------------------------------------------------------------

SKDEZTiltBridge_BeginSegmentFall:
                move.l  $3A(a0),d0
                asl.l   #2,d0
                move.l  d0,$3A(a0)
                move.l  #SKDEZTiltBridge_FallAndCheckCameraDepth,(a0)

SKDEZTiltBridge_FallAndCheckCameraDepth:
                move.l  #$1000,d0
                add.l   d0,$3A(a0)
                move.l  $3A(a0),d0
                add.l   d0,y_pos(a0)
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$110,d0
                cmp.w   y_pos(a0),d0
                bgt.s   SKDEZTiltBridge_CheckSolidAndRelease
                move.w  #$7F00,x_pos(a0)
                move.w  #$7F00,$44(a0)

SKDEZTiltBridge_CheckSolidAndRelease:
                move.w  #$1B,d1
                move.w  #$10,d2
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jsr     (CheckPlayerReleaseFromObj).l
                move.w  $44(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
Map_DEZTiltingBridge:
                include "src/objects/shared/zones/dez/mappings/tilting_bridge.s"
; End of function Obj_DEZTiltingBridge
