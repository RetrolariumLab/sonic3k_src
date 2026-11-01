; Owner: objects/bosses/mgz/end_boss/s3
; Responsibility: Marble Garden end-boss child motion, collision, palette adjustment, scaling and private geometry helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SelectMGZBossAttachmentFrameAndDepthFromParentAngle:
                movea.w parent3(a0),a1
                move.w  angle(a1),d0
                move.w  d0,angle(a0)
                lea     (a2,d0.w),a3
                move.b  (a3)+,mapping_frame(a0)
                moveq   #0,d0
                move.b  (a3)+,d0
                beq.s   locret_4AEBA
                lsl.w   #4,d0
                move.w  d0,priority(a0)

locret_4AEBA:
                rts
; End of function SelectMGZBossAttachmentFrameAndDepthFromParentAngle

; ---------------------------------------------------------------------------
byte_4AEBC:
                dc.b    2, $30
                dc.b    3, $30
                dc.b    $1E, $30
                dc.b    $1F, $30
                dc.b    5, $30
                dc.b    3, $30
                dc.b    4, $30
                dc.b    2, $30
byte_4AECC:
                dc.b    9, $28
                dc.b    $C, $28
                dc.b    $20, $28
                dc.b    $14, $30
                dc.b    $13, $30
                dc.b    $12, $30
                dc.b    $F, $28
                dc.b    9, $28
                even

; =============== S U B R O U T I N E =======================================

SelectMGZBossAttachmentOffsetsFromParentAngle:
                movea.w parent3(a0),a1
                move.w  angle(a1),d0
                move.w  d0,angle(a0)
                lea     (a2,d0.w),a3
                move.b  (a3)+,child_dx(a0)
                move.b  (a3)+,child_dy(a0)
                rts
; End of function SelectMGZBossAttachmentOffsetsFromParentAngle

; ---------------------------------------------------------------------------
byte_4AEF6:
                dc.b    -$1C, $10
                dc.b    -$A, $18
                dc.b    $C, $1C
                dc.b    $18, $14
                dc.b    $2C,   8
                dc.b    $20, -$C
                dc.b    $14,-$14
                dc.b    -$1C, $10
byte_4AF06:
                dc.b    -$17,   0
                dc.b    -$11, $16
                dc.b    0, $20
                dc.b    $10,  $F
                dc.b    $11,   0
                dc.b    $10,-$10
                dc.b    0,-$20
                dc.b    -$17,   0
                even

; =============== S U B R O U T I N E =======================================

SelectMGZBossPoseChildOffsetsAndFrame:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  $3A(a1),d0
                move.b  d0,$3A(a0)
                add.w   d0,d0
                lea     (a2,d0.w),a3
                move.b  (a3)+,child_dx(a0)
                move.b  (a3)+,child_dy(a0)
                move.b  (a3)+,mapping_frame(a0)
                tst.b   subtype(a0)
                beq.s   locret_4AF42
                subi.b  #$14,child_dx(a0)

locret_4AF42:
                rts
; End of function SelectMGZBossPoseChildOffsetsAndFrame

; ---------------------------------------------------------------------------
byte_4AF44:
                dc.b    8, $18,   6
                even
                dc.b    -8, $14,   7
                even
                dc.b    $18, $14,   8
                even
                dc.b    $18,   8, $18
                even
                dc.b    $18,  -4, $23
                even
byte_4AF58:
                dc.b    0, $10, $19
                even
                dc.b    -8,   8, $1A
                even
                dc.b    8,   8, $24
                even
                dc.b    $10,   0, $1B
                even
                dc.b    9,  -7, $25
                even
; ---------------------------------------------------------------------------

loc_4AF6C:
                movea.w $44(a0),a1
                move.w  angle(a1),d0
                add.w   d0,d0
                move.l  off_4AF86(pc,d0.w),$30(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------
off_4AF86:
                dc.l    byte_4B45B
                dc.l    byte_4B482
                dc.l    byte_4B4A9
                dc.l    byte_4B4D0
                dc.l    byte_4B4D5
                dc.l    byte_4B4DA
                dc.l    byte_4B4E1
                dc.l    byte_4B45B

; =============== S U B R O U T I N E =======================================

SetMGZBossIndexedAngleVelocity:
                move.w  angle(a0),d0
                add.w   d0,d0
                move.l  word_4AFC0(pc,d0.w),x_vel(a0)   ; and y_vel
                btst    #0,render_flags(a1)
                beq.s   .return
                neg.w   x_vel(a0)

                .return:
                rts
; End of function SetMGZBossIndexedAngleVelocity

; ---------------------------------------------------------------------------
word_4AFC0:
                dc.w    -$400,     0
                dc.w    -$400,  $400
                dc.w    0,  $400
                dc.w    $400,  $400
                dc.w    $400,     0
                dc.w    $400, -$400
                dc.w    0, -$400
                dc.w    -$400,     0

; =============== S U B R O U T I N E =======================================

InitializeMGZBossStaggeredTrailVelocityAndDelay:
                movea.w parent3(a0),a1
                move.w  angle(a1),d0
                add.w   d0,d0
                move.l  word_4AFC0(pc,d0.w),x_vel(a0)   ; and y_vel
                btst    #0,render_flags(a1)
                beq.s   loc_4AFFC
                neg.w   x_vel(a0)

loc_4AFFC:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_4B00A(pc,d0.w),$2E(a0)
                rts
; End of function InitializeMGZBossStaggeredTrailVelocityAndDelay

; ---------------------------------------------------------------------------
word_4B00A:
                dc.w    4,     9,    $E,   $13,   $18,   $1D,   $22,   $27
; ---------------------------------------------------------------------------

loc_4B01A:
                movea.w $44(a0),a1
                move.w  angle(a1),d0
                add.w   d0,d0
                move.l  off_4B034(pc,d0.w),$30(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------
off_4B034:
                dc.l    byte_4B508
                dc.l    byte_4B527
                dc.l    byte_4B546
                dc.l    byte_4B4D0
                dc.l    byte_4B4D5
                dc.l    byte_4B4DA
                dc.l    byte_4B565
                dc.l    byte_4B508
; ---------------------------------------------------------------------------

loc_4B054:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d0
                move.b  RawAni_4B06E(pc,d0.w),mapping_frame(a0)
                add.w   d1,d1
                move.l  word_4B078(pc,d1.w),x_vel(a0)   ; and y_vel
                rts
; ---------------------------------------------------------------------------
RawAni_4B06E:
                dc.b    0,   1,   2,   0,   0,   1,   0,   2,   0,   1
                even
word_4B078:
                dc.w    -$400, -$400
                dc.w    $400, -$400
                dc.w    -$80, -$400
                dc.w    $80, -$400
                dc.w    -$300, -$200
                dc.w    $300, -$200
                dc.w    -$200, -$300
                dc.w    $200, -$300
                dc.w    -$80, -$200
                dc.w    $80, -$200

; =============== S U B R O U T I N E =======================================

LaunchMGZBossUpperDrillPassAndRecordPlan:
                jsr     (Random_Number).l
                andi.w  #$FF,d0
                move.w  d0,d1
                andi.w  #1,d1
                bclr    #0,render_flags(a0)
                subi.w  #$80,d0
                bcc.s   loc_4B0C4
                addq.w  #2,d1
                bset    #0,render_flags(a0)

loc_4B0C4:
                move.w  #$550,d3
                lea     (_unkFA82).w,a2

loc_4B0CC:
                move.w  #$3AF0,d2
                add.w   d0,d2
                add.w   d1,d1
                move.w  word_4B116(pc,d1.w),d4
                move.w  d4,angle(a0)
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                move.w  d1,(a2)+
                move.w  d4,(a2)+
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                add.w   d1,d1
                move.l  off_4B126(pc,d1.w),$30(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                add.w   d4,d4
                lea     word_4AFC0(pc),a3
                move.l  (a3,d4.w),x_vel(a0)             ; and y_vel
                btst    #0,render_flags(a0)
                beq.s   locret_4B114
                neg.w   x_vel(a0)

locret_4B114:
                rts
; End of function LaunchMGZBossUpperDrillPassAndRecordPlan

; ---------------------------------------------------------------------------
word_4B116:
                dc.w    4,     2,     4,     2,    $C,    $A,    $C,    $A
off_4B126:
                dc.l    byte_4B4C9
                dc.l    byte_4B4A2
                dc.l    byte_4B4C9
                dc.l    byte_4B4A2
                dc.l    byte_4B501
                dc.l    byte_4B4DA
                dc.l    byte_4B501
                dc.l    byte_4B4DA

; =============== S U B R O U T I N E =======================================

LaunchMGZBossLowerDrillPassFromUpperPlan:
                jsr     (Random_Number).l
                andi.w  #$7F,d0
                move.w  d0,d1
                andi.w  #1,d1
                addq.w  #4,d1
                move.w  (_unkFA82).w,d2
                lsr.w   #1,d2
                bset    #0,render_flags(a0)
                move.b  byte_4B180(pc,d2.w),d3
                beq.s   loc_4B172
                neg.w   d0
                bclr    #0,render_flags(a0)

loc_4B172:
                add.b   d3,d1
                move.w  #$610,d3
                lea     (_unkFA8A).w,a2
                bra.w   loc_4B0CC
; End of function LaunchMGZBossLowerDrillPassFromUpperPlan

; ---------------------------------------------------------------------------
byte_4B180:
                dc.b    2,   0,   0,   2
                even
; ---------------------------------------------------------------------------

loc_4B184:
                move.w  (a1)+,d0
                move.w  (a1)+,d1
                move.w  d1,angle(a0)
                move.w  (a1)+,d2
                move.w  (a1)+,d3
                lea     byte_4B1E2(pc,d0.w),a2
                move.b  (a2)+,d4
                ext.w   d4
                add.w   d4,d2
                move.w  d2,x_pos(a0)
                move.b  (a2)+,d4
                ext.w   d4
                add.w   d4,d3
                move.w  d3,y_pos(a0)
                lsr.w   #1,d0
                move.b  byte_4B1F2(pc,d0.w),$3A(a0)
                lsr.w   #1,d0
                move.b  byte_4B1FA(pc,d0.w),d2
                andi.b  #$FC,render_flags(a0)
                or.b    d2,render_flags(a0)
                add.w   d1,d1
                lea     word_4AFC0(pc),a2
                move.l  (a2,d1.w),x_vel(a0)             ; and y_vel
                asr     x_vel(a0)
                asr     y_vel(a0)
                btst    #0,render_flags(a0)
                beq.s   locret_4B1E0
                neg.w   x_vel(a0)

locret_4B1E0:
                rts
; ---------------------------------------------------------------------------
byte_4B1E2:
                dc.b    -$C,-$2C
                dc.b    $1A,-$28
                dc.b    $C,-$2C
                dc.b    -$1A,-$28
                dc.b    $14, $24
                dc.b    $30, $1C
                dc.b    -$14, $24
                dc.b    -$30, $1C
byte_4B1F2:
                dc.b    0,   8,   0,   8,   0,   2,   0,   2
byte_4B1FA:
                dc.b    0,   1,   1,   0
                even

; =============== S U B R O U T I N E =======================================

MGZ2_SpecialCheckHit:
                tst.b   collision_flags(a0)
                bne.s   locret_4B262                    ; If collision is on, don't do anything
                tst.b   collision_property(a0)
                bne.s   loc_4B21C                       ; If still has a hit point, branch
                tst.b   $46(a0)
                beq.s   loc_4B264                       ; ONLY kill the boss is $46 isn't set. If it is set, this is an event instance of the object
                move.b  #1,collision_property(a0)
                bclr    #7,status(a0)

loc_4B21C:
                tst.b   $20(a0)
                bne.s   loc_4B230
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0    ; Play hit sound
                jsr     (Play_SFX).l

loc_4B230:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_4B244
                addi.w  #2*3,d0

loc_4B244:
                bsr.w   MGZ2_BossPalAdjust
                subq.b  #1,$20(a0)
                bne.s   locret_4B262
                bclr    #6,status(a0)
                cmpi.b  #0,mapping_frame(a0)
                bne.s   locret_4B262
                move.b  $25(a0),collision_flags(a0)     ; Put backup of collision back into $28

locret_4B262:
                rts
; ---------------------------------------------------------------------------

loc_4B264:
                move.l  #Wait_Draw,(a0)
                move.l  #loc_4A592,$34(a0)
                jmp     (BossDefeated_StopTimer).l
; End of function MGZ2_SpecialCheckHit

; =============== S U B R O U T I N E =======================================

MGZ2_BossPalAdjust:
                lea     word_4B28E(pc),a1
                lea     word_4B294(pc,d0.w),a2
                rept    3
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+
                endm
                rts
; End of function MGZ2_BossPalAdjust

; ---------------------------------------------------------------------------
word_4B28E:
                dc.w    Normal_palette_line_2+$16, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
word_4B294:
                dc.w    $20,  $866,  $644
                dc.w    $EEE,  $888,  $AAA
; ---------------------------------------------------------------------------

loc_4B2A0:
                movea.w $44(a0),a1
                movea.w parent3(a1),a1
                btst    #7,status(a1)
                bne.s   loc_4B2B6
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_4B2B6:
                jsr     (Random_Number).l
                andi.w  #$3C,d0
                jmp     (loc_5312A).l

; =============== S U B R O U T I N E =======================================

SelectMGZBossScaledFlybyAndNextEntryPattern:
                movea.w parent3(a0),a2
                moveq   #0,d0
                move.b  $39(a2),d0
                addq.b  #1,$39(a2)
                andi.b  #7,d0
                move.b  byte_4B302(pc,d0.w),d0
                move.w  d0,ground_vel(a0)
                move.w  d0,$3C(a2)
                lea     word_4B2F2(pc,d0.w),a1
                move.w  (a1)+,y_vel(a0)
                move.w  (a1)+,$3C(a0)
                rts
; End of function SelectMGZBossScaledFlybyAndNextEntryPattern

; ---------------------------------------------------------------------------
word_4B2F2:
                dc.w    -$200,     8
                dc.w    -$600,   $40
                dc.w    $600,  -$40
                dc.w    -$200,     8
byte_4B302:
                dc.b    0,   8,   4,   0,   0,   4,   0,   8
                even

; =============== S U B R O U T I N E =======================================

IntegrateScaledActorPositionAccumulators:
                move.w  x_vel(a0),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,$30(a0)
                move.w  y_vel(a0),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,$34(a0)
                rts
; End of function IntegrateScaledActorPositionAccumulators

; ---------------------------------------------------------------------------

loc_4B324:
                move.w  $3C(a0),d0
                lea     word_4B358(pc,d0.w),a2
                move.w  (a2)+,d1
                add.w   (Camera_X_pos).w,d1
                move.w  d1,x_pos(a0)
                move.w  (a2)+,d1
                add.w   (Camera_Y_pos).w,d1
                move.w  d1,y_pos(a0)
                move.l  word_4B368(pc,d0.w),x_vel(a0)   ; and y_vel
                lsr.w   #1,d0
                move.w  word_4B378(pc,d0.w),angle(a0)
                lsr.w   #1,d0
                move.b  byte_4B380(pc,d0.w),$3A(a0)
                rts
; ---------------------------------------------------------------------------
word_4B358:
                dc.w    -$40,   $70
                dc.w    $A0,  $120
                dc.w    $A0,  -$50
                dc.w    -$40,   $70
word_4B368:
                dc.w    $200,     0
                dc.w    $80, -$200
                dc.w    $80,  $200
                dc.w    $200,     0
word_4B378:
                dc.w    0,    $C,     4,     0
byte_4B380:
                dc.b    6,   4,   8,   6
                even
