; Owner: game/level/sk
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
                bhs.s   loc_84A6A
                move.w  d0,(Camera_max_X_pos).w
                rts
; ---------------------------------------------------------------------------

loc_84A6A:
                move.w  (Camera_stored_max_X_pos).w,(Camera_max_X_pos).w

loc_84A70:                                              ; used in S3, unused in S&K
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
                ble.s   loc_84A98
                move.w  d0,(Camera_min_X_pos).w
                rts
; ---------------------------------------------------------------------------

loc_84A98:
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
                ble.s   loc_84AC6
                move.w  d0,(Camera_min_Y_pos).w
                rts
; ---------------------------------------------------------------------------

loc_84AC6:
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
                bgt.s   loc_84AF4
                move.w  d0,(Camera_max_Y_pos).w
                rts
; ---------------------------------------------------------------------------

loc_84AF4:
                move.w  (Camera_stored_max_Y_pos).w,(Camera_max_Y_pos).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Child6_IncLevX:
                dc.w    1-1
                dc.l    Obj_IncLevEndXGradual
Child6_DecLevX:                                         ; used in S3, unused in S3K
                dc.w    1-1
                dc.l    Obj_DecLevStartXGradual
Child6_DecLevY:
                dc.w    1-1
                dc.l    Obj_DecLevStartYGradual
Child6_IncLevY:
                dc.w    1-1
                dc.l    Obj_IncLevEndYGradual
