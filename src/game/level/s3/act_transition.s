; Owner: game/level/s3
; Responsibility: Change to second-act bounds and construct level-size transition actors or restart the level
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Change_Act2Sizes:
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                lsl.w   #4,d0
                lea     (LevelSizes).l,a1
                lea     8(a1,d0.w),a1                   ; Get level sizes for act 2
                move.w  (a1)+,(Camera_stored_min_X_pos).w
                move.w  (a1)+,(Camera_stored_max_X_pos).w
                move.w  (a1)+,(Camera_stored_min_Y_pos).w
                move.w  (a1)+,d1
                move.w  d1,(Camera_stored_max_Y_pos).w  ; Put level sizes into the target size memory
                move.w  d1,(Camera_target_max_Y_pos).w
                cmpi.b  #$10,d0
                beq.w   S3Return_AttrSetup              ; If we're in HCZ, don't immediately apply these changes. There's another event to do
; End of function Change_Act2Sizes

; =============== S U B R O U T I N E =======================================

Make_LevelSizeObj:
                lea     Child1_Act2LevelSize(pc),a2
                jmp     CreateChild1_Normal(pc)
; End of function Make_LevelSizeObj

; ---------------------------------------------------------------------------
Child1_Act2LevelSize:
                dc.w    3-1
                dc.l    Obj_IncLevEndXGradual
                dc.b    0,   0
                dc.l    Obj_DecLevStartYGradual
                dc.b    0,   0
                dc.l    Obj_IncLevEndYGradual
                dc.b    0,   0

; =============== S U B R O U T I N E =======================================

StartNewLevel:
                move.w  d0,(Current_zone_and_act).w
                move.w  d0,(Apparent_zone_and_act).w
                move.w  #1,(Restart_level_flag).w
                clr.b   (Last_star_post_hit).w
                clr.b   (Special_bonus_entry_flag).w
                rts
; End of function StartNewLevel
