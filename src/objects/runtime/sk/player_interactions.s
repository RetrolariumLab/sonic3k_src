; Owner: objects/runtime/sk
; Responsibility: Object defeat response, scoring, character-specific attack tests, player contact, range checks and displacement
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

EnemyDefeated:
                bsr.w   EnemyDefeat_Score
                movea.w $44(a0),a1
                tst.w   y_vel(a1)
                bmi.s   loc_85750
                move.w  y_pos(a1),d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_85758
                neg.w   y_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_85750:
                addi.w  #$100,y_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_85758:
                subi.w  #$100,y_vel(a1)
                rts
; End of function EnemyDefeated

; =============== S U B R O U T I N E =======================================

EnemyDefeat_Score:
                bset    #7,status(a0)
                clr.b   collision_flags(a0)
                moveq   #0,d0
                move.w  (Chain_bonus_counter).w,d0
                addq.w  #2,(Chain_bonus_counter).w
                cmpi.w  #6,d0
                blo.s   loc_8577C
                moveq   #6,d0

loc_8577C:
                move.w  d0,$3E(a0)
                move.w  word_857AC(pc,d0.w),d0
                cmpi.w  #$20,(Chain_bonus_counter).w
                blo.s   loc_85796
                move.w  #1000,d0                        ; 10000 points
                move.w  #$A,$3E(a0)

loc_85796:
                movea.w a1,a3
                jsr     (HUD_AddToScore).l
                move.l  #Obj_Explosion,(a0)
                move.b  #0,routine(a0)
                rts
; End of function EnemyDefeat_Score

; ---------------------------------------------------------------------------
word_857AC:
                dc.w    10                              ; 100 points
                dc.w    20                              ; 200 points
                dc.w    50                              ; 500 points
                dc.w    100                             ; 1000 points

; =============== S U B R O U T I N E =======================================

HurtCharacter_Directly:
                movea.l a0,a2
                movea.l a1,a0
                jsr     (HurtCharacter).l
                movea.l a2,a0
                rts
; End of function HurtCharacter_Directly

; =============== S U B R O U T I N E =======================================

Check_PlayerAttack:
                btst    #Status_Invincible,status_secondary(a1)
                bne.s   loc_85822
                cmpi.b  #9,anim(a1)
                beq.s   loc_85822
                cmpi.b  #2,anim(a1)
                beq.s   loc_85822
                moveq   #0,d0
                move.b  character_id(a1),d0
                add.w   d0,d0
                move.w  Check_PlayerAttack_Index(pc,d0.w),d0
                jmp     Check_PlayerAttack_Index(pc,d0.w)
; ---------------------------------------------------------------------------
Check_PlayerAttack_Index:
                dc.w    Check_SonicAttack-Check_PlayerAttack_Index
                dc.w    Check_TailsAttack-Check_PlayerAttack_Index
                dc.w    Check_KnuxAttack-Check_PlayerAttack_Index
; ---------------------------------------------------------------------------

Check_SonicAttack:
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

Check_TailsAttack:
                tst.b   double_jump_flag(a1)
                beq.s   Check_SonicAttack               ; If Tails is not flying, branch
                btst    #6,status(a1)
                bne.s   Check_SonicAttack               ; If Tails is underwater, branch
                move.w  x_pos(a1),d1
                move.w  y_pos(a1),d2
                sub.w   x_pos(a0),d1
                sub.w   y_pos(a0),d2
                jsr     (GetArcTan).l                   ; Get angle between Tails and object
                subi.b  #$20,d0
                cmpi.b  #$40,d0
                bhs.s   Check_SonicAttack               ; If Tails is between 20-60 degrees off object (directly below), then he is attacking

loc_85822:
                moveq   #1,d0
                rts
; End of function Check_PlayerAttack

; ---------------------------------------------------------------------------

Check_KnuxAttack:
                cmpi.b  #1,double_jump_flag(a1)
                beq.s   loc_85822
                cmpi.b  #3,double_jump_flag(a1)
                beq.s   loc_85822                       ; If Knux is gliding or sliding, then he's attacking
                bra.s   Check_SonicAttack

; =============== S U B R O U T I N E =======================================

Check_LRControllerShake:
                subq.b  #1,$3D(a0)
                bpl.s   loc_8584A
                move.b  #5,$3C(a0)
                move.b  #60,$3D(a0)

loc_8584A:
                movea.w $3E(a0),a2
                move.w  (a2),d0
                andi.w  #$C,d0
                beq.s   locret_8586E
                move.w  $3A(a0),d1
                move.w  d0,$3A(a0)
                andi.w  #$C,d1
                eor.w   d1,d0
                beq.s   locret_8586E
                subq.b  #1,$3C(a0)
                bmi.s   locret_8586E
                moveq   #0,d0

locret_8586E:
                rts
; End of function Check_LRControllerShake

; =============== S U B R O U T I N E =======================================

Check_PlayerCollision:
                move.b  collision_property(a0),d0
                beq.s   locret_8588E
                clr.b   collision_property(a0)
                andi.w  #3,d0
                add.w   d0,d0
                lea     word_85890(pc),a1
                movea.w (a1,d0.w),a1
                move.w  a1,$44(a0)
                moveq   #1,d1

locret_8588E:
                rts
; End of function Check_PlayerCollision

; ---------------------------------------------------------------------------
word_85890:
                dc.w    Player_1
                dc.w    Player_1
                dc.w    Player_2
                dc.w    Player_2

; =============== S U B R O U T I N E =======================================

Check_InTheirRange:
                move.w  x_pos(a0),d0
                move.w  x_pos(a1),d1
                add.w   (a2)+,d1
                cmp.w   d1,d0
                blt.s   loc_858C4
                add.w   (a2)+,d1
                cmp.w   d1,d0
                bge.s   loc_858C4
                move.w  y_pos(a0),d0
                move.w  y_pos(a1),d1
                add.w   (a2)+,d1
                cmp.w   d1,d0
                blt.s   loc_858C4
                add.w   (a2)+,d1
                cmp.w   d1,d0
                bge.s   loc_858C4
                moveq   #1,d0
                rts
; ---------------------------------------------------------------------------

loc_858C4:
                moveq   #0,d0
                rts
; End of function Check_InTheirRange

; =============== S U B R O U T I N E =======================================

Check_InMyRange:
                move.w  x_pos(a0),d0
                move.w  x_pos(a1),d1
                add.w   (a2)+,d0
                cmp.w   d0,d1
                blt.s   loc_858F4
                add.w   (a2)+,d0
                cmp.w   d0,d1
                bge.s   loc_858F4
                move.w  y_pos(a0),d0
                move.w  y_pos(a1),d1
                add.w   (a2)+,d0
                cmp.w   d0,d1
                blt.s   loc_858F4
                add.w   (a2)+,d0
                cmp.w   d0,d1
                bge.s   loc_858F4
                moveq   #1,d0
                rts
; ---------------------------------------------------------------------------

loc_858F4:
                moveq   #0,d0
                rts
; End of function Check_InMyRange

; =============== S U B R O U T I N E =======================================

Check_PlayerInRange:
                moveq   #0,d0
                lea     (Player_2).w,a2
                move.w  x_pos(a2),d1
                move.w  y_pos(a2),d2
                move.w  x_pos(a0),d3
                move.w  y_pos(a0),d4
                add.w   (a1)+,d3
                move.w  d3,d5
                add.w   (a1)+,d5
                add.w   (a1)+,d4
                move.w  d4,d6
                add.w   (a1)+,d6
                bsr.w   StorePlayerPointerIfInsideRect
                swap    d0
                lea     (Player_1).w,a2
                move.w  x_pos(a2),d1
                move.w  y_pos(a2),d2
; End of function Check_PlayerInRange

; =============== S U B R O U T I N E =======================================

StorePlayerPointerIfInsideRect:
                cmp.w   d3,d1
                blo.s   locret_8593E
                cmp.w   d5,d1
                bhs.s   locret_8593E
                cmp.w   d4,d2
                blo.s   locret_8593E
                cmp.w   d6,d2
                bhs.s   locret_8593E
                move.w  a2,d0

locret_8593E:
                rts
; End of function StorePlayerPointerIfInsideRect

; =============== S U B R O U T I N E =======================================

PalLoad_Line1:
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d0

                .loop:
                move.l  (a1)+,(a2)+
                dbf     d0,.loop
                rts
; End of function PalLoad_Line1

; =============== S U B R O U T I N E =======================================

Displace_PlayerOffObject:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   locret_85988
                bclr    #p1_standing_bit,status(a0)
                beq.s   loc_85970
                lea     (Player_1).w,a1
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)

loc_85970:
                bclr    #p2_standing_bit,status(a0)
                beq.s   locret_85988
                lea     (Player_2).w,a1
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)

locret_85988:
                rts
; End of function Displace_PlayerOffObject
