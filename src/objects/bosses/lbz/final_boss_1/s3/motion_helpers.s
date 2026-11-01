; Owner: objects/bosses/lbz/final_boss_1/s3
; Responsibility: Launch Base first final boss motion, collision, hit response and child positioning helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

AdvanceLBZFinalBoss1CannonTurnCycle:
                moveq   #0,d0
                move.b  $39(a0),d0
                subq.w  #1,$2E(a0)
                bmi.s   loc_4FFF0
                add.w   d0,d0
                bra.w   loc_50064
; ---------------------------------------------------------------------------

loc_4FFF0:
                movea.w $44(a0),a1
                btst    #0,render_flags(a1)
                sne     d2
                beq.s   loc_50008
                subq.b  #1,d0
                bpl.s   loc_50012
                moveq   #$B,d0
                bra.w   loc_50012
; ---------------------------------------------------------------------------

loc_50008:
                addq.b  #1,d0
                cmpi.b  #$C,d0
                blo.s   loc_50012
                moveq   #0,d0

loc_50012:
                move.b  d0,$39(a0)
                lea     byte_5008A(pc),a2
                move.b  (a2,d0.w),d1
                bset    #0,render_flags(a0)
                bclr    #7,d1
                bne.s   loc_50032
                bclr    #0,render_flags(a0)
                not.b   d2

loc_50032:
                bclr    #3,$38(a1)
                cmpi.b  #4,d1
                bne.s   loc_50058
                bset    #3,$38(a1)
                tst.b   d2
                beq.s   loc_50058
                movem.l d0-d1,-(sp)
                lea     ChildObjDat_5038A(pc),a2
                jsr     CreateChild1_Normal(pc)
                movem.l (sp)+,d0-d1

loc_50058:
                move.b  d1,mapping_frame(a0)
                add.w   d0,d0
                move.w  word_50096(pc,d0.w),$2E(a0)

loc_50064:
                lea     byte_500AE(pc,d0.w),a1
                movea.w parent3(a0),a2
                move.b  (a1)+,d1
                ext.w   d1
                move.w  x_pos(a2),d2
                add.w   d1,d2
                move.w  d2,x_pos(a0)
                move.b  (a1)+,d1
                ext.w   d1
                move.w  y_pos(a2),d2
                add.w   d1,d2
                move.w  d2,y_pos(a0)
                rts
; End of function AdvanceLBZFinalBoss1CannonTurnCycle

; ---------------------------------------------------------------------------
byte_5008A:
                dc.b    3|$80
                dc.b    4|$80
                dc.b    5|$80
                dc.b    6|$80
                dc.b    7|$80
                dc.b    8|$80
                dc.b    7
                dc.b    6
                dc.b    5
                dc.b    4
                dc.b    3
                dc.b    $2D
                even
word_50096:
                dc.w    7
                dc.w    $5F
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    7
                dc.w    $5F
                dc.w    7
                dc.w    $27
byte_500AE:
                dc.b    $27,  -8
                dc.b    $24,  -8
                dc.b    $24,  -8
                dc.b    $14,  -8
                dc.b    $C,  -8
                dc.b    0,  -8
                dc.b    -$C,  -8
                dc.b    -$14,  -8
                dc.b    -$24,  -8
                dc.b    -$24,  -8
                dc.b    -$27,  -8

; =============== S U B R O U T I N E =======================================

RandomizeLBZFinalBoss1LaserTrailOffset:
                jsr     (Random_Number).l
                swap    d0
                andi.b  #7,d0
                addi.b  #$18,d0
                move.b  d0,child_dx(a1)
                rts
; End of function RandomizeLBZFinalBoss1LaserTrailOffset

; =============== S U B R O U T I N E =======================================

HandleLBZFinalBoss1HitSectionDropOrDefeat:
                tst.b   collision_flags(a0)
                bne.w   locret_50192
                tst.b   collision_property(a0)
                beq.w   loc_50194
                tst.b   $20(a0)
                bne.s   loc_50162
                move.b  routine(a0),$3A(a0)
                move.b  #6,routine(a0)
                move.b  #$20,$20(a0)
                bset    #6,status(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                move.w  y_vel(a0),d0
                asl.w   #1,d0
                cmpi.w  #-$800,d0
                blt.s   loc_50126
                cmpi.w  #$800,d0
                bgt.s   loc_50126
                move.w  d0,y_vel(a0)

loc_50126:
                cmpi.b  #5,collision_property(a0)
                beq.s   loc_5013C
                cmpi.b  #1,collision_property(a0)
                bne.s   loc_50162
                bset    #3,$38(a0)

loc_5013C:
                move.w  $3C(a0),d0
                bset    d0,$38(a0)
                addq.w  #1,$3C(a0)
                move.b  #8,routine(a0)
                move.b  #$F,$40(a0)
                bset    #5,status(a0)
                lea     ChildObjDat_503C0(pc),a2
                jsr     CreateChild1_Normal(pc)

loc_50162:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_50170
                addi.w  #2*2,d0

loc_50170:
                bsr.w   CopyLBZFinalBoss1TwoColorPalette
                subq.b  #1,$20(a0)
                bne.s   locret_50192
                move.b  $3A(a0),routine(a0)
                move.w  #$EEE,(Normal_palette_line_2+2).w
                move.b  $25(a0),collision_flags(a0)
                bclr    #6,status(a0)

locret_50192:
                rts
; ---------------------------------------------------------------------------

loc_50194:
                jsr     BossDefeated(pc)
                move.b  #5,mapping_frame(a0)
                bset    #6,status(a0)
                bset    #7,status(a0)
                clr.b   collision_flags(a0)
                move.w  $3C(a0),d0
                bset    d0,$38(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                move.b  #4,subtype(a1)
                tst.b   (_unkFA80+1).w
                bne.s   loc_501D4
                move.l  #loc_4FAEE,(a0)
                rts
; ---------------------------------------------------------------------------

loc_501D4:
                move.l  #loc_4FB4C,(a0)
                lea     ChildObjDat_5031E(pc),a2
                jmp     CreateChild1_Normal(pc)
; End of function HandleLBZFinalBoss1HitSectionDropOrDefeat

; =============== S U B R O U T I N E =======================================

CopyLBZFinalBoss1TwoColorPalette:
                lea     word_501EE(pc),a1
                lea     word_501F2(pc,d0.w),a2
                jmp     CopyWordData_2(pc)
; End of function CopyLBZFinalBoss1TwoColorPalette

; ---------------------------------------------------------------------------
word_501EE:
                dc.w    Normal_palette_line_2+$08, Normal_palette_line_2+$1C
word_501F2:
                dc.w    $26,   $20
                dc.w    $EEE,  $EEE

; =============== S U B R O U T I N E =======================================

BreakOrSuspendLBZFinalBoss1BodySection:
                movea.w parent3(a0),a1
                move.w  $3C(a0),d0
                btst    d0,$38(a1)
                beq.s   loc_5024A
                move.l  #byte_5029A,$3E(a0)
                bset    #7,status(a0)
                lea     (ChildObjDat_50342).l,a2
                cmpi.w  #2,d0
                bne.s   loc_50230
                move.l  #byte_5029E,$3E(a0)
                lea     (ChildObjDat_5035C).l,a2

loc_50230:
                move.w  #$10,$2E(a0)
                move.l  #loc_4FC8A,(a0)
                jsr     CreateChild1_Normal(pc)
                lea     (Child6_CreateBossExplosion).l,a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_5024A:
                btst    #6,status(a1)
                beq.s   locret_50258
                move.l  #loc_4FC5A,(a0)

locret_50258:
                rts
; End of function BreakOrSuspendLBZFinalBoss1BodySection

; =============== S U B R O U T I N E =======================================

SeedLBZFinalBoss1SectionDebrisFrameAndVelocity:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d1
                movea.w parent3(a0),a1
                movea.l $3E(a1),a1
                move.b  (a1,d1.w),mapping_frame(a0)
                add.w   d0,d0
                lea     word_50282(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,y_vel(a0)
                rts
; End of function SeedLBZFinalBoss1SectionDebrisFrameAndVelocity

; ---------------------------------------------------------------------------
word_50282:
                dc.w    -$100, -$200
                dc.w    $100, -$200
                dc.w    -$200, -$100
                dc.w    $200, -$100
                dc.w    -$300, -$300
                dc.w    $300, -$300
byte_5029A:
                dc.b    $23
                dc.b    $25
                dc.b    $24
                dc.b    $26
byte_5029E:
                dc.b    $27
                dc.b    $29
                dc.b    $28
                dc.b    $2A
                dc.b    $2B
                dc.b    $2C
                even
