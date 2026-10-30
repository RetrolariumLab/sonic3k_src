; Owner: game/level/zones/hcz/s3
; Responsibility: Hydrocity act-one screen and background initialization, events, deformation and private geometry
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

HCZ1_ScreenInit:
                clr.w   (Events_bg+$16).w
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

HCZ1_ScreenEvent:
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

HCZ1_BackgroundInit:
                jsr     HCZ1_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                moveq   #$60,d0
                cmp.w   (Events_bg+$10).w,d0
                blt.s   loc_3C2BA
                neg.w   d0
                cmp.w   (Events_bg+$10).w,d0
                bgt.s   loc_3C2BE

loc_3C2BA:
                move.w  d0,(Events_bg+$10).w            ; Cap dynamic art reloading value at $60 either way

loc_3C2BE:
                lea     HCZ1_BGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

HCZ1_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     HCZ1_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

HCZ1_BackgroundEvent_Index:
                bra.w   HCZ1BGE_Normal
; ---------------------------------------------------------------------------
                bra.w   HCZ1BGE_DoTransition
; ---------------------------------------------------------------------------

HCZ1BGE_Normal:
                tst.w   (Events_fg_5).w
                beq.s   loc_3C336
                clr.w   (Events_fg_5).w                 ; Do transition
                movem.l d7-a0/a2-a3,-(sp)
                lea     (HCZ2_128x128_Secondary_Kos).l,a1
                lea     (RAM_start+$A00).l,a2
                jsr     (Queue_Kos).l
                lea     (HCZ2_16x16_Secondary_Kos).l,a1
                lea     (Block_table+$558).w,a2
                jsr     (Queue_Kos).l
                lea     (HCZ2_8x8_Secondary_KosM).l,a1  ; Load secondary HCZ2 art, blocks, and chunks so as to not compromise current position
                move.w  #tiles_to_bytes($11B),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_10,d0
                jsr     (Load_PLC).l
                moveq   #PLCID_11,d0
                jsr     (Load_PLC).l                    ; load HCZ 2 PLCs
                movem.l (sp)+,d7-a0/a2-a3
                st      (Events_bg+$16).w
                addq.w  #4,(Events_routine_bg).w

loc_3C336:
                jsr     HCZ1_Deform(pc)
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                lea     HCZ1_BGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

HCZ1BGE_DoTransition:
                tst.b   (Kos_modules_left).w
                bne.w   loc_3C3E6                       ; Don't do anything else until Kos queue has been cleared
                move.w  #$101,(Current_zone_and_act).w  ; Change the act
                clr.b   (Dynamic_resize_routine).w      ; Reload resize routine counter
                clr.b   (Object_load_routine).w         ; Reload sprite manager
                clr.b   (Rings_manager_routine).w       ; Reload ring manager
                clr.b   (Boss_flag).w                   ; Unlock the screen
                clr.b   (Respawn_table_keep).w          ; Refresh sprite/ring memory
                jsr     Clear_Switches(pc)
                move.l  #Obj_HCZWaterSplash,(Dynamic_object_RAM+(object_size*2)).w  ; Load the splash object
                move.b  #1,(Dynamic_object_RAM+(object_size*2)+subtype).w
                movem.l d7-a0/a2-a3,-(sp)
                jsr     (Load_Level).l                  ; Load HCZ2 layout
                jsr     (LoadSolids).l
                jsr     (CheckLevelForWater).l
                move.w  #$6A0,d0
                move.w  d0,(Water_level).w
                move.w  d0,(Mean_water_level).w
                move.w  d0,(Target_water_level).w       ; Set the water up
                moveq   #PalID_HCZ2,d0
                jsr     (LoadPalette_Immediate).l       ; Load HCZ2 palette
                movem.l (sp)+,d7-a0/a2-a3
                move.w  #$3600,d0
                moveq   #0,d1
                sub.w   d0,(Player_1+x_pos).w
                sub.w   d0,(Player_2+x_pos).w
                jsr     Offset_ObjectsDuringTransition(pc)
                sub.w   d0,(Camera_X_pos).w
                sub.w   d0,(Camera_X_pos_copy).w
                sub.w   d0,(Camera_min_X_pos).w
                sub.w   d0,(Camera_max_X_pos).w         ; Offset objects/camera position by specified amount
                jsr     Reset_TileOffsetPositionActual(pc)
                clr.w   (Events_routine_bg).w

loc_3C3E6:
                jsr     HCZ1_Deform(pc)
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                lea     HCZ1_BGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)

; =============== S U B R O U T I N E =======================================

HCZ1_Deform:
                move.w  (Camera_Y_pos_copy).w,d0        ; Get the BG camera Y position
                subi.w  #$610,d0                        ; Get the difference between that and the water line equilibrium point
                move.w  d0,d1
                asr.w   #2,d0
                move.w  d0,d2
                addi.w  #$190,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w     ; The effective BG Y is negative when the BG is above the water line, positive when otherwise
                sub.w   d1,d2                           ; The difference between the effective BG Y and the actual BG Y difference is what's used to calculate how the water line should be drawn
                move.w  d2,(Events_bg+$10).w
                move.w  (Camera_X_pos_copy).w,d0        ; Get the camera BG X
                swap    d0
                clr.w   d0
                tst.w   d2
                beq.w   loc_3C4E2                       ; If equilibrium point, branch
                move.l  d0,d1
                move.l  d0,d3                           ; Set up deformation scroll value
                asr.l   #7,d3
                moveq   #$30-1,d4
                cmpi.w  #-$60,d2
                bgt.s   loc_3C45A
                lea     (HScroll_table+$01A).w,a1       ; If background is high enough that water line doesn't have to be messed with, just apply the standard formation to it

loc_3C442:
                swap    d1
                move.w  d1,(a1)+
                swap    d1
                sub.l   d3,d1
                swap    d1
                move.w  d1,(a1)+
                swap    d1
                sub.l   d3,d1
                dbf     d4,loc_3C442
                bra.w   loc_3C4E2                       ; Then finish it up
; ---------------------------------------------------------------------------

loc_3C45A:
                lea     (HScroll_table+$19A).w,a1

loc_3C45E:
                swap    d1                              ; If background camera is lower, then apply water line deformation backwards
                move.w  d1,-(a1)
                swap    d1
                sub.l   d3,d1
                swap    d1
                move.w  d1,-(a1)
                swap    d1
                sub.l   d3,d1
                dbf     d4,loc_3C45E
                cmpi.w  #$60,d2
                bge.s   loc_3C4E2                       ; If background camera is low enough that water line doesn't need to be messed with, then end it
                lea     (HScroll_table+$0DA).w,a1
                lea     (a1),a5
                lea     (HCZ_WaterlineScroll_Data).l,a6
                move.w  d2,d1
                bmi.s   loc_3C4B6
                move.w  d1,d3                           ; If waterline is displayed below water level
                neg.w   d3
                addi.w  #$60,d3
                lsl.w   #5,d3
                adda.w  d3,a6
                add.w   d3,d3
                adda.w  d3,a6                           ; Set up area of water line scroll data to use based on position
                subq.w  #1,d1
                moveq   #0,d3
                lsr.w   #1,d1
                bcc.s   loc_3C4A8

loc_3C4A0:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),(a1)+

loc_3C4A8:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),(a1)+                 ; Apply scroll data
                dbf     d1,loc_3C4A0
                bra.s   loc_3C4E2
; ---------------------------------------------------------------------------

loc_3C4B6:
                move.w  d1,d3                           ; If waterline is displayed above water level
                addi.w  #$60,d3
                lsl.w   #5,d3
                adda.w  d3,a6
                add.w   d3,d3
                adda.w  d3,a6                           ; Set up area of water line scroll data to use based on position
                neg.w   d1
                subq.w  #1,d1
                moveq   #0,d3
                lsr.w   #1,d1
                bcc.s   loc_3C4D6

loc_3C4CE:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),-(a1)

loc_3C4D6:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),-(a1)                 ; Apply scroll data
                dbf     d1,loc_3C4CE

loc_3C4E2:
                move.l  d0,d1                           ; Get BG X again
                asr.l   #2,d0
                asr.l   #5,d1
                lea     (HScroll_table).w,a1
                swap    d0
                move.w  d0,(a1)
                move.w  d0,$18(a1)
                move.w  d0,d3
                swap    d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,2(a1)
                move.w  d0,$16(a1)
                swap    d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,4(a1)
                move.w  d0,$14(a1)
                swap    d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,6(a1)
                move.w  d0,$12(a1)
                swap    d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,8(a1)
                move.w  d0,$10(a1)
                swap    d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,$A(a1)
                move.w  d0,$E(a1)
                swap    d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,$C(a1)
                move.w  d0,$19A(a1)
                move.w  d0,d4
                tst.w   d2
                bpl.s   loc_3C570
                lea     (HScroll_table+$0DA).w,a1       ; Water line above water
                moveq   #$30-1,d0

loc_3C556:
                move.w  d4,(a1)+
                move.w  d4,(a1)+
                dbf     d0,loc_3C556
                moveq   #$60-1,d0
                add.w   d2,d0
                bmi.s   locret_3C58E
                lea     (HScroll_table+$01A).w,a1

loc_3C568:
                move.w  d3,(a1)+
                dbf     d0,loc_3C568
                bra.s   locret_3C58E
; ---------------------------------------------------------------------------

loc_3C570:
                lea     (HScroll_table+$01A).w,a1       ; Water line below water
                moveq   #$30-1,d0

loc_3C576:
                move.w  d3,(a1)+
                move.w  d3,(a1)+
                dbf     d0,loc_3C576
                moveq   #$60-1,d0
                sub.w   d2,d0
                bmi.s   locret_3C58E
                lea     (HScroll_table+$19A).w,a1

loc_3C588:
                move.w  d4,-(a1)
                dbf     d0,loc_3C588

locret_3C58E:
                rts
; End of function HCZ1_Deform

; ---------------------------------------------------------------------------
HCZ1_BGDeformArray:
                dc.w    $40,     8,     8,     5,     5,     6,   $F0,     6,     5,     5,     8,     8,   $30, $80C0, $7FFF
