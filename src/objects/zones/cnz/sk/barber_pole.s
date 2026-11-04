; Owner: objects/zones/cnz/sk
; Responsibility: Carnival Night barber-pole sprite motion, player rotation and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZBarberPoleSprite:
                tst.b   subtype(a0)
                beq.s   SKCNZPole_StartDownSlope
                move.l  #SKCNZPole_UpdateUpSlopeRiders,(a0)
                bra.w   SKCNZPole_UpdateUpSlopeRiders
; ---------------------------------------------------------------------------

SKCNZPole_StartDownSlope:
                move.l  #SKCNZPole_UpdateDownSlopeRiders,(a0)

SKCNZPole_UpdateDownSlopeRiders:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   UpdatePlayerOnCnzFallingBarberPole
                addq.w  #6,a2
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                bsr.s   UpdatePlayerOnCnzFallingBarberPole
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnCnzFallingBarberPole:
                btst    d6,status(a0)
                bne.w   SKCNZPole_CheckDownSlopeSupport
                btst    #Status_OnObj,status(a1)
                bne.w   SKCNZPole_CheckDownSlopeTransfer
                moveq   #0,d0
                move.b  x_radius(a1),d0
                neg.w   d0
                add.w   x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                cmpi.w  #$A0,d0
                bhs.s   SKCNZPole_DownEntryReturn
                subi.w  #$61,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                add.w   y_pos(a1),d1
                sub.w   y_pos(a0),d1
                sub.w   d0,d1
                cmpi.w  #$10,d1
                bhs.s   SKCNZPole_DownEntryReturn
                tst.b   object_control(a1)
                bne.s   SKCNZPole_DownEntryReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKCNZPole_DownEntryReturn
                btst    #Status_InAir,status(a1)
                beq.s   SKCNZPole_CaptureOnDownSlope
                tst.w   y_vel(a1)
                bmi.s   SKCNZPole_DownEntryReturn

SKCNZPole_CaptureOnDownSlope:
                move.l  x_pos(a1),(a2)
                move.w  (a2),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                move.w  d0,(a2)
                move.w  #0,4(a2)
                subi.w  #$18,d0
                cmpi.w  #$70,d0
                bhs.s   SKCNZPole_AttachDownSlopeEntrant
                move.w  #1,4(a2)

SKCNZPole_AttachDownSlopeEntrant:
                bsr.w   AttachPlayerToCnzBarberPole
                move.b  #$20,angle(a1)
                move.b  #2,flip_type(a1)

SKCNZPole_DownEntryReturn:
                rts
; ---------------------------------------------------------------------------

SKCNZPole_CheckDownSlopeTransfer:
                moveq   #0,d0
                move.b  x_radius(a1),d0
                neg.w   d0
                add.w   x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$30,d0
                cmpi.w  #$80,d0
                bhs.s   SKCNZPole_DownTransferReturn
                subi.w  #$51,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                add.w   y_pos(a1),d1
                sub.w   y_pos(a0),d1
                sub.w   d0,d1
                cmpi.w  #$10,d1
                bhs.s   SKCNZPole_DownTransferReturn
                tst.b   object_control(a1)
                bne.s   SKCNZPole_DownTransferReturn
                btst    #Status_InAir,status(a1)
                beq.s   SKCNZPole_TryRecaptureDownSlope
                tst.w   y_vel(a1)
                bmi.s   SKCNZPole_DownTransferReturn

SKCNZPole_TryRecaptureDownSlope:
                movea.w interact(a1),a3
                cmpi.l  #SKCNZPole_UpdateDownSlopeRiders,(a3)
                bne.s   SKCNZPole_DownTransferReturn
                move.l  x_pos(a1),(a2)
                move.w  (a2),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                move.w  d0,(a2)
                move.w  #0,4(a2)
                subi.w  #$20,d0
                cmpi.w  #$60,d0
                bhs.s   SKCNZPole_AttachDownSlopeTransfer
                move.w  #1,4(a2)

SKCNZPole_AttachDownSlopeTransfer:
                bsr.w   AttachPlayerToCnzBarberPole
                move.b  #$20,angle(a1)
                move.b  #2,flip_type(a1)

SKCNZPole_DownTransferReturn:
                rts
; ---------------------------------------------------------------------------

SKCNZPole_CheckDownSlopeSupport:
                tst.w   4(a2)
                bne.s   SKCNZPole_AdvanceDownSlopeRider
                move.w  ground_vel(a1),d0
                bpl.s   SKCNZPole_CheckDownEdgeSpeed
                neg.w   d0

SKCNZPole_CheckDownEdgeSpeed:
                cmpi.w  #$118,d0
                bhs.s   SKCNZPole_AdvanceDownSlopeRider
                bset    #Status_InAir,status(a1)
                bra.s   SKCNZPole_ReleaseDownSlopeRider
; ---------------------------------------------------------------------------

SKCNZPole_AdvanceDownSlopeRider:
                btst    #Status_InAir,status(a1)
                bne.s   SKCNZPole_ReleaseDownSlopeRider
                move.w  x_vel(a1),d0
                ext.l   d0
                lsl.l   #6,d0
                move.l  d0,d1
                add.l   d0,d0
                add.l   d1,d0
                add.l   d0,(a2)
                moveq   #0,d0
                move.b  x_radius(a1),d0
                neg.w   d0
                add.w   (a2),d0
                cmpi.w  #$A0,d0
                blo.s   SKCNZPole_BeginDownProjection

SKCNZPole_ReleaseDownSlopeRider:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                andi.w  #drawing_mask,art_tile(a1)
                rts
; ---------------------------------------------------------------------------

SKCNZPole_BeginDownProjection:
                btst    #Status_OnObj,status(a1)
                beq.w   SKCNZPole_DownProjectionReturn
                move.w  d0,d2
                subi.b  #$10,d0
                bcc.s   SKCNZPole_ClampDownRotation
                move.w  #0,4(a2)
                moveq   #0,d0

SKCNZPole_ClampDownRotation:
                cmpi.b  #$80,d0
                blo.s   SKCNZPole_SetDownSlopePriority
                move.w  #0,4(a2)
                move.w  #$80,d0

SKCNZPole_SetDownSlopePriority:
                andi.w  #drawing_mask,art_tile(a1)
                cmpi.b  #$34,d0
                bhs.s   SKCNZPole_ZeroDownInteriorRotation
                ori.w   #high_priority,art_tile(a1)

SKCNZPole_ZeroDownInteriorRotation:
                tst.w   4(a2)
                beq.s   SKCNZPole_ProjectDownSlopeRider
                moveq   #0,d0

SKCNZPole_ProjectDownSlopeRider:
                add.w   d0,d0
                move.b  d0,flip_angle(a1)
                jsr     (GetSineCosine).l
                move.w  d1,d4
                asr.w   #4,d1
                move.w  d1,d3
                add.w   d2,d1
                add.w   x_pos(a0),d1
                subi.w  #$50,d1
                moveq   #0,d0
                move.b  x_radius(a1),d0
                muls.w  d4,d0
                asr.w   #8,d0
                add.w   d0,d1
                move.w  d1,x_pos(a1)
                move.w  d2,d0
                subi.w  #$51,d0
                move.w  y_pos(a0),d2
                sub.w   d3,d2
                add.w   d0,d2
                moveq   #0,d1
                move.b  y_radius(a1),d1
                muls.w  d4,d1
                asr.w   #8,d1
                sub.w   d1,d2
                move.w  d2,y_pos(a1)

SKCNZPole_DownProjectionReturn:
                rts
; End of function UpdatePlayerOnCnzFallingBarberPole

; ---------------------------------------------------------------------------

SKCNZPole_UpdateUpSlopeRiders:
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   UpdatePlayerOnCnzRisingBarberPole
                addq.w  #6,a2
                lea     (Player_2).w,a1
                addq.b  #p2_standing_bit-p1_standing_bit,d6
                bsr.s   UpdatePlayerOnCnzRisingBarberPole
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnCnzRisingBarberPole:
                btst    d6,status(a0)
                bne.w   SKCNZPole_CheckUpSlopeSupport
                btst    #Status_OnObj,status(a1)
                bne.w   SKCNZPole_CheckUpSlopeTransfer
                moveq   #0,d0
                move.b  x_radius(a1),d0
                add.w   x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$60,d0
                cmpi.w  #$A0,d0
                bhs.s   SKCNZPole_UpEntryReturn
                subi.w  #$3E,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                add.w   y_pos(a1),d1
                sub.w   y_pos(a0),d1
                add.w   d0,d1
                cmpi.w  #$10,d1
                bhs.s   SKCNZPole_UpEntryReturn
                tst.b   object_control(a1)
                bne.s   SKCNZPole_UpEntryReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKCNZPole_UpEntryReturn
                btst    #Status_InAir,status(a1)
                beq.s   SKCNZPole_CaptureOnUpSlope
                tst.w   y_vel(a1)
                bmi.s   SKCNZPole_UpEntryReturn

SKCNZPole_CaptureOnUpSlope:
                move.l  x_pos(a1),(a2)
                move.w  (a2),d0
                sub.w   x_pos(a0),d0
                addi.w  #$60,d0
                move.w  d0,(a2)
                move.w  #0,4(a2)
                subi.w  #$18,d0
                cmpi.w  #$70,d0
                bhs.s   SKCNZPole_AttachUpSlopeEntrant
                move.w  #1,4(a2)

SKCNZPole_AttachUpSlopeEntrant:
                bsr.w   AttachPlayerToCnzBarberPole
                move.b  #$E0,angle(a1)
                move.b  #3,flip_type(a1)

SKCNZPole_UpEntryReturn:
                rts
; ---------------------------------------------------------------------------

SKCNZPole_CheckUpSlopeTransfer:
                moveq   #0,d0
                move.b  x_radius(a1),d0
                add.w   x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$50,d0
                cmpi.w  #$80,d0
                bhs.s   SKCNZPole_UpTransferReturn
                subi.w  #$2E,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                add.w   y_pos(a1),d1
                sub.w   y_pos(a0),d1
                add.w   d0,d1
                cmpi.w  #$10,d1
                bhs.s   SKCNZPole_UpTransferReturn
                tst.b   object_control(a1)
                bne.s   SKCNZPole_UpTransferReturn
                btst    #Status_InAir,status(a1)
                beq.s   SKCNZPole_TryRecaptureUpSlope
                tst.w   y_vel(a1)
                bmi.s   SKCNZPole_UpTransferReturn

SKCNZPole_TryRecaptureUpSlope:
                movea.w interact(a1),a3
                cmpi.l  #SKCNZPole_UpdateUpSlopeRiders,(a3)
                bne.s   SKCNZPole_UpTransferReturn
                move.l  x_pos(a1),(a2)
                move.w  (a2),d0
                sub.w   x_pos(a0),d0
                addi.w  #$60,d0
                move.w  d0,(a2)
                move.w  #0,4(a2)
                subi.w  #$20,d0
                cmpi.w  #$60,d0
                bhs.s   SKCNZPole_AttachUpSlopeTransfer
                move.w  #1,4(a2)

SKCNZPole_AttachUpSlopeTransfer:
                bsr.w   AttachPlayerToCnzBarberPole
                move.b  #$E0,angle(a1)
                move.b  #3,flip_type(a1)

SKCNZPole_UpTransferReturn:
                rts
; ---------------------------------------------------------------------------

SKCNZPole_CheckUpSlopeSupport:
                tst.w   4(a2)
                bne.s   SKCNZPole_AdvanceUpSlopeRider
                move.w  ground_vel(a1),d0
                bpl.s   SKCNZPole_CheckUpEdgeSpeed
                neg.w   d0

SKCNZPole_CheckUpEdgeSpeed:
                cmpi.w  #$118,d0
                bhs.s   SKCNZPole_AdvanceUpSlopeRider
                bset    #Status_InAir,status(a1)
                bra.s   SKCNZPole_ReleaseUpSlopeRider
; ---------------------------------------------------------------------------

SKCNZPole_AdvanceUpSlopeRider:
                btst    #Status_InAir,status(a1)
                bne.s   SKCNZPole_ReleaseUpSlopeRider
                move.w  x_vel(a1),d0
                ext.l   d0
                lsl.l   #6,d0
                move.l  d0,d1
                add.l   d0,d0
                add.l   d1,d0
                add.l   d0,(a2)
                moveq   #0,d0
                move.b  x_radius(a1),d0
                add.w   (a2),d0
                cmpi.w  #$A0,d0
                blo.s   SKCNZPole_BeginUpProjection

SKCNZPole_ReleaseUpSlopeRider:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,flips_remaining(a1)
                move.b  #4,flip_speed(a1)
                andi.w  #drawing_mask,art_tile(a1)
                rts
; ---------------------------------------------------------------------------

SKCNZPole_BeginUpProjection:
                btst    #Status_OnObj,status(a1)
                beq.w   SKCNZPole_UpProjectionReturn
                move.w  d0,d2
                subi.b  #$10,d0
                bcc.s   SKCNZPole_ClampUpRotation
                move.w  #0,4(a2)
                moveq   #0,d0

SKCNZPole_ClampUpRotation:
                cmpi.b  #$80,d0
                blo.s   SKCNZPole_SetUpSlopePriority
                move.w  #0,4(a2)
                move.w  #$80,d0

SKCNZPole_SetUpSlopePriority:
                andi.w  #drawing_mask,art_tile(a1)
                cmpi.b  #$4C,d0
                blo.s   SKCNZPole_ZeroUpInteriorRotation
                ori.w   #high_priority,art_tile(a1)

SKCNZPole_ZeroUpInteriorRotation:
                tst.w   4(a2)
                beq.s   SKCNZPole_ProjectUpSlopeRider
                moveq   #0,d0

SKCNZPole_ProjectUpSlopeRider:
                neg.b   d0
                add.w   d0,d0
                move.b  d0,flip_angle(a1)
                jsr     (GetSineCosine).l
                move.w  d1,d4
                asr.w   #4,d1
                move.w  d1,d3
                neg.w   d1
                add.w   d2,d1
                add.w   x_pos(a0),d1
                subi.w  #$50,d1
                moveq   #0,d0
                move.b  x_radius(a1),d0
                muls.w  d4,d0
                asr.w   #8,d0
                sub.w   d0,d1
                move.w  d1,x_pos(a1)
                move.w  d2,d0
                subi.w  #$4E,d0
                move.w  y_pos(a0),d2
                sub.w   d3,d2
                sub.w   d0,d2
                moveq   #0,d1
                move.b  y_radius(a1),d1
                muls.w  d4,d1
                asr.w   #8,d1
                sub.w   d1,d2
                move.w  d2,y_pos(a1)

SKCNZPole_UpProjectionReturn:
                rts
; End of function UpdatePlayerOnCnzRisingBarberPole

; =============== S U B R O U T I N E =======================================

AttachPlayerToCnzBarberPole:
                btst    #Status_OnObj,status(a1)
                beq.s   SKCNZPole_SetInteractionAndLand
                movea.w interact(a1),a3
                bclr    d6,status(a3)

SKCNZPole_SetInteractionAndLand:
                move.w  a0,interact(a1)
                btst    #Status_InAir,status(a1)
                beq.s   SKCNZPole_SetStandingFlags
                move.w  #0,y_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                move.l  a0,-(sp)
                movea.l a1,a0
                move.w  a0,d1
                subi.w  #Player_1,d1
                bne.s   SKCNZPole_LandTailsEntrant
                cmpi.w  #2,(Player_mode).w
                beq.s   SKCNZPole_LandTailsEntrant
                jsr     (Player_TouchFloor).l
                bra.s   SKCNZPole_RestorePolePointer
; ---------------------------------------------------------------------------

SKCNZPole_LandTailsEntrant:
                jsr     (Tails_TouchFloor).l

SKCNZPole_RestorePolePointer:
                movea.l (sp)+,a0

SKCNZPole_SetStandingFlags:
                bset    #Status_OnObj,status(a1)
                bclr    #Status_InAir,status(a1)
                bset    d6,status(a0)
                rts
; End of function AttachPlayerToCnzBarberPole
