; Owner: game/level/s3
; Responsibility: Competition environment palette, collision response reset, water surface height and dynamic water-level state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
Pal_Level_2P:
                binclude "data/Levels/Misc/Palettes/2P Level Secondary.bin"
                even
; ---------------------------------------------------------------------------

Obj_ResetCollisionResponseList:
                move.w  #0,(Collision_response_list).w
                rts

; =============== S U B R O U T I N E =======================================

UpdateWaterSurface:
                rts
; ---------------------------------------------------------------------------
; unused leftover from Sonic 2
                tst.b   (Water_flag).w
                beq.s   locret_50DC
                move.w  (Camera_X_pos).w,d1
                btst    #0,(Level_frame_counter+1).w
                beq.s   loc_50D2
                addi.w  #$20,d1

loc_50D2:
                move.w  d1,d0
                addi.w  #$60,d0
                addi.w  #$120,d1

locret_50DC:
                rts
; End of function UpdateWaterSurface

; =============== S U B R O U T I N E =======================================

Handle_Onscreen_Water_Height:
                tst.b   (Water_flag).w
                beq.w   loc_5146
                tst.b   (Deform_lock).w
                bne.s   loc_50FC
                cmpi.b  #6,(Player_1+routine).w
                bhs.s   loc_50FC
                bsr.w   S3HCZApplyRectangularWaterTunnelCurrentsToPlayers
                bsr.w   DynamicWaterHeight

loc_50FC:
                clr.b   (Water_full_screen_flag).w
                moveq   #0,d0
                add.w   (Mean_water_level).w,d0
                move.w  d0,(Water_level).w
                cmpi.w  #$100,(Current_zone_and_act).w
                bne.s   loc_511A
                cmpi.w  #$900,(Camera_X_pos).w
                blo.s   loc_5130

loc_511A:
                move.w  (Water_level).w,d0
                sub.w   (Camera_Y_pos).w,d0
                beq.s   loc_512A
                bcc.s   loc_5138
                tst.w   d0
                bpl.s   loc_5138

loc_512A:
                move.b  #1,(Water_full_screen_flag).w

loc_5130:
                move.b  #-1,(H_int_counter).w
                rts
; ---------------------------------------------------------------------------

loc_5138:
                cmpi.w  #$DF,d0
                blo.s   loc_5142
                move.w  #$FF,d0

loc_5142:
                move.b  d0,(H_int_counter).w

loc_5146:
                bsr.w   S3DispatchHCZ2ICZ1SurfaceMotionForBothPlayers
                rts
; End of function Handle_Onscreen_Water_Height

; ---------------------------------------------------------------------------
; unused
                clr.b   (Water_full_screen_flag).w
                move.w  (Mean_water_level).w,(Water_level).w
                move.l  #HInt3,(H_int_addr).w
                cmpi.w  #$1000,(V_blank_cycles).w
                blo.s   loc_516E
                move.l  #HInt4,(H_int_addr).w

loc_516E:
                move.w  (Water_level).w,d0
                sub.w   (Camera_Y_pos).w,d0
                beq.s   loc_5186
                bcc.s   loc_51C2
                tst.w   d0
                bpl.s   loc_51C2
                addi.w  #$1E0,d0
                beq.s   loc_5186
                bcs.s   loc_5194

loc_5186:
                move.b  #1,(Water_full_screen_flag).w
                move.b  #-1,(H_int_counter).w
                rts
; ---------------------------------------------------------------------------

loc_5194:
                cmpi.w  #$DF,d0
                blo.s   loc_519E
                move.w  #$FF,d0

loc_519E:
                move.b  d0,(H_int_counter).w
                move.b  #1,(Water_full_screen_flag).w
                move.l  #HInt5,(H_int_addr).w
                cmpi.w  #$1000,(V_blank_cycles).w
                blo.s   loc_51C0
                move.l  #HInt6,(H_int_addr).w

loc_51C0:
                bra.s   loc_51D0
; ---------------------------------------------------------------------------

loc_51C2:
                cmpi.w  #$DF,d0
                blo.s   loc_51CC
                move.w  #$FF,d0

loc_51CC:
                move.b  d0,(H_int_counter).w

loc_51D0:
                bsr.w   S3DispatchHCZ2ICZ1SurfaceMotionForBothPlayers
                rts
; ---------------------------------------------------------------------------
StartingWaterHeights:
                binclude "data/Levels/Misc/StartingWaterHeights.bin"
                even

; =============== S U B R O U T I N E =======================================

DynamicWaterHeight:
                moveq   #0,d0
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #6,d0
                andi.w  #$FFFE,d0
                move.w  DynamicWaterHeight_Index(pc,d0.w),d0
                jsr     DynamicWaterHeight_Index(pc,d0.w)
                moveq   #0,d1
                move.b  (Water_speed).w,d1
                move.w  (Target_water_level).w,d0
                sub.w   (Mean_water_level).w,d0
                beq.s   locret_5244
                bcc.s   loc_5240
                neg.w   d1

loc_5240:
                add.w   d1,(Mean_water_level).w

locret_5244:
                rts
; End of function DynamicWaterHeight

; ---------------------------------------------------------------------------
DynamicWaterHeight_Index:
                dc.w    DynamicWaterHeight_AIZ1-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_AIZ2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_HCZ1-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_HCZ2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_LBZ1-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Ending-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
                dc.w    DynamicWaterHeight_Null2-DynamicWaterHeight_Index
; ---------------------------------------------------------------------------

DynamicWaterHeight_AIZ1:
                rts
; ---------------------------------------------------------------------------

DynamicWaterHeight_AIZ2:
                cmpi.w  #$820,(Camera_target_max_Y_pos).w
                beq.s   locret_5306
                cmpi.w  #$2440,(Camera_X_pos).w
                bhs.s   loc_52AE
                cmpi.w  #$618,(Target_water_level).w
                bne.s   locret_5306
                move.w  #$528,(Target_water_level).w
                move.b  #2,(Water_speed).w
                rts
; ---------------------------------------------------------------------------

loc_52AE:
                tst.b   (Level_trigger_array).w
                bne.s   loc_52C2
                cmpi.w  #$2850,(Camera_X_pos).w
                blo.s   locret_5306
                move.b  #1,(Level_trigger_array).w

loc_52C2:
                cmpi.w  #$618,(Target_water_level).w
                beq.s   locret_5306
                cmpi.w  #$2900,(Camera_X_pos).w
                bhs.s   loc_52EC
                move.w  #-1,(Screen_shake_flag).w
                jsr     (AllocateObject).l
                bne.s   loc_52EC
                move.l  #Obj_5308,(a1)
                move.b  #180,anim_frame_timer(a1)

loc_52EC:
                lea     (Level_layout_main+$1C).w,a3
                moveq   #4-1,d1

loc_52F2:
                movea.w (a3),a1
                move.b  #0,$4E(a1)
                addq.w  #4,a3
                dbf     d1,loc_52F2
                move.w  #$618,(Target_water_level).w

locret_5306:
                rts
; ---------------------------------------------------------------------------

Obj_5308:
                subq.b  #1,anim_frame_timer(a0)
                beq.s   loc_5310
                rts
; ---------------------------------------------------------------------------

loc_5310:
                move.w  #0,(Screen_shake_flag).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

DynamicWaterHeight_HCZ1:
                lea     (word_5324).l,a1
                bra.s   loc_537C
; ---------------------------------------------------------------------------
word_5324:
                dc.w    $8500,  $900
                dc.w    $8680, $2A00
                dc.w    $8680, $3500
                dc.w    $86A0, $FFFF
; ---------------------------------------------------------------------------

DynamicWaterHeight_HCZ2:
                tst.b   (_unkFAA2).w
                beq.s   loc_533C
                rts
; ---------------------------------------------------------------------------

loc_533C:
                lea     (word_5344).l,a1
                bra.s   loc_537C
; ---------------------------------------------------------------------------
word_5344:
                dc.w    $700, $3E00
                dc.w    $7E0, $FFFF
; ---------------------------------------------------------------------------

DynamicWaterHeight_Null:
                rts
; ---------------------------------------------------------------------------

DynamicWaterHeight_LBZ1:
                lea     (word_5356).l,a1
                bra.s   loc_537C
; ---------------------------------------------------------------------------
word_5356:
                dc.w    $8B00,  $E00
                dc.w    $8A00, $1980
                dc.w    $8A00, $2340
                dc.w    $8AC8, $2C00
                dc.w    $8FF0, $FFFF
; ---------------------------------------------------------------------------

DynamicWaterHeight_Null2:
                rts
; ---------------------------------------------------------------------------

DynamicWaterHeight_Ending:
                cmpi.w  #$1DE0,(Camera_X_pos).w
                blo.s   locret_537A
                move.w  #$510,(Target_water_level).w

locret_537A:
                rts
; ---------------------------------------------------------------------------

loc_537C:
                move.w  (Camera_X_pos).w,d0

loc_5380:
                move.l  (a1)+,d1
                cmp.w   d1,d0
                bhi.s   loc_5380
                swap    d1
                tst.w   d1
                bpl.s   loc_5394
                andi.w  #$7FFF,d1
                move.w  d1,(Mean_water_level).w

loc_5394:
                move.w  d1,(Target_water_level).w
                rts
