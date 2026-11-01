; Owner: objects/bosses/fbz/end_boss/sk
; Responsibility: Flying Battery end-boss motion, collision, flash, angle and private geometry helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

PlayFBZEndBossHalfTurnSoundBeforeWaitEnds:
                cmpi.w  #4,$2E(a0)
                blo.s   locret_70C8C
                move.b  $3C(a0),d0
                andi.b  #$7F,d0
                bne.s   locret_70C8C
                moveq   #signextendB(sfx_SpikeBalls),d0
                jsr     (Play_SFX).l

locret_70C8C:
                rts
; End of function PlayFBZEndBossHalfTurnSoundBeforeWaitEnds

; ---------------------------------------------------------------------------

loc_70C8E:
                movea.w $44(a0),a1
                movea.w parent3(a0),a2
                move.w  x_pos(a1),d0
                move.b  child_dx(a0),d1
                ext.w   d1
                add.w   d0,d1
                move.w  x_pos(a2),d2
                sub.w   d2,d1
                moveq   #$10,d3
                moveq   #0,d4
                move.b  subtype(a0),d4
                bsr.w   PositionFBZEndBossConnectorAxisByQuarter
                move.w  y_pos(a1),d0
                move.b  child_dy(a0),d1
                ext.w   d1
                add.w   d0,d1
                move.w  y_pos(a2),d2
                sub.w   d2,d1
                moveq   #$14,d3
                bsr.w   PositionFBZEndBossConnectorAxisByQuarter
                tst.b   $3C(a2)
                beq.s   locret_70CDA
                bmi.s   locret_70CDA
                move.w  word_70CDC(pc,d4.w),priority(a0)

locret_70CDA:
                rts
; ---------------------------------------------------------------------------
word_70CDC:
                dc.w    $180
                dc.w    $100
                dc.w    $80
                dc.w    0

; =============== S U B R O U T I N E =======================================

PositionFBZEndBossConnectorAxisByQuarter:
                move.w  off_70CEC(pc,d4.w),d5
                jmp     off_70CEC(pc,d5.w)
; End of function PositionFBZEndBossConnectorAxisByQuarter

; ---------------------------------------------------------------------------
off_70CEC:
                dc.w    loc_70CF4-off_70CEC
                dc.w    loc_70CFA-off_70CEC
                dc.w    loc_70D00-off_70CEC
                dc.w    loc_70D08-off_70CEC
; ---------------------------------------------------------------------------

loc_70CF4:
                asr.w   #2,d1
                bra.w   loc_70D08
; ---------------------------------------------------------------------------

loc_70CFA:
                asr.w   #1,d1
                bra.w   loc_70D08
; ---------------------------------------------------------------------------

loc_70D00:
                asr.w   #1,d1
                move.w  d1,d0
                asr.w   #1,d1
                add.w   d0,d1

loc_70D08:
                add.w   d1,d2
                move.w  d2,(a0,d3.w)
                rts

; =============== S U B R O U T I N E =======================================

InitializeFBZEndBossFlameColumnPart:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_70D40(pc,d0.w),$2E(a0)
                move.w  byte_70D52(pc,d0.w),child_dx(a0)  ; and child_dy
                add.w   d0,d0
                move.l  off_70D64(pc,d0.w),$30(a0)
                movea.l off_70D88(pc,d0.w),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #4,shield_reaction(a0)
                jmp     (Refresh_ChildPosition).l
; End of function InitializeFBZEndBossFlameColumnPart

; ---------------------------------------------------------------------------
word_70D40:
                dc.w    $50
                dc.w    $4D
                dc.w    $4A
                dc.w    $47
                dc.w    $44
                dc.w    $41
                dc.w    $3E
                dc.w    $3B
                dc.w    0
byte_70D52:
                dc.b    0,-$68
                dc.b    8,-$5C
                dc.b    -8,-$5C
                dc.b    0,-$4C
                dc.b    0,-$3C
                dc.b    0,-$2C
                dc.b    0,-$1C
                dc.b    0, -$C
                dc.b    0,-$10
off_70D64:
                dc.l    byte_70F70
                dc.l    byte_70F70
                dc.l    byte_70F70
                dc.l    byte_70F61
                dc.l    byte_70F61
                dc.l    byte_70F61
                dc.l    byte_70F61
                dc.l    byte_70F61
                dc.l    byte_70F3E
off_70D88:
                dc.l    ObjDat3_70EC8
                dc.l    ObjDat3_70EC8
                dc.l    ObjDat3_70EC8
                dc.l    ObjDat3_70EBC
                dc.l    ObjDat3_70EBC
                dc.l    ObjDat3_70EBC
                dc.l    ObjDat3_70EBC
                dc.l    ObjDat3_70EBC
                dc.l    ObjDat3_70EB0

; =============== S U B R O U T I N E =======================================

CenterFBZEndBossXBetweenSupports:
                movea.w $44(a0),a1
                movea.w parent3(a0),a2
                move.w  x_pos(a1),d0
                move.w  x_pos(a2),d1
                sub.w   d0,d1
                asr.w   #1,d1
                add.w   d1,d0
                move.w  d0,x_pos(a0)
                rts
; End of function CenterFBZEndBossXBetweenSupports

; =============== S U B R O U T I N E =======================================

SetFBZEndBossBodyDepthFromPhase:
                tst.b   $3C(a0)
                beq.s   loc_70DEC
                bmi.s   loc_70DDE
                bset    #7,art_tile(a0)
                move.w  #0,priority(a0)
                rts
; ---------------------------------------------------------------------------

loc_70DDE:
                bclr    #7,art_tile(a0)
                move.w  #$300,priority(a0)
                rts
; ---------------------------------------------------------------------------

loc_70DEC:
                bset    #7,art_tile(a0)
                move.w  #$300,priority(a0)
                rts
; End of function SetFBZEndBossBodyDepthFromPhase

; =============== S U B R O U T I N E =======================================

SetFBZEndBossHingeDepthFromPhase:
                tst.b   $3C(a0)
                beq.s   loc_70DEC
                bmi.s   loc_70DDE
                bset    #7,art_tile(a0)
                move.w  #$200,priority(a0)
                rts
; End of function SetFBZEndBossHingeDepthFromPhase

; =============== S U B R O U T I N E =======================================

HandleFBZEndBossFourColorHitOrDefeat:
                tst.l   (a0)
                beq.s   locret_70E66
                tst.b   collision_flags(a0)
                bne.s   locret_70E66
                tst.b   collision_property(a0)
                beq.s   loc_70E68
                tst.b   $20(a0)
                bne.s   loc_70E34
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_70E34:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_70E46
                addq.w  #2*4,d0

loc_70E46:
                lea     word_70E74(pc),a1
                lea     word_70E7C(pc,d0.w),a2
                jsr     (CopyWordData_4).l
                subq.b  #1,$20(a0)
                bne.s   locret_70E66
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_70E66:
                rts
; ---------------------------------------------------------------------------

loc_70E68:
                move.l  #loc_707F6,(a0)
                jmp     (BossDefeated_StopTimer).l
; End of function HandleFBZEndBossFourColorHitOrDefeat

; ---------------------------------------------------------------------------
word_70E74:
                dc.w    Normal_palette_line_2+$06, Normal_palette_line_2+$08, Normal_palette_line_2+$12, Normal_palette_line_2+$1C
word_70E7C:
                dc.w    $2A,   $26,   $20,  $644
                dc.w    $888,  $AAA,  $EEE,  $AAA
