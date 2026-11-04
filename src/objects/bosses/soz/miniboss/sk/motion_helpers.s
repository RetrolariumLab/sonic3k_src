; Owner: objects/bosses/soz/miniboss/sk
; Responsibility: Sandopolis miniboss child movement, collision, palette and parent-state helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; At world X $4200, switch tile priority and sprite queue priority
SOZMini_SetLayerFromWorldX:
                bset    #7,art_tile(a0)
                move.w  $3C(a0),d0
                cmpi.w  #$4200,x_pos(a0)
                bhs.s   SOZMini_StoreLayerPriority
                move.w  #$80,d0
                bclr    #7,art_tile(a0)

SOZMini_StoreLayerPriority:
                move.w  d0,priority(a0)
                rts
; End of function SOZMini_SetLayerFromWorldX

; =============== S U B R O U T I N E =======================================

SOZMiniPart_SyncFromRootPose:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  SOZMini_PoseTableOffsets(pc,d0.w),d1
                lea     SOZMini_PoseTableOffsets(pc,d1.w),a1
                movea.w parent3(a0),a2
                moveq   #0,d1
                move.b  $39(a2),d1
                andi.b  #$3F,d1
                lsl.w   #2,d1
                adda.w  d1,a1
                move.b  (a1)+,d2
                ext.w   d2
                move.b  (a1)+,d3
                ext.w   d3
                move.b  (a1)+,mapping_frame(a0)
                bclr    #0,render_flags(a0)
                btst    #0,render_flags(a2)
                beq.s   SOZMini_PoseApplyRecordFlip
                bset    #0,render_flags(a0)
                neg.w   d2

SOZMini_PoseApplyRecordFlip:
                tst.b   (a1)
                beq.s   SOZMini_PoseApplyRootOffsets
                bchg    #0,render_flags(a0)

SOZMini_PoseApplyRootOffsets:
                move.w  x_pos(a2),d1
                add.w   d2,d1
                move.w  d1,x_pos(a0)
                move.w  y_pos(a2),d1
                add.w   d3,d1
                move.w  d1,y_pos(a0)
                rts
; End of function SOZMiniPart_SyncFromRootPose

; ---------------------------------------------------------------------------
SOZMini_PoseTableOffsets:
                dc.w    SOZMinibossPart00_TenPoseRecords-SOZMini_PoseTableOffsets
                dc.w    SOZMinibossPart02_TenPoseRecords-SOZMini_PoseTableOffsets
                dc.w    SOZMinibossPart04_TenPoseRecords-SOZMini_PoseTableOffsets
                dc.w    SOZMinibossPart06_TenPoseRecords-SOZMini_PoseTableOffsets
                dc.w    SOZMinibossPart08_TenPoseRecords-SOZMini_PoseTableOffsets
                dc.w    SOZMinibossPart10_TenPoseRecords-SOZMini_PoseTableOffsets
                dc.w    SOZMinibossPart12_TenPoseRecords-SOZMini_PoseTableOffsets
                dc.w    SOZMinibossPart14_TenPoseRecords-SOZMini_PoseTableOffsets
SOZMinibossPart00_TenPoseRecords:
                dc.b    0,  -8, $15,   0
                dc.b    0,  -8, $15,   0
                dc.b    0,  -8, $15,   0
                dc.b    0,  -8, $15,   0
                dc.b    0,  -8, $15,   0
                dc.b    -1, -$9, $15,   0
                dc.b    -2, -$A, $15,   0
                dc.b    -3, -$B, $15,   0
                dc.b    -4, -$C, $15,   0
                dc.b    0,  -8, $16,   0
SOZMinibossPart02_TenPoseRecords:
                dc.b    -$C, $14,   6,   0
                dc.b    -$C, $14,   6,   0
                dc.b    -$C, $14,   6,   0
                dc.b    -$C, $14,   6,   0
                dc.b    -$B, $14,   6,   0
                dc.b    -$14,  $D,   7,   0
                dc.b    -$20,   0,   8,   0
                dc.b    -$1C, -$A,   9,   0
                dc.b    -$20,-$14,  $A,   0
                dc.b    -8, $14,  $B,   0
SOZMinibossPart04_TenPoseRecords:
                dc.b    0,   4, $17,   0
                dc.b    0,   4, $17,   0
                dc.b    0,   4, $17,   0
                dc.b    0,   4, $17,   0
                dc.b    1,   4, $17,   0
                dc.b    -4,   2, $17,   0
                dc.b    -8,   0, $17,   0
                dc.b    -$C,  -2, $17,   0
                dc.b    -$10,  -8, $17,   0
                dc.b    0,   4, $17,   0
SOZMinibossPart06_TenPoseRecords:
                dc.b    0, $28,  $C,   1
                dc.b    -1, $28,  $C,   1
                dc.b    -8, $20,  $C,   1
                dc.b    -$D, $1A,  $C,   1
                dc.b    -$E, $19,  $C,   1
                dc.b    -$D, $1A,  $C,   1
                dc.b    -8, $20,  $C,   1
                dc.b    -1, $28,  $C,   1
                dc.b    0, $28,  $C,   1
                dc.b    0, $28,  $F,   1
SOZMinibossPart08_TenPoseRecords:
                dc.b    0, $14,  $C,   0
                dc.b    2, $14,  $C,   0
                dc.b    -4, $10,  $D,   0
                dc.b    -2,  $E,  $E,   0
                dc.b    -2,  $E,  $E,   0
                dc.b    -2,  $E,  $E,   0
                dc.b    -4, $10,  $D,   0
                dc.b    2, $14,  $C,   0
                dc.b    0, $14,  $C,   0
                dc.b    0, $14,  $F,   0
SOZMinibossPart10_TenPoseRecords:
                dc.b    -8, $1C, $17,   0
                dc.b    -6, $1C, $17,   0
                dc.b    -$A, $14, $17,   0
                dc.b    -$E,  $E, $17,   0
                dc.b    -$E,  $E, $17,   0
                dc.b    -$E,  $E, $17,   0
                dc.b    -$A, $14, $17,   0
                dc.b    -6, $1C, $17,   0
                dc.b    -8, $1C, $17,   0
                dc.b    -4, $1C, $17,   0
SOZMinibossPart12_TenPoseRecords:
                dc.b    -4, $34, $10,   0
                dc.b    -5, $34, $10,   0
                dc.b    -$C, $2C, $10,   0
                dc.b    -$11, $26, $10,   0
                dc.b    -$12, $25, $10,   0
                dc.b    -$11, $26, $10,   0
                dc.b    -$C, $2C, $10,   0
                dc.b    -5, $34, $10,   0
                dc.b    -4, $34, $10,   0
                dc.b    -4, $34, $11,   0
SOZMinibossPart14_TenPoseRecords:
                dc.b    0, $14,   3,   0
                dc.b    2, $14,   3,   0
                dc.b    2, $14,   3,   0
                dc.b    2, $14,   3,   0
                dc.b    2, $14,   3,   0
                dc.b    2, $14,   3,   0
                dc.b    2, $14,   3,   0
                dc.b    2, $14,   3,   0
                dc.b    0, $14,   3,   0
                dc.b    0, $14,   3,   0
                even

; =============== S U B R O U T I N E =======================================

; Read signed X and Y offsets at the animation cursor and mirror X with facing
SOZMini_ApplyAnimStepOffset:
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                adda.w  d0,a1
                move.b  (a1)+,d0
                ext.w   d0
                btst    #0,render_flags(a0)
                beq.s   SOZMini_ApplyPoseCursorDisplacement
                neg.w   d0

SOZMini_ApplyPoseCursorDisplacement:
                add.w   d0,x_pos(a0)
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d0,y_pos(a0)
                rts
; End of function SOZMini_ApplyAnimStepOffset

; ---------------------------------------------------------------------------
SOZMini_PoseCursorDisplacements:
                dc.b    0,   0
                dc.b    1,   0
                dc.b    7,   8
                dc.b    5,   6
                dc.b    1,   1
                dc.b    -1,  -1
                dc.b    -5,  -6
                dc.b    -7,  -8
                dc.b    -1,   0
                dc.b    0,   0
                even

; =============== S U B R O U T I N E =======================================

; An armed hit launches the boss away from the hitter. At world Y $A10, begin the scripted sinking defeat
SOZMini_HandleKnockbackOrSink:
                cmpi.w  #$A10,y_pos(a0)
                bhs.s   SOZMini_BeginDefeatSink
                btst    #6,status(a0)
                beq.w   SOZMini_HitUpdateReturn
                bclr    #7,$38(a0)
                beq.w   SOZMini_HitUpdateReturn
                move.b  #$C,routine(a0)
                move.l  #SOZMini_ResetAfterKnockbackLanding,$34(a0)
                move.b  #8,y_radius(a0)
                moveq   #0,d0
                move.b  d0,mapping_frame(a0)
                move.b  d0,anim_frame(a0)
                move.b  d0,anim_frame_timer(a0)
                move.b  d0,$3A(a0)
                move.b  d0,$39(a0)
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                movea.w $44(a0),a1
                move.w  #$200,d0
                move.w  x_pos(a1),d1
                cmp.w   x_pos(a0),d1
                blo.s   SOZMini_StoreKnockbackVelocity
                neg.w   d0

SOZMini_StoreKnockbackVelocity:
                move.w  d0,x_vel(a0)
                move.w  #-$200,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SOZMini_BeginDefeatSink:
                move.l  #SOZMini_SinkAndDraw,(a0)
                clr.w   x_vel(a0)
                move.w  #$40,y_vel(a0)
                move.w  #$BF,$2E(a0)
                clr.b   (Update_HUD_timer).w
                move.w  (Camera_min_X_pos).w,(Camera_stored_min_X_pos).w
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                move.w  (Camera_X_pos).w,(Camera_max_X_pos).w
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   SOZMini_HitUpdateReturn
                move.b  #4,subtype(a1)

SOZMini_HitUpdateReturn:
                rts
; End of function SOZMini_HandleKnockbackOrSink
