; Owner: objects/bosses/cnz/miniboss/sk
; Responsibility: Carnival Night miniboss swing, collision, defeat, palette and player response helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

SetUp_CNZMinibossSwing:
                move.w  #$60,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts

; =============== S U B R O U T I N E =======================================

CNZMiniboss_CheckPlayerHit:
                tst.b   collision_flags(a0)
                bne.s   locret_6E0AE
                bset    #2,$38(a0)                      ; If boss was hit by Sonic, set flag
                bne.s   loc_6E09C                       ; If already set earlier, skip ahead
                addq.b  #1,collision_property(a0)       ; Don't allow hit to affect him
                move.b  #$10,$3A(a0)
                bset    #3,$38(a0)
                bne.s   loc_6E09C
                move.b  #8,routine(a0)
                move.l  #AniRaw_CNZMinibossOpening,$30(a0)
                move.l  #Obj_CNZMinibossOpenGo,$34(a0)  ; Set boss to opening animation/routine
                lea     (PalSPtr_CNZMinibossOpen).l,a1
                lea     (Palette_rotation_data).w,a2    ; Reset pal script
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+

loc_6E09C:
                subq.b  #1,$3A(a0)
                bpl.s   locret_6E0AE
                bclr    #2,$38(a0)
                move.b  $25(a0),collision_flags(a0)     ; Restore collision after 16 frames at most while opening

locret_6E0AE:
                rts
; End of function CNZMiniboss_CheckPlayerHit

; =============== S U B R O U T I N E =======================================

CNZMiniboss_CheckTopHit:
                tst.b   $44(a0)
                beq.s   locret_6E0F8                    ; If not hit by top, don't bother
                tst.b   $20(a0)
                bne.s   loc_6E0D6
                subq.b  #1,$45(a0)                      ; Subtract 1 from ACTUAL hit count
                beq.s   CNZMiniboss_BossDefeated
                bset    #6,status(a0)                   ; Set to indicate in hit stun
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l                    ; Play hit sound

loc_6E0D6:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_6E0E4
                addi.w  #2*5,d0

loc_6E0E4:
                bsr.w   CNZMiniboss_BossFlash           ; Do the boss flash
                subq.b  #1,$20(a0)
                bne.s   locret_6E0F8
                bclr    #6,status(a0)
                clr.b   $44(a0)

locret_6E0F8:
                rts
; ---------------------------------------------------------------------------

CNZMiniboss_BossDefeated:
                move.l  #Wait_FadeToLevelMusic,(a0)
                bset    #7,status(a0)                   ; Boss has been annihilated!
                move.l  #Obj_CNZMinibossEnd,$34(a0)
                move.w  #$20,(Normal_palette_line_2+$14).w  ; Set palette properly
                st      (Events_fg_5).w                 ; Signal BG event
                lea     Child1_CNZMinibossExplosion(pc),a2
                jsr     (CreateChild1_Normal).l
                jmp     (BossDefeated_StopTimer).l
; End of function CNZMiniboss_CheckTopHit

; =============== S U B R O U T I N E =======================================

CNZMiniboss_BossFlash:
                lea     word_6E146(pc),a1
                lea     word_6E150(pc,d0.w),a2
                rept    5
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+
                endm
                rts
; End of function CNZMiniboss_BossFlash

; ---------------------------------------------------------------------------
word_6E146:
                dc.w    Normal_palette_line_2+$04, Normal_palette_line_2+$06, Normal_palette_line_2+$08
                dc.w    Normal_palette_line_2+$0E, Normal_palette_line_2+$1C
word_6E150:
                dc.w    $6E0,  $280,   $40,   $28,  $642
                dc.w    $888,  $AAA,  $CCC,  $888,  $AAA
; ---------------------------------------------------------------------------

CNZMiniboss_MakeTimedSparks:
                lea     (PalSPtr_CNZMinibossSparks).l,a2
                move.l  (a2)+,(a1)+
                move.l  (a2)+,(a1)+
                lea     Child1_CNZMinibossTimedSparks(pc),a2
                jmp     (CreateChild1_Normal).l

; =============== S U B R O U T I N E =======================================

CNZMiniboss_MoveDown:
                move.w  (Events_bg+$04).w,d0
                cmp.w   $3C(a0),d0
                beq.s   locret_6E198
                move.w  d0,$3C(a0)
                move.b  routine(a0),$42(a0)
                move.b  #$E,routine(a0)
                move.b  #$1F,$43(a0)

locret_6E198:
                rts
; End of function CNZMiniboss_MoveDown

; =============== S U B R O U T I N E =======================================

CNZMinibossTop_CheckPlayerBounce:
                lea     (Player_1).w,a1
                bsr.w   sub_6E1A8
                bne.s   locret_6E20E
                lea     (Player_2).w,a1
; End of function CNZMinibossTop_CheckPlayerBounce

; =============== S U B R O U T I N E =======================================

sub_6E1A8:
                tst.w   y_vel(a1)
                bpl.s   loc_6E210                       ; If player is moving downward, don't bother
                cmpi.b  #2,anim(a1)
                bne.s   loc_6E210                       ; If player is not in rolling animation, don't bother
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                addi.w  #$C,d1
                move.w  x_pos(a1),d2
                subi.w  #$10,d2
                cmp.w   d2,d0
                blo.s   loc_6E210                       ; If player is not within X range, don't bother
                addi.w  #$20,d2
                cmp.w   d2,d0
                bhs.s   loc_6E210                       ; See above
                move.w  y_pos(a1),d2
                subi.w  #$10,d2
                cmp.w   d2,d1
                blo.s   loc_6E210                       ; If player is not within Y range, don't bother
                addi.w  #$20,d2
                cmp.w   d2,d1
                bhs.s   loc_6E210                       ; See above
                tst.w   x_vel(a1)
                bmi.s   loc_6E1FA
                tst.w   x_vel(a0)
                bpl.s   loc_6E204                       ; If player and top are moving the same direction, don't need to reverse X direction
                bra.w   loc_6E200
; ---------------------------------------------------------------------------

loc_6E1FA:
                tst.w   x_vel(a0)
                bmi.s   loc_6E204                       ; If player and top are moving the same direction, don't need to reverse X direction

loc_6E200:
                neg.w   x_vel(a0)                       ; If moving in opposite directions, reverse

loc_6E204:
                tst.w   y_vel(a0)
                bmi.w   loc_6E210
                moveq   #1,d0                           ; If top is moving downward on collision, set collision flag

locret_6E20E:
                rts
; ---------------------------------------------------------------------------

loc_6E210:
                moveq   #0,d0
                rts
; End of function sub_6E1A8

; =============== S U B R O U T I N E =======================================

CNZMinibossTop_CheckHitBase:
                movea.w parent3(a0),a1
                lea     CNZMiniboss_BaseRange(pc),a2    ; Two hit boxes. First is the slightly wider base
                move.w  x_pos(a1),d2
                add.w   (a2)+,d2
                cmp.w   d2,d0
                blo.s   loc_6E23C
                add.w   (a2)+,d2
                cmp.w   d2,d0
                bhs.s   loc_6E23C
                move.w  y_pos(a1),d2
                add.w   (a2)+,d2
                cmp.w   d2,d1
                blo.s   loc_6E23C
                add.w   (a2)+,d2
                cmp.w   d2,d1
                blo.s   loc_6E270

loc_6E23C:
                lea     CNZMiniboss_CoilRange(pc),a2    ; Then it's the coil, different ranges depending on open or close state
                btst    #6,$38(a1)
                beq.s   loc_6E24C
                lea     CNZMiniboss_CoilOpenRange(pc),a2

loc_6E24C:
                move.w  x_pos(a1),d2
                add.w   (a2)+,d2
                cmp.w   d2,d0
                blo.s   loc_6E26C
                add.w   (a2)+,d2
                cmp.w   d2,d0
                bhs.s   loc_6E26C
                move.w  y_pos(a1),d2
                add.w   (a2)+,d2
                cmp.w   d2,d1
                blo.s   loc_6E26C
                add.w   (a2)+,d2
                cmp.w   d2,d1
                blo.s   loc_6E270

loc_6E26C:
                moveq   #0,d2
                rts
; ---------------------------------------------------------------------------

loc_6E270:
                btst    #6,$38(a1)
                beq.s   loc_6E27C
                st      $44(a1)                         ; Only set hit state if coil was open to begin with

loc_6E27C:
                moveq   #1,d2
                rts
; End of function CNZMinibossTop_CheckHitBase
