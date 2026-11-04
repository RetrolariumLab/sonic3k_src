; Owner: objects/runtime/sk
; Responsibility: Timed object waits and floor or wall contact transitions to the next routine
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Obj_Wait:
                subq.w  #1,$2E(a0)
                bmi.s   SKObjWait_RunCallback
                rts
; ---------------------------------------------------------------------------

SKObjWait_RunCallback:
                movea.l $34(a0),a1
                jmp     (a1)
; End of function Obj_Wait

; =============== S U B R O U T I N E =======================================

ObjHitFloor_DoRoutine:
                tst.w   y_vel(a0)
                bmi.s   SKFloor_NoContactReturn
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   SKFloor_AdjustYAndContinue
                beq.s   SKFloor_AdjustYAndContinue

SKFloor_NoContactReturn:
                rts
; ---------------------------------------------------------------------------

SKFloor_AdjustYAndContinue:
                add.w   d1,y_pos(a0)
                movea.l $34(a0),a1
                jmp     (a1)
; End of function ObjHitFloor_DoRoutine

; =============== S U B R O U T I N E =======================================

ObjHitFloor2_DoRoutine:
                move.w  x_vel(a0),d3
                ext.l   d3
                lsl.l   #8,d3
                add.l   x_pos(a0),d3
                swap    d3
                jsr     (ObjCheckFloorDist2).l
                cmpi.w  #-1,d1
                blt.s   SKPredFloor_CallAndReturnOne
                cmpi.w  #$C,d1
                bge.s   SKPredFloor_CallAndReturnOne
                add.w   d1,y_pos(a0)
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

SKPredFloor_CallAndReturnOne:
                movea.l $34(a0),a1
                jsr     (a1)
                moveq   #1,d0
                rts
; End of function ObjHitFloor2_DoRoutine

; =============== S U B R O U T I N E =======================================

ObjHitWall_DoRoutine:
                jsr     (ObjCheckRightWallDist).l
                tst.w   d1
                bmi.s   SKRightWall_AdjustXAndContinue
                rts
; ---------------------------------------------------------------------------

SKRightWall_AdjustXAndContinue:
                add.w   d1,x_pos(a0)
                movea.l $34(a0),a1
                jmp     (a1)
; End of function ObjHitWall_DoRoutine

; ---------------------------------------------------------------------------

ObjHitWall2_DoRoutine:
                jsr     (ObjCheckLeftWallDist).l
                tst.w   d1
                bmi.s   SKLeftWall_AdjustXAndContinue
                rts
; ---------------------------------------------------------------------------

SKLeftWall_AdjustXAndContinue:
                add.w   d1,x_pos(a0)
                movea.l $34(a0),a1
                jmp     (a1)
; End of function ObjHitWall2_DoRoutine
