; Owner: objects/bosses/soz/end_boss/sk
; Responsibility: Sandopolis end-boss child motion, collision, palette and attack helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

ReloadSOZEndBossMotionProfileAtTurnBounds:
                tst.b   $3C(a0)
                bpl.s   locret_7805E
                tst.w   x_vel(a0)
                bpl.s   loc_78054
                cmpi.w  #$4E80,x_pos(a0)
                bhs.s   locret_7805E
                lea     word_78060(pc),a1
                bra.w   loc_7773C
; ---------------------------------------------------------------------------

loc_78054:
                cmpi.w  #$5210,x_pos(a0)
                bhs.w   loc_7772C

locret_7805E:
                rts
; End of function ReloadSOZEndBossMotionProfileAtTurnBounds

; ---------------------------------------------------------------------------
word_78060:
                dc.w    $400,  $800, -$400,   $1F,    $F,     7

; =============== S U B R O U T I N E =======================================

TickSOZEndBossChargeAttackSpawnTimer:
                subq.w  #1,(_unkFA82).w
                bpl.w   locret_77AF6
                move.w  #$200,(_unkFA82).w
                moveq   #signextendB(sfx_Charging),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_7832C(pc),a2
                jmp     (CreateChild1_Normal).l
; End of function TickSOZEndBossChargeAttackSpawnTimer

; =============== S U B R O U T I N E =======================================

UpdateSOZEndBossSineBobFromAngleStep:
                move.b  angle(a0),d0
                sub.b   $3E(a0),d0
                move.b  d0,angle(a0)
                jsr     (GetSineCosine).l
                asr.w   #4,d0
                move.w  $3A(a0),d1
                add.w   d0,d1
                move.w  d1,y_pos(a0)
                rts
; End of function UpdateSOZEndBossSineBobFromAngleStep

; =============== S U B R O U T I N E =======================================

ProcessSOZEndBossUpperBodyContactsForBothPlayers:
                swap    d6
                moveq   #0,d0
                lea     (Player_1).w,a1
                bsr.w   OpenSOZEndBossEyeOrHurtUpperBodyContactPlayer
                moveq   #1,d0
                lea     (Player_2).w,a1
; End of function ProcessSOZEndBossUpperBodyContactsForBothPlayers

; =============== S U B R O U T I N E =======================================

OpenSOZEndBossEyeOrHurtUpperBodyContactPlayer:
                btst    d0,d6
                beq.s   locret_78118
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   loc_7811A
                cmpi.b  #2,anim(a1)
                beq.s   loc_780E4
                cmpi.b  #2,character_id(a1)
                bne.s   loc_780E4
                cmpi.b  #1,double_jump_flag(a1)
                bne.s   locret_78118

loc_780E4:
                move.w  y_pos(a1),(Events_bg+$0A).w
                move.l  #loc_77D0C,(a0)
                move.w  #-$400,x_vel(a1)
                move.w  #-$300,y_vel(a1)
                movea.w parent3(a0),a2
                move.b  routine(a2),$42(a2)
                move.b  #$C,routine(a2)
                move.b  #$F,collision_flags(a2)
                jsr     (Displace_PlayerOffObject).l

locret_78118:
                rts
; ---------------------------------------------------------------------------

loc_7811A:
                jmp     (HurtPlayerFromSolidHazard).l
; End of function OpenSOZEndBossEyeOrHurtUpperBodyContactPlayer

; =============== S U B R O U T I N E =======================================

ProcessSOZEndBossLowerBodyContactsForBothPlayers:
                swap    d6
                moveq   #0,d0
                moveq   #p1_standing_bit,d1
                lea     (Player_1).w,a1
                bsr.w   DetachOrHurtSOZEndBossLowerBodyContactPlayer
                moveq   #1,d0
                moveq   #p2_standing_bit,d1
                lea     (Player_2).w,a1
; End of function ProcessSOZEndBossLowerBodyContactsForBothPlayers

; =============== S U B R O U T I N E =======================================

DetachOrHurtSOZEndBossLowerBodyContactPlayer:
                btst    d0,d6
                bne.s   loc_78140
                bclr    d1,status(a0)
                beq.s   locret_78158

loc_78140:
                bclr    #Status_OnObj,status(a1)
                tst.b   invulnerability_timer(a1)
                bne.s   locret_78158
                andi.b  #$9F,status(a0)
                jsr     (HurtPlayerFromSolidHazard).l

locret_78158:
                rts
; End of function DetachOrHurtSOZEndBossLowerBodyContactPlayer

; =============== S U B R O U T I N E =======================================

ProcessSOZEndBossArmContactsWhileRootAlive:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   locret_78198
                swap    d6
                moveq   #0,d0
                lea     (Player_1).w,a1
                bsr.w   HurtSOZEndBossArmContactPlayerOnLeftSide
                moveq   #1,d0
                lea     (Player_2).w,a1
; End of function ProcessSOZEndBossArmContactsWhileRootAlive

; =============== S U B R O U T I N E =======================================

HurtSOZEndBossArmContactPlayerOnLeftSide:
                btst    d0,d6
                beq.s   locret_78198
                tst.b   $34(a1)
                bne.s   locret_78198
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                bcs.s   locret_78198
                andi.b  #$9F,status(a0)
                jsr     (HurtPlayerFromSolidHazard).l

locret_78198:
                rts
; End of function HurtSOZEndBossArmContactPlayerOnLeftSide

; =============== S U B R O U T I N E =======================================

SeedSOZEndBossChargeParticleOffsetAndStagger:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     byte_781BC(pc,d0.w),a1
                move.b  (a1)+,$3A(a0)
                move.b  (a1)+,$3C(a0)
                move.w  byte_781BC(pc,d0.w),child_dx(a0)  ; and child_dy
                addq.w  #2,d0
                lsl.w   #2,d0
                move.w  d0,$2E(a0)
                rts
; End of function SeedSOZEndBossChargeParticleOffsetAndStagger

; ---------------------------------------------------------------------------
byte_781BC:
                dc.b    -$16,   2
                dc.b    -$10,  -8
                dc.b    -$14,   9
                dc.b    -$1B,  -4
                dc.b    -$D,   8
                dc.b    -$16,  -5
                dc.b    -$1F,   4
                dc.b    -$12,  $D
                dc.b    -$18,  -8
                dc.b    -$14,  -1
                dc.b    -$20,  -2
                dc.b    -$1C,  $C
                dc.b    -$1A,  -1
                dc.b    -$24,   9
                dc.b    -$1F, -$A
                dc.b    -$1A,   4
                dc.b    -$14,   2
                dc.b    -$16,   6
                dc.b    -$18, -$C
                dc.b    -$26,  $C
                even
; ---------------------------------------------------------------------------

loc_781E4:
                tst.b   collision_flags(a0)
                bne.s   locret_7822E
                tst.b   collision_property(a0)
                beq.s   loc_78230
                tst.b   $20(a0)
                bne.s   loc_7820A
                bset    #6,status(a0)
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_7820A:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_78218
                addi.w  #2*5,d0

loc_78218:
                bsr.w   CopySOZEndBossFirstThreeOfFivePaletteColors
                subq.b  #1,$20(a0)
                bne.s   locret_7822E
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_7822E:
                rts
; ---------------------------------------------------------------------------

loc_78230:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #loc_7780A,$34(a0)
                move.w  #$55,(Events_fg_5).w
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                move.w  (Camera_X_pos).w,d0
                move.w  d0,(Camera_min_X_pos).w
                jmp     (BossDefeated_StopTimer).l

; =============== S U B R O U T I N E =======================================

CopySOZEndBossFirstThreeOfFivePaletteColors:
                lea     word_7826C(pc),a1
                lea     word_78276(pc,d0.w),a2
; Bug: this should go to CopyWordData_5
                jmp     (CopyWordData_3).l
; End of function CopySOZEndBossFirstThreeOfFivePaletteColors

; ---------------------------------------------------------------------------
word_7826C:
                dc.w    Normal_palette_line_4+$0C, Normal_palette_line_4+$0E, Normal_palette_line_4+$10
                dc.w    Normal_palette_line_4+$12, Normal_palette_line_4+$14
word_78276:
                dc.w    $6E,  $24C,   $28,     4,     2
                dc.w    $AAA,  $CCC,  $CCC,  $EEE,  $EEE
