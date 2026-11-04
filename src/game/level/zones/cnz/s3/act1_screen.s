; Owner: game/level/zones/cnz/s3
; Responsibility: Carnival Night act-one screen and background control, deformation and miniboss scroll objects
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CNZ1_ScreenInit:
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

CNZ1_ScreenEvent:
                tst.w   (Events_bg+$06).w
                beq.s   S3CNZ1Screen_DrawFgAndTryRemoveArena
                clr.w   (Events_bg+$06).w
                jmp     Refresh_PlaneScreenDirect(pc)
; ---------------------------------------------------------------------------

S3CNZ1Screen_DrawFgAndTryRemoveArena:
                jsr     DrawTilesAsYouMove(pc)
                lea     (Events_bg+$00).w,a5
                tst.l   (a5)
                beq.w   S3CNZ1Screen_ArenaRemovalReturn
                move.w  (a5)+,d0                        ; All this below is for removing chunks from the miniboss arena
                move.w  (a5),d1
                clr.l   -2(a5)
                move.w  d0,d2
                move.w  d1,d3
                asr.w   #3,d2
                move.w  d2,d4
                asr.w   #4,d2
                move.w  d3,d5
                asr.w   #5,d3
                and.w   (Layout_row_index_mask).w,d3
                movea.w (a3,d3.w),a4
                moveq   #-1,d6
                clr.w   d6
                move.b  (a4,d2.w),d6
                lsl.w   #7,d6
                andi.w  #$C,d4
                andi.w  #$60,d5
                add.w   d4,d6
                add.w   d5,d6
                movea.l d6,a4
                clr.l   (a4)
                clr.l   $10(a4)                         ; Clear the necessary parts of the chunks
                asr.w   #2,d0
                andi.w  #$78,d0
                lsl.w   #4,d1
                andi.w  #$E00,d1
                add.w   d1,d0
                add.w   d7,d0
                moveq   #0,d1
                move.w  d0,(a0)+
                move.w  #1,(a0)+
                move.l  d1,(a0)+
                move.l  d1,(a0)+
                move.l  d1,(a0)+
                move.l  d1,(a0)+
                addi.w  #$100,d0
                move.w  d0,(a0)+
                move.w  #1,(a0)+
                move.l  d1,(a0)+
                move.l  d1,(a0)+
                move.l  d1,(a0)+
                move.l  d1,(a0)+                        ; Add a VRAM write to remove it from the screen
                clr.w   (a0)
                movea.w $18(a3),a4
                lea     $64(a4),a4                      ; Level layout $300 Y $3200 X (the boss arena blocks)
                moveq   #0,d1
                clr.w   (Events_bg+$04).w
                moveq   #4-1,d3

S3CNZ1Screen_ScanNextArenaBand:
                lea     (a4),a5
                moveq   #2,d2

S3CNZ1Screen_CheckArenaBandEmpty:
                moveq   #-1,d0
                clr.w   d0
                move.b  (a5)+,d0
                lsl.w   #7,d0
                add.w   d1,d0
                movea.l d0,a6
                tst.l   (a6)+
                bne.s   S3CNZ1Screen_ArenaRemovalReturn
                tst.l   (a6)+
                bne.s   S3CNZ1Screen_ArenaRemovalReturn
                tst.l   (a6)+
                bne.s   S3CNZ1Screen_ArenaRemovalReturn
                tst.l   (a6)
                bne.s   S3CNZ1Screen_ArenaRemovalReturn
                dbf     d2,S3CNZ1Screen_CheckArenaBandEmpty
                addi.w  #$20,d1                         ; Basically, if a line of blocks is completely destroyed, the boss is lowered by $20 pixels to compensate
                addi.w  #$20,(Events_bg+$04).w
                dbf     d3,S3CNZ1Screen_ScanNextArenaBand

S3CNZ1Screen_ArenaRemovalReturn:
                rts
; ---------------------------------------------------------------------------

CNZ1_BackgroundInit:
                jsr     CNZ1_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                lea     CNZ1_BGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

CNZ1_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     CNZ1_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

CNZ1_BackgroundEvent_Index:
                bra.w   CNZ1BGE_Normal
; ---------------------------------------------------------------------------
                bra.w   CNZ1BGE_BossStart
; ---------------------------------------------------------------------------
                bra.w   CNZ1BGE_Boss
; ---------------------------------------------------------------------------
                bra.w   CNZ1BGE_AfterBoss
; ---------------------------------------------------------------------------
                bra.w   CNZ1BGE_FGRefresh
; ---------------------------------------------------------------------------
                bra.w   CNZ1BGE_FGRefresh2
; ---------------------------------------------------------------------------
                bra.w   CNZ1BGE_DoTransition
; ---------------------------------------------------------------------------

CNZ1BGE_Normal:
                cmpi.w  #$3000,(Camera_X_pos_copy).w
                blo.s   S3CNZ1Screen_DrawNormalParallaxRow
                cmpi.w  #$54C,(Camera_Y_pos_copy).w
                blo.s   S3CNZ1Screen_EnterBossBackground
                move.w  #$700,d0                        ; This is positional adjustment for Knuckles' path
                sub.w   d0,(Player_1+y_pos).w
                sub.w   d0,(Player_2+y_pos).w
                sub.w   d0,(Camera_Y_pos).w
                sub.w   d0,(Camera_Y_pos_copy).w
                jsr     Reset_TileOffsetPositionActual(pc)

S3CNZ1Screen_EnterBossBackground:
                jsr     CNZ1_BossLevelScroll(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                lea     (Pal_CNZMiniboss).l,a1
                jsr     (PalLoad_Line1).l
                move.w  #$1C0,d0
                move.w  d0,(Camera_min_Y_pos).w         ; Change level start Y
                move.w  d0,(Camera_target_min_Y_pos).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   S3CNZ1Screen_DrawBossBackground
; ---------------------------------------------------------------------------

S3CNZ1Screen_DrawNormalParallaxRow:
                jsr     CNZ1_Deform(pc)
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                lea     CNZ1_BGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

CNZ1BGE_BossStart:
                jsr     CNZ1_BossLevelScroll(pc)

S3CNZ1Screen_DrawBossBackground:
                jsr     DrawBGAsYouMove(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

CNZ1BGE_Boss:
                jsr     CNZ1_BossLevelScroll2(pc)
                lea     (Camera_X_pos_BG_copy).w,a6
                lea     (Camera_X_pos_BG_rounded).w,a5
                move.w  #$200,d1
                moveq   #$10,d6
                jsr     Draw_TileColumn(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

CNZ1BGE_AfterBoss:
                tst.w   (Events_fg_5).w
                bne.s   S3CNZ1Screen_BeginPostBossFgRefresh
                jsr     CNZ1_BossLevelScroll2(pc)
                jsr     DrawBGAsYouMove(pc)
                jsr     PlainDeformation(pc)
                jmp     Get_BGActualEffectiveDiff(pc)
; ---------------------------------------------------------------------------

S3CNZ1Screen_BeginPostBossFgRefresh:
                clr.w   (Events_fg_5).w                 ; When signaled
                move.w  #$2F0,(Draw_delayed_position).w  ; Set refresh position
                move.w  #$F,(Draw_delayed_rowcount).w   ; Refresh number
                addq.w  #4,(Events_routine_bg).w

CNZ1BGE_FGRefresh:
                move.w  #VRAM_Plane_A_Name_Table,d7
                moveq   #0,d1
                move.w  #$200,d2
                jsr     Draw_PlaneVertSingleBottomUp(pc)  ; Refresh the foreground using BG chunks
                bmi.s   S3CNZ1Screen_SetArenaLayoutCopy
                move.w  #VRAM_Plane_B_Name_Table,d7
                jsr     CNZ1_BossLevelScroll2(pc)
                jsr     DrawBGAsYouMove(pc)
                jsr     PlainDeformation(pc)
                jmp     Get_BGActualEffectiveDiff(pc)
; ---------------------------------------------------------------------------

S3CNZ1Screen_SetArenaLayoutCopy:
                movea.w $C(a3),a1                       ; $180 Y of BG
                addq.w  #4,a1                           ; $200 X of BG
                move.w  -8(a3),d0                       ; Get X size of BG
                subq.w  #5,d0
                movea.w $12(a3),a5                      ; $280 Y of FG
                lea     $63(a5),a5                      ; $3180 of FG
                move.w  -$A(a3),d1                      ; Get X size of FG
                subq.w  #5,d1
                moveq   #6-1,d2

S3CNZ1Screen_CopyArenaLayoutRow:
                move.b  (a1)+,(a5)+                     ; Replace 5x5 portion of Foreground with equivalent from BG. Basically,
                move.b  (a1)+,(a5)+                     ; transferring the actual layout to the FG for use with collision
                move.b  (a1)+,(a5)+
                move.b  (a1)+,(a5)+
                move.b  (a1)+,(a5)+
                adda.w  d0,a1
                adda.w  d1,a5
                dbf     d2,S3CNZ1Screen_CopyArenaLayoutRow
                clr.b   (Background_collision_flag).w   ; Turn off BG collision
                clr.w   (Events_bg+$08).w               ; Turn off scrolling
                move.w  #$1C0,d0
                add.w   d0,(Player_1+y_pos).w           ; Move players and camera to position
                add.w   d0,(Player_2+y_pos).w
                add.w   d0,(Camera_Y_pos).w
                add.w   d0,(Camera_Y_pos_copy).w
                jsr     Reset_TileOffsetPositionActual(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w    ; Set up refresh position
                move.w  #$F,(Draw_delayed_rowcount).w   ; Refresh amount
                addq.w  #4,(Events_routine_bg).w

CNZ1BGE_FGRefresh2:
                lea     (Level_layout_main).w,a3
                move.w  #VRAM_Plane_A_Name_Table,d7
                move.w  (Camera_X_pos_copy).w,d1
                move.w  (Camera_Y_pos_copy).w,d2
                jsr     Draw_PlaneVertSingleBottomUp(pc)  ; Refresh the FG using FG chunks this time
                bmi.s   S3CNZ1Screen_TrySpawnEndSign
                addq.w  #2,a3
                move.w  #VRAM_Plane_B_Name_Table,d7
                jsr     CNZ1_BossLevelScroll2(pc)
                jsr     DrawBGAsYouMove(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

S3CNZ1Screen_TrySpawnEndSign:
                addq.w  #2,a3
                move.w  #VRAM_Plane_B_Name_Table,d7
                jsr     (AllocateObject).l
                bne.s   S3CNZ1Screen_EnterActTransitionWait
                move.l  #Obj_EndSign,(a1)
                move.w  #$32C0,x_pos(a1)                ; Set up the end sign

S3CNZ1Screen_EnterActTransitionWait:
                addq.w  #4,(Events_routine_bg).w

CNZ1BGE_DoTransition:
                tst.w   (Events_fg_5).w
                beq.w   S3CNZ1Screen_DrawOldBossScroll  ; Don't do anything until signpost lands
                clr.w   (Events_fg_5).w
                movem.l d7-a0/a2-a3,-(sp)
                moveq   #PLCID_18,d0
                jsr     (Load_PLC).l
                moveq   #PLCID_19,d0
                jsr     (Load_PLC).l                    ; Load CNZ 2 PLCs
                move.w  #$301,(Current_zone_and_act).w  ; Change to act 2
                clr.b   (Dynamic_resize_routine).w
                clr.b   (Object_load_routine).w
                clr.b   (Rings_manager_routine).w
                clr.b   (Boss_flag).w
                clr.b   (Respawn_table_keep).w          ; Reset various managers
                jsr     Clear_Switches(pc)
                jsr     (Load_Level).l
                jsr     (LoadSolids).l
                jsr     (CheckLevelForWater).l          ; Level stuff, etc
                move.w  #$8014,(VDP_control_port).l     ; Turn HInt on for water
                moveq   #PalID_CNZ2,d0
                jsr     (LoadPalette_Immediate).l       ; Load CNZ palette
                movem.l (sp)+,d7-a0/a2-a3
                move.w  #$3000,d0
                move.w  #-$200,d1
                sub.w   d0,(Player_1+x_pos).w
                sub.w   d1,(Player_1+y_pos).w
                sub.w   d0,(Player_2+x_pos).w
                sub.w   d1,(Player_2+y_pos).w           ; Offset object/player positions
                jsr     Offset_ObjectsDuringTransition(pc)
                sub.w   d0,(Camera_X_pos).w
                sub.w   d1,(Camera_Y_pos).w
                sub.w   d0,(Camera_X_pos_copy).w
                sub.w   d1,(Camera_Y_pos_copy).w        ; Offset camera positions
                sub.w   d0,(Camera_min_X_pos).w
                sub.w   d0,(Camera_max_X_pos).w
                sub.w   d1,(Camera_min_Y_pos).w
                sub.w   d1,(Camera_max_Y_pos).w         ; Offset level start/ends
                move.w  (Camera_max_Y_pos).w,(Camera_target_max_Y_pos).w
                jsr     Reset_TileOffsetPositionActual(pc)
                move.w  #$2F0,(Draw_delayed_position).w  ; Set up refresh
                move.w  #$F,(Draw_delayed_rowcount).w
                clr.w   (Events_routine_bg).w

S3CNZ1Screen_DrawOldBossScroll:
                jsr     CNZ1_BossLevelScroll2(pc)
                jsr     DrawBGAsYouMove(pc)
                jmp     PlainDeformation(pc)

; =============== S U B R O U T I N E =======================================

CNZ1_Deform:
                move.w  (Camera_Y_pos_copy).w,d0
                swap    d0
                clr.w   d0
                asr.l   #4,d0
                move.l  d0,d1
                asr.l   #1,d1
                add.l   d1,d0
                asr.l   #2,d1
                add.l   d1,d0
                swap    d0
                move.w  d0,(Camera_Y_pos_BG_copy).w     ; Effective BG Y is about 1/10th (13/128ths to be exact) of camera Y
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d1
                asr.l   #3,d1
                lea     (HScroll_table+$00A).w,a1
                swap    d0
                move.w  d0,-(a1)
                swap    d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,(Camera_X_pos_BG_copy).w     ; Effective BG X is 7/16th speed of normal camera
                move.w  d0,-(a1)
                swap    d0
                sub.l   d1,d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,(Events_bg+$10).w            ; Dynamic art reload BG speed is 5/16th of normal camera
                swap    d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,-(a1)
                swap    d0
                sub.l   d1,d0
                sub.l   d1,d0
                swap    d0
                move.w  d0,-(a1)
                swap    d0
                sub.l   d1,d0
                asr.l   #1,d1
                sub.l   d1,d0
                swap    d0
                move.w  d0,-(a1)
                rts
; End of function CNZ1_Deform

; =============== S U B R O U T I N E =======================================

CNZ1_BossLevelScroll:
                cmpi.w  #$1E0,(Camera_Y_pos_BG_copy).w
                blo.s   CNZ1_BossLevelScroll2
                addq.w  #4,(Events_routine_bg).w

CNZ1_BossLevelScroll2:
                move.w  (Camera_Y_pos_copy).w,d0
                subi.w  #$100,d0
                add.w   (Events_bg+$08).w,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                subi.w  #$2F80,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                rts
; End of function CNZ1_BossLevelScroll

; ---------------------------------------------------------------------------

Obj_CNZMinibossScrollControl:
                moveq   #0,d0
                move.b  routine(a0),d0
                jmp     CNZMinibossScrollControl_Index(pc,d0.w)
; ---------------------------------------------------------------------------

CNZMinibossScrollControl_Index:
                bra.w   Obj_CNZMinibossScrollInit
; ---------------------------------------------------------------------------
                bra.w   Obj_CNZMinibossScrollMain
; ---------------------------------------------------------------------------
                bra.w   Obj_CNZMinibossScrollWait
; ---------------------------------------------------------------------------
                bra.w   Obj_CNZMinibossScrollSlow
; ---------------------------------------------------------------------------
                bra.w   Obj_CNZMinibossScrollWait2
; ---------------------------------------------------------------------------
                bra.w   Obj_CNZMinibossScrollWait3
; ---------------------------------------------------------------------------

Obj_CNZMinibossScrollInit:
                lea     (Level_layout_main).w,a3
                movea.w $14(a3),a1                      ; $280 Y
                move.b  $63(a1),d0                      ; $3180 X chunk
                suba.w  -8(a3),a1
                move.b  d0,$63(a1)                      ; Replace FG layout piece
                addq.w  #2,a3
                movea.w (a3),a1
                move.b  4(a1),d0
                move.w  -8(a3),d1
                adda.w  d1,a1
                move.b  d0,4(a1)
                adda.w  d1,a1
                move.b  d0,4(a1)                        ; Replace BG layout piece
                addq.b  #4,routine(a0)

Obj_CNZMinibossScrollMain:
                tst.w   (Events_fg_5).w
                bne.s   S3CNZ1Screen_BeginScrollAlignment
                move.l  (Events_bg+$0C).w,d0            ; Speed up scroll
                cmpi.l  #$40000,d0
                bhs.s   S3CNZ1Screen_IntegrateMinibossScroll
                addi.l  #$200,d0
                move.l  d0,(Events_bg+$0C).w

S3CNZ1Screen_IntegrateMinibossScroll:
                add.l   d0,(Events_bg+$08).w            ; Set BG scrolling speed
                rts
; ---------------------------------------------------------------------------

S3CNZ1Screen_BeginScrollAlignment:
                clr.w   (Events_fg_5).w                 ; When boss is completed
                addq.b  #4,routine(a0)

Obj_CNZMinibossScrollWait:
                move.w  (Events_bg+$08).w,d0
                andi.w  #$FF,d0
                cmpi.w  #4,d0
                blo.s   S3CNZ1Screen_BeginScrollDeceleration  ; Wait until the offset is a multiple of $100
                move.l  (Events_bg+$0C).w,d0
                add.l   d0,(Events_bg+$08).w
                rts
; ---------------------------------------------------------------------------

S3CNZ1Screen_BeginScrollDeceleration:
                addq.b  #4,routine(a0)

Obj_CNZMinibossScrollSlow:
                move.l  (Events_bg+$0C).w,d0            ; Start slowing down the scrolling
                cmpi.l  #$10000,d0
                bls.s   S3CNZ1Screen_BeginSlowScrollAlignment
                subi.l  #$400,d0
                move.l  d0,(Events_bg+$0C).w
                add.l   d0,(Events_bg+$08).w
                rts
; ---------------------------------------------------------------------------

S3CNZ1Screen_BeginSlowScrollAlignment:
                addq.b  #4,routine(a0)

Obj_CNZMinibossScrollWait2:
                move.w  (Events_bg+$08).w,d0
                andi.w  #$FF,d0
                cmpi.w  #4,d0
                blo.s   S3CNZ1Screen_EnablePostBossCollision  ; Keep going until offset is a multiple of $100 again
                move.l  (Events_bg+$0C).w,d0
                add.l   d0,(Events_bg+$08).w
                rts
; ---------------------------------------------------------------------------

S3CNZ1Screen_EnablePostBossCollision:
                move.w  d0,(Events_bg+$08).w            ; Reset scroll offset
                move.w  #$1000,(Camera_target_max_Y_pos).w  ; Reset Y end
                st      (Background_collision_flag).w   ; BG collision is on
                addq.w  #4,(Events_routine_bg).w        ; Next BG Event
                movea.w (Level_layout_main).w,a1
                lea     $67(a1),a1
                move.w  (Level_layout_header).w,d0
                moveq   #0,d1
                moveq   #6,d2

S3CNZ1Screen_ClearArenaColumn:
                move.b  d1,(a1)                         ; Copy top of FG at $3380 downwards
                adda.w  d0,a1
                dbf     d2,S3CNZ1Screen_ClearArenaColumn
                addq.b  #4,routine(a0)

Obj_CNZMinibossScrollWait3:
                cmpi.w  #$1C0,(Events_bg+$08).w         ; Wait till scroll offset is $1C0
                bhs.s   S3CNZ1Screen_FinishMinibossScroll
                move.l  (Events_bg+$0C).w,d0
                add.l   d0,(Events_bg+$08).w
                rts
; ---------------------------------------------------------------------------

S3CNZ1Screen_FinishMinibossScroll:
                st      (Events_fg_5).w                 ; Set flag to continue next BG event
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
CNZ1_BGDeformArray:
                dc.w    $80,   $30,   $60,   $C0, $7FFF
