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
                bpl.s   S3FindPlayers_MeasureP2X
                neg.w   d2
                addq.w  #2,d0

S3FindPlayers_MeasureP2X:
                lea     (Player_2).w,a2
                move.w  x_pos(a0),d3
                sub.w   x_pos(a2),d3
                bpl.s   S3FindPlayers_SelectNearestX
                neg.w   d3
                addq.w  #2,d1

; Compare unsigned X distances and keep player 1 on a tie
S3FindPlayers_SelectNearestX:
                cmp.w   d3,d2
                bls.s   S3FindPlayers_MeasureSelectedY
                movea.l a2,a1
                move.w  d1,d0
                move.w  d3,d2

S3FindPlayers_MeasureSelectedY:
                moveq   #0,d1
                move.w  y_pos(a0),d3
                sub.w   y_pos(a1),d3
                bpl.s   S3FindPlayers_Return
                neg.w   d3
                addq.w  #2,d1

; A1 selects the player. D0/D1 are side codes and D2/D3 are X/Y word distances
S3FindPlayers_Return:
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
                bpl.s   S3FindOther_MeasureY
                neg.w   d2
                addq.w  #2,d0

S3FindOther_MeasureY:
                moveq   #0,d1
                move.w  y_pos(a0),d3
                sub.w   y_pos(a1),d3
                bpl.s   S3FindOther_Return
                neg.w   d3
                addq.w  #2,d1

S3FindOther_Return:
                rts
; End of function Find_OtherObject
