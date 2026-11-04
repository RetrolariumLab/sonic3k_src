; Owner: objects/effects/sk
; Responsibility: Continuous sound playback and callback-driven palette fade effects with color-channel helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Play_SFX_Continuous:
                move.b  (V_int_run_count+3).w,d1
                andi.b  #$F,d1
                bne.w   SKReturn_AttrSetup
                jmp     (Play_SFX).l
; End of function Play_SFX_Continuous

; ---------------------------------------------------------------------------

loc_85E64:
                move.b  #7,$39(a0)
                move.l  #loc_85E74,(a0)
                st      (Palette_rotation_disable).w

loc_85E74:
                subq.w  #1,$2E(a0)
                bpl.s   locret_85EA8
                move.w  $3A(a0),$2E(a0)
                lea     (Normal_palette).w,a1
                moveq   #$40-1,d0

loc_85E86:
                bsr.w   EffectColorSKRaiseOneColorTowardWhite
                dbf     d0,loc_85E86
                subq.b  #1,$39(a0)
                bmi.s   loc_85E96
                rts
; ---------------------------------------------------------------------------

loc_85E96:
                tst.b   subtype(a0)
                beq.s   loc_85EAA
                move.l  #loc_85EE6,(a0)
                bset    #5,$38(a0)

locret_85EA8:
                rts
; ---------------------------------------------------------------------------

loc_85EAA:
                clr.b   (Palette_rotation_disable).w
                jmp     (Go_Delete_Sprite).l

; =============== S U B R O U T I N E =======================================

EffectColorSKRaiseOneColorTowardWhite:
                moveq   #$E,d2
                move.b  (a1),d3
                and.b   d2,d3
                cmp.b   d2,d3
                bhs.s   loc_85EC2
                addq.b  #2,d3
                move.b  d3,(a1)

loc_85EC2:
                addq.w  #1,a1
                move.b  (a1),d3
                move.b  d3,d4
                andi.b  #$E0,d3
                andi.b  #$E,d4
                cmpi.b  #$E0,d3
                bhs.s   loc_85EDA
                addi.b  #$20,d3

loc_85EDA:
                cmp.b   d2,d4
                bhs.s   loc_85EE0
                addq.b  #2,d4

loc_85EE0:
                or.b    d3,d4
                move.b  d4,(a1)+
                rts
; End of function EffectColorSKRaiseOneColorTowardWhite

; ---------------------------------------------------------------------------

loc_85EE6:
                move.b  #7,$39(a0)
                move.w  #3,$2E(a0)
                move.l  #loc_85EF8,(a0)

loc_85EF8:
                subq.w  #1,$2E(a0)
                bpl.w   SKReturn_AttrSetup
                move.w  #3,$2E(a0)
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #$40-1,d0

loc_85F10:
                bsr.w   EffectColorSKLowerOneColorTowardTarget
                dbf     d0,loc_85F10
                subq.b  #1,$39(a0)
                bpl.w   SKReturn_AttrSetup
                clr.b   (Palette_rotation_disable).w
                jmp     (Go_Delete_Sprite).l

; =============== S U B R O U T I N E =======================================

EffectColorSKLowerOneColorTowardTarget:
                move.b  (a2)+,d2
                andi.b  #$E,d2
                move.b  (a1),d3
                cmp.b   d2,d3
                bls.s   loc_85F3A
                subq.b  #2,d3
                move.b  d3,(a1)

loc_85F3A:
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
                bls.s   loc_85F5C
                subi.b  #$20,d4

loc_85F5C:
                cmp.b   d3,d5
                bls.s   loc_85F62
                subq.b  #2,d5

loc_85F62:
                or.b    d4,d5
                move.b  d5,(a1)+
                rts
; End of function EffectColorSKLowerOneColorTowardTarget

; ---------------------------------------------------------------------------
loc_85F68:                                              ; used in S3, unused in S3&K
                move.w  (Player_mode).w,d0
                cmpi.w  #2,d0
                beq.s   loc_85F7E
                cmpi.w  #7,(Emerald_counts).w
                beq.s   loc_85F82
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

loc_85F7E:
                moveq   #1,d0
                rts
; ---------------------------------------------------------------------------

loc_85F82:
                moveq   #2,d0
                rts
