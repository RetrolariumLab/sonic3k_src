; Owner: game/level/zones/fbz/sk
; Responsibility: Flying Battery act-two screen initialization, event dispatch and progression control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

FBZ2_ScreenInit:
                move.w  #$2C40,d0
                cmp.w   (Camera_X_pos).w,d0
                bhi.s   SKFBZ2FG_RefreshInitialForeground
                move.w  #4,(Events_routine_fg).w        ; If screen X is past subboss battle, change screen event
                move.w  d0,(Camera_min_X_pos).w
                jsr     SetUp_FBZ2BossEvent(pc)
                clr.l   (SceneAuxiliaryXOrCompetitionTime).w
                clr.l   (SceneAuxiliaryYOrVerticalMotion).w  ; Clear BG camera offset
                move.w  #VRAM_Plane_B_Name_Table,d7
                movem.l d7-a0/a2-a3,-(sp)
                lea     (ArtKosM_FBZCloud).l,a1
                move.w  #tiles_to_bytes(ArtTile_FBZCloud),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_FBZBossPillar).l,a1
                move.w  #tiles_to_bytes(ArtTile_FBZBossPillar),d2
                jsr     (Queue_Kos_Module).l            ; Load boss event graphics
                movem.l (sp)+,d7-a0/a2-a3

SKFBZ2FG_RefreshInitialForeground:
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

FBZ2_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                move.w  (Events_routine_fg).w,d0
                jmp     FBZ2_ScreenEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

FBZ2_ScreenEvent_Index:
                bra.w   FBZ2SE_Normal
; ---------------------------------------------------------------------------
                bra.w   FBZ2SE_BossEvent
; ---------------------------------------------------------------------------
                bra.w   FBZ2SE_BossEventRefresh
; ---------------------------------------------------------------------------
                bra.w   FBZ2SE_BossEventEnd
; ---------------------------------------------------------------------------

FBZ2SE_Normal:
                cmpi.b  #6,(Player_1+routine).w
                blo.s   SKFBZ2FG_DispatchLayoutEvent
                rts
; ---------------------------------------------------------------------------

SKFBZ2FG_DispatchLayoutEvent:
                lea     FBZ2_LayoutModRange(pc),a1      ; Only one layout mod this time around
                move.w  (Player_1+x_pos).w,d0
                move.w  (Player_1+y_pos).w,d1
                move.w  (Events_bg+$00).w,d2
                jmp     SKFBZ2FG_LayoutEventTable(pc,d2.w)
; ---------------------------------------------------------------------------

SKFBZ2FG_LayoutEventTable:
                bra.w   FBZ2_NoLayoutMod
; ---------------------------------------------------------------------------
                bra.w   FBZ2_LayoutMod1
; ---------------------------------------------------------------------------

FBZ2_NoLayoutMod:
                cmp.w   (a1)+,d0
                blo.s   SKFBZ2FG_DrawAndTryStartBoss
                cmp.w   (a1)+,d0
                bhi.s   SKFBZ2FG_DrawAndTryStartBoss
                cmp.w   (a1)+,d1
                blo.s   SKFBZ2FG_DrawAndTryStartBoss
                cmp.w   (a1)+,d1
                bhi.s   SKFBZ2FG_DrawAndTryStartBoss
                move.w  #4,(Events_bg+$00).w

SKFBZ2FG_DrawAndTryStartBoss:
                jsr     DrawTilesAsYouMove(pc)
                cmpi.w  #$2B30,(Camera_X_pos).w
                blo.s   SKFBZ2FG_ScreenEventReturn
                jsr     SetUp_FBZ2BossEvent(pc)         ; If Player passes certain point, set up the boss event
                clr.l   (SceneAuxiliaryXOrCompetitionTime).w
                clr.l   (SceneAuxiliaryYOrVerticalMotion).w
                addq.w  #4,(Events_routine_fg).w

SKFBZ2FG_ScreenEventReturn:
                rts
; ---------------------------------------------------------------------------

FBZ2_LayoutMod1:
                jsr     FBZ1Screen_CheckInRange(pc)
                cmpi.w  #$E00,d0
                blo.s   SKFBZ2FG_CheckLayoutSwitchHeight
                cmpi.w  #$1280,d0
                bls.s   SKFBZ2FG_DrawWithoutChangingActTwoLayout

SKFBZ2FG_CheckLayoutSwitchHeight:
                tst.w   (Events_bg+$02).w
                bne.s   SKFBZ2FG_TryReturnIndoors
                cmpi.w  #$B0E,d1                        ; If indoors
                bls.s   SKFBZ2FG_DrawWithoutChangingActTwoLayout
                bra.s   SKFBZ2FG_BindOutdoorLayout
; ---------------------------------------------------------------------------

SKFBZ2FG_TryReturnIndoors:
                cmpi.w  #$AF2,d1                        ; If outdoors
                bhi.s   SKFBZ2FG_DrawWithoutChangingActTwoLayout
                clr.w   (Events_bg+$02).w
                movea.w (a3),a5
                lea     $70(a5),a5
                bra.s   SKFBZ2FG_BeginLayoutCopy
; ---------------------------------------------------------------------------

SKFBZ2FG_BindOutdoorLayout:
                st      (Events_bg+$02).w
                movea.w $10(a3),a5
                lea     $70(a5),a5

SKFBZ2FG_BeginLayoutCopy:
                movea.w $50(a3),a1
                lea     $1A(a1),a1
                move.w  -8(a3),d0
                subi.w  #$E,d0                          ; Width of 14 tiles
                moveq   #4-1,d1                         ; Height of 4 tiles

SKFBZ2FG_CopyAndRefreshLayout:
                move.l  (a5)+,(a1)+
                move.l  (a5)+,(a1)+
                move.l  (a5)+,(a1)+
                move.w  (a5)+,(a1)+
                adda.w  d0,a5
                adda.w  d0,a1
                dbf     d1,SKFBZ2FG_CopyAndRefreshLayout
                jmp     Refresh_PlaneScreenDirect(pc)
; ---------------------------------------------------------------------------

SKFBZ2FG_DrawWithoutChangingActTwoLayout:
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

FBZ2SE_BossEvent:
                move.w  #VRAM_Plane_B_Name_Table,d7     ; Draw FG tiles on BG plane instead
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

FBZ2SE_BossEventRefresh:
                move.w  #VRAM_Plane_B_Name_Table,d7
                move.w  #$2D00,d1
                moveq   #0,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.s   FBZ2SE_BossEventEnd
                addq.w  #4,(Events_routine_fg).w

FBZ2SE_BossEventEnd:
                rts

; =============== S U B R O U T I N E =======================================

SetUp_FBZ2BossEvent:
                jsr     (AllocateObject).l
                bne.s   SKFBZ2FG_SetBossAreaPalettes
                move.l  #Obj_FBZEndBossEventControl,(a1)
                jsr     (CreateNewSprite4).l
                bne.s   SKFBZ2FG_SetBossAreaPalettes
                move.l  #Obj_FBZBossPillar,(a1)
                lea     (FBZ_cloud_addr).w,a5
                moveq   #0,d1
                moveq   #5-1,d2

SKFBZ2FG_ClearCloudHandles:
                move.l  d1,(a5)+                        ; Reset object addresses for clouds
                dbf     d2,SKFBZ2FG_ClearCloudHandles
                lea     (FBZ_cloud_addr).w,a5
                moveq   #$A-1,d1

SKFBZ2FG_TrySpawnClouds:
                jsr     (CreateNewSprite4).l
                bne.s   SKFBZ2FG_SetBossAreaPalettes
                move.w  a1,(a5)+
                move.l  #Obj_FBZCloud,(a1)              ; Create cloud objects and place addresses in FFEEEA
                move.w  d1,$2E(a1)
                dbf     d1,SKFBZ2FG_TrySpawnClouds

; Apply the current and target palettes even when a boss-area actor fails to allocate
SKFBZ2FG_SetBossAreaPalettes:
                lea     Pal_FBZBGOutdoors(pc),a1        ; Modify palette
                lea     (Normal_palette_line_4+$2).w,a5
                lea     (Target_palette_line_4+$2).w,a6
                move.w  #$EEE,(a5)+
                move.w  #$EEE,(a6)+
                move.l  (a1),(a5)+
                move.l  (a1)+,(a6)+
                move.l  (a1),(a5)+
                move.l  (a1)+,(a6)+
                move.l  (a1),(a5)+
                move.l  (a1)+,(a6)+
                move.l  (a1),(a5)+
                move.l  (a1)+,(a6)+
                rts
; End of function SetUp_FBZ2BossEvent

; ---------------------------------------------------------------------------
FBZ2_LayoutModRange:
                dc.w    $D80, $1300,  $A00,  $B80
