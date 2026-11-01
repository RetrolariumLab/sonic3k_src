; Owner: objects/effects/s3
; Responsibility: Continuous sound playback and callback-driven object palette fade effects with their color-channel helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Play_SFX_Continuous:
                move.b  (V_int_run_count+3).w,d1
                andi.b  #$F,d1
                bne.w   locret_529CE
                jmp     (Play_SFX).l
; End of function Play_SFX_Continuous

; ---------------------------------------------------------------------------

loc_542B8:
                move.b  #7,$39(a0)
                move.w  #3,$2E(a0)
                move.l  #loc_542CA,(a0)

loc_542CA:
                subq.w  #1,$2E(a0)
                bpl.w   locret_529CE
                move.w  #3,$2E(a0)
                lea     (Normal_palette).w,a1
                moveq   #$40-1,d0

loc_542DE:
                bsr.w   EffectColorS3RaiseOneColorTowardWhite
                dbf     d0,loc_542DE
                subq.b  #1,$39(a0)
                bmi.w   Go_Delete_Sprite
                rts

; =============== S U B R O U T I N E =======================================

EffectColorS3RaiseOneColorTowardWhite:
                moveq   #$E,d2
                move.b  (a1),d3
                and.b   d2,d3
                cmp.b   d2,d3
                bhs.s   loc_542FE
                addq.b  #2,d3
                move.b  d3,(a1)

loc_542FE:
                addq.w  #1,a1
                move.b  (a1),d3
                move.b  d3,d4
                andi.b  #$E0,d3
                andi.b  #$E,d4
                cmpi.b  #$E0,d3
                bhs.s   loc_54316
                addi.b  #$20,d3

loc_54316:
                cmp.b   d2,d4
                bhs.s   loc_5431C
                addq.b  #2,d4

loc_5431C:
                or.b    d3,d4
                move.b  d4,(a1)+
                rts
; End of function EffectColorS3RaiseOneColorTowardWhite

; ---------------------------------------------------------------------------

loc_54322:
                move.b  #7,$39(a0)
                move.w  #3,$2E(a0)
                move.l  #loc_54334,(a0)

loc_54334:
                subq.w  #1,$2E(a0)
                bpl.w   locret_529CE
                move.w  #3,$2E(a0)
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #$40-1,d0

loc_5434C:
                bsr.w   EffectColorS3LowerOneColorTowardTarget
                dbf     d0,loc_5434C
                subq.b  #1,$39(a0)
                bmi.w   Go_Delete_Sprite
                rts

; =============== S U B R O U T I N E =======================================

EffectColorS3LowerOneColorTowardTarget:
                move.b  (a2)+,d2
                andi.b  #$E,d2
                move.b  (a1),d3
                cmp.b   d2,d3
                bls.s   loc_5436E
                subq.b  #2,d3
                move.b  d3,(a1)

loc_5436E:
                addq.w  #1,a1
                move.b  (a2)+,d2
                move.b  d2,d3
                andi.b  #$E0,d2
                andi.b  #$E,d3
                move.b  (a1),d4
                move.b  d4,d5
                andi.b  #$E0,d4
                andi.b  #$E,d5
                cmp.b   d2,d4
                bls.s   loc_54390
                subi.b  #$20,d4

loc_54390:
                cmp.b   d3,d5
                bls.s   loc_54396
                subq.b  #2,d5

loc_54396:
                or.b    d4,d5
                move.b  d5,(a1)+
                rts
; End of function EffectColorS3LowerOneColorTowardTarget
