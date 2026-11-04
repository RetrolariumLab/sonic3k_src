; Owner: objects/cutscenes/sk
; Responsibility: Shared Knuckles cutscene state selection, graphics patterns, angle helpers and child positioning
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SSZSmallDeathEgg_TryParticleEvery32:
                move.b  (V_int_run_count+3).w,d0
                andi.w  #$1F,d0
                bne.w   locret_6206C
                moveq   #signextendB(sfx_MissileShoot),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_665F0(pc),a2
                jmp     (CreateChild6_Simple).l
; End of function SSZSmallDeathEgg_TryParticleEvery32

; ---------------------------------------------------------------------------

loc_66072:
                move.w  (Camera_X_pos).w,$3A(a0)
                move.l  #loc_6607E,(a0)

loc_6607E:
                move.w  (Camera_X_pos).w,d0
                move.w  $3A(a0),d1
                move.w  d0,$3A(a0)
                sub.w   d1,d0
                asr.w   #1,d0
                move.w  d0,(_unkFA84).w
                rts

; =============== S U B R O U T I N E =======================================

HPZKnucklesFaceTargetFromSideWord:
                bset    #0,render_flags(a0)
                tst.w   d0
                beq.s   locret_660A4
                bclr    #0,render_flags(a0)

locret_660A4:
                rts
; End of function HPZKnucklesFaceTargetFromSideWord

; ---------------------------------------------------------------------------

loc_660A6:
                tst.b   $34(a1)
                bne.w   locret_6206C

loc_660AE:
                btst    #Status_InAir,status_secondary(a1)
                bne.w   locret_6206C
                jmp     (HurtCharacter_Directly).l
; ---------------------------------------------------------------------------

loc_660BE:
                lea     word_66152(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.l   d0
                beq.w   locret_6206C
                tst.w   d0
                beq.s   loc_660DA
                move.l  d0,-(sp)
                bsr.w   HPZKnux_DispatchPlayerContact
                move.l  (sp)+,d0

loc_660DA:
                swap    d0
                tst.w   d0
                beq.w   locret_6206C

; =============== S U B R O U T I N E =======================================

; Select the callback by facing side and vertical alignment. Nonrolling invincible contact goes directly to the hit response
HPZKnux_DispatchPlayerContact:
                btst    #4,$38(a0)
                bne.w   locret_6206C
                movea.w d0,a1
                btst    #0,render_flags(a0)
                sne     d4
                move.w  x_pos(a1),d1
                cmp.w   x_pos(a0),d1
                bhs.s   loc_66102
                not.b   d4

loc_66102:
                tst.b   d4
                bne.s   loc_66134
                move.w  y_pos(a1),d2
                sub.w   y_pos(a0),d2
                bpl.s   loc_66112
                neg.w   d2

loc_66112:
                cmpi.w  #$10,d2
                bhs.s   loc_66134
                cmpi.b  #2,anim(a1)
                beq.s   loc_6612A
                btst    #Status_Invincible,status_secondary(a1)
                bne.w   loc_6429E

loc_6612A:
                movea.l (a3),a4
                jmp     (a4)
; ---------------------------------------------------------------------------
; unused
                movea.l 4(a3),a4
                jmp     (a4)
; ---------------------------------------------------------------------------

loc_66134:
                cmpi.b  #2,anim(a1)
                beq.s   loc_66146
                btst    #Status_Invincible,status_secondary(a1)
                bne.w   loc_6429E

loc_66146:
                movea.l 8(a3),a4
                jmp     (a4)
; ---------------------------------------------------------------------------
; unused
                movea.l $C(a3),a4
                jmp     (a4)
; End of function HPZKnux_DispatchPlayerContact

; ---------------------------------------------------------------------------
word_66152:
                dc.w    -$18,   $30,  -$18,   $30

; =============== S U B R O U T I N E =======================================

HPZKnux_StopAtCameraXMargins:
                tst.w   x_vel(a0)
                beq.s   locret_66188
                bmi.s   loc_66176
                move.w  (Camera_X_pos).w,d0
                addi.w  #$130,d0
                cmp.w   x_pos(a0),d0
                bhi.s   locret_66188
                clr.w   x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_66176:
                move.w  (Camera_X_pos).w,d0
                addi.w  #$10,d0
                cmp.w   x_pos(a0),d0
                blo.s   locret_66188
                clr.w   x_vel(a0)

locret_66188:
                rts
; End of function HPZKnux_StopAtCameraXMargins

; ---------------------------------------------------------------------------

Knuckles_Load_PLC_6618A:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   $3A(a0),d0
                beq.s   locret_661DE
                move.b  d0,$3A(a0)
                lea     (PLC_Knuckles).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   locret_661DE
                move.w  #tiles_to_bytes(ArtTile_Player_2),d4
                move.l  #ArtUnc_Knux,d6

loc_661B6:
                moveq   #0,d1
                move.w  (a2)+,d1
                move.w  d1,d3
                lsr.w   #8,d3
                andi.w  #$F0,d3
                addi.w  #$10,d3
                andi.w  #$FFF,d1
                lsl.l   #5,d1
                add.l   d6,d1
                move.w  d4,d2
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                dbf     d5,loc_661B6

locret_661DE:
                rts

; =============== S U B R O U T I N E =======================================

Knuckles_Load_PLC_661E0:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   $3A(a0),d0
                beq.s   locret_66234
                move.b  d0,$3A(a0)
                lea     (PLC_Knuckles).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   locret_66234
                move.w  #tiles_to_bytes(ArtTile_CutsceneKnux),d4
                move.l  #ArtUnc_Knux,d6

loc_6620C:
                moveq   #0,d1
                move.w  (a2)+,d1
                move.w  d1,d3
                lsr.w   #8,d3
                andi.w  #$F0,d3
                addi.w  #$10,d3
                andi.w  #$FFF,d1
                lsl.l   #5,d1
                add.l   d6,d1
                move.w  d4,d2
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                dbf     d5,loc_6620C

locret_66234:
                rts
; End of function Knuckles_Load_PLC_661E0

; =============== S U B R O U T I N E =======================================

HPZKnucklesDustQueueDPLCWhenFrameChanges:
                move.l  #ArtUnc_DashDust,d6
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   $3A(a0),d0
                beq.s   locret_6628A
                move.b  d0,$3A(a0)
                lea     (DPLC_DashSplashDrown).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   locret_6628A
                move.w  #tiles_to_bytes(ArtTile_HPZKnuxBossDust),d4

loc_66262:
                moveq   #0,d1
                move.w  (a2)+,d1
                move.w  d1,d3
                lsr.w   #8,d3
                andi.w  #$F0,d3
                addi.w  #$10,d3
                andi.w  #$FFF,d1
                lsl.l   #5,d1
                add.l   d6,d1
                move.w  d4,d2
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                dbf     d5,loc_66262

locret_6628A:
                rts
; End of function HPZKnucklesDustQueueDPLCWhenFrameChanges

; =============== S U B R O U T I N E =======================================

; Add the signed byte step to the phase. Reverse the step when the signed countdown expires
HPZCrane_TickOscillation:
                move.b  $40(a0),d0
                add.b   d0,$3C(a0)
                subq.b  #1,$39(a0)
                bpl.s   locret_662A4
                move.b  $30(a0),$39(a0)
                neg.b   $40(a0)

locret_662A4:
                rts
; End of function HPZCrane_TickOscillation

; =============== S U B R O U T I N E =======================================

; Round the phase to frames $13 through $1A
HPZCrane_SelectEightWayFrame:
                moveq   #0,d0
                move.b  $3C(a0),d0
                addi.b  #$10,d0
                rol.b   #3,d0
                andi.b  #7,d0
                addi.b  #$13,d0
                move.b  d0,mapping_frame(a0)
                rts
; End of function HPZCrane_SelectEightWayFrame

; ---------------------------------------------------------------------------

loc_662C0:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d3
                lea     byte_66308(pc,d0.w),a1
                move.b  (a1)+,d1
                ext.w   d1
                add.w   d1,x_pos(a0)
                move.b  (a1)+,d2
                ext.w   d2
                add.w   d2,y_pos(a0)
                lsr.w   #1,d0
                addq.b  #7,d0
                move.b  d0,mapping_frame(a0)
                move.w  #-$200,d0
                lsl.w   #4,d3
                neg.w   d3
                add.w   d3,d0
                move.w  d0,x_vel(a0)
                lsl.w   #1,d3
                andi.w  #$180,d3
                addi.w  #$80,d3
                tst.w   d2
                bpl.s   loc_66302
                neg.w   d3

loc_66302:
                move.w  d3,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
byte_66308:
                dc.b    8,   -8
                dc.b    8,    0
                dc.b    8, -$10
                dc.b    8,    8
                dc.b    8, -$18
                dc.b    8,  $10
                dc.b    8, -$20
                dc.b    8,  $18
                dc.b    0,   -8
                dc.b    0,    0
                dc.b    0, -$10
                dc.b    0,    8
                dc.b    0, -$18
                dc.b    0,  $10
                dc.b    0, -$20
                dc.b    0,  $18
                dc.b    -8,   -8
                dc.b    -8,    0
                dc.b    -8, -$10
                dc.b    -8,    8
                dc.b    -8, -$18
                dc.b    -8,  $10
                dc.b    -8, -$20
                dc.b    -8,  $18
                dc.b    -$10,   -8
                dc.b    -$10,    0
                dc.b    -$10, -$10
                dc.b    -$10,    8
                dc.b    -$10, -$18
                dc.b    -$10,  $10
                dc.b    -$10, -$20
                dc.b    -$10,  $18

; =============== S U B R O U T I N E =======================================

; Count 48 updates while hit status bit 6 is set, then clear the bit
HPZShip_TickMovingHitPause:
                btst    #6,status(a0)
                beq.s   locret_66370
                tst.b   $20(a0)
                bne.s   loc_66364
                move.b  #$30,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_66364:
                subq.b  #1,$20(a0)
                bne.s   locret_66370
                bclr    #6,status(a0)

locret_66370:
                rts
; End of function HPZShip_TickMovingHitPause

; =============== S U B R O U T I N E =======================================

; Flash three palette slots for 32 updates before restoring the saved collision type
HPZShip_TickHitFlashAndRestoreColl:
                tst.b   collision_flags(a0)
                bne.s   locret_663B8
                tst.b   $20(a0)
                bne.s   loc_66392
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

loc_66392:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_663A0
; Bug: should be 2*3
                addi.w  #2*2,d0

loc_663A0:
                jsr     (CopySSZGHZThreeColorPaletteAtByteOffset).l
                subq.b  #1,$20(a0)
                bne.s   locret_663B8
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_663B8:
                rts
; End of function HPZShip_TickHitFlashAndRestoreColl
