; Owner: objects/zones/lbz/s3
; Responsibility: Launch Base triggered bridge activation, movement and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
S3LBZTrigBridge_BridgeConfigs:                          ; X offset, Y offset, X width, Y width, init routine counter, init mapping frame, second routine counter, second mapping frame
                dc.b    $48,   0,   8, $40,   0,   0,  $A,   8
                dc.b    0, $48, $40,   8,   0,   8,  $A, $10
                dc.b    -$48,   0,   8, $40,   0,   0,  $A,   8
                dc.b    0, $48, $40,   8,   0, $10,  $A, $18
                dc.b    0, $48, $40,   8,   6,   8,   4, $10
                dc.b    $48,   0,   8, $40,   6,   0,   4,   8
                dc.b    0, $48, $40,   8,   6, $10,   4, $18
                dc.b    -$48,   0,   8, $40,   6,   0,   4,   8
                even
; ---------------------------------------------------------------------------

Obj_LBZTriggerBridge:
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$F,d1
                tst.b   $34(a0)
                bne.s   S3LBZTrigBridge_SelectBridgeConfig
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d0.w)
                beq.s   S3LBZTrigBridge_SelectBridgeConfig
                addq.w  #4,d0

S3LBZTrigBridge_SelectBridgeConfig:
                lsr.b   #1,d0
                andi.w  #$38,d0
                lea     S3LBZTrigBridge_BridgeConfigs(pc,d0.w),a1
                move.l  #Map_LBZTriggerBridge,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZMisc,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                move.b  (a1)+,d0
                ext.w   d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                move.b  (a1)+,d0
                ext.w   d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a0)
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                moveq   #0,d0
                move.b  (a1)+,d0
                move.w  d0,$36(a0)
                move.b  (a1)+,mapping_frame(a0)
                tst.b   $34(a0)
                beq.s   S3LBZTrigBridge_StartBridgeStates
                move.b  (a1)+,d0
                move.w  d0,$36(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  #0,$34(a0)

S3LBZTrigBridge_StartBridgeStates:
                move.l  #S3LBZTrigBridge_UpdateBridgeAndSolid,(a0)

S3LBZTrigBridge_UpdateBridgeAndSolid:
                move.w  $36(a0),d0
                move.w  S3LBZTrigBridge_BridgeStateTable(pc,d0.w),d1
                jsr     S3LBZTrigBridge_BridgeStateTable(pc,d1.w)
                tst.b   render_flags(a0)
                bpl.s   S3LBZTrigBridge_DrawFromOrigin
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull2).l

S3LBZTrigBridge_DrawFromOrigin:
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
S3LBZTrigBridge_BridgeStateTable:
                dc.w    S3LBZTrigBridge_TrySwitchOn-S3LBZTrigBridge_BridgeStateTable
                dc.w    S3LBZTrigBridge_RetractAndHide-S3LBZTrigBridge_BridgeStateTable
                dc.w    S3LBZTrigBridge_ExtendTowardOffWait-S3LBZTrigBridge_BridgeStateTable
                dc.w    S3LBZTrigBridge_TrySwitchOff-S3LBZTrigBridge_BridgeStateTable
                dc.w    S3LBZTrigBridge_RetractAndHide-S3LBZTrigBridge_BridgeStateTable
                dc.w    S3LBZTrigBridge_ExtendTowardOnWait-S3LBZTrigBridge_BridgeStateTable
; ---------------------------------------------------------------------------

; The outgoing bridge starts retracting even if the alternate bridge cannot allocate
S3LBZTrigBridge_TrySwitchOn:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d0.w)
                beq.s   S3LBZTrigBridge_SwitchOnReturn
                addq.b  #1,mapping_frame(a0)
                move.w  #7,$38(a0)
                addq.w  #2,$36(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3LBZTrigBridge_SwitchOnReturn
                move.l  #Obj_LBZTriggerBridge,(a1)
                move.w  $30(a0),x_pos(a1)
                move.w  $32(a0),y_pos(a1)
                move.b  subtype(a0),d0
                addi.b  #$40,d0
                andi.b  #$7F,d0
                move.b  d0,subtype(a1)
                move.w  #8,$38(a1)
                move.b  #1,$34(a1)

S3LBZTrigBridge_SwitchOnReturn:
                rts
; ---------------------------------------------------------------------------

S3LBZTrigBridge_RetractAndHide:
                addq.b  #1,mapping_frame(a0)
                subq.w  #1,$38(a0)
                bne.s   S3LBZTrigBridge_RetractReturn
                move.w  #$7FFF,x_pos(a0)

S3LBZTrigBridge_RetractReturn:
                rts
; ---------------------------------------------------------------------------

S3LBZTrigBridge_ExtendTowardOffWait:
                subq.b  #1,mapping_frame(a0)
                subq.w  #1,$38(a0)
                bne.s   S3LBZTrigBridge_ExtendToOffReturn
                addq.w  #2,$36(a0)

S3LBZTrigBridge_ExtendToOffReturn:
                rts
; ---------------------------------------------------------------------------

S3LBZTrigBridge_ExtendTowardOnWait:
                subq.b  #1,mapping_frame(a0)
                subq.w  #1,$38(a0)
                bne.s   S3LBZTrigBridge_ExtendToOnReturn
                move.w  #0,$36(a0)

S3LBZTrigBridge_ExtendToOnReturn:
                rts
; ---------------------------------------------------------------------------

S3LBZTrigBridge_TrySwitchOff:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d0.w)
                bne.s   S3LBZTrigBridge_SwitchOffReturn
                addq.b  #1,mapping_frame(a0)
                move.w  #7,$38(a0)
                addq.w  #2,$36(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3LBZTrigBridge_SwitchOffReturn
                move.l  #Obj_LBZTriggerBridge,(a1)
                move.w  $30(a0),x_pos(a1)
                move.w  $32(a0),y_pos(a1)
                move.b  subtype(a0),d0
                addi.b  #$40,d0
                andi.b  #$7F,d0
                move.b  d0,subtype(a1)
                move.w  #8,$38(a1)
                move.b  #1,$34(a1)

S3LBZTrigBridge_SwitchOffReturn:
                rts
; ---------------------------------------------------------------------------
Map_LBZTriggerBridge:
                include "src/objects/shared/zones/lbz/mappings/trigger_bridge.s"
