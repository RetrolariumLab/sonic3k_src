; Owner: objects/bosses/lrz/miniboss/sk
; Responsibility: Lava Reef miniboss child movement, collision, palette and parent-state helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

CopyLRZMinibossPaletteLinesThreeAndFour:
                lea     (Normal_palette_line_3).w,a2
                moveq   #bytesToLcnt($40),d0

loc_78B3E:
                move.l  (a1)+,(a2)+
                dbf     d0,loc_78B3E
                rts
; End of function CopyLRZMinibossPaletteLinesThreeAndFour

; =============== S U B R O U T I N E =======================================

ScheduleLRZMinibossArmSegmentDestructionBySide:
                movea.w $44(a0),a1
                moveq   #6,d0
                btst    #0,render_flags(a0)
                beq.s   loc_78B56
                moveq   #7,d0

loc_78B56:
                btst    d0,$38(a1)
                beq.w   locret_78536
                move.l  #Wait_Draw,(a0)
                move.w  #$80,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  #$2C,d1
                sub.w   d0,d1
                move.w  d1,$2E(a0)
                move.l  #loc_78B86,$34(a0)
                rts
; End of function ScheduleLRZMinibossArmSegmentDestructionBySide

; ---------------------------------------------------------------------------

loc_78B86:
                move.w  #$F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   locret_78BA8
                move.b  #6,subtype(a1)

locret_78BA8:
                rts

; =============== S U B R O U T I N E =======================================

SeedLRZMinibossArmProjectileVelocity:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #2,d0
                move.l  word_78BCA-4(pc,d0.w),x_vel(a0)  ; and y_vel
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                beq.s   locret_78BC8
                neg.w   x_vel(a0)

locret_78BC8:
                rts
; End of function SeedLRZMinibossArmProjectileVelocity

; ---------------------------------------------------------------------------
word_78BCA:
                dc.w    $200,  $300
                dc.w    $200,  $200
                dc.w    $200,  $100

; =============== S U B R O U T I N E =======================================

SuspendLRZArmInitializationUntilCapturedContinuation:
                move.l  (sp)+,$34(a0)
                move.l  #Wait_Draw,(a0)
                move.b  #$80,$3C(a0)
                move.b  #1,$40(a0)
                rts
; End of function SuspendLRZArmInitializationUntilCapturedContinuation

; =============== S U B R O U T I N E =======================================

PlaceLRZMinibossArmBaseAtCameraSide:
                move.w  #$20,d0
                btst    #0,render_flags(a0)
                beq.s   loc_78BFE
                move.w  #$120,d0

loc_78BFE:
                add.w   (Camera_X_pos).w,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$1B8,d0
                move.w  d0,y_pos(a0)
                rts
; End of function PlaceLRZMinibossArmBaseAtCameraSide

; =============== S U B R O U T I N E =======================================

HandleLRZMinibossRootHitOrDefeatWithMisoffsetFlash:
                tst.b   collision_flags(a0)
                bne.s   locret_78C5E
                move.b  collision_property(a0),d0
                beq.s   loc_78C60
                tst.b   $20(a0)
                bne.s   loc_78C3A
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

loc_78C3A:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_78C48
; Bug: this should be 2*6
                addi.w  #2*2,d0

loc_78C48:
                bsr.w   CopyLRZMinibossSixColorPaletteAtByteOffset
                subq.b  #1,$20(a0)
                bne.s   locret_78C5E
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_78C5E:
                rts
; ---------------------------------------------------------------------------

loc_78C60:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.w  #$80,priority(a0)
                bset    #6,$38(a0)
                bset    #7,$38(a0)
                move.l  #loc_787E0,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                jsr     (Displace_PlayerOffObject).l
                jmp     (BossDefeated_StopTimer).l
; End of function HandleLRZMinibossRootHitOrDefeatWithMisoffsetFlash

; =============== S U B R O U T I N E =======================================

CopyLRZMinibossSixColorPaletteAtByteOffset:
                lea     word_78CA6(pc),a1
                lea     word_78CB2(pc,d0.w),a2
                jmp     (CopyWordData_6).l
; End of function CopyLRZMinibossSixColorPaletteAtByteOffset

; ---------------------------------------------------------------------------
word_78CA6:
                dc.w    Normal_palette_line_2+$06, Normal_palette_line_2+$08, Normal_palette_line_2+$10
                dc.w    Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
word_78CB2:
                dc.w    $2A,     6,     2,  $644,  $422,     0
                dc.w    $888,  $AAA,  $CCC,  $AAA,  $CCC,  $EEE

; =============== S U B R O U T I N E =======================================

ContinueLRZMinibossRootFlashWhileRetracting:
                tst.b   collision_property(a0)
                beq.s   loc_78C60
                tst.b   $20(a0)
                beq.s   locret_78CF2
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_78CE4
; Bug: this should be 2*6
                addi.w  #2*2,d0

loc_78CE4:
                bsr.s   CopyLRZMinibossSixColorPaletteAtByteOffset
                subq.b  #1,$20(a0)
                bne.s   locret_78CF2
                bclr    #6,status(a0)

locret_78CF2:
                rts
; End of function ContinueLRZMinibossRootFlashWhileRetracting

; =============== S U B R O U T I N E =======================================

HandleLRZMinibossTerminalArmHitAndSideDefeat:
                tst.b   collision_flags(a0)
                bne.s   locret_78D2A
                move.b  collision_property(a0),d0
                beq.s   loc_78D2C
                tst.b   $20(a0)
                bne.s   loc_78D1E
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_78D98(pc),a2
                jsr     (CreateChild6_Simple).l

loc_78D1E:
                subq.b  #1,$20(a0)
                bne.s   locret_78D2A
                move.b  $25(a0),collision_flags(a0)

locret_78D2A:
                rts
; ---------------------------------------------------------------------------

loc_78D2C:
                movea.w $44(a0),a1
                move.w  #6,d0
                btst    #0,render_flags(a0)
                beq.s   loc_78D40
                move.w  #7,d0

loc_78D40:
                bset    d0,$38(a1)
                move.b  $38(a1),d0
                andi.b  #$C0,d0
                cmpi.b  #$C0,d0
                bne.s   locret_78D2A
                move.w  #$1F,$2E(a1)
                rts
; End of function HandleLRZMinibossTerminalArmHitAndSideDefeat
