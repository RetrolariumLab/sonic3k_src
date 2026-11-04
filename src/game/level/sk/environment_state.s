; Owner: game/level/sk
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

Handle_Onscreen_Water_Height:
                tst.b   (Water_flag).w
                beq.w   loc_6C9C
                tst.b   (Deform_lock).w
                bne.s   loc_6C52
                cmpi.b  #6,(Player_1+routine).w
                bhs.s   loc_6C52
                bsr.w   SKHCZ_ApplyWaterTunnelCurrents
                bsr.w   DynamicWaterHeight

loc_6C52:
                clr.b   (Water_full_screen_flag).w
                moveq   #0,d0
                add.w   (Mean_water_level).w,d0
                move.w  d0,(Water_level).w
                cmpi.w  #$100,(Current_zone_and_act).w
                bne.s   loc_6C70
                cmpi.w  #$900,(Camera_X_pos).w
                blo.s   loc_6C86

loc_6C70:
                move.w  (Water_level).w,d0
                sub.w   (Camera_Y_pos).w,d0
                beq.s   loc_6C80
                bcc.s   loc_6C8E
                tst.w   d0
                bpl.s   loc_6C8E

loc_6C80:
                move.b  #1,(Water_full_screen_flag).w

loc_6C86:
                move.b  #-1,(H_int_counter).w
                rts
; ---------------------------------------------------------------------------

loc_6C8E:
                cmpi.w  #$DF,d0
                blo.s   loc_6C98
                move.w  #$FF,d0

loc_6C98:
                move.b  d0,(H_int_counter).w

loc_6C9C:
                bsr.w   SKSurface_DispatchBothPlayers
                rts
; End of function Handle_Onscreen_Water_Height

; ---------------------------------------------------------------------------
; unused
                clr.b   (Water_full_screen_flag).w
                move.w  (Mean_water_level).w,(Water_level).w
                move.l  #HInt3,(H_int_addr).w
                cmpi.w  #$1000,(V_blank_cycles).w
                blo.s   loc_6CC4
                move.l  #HInt4,(H_int_addr).w

loc_6CC4:
                move.w  (Water_level).w,d0
                sub.w   (Camera_Y_pos).w,d0
                beq.s   loc_6CDC
                bcc.s   loc_6D18
                tst.w   d0
                bpl.s   loc_6D18
                addi.w  #$1E0,d0
                beq.s   loc_6CDC
                bcs.s   loc_6CEA

loc_6CDC:
                move.b  #1,(Water_full_screen_flag).w
                move.b  #-1,(H_int_counter).w
                rts
; ---------------------------------------------------------------------------

loc_6CEA:
                cmpi.w  #$DF,d0
                blo.s   loc_6CF4
                move.w  #$FF,d0

loc_6CF4:
                move.b  d0,(H_int_counter).w
                move.b  #1,(Water_full_screen_flag).w
                move.l  #HInt5,(H_int_addr).w
                cmpi.w  #$1000,(V_blank_cycles).w
                blo.s   loc_6D16
                move.l  #HInt6,(H_int_addr).w

loc_6D16:
                bra.s   loc_6D26
; ---------------------------------------------------------------------------

loc_6D18:
                cmpi.w  #$DF,d0
                blo.s   loc_6D22
                move.w  #$FF,d0

loc_6D22:
                move.b  d0,(H_int_counter).w

loc_6D26:
                bsr.w   SKSurface_DispatchBothPlayers
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
                beq.s   locret_6D9A
                bcc.s   loc_6D96
                neg.w   d1

loc_6D96:
                add.w   d1,(Mean_water_level).w

locret_6D9A:
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
                dc.w    DynamicWaterHeight_LBZ2-DynamicWaterHeight_Index
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
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_6DF6
                cmpi.w  #$820,(Camera_target_max_Y_pos).w
                beq.s   locret_6E6C
                cmpi.w  #$3B60,(Camera_X_pos).w
                bhs.s   locret_6E6C

loc_6DF6:
                cmpi.w  #$2440,(Camera_X_pos).w
                bhs.s   loc_6E14
                cmpi.w  #$618,(Target_water_level).w
                bne.s   locret_6E6C
                move.w  #$528,(Target_water_level).w
                move.b  #2,(Water_speed).w
                rts
; ---------------------------------------------------------------------------

loc_6E14:
                tst.b   (Level_trigger_array).w
                bne.s   loc_6E28
                cmpi.w  #$2850,(Camera_X_pos).w
                blo.s   locret_6E6C
                move.b  #1,(Level_trigger_array).w

loc_6E28:
                cmpi.w  #$618,(Target_water_level).w
                beq.s   locret_6E6C
                cmpi.w  #$2900,(Camera_X_pos).w
                bhs.s   loc_6E52
                move.w  #-1,(Screen_shake_flag).w
                jsr     (AllocateObject).l
                bne.s   loc_6E52
                move.l  #Obj_6E6E,(a1)
                move.b  #180,anim_frame_timer(a1)

loc_6E52:
                lea     (Level_layout_main+$1C).w,a3
                moveq   #4-1,d1

loc_6E58:
                movea.w (a3),a1
                move.b  #0,$4E(a1)
                addq.w  #4,a3
                dbf     d1,loc_6E58
                move.w  #$618,(Target_water_level).w

locret_6E6C:
                rts
; ---------------------------------------------------------------------------

Obj_6E6E:
                subq.b  #1,anim_frame_timer(a0)
                beq.s   loc_6E76
                rts
; ---------------------------------------------------------------------------

loc_6E76:
                move.w  #0,(Screen_shake_flag).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

DynamicWaterHeight_HCZ1:
                lea     (word_6E8C).l,a1
                bra.w   loc_6F2C
; ---------------------------------------------------------------------------
word_6E8C:
                dc.w    $8500,  $900
                dc.w    $8680, $2A00
                dc.w    $8680, $3500
                dc.w    $86A0, $FFFF
; ---------------------------------------------------------------------------

DynamicWaterHeight_HCZ2:
                tst.b   (_unkFAA2).w
                beq.s   loc_6EA4
                rts
; ---------------------------------------------------------------------------

loc_6EA4:
                lea     (word_6EBA).l,a1
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_6F2C
                lea     (word_6EC2).l,a1
                bra.s   loc_6F2C
; ---------------------------------------------------------------------------
word_6EBA:
                dc.w    $700, $3E00
                dc.w    $7E0, $FFFF
word_6EC2:
                dc.w    $700, $4100
                dc.w    $8360, $FFFF
; ---------------------------------------------------------------------------

DynamicWaterHeight_Null:
                rts
; ---------------------------------------------------------------------------

DynamicWaterHeight_LBZ1:
                lea     (word_6ED4).l,a1
                bra.s   loc_6F2C
; ---------------------------------------------------------------------------
word_6ED4:
                dc.w    $8B00,  $E00
                dc.w    $8A00, $1980
                dc.w    $8A00, $2340
                dc.w    $8AC8, $2C00
                dc.w    $8FF0, $FFFF
; ---------------------------------------------------------------------------

DynamicWaterHeight_LBZ2:
                cmpi.w  #3,(Player_mode).w
                beq.s   loc_6EF2
                rts
; ---------------------------------------------------------------------------

loc_6EF2:
                tst.b   (_unkF7C2).w
                bne.s   loc_6F00
                lea     (word_6F12).l,a1
                bra.s   loc_6F2C
; ---------------------------------------------------------------------------

loc_6F00:
                move.w  (Camera_Y_pos).w,d0
                cmp.w   (Mean_water_level).w,d0
                blo.s   locret_6F10
                move.w  #$660,(Mean_water_level).w

locret_6F10:
                rts
; ---------------------------------------------------------------------------
word_6F12:
                dc.w    $8FF0,  $D80
                dc.w    $8B20, $FFFF
; ---------------------------------------------------------------------------

DynamicWaterHeight_Null2:
                rts
; ---------------------------------------------------------------------------

DynamicWaterHeight_Ending:
                cmpi.w  #$1DE0,(Camera_X_pos).w
                blo.s   locret_6F2A
                move.w  #$510,(Target_water_level).w

locret_6F2A:
                rts
; ---------------------------------------------------------------------------

loc_6F2C:
                move.w  (Camera_X_pos).w,d0

loc_6F30:
                move.l  (a1)+,d1
                cmp.w   d1,d0
                bhi.s   loc_6F30
                swap    d1
                tst.w   d1
                bpl.s   loc_6F44
                andi.w  #$7FFF,d1
                move.w  d1,(Mean_water_level).w

loc_6F44:
                move.w  d1,(Target_water_level).w
                rts
