; Owner: game/level/zones/ssz/sk
; Responsibility: Sky Sanctuary arrival beam, player transport, timed character placement and Knuckles scene support
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

SSZArrival_AttemptBeamAllocation:
                jsr     (AllocateObjectAfterCurrent).l
                beq.s   SSZArrival_InitializeBeamAndControllers
                rts
; ---------------------------------------------------------------------------

SSZArrival_InitializeBeamAndControllers:
                move.l  #SSZArrival_RaiseP1OrBeginSwing,(a0)
                move.w  #$1000,y_pos(a0)
                move.w  #-$100,$38(a0)
                move.w  a1,$3C(a0)
                move.l  #Obj_TeleporterBeamExpand,(a1)
                move.b  #$44,render_flags(a1)
                move.b  #$80,height_pixels(a1)
                move.b  #$18,width_pixels(a1)
                move.w  #$80,priority(a1)
                move.w  #make_art_tile(ArtTile_SSZMisc+$88,3,1),art_tile(a1)
                move.l  #Map_SSZHPZTeleporter,mappings(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  #2,mainspr_childsprites(a1)
                move.w  y_pos(a0),$44(a1)
                subi.w  #$88,$44(a1)
                move.b  #$18,$46(a1)
                move.w  a0,$48(a1)
                tst.b   (Current_act).w
                bne.s   SSZArrival_PlaceAndLockPrimaryPlayer
                jsr     (CreateNewSprite4).l
                bne.s   SSZArrival_PlaceAndLockPrimaryPlayer
                move.l  #SSZArrivalKnuckles_WaitThenAllocateActor,(a1)
                move.w  #$60,subtype(a1)

SSZArrival_PlaceAndLockPrimaryPlayer:
                st      (Events_bg+$04).w
                lea     (Player_1).w,a1
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$65,d0
                move.w  d0,y_pos(a1)
                move.b  #3,object_control(a1)
                moveq   #0,d0
                move.b  d0,anim(a1)
                move.b  d0,mapping_frame(a1)
                rts
; ---------------------------------------------------------------------------

SSZArrival_RaiseP1OrBeginSwing:
                jsr     (CycleSszHpzTeleporterPalettePair).l
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                tst.b   $2D(a0)
                bne.w   SSZArrival_RaisePlayerAndCameraStep
                move.b  #1,object_control(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                move.w  #-1,y_vel(a1)
                move.w  y_pos(a1),d1
                move.w  d1,$3E(a0)
                tst.b   (Current_act).w
                beq.s   SSZArrival_AttemptDelayedTailsTransport
                bset    #7,art_tile(a1)
                bra.s   SSZArrival_ContractBeamAndStartSwing
; ---------------------------------------------------------------------------

SSZArrival_AttemptDelayedTailsTransport:
                tst.w   (Player_mode).w
                bne.s   SSZArrival_ContractBeamAndStartSwing
                jsr     (CreateNewSprite4).l
                bne.s   SSZArrival_ContractBeamAndStartSwing
                move.l  #SSZArrivalTails_WaitThenSwingIntoPlace,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  d1,$3E(a1)
                move.w  #$C,subtype(a1)

SSZArrival_ContractBeamAndStartSwing:
                clr.b   (Scroll_lock).w
                movea.w $3C(a0),a1
                st      5(a1)
                move.l  #SSZArrival_SwingP1AndUnlockControls,(a0)
                rts
; ---------------------------------------------------------------------------

SSZArrival_RaisePlayerAndCameraStep:
                subi.w  #8,y_pos(a1)
                subq.b  #1,$2D(a0)
                beq.s   SSZArrival_ReturnAfterAscentStep
                subi.w  #8,(Camera_Y_pos).w

SSZArrival_ReturnAfterAscentStep:
                rts
; ---------------------------------------------------------------------------

SSZArrival_SwingP1AndUnlockControls:
                jsr     (CycleSszHpzTeleporterPalettePair).l
                lea     (Player_1).w,a1
                move.l  #$20000,d0
                move.l  #$800,d1
                jsr     (Gradual_SwingOffset).l
                add.w   $3E(a0),d0
                move.w  d0,y_pos(a1)
                tst.l   $2E(a0)
                bmi.s   SSZArrival_ReturnFromPrimarySwing
                clr.b   object_control(a1)
                clr.b   anim(a1)
                clr.b   (Events_bg+$04).w
                move.l  #SSZArrival_WaitForCameraAndPalette,(a0)

SSZArrival_ReturnFromPrimarySwing:
                rts
; ---------------------------------------------------------------------------

SSZArrival_WaitForCameraAndPalette:
                move.w  (Camera_Y_pos).w,d0
                cmp.w   (Camera_max_Y_pos).w,d0
                bne.s   SSZArrival_ContinueTeleporterPalette
                cmp.w   (Camera_min_Y_pos).w,d0
                beq.s   SSZArrival_DeleteWhenBeamPaletteIdle
                move.w  d0,(Camera_min_Y_pos).w

SSZArrival_DeleteWhenBeamPaletteIdle:
                move.w  $3A(a0),d0
                or.b    $38(a0),d0
                bne.s   SSZArrival_ContinueTeleporterPalette
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SSZArrival_ContinueTeleporterPalette:
                jmp     (CycleSszHpzTeleporterPalettePair).l
; ---------------------------------------------------------------------------

SSZArrivalTails_WaitThenSwingIntoPlace:
                lea     (Player_2).w,a1
                tst.w   subtype(a0)
                beq.s   SSZArrivalTails_ApplySwingAndResumeCPU
                subq.w  #1,subtype(a0)
                bne.s   SSZArrivalTails_ReturnDuringDelayOrSwing
                move.w  x_pos(a0),x_pos(a1)
                move.b  #1,$2E(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                move.w  #-1,y_vel(a1)

SSZArrivalTails_ApplySwingAndResumeCPU:
                move.l  #$20000,d0
                move.l  #$800,d1
                jsr     (Gradual_SwingOffset).l
                add.w   $3E(a0),d0
                move.w  d0,y_pos(a1)
                tst.l   $2E(a0)
                bmi.s   SSZArrivalTails_ReturnDuringDelayOrSwing
                clr.b   object_control(a1)
                clr.b   anim(a1)
                clr.w   (Tails_CPU_flight_timer).w
                move.w  #6,(Tails_CPU_routine).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SSZArrivalTails_ReturnDuringDelayOrSwing:
                rts
; ---------------------------------------------------------------------------

SSZArrivalKnuckles_WaitThenAllocateActor:
                tst.w   subtype(a0)
                beq.s   SSZArrivalK_SwingActorAndSignalReady
                subq.w  #1,subtype(a0)
                bne.s   SSZArrivalK_ArrivalWaitReturn
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SSZArrivalK_ArrivalWaitReturn
                move.l  #Obj_CutsceneKnuckles,(a1)
                move.w  #$100,x_pos(a1)
                move.b  #$2C,subtype(a1)
                move.w  a1,$20(a0)
                move.w  #$C4E,$3E(a0)

SSZArrivalK_SwingActorAndSignalReady:
                movea.w $20(a0),a1
                move.l  #$20000,d0
                move.l  #$800,d1
                jsr     (Gradual_SwingOffset).l
                add.w   $3E(a0),d0
                move.w  d0,y_pos(a1)
                tst.l   $2E(a0)
                bmi.s   SSZArrivalK_ArrivalWaitReturn
                bset    #0,(_unkFAB8).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SSZArrivalK_ArrivalWaitReturn:
                rts
