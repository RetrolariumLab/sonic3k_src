; Owner: objects/zones/ssz/sk
; Responsibility: Sky Sanctuary and Hidden Palace teleporter capture, transition control and player release
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SSZHPZTeleporter:
                move.l  #SKSSZTeleporter_TryEnableHPZPalette,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$18,width_pixels(a0)
                move.w  #$180,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$88,0,0),art_tile(a0)
                move.l  #Map_SSZHPZTeleporter,mappings(a0)
                move.w  y_pos(a0),$16(a0)
                move.b  subtype(a0),d0
                bpl.s   SKSSZTeleporter_SelectZoneSetup
                lea     (Events_bg+$00).w,a1
                add.b   d0,d0
                bpl.s   SKSSZTeleporter_SelectRaisedStart
                addq.w  #2,a1

SKSSZTeleporter_SelectRaisedStart:
                tst.b   (a1)
                bmi.s   SKSSZTeleporter_SelectZoneSetup
                move.w  #$20,y_vel(a0)

SKSSZTeleporter_SelectZoneSetup:
                cmpi.w  #$1701,(Current_zone_and_act).w
                beq.s   SKSSZTeleporter_InitAlternateZoneArt
                cmpi.b  #$16,(Current_zone).w
                bne.s   SKSSZBossPedestal_CheckEndBossPosition
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKSSZTeleporter_InitHPZArtAndSubtype
                move.l  #SKHPZDepartScene_SelectDepartureRoute,(a1)
                move.w  a0,$2E(a1)

SKSSZTeleporter_InitHPZArtAndSubtype:
                move.w  #make_art_tile(ArtTile_HPZTeleporter,0,0),art_tile(a0)  ; If in HPZ, use this VRAM offset
                cmpi.w  #3,(Player_mode).w
                bne.s   SKSSZTeleporter_InitFrameAndUpdate
                move.b  #$4A,subtype(a0)
                bra.s   SKSSZTeleporter_InitFrameAndUpdate
; ---------------------------------------------------------------------------

SKSSZTeleporter_InitAlternateZoneArt:
                move.w  #make_art_tile(ArtTile_SSZMisc+$1b4,0,0),art_tile(a0)

SKSSZTeleporter_InitFrameAndUpdate:
                move.b  #$A,mapping_frame(a0)
                bra.s   SKSSZTeleporter_TryEnableHPZPalette
; ---------------------------------------------------------------------------

SKSSZBossPedestal_CheckEndBossPosition:
                cmpi.w  #$1A00,x_pos(a0)
                blo.s   SKSSZTeleporter_TryEnableHPZPalette
                cmpi.w  #$680,y_pos(a0)
                blo.w   SKSSZBossPedestal_InitBossSceneProp

SKSSZTeleporter_TryEnableHPZPalette:
                cmpi.b  #$16,(Current_zone).w
                bne.s   SKSSZTeleporter_ApplyYOffsetAndCycle
                tst.b   render_flags(a0)
                bpl.s   SKSSZTeleporter_TryDisableHPZPalette
                tst.b   $38(a0)
                bne.s   SKSSZTeleporter_ApplyYOffsetAndCycle
                move.l  #$40C0408,(Normal_palette_line_4+$2).w
                st      (Palette_cycle_counters+$00).w
                bra.s   SKSSZTeleporter_ApplyYOffsetAndCycle
; ---------------------------------------------------------------------------

SKSSZTeleporter_TryDisableHPZPalette:
                tst.b   $38(a0)
                bne.s   SKSSZTeleporter_ApplyYOffsetAndCycle
                clr.b   (Palette_cycle_counters+$00).w

SKSSZTeleporter_ApplyYOffsetAndCycle:
                move.w  $16(a0),d0
                add.w   $1A(a0),d0
                move.w  d0,y_pos(a0)
                jsr     CycleSszHpzTeleporterPalettePair(pc)
                tst.b   subtype(a0)
                bne.s   SKSSZTeleporter_TryCheckLoweredSlope
                tst.b   (Events_bg+$04).w
                bne.w   SKSSZTeleporter_DrawIdleSurface

SKSSZTeleporter_TryCheckLoweredSlope:
                tst.w   $1A(a0)
                bne.s   SKSSZTeleporter_CheckSubtypeAndEvent
                moveq   #$23,d1
                lea     SKSSZTeleporter_SolidHeights(pc),a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped2).l

SKSSZTeleporter_CheckSubtypeAndEvent:
                lea     (Events_bg+$00).w,a1
                move.b  subtype(a0),d0
                beq.w   SKSSZTeleporter_DrawIdleSurface
                bpl.s   SKSSZTeleporter_TryCaptureP1
                add.b   d0,d0
                bpl.s   SKSSZTeleporter_TickLowering
                addq.w  #2,a1

SKSSZTeleporter_TickLowering:
                tst.b   (a1)
                bpl.w   SKSSZTeleporter_DrawIdleSurface
                tst.w   $1A(a0)
                beq.s   SKSSZTeleporter_TryCaptureP1
                move.w  (Level_frame_counter).w,d0
                andi.w  #3,d0
                bne.w   SKSSZTeleporter_DrawIdleSurface
                subq.w  #1,y_vel(a0)
                bra.w   SKSSZTeleporter_DrawIdleSurface
; ---------------------------------------------------------------------------

; Take control of P1 only after the beam actor is allocated
SKSSZTeleporter_TryCaptureP1:
                btst    #p1_standing_bit,status(a0)
                beq.w   SKSSZTeleporter_DrawIdleSurface
                lea     (Player_1).w,a2
                move.w  x_pos(a2),d0
                sub.w   x_pos(a0),d0
                addi.w  #$C,d0
                cmpi.w  #$18,d0
                bhs.s   SKSSZTeleporter_DrawIdleSurface
                tst.b   object_control(a2)
                bne.w   SKSSZTeleporter_DrawIdleSurface
                cmpi.b  #4,routine(a2)
                bhs.w   SKSSZTeleporter_DrawIdleSurface
                tst.w   (Debug_placement_mode).w
                bne.w   SKSSZTeleporter_DrawIdleSurface
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKSSZTeleporter_DrawIdleSurface
                move.w  a1,$3C(a0)
                move.l  #Obj_TeleporterBeam,(a1)
                move.w  a0,parent2(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                clr.w   x_vel(a2)
                clr.w   ground_vel(a2)
                move.w  #-1,y_vel(a2)
                clr.b   spin_dash_flag(a2)
                move.b  #1,object_control(a2)
                move.b  #5,anim(a2)
                move.l  #SKSSZTeleporter_TrackP1Charge,(a0)
                move.w  #-$100,$38(a0)
                moveq   #signextendB(sfx_Charging),d0
                jsr     (Play_SFX).l

SKSSZTeleporter_DrawIdleSurface:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKSSZTeleporter_TrackP1Charge:
                jsr     UpdateSszHpzTeleporterSurfaceAndPalette(pc)
                lea     (Player_1).w,a1
                movea.w $3C(a0),a2
                cmpi.b  #8,$46(a2)
                blt.w   SKSSZTeleporter_DrawCharge
                beq.w   SKSSZTeleporter_RollP1AndSignalCapture
                cmpi.b  #$18,$46(a2)
                bhs.s   SKSSZTeleporter_SelectTravelCount
                btst    #0,(Level_frame_counter+1).w
                beq.w   SKSSZTeleporter_DrawCharge
                subq.w  #1,y_pos(a1)
                btst    #1,(Level_frame_counter+1).w
                beq.w   SKSSZTeleporter_DrawCharge
                moveq   #1,d1
                move.w  x_pos(a1),d0
                cmp.w   x_pos(a0),d0
                beq.s   SKSSZTeleporter_DrawCharge
                bcs.s   SKSSZTeleporter_CenterChargingP1
                neg.w   d1

SKSSZTeleporter_CenterChargingP1:
                add.w   d1,x_pos(a1)
                bra.s   SKSSZTeleporter_DrawCharge
; ---------------------------------------------------------------------------

; Hidden Palace uses the full subtype. Other zones mask it to six bits
SKSSZTeleporter_SelectTravelCount:
                move.l  #SKSSZTeleporter_TravelUpOrRebound,(a0)
                move.b  subtype(a0),d0
                cmpi.b  #$16,(Current_zone).w
                beq.s   SKSSZTeleporter_BeginP1Travel
                andi.w  #$3F,d0

SKSSZTeleporter_BeginP1Travel:
                move.b  d0,$2D(a0)
                move.b  #3,object_control(a1)
                moveq   #0,d0
                move.b  d0,anim(a1)
                move.b  d0,mapping_frame(a1)
                cmpi.b  #$16,(Current_zone).w
                bne.s   SKSSZTeleporter_SetNonHPZCameraYBounds
                move.w  #$AA0,(Camera_min_X_pos).w
                bra.s   SKSSZTeleporter_ClearEventAndLockScroll
; ---------------------------------------------------------------------------

SKSSZTeleporter_SetNonHPZCameraYBounds:
                move.w  #-$100,(Camera_min_Y_pos).w
                move.w  #$1000,d0
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w

SKSSZTeleporter_ClearEventAndLockScroll:
                clr.b   (Events_bg+$05).w
                moveq   #signextendB(sfx_Transporter),d0
                jsr     (Play_SFX).l
                st      (Scroll_lock).w
                bra.s   SKSSZTeleporter_DrawCharge
; ---------------------------------------------------------------------------

SKSSZTeleporter_RollP1AndSignalCapture:
                bclr    #Status_OnObj,status(a1)
                bset    #Status_Roll,status(a1)
                move.b  #2,anim(a1)
                st      (Events_bg+$04).w

SKSSZTeleporter_DrawCharge:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSSZTeleporter_TravelUpOrRebound:
                jsr     UpdateSszHpzTeleporterSurfaceAndPalette(pc)
                lea     (Player_1).w,a1
                tst.b   $2D(a0)
                bne.s   SKSSZTeleporter_StepUpwardTravel
                move.b  #1,object_control(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                move.w  y_pos(a1),$3E(a0)
                clr.l   $2E(a0)
                clr.l   $32(a0)
                clr.b   $36(a0)
                clr.b   (Scroll_lock).w
                movea.w $3C(a0),a1
                st      routine(a1)
                move.l  #SKSSZTeleporter_SwingP1AtArrival,(a0)
                rts
; ---------------------------------------------------------------------------

; Move P1 by 16 pixels each step. Keep the camera fixed on the last step
SKSSZTeleporter_StepUpwardTravel:
                subi.w  #$10,y_pos(a1)
                subq.b  #1,$2D(a0)
                beq.s   SKSSZTeleporter_DrawTravel
                subi.w  #$10,(Camera_Y_pos).w

SKSSZTeleporter_DrawTravel:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSSZTeleporter_SwingP1AtArrival:
                jsr     UpdateSszHpzTeleporterSurfaceAndPalette(pc)
                lea     (Player_1).w,a1
                move.l  #$20000,d0
                move.l  #$800,d1
                jsr     Gradual_SwingOffset(pc)
                add.w   $3E(a0),d0
                move.w  d0,y_pos(a1)
                tst.l   $2E(a0)
                bmi.s   SKSSZTeleporter_ArrivalReturn
                clr.b   object_control(a1)
                clr.b   anim(a1)
                clr.b   (Events_bg+$04).w
                move.l  #SKSSZTeleporter_TryEnableHPZPalette,(a0)

SKSSZTeleporter_ArrivalReturn:
                rts

; =============== S U B R O U T I N E =======================================

UpdateSszHpzTeleporterSurfaceAndPalette:
                moveq   #$23,d1
                lea     SKSSZTeleporter_SolidHeights(pc),a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped2).l
; End of function UpdateSszHpzTeleporterSurfaceAndPalette

; =============== S U B R O U T I N E =======================================

CycleSszHpzTeleporterPalettePair:
                tst.b   $39(a0)
                beq.s   SKSSZTeleporter_TickPaletteAtRest
                subq.b  #1,$39(a0)
                bra.s   SKSSZTeleporter_PaletteCycleReturn
; ---------------------------------------------------------------------------

SKSSZTeleporter_TickPaletteAtRest:
                move.b  #3,$39(a0)
                move.w  $3A(a0),d0
                bne.s   SKSSZTeleporter_NextPalettePair
                tst.b   $38(a0)
                beq.s   SKSSZTeleporter_PaletteCycleReturn

SKSSZTeleporter_NextPalettePair:
                addq.w  #4,d0
                cmpi.w  #$28,d0
                blo.s   SKSSZTeleporter_WriteZonePalettePair
                moveq   #0,d0

SKSSZTeleporter_WriteZonePalettePair:
                move.w  d0,$3A(a0)
                lea     SKSSZTeleporter_PaletteCyclePairs(pc),a1
                cmpi.b  #$A,(Current_zone).w
                bne.s   SKSSZTeleporter_WriteReversedLine4Pair
                move.l  (a1,d0.w),(Normal_palette_line_3+$18).w
                bra.s   SKSSZTeleporter_PaletteCycleReturn
; ---------------------------------------------------------------------------

SKSSZTeleporter_WriteReversedLine4Pair:
                move.w  2(a1,d0.w),(Normal_palette_line_4+$2).w
                move.w  (a1,d0.w),(Normal_palette_line_4+$4).w

SKSSZTeleporter_PaletteCycleReturn:
                rts
; End of function CycleSszHpzTeleporterPalettePair
