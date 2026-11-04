; Owner: objects/shared/sk
; Responsibility: Shared door movement, trigger control, collision and zone mapping variants
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
SKDoor_VerticalSubtypeAttributes:
                dc.b    $10, $20
                dc.w    make_art_tile(ArtTile_HCZMisc+$A,2,0)
                dc.b    8, $20
                dc.w    make_art_tile(ArtTile_CNZMisc+$C5,2,0)
                dc.b    $10, $20
                dc.w    make_art_tile(ArtTile_DEZMisc+$1E,1,0)
; ---------------------------------------------------------------------------

Obj_Door:
                moveq   #0,d0
                move.b  subtype(a0),d0
                bmi.w   SKDoor_InitializeHorizontalDoorAndWindow
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                add.w   d0,d0
                lea     SKDoor_VerticalSubtypeAttributes(pc,d0.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.w  (a1)+,art_tile(a0)
                move.l  #Map_HCZCNZDEZDoor,mappings(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$300,priority(a0)
                move.w  y_pos(a0),$32(a0)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                subi.w  #$200,d2
                addi.w  #$18,d3
                btst    #0,status(a0)
                beq.s   SKDoor_InitVerticalApproach
                subi.w  #-$1E8,d2
                addi.w  #$1E8,d3

SKDoor_InitVerticalApproach:
                move.w  d2,$34(a0)
                move.w  d3,$36(a0)
                move.l  #SKDoor_CheckVerticalNearSide,(a0)

SKDoor_CheckVerticalNearSide:
                btst    #0,status(a0)
                bne.s   SKDoor_CheckVerticalFlippedSide
                move.w  $34(a0),d2
                move.w  x_pos(a0),d3
                tst.b   $38(a0)
                beq.s   SKDoor_CheckVerticalRequestsAndStep
                move.w  $36(a0),d3
                bra.s   SKDoor_CheckVerticalRequestsAndStep
; ---------------------------------------------------------------------------

SKDoor_CheckVerticalFlippedSide:
                move.w  x_pos(a0),d2
                move.w  $36(a0),d3
                tst.b   $38(a0)
                beq.s   SKDoor_CheckVerticalRequestsAndStep
                move.w  $34(a0),d2

SKDoor_CheckVerticalRequestsAndStep:
                move.w  $32(a0),d4
                move.w  d4,d5
                subi.w  #$20,d4
                addi.w  #$20,d5
                move.b  #0,$38(a0)
                lea     (Player_1).w,a1
                bsr.w   RequestVerticalDoorOpenForPlayer
                lea     (Player_2).w,a1
                bsr.s   RequestVerticalDoorOpenForPlayer
                tst.b   $38(a0)
                beq.s   SKDoor_CloseVerticalDoorAndSoundAtZero
                cmpi.w  #$40,$30(a0)
                beq.s   SKDoor_CollideAndDrawVertical
                addq.w  #8,$30(a0)
                cmpi.w  #$40,$30(a0)
                bne.s   SKDoor_ApplyVerticalDoorDisplacement
                moveq   #signextendB(sfx_FanLatch),d0
                cmpi.b  #$B,(Current_zone).w            ; are we on DEZ?
                bne.s   SKDoor_PlayVerticalOpenEndpointSound  ; if not, branch
                moveq   #signextendB(sfx_FanLatch),d0   ; this check and sfx selection is not really necessary?

SKDoor_PlayVerticalOpenEndpointSound:
                jsr     (Play_SFX).l
                bra.s   SKDoor_ApplyVerticalDoorDisplacement
; ---------------------------------------------------------------------------

SKDoor_CloseVerticalDoorAndSoundAtZero:
                tst.w   $30(a0)
                beq.s   SKDoor_CollideAndDrawVertical
                subq.w  #8,$30(a0)
                bne.s   SKDoor_ApplyVerticalDoorDisplacement
                moveq   #signextendB(sfx_FanLatch),d0
                cmpi.b  #$B,(Current_zone).w            ; are we on DEZ?
                bne.s   SKDoor_PlayVerticalCloseEndpointSound  ; if not, branch
                moveq   #signextendB(sfx_FanLatch),d0   ; this check and sfx selection is not really necessary?

SKDoor_PlayVerticalCloseEndpointSound:
                jsr     (Play_SFX).l

SKDoor_ApplyVerticalDoorDisplacement:
                move.w  $32(a0),d0
                sub.w   $30(a0),d0
                move.w  d0,y_pos(a0)

SKDoor_CollideAndDrawVertical:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

RequestVerticalDoorOpenForPlayer:
                move.w  x_pos(a1),d0
                cmp.w   d2,d0
                blt.w   SKDoor_ReturnFromVerticalPlayerRequest
                cmp.w   d3,d0
                bhs.w   SKDoor_ReturnFromVerticalPlayerRequest
                move.w  y_pos(a1),d0
                cmp.w   d4,d0
                blo.w   SKDoor_ReturnFromVerticalPlayerRequest
                cmp.w   d5,d0
                bhs.w   SKDoor_ReturnFromVerticalPlayerRequest
                tst.b   object_control(a1)
                bmi.s   SKDoor_ReturnFromVerticalPlayerRequest
                move.b  #1,$38(a0)

SKDoor_ReturnFromVerticalPlayerRequest:
                rts
; End of function RequestVerticalDoorOpenForPlayer

; ---------------------------------------------------------------------------
Map_HCZCNZDEZDoor:
                include "src/objects/shared/zones/hcz/mappings/cnz_dez_door.s"
; ---------------------------------------------------------------------------
SKDoor_HorizontalSubtypeAttributes:
                dc.b    $20,   8
                dc.w    make_art_tile(ArtTile_CNZMisc+$C5,2,0)
; ---------------------------------------------------------------------------

SKDoor_InitializeHorizontalDoorAndWindow:
                andi.w  #$7F,d0
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                add.w   d0,d0
                lea     SKDoor_HorizontalSubtypeAttributes(pc,d0.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.w  (a1)+,art_tile(a0)
                move.l  #Map_CNZDoorHorizontal,mappings(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.w  x_pos(a0),$32(a0)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                subi.w  #$100,d2
                addi.w  #$18,d3
                btst    #1,status(a0)
                beq.s   SKDoor_InitHorizontalApproach
                subi.w  #-$E8,d2
                addi.w  #$E8,d3

SKDoor_InitHorizontalApproach:
                move.w  d2,$34(a0)
                move.w  d3,$36(a0)
                move.l  #SKDoor_CheckHorizontalNearSide,(a0)

SKDoor_CheckHorizontalNearSide:
                btst    #1,status(a0)
                bne.s   SKDoor_CheckHorizontalFlippedSide
                move.w  $34(a0),d2
                move.w  y_pos(a0),d3
                tst.b   $38(a0)
                beq.s   SKDoor_CheckHorizontalRequestsAndStep
                move.w  $36(a0),d3
                bra.s   SKDoor_CheckHorizontalRequestsAndStep
; ---------------------------------------------------------------------------

SKDoor_CheckHorizontalFlippedSide:
                move.w  y_pos(a0),d2
                move.w  $36(a0),d3
                tst.b   $38(a0)
                beq.s   SKDoor_CheckHorizontalRequestsAndStep
                move.w  $34(a0),d2

SKDoor_CheckHorizontalRequestsAndStep:
                move.w  $32(a0),d4
                move.w  d4,d5
                subi.w  #$20,d4
                addi.w  #$20,d5
                move.b  #0,$38(a0)
                lea     (Player_1).w,a1
                bsr.s   RequestHorizontalDoorOpenForPlayer
                lea     (Player_2).w,a1
                bsr.s   RequestHorizontalDoorOpenForPlayer
                tst.b   $38(a0)
                beq.s   SKDoor_CloseHorizontalDoorOffset
                cmpi.w  #$40,$30(a0)
                beq.s   SKDoor_CollideAndDrawHorizontal
                addq.w  #8,$30(a0)
                bra.s   SKDoor_ChooseHorizontalTravelSign
; ---------------------------------------------------------------------------

SKDoor_CloseHorizontalDoorOffset:
                tst.w   $30(a0)
                beq.s   SKDoor_CollideAndDrawHorizontal
                subq.w  #8,$30(a0)

SKDoor_ChooseHorizontalTravelSign:
                move.w  $30(a0),d0
                btst    #0,status(a0)
                beq.s   SKDoor_ApplySignedHorizontalDoorOffset
                neg.w   d0

SKDoor_ApplySignedHorizontalDoorOffset:
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)

SKDoor_CollideAndDrawHorizontal:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

RequestHorizontalDoorOpenForPlayer:
                move.w  y_pos(a1),d0
                cmp.w   d2,d0
                blt.w   SKDoor_ReturnFromHorizontalPlayerRequest
                cmp.w   d3,d0
                bhs.w   SKDoor_ReturnFromHorizontalPlayerRequest
                move.w  x_pos(a1),d0
                cmp.w   d4,d0
                blo.w   SKDoor_ReturnFromHorizontalPlayerRequest
                cmp.w   d5,d0
                bhs.w   SKDoor_ReturnFromHorizontalPlayerRequest
                tst.b   object_control(a1)
                bmi.s   SKDoor_ReturnFromHorizontalPlayerRequest
                move.b  #1,$38(a0)

SKDoor_ReturnFromHorizontalPlayerRequest:
                rts
; End of function RequestHorizontalDoorOpenForPlayer

; ---------------------------------------------------------------------------
Map_CNZDoorHorizontal:
                include "src/objects/shared/zones/cnz/mappings/door_horizontal.s"
