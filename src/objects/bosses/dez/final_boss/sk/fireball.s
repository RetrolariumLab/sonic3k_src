; Owner: objects/bosses/dez/final_boss/sk
; Responsibility: Death Egg final-boss fireball state, trajectory and player interaction
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZ3_Boss_Fireball:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DEZ3_Boss_Fireball_Index(pc,d0.w),d1
                jsr     DEZ3_Boss_Fireball_Index(pc,d1.w)
                bra.w   DEZFinalChild_SetPosFromParent
; ---------------------------------------------------------------------------
DEZ3_Boss_Fireball_Index:
                dc.w    DEZFinal_InitFireballAndBlast-DEZ3_Boss_Fireball_Index
                dc.w    DEZFinal_FireballTickAirPath-DEZ3_Boss_Fireball_Index
; ---------------------------------------------------------------------------

DEZFinal_InitFireballAndBlast:
                move.b  #2,routine(a0)
                bset    #2,render_flags(a0)
                clr.b   $39(a0)
                clr.b   anim_frame(a0)
                move.w  #$B0,$42(a0)
                move.w  #-$18,$44(a0)
                moveq   #signextendB(sfx_Blast),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

DEZFinal_FireballTickAirPath:
                subq.w  #1,$2E(a0)
                bpl.w   DEZFinalAttackActors_SharedReturn
                cmpi.w  #$C7,y_pos(a0)
                bhs.s   DEZFinal_FireballBeginGroundTrail
                move.w  #1,$2E(a0)
                move.b  anim_frame(a0),d0
                move.b  d0,d1
                addq.b  #1,d0
                cmpi.b  #3,d0
                blo.s   DEZFinal_FireballStepAirAndClone
                moveq   #0,d0

; Advance by one byte per step and read the next two signed offsets, so successive pairs overlap
DEZFinal_FireballStepAirAndClone:
                move.b  d0,anim_frame(a0)
                andi.w  #3,d1
                add.w   d1,d1
                lea     DEZFinal_FireballAirPathBytes(pc,d0.w),a1
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d0,$42(a0)
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d0,$44(a0)
                moveq   #0,d2
                bra.w   DEZFireball_SpawnFlameSegment
; ---------------------------------------------------------------------------

DEZFinal_FireballBeginGroundTrail:
                move.l  #DEZFinal_FireballStepGroundTrail,(a0)
                move.w  #$CF,y_pos(a0)
                clr.b   anim_frame(a0)
                move.w  #2,$2E(a0)
                bsr.w   DEZFinalAttack_SetXFromParent
                moveq   #2,d2
                bsr.w   DEZFireball_SpawnFlameSegment
                addq.w  #4,sp
                rts
; ---------------------------------------------------------------------------
DEZFinal_FireballAirPathBytes:
                dc.b    8,   8
                dc.b    -4,   4
                dc.b    $C,  $C
                even
; ---------------------------------------------------------------------------

DEZFinal_FireballStepGroundTrail:
                subq.w  #1,$2E(a0)
                bpl.s   DEZFinalAttack_SetXFromParent
                move.w  #2,$2E(a0)
                addq.w  #8,$42(a0)
                cmpi.w  #$300,$42(a0)
                bhs.w   DEZFinal_DeleteCurrentActor
                moveq   #8,d0
                moveq   #1,d2
                bchg    #0,anim_frame(a0)
                beq.s   DEZFinal_FireballMoveYAndClone
                neg.w   d0
                moveq   #2,d2

DEZFinal_FireballMoveYAndClone:
                add.w   d0,y_pos(a0)
                bsr.w   DEZFireball_SpawnFlameSegment

; =============== S U B R O U T I N E =======================================

DEZFinalAttack_SetXFromParent:
                movea.w parent3(a0),a1
                move.w  $42(a0),d0
                move.w  x_pos(a1),d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                rts
; End of function DEZFinalAttack_SetXFromParent
