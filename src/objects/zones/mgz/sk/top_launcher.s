; Owner: objects/zones/mgz/sk
; Responsibility: Marble Garden spinning top launcher initialization, motion and player response
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MGZTopLauncher:
                move.l  #Map_MGZTopPlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_MGZMisc2,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.b  #2,mapping_frame(a0)
                move.w  #$10,$30(a0)
                move.w  #$C00,d0
                btst    #0,status(a0)
                beq.s   SKMGZTopLauncher_SetSpeedAndTryCreateTop
                neg.w   d0

SKMGZTopLauncher_SetSpeedAndTryCreateTop:
                move.w  d0,x_vel(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKMGZTopLauncher_StartHoldingTop
                move.l  #Obj_MGZTopPlatform,(a1)
                move.b  #1,subtype(a1)
                move.w  a1,$3E(a0)

SKMGZTopLauncher_StartHoldingTop:
                move.l  #SKMGZTopLauncher_HoldTopAndCheckRiders,(a0)

SKMGZTopLauncher_HoldTopAndCheckRiders:
                movea.w $3E(a0),a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addq.w  #4,$24(a1)
                cmpi.b  #4,$40(a1)
                beq.s   SKMGZTopLauncher_BeginSink
                cmpi.b  #4,$42(a1)
                bne.s   SKMGZTopLauncher_DrawHoldingLauncher

SKMGZTopLauncher_BeginSink:
                move.l  #SKMGZTopLauncher_StepSink,(a0)

SKMGZTopLauncher_DrawHoldingLauncher:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKMGZTopLauncher_StepSink:
                movea.w $3E(a0),a1
                addq.w  #1,y_pos(a0)
                subq.w  #1,$30(a0)
                bne.s   SKMGZTopLauncher_HoldOrReleaseTop
                move.l  #SKMGZTopLauncher_DrawSinkingLauncher,(a0)
                move.w  #$7F00,x_pos(a0)

SKMGZTopLauncher_HoldOrReleaseTop:
                cmpi.w  #4,$30(a0)
                beq.s   SKMGZTopLauncher_ReleaseTopWithSpeed
                bcs.s   SKMGZTopLauncher_DrawSinkingLauncher
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addq.w  #4,$24(a1)
                bra.s   SKMGZTopLauncher_DrawSinkingLauncher
; ---------------------------------------------------------------------------

SKMGZTopLauncher_ReleaseTopWithSpeed:
                move.w  x_vel(a0),d1
                move.w  d1,x_vel(a1)
                move.w  d1,ground_vel(a1)
                move.b  #1,$34(a1)
                bclr    #1,status(a1)
                move.b  #0,subtype(a1)

SKMGZTopLauncher_DrawSinkingLauncher:
                jmp     (Sprite_OnScreen_Test).l
; End of function Obj_MGZTopLauncher
