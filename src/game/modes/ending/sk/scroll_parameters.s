; Owner: game/modes/ending/sk
; Responsibility: Choose credit scroll speed and delay from product, region, character and emerald completion state
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

sub_5B514:
                moveq   #0,d1
                tst.w   (SK_alone_flag).w
                bne.s   loc_5B520
                addi.w  #$24,d1

loc_5B520:
                btst    #6,(Graphics_flags).w
                beq.s   loc_5B52C
                addi.w  #$12,d1

loc_5B52C:
                move.w  (Player_mode).w,d0
                subq.w  #2,d0
                bmi.s   loc_5B53E
                beq.s   loc_5B53A
                addi.w  #6,d1

loc_5B53A:
                addi.w  #6,d1

loc_5B53E:
                tst.b   (_unkFA88).w
                bmi.s   loc_5B54A
                beq.s   loc_5B548
                addq.w  #2,d1

loc_5B548:
                addq.w  #2,d1

loc_5B54A:
                lea     CreditsText_ScrollSpeed(pc),a1
                moveq   #0,d0
                move.w  (a1,d1.w),d0
                lsl.l   #8,d0
                move.l  d0,(_unkFAC8).w
                lea     CreditsText_ScrollDelay(pc),a1
                move.w  (a1,d1.w),(_unkF660).w
                rts
; End of function sub_5B514
