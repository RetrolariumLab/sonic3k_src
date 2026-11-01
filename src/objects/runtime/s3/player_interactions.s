; Owner: objects/runtime/s3
; Responsibility: Enemy defeat scoring, controller shake, player collision or proximity, palette transfer and object displacement
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

EnemyDefeat_Score:
                bset    #7,status(a0)
                movea.w $44(a0),a1
                moveq   #0,d0
                move.w  (Chain_bonus_counter).w,d0
                addq.w  #2,(Chain_bonus_counter).w
                cmpi.w  #6,d0
                blo.s   loc_53D88
                moveq   #6,d0

loc_53D88:
                move.w  d0,$3E(a0)
                move.w  word_53DE8(pc,d0.w),d0
                cmpi.w  #$20,(Chain_bonus_counter).w
                blo.s   loc_53DA2
                move.w  #1000,d0                        ; 10000 points
                move.w  #$A,$3E(a0)

loc_53DA2:
                movea.w a1,a3
                jsr     (HUD_AddToScore).l
                move.l  #Obj_Explosion,(a0)
                move.b  #0,routine(a0)
                tst.w   y_vel(a1)
                bmi.s   loc_53DD0
                move.w  y_pos(a1),d0
                cmp.w   y_pos(a0),d0
                bcc.s   loc_53DDC
                neg.w   y_vel(a1)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_53DD0:
                addi.w  #$100,y_vel(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_53DDC:
                subi.w  #$100,y_vel(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
word_53DE8:
                dc.w    10                              ; 100 points
                dc.w    20                              ; 200 points
                dc.w    50                              ; 500 points
                dc.w    100                             ; 1000 points

; =============== S U B R O U T I N E =======================================

Check_LRControllerShake:
                subq.b  #1,$3D(a0)
                bpl.s   loc_53E02
                move.b  #5,$3C(a0)
                move.b  #60,$3D(a0)

loc_53E02:
                movea.w $3E(a0),a2
                move.w  (a2),d0
                andi.w  #$C,d0
                beq.s   locret_53E26
                move.w  $3A(a0),d1
                move.w  d0,$3A(a0)
                andi.w  #$C,d1
                eor.w   d1,d0
                beq.s   locret_53E26
                subq.b  #1,$3C(a0)
                bmi.s   locret_53E26
                moveq   #0,d0

locret_53E26:
                rts
; End of function Check_LRControllerShake

; =============== S U B R O U T I N E =======================================

Check_PlayerCollision:
                move.b  collision_property(a0),d0
                beq.s   locret_53E50
                clr.b   collision_property(a0)
                move.w  parent3(a0),d1
                beq.s   loc_53E40
                movea.w d1,a1
                bset    #0,$38(a1)

loc_53E40:
                andi.w  #3,d0
                add.w   d0,d0
                movea.w word_53E52-2(pc,d0.w),a1
                move.w  a1,$44(a0)
                moveq   #1,d1

locret_53E50:
                rts
; End of function Check_PlayerCollision

; ---------------------------------------------------------------------------
word_53E52:
                dc.w    Player_1
                dc.w    Player_2
                dc.w    Player_1

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
                blo.s   locret_53E9E
                cmp.w   d5,d1
                bhs.s   locret_53E9E
                cmp.w   d4,d2
                blo.s   locret_53E9E
                cmp.w   d6,d2
                bhs.s   locret_53E9E
                move.w  a2,d0

locret_53E9E:
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
                beq.s   locret_53EE8
                bclr    #p1_standing_bit,status(a0)
                beq.s   loc_53ED0
                lea     (Player_1).w,a1
; Bug: This should clear Status_OnObj instead of p1_standing_bit
; Thankfully, they both equal 3. Sonic (3) & Knuckles corrects this
                bclr    #p1_standing_bit,status(a1)
                bset    #Status_InAir,status(a1)

loc_53ED0:
                bclr    #p2_standing_bit,status(a0)
                beq.s   locret_53EE8
                lea     (Player_2).w,a1
; Bug: this should clear Status_OnObj instead of p2_standing_bit
; As a result, player 2's Status_RollJump is cleared instead
; Sonic (3) & Knuckles corrects this as well
                bclr    #p2_standing_bit,status(a1)
                bset    #Status_InAir,status(a1)

locret_53EE8:
                rts
; End of function Displace_PlayerOffObject
