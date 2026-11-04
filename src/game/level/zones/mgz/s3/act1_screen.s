; Owner: game/level/zones/mgz/s3
; Responsibility: Marble Garden act-one screen and background initialization, events, deformation and private geometry
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

MGZ1_ScreenInit:
                clr.w   (Events_bg+$16).w
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

MGZ1_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                jsr     Do_ShakeSound(pc)
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

MGZ1_BackgroundInit:
                jsr     MGZ1_Deform(pc)
                moveq   #0,d0
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                lea     MGZ1_BGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

MGZ1_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     MGZ1_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

MGZ1_BackgroundEvent_Index:
                bra.w   MGZ1BGE_Normal
; ---------------------------------------------------------------------------
                bra.w   MGZ1BGE_Transition
; ---------------------------------------------------------------------------

MGZ1BGE_Normal:
                tst.w   (Events_fg_5).w
                beq.s   S3MGZ1Screen_ApplyBgDeformAndShake
                clr.w   (Events_fg_5).w                 ; Transition time
                movem.l d7-a0/a2-a3,-(sp)
                lea     (MGZ2_128x128_Secondary_Kos).l,a1
                lea     (RAM_start+$6B00).l,a2
                jsr     (Queue_Kos).l
                lea     (MGZ2_16x16_Secondary_Kos).l,a1
                lea     (Block_table+$C60).w,a2
                jsr     (Queue_Kos).l
                lea     (MGZ2_8x8_Secondary_KosM).l,a1
                move.w  #tiles_to_bytes($252),d2
                jsr     (Queue_Kos_Module).l            ; Queue art, blocks and chunks for act 2
                moveq   #PLCID_14,d0
                jsr     (Load_PLC).l                    ; Load act 2 PLCs
                movem.l (sp)+,d7-a0/a2-a3
                addq.w  #4,(Events_routine_bg).w

S3MGZ1Screen_ApplyBgDeformAndShake:
                jsr     MGZ1_Deform(pc)                 ; Pretty self-explanatory to be honest
                lea     MGZ1_BGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jsr     ApplyDeformation(pc)
                jmp     ShakeScreen_Setup(pc)
; ---------------------------------------------------------------------------

MGZ1BGE_Transition:
                tst.b   (Kos_modules_left).w
                bne.w   S3MGZ1Screen_DrawBgDuringActChange  ; Wait for Kos queue to finish
                move.w  #$201,(Current_zone_and_act).w  ; Change act
                clr.b   (Dynamic_resize_routine).w
                clr.b   (Object_load_routine).w
                clr.b   (Rings_manager_routine).w
                clr.b   (Boss_flag).w
                clr.b   (Respawn_table_keep).w          ; Reset various managers
                jsr     Clear_Switches(pc)
                movem.l d7-a0/a2-a3,-(sp)
                jsr     (Load_Level).l
                jsr     (LoadSolids).l
                moveq   #PalID_MGZ2,d0
                jsr     (LoadPalette_Immediate).l
                movem.l (sp)+,d7-a0/a2-a3
                move.w  #$2E00,d0
                move.w  #$600,d1
                sub.w   d0,(Player_1+x_pos).w
                sub.w   d1,(Player_1+y_pos).w
                sub.w   d0,(Player_2+x_pos).w
                sub.w   d1,(Player_2+y_pos).w
                jsr     Offset_ObjectsDuringTransition(pc)
                sub.w   d0,(Camera_X_pos).w
                sub.w   d1,(Camera_Y_pos).w
                sub.w   d0,(Camera_X_pos_copy).w
                sub.w   d1,(Camera_Y_pos_copy).w
                sub.w   d0,(Camera_min_X_pos).w
                sub.w   d0,(Camera_max_X_pos).w
                sub.w   d1,(Camera_min_Y_pos).w
                sub.w   d1,(Camera_max_Y_pos).w
                move.w  (Camera_max_Y_pos).w,(Camera_target_max_Y_pos).w
                jsr     Reset_TileOffsetPositionActual(pc)
                clr.l   (Events_bg+$10).w
                clr.w   (Events_bg+$14).w
                clr.w   (_unkEEA2).w
                clr.w   (Events_routine_bg).w           ; Clear flags/values used for BG stuff in act 2

S3MGZ1Screen_DrawBgDuringActChange:
                jsr     MGZ1_Deform(pc)
                lea     MGZ1_BGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)

; =============== S U B R O U T I N E =======================================

MGZ1_Deform:
                move.w  (Screen_shake_offset).w,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                asr.l   #2,d0
                move.l  d0,d1
                asr.l   #4,d1
                lea     (HScroll_table+$01C).w,a1
                moveq   #9-1,d2

S3MGZ1Screen_WriteParallaxWords:
                swap    d0
                move.w  d0,-(a1)
                swap    d0
                sub.l   d1,d0
                dbf     d2,S3MGZ1Screen_WriteParallaxWords
                lea     (HScroll_table).w,a1
                move.l  (HScroll_table+$01C).w,d2
                addi.l  #$500,(HScroll_table+$01C).w
                asr.l   #1,d0
                moveq   #5-1,d3

S3MGZ1Screen_WriteFgScrollPairs:
                add.l   d2,d0
                addi.l  #$500,d2
                swap    d0
                move.w  d0,(a1)+
                swap    d0
                add.l   d1,d0
                dbf     d3,S3MGZ1Screen_WriteFgScrollPairs
                move.w  -2(a1),d0
                move.w  -4(a1),-2(a1)
                move.w  d0,-4(a1)
                rts
; End of function MGZ1_Deform

; =============== S U B R O U T I N E =======================================

Do_ShakeSound:
                cmpi.b  #6,(Player_1+routine).w
                bhs.s   .return                         ; If dying, skip this
                tst.w   (Events_bg+$16).w
                bne.s   .return                         ; If flag is set, skip this
                tst.w   (Screen_shake_flag).w
                bpl.s   .return                         ; If screen is not shaking continuously, skip this
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   .return
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l

                .return:
                rts
; End of function Do_ShakeSound

; ---------------------------------------------------------------------------
MGZ1_BGDeformArray:
                dc.w    $10,     4,     4,     8,     8,     8,    $D,   $13,     8,     8,     8,     8,   $18, $7FFF
