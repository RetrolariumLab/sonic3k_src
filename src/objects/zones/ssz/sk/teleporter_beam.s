; Owner: objects/zones/ssz/sk
; Responsibility: Teleporter beam spawning, expansion, animation and transition effects
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_TeleporterBeam:
                move.l  #Obj_TeleporterBeamSpawn,(a0)
                move.b  #$44,render_flags(a0)           ; Multisprite mode
                move.b  #$80,height_pixels(a0)
                move.b  #$18,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$88,3,1),art_tile(a0)
                move.l  #Map_SSZHPZTeleporter,mappings(a0)
                move.w  #1,mainspr_childsprites(a0)
                move.w  y_pos(a0),$44(a0)
                subi.w  #$88,$44(a0)
                move.b  #$10,$47(a0)                    ; Wait 16 frames
                cmpi.b  #3,(Current_zone).w
                bne.s   SKSSZBeam_TrySetHPZArt
                move.w  #$24EE,art_tile(a0)             ; If in CNZ, use this VRAM offset
                bra.s   Obj_TeleporterBeamSpawn
; ---------------------------------------------------------------------------

SKSSZBeam_TrySetHPZArt:
                cmpi.b  #$16,(Current_zone).w
                bne.s   Obj_TeleporterBeamSpawn
                move.w  #make_art_tile(ArtTile_HPZTeleporter,3,0),art_tile(a0)  ; If in HPZ, use this VRAM offset

Obj_TeleporterBeamSpawn:
                tst.b   $47(a0)
                beq.s   SKSSZBeam_TryBuildNarrowBeam
                subq.b  #1,$47(a0)
                bra.s   SKSSZBeam_NarrowBeamReturn
; ---------------------------------------------------------------------------

SKSSZBeam_TryBuildNarrowBeam:
                btst    #0,(Level_frame_counter+1).w
                beq.s   SKSSZBeam_NarrowBeamReturn      ; Do a flickering effect
                lea     sub2_x_pos(a0),a1               ; Sprite attribute table to a1
                move.w  y_pos(a0),d0
                move.w  mainspr_childsprites(a0),d1
                subq.w  #1,d1

SKSSZBeam_PlaceNarrowSegment:
                move.w  x_pos(a0),(a1)                  ; Same X coordinate for all sprites
                move.w  d0,sub2_y_pos-sub2_x_pos(a1)    ; Different Y coordinate offset from base
                tst.w   d1
                bne.s   SKSSZBeam_StepToUpperSegment
                eori.b  #-1,$46(a0)                     ; If the last listed sprite
                beq.s   SKSSZBeam_GrowNarrowBeam
                move.b  #1,sub2_mapframe-sub2_x_pos(a1)  ; Use mapping 1 on the first frame
                bra.s   SKSSZBeam_TryBeginExpansionDelay
; ---------------------------------------------------------------------------

SKSSZBeam_GrowNarrowBeam:
                move.b  #2,sub2_mapframe-sub2_x_pos(a1)  ; Mapping 2 on the second frame + add new sprite
                addq.w  #1,mainspr_childsprites(a0)
                bra.s   SKSSZBeam_TryBeginExpansionDelay
; ---------------------------------------------------------------------------

SKSSZBeam_StepToUpperSegment:
                move.b  #2,sub2_mapframe-sub2_x_pos(a1)
                subi.w  #$20,d0
                addq.w  #next_subspr,a1

SKSSZBeam_TryBeginExpansionDelay:
                dbf     d1,SKSSZBeam_PlaceNarrowSegment
                cmpi.w  #7,mainspr_childsprites(a0)
                blo.s   SKSSZBeam_DrawNarrowBeam
                tst.b   $46(a0)                         ; When seven sprites have been made, test $46
                bne.s   SKSSZBeam_DrawNarrowBeam
                move.l  #Obj_TeleporterBeamWait,(a0)    ; When last sprite uses mapping frame 2, go to next phase
                move.b  #$10,$47(a0)

SKSSZBeam_DrawNarrowBeam:
                jsr     (Draw_Sprite).l

SKSSZBeam_NarrowBeamReturn:
                rts
; ---------------------------------------------------------------------------

Obj_TeleporterBeamWait:
                subq.b  #1,$47(a0)
                beq.s   SKSSZBeam_BeginWideBeam
                btst    #0,(Level_frame_counter+1).w
                beq.s   SKSSZBeam_ExpansionDelayReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSSZBeam_ExpansionDelayReturn:
                rts
; ---------------------------------------------------------------------------

SKSSZBeam_BeginWideBeam:
                move.l  #Obj_TeleporterBeamExpand,(a0)
                move.w  #2,mainspr_childsprites(a0)     ; Use two large sprites for the beam

Obj_TeleporterBeamExpand:
                btst    #0,(Level_frame_counter+1).w
                beq.w   SKSSZBeam_WideBeamReturn
                move.w  $44(a0),d0
                move.w  d0,d1
                sub.w   (Camera_Y_pos).w,d1
                cmpi.w  #$68,d1
                ble.s   SKSSZBeam_SetYAndLimitSpread
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$68,d0                         ; Ensure that object base Y is always centered or above the screen

SKSSZBeam_SetYAndLimitSpread:
                move.w  d0,y_pos(a0)
                move.w  x_pos(a0),d1
                moveq   #0,d2
                move.b  $46(a0),d2                      ; $46 should be 0 starting out
                move.w  d2,d3
                cmpi.w  #$12,d2                         ; Maximum of $12
                blo.s   SKSSZBeam_SelectGeometryBank
                moveq   #$12,d2

SKSSZBeam_SelectGeometryBank:
                addq.w  #6,d2
                lsl.w   #3,d3
                lea     SKSSZBeam_SSZAndHPZGeometry(pc),a1  ; Use if in SSZ or HPZ
                cmpi.b  #$A,(Current_zone).w
                beq.s   SKSSZBeam_WriteBeamSpritePair
                cmpi.b  #$16,(Current_zone).w
                beq.s   SKSSZBeam_WriteBeamSpritePair
                lea     SKSSZBeam_OtherZoneGeometry(pc),a1  ; Use if anywhere else

SKSSZBeam_WriteBeamSpritePair:
                adda.w  d3,a1
                lea     sub2_x_pos(a0),a2
                move.w  d1,(a2)
                sub.w   d2,(a2)+
                move.w  (a1)+,(a2)
                add.w   d0,(a2)+
                move.w  (a1)+,(a2)+
                move.w  d1,(a2)
                add.w   d2,(a2)+
                move.w  (a1)+,(a2)
                add.w   d0,(a2)+
                move.w  (a1)+,(a2)+
                tst.b   routine(a0)
                beq.s   SKSSZBeam_TryExpandOnPhase3
                subq.b  #1,$46(a0)                      ; Contract beam
                bpl.s   SKSSZBeam_DrawWideBeam          ; Branch if beam is still in effect
                move.b  #9,mapping_frame(a0)            ; Change main mapping
                clr.w   mainspr_childsprites(a0)        ; No more sprites
                move.l  #Delete_Current_Sprite,(a0)     ; Delete object
                movea.w parent2(a0),a1
                clr.b   $38(a1)                         ; Set flag to parent indicating completion
                bra.s   SKSSZBeam_DrawWideBeam
; ---------------------------------------------------------------------------

SKSSZBeam_TryExpandOnPhase3:
                btst    #1,(Level_frame_counter+1).w
                beq.s   SKSSZBeam_DrawWideBeam
                cmpi.b  #$18,$46(a0)
                bhs.s   SKSSZBeam_DrawWideBeam
                addq.b  #1,$46(a0)                      ; Expand beam

SKSSZBeam_DrawWideBeam:
                jsr     (Draw_Sprite).l

SKSSZBeam_WideBeamReturn:
                rts
; ---------------------------------------------------------------------------

SKSSZBossPedestal_InitBossSceneProp:
                move.l  #SKSSZBossPedestal_TickRetirementOrWait,(a0)
                addi.w  #high_priority,art_tile(a0)

SKSSZBossPedestal_TickRetirementOrWait:
                tst.w   $32(a0)
                beq.s   SKSSZBossPedestal_TrySpawnAtMaxCameraY
                subq.w  #1,$32(a0)
                bne.s   SKSSZBossPedestal_DrawSceneProp
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSSZBossPedestal_TrySpawnAtMaxCameraY:
                tst.w   $2E(a0)
                bne.s   SKSSZBossPedestal_TryExplodeAfterBoss
                move.w  (Camera_Y_pos).w,d0
                cmp.w   (Camera_max_Y_pos).w,d0
                bne.s   SKSSZBossPedestal_DrawSceneProp
                jsr     (AllocateObject).l
                bne.s   SKSSZBossPedestal_DrawAfterSpawnAttempt
                move.l  #Obj_SSZEndBoss,(a1)
                move.w  a1,(_unkFAA4).w
                move.w  a1,$30(a0)
                st      $2E(a0)

SKSSZBossPedestal_DrawAfterSpawnAttempt:
                bra.s   SKSSZBossPedestal_DrawSceneProp
; ---------------------------------------------------------------------------

SKSSZBossPedestal_TryExplodeAfterBoss:
                movea.w $30(a0),a1
                move.w  x_pos(a1),d0
                cmp.w   x_pos(a0),d0
                bhi.s   SKSSZBossPedestal_DrawSceneProp
                move.w  #$20,$32(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l

SKSSZBossPedestal_DrawSceneProp:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKHPZDepartSurface_TrySpawnBeam:
                jsr     CycleSszHpzTeleporterPalettePair(pc)
                tst.b   routine(a0)
                beq.s   SKHPZDepartSurface_DrawWaiting
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKHPZDepartSurface_DrawWaiting
                move.w  a1,$3C(a0)
                move.l  #Obj_TeleporterBeam,(a1)
                move.w  a0,parent2(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #SKHPZDepartSurface_RaiseDepartingActor,(a0)
                move.w  #-$100,$38(a0)
                moveq   #signextendB(sfx_Charging),d0
                jsr     (Play_SFX).l

SKHPZDepartSurface_DrawWaiting:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKHPZDepartSurface_RaiseDepartingActor:
                jsr     CycleSszHpzTeleporterPalettePair(pc)
                movea.w (_unkFAA4).w,a1
                movea.w $3C(a0),a2
                cmpi.b  #8,$46(a2)
                blt.w   SKHPZDepartSurface_DrawCharging
                beq.w   SKHPZDepartSurface_SignalCapturePhase
                cmpi.b  #$18,$46(a2)
                bhs.s   SKHPZDepartSurface_RemoveActorAtFullBeam
                btst    #0,(Level_frame_counter+1).w
                beq.w   SKHPZDepartSurface_DrawCharging
                subq.w  #1,y_pos(a1)
                btst    #1,(Level_frame_counter+1).w
                beq.w   SKHPZDepartSurface_DrawCharging
                moveq   #1,d1
                move.w  x_pos(a1),d0
                cmp.w   x_pos(a0),d0
                beq.s   SKHPZDepartSurface_DrawCharging
                bcs.s   SKHPZDepartSurface_CenterDepartingActor
                neg.w   d1

SKHPZDepartSurface_CenterDepartingActor:
                add.w   d1,x_pos(a1)
                bra.s   SKHPZDepartSurface_DrawCharging
; ---------------------------------------------------------------------------

SKHPZDepartSurface_RemoveActorAtFullBeam:
                clr.l   (a1)
                moveq   #signextendB(sfx_Transporter),d0
                jsr     (Play_SFX).l
                move.l  #SKHPZDepartSurface_CyclePaletteAndDraw,(a0)
                bra.s   SKHPZDepartSurface_DrawCharging
; ---------------------------------------------------------------------------

SKHPZDepartSurface_SignalCapturePhase:
                bset    #7,(_unkFAB8).w

SKHPZDepartSurface_DrawCharging:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKHPZDepartSurface_CyclePaletteAndDraw:
                jsr     CycleSszHpzTeleporterPalettePair(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKHPZDepartScene_SelectDepartureRoute:
                cmpi.w  #3,(Player_mode).w
                bne.s   SKHPZDepartScene_CheckSurfaceXOrDelete
                cmpi.w  #$240,(Camera_Y_pos).w
                bhs.s   SKHPZDepartScene_SetupReturn
                cmpi.w  #$B00,(Player_1+x_pos).w
                blo.s   SKHPZDepartScene_SetupReturn
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                st      (SRAM_mask_interrupts_flag).w
                jsr     (SaveGame).l
                move.w  #$A01,d0
                jmp     (StartNewLevel).l
; ---------------------------------------------------------------------------

SKHPZDepartScene_CheckSurfaceXOrDelete:
                movea.w $2E(a0),a1
                cmpi.w  #$1000,x_pos(a1)
                bhs.s   SKHPZDepartScene_InitScriptAndSurface
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKHPZDepartScene_InitScriptAndSurface:
                move.l  #$40C0408,(Normal_palette_line_4+$2).w
                st      (Palette_cycle_counters+$00).w
                move.l  #SKHPZDepartSurface_TrySpawnBeam,(a1)
                move.l  #SKHPZDepartScene_ClampCameraX,(a0)

SKHPZDepartScene_SetupReturn:
                rts
; ---------------------------------------------------------------------------

SKHPZDepartScene_ClampCameraX:
                move.w  #$1600,d0
                cmp.w   (Camera_X_pos).w,d0
                blo.s   SKHPZDepartScene_UpdatePlayerScripts
                cmp.w   (Camera_max_X_pos).w,d0
                beq.s   SKHPZDepartScene_UpdatePlayerScripts
                move.w  d0,(Camera_max_X_pos).w
                clr.w   (Camera_min_Y_pos).w

SKHPZDepartScene_UpdatePlayerScripts:
                lea     (Player_1).w,a1
                lea     (Ctrl_1_logical).w,a2
                lea     (Ctrl_1_locked).w,a3
                lea     $30(a0),a4
                lea     1(a4),a5
                moveq   #0,d6
                bsr.s   AdvanceHpzDeparturePlayerScript
                tst.w   (Player_mode).w
                bne.s   SKHPZDepartScene_TickBeamTriggerPhase
                lea     (Player_2).w,a1
                lea     (Ctrl_2_logical).w,a2
                lea     (Ctrl_2_locked).w,a3
                lea     $31(a0),a4
                lea     -1(a4),a5
                moveq   #1,d6
                bsr.s   AdvanceHpzDeparturePlayerScript

SKHPZDepartScene_TickBeamTriggerPhase:
                move.b  subtype(a0),d0
                beq.s   SKHPZDepartScene_TryPanCamera
                subq.b  #1,d0
                bne.s   SKHPZDepartScene_TrySignalSurface
                subq.b  #1,$2D(a0)
                bne.s   SKHPZDepartScene_TryPanCamera
                bset    #6,(_unkFAB8).w
                move.w  #(2<<8)|60,subtype(a0)
                bra.s   SKHPZDepartScene_TryPanCamera
; ---------------------------------------------------------------------------

SKHPZDepartScene_TrySignalSurface:
                subq.b  #1,$2D(a0)
                bne.s   SKHPZDepartScene_TryPanCamera
                movea.w $2E(a0),a1
                st      routine(a1)
                clr.w   subtype(a0)

SKHPZDepartScene_TryPanCamera:
                tst.b   routine(a0)
                beq.s   SKHPZDepartScene_SceneUpdateReturn
                subq.w  #1,(Camera_X_pos).w
                btst    #0,routine(a0)
                beq.s   SKHPZDepartScene_TickCameraPan
                subq.w  #1,(Camera_Y_pos).w

SKHPZDepartScene_TickCameraPan:
                subq.b  #1,routine(a0)

SKHPZDepartScene_SceneUpdateReturn:
                rts

; =============== S U B R O U T I N E =======================================

AdvanceHpzDeparturePlayerScript:
                move.b  (a4),d0
                bmi.w   SKHPZDepartPlayer_PlayerScriptReturn
                bne.s   SKHPZDepartPlayer_WaitGroundedThenArm
                move.w  #$1628,d0
                tst.w   d6
                beq.s   SKHPZDepartPlayer_ClampXAndLockInput
                addi.w  #$10,d0

SKHPZDepartPlayer_ClampXAndLockInput:
                cmp.w   x_pos(a1),d0
                blo.w   SKHPZDepartPlayer_PlayerScriptReturn
                move.w  d0,x_pos(a1)
                clr.w   x_vel(a1)
                clr.w   ground_vel(a1)
                clr.w   (a2)
                st      (a3)
                addq.b  #1,(a4)
                bra.w   SKHPZDepartPlayer_PlayerScriptReturn
; ---------------------------------------------------------------------------

SKHPZDepartPlayer_WaitGroundedThenArm:
                subq.b  #1,d0
                bne.s   SKHPZDepartPlayer_WaitForPartner
                btst    #1,status(a1)
                bne.w   SKHPZDepartPlayer_PlayerScriptReturn
                move.b  #-$60,2(a4)
                tst.w   d6
                beq.s   SKHPZDepartPlayer_AdvanceAfterDelaySetup
                move.b  #-$24,2(a4)

SKHPZDepartPlayer_AdvanceAfterDelaySetup:
                addq.b  #1,(a4)
                bra.w   SKHPZDepartPlayer_PlayerScriptReturn
; ---------------------------------------------------------------------------

SKHPZDepartPlayer_WaitForPartner:
                subq.b  #1,d0
                bne.s   SKHPZDepartPlayer_WaitSharedThenTickRun
                tst.w   (Player_mode).w
                bne.s   SKHPZDepartPlayer_StartSharedScene
                tst.b   2(a5)
                beq.w   SKHPZDepartPlayer_PlayerScriptReturn

SKHPZDepartPlayer_StartSharedScene:
                move.w  #(1<<8)|60,subtype(a0)
                move.b  #$48,routine(a0)
                st      (Scroll_lock).w
                addq.b  #1,(a4)
                bra.w   SKHPZDepartPlayer_PlayerScriptReturn
; ---------------------------------------------------------------------------

SKHPZDepartPlayer_WaitSharedThenTickRun:
                subq.b  #1,d0
                bne.s   SKHPZDepartPlayer_RunToTargetAndRise
                tst.w   subtype(a0)
                bne.w   SKHPZDepartPlayer_PlayerScriptReturn
                subq.b  #1,2(a4)
                bne.w   SKHPZDepartPlayer_PlayerScriptReturn
                move.w  #-$100,x_vel(a1)
                move.w  #$2424,(a2)
                addq.b  #1,(a4)
                bra.s   SKHPZDepartPlayer_PlayerScriptReturn
; ---------------------------------------------------------------------------

SKHPZDepartPlayer_RunToTargetAndRise:
                subq.b  #1,d0
                bne.s   SKHPZDepartPlayer_TickSaveAndEnterSSZ
                move.w  #$15C0,d0
                cmp.w   x_pos(a1),d0
                blo.s   SKHPZDepartPlayer_ForceLeftInput
                move.w  d0,x_pos(a1)
                subi.w  #$80,y_pos(a1)
                clr.w   x_vel(a1)
                clr.w   ground_vel(a1)
                move.b  #3,$2E(a1)
                clr.b   anim(a1)
                clr.b   mapping_frame(a1)
                clr.w   (a2)
                moveq   #signextendB(sfx_Transporter),d0
                jsr     (Play_SFX).l
                tst.w   d6
                beq.s   SKHPZDepartPlayer_SetP1FinalDelay
                st      (a4)
                rts
; ---------------------------------------------------------------------------

SKHPZDepartPlayer_SetP1FinalDelay:
                move.b  #60,2(a4)
                tst.w   (Player_mode).w
                bne.s   SKHPZDepartPlayer_BeginFinalCountdown
                move.b  #2*60,2(a4)

SKHPZDepartPlayer_BeginFinalCountdown:
                addq.b  #1,(a4)
                bra.s   SKHPZDepartPlayer_PlayerScriptReturn
; ---------------------------------------------------------------------------

SKHPZDepartPlayer_ForceLeftInput:
                move.w  #$2404,(a2)
                bra.s   SKHPZDepartPlayer_PlayerScriptReturn
; ---------------------------------------------------------------------------

SKHPZDepartPlayer_TickSaveAndEnterSSZ:
                subq.b  #1,2(a4)
                bne.s   SKHPZDepartPlayer_PlayerScriptReturn
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                st      (SRAM_mask_interrupts_flag).w
                jsr     (SaveGame).l
                move.w  #$A00,d0
                jmp     (StartNewLevel).l
; ---------------------------------------------------------------------------

SKHPZDepartPlayer_PlayerScriptReturn:
                rts
; End of function AdvanceHpzDeparturePlayerScript
