; Owner: objects/bosses/dez/miniboss/sk
; Responsibility: Death Egg miniboss movement, collision, palette, angle and parent-state helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

HurtBothPlayersInsideDEZMinibossBeamRange:
                lea     word_7EB6E(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.w   d0
                beq.s   loc_7EB46
                bsr.w   HurtDEZBeamRangePlayerUnlessProtectedOrOnObject

loc_7EB46:
                swap    d0
                tst.w   d0
                beq.s   locret_7EB6C
; End of function HurtBothPlayersInsideDEZMinibossBeamRange

; =============== S U B R O U T I N E =======================================

HurtDEZBeamRangePlayerUnlessProtectedOrOnObject:
                movea.w d0,a1
                tst.b   $34(a1)
                bne.s   locret_7EB6C
                btst    #Status_OnObj,status(a1)
                bne.s   locret_7EB6C
                btst    #Status_Invincible,status_secondary(a1)
                bne.s   locret_7EB6C
                move.l  d0,-(sp)
                jsr     HurtCharacter_Directly(pc)
                move.l  (sp)+,d0

locret_7EB6C:
                rts
; End of function HurtDEZBeamRangePlayerUnlessProtectedOrOnObject

; ---------------------------------------------------------------------------
word_7EB6E:
                dc.w    -$18,   $30,  -$48,   $90

; =============== S U B R O U T I N E =======================================

SetDEZOrbitHazardCollisionFromParentStatusSix:
                move.b  #$86,collision_flags(a0)
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                beq.s   locret_7EB8C
                clr.b   collision_flags(a0)

locret_7EB8C:
                rts
; End of function SetDEZOrbitHazardCollisionFromParentStatusSix

; =============== S U B R O U T I N E =======================================

RetargetDEZMinibossPlatformAngularVelocityFromPlayer:
                btst    #3,(Player_1+status).w
                bne.s   loc_7EBBA
                move.b  (V_int_run_count+3).w,d0
                andi.w  #$1F,d0
                bne.s   locret_7EBB8
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                move.w  $26(a0),d1
                tst.w   d0
                beq.s   loc_7EBB4
                neg.w   d1

loc_7EBB4:
                move.w  d1,$3C(a0)

locret_7EBB8:
                rts
; ---------------------------------------------------------------------------

loc_7EBBA:
                move.w  $26(a0),$3C(a0)
                rts
; End of function RetargetDEZMinibossPlatformAngularVelocityFromPlayer

; =============== S U B R O U T I N E =======================================

AccelerateDEZPlatformSharedAngularStepAndAdvancePhase:
                movea.w parent3(a0),a1
                moveq   #8,d0
                move.w  $3A(a1),d1
                move.w  $3C(a1),d2
                bmi.s   loc_7EBDE
                add.w   d0,d1
                cmp.w   d2,d1
                blt.s   loc_7EBE8
                move.w  d2,d1
                bra.w   loc_7EBE8
; ---------------------------------------------------------------------------

loc_7EBDE:
                neg.w   d0
                add.w   d0,d1
                cmp.w   d2,d1
                bgt.s   loc_7EBE8
                move.w  d2,d1

loc_7EBE8:
                add.w   d1,$3C(a0)
                move.w  d1,$3A(a1)
                rts
; End of function AccelerateDEZPlatformSharedAngularStepAndAdvancePhase

; ---------------------------------------------------------------------------

loc_7EBF2:
                movea.w parent3(a0),a1
                tst.b   subtype(a0)
                bne.s   loc_7EC06
                move.b  $3C(a0),child_dy(a1)
                bra.w   loc_7EC12
; ---------------------------------------------------------------------------

loc_7EC06:
                move.b  child_dy(a1),d0
                addi.b  #$80,d0
                move.b  d0,$3C(a0)

loc_7EC12:
                move.w  x_pos(a0),-(sp)
                moveq   #2,d2
                jsr     MoveSprite_CircularSimpleOffset(pc)
                moveq   #$23,d1
                moveq   #8,d2
                moveq   #$15,d3
                move.w  (sp)+,d4

loc_7EC24:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_7EC3C
                jsr     (SolidObjectTop).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7EC3C:
                jsr     Displace_PlayerOffObject(pc)
                moveq   #0,d0
                jmp     SKChild_StartFlickerAndDraw(pc)
; ---------------------------------------------------------------------------

loc_7EC46:
                moveq   #$23,d1
                moveq   #8,d2
                moveq   #$15,d3
                move.w  x_pos(a0),d4
                bra.s   loc_7EC24
; ---------------------------------------------------------------------------

loc_7EC52:
                move.w  x_pos(a0),-(sp)
                jsr     MoveSprite_Circular(pc)
                moveq   #$23,d1
                moveq   #8,d2
                moveq   #$15,d3
                move.w  (sp)+,d4
                bra.s   loc_7EC24

; =============== S U B R O U T I N E =======================================

ReverseDEZMinibossHorizontalVelocityPastBounds:
                move.w  x_pos(a0),d0
                tst.w   x_vel(a0)
                beq.s   locret_7EC82
                bmi.s   loc_7EC78
                cmp.w   (_unkFAB6).w,d0
                bhi.s   loc_7EC7E
                rts
; ---------------------------------------------------------------------------

loc_7EC78:
                cmp.w   (_unkFAB4).w,d0
                bhs.s   locret_7EC82

loc_7EC7E:
                neg.w   x_vel(a0)

locret_7EC82:
                rts
; End of function ReverseDEZMinibossHorizontalVelocityPastBounds

; =============== S U B R O U T I N E =======================================

SetDEZMinibossPlayerPursuitVelocityWithinBounds:
                move.w  x_pos(a0),d0
                move.w  #-$80,d1
                move.w  (Player_1+x_pos).w,d2
                sub.w   d0,d2
                bls.s   loc_7EC96
                neg.w   d1

loc_7EC96:
                move.w  d1,x_vel(a0)
                beq.s   locret_7ECB0
                bmi.s   loc_7ECA6
                cmp.w   (_unkFAB6).w,d0
                bhs.s   loc_7ECAC
                rts
; ---------------------------------------------------------------------------

loc_7ECA6:
                cmp.w   (_unkFAB4).w,d0
                bhi.s   locret_7ECB0

loc_7ECAC:
                clr.w   x_vel(a0)

locret_7ECB0:
                rts
; End of function SetDEZMinibossPlayerPursuitVelocityWithinBounds

; ---------------------------------------------------------------------------
; unused
                move.w  x_pos(a0),d0
                tst.w   x_vel(a0)
                beq.s   loc_7ECD2
                bmi.s   loc_7ECC8
                cmp.w   (_unkFAB6).w,d0
                bhs.s   loc_7ECCE
                bra.w   loc_7ECD2
; ---------------------------------------------------------------------------

loc_7ECC8:
                cmp.w   (_unkFAB4).w,d0
                bhi.s   loc_7ECD2

loc_7ECCE:
                clr.w   x_vel(a0)

loc_7ECD2:
                move.w  y_pos(a0),d0
                tst.w   y_vel(a0)
                beq.s   locret_7ECF2
                bmi.s   loc_7ECE8
                cmp.w   (_unkFAB2).w,d0
                bhs.s   loc_7ECEE
                bra.w   locret_7ECF2
; ---------------------------------------------------------------------------

loc_7ECE8:
                cmp.w   (_unkFAB0).w,d0
                bhi.s   locret_7ECF2

loc_7ECEE:
                clr.w   y_vel(a0)

locret_7ECF2:
                rts

; =============== S U B R O U T I N E =======================================

SeedDEZMinibossRandomFlickerDebris:
                jsr     (Random_Number).l
                move.w  d0,d1
                andi.w  #$C,d1
                move.l  word_7ED40(pc,d1.w),x_vel(a0)   ; and y_vel
                andi.w  #$1F,d0
                btst    #0,d0
                beq.s   loc_7ED1C
                neg.w   d0
                neg.w   x_vel(a0)
                bset    #0,render_flags(a0)

loc_7ED1C:
                add.w   d0,x_pos(a0)
                swap    d0
                move.w  d0,d1
                andi.w  #3,d1
                move.b  byte_7ED50(pc,d1.w),mapping_frame(a0)
                andi.w  #$1F,d0
                btst    #0,d0
                beq.s   loc_7ED3A
                neg.w   d0

loc_7ED3A:
                add.w   d0,y_pos(a0)
                rts
; End of function SeedDEZMinibossRandomFlickerDebris

; ---------------------------------------------------------------------------
word_7ED40:
                dc.w    $300, -$400
                dc.w    $200, -$300
                dc.w    $400, -$500
                dc.w    $300, -$200
byte_7ED50:
                dc.b    $12
                dc.b    $13
                dc.b    $14
                dc.b    $12
                even

; =============== S U B R O U T I N E =======================================

SeedDEZMinibossEightOrbitHazardPhases:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  byte_7ED64(pc,d0.w),$3C(a0)
                rts
; End of function SeedDEZMinibossEightOrbitHazardPhases

; ---------------------------------------------------------------------------
byte_7ED64:
                dc.b    0, $80
                dc.b    $20, $A0
                dc.b    $40, $C0
                dc.b    $60, $E0
                even

; =============== S U B R O U T I N E =======================================

TrackDEZMinibossEyeTowardPlayerOne:
                movea.w parent3(a0),a1
                move.w  y_pos(a1),y_pos(a0)
                move.w  (Player_1+x_pos).w,d0
                move.w  x_pos(a1),d1
                sub.w   d1,d0
                smi     d2
                bpl.s   loc_7ED86
                neg.w   d0

loc_7ED86:
                cmpi.w  #$A0,d0
                bls.s   loc_7ED90
                move.w  #$A0,d0

loc_7ED90:
                lsr.w   #3,d0
                andi.w  #$FE,d0
                lea     byte_7EDBA(pc,d0.w),a2
                move.b  (a2)+,d0
                bclr    #0,render_flags(a0)
                tst.b   d2
                beq.s   loc_7EDAE
                bset    #0,render_flags(a0)
                neg.w   d0

loc_7EDAE:
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.b  (a2)+,mapping_frame(a0)
                rts
; End of function TrackDEZMinibossEyeTowardPlayerOne

; ---------------------------------------------------------------------------
byte_7EDBA:
                dc.b    0,   2
                dc.b    1,   2
                dc.b    2,   3
                dc.b    4,   3
                dc.b    5,   3
                dc.b    6,   4
                dc.b    8,   4
                dc.b    9,   4
                dc.b    $A,   5
                dc.b    $B,   5
                dc.b    $C,   5
                even

; =============== S U B R O U T I N E =======================================

AdvanceDEZMinibossEyeHitAndIncrementRootCounter:
                tst.b   collision_flags(a0)
                bne.s   locret_7EE10
                tst.b   $20(a0)
                bne.s   loc_7EDF2
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                movea.w parent3(a0),a1
                addq.b  #1,collision_property(a1)

loc_7EDF2:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_7EE00
                addi.w  #2*4,d0

loc_7EE00:
                bsr.w   CopyDEZMinibossEyeFourColorPalette
                subq.b  #1,$20(a0)
                bne.s   locret_7EE10
                move.b  $25(a0),collision_flags(a0)

locret_7EE10:
                rts
; End of function AdvanceDEZMinibossEyeHitAndIncrementRootCounter

; =============== S U B R O U T I N E =======================================

CopyDEZMinibossEyeFourColorPalette:
                lea     word_7EE1E(pc),a1
                lea     word_7EE26(pc,d0.w),a2
                jmp     CopyWordData_4(pc)
; End of function CopyDEZMinibossEyeFourColorPalette

; ---------------------------------------------------------------------------
word_7EE1E:
                dc.w    Normal_palette_line_2+$16, Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
word_7EE26:
                dc.w    $666,  $444,  $222,     0
                dc.w    $888,  $AAA,  $CCC,  $EEE
; ---------------------------------------------------------------------------

loc_7EE36:
                move.b  collision_property(a0),d0
                cmp.b   $42(a0),d0
                bne.s   loc_7EE42
                rts
; ---------------------------------------------------------------------------

loc_7EE42:
                move.b  d0,$42(a0)
                bset    #1,$38(a0)
                cmpi.b  #8,d0
                blo.s   locret_7EE86
                move.l  #loc_7DF8C,(a0)
                clr.b   routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_7DFB8,$34(a0)
                bset    #6,status(a0)
                bsr.w   loc_7EE74

loc_7EE74:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                bne.s   locret_7EE86
                move.b  #$E,subtype(a1)

locret_7EE86:
                rts

; =============== S U B R O U T I N E =======================================

ReactToDEZMinibossSecondFormHitCountOrDefeat:
                move.b  collision_property(a0),d0
                cmp.b   $42(a0),d0
                bne.s   loc_7EE94

locret_7EE92:
                rts
; ---------------------------------------------------------------------------

loc_7EE94:
                move.b  d0,$42(a0)
                cmpi.b  #8,d0
                bhs.s   loc_7EECC
                move.w  #$800,$26(a0)
                lea     (word_7F03C).l,a1
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                move.l  #loc_7E124,(Palette_rotation_custom).w
                bset    #1,$38(a0)
                bne.s   locret_7EE92
                lea     ChildObj_7EFC4(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_7EECC:
                bset    #7,status(a0)
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #loc_7E23C,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                jmp     BossDefeated_StopTimer(pc)
; End of function ReactToDEZMinibossSecondFormHitCountOrDefeat

; =============== S U B R O U T I N E =======================================

AdvanceDEZPostBossPlayerTwelvePoseSpinAndPLC:
                move.w  $3C(a0),d0
                add.w   $1C(a0),d0
                cmpi.w  #$C00,d0
                blo.s   loc_7EF00
                subi.w  #$C00,d0

loc_7EF00:
                move.w  d0,$3C(a0)
                moveq   #0,d0
                move.b  $3C(a0),d0
                lea     (Player_1).w,a1
                move.b  byte_7EF2E(pc,d0.w),mapping_frame(a1)
                andi.b  #$FC,render_flags(a1)
                move.b  byte_7EF3A(pc,d0.w),d0
                or.b    d0,render_flags(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jmp     (Player_Load_PLC).l
; End of function AdvanceDEZPostBossPlayerTwelvePoseSpinAndPLC

; ---------------------------------------------------------------------------
byte_7EF2E:
                dc.b    $55, $59, $5A, $5B, $5A, $59, $55, $56, $57, $58, $57, $56
byte_7EF3A:
                dc.b    0,   1,   1,   0,   0,   0,   1,   1,   1,   0,   0,   0
                even
