; Owner: objects/zones/lbz/sk
; Responsibility: Unused Launch Base tilting bridge initialization, linked platform states and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZUnusedTiltingBridge:
                move.l  #Map_LBZUnusedTiltingBridge,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZMisc,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$40,height_pixels(a0)
                move.w  #$200,priority(a0)
                move.b  #$80,$42(a0)
                move.b  #1,mapping_frame(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKLBZUnusedTilt_InitDebugTilt
                move.l  #SKLBZUnusedTilt_CopyTiltAndPlacePieces,(a1)
                move.l  #Map_LBZUnusedTiltingBridge,mappings(a1)
                move.w  #make_art_tile(ArtTile_LBZMisc,2,0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.b  #$40,width_pixels(a1)
                move.b  #$40,height_pixels(a1)
                move.w  #$200,priority(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  #$80,$42(a1)
                bset    #6,render_flags(a1)
                move.w  #6,mainspr_childsprites(a1)
                move.w  a0,$3C(a1)

SKLBZUnusedTilt_InitDebugTilt:
                move.b  #$10,$42(a0)
                move.l  #SKLBZUnusedTilt_TryResetTilt,(a0)

SKLBZUnusedTilt_TryResetTilt:
                btst    #button_B,(Ctrl_2_held).w
                beq.s   SKLBZUnusedTilt_TryIncreaseTilt
                move.b  #0,$42(a0)

SKLBZUnusedTilt_TryIncreaseTilt:
                btst    #button_C,(Ctrl_2_held).w
                beq.s   SKLBZUnusedTilt_TryDecreaseTilt
                addi.b  #1,$42(a0)

SKLBZUnusedTilt_TryDecreaseTilt:
                btst    #button_A,(Ctrl_2_held).w
                beq.s   SKLBZUnusedTilt_UpdateRidersAndDraw
                subi.b  #1,$42(a0)

SKLBZUnusedTilt_UpdateRidersAndDraw:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #8,d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   CollidePlayersWithLbzUnusedTiltingBridge
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKLBZUnusedTilt_CopyTiltAndPlacePieces:
                movea.w $3C(a0),a1
                move.b  $42(a1),$42(a0)
                bsr.w   PositionLbzUnusedTiltingBridgePieces
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

PositionLbzUnusedTiltingBridgePieces:
                move.b  $42(a0),d0
                jsr     (GetSineCosine).l
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                swap    d0
                swap    d1
                asr.l   #5,d0
                asr.l   #5,d1
                move.l  d0,d4
                move.l  d1,d5
                add.l   d0,d0
                add.l   d1,d1
                movem.l d0-d5,-(sp)
                add.l   d0,d4
                add.l   d1,d5
                lea     sub2_x_pos(a0),a2
                moveq   #3-1,d6

SKLBZUnusedTilt_PlacePositivePieces:
                movem.l d4-d5,-(sp)
                swap    d4
                swap    d5
                add.w   d2,d4
                add.w   d3,d5
                move.w  d5,(a2)+
                move.w  d4,(a2)+
                movem.l (sp)+,d4-d5
                add.l   d0,d4
                add.l   d1,d5
                addq.w  #2,a2
                dbf     d6,SKLBZUnusedTilt_PlacePositivePieces
                movem.l (sp)+,d0-d5
                neg.l   d4
                neg.l   d5
                sub.l   d0,d4
                sub.l   d1,d5
                moveq   #3-1,d6

SKLBZUnusedTilt_PlaceNegativePieces:
                movem.l d4-d5,-(sp)
                swap    d4
                swap    d5
                add.w   d2,d4
                add.w   d3,d5
                move.w  d5,(a2)+
                move.w  d4,(a2)+
                movem.l (sp)+,d4-d5
                sub.l   d0,d4
                sub.l   d1,d5
                addq.w  #2,a2
                dbf     d6,SKLBZUnusedTilt_PlaceNegativePieces
                rts
; End of function PositionLbzUnusedTiltingBridgePieces

; =============== S U B R O U T I N E =======================================

CollidePlayersWithLbzUnusedTiltingBridge:
; Bug: probably meant to be $30(a0)
                lea     (Vectors+$30).w,a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d3,-(sp)
                bsr.s   CollidePlayerWithLbzUnusedTiltingBridge
                movem.l (sp)+,d1-d3
; Bug: probably meant to be $34(a0)
                lea     (Vectors+$34).w,a2
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
; End of function CollidePlayersWithLbzUnusedTiltingBridge

; =============== S U B R O U T I N E =======================================

CollidePlayerWithLbzUnusedTiltingBridge:
                btst    d6,status(a0)
                beq.w   SKLBZUnusedTilt_TryCaptureDescending
                move.w  ground_vel(a1),d0
                move.b  $42(a0),d4
                addi.b  #$40,d4
                bpl.s   SKLBZUnusedTilt_UpdateAndCheckRider
                neg.w   d0

SKLBZUnusedTilt_UpdateAndCheckRider:
                add.w   d0,(a2)
                btst    #Status_InAir,status(a1)
                bne.s   SKLBZUnusedTilt_DetachRider
                move.b  $42(a0),d0
                jsr     (GetSineCosine).l
                tst.w   d1
                bmi.s   SKLBZUnusedTilt_CheckProjectedWidth
                neg.w   d1

SKLBZUnusedTilt_CheckProjectedWidth:
                asr.w   #2,d1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                cmp.w   d1,d0
                blt.s   SKLBZUnusedTilt_DetachRider
                neg.w   d1
                cmp.w   d1,d0
                blt.s   SKLBZUnusedTilt_PlaceAttachedRider

SKLBZUnusedTilt_DetachRider:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                bclr    d6,status(a0)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKLBZUnusedTilt_PlaceAttachedRider:
                bsr.w   ProjectPlayerOnLbzUnusedTiltingBridge
                moveq   #0,d4
                rts
; End of function CollidePlayerWithLbzUnusedTiltingBridge

; =============== S U B R O U T I N E =======================================

ProjectPlayerOnLbzUnusedTiltingBridge:
                move.w  d3,d5
                move.b  $42(a0),d0
                jsr     (GetSineCosine).l
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                move.w  (a2),d4
                muls.w  d4,d0
                muls.w  d4,d1
                swap    d0
                swap    d1
                add.w   d0,d2
                add.w   d1,d3
                move.b  $42(a0),d0
                move.b  d0,d1
                addi.b  #$40,d1
                bpl.s   SKLBZUnusedTilt_SetAngleAndRadiusOffset
                addi.b  #$80,d0

SKLBZUnusedTilt_SetAngleAndRadiusOffset:
                move.b  d0,angle(a1)
                moveq   #0,d1
                move.b  y_radius(a1),d1
                add.w   d1,d5
                lsl.w   #8,d5
                jsr     (GetSineCosine).l
                muls.w  d5,d0
                muls.w  d5,d1
                swap    d0
                swap    d1
                add.w   d0,d3
                sub.w   d1,d2
                move.w  d2,y_pos(a1)
                move.w  d3,x_pos(a1)
                rts
; End of function ProjectPlayerOnLbzUnusedTiltingBridge

; ---------------------------------------------------------------------------

SKLBZUnusedTilt_TryCaptureDescending:
                tst.w   y_vel(a1)
                bmi.w   SKLBZUnusedTilt_LandingReturn
                move.b  $42(a0),d0
                jsr     (GetSineCosine).l
                move.w  d0,d4
                move.w  d1,d2
                tst.w   d1
                bmi.s   SKLBZUnusedTilt_CalcTravelAndTestLand
                neg.w   d1

SKLBZUnusedTilt_CalcTravelAndTestLand:
                asr.w   #2,d1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                cmp.w   d1,d0
                blt.s   SKLBZUnusedTilt_LandingReturn
                neg.w   d1
                cmp.w   d1,d0
                bge.s   SKLBZUnusedTilt_LandingReturn
                swap    d0
                divs.w  d2,d0
                move.w  d0,(a2)
                neg.w   d4
                muls.w  d4,d0
                swap    d0
                move.w  d3,d5
                add.w   d0,d3
                move.w  y_pos(a0),d0
                sub.w   d3,d0
                move.w  y_pos(a1),d2
                move.b  y_radius(a1),d1
                ext.w   d1
                add.w   d2,d1
                addq.w  #4,d1
                sub.w   d1,d0
                bhi.s   SKLBZUnusedTilt_LandingReturn
                cmpi.w  #-$10,d0
                blo.s   SKLBZUnusedTilt_LandingReturn
                tst.b   object_control(a1)
                bmi.s   SKLBZUnusedTilt_LandingReturn
                cmpi.b  #6,routine(a1)
                bhs.s   SKLBZUnusedTilt_LandingReturn
                move.b  $42(a0),d0
                move.b  d0,d1
                addi.b  #$40,d1
                bpl.s   SKLBZUnusedTilt_CorrectTravelAndAttach
                addi.b  #$80,d0

SKLBZUnusedTilt_CorrectTravelAndAttach:
                jsr     (GetSineCosine).l
                muls.w  #$1B00,d0
                swap    d0
                sub.w   d0,(a2)
                move.w  d5,d3
                bsr.w   ProjectPlayerOnLbzUnusedTiltingBridge
                jmp     (RideObject_SetRide).l
; ---------------------------------------------------------------------------

SKLBZUnusedTilt_LandingReturn:
                rts
