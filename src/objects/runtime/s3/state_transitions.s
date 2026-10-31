; Owner: objects/runtime/s3
; Responsibility: Timed object waits and floor or wall contact transitions to the next routine
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Obj_Wait:
                subq.w  #1,$2E(a0)
                bmi.s   loc_53010
                rts
; ---------------------------------------------------------------------------

loc_53010:
                movea.l $34(a0),a1
                jmp     (a1)
; End of function Obj_Wait

; =============== S U B R O U T I N E =======================================

ObjHitFloor_DoRoutine:
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_53024
                beq.s   loc_53024
                rts
; ---------------------------------------------------------------------------

loc_53024:
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
                blt.s   loc_53054
                cmpi.w  #$C,d1
                bge.s   loc_53054
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_53054:
                movea.l $34(a0),a1
                jmp     (a1)
; End of function ObjHitFloor2_DoRoutine

; =============== S U B R O U T I N E =======================================

ObjHitWall_DoRoutine:
                jsr     (ObjCheckRightWallDist).l
                tst.w   d1
                bmi.s   loc_53066
                rts
; ---------------------------------------------------------------------------

loc_53066:
                add.w   d1,x_pos(a0)
                movea.l $34(a0),a1
                jmp     (a1)
; End of function ObjHitWall_DoRoutine

; ---------------------------------------------------------------------------

ObjHitWall2_DoRoutine:
                jsr     (ObjCheckLeftWallDist).l
                tst.w   d1
                bmi.s   loc_5307C
                rts
; ---------------------------------------------------------------------------

loc_5307C:
                add.w   d1,x_pos(a0)
                movea.l $34(a0),a1
                jmp     (a1)
; End of function ObjHitWall2_DoRoutine
