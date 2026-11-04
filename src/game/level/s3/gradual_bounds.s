; Owner: game/level/s3
; Responsibility: Gradual camera bound changes and their four object child descriptors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_IncLevEndXGradual:
                move.w  (Camera_max_X_pos).w,d0
                move.l  $30(a0),d1
                addi.l  #$4000,d1
                move.l  d1,$30(a0)
                swap    d1
                add.w   d1,d0
                cmp.w   (Camera_stored_max_X_pos).w,d0
                bhs.s   S3Camera_LatchGrowingMaxX
                move.w  d0,(Camera_max_X_pos).w
                rts
; ---------------------------------------------------------------------------

S3Camera_LatchGrowingMaxX:
                move.w  (Camera_stored_max_X_pos).w,(Camera_max_X_pos).w

; The selected-color fade object also uses this deletion tail
S3Camera_DeleteCompletedActor:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_DecLevStartXGradual:
                move.w  (Camera_min_X_pos).w,d0
                move.l  $30(a0),d1
                addi.l  #$4000,d1
                move.l  d1,$30(a0)
                swap    d1
                sub.w   d1,d0
                cmp.w   (Camera_stored_min_X_pos).w,d0
                ble.s   S3Camera_LatchLowerMinX
                move.w  d0,(Camera_min_X_pos).w
                rts
; ---------------------------------------------------------------------------

S3Camera_LatchLowerMinX:
                move.w  (Camera_stored_min_X_pos).w,(Camera_min_X_pos).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_DecLevStartYGradual:
                move.w  (Camera_min_Y_pos).w,d0
                move.l  $30(a0),d1
                addi.l  #$4000,d1
                move.l  d1,$30(a0)
                swap    d1
                sub.w   d1,d0
                cmp.w   (Camera_stored_min_Y_pos).w,d0
                ble.s   S3Camera_LatchLowerMinY
                move.w  d0,(Camera_min_Y_pos).w
                rts
; ---------------------------------------------------------------------------

S3Camera_LatchLowerMinY:
                move.w  (Camera_stored_min_Y_pos).w,(Camera_min_Y_pos).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_IncLevEndYGradual:
                move.w  (Camera_max_Y_pos).w,d0
                move.l  $30(a0),d1
                addi.l  #$8000,d1
                move.l  d1,$30(a0)
                swap    d1
                add.w   d1,d0
                cmp.w   (Camera_stored_max_Y_pos).w,d0
                bgt.s   S3Camera_LatchGrowingMaxY
                move.w  d0,(Camera_max_Y_pos).w
                rts
; ---------------------------------------------------------------------------

S3Camera_LatchGrowingMaxY:
                move.w  (Camera_stored_max_Y_pos).w,(Camera_max_Y_pos).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Child6_IncLevX:
                dc.w    1-1
                dc.l    Obj_IncLevEndXGradual
Child6_DecLevX:
                dc.w    1-1
                dc.l    Obj_DecLevStartXGradual
Child6_DecLevY:
                dc.w    1-1
                dc.l    Obj_DecLevStartYGradual
Child6_IncLevY:
                dc.w    1-1
                dc.l    Obj_IncLevEndYGradual
