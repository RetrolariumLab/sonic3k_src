; Owner: objects/shared/s3
; Responsibility: Shared door movement, trigger control, collision and zone mapping variants
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
S3Door_VerticalSubtypeAttributes:
                dc.b    $10, $20
                dc.w    make_art_tile(ArtTile_HCZMisc+$A,2,0)
                dc.b    8, $20
                dc.w    make_art_tile(ArtTile_CNZMisc+$C5,2,0)
; ---------------------------------------------------------------------------

Obj_Door:
                moveq   #0,d0
                move.b  subtype(a0),d0
                bmi.w   S3Door_InitializeHorizontalDoorAndWindow
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                add.w   d0,d0
                lea     S3Door_VerticalSubtypeAttributes(pc,d0.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.w  (a1)+,art_tile(a0)
                move.l  #Map_HCZCNZDoor,mappings(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$300,priority(a0)
                move.w  y_pos(a0),$32(a0)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                subi.w  #$200,d2
                addi.w  #$18,d3
                btst    #0,status(a0)
                beq.s   S3Door_InitVerticalApproach
                subi.w  #-$1E8,d2
                addi.w  #$1E8,d3

S3Door_InitVerticalApproach:
                move.w  d2,$34(a0)
                move.w  d3,$36(a0)
                move.l  #S3Door_CheckVerticalNearSide,(a0)

S3Door_CheckVerticalNearSide:
                btst    #0,status(a0)
                bne.s   S3Door_CheckVerticalFlippedSide
                move.w  $34(a0),d2
                move.w  x_pos(a0),d3
                tst.b   $38(a0)
                beq.s   S3Door_CheckVerticalRequestsAndStep
                move.w  $36(a0),d3
                bra.s   S3Door_CheckVerticalRequestsAndStep
; ---------------------------------------------------------------------------

S3Door_CheckVerticalFlippedSide:
                move.w  x_pos(a0),d2
                move.w  $36(a0),d3
                tst.b   $38(a0)
                beq.s   S3Door_CheckVerticalRequestsAndStep
                move.w  $34(a0),d2

S3Door_CheckVerticalRequestsAndStep:
                move.w  $32(a0),d4
                move.w  d4,d5
                subi.w  #$20,d4
                addi.w  #$20,d5
                move.b  #0,$38(a0)
                lea     (Player_1).w,a1
                bsr.s   RequestVerticalDoorOpenForPlayer
                lea     (Player_2).w,a1
                bsr.s   RequestVerticalDoorOpenForPlayer
                tst.b   $38(a0)
                beq.s   S3Door_CloseVerticalDoorAndSoundAtZero
                cmpi.w  #$40,$30(a0)
                beq.s   S3Door_CollideAndDrawVertical
                addq.w  #8,$30(a0)
                cmpi.w  #$40,$30(a0)
                bne.s   S3Door_ApplyVerticalDoorDisplacement
                moveq   #signextendB(sfx_FanLatch),d0
                jsr     (Play_SFX).l
                bra.s   S3Door_ApplyVerticalDoorDisplacement
; ---------------------------------------------------------------------------

S3Door_CloseVerticalDoorAndSoundAtZero:
                tst.w   $30(a0)
                beq.s   S3Door_CollideAndDrawVertical
                subq.w  #8,$30(a0)
                bne.s   S3Door_ApplyVerticalDoorDisplacement
                moveq   #signextendB(sfx_FanLatch),d0
                jsr     (Play_SFX).l

S3Door_ApplyVerticalDoorDisplacement:
                move.w  $32(a0),d0
                sub.w   $30(a0),d0
                move.w  d0,y_pos(a0)

S3Door_CollideAndDrawVertical:
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
                blt.w   S3Door_ReturnFromVerticalPlayerRequest
                cmp.w   d3,d0
                bhs.w   S3Door_ReturnFromVerticalPlayerRequest
                move.w  y_pos(a1),d0
                cmp.w   d4,d0
                blo.w   S3Door_ReturnFromVerticalPlayerRequest
                cmp.w   d5,d0
                bhs.w   S3Door_ReturnFromVerticalPlayerRequest
                tst.b   object_control(a1)
                bmi.s   S3Door_ReturnFromVerticalPlayerRequest
                move.b  #1,$38(a0)

S3Door_ReturnFromVerticalPlayerRequest:
                rts
; End of function RequestVerticalDoorOpenForPlayer

; ---------------------------------------------------------------------------
Map_HCZCNZDoor:
                include "src/objects/shared/zones/hcz/mappings/cnz_door_s3.s"
; ---------------------------------------------------------------------------
S3Door_HorizontalSubtypeAttributes:
                dc.b    $20,   8
                dc.w    make_art_tile(ArtTile_CNZMisc+$C5,2,0)
; ---------------------------------------------------------------------------

S3Door_InitializeHorizontalDoorAndWindow:
                andi.w  #$7F,d0
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                add.w   d0,d0
                lea     S3Door_HorizontalSubtypeAttributes(pc,d0.w),a1
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
                beq.s   S3Door_InitHorizontalApproach
                subi.w  #-$E8,d2
                addi.w  #$E8,d3

S3Door_InitHorizontalApproach:
                move.w  d2,$34(a0)
                move.w  d3,$36(a0)
                move.l  #S3Door_CheckHorizontalNearSide,(a0)

S3Door_CheckHorizontalNearSide:
                btst    #1,status(a0)
                bne.s   S3Door_CheckHorizontalFlippedSide
                move.w  $34(a0),d2
                move.w  y_pos(a0),d3
                tst.b   $38(a0)
                beq.s   S3Door_CheckHorizontalRequestsAndStep
                move.w  $36(a0),d3
                bra.s   S3Door_CheckHorizontalRequestsAndStep
; ---------------------------------------------------------------------------

S3Door_CheckHorizontalFlippedSide:
                move.w  y_pos(a0),d2
                move.w  $36(a0),d3
                tst.b   $38(a0)
                beq.s   S3Door_CheckHorizontalRequestsAndStep
                move.w  $34(a0),d2

S3Door_CheckHorizontalRequestsAndStep:
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
                beq.s   S3Door_CloseHorizontalDoorOffset
                cmpi.w  #$40,$30(a0)
                beq.s   S3Door_CollideAndDrawHorizontal
                addq.w  #8,$30(a0)
                bra.s   S3Door_ChooseHorizontalTravelSign
; ---------------------------------------------------------------------------

S3Door_CloseHorizontalDoorOffset:
                tst.w   $30(a0)
                beq.s   S3Door_CollideAndDrawHorizontal
                subq.w  #8,$30(a0)

S3Door_ChooseHorizontalTravelSign:
                move.w  $30(a0),d0
                btst    #0,status(a0)
                beq.s   S3Door_ApplySignedHorizontalDoorOffset
                neg.w   d0

S3Door_ApplySignedHorizontalDoorOffset:
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)

S3Door_CollideAndDrawHorizontal:
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
                blt.w   S3Door_ReturnFromHorizontalPlayerRequest
                cmp.w   d3,d0
                bhs.w   S3Door_ReturnFromHorizontalPlayerRequest
                move.w  x_pos(a1),d0
                cmp.w   d4,d0
                blo.w   S3Door_ReturnFromHorizontalPlayerRequest
                cmp.w   d5,d0
                bhs.w   S3Door_ReturnFromHorizontalPlayerRequest
                tst.b   object_control(a1)
                bmi.s   S3Door_ReturnFromHorizontalPlayerRequest
                move.b  #1,$38(a0)

S3Door_ReturnFromHorizontalPlayerRequest:
                rts
; End of function RequestHorizontalDoorOpenForPlayer

; ---------------------------------------------------------------------------
Map_CNZDoorHorizontal:
                include "src/objects/shared/zones/cnz/mappings/door_horizontal.s"
