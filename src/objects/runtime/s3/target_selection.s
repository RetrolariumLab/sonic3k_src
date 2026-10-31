; Owner: objects/runtime/s3
; Responsibility: Nearest player or other-object selection and facing from position, velocity or parent flags
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Find_SonicTails:
                moveq   #0,d0                           ; d0 = 0 if Sonic/Tails is left of object, 2 if right of object
                moveq   #0,d1                           ; d1 = 0 if Sonic/Tails is above object, 2 if below object
                lea     (Player_1).w,a1
                move.w  x_pos(a0),d2
                sub.w   x_pos(a1),d2
                bpl.s   loc_53280
                neg.w   d2
                addq.w  #2,d0

loc_53280:
                lea     (Player_2).w,a2
                move.w  x_pos(a0),d3
                sub.w   x_pos(a2),d3
                bpl.s   loc_53292
                neg.w   d3
                addq.w  #2,d1

loc_53292:
                cmp.w   d3,d2
                bls.s   loc_5329C
                movea.l a2,a1
                move.w  d1,d0
                move.w  d3,d2

loc_5329C:
                moveq   #0,d1
                move.w  y_pos(a0),d3
                sub.w   y_pos(a1),d3
                bpl.s   locret_532AC
                neg.w   d3
                addq.w  #2,d1

locret_532AC:
                rts
; End of function Find_SonicTails

; =============== S U B R O U T I N E =======================================

Change_FlipX:
                bclr    #0,render_flags(a0)
                tst.w   d0
                beq.s   .return
                bset    #0,render_flags(a0)

                .return:
                rts
; End of function Change_FlipX

; =============== S U B R O U T I N E =======================================

Change_FlipXWithVelocity:
                bclr    #0,render_flags(a0)
                tst.w   x_vel(a0)
                bmi.s   .return
                bset    #0,render_flags(a0)

                .return:
                rts
; End of function Change_FlipXWithVelocity

; =============== S U B R O U T I N E =======================================

Change_FlipXUseParent:
                bclr    #0,render_flags(a0)
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                beq.s   .return
                bset    #0,render_flags(a0)

                .return:
                rts
; End of function Change_FlipXUseParent

; =============== S U B R O U T I N E =======================================

Find_OtherObject:
                moveq   #0,d0                           ; d0 = 0 if other object is left of calling object, 2 if right of it
                moveq   #0,d1                           ; d1 = 0 if other object is above calling object, 2 if below it
                move.w  x_pos(a0),d2
                sub.w   x_pos(a1),d2
                bpl.s   loc_53300
                neg.w   d2
                addq.w  #2,d0

loc_53300:
                moveq   #0,d1
                move.w  y_pos(a0),d3
                sub.w   y_pos(a1),d3
                bpl.s   locret_53310
                neg.w   d3
                addq.w  #2,d1

locret_53310:
                rts
; End of function Find_OtherObject
