; Owner: objects/runtime/s3
; Responsibility: Timed object waits and floor or wall contact transitions to the next routine
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Obj_Wait:
                subq.w  #1,$2E(a0)
                bmi.s   S3ObjWait_RunCallback
                rts
; ---------------------------------------------------------------------------

S3ObjWait_RunCallback:
                movea.l $34(a0),a1
                jmp     (a1)
; End of function Obj_Wait

; =============== S U B R O U T I N E =======================================

ObjHitFloor_DoRoutine:
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   S3Floor_AdjustYAndContinue
                beq.s   S3Floor_AdjustYAndContinue
                rts
; ---------------------------------------------------------------------------

S3Floor_AdjustYAndContinue:
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
                blt.s   S3PredFloor_TailCall
                cmpi.w  #$C,d1
                bge.s   S3PredFloor_TailCall
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3PredFloor_TailCall:
                movea.l $34(a0),a1
                jmp     (a1)
; End of function ObjHitFloor2_DoRoutine

; =============== S U B R O U T I N E =======================================

ObjHitWall_DoRoutine:
                jsr     (ObjCheckRightWallDist).l
                tst.w   d1
                bmi.s   S3RightWall_AdjustXAndContinue
                rts
; ---------------------------------------------------------------------------

S3RightWall_AdjustXAndContinue:
                add.w   d1,x_pos(a0)
                movea.l $34(a0),a1
                jmp     (a1)
; End of function ObjHitWall_DoRoutine

; ---------------------------------------------------------------------------

ObjHitWall2_DoRoutine:
                jsr     (ObjCheckLeftWallDist).l
                tst.w   d1
                bmi.s   S3LeftWall_AdjustXAndContinue
                rts
; ---------------------------------------------------------------------------

S3LeftWall_AdjustXAndContinue:
                add.w   d1,x_pos(a0)
                movea.l $34(a0),a1
                jmp     (a1)
; End of function ObjHitWall2_DoRoutine
