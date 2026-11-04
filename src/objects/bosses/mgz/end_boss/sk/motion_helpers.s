; Owner: objects/bosses/mgz/end_boss/sk
; Responsibility: Marble Garden end-boss child motion, collision, palette adjustment, scaling and private geometry helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Copy the parent angle and index the caller's two-byte pose row. A zero depth entry leaves priority alone
MGZBossPart_SelectFrameAndDepth:
                movea.w parent3(a0),a1
                move.w  angle(a1),d0
                move.w  d0,angle(a0)
                lea     (a2,d0.w),a3
                move.b  (a3)+,mapping_frame(a0)
                moveq   #0,d0
                move.b  (a3)+,d0
                beq.s   locret_6D248
                lsl.w   #4,d0
                move.w  d0,priority(a0)

locret_6D248:
                rts
; End of function MGZBossPart_SelectFrameAndDepth

; ---------------------------------------------------------------------------
byte_6D24A:
                dc.b    2, $30
                dc.b    3, $30
                dc.b    $1E, $30
                dc.b    $1F, $30
                dc.b    5, $30
                dc.b    3, $30
                dc.b    4, $30
                dc.b    2, $30
byte_6D25A:
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

; Copy the parent angle and load signed byte offsets from the caller's pose table
MGZBossPart_SetOffsetsFromAngle:
                movea.w parent3(a0),a1
                move.w  angle(a1),d0
                move.w  d0,angle(a0)
                lea     (a2,d0.w),a3
                move.b  (a3)+,child_dx(a0)
                move.b  (a3)+,child_dy(a0)
                rts
; End of function MGZBossPart_SetOffsetsFromAngle

; ---------------------------------------------------------------------------
byte_6D284:
                dc.b    -$1C, $10
                dc.b    -$A, $18
                dc.b    $C, $1C
                dc.b    $18, $14
                dc.b    $2C,   8
                dc.b    $20, -$C
                dc.b    $14,-$14
                dc.b    -$1C, $10
byte_6D294:
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
                beq.s   locret_6D2D0
                subi.b  #$14,child_dx(a0)

locret_6D2D0:
                rts
; End of function SelectMGZBossPoseChildOffsetsAndFrame

; ---------------------------------------------------------------------------
byte_6D2D2:
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
byte_6D2E6:
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

loc_6D2FA:
                movea.w $44(a0),a1
                move.w  angle(a1),d0
                add.w   d0,d0
                move.l  off_6D314(pc,d0.w),$30(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------
off_6D314:
                dc.l    byte_6D853
                dc.l    byte_6D87A
                dc.l    byte_6D8A1
                dc.l    byte_6D8C8
                dc.l    byte_6D8CD
                dc.l    byte_6D8D2
                dc.l    byte_6D8D9
                dc.l    byte_6D853

; =============== S U B R O U T I N E =======================================

SetMGZBossIndexedAngleVelocity:
                move.w  angle(a0),d0
                add.w   d0,d0
                move.l  word_6D34E(pc,d0.w),x_vel(a0)   ; and y_vel
                btst    #0,render_flags(a1)
                beq.s   .return
                neg.w   x_vel(a0)

                .return:
                rts
; End of function SetMGZBossIndexedAngleVelocity

; ---------------------------------------------------------------------------
word_6D34E:
                dc.w    -$400,     0
                dc.w    -$400,  $400
                dc.w    0,  $400
                dc.w    $400,  $400
                dc.w    $400,     0
                dc.w    $400, -$400
                dc.w    0, -$400
                dc.w    -$400,     0

; =============== S U B R O U T I N E =======================================

; Use the parent angle for velocity and the child's even subtype for its delay
MGZBossTrail_InitVelAndDelay:
                movea.w parent3(a0),a1
                move.w  angle(a1),d0
                add.w   d0,d0
                move.l  word_6D34E(pc,d0.w),x_vel(a0)   ; and y_vel
                btst    #0,render_flags(a1)
                beq.s   loc_6D38A
                neg.w   x_vel(a0)

loc_6D38A:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_6D398(pc,d0.w),$2E(a0)
                rts
; End of function MGZBossTrail_InitVelAndDelay

; ---------------------------------------------------------------------------
word_6D398:
                dc.w    4,     9,    $E,   $13,   $18,   $1D,   $22,   $27
; ---------------------------------------------------------------------------

loc_6D3A8:
                movea.w $44(a0),a1
                move.w  angle(a1),d0
                add.w   d0,d0
                move.l  off_6D3C2(pc,d0.w),$30(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------
off_6D3C2:
                dc.l    byte_6D900
                dc.l    byte_6D91F
                dc.l    byte_6D93E
                dc.l    byte_6D8C8
                dc.l    byte_6D8CD
                dc.l    byte_6D8D2
                dc.l    byte_6D95D
                dc.l    byte_6D900
; ---------------------------------------------------------------------------

loc_6D3E2:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d0
                move.b  RawAni_6D3FC(pc,d0.w),mapping_frame(a0)
                add.w   d1,d1
                move.l  word_6D406(pc,d1.w),x_vel(a0)   ; and y_vel
                rts
; ---------------------------------------------------------------------------
RawAni_6D3FC:
                dc.b    0,   1,   2,   0,   0,   1,   0,   2,   0,   1
                even
word_6D406:
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
                bcc.s   loc_6D452
                addq.w  #2,d1
                bset    #0,render_flags(a0)

loc_6D452:
                move.w  (Camera_Y_pos).w,d3
                addi.w  #8,d3
                lea     (_unkFA82).w,a2

loc_6D45E:
                move.w  (Camera_X_pos).w,d2
                addi.w  #$A8,d2
                add.w   d0,d2
                add.w   d1,d1
                move.w  word_6D4AC(pc,d1.w),d4
                move.w  d4,angle(a0)
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                move.w  d1,(a2)+
                move.w  d4,(a2)+
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                add.w   d1,d1
                move.l  off_6D4BC(pc,d1.w),$30(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                add.w   d4,d4
                lea     word_6D34E(pc),a3
                move.l  (a3,d4.w),x_vel(a0)             ; and y_vel
                btst    #0,render_flags(a0)
                beq.s   locret_6D4AA
                neg.w   x_vel(a0)

locret_6D4AA:
                rts
; End of function LaunchMGZBossUpperDrillPassAndRecordPlan

; ---------------------------------------------------------------------------
word_6D4AC:
                dc.w    4,     2,     4,     2,    $C,    $A,    $C,    $A
off_6D4BC:
                dc.l    byte_6D8C1
                dc.l    byte_6D89A
                dc.l    byte_6D8C1
                dc.l    byte_6D89A
                dc.l    byte_6D8F9
                dc.l    byte_6D8D2
                dc.l    byte_6D8F9
                dc.l    byte_6D8D2

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
                move.b  byte_6D516(pc,d2.w),d3
                beq.s   loc_6D508
                neg.w   d0
                bclr    #0,render_flags(a0)

loc_6D508:
                add.b   d3,d1
                move.w  #$F8,d3
                lea     (_unkFA8A).w,a2
                bra.w   loc_6D45E
; End of function LaunchMGZBossLowerDrillPassFromUpperPlan

; ---------------------------------------------------------------------------
byte_6D516:
                dc.b    2,   0,   0,   2
                even
; ---------------------------------------------------------------------------

loc_6D51A:
                move.w  (a1)+,d0
                move.w  (a1)+,d1
                move.w  d1,angle(a0)
                move.w  (a1)+,d2
                move.w  (a1)+,d3
                lea     byte_6D588(pc,d0.w),a2
                move.b  (a2)+,d4
                ext.w   d4
                add.w   d4,d2
                move.w  d2,x_pos(a0)
                move.b  (a2)+,d4
                ext.w   d4
                add.w   d4,d3
                move.w  d3,y_pos(a0)
                lsr.w   #1,d0
                move.b  byte_6D598(pc,d0.w),$3A(a0)
                lsr.w   #1,d0
                move.b  byte_6D5A0(pc,d0.w),d2
                andi.b  #$FC,render_flags(a0)
                or.b    d2,render_flags(a0)
                add.w   d1,d1
                lea     word_6D34E(pc),a2
                move.l  (a2,d1.w),x_vel(a0)             ; and y_vel
                asr     x_vel(a0)
                asr     y_vel(a0)
                btst    #0,render_flags(a0)
                beq.s   loc_6D576
                neg.w   x_vel(a0)

loc_6D576:
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_6D83E(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------
byte_6D588:
                dc.b    -$C,-$2C
                dc.b    $1A,-$28
                dc.b    $C,-$2C
                dc.b    -$1A,-$28
                dc.b    $14, $24
                dc.b    $30, $1C
                dc.b    -$14, $24
                dc.b    -$30, $1C
byte_6D598:
                dc.b    0,   8,   0,   8,   0,   2,   0,   2
byte_6D5A0:
                dc.b    0,   1,   1,   0
                even

; =============== S U B R O U T I N E =======================================

MGZ2_SpecialCheckHit:
                tst.b   collision_flags(a0)
                bne.s   locret_6D608                    ; If collision is on, don't do anything
                tst.b   collision_property(a0)
                bne.s   loc_6D5C2                       ; If still has a hit point, branch
                tst.b   $46(a0)
                beq.s   loc_6D60A                       ; ONLY kill the boss is $46 isn't set. If it is set, this is an event instance of the object
                move.b  #1,collision_property(a0)
                bclr    #7,status(a0)

loc_6D5C2:
                tst.b   $20(a0)
                bne.s   loc_6D5D6
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0    ; Play hit sound
                jsr     (Play_SFX).l

loc_6D5D6:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_6D5EA
                addi.w  #2*3,d0

loc_6D5EA:
                bsr.w   MGZ2_BossPalAdjust
                subq.b  #1,$20(a0)
                bne.s   locret_6D608
                bclr    #6,status(a0)
                cmpi.b  #0,mapping_frame(a0)
                bne.s   locret_6D608
                move.b  $25(a0),collision_flags(a0)     ; Put backup of collision back into $28

locret_6D608:
                rts
; ---------------------------------------------------------------------------

loc_6D60A:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #loc_6C2BE,$34(a0)
                jmp     (BossDefeated_StopTimer).l
; End of function MGZ2_SpecialCheckHit

; ---------------------------------------------------------------------------

loc_6D61E:
                tst.b   collision_flags(a0)
                bne.s   locret_6D668
                tst.b   collision_property(a0)
                beq.s   loc_6D66A
                tst.b   $20(a0)
                bne.s   loc_6D644
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

loc_6D644:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_6D652
                addi.w  #2*3,d0

loc_6D652:
                bsr.w   MGZ2_BossPalAdjust
                subq.b  #1,$20(a0)
                bne.s   locret_6D668
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_6D668:
                rts
; ---------------------------------------------------------------------------

loc_6D66A:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #loc_6C890,$34(a0)
                jmp     (BossDefeated_StopTimer).l

; =============== S U B R O U T I N E =======================================

MGZ2_BossPalAdjust:
                lea     word_6D694(pc),a1
                lea     word_6D69A(pc,d0.w),a2
                rept    3
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+
                endm
                rts
; End of function MGZ2_BossPalAdjust

; ---------------------------------------------------------------------------
word_6D694:
                dc.w    Normal_palette_line_2+$16, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
word_6D69A:
                dc.w    $20,  $866,  $644
                dc.w    $EEE,  $888,  $AAA
; ---------------------------------------------------------------------------

loc_6D6A6:
                movea.w $44(a0),a1
                movea.w parent3(a1),a1
                btst    #7,status(a1)
                bne.s   loc_6D6BC
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_6D6BC:
                jsr     (Random_Number).l
                andi.w  #$3C,d0
                jmp     (SKChild_StartFlickerAndDraw).l

; =============== S U B R O U T I N E =======================================

; The eight-step parent counter selects the scaled flyby's vertical motion and the real boss's next entry
MGZBossFlyby_SelectPathAndEntry:
                movea.w parent3(a0),a2
                moveq   #0,d0
                move.b  $39(a2),d0
                addq.b  #1,$39(a2)
                andi.b  #7,d0
                move.b  byte_6D708(pc,d0.w),d0
                move.w  d0,ground_vel(a0)
                move.w  d0,$3C(a2)
                lea     word_6D6F8(pc,d0.w),a1
                move.w  (a1)+,y_vel(a0)
                move.w  (a1)+,$3C(a0)
                rts
; End of function MGZBossFlyby_SelectPathAndEntry

; ---------------------------------------------------------------------------
word_6D6F8:
                dc.w    -$200,     8
                dc.w    -$600,   $40
                dc.w    $600,  -$40
                dc.w    -$200,     8
byte_6D708:
                dc.b    0,   8,   4,   0,   0,   4,   0,   8
                even
; ---------------------------------------------------------------------------

loc_6D710:
                move.w  $3C(a0),d0
                lea     word_6D744(pc,d0.w),a2
                move.w  (a2)+,d1
                add.w   (Camera_X_pos).w,d1
                move.w  d1,x_pos(a0)
                move.w  (a2)+,d1
                add.w   (Camera_Y_pos).w,d1
                move.w  d1,y_pos(a0)
                move.l  word_6D754(pc,d0.w),x_vel(a0)   ; and y_vel
                lsr.w   #1,d0
                move.w  word_6D764(pc,d0.w),angle(a0)
                lsr.w   #1,d0
                move.b  byte_6D76C(pc,d0.w),$3A(a0)
                rts
; ---------------------------------------------------------------------------
word_6D744:
                dc.w    -$40,   $70
                dc.w    $A0,  $120
                dc.w    $A0,  -$50
                dc.w    -$40,   $70
word_6D754:
                dc.w    $200,     0
                dc.w    $80, -$200
                dc.w    $80,  $200
                dc.w    $200,     0
word_6D764:
                dc.w    0,    $C,     4,     0
byte_6D76C:
                dc.b    6,   4,   8,   6
                even
