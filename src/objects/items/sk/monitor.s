; Owner: objects/items/sk
; Responsibility: Item monitor initialization, solid contact, breakage and product-specific reward effects with animation resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_Monitor:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Monitor_Index(pc,d0.w),d1
                jmp     Monitor_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Monitor_Index:
                dc.w    Obj_MonitorInit-Monitor_Index
                dc.w    Obj_MonitorMain-Monitor_Index
                dc.w    Obj_MonitorBreak-Monitor_Index
                dc.w    Obj_MonitorAnimate-Monitor_Index
                dc.w    SKMonitor_Box_DrawAndCullCurrentX-Monitor_Index
; ---------------------------------------------------------------------------

Obj_MonitorInit:
                addq.b  #2,routine(a0)                  ; => Obj_MonitorMain
                move.b  #$F,y_radius(a0)
                move.b  #$F,x_radius(a0)
                move.l  #Map_Monitor,mappings(a0)
                move.w  #make_art_tile(ArtTile_Monitors,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$180,priority(a0)
                move.b  #$E,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  respawn_addr(a0),d0             ; Get address in respawn table
                beq.s   .notbroken                      ; If it's zero, it isn't remembered
                movea.w d0,a2                           ; Load address into a2
                btst    #0,(a2)                         ; Is this monitor broken?
                beq.s   .notbroken                      ; If not, branch
                move.b  #$B,mapping_frame(a0)           ; Use 'broken monitor' frame
                move.l  #Sprite_OnScreen_Test,(a0)
                rts
; ---------------------------------------------------------------------------

                .notbroken:
                move.b  #$46,collision_flags(a0)
                move.b  subtype(a0),anim(a0)            ; Subtype determines what powerup is inside

Obj_MonitorMain:
                bsr.s   Obj_MonitorFall
                move.w  #$19,d1                         ; Monitor's width
                move.w  #$10,d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                bsr.w   SolidObject_Monitor_SonicKnux
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   SolidObject_Monitor_Tails
                jsr     (Add_SpriteToCollisionResponseList).l
                lea     (Ani_Monitor).l,a1
                bsr.w   Animate_Sprite

SKMonitor_Box_DrawAndCullCurrentX:
                bra.w   Sprite_OnScreen_Test
; ---------------------------------------------------------------------------

Obj_MonitorAnimate:
                cmpi.b  #$B,mapping_frame(a0)           ; Is monitor broken?
                bne.s   .notbroken                      ; If not, branch
                move.l  #SKMonitor_Box_DrawAndCullCurrentX,(a0)

                .notbroken:
                lea     (Ani_Monitor).l,a1
                bsr.w   Animate_Sprite
                bra.w   Sprite_OnScreen_Test

; =============== S U B R O U T I N E =======================================

Obj_MonitorFall:
                move.b  routine_secondary(a0),d0
                beq.s   SKMonitor_Box_ReturnFromNativeFallOrSkip
                btst    #1,render_flags(a0)             ; Is monitor upside down?
                bne.s   Obj_MonitorFallUpsideDown       ; If so, branch
                bsr.w   MoveSprite
                tst.w   y_vel(a0)                       ; Is monitor moving up?
                bmi.s   SKMonitor_Box_ReturnFromNativeFallOrSkip  ; If so, return
                jsr     (ObjCheckFloorDist).l
                tst.w   d1                              ; Is monitor in the ground?
                beq.s   .inground                       ; If so, branch
                bpl.s   SKMonitor_Box_ReturnFromNativeFallOrSkip  ; if not, return

                .inground:
                add.w   d1,y_pos(a0)                    ; Move monitor out of the ground
                clr.w   y_vel(a0)
                clr.b   routine_secondary(a0)           ; Stop monitor from falling
                rts
; ---------------------------------------------------------------------------

Obj_MonitorFallUpsideDown:
                bsr.w   MoveSprite2
                subi.w  #$38,y_vel(a0)
                tst.w   y_vel(a0)                       ; Is monitor moving down?
                bpl.s   SKMonitor_Box_ReturnFromNativeFallOrSkip  ; If so, return
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1                              ; Is monitor in the ground (ceiling)?
                beq.s   .inground                       ; If so, branch
                bpl.s   SKMonitor_Box_ReturnFromNativeFallOrSkip  ; if not, return

                .inground:
                sub.w   d1,y_pos(a0)                    ; Move monitor out of the ground
                clr.w   y_vel(a0)
                clr.b   routine_secondary(a0)           ; Stop monitor from falling

SKMonitor_Box_ReturnFromNativeFallOrSkip:
                rts
; End of function Obj_MonitorFall

; =============== S U B R O U T I N E =======================================

SolidObject_Monitor_SonicKnux:
                btst    d6,status(a0)                   ; Is Sonic/Knux standing on the monitor?
                bne.s   Monitor_ChkOverEdge             ; If so, branch
                cmpi.b  #2,anim(a1)                     ; Is Sonic/Knux in their rolling animation?
                beq.s   SKMonitor_SkipNewSolidReturn    ; If so, return
                cmpi.b  #2,character_id(a1)             ; Is character Knuckles?
                bne.s   SKMonitor_ContinueSolidContact  ; If not, branch
                cmpi.b  #1,double_jump_flag(a1)         ; Is Knuckles gliding?
                beq.s   SKMonitor_SkipNewSolidReturn    ; If so, return
                cmpi.b  #3,double_jump_flag(a1)         ; Is Knuckles sliding after gliding?
                bne.s   SKMonitor_ContinueSolidContact  ; If not, branch

SKMonitor_SkipNewSolidReturn:
                rts
; ---------------------------------------------------------------------------

SKMonitor_ContinueSolidContact:
                bra.w   SolidObject_cont
; End of function SolidObject_Monitor_SonicKnux

; =============== S U B R O U T I N E =======================================

SolidObject_Monitor_Tails:
                btst    d6,status(a0)                   ; Is Tails standing on the monitor?
                bne.s   Monitor_ChkOverEdge             ; If so, branch
                tst.w   (Competition_mode).w            ; Are we in competition mode?
                beq.w   SolidObject_cont                ; If not, branch
                cmpi.b  #2,anim(a1)                     ; Is Tails in his rolling animation?
                bne.w   SolidObject_cont                ; If not, branch
                rts
; End of function SolidObject_Monitor_Tails

; ---------------------------------------------------------------------------

Monitor_ChkOverEdge:
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)        ; Is the character in the air?
                bne.s   .notonmonitor                   ; If so, branch
; Check if character is standing on
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   .notonmonitor                   ; Branch, if character is behind the left edge of the monitor
                cmp.w   d2,d0
                blo.s   Monitor_CharStandOn             ; Branch, if character is not beyond the right edge of the monitor

                .notonmonitor:
; if the character isn't standing on the monitor
                bclr    #Status_OnObj,status(a1)        ; Clear 'on object' bit
                bset    #Status_InAir,status(a1)        ; Set 'in air' bit
                bclr    d6,status(a0)                   ; Clear 'standing on' bit for the current character
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

Monitor_CharStandOn:
                move.w  d4,d2
                bsr.w   MvSonicOnPtfm
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

Obj_MonitorBreak:
                move.b  status(a0),d0
                andi.b  #standing_mask|pushing_mask,d0  ; Is someone touching the monitor?
                beq.s   Obj_MonitorSpawnIcon            ; If not, branch
                move.b  d0,d1
                andi.b  #p1_standing|p1_pushing,d1      ; Is it the main character?
                beq.s   .notmainchar                    ; If not, branch
                andi.b  #$D7,(Player_1+status).w
                ori.b   #1<<Status_InAir,(Player_1+status).w  ; Prevent main character from walking in the air

                .notmainchar:
                andi.b  #p2_standing|p2_pushing,d0      ; Is it the sidekick?
                beq.s   Obj_MonitorSpawnIcon            ; If not, branch
                andi.b  #$D7,(Player_2+status).w
                ori.b   #1<<Status_InAir,(Player_2+status).w  ; Prevent sidekick from walking in the air

Obj_MonitorSpawnIcon:
                andi.b  #3,status(a0)
                move.b  #0,collision_flags(a0)
                bsr.w   AllocateObjectAfterCurrent
                bne.s   .skipiconcreation
                move.l  #Obj_MonitorContents,(a1)
                move.w  x_pos(a0),x_pos(a1)             ; Set icon's position
                move.w  y_pos(a0),y_pos(a1)
                move.b  anim(a0),anim(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.b  status(a0),status(a1)
                move.w  parent(a0),parent(a1)

                .skipiconcreation:
                bsr.w   AllocateObjectAfterCurrent
                bne.s   .skipexplosioncreation
                move.l  #Obj_Explosion,(a1)
                addq.b  #2,routine(a1)                  ; => loc_1E61A
                move.w  x_pos(a0),x_pos(a1)             ; Set explosion's position
                move.w  y_pos(a0),y_pos(a1)

                .skipexplosioncreation:
                move.w  respawn_addr(a0),d0             ; Get address in respawn table
                beq.s   .notremembered                  ; If it's zero, it isn't remembered
                movea.w d0,a2                           ; Load address into a2
                bset    #0,(a2)                         ; Mark monitor as destroyed

                .notremembered:
                move.b  #$A,anim(a0)                    ; Display 'broken' animation
                move.l  #Obj_MonitorAnimate,(a0)
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

Obj_MonitorContents:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MonitorContents_Index(pc,d0.w),d1
                jmp     MonitorContents_Index(pc,d1.w)
; ---------------------------------------------------------------------------
MonitorContents_Index:
                dc.w    SKMonitorIcon_InitFirstPiece-MonitorContents_Index
                dc.w    SKMonitor_Icon_MoveTowardApexThenDraw-MonitorContents_Index
                dc.w    SKMonitorIcon_TickLifeOrDelete-MonitorContents_Index
; ---------------------------------------------------------------------------

SKMonitorIcon_InitFirstPiece:
                addq.b  #2,routine(a0)
                move.w  #make_art_tile(ArtTile_Monitors,0,1),art_tile(a0)
                ori.b   #$24,render_flags(a0)
                move.w  #$180,priority(a0)
                move.b  #8,width_pixels(a0)
                move.w  #-$300,y_vel(a0)
                btst    #1,render_flags(a0)
                beq.s   SKMonitorIcon_SelectFirstPiece
                neg.w   y_vel(a0)

SKMonitorIcon_SelectFirstPiece:
                moveq   #0,d0
                move.b  anim(a0),d0
                addq.b  #1,d0
                move.b  d0,mapping_frame(a0)
                movea.l #Map_Monitor,a1
                add.b   d0,d0
                adda.w  (a1,d0.w),a1
                addq.w  #2,a1
                move.l  a1,mappings(a0)

SKMonitor_Icon_MoveTowardApexThenDraw:
                bsr.s   MonitorIconSKMoveToApexAndDispatchReward
                bra.w   Draw_Sprite

; =============== S U B R O U T I N E =======================================

MonitorIconSKMoveToApexAndDispatchReward:
                btst    #1,render_flags(a0)
                bne.s   SKMonitorIcon_MoveFlippedToApex
                tst.w   y_vel(a0)
                bpl.w   SKMonitorIcon_InitLifeAndLedger
                bsr.w   MoveSprite2
                addi.w  #$18,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKMonitorIcon_MoveFlippedToApex:
                tst.w   y_vel(a0)
                bmi.w   SKMonitorIcon_InitLifeAndLedger
                bsr.w   MoveSprite2
                subi.w  #$18,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

; Set a 30-update word timer and select the broken-monitor counter for the recipient
SKMonitorIcon_InitLifeAndLedger:
                addq.b  #2,routine(a0)
                move.w  #30-1,anim_frame_timer(a0)
                movea.w parent(a0),a1
                lea     (Monitors_broken).w,a2
                cmpa.w  #Player_1,a1
                beq.s   SKMonitorIcon_DispatchAnimReward
                lea     (Monitors_broken_P2).w,a2

; Use the animation byte as an unchecked word-table index
SKMonitorIcon_DispatchAnimReward:
                moveq   #0,d0
                move.b  anim(a0),d0
                add.w   d0,d0
                move.w  SKMonitor_Icon_RewardRelativeWordTable(pc,d0.w),d0
                jmp     SKMonitor_Icon_RewardRelativeWordTable(pc,d0.w)
; End of function MonitorIconSKMoveToApexAndDispatchReward

; ---------------------------------------------------------------------------
SKMonitor_Icon_RewardRelativeWordTable:
                dc.w    Monitor_Give_Eggman-SKMonitor_Icon_RewardRelativeWordTable
                dc.w    Monitor_Give_1up-SKMonitor_Icon_RewardRelativeWordTable
                dc.w    Monitor_Give_Eggman-SKMonitor_Icon_RewardRelativeWordTable
                dc.w    Monitor_Give_Rings-SKMonitor_Icon_RewardRelativeWordTable
                dc.w    Monitor_Give_SpeedShoes-SKMonitor_Icon_RewardRelativeWordTable
                dc.w    Monitor_Give_FireShield-SKMonitor_Icon_RewardRelativeWordTable
                dc.w    Monitor_Give_LightningShield-SKMonitor_Icon_RewardRelativeWordTable
                dc.w    Monitor_Give_BubbleShield-SKMonitor_Icon_RewardRelativeWordTable
                dc.w    Monitor_Give_Invincibility-SKMonitor_Icon_RewardRelativeWordTable
                dc.w    Monitor_Give_SuperSonic-SKMonitor_Icon_RewardRelativeWordTable
; ---------------------------------------------------------------------------

Monitor_Give_Eggman:
                addq.w  #1,(a2)
                jmp     (HurtPlayerFromSolidHazard).l
; ---------------------------------------------------------------------------

Monitor_Give_1up:
                addq.w  #1,(Monitors_broken).w
                addq.b  #1,(Life_count).w
                addq.b  #1,(Update_HUD_life_count).w
                moveq   #signextendB(mus_ExtraLife),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

Monitor_Give_Rings:
                addq.w  #1,(a2)
                lea     (Ring_count).w,a2
                lea     (Update_HUD_ring_count).w,a3
                lea     (Extra_life_flags).w,a4
                lea     (Total_ring_count).w,a5
                addi.w  #10,(a5)
                cmpi.w  #999,(a5)
                blo.s   SKMonitorRings_CapP1At999
                move.w  #999,(a5)

SKMonitorRings_CapP1At999:
                addi.w  #10,(a2)
                cmpi.w  #999,(a2)
                blo.s   SKMonitorRings_UpdateHudAndLives
                move.w  #999,(a2)

; Test the 100-ring life flag before the 200-ring flag
SKMonitorRings_UpdateHudAndLives:
                ori.b   #1,(a3)
                cmpi.w  #100,(a2)
                blo.s   SKMonitorRings_PlayRightSound
                bset    #1,(a4)
                beq.s   SKMonitorRings_PickLifeOrEggman
                cmpi.w  #200,(a2)
                blo.s   SKMonitorRings_PlayRightSound
                bset    #2,(a4)
                beq.s   SKMonitorRings_PickLifeOrEggman

; Send the right-ring sound through Play_Music
SKMonitorRings_PlayRightSound:
                moveq   #signextendB(sfx_RingRight),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

SKMonitorRings_PickLifeOrEggman:
                cmpa.w  #Player_1,a1
                beq.w   Monitor_Give_1up
                bra.w   Monitor_Give_Eggman
; ---------------------------------------------------------------------------

Monitor_Give_SpeedShoes:
                addq.w  #1,(a2)
                bset    #Status_SpeedShoes,status_secondary(a1)
                move.b  #(20*60)/8,speed_shoes_timer(a1)
                cmpa.w  #Player_1,a1
                bne.s   SKMonitorShoes_SetP2SpeedParams
                cmpi.w  #2,(Player_mode).w
                beq.s   SKMonitorShoes_SetP2SpeedParams
                move.w  #$C00,(Max_speed).w
                move.w  #$18,(Acceleration).w
                move.w  #$80,(Deceleration).w
                bra.s   SKMonitorShoes_SetGlobalTempo8
; ---------------------------------------------------------------------------

SKMonitorShoes_SetP2SpeedParams:
                move.w  #$C00,(Max_speed_P2).w
                move.w  #$18,(Acceleration_P2).w
                move.w  #$80,(Deceleration_P2).w

SKMonitorShoes_SetGlobalTempo8:
                moveq   #8,d0
                jmp     (Change_Music_Tempo).l
; ---------------------------------------------------------------------------

Monitor_Give_FireShield:
                addq.w  #1,(a2)
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                bset    #Status_FireShield,status_secondary(a1)
                moveq   #signextendB(sfx_FireShield),d0
                jsr     (Play_Music).l
                tst.b   parent+1(a0)
                bne.s   SKMonitorFireShield_InitP2Slot
                move.l  #Obj_FireShield,(Shield).w
                move.w  a1,(Shield+parent).w
                rts
; ---------------------------------------------------------------------------

SKMonitorFireShield_InitP2Slot:
                move.l  #Obj_FireShield,(Shield_P2).w
                move.w  a1,(Shield_P2+parent).w
                rts
; ---------------------------------------------------------------------------

Monitor_Give_LightningShield:
                addq.w  #1,(a2)
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                bset    #Status_LtngShield,status_secondary(a1)
                moveq   #signextendB(sfx_LightningShield),d0
                jsr     (Play_Music).l
                tst.b   parent+1(a0)
                bne.s   SKMonitorLightning_InitP2Slot
                move.l  #Obj_LightningShield,(Shield).w
                move.w  a1,(Shield+parent).w
                rts
; ---------------------------------------------------------------------------

SKMonitorLightning_InitP2Slot:
                move.l  #Obj_LightningShield,(Shield_P2).w
                move.w  a1,(Shield_P2+parent).w
                rts
; ---------------------------------------------------------------------------

Monitor_Give_BubbleShield:
                addq.w  #1,(a2)
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                bset    #Status_BublShield,status_secondary(a1)
                moveq   #signextendB(sfx_BubbleShield),d0
                jsr     (Play_Music).l
                tst.b   parent+1(a0)
                bne.s   SKMonitorBubbleShield_InitP2Slot
                move.l  #Obj_BubbleShield,(Shield).w
                move.w  a1,(Shield+parent).w
                rts
; ---------------------------------------------------------------------------

SKMonitorBubbleShield_InitP2Slot:
                move.l  #Obj_BubbleShield,(Shield_P2).w
                move.w  a1,(Shield_P2+parent).w
                rts
; ---------------------------------------------------------------------------

Monitor_Give_Invincibility:
                addq.w  #1,(a2)
                tst.b   (Super_Sonic_Knux_flag).w
                bne.s   SKMonitorStars_GrantReturn
                tst.b   (Super_Tails_flag).w
                bne.s   SKMonitorStars_GrantReturn
                bset    #1,status_secondary(a1)
                move.b  #(20*60)/8,invincibility_timer(a1)
                tst.b   (Boss_flag).w
                bne.s   SKMonitorStars_SelectSlot
                cmpi.b  #12,air_left(a1)
                bls.s   SKMonitorStars_SelectSlot
                moveq   #signextendB(mus_Invincibility),d0
                jsr     (Play_Music).l

; Choose the fixed stars slot using the low byte of the parent pointer
SKMonitorStars_SelectSlot:
                tst.b   parent+1(a0)
                bne.s   SKMonitorStars_InitP2Slot
                move.l  #Obj_Invincibility,(Invincibility_stars).w
                move.w  a1,(Invincibility_stars+parent).w
                rts
; ---------------------------------------------------------------------------

SKMonitorStars_InitP2Slot:
                move.l  #Obj_Invincibility,(Invincibility_stars_P2).w
                move.w  a1,(Invincibility_stars_P2+parent).w

SKMonitorStars_GrantReturn:
                rts
; ---------------------------------------------------------------------------

Monitor_Give_SuperSonic:
                addq.w  #1,(a2)
                addi.w  #50,(Ring_count).w
                move.b  #1,(Super_palette_status).w
                move.b  #$F,(Palette_timer).w
                move.b  #1,(Super_Sonic_Knux_flag).w    ; Super
                move.w  #60,(Super_frame_count).w
                move.w  #$800,(Max_speed).w
                move.w  #$18,(Acceleration).w
                move.w  #$C0,(Deceleration).w
                move.b  #$1F,(Player_1+anim).w
                cmpi.w  #2,(Player_mode).w
                bne.s   .notTails

                move.b  #0,(Super_Sonic_Knux_flag).w    ; Normal
                move.b  #1,(Super_Tails_flag).w         ; Super
                move.b  #$29,(Player_1+anim).w
                move.w  #$800,(Max_speed_P2).w
                move.w  #$18,(Acceleration_P2).w
                move.w  #$C0,(Deceleration_P2).w
                move.l  #Obj_SuperTailsBirds,(Invincibility_stars).w
                bra.s   .continued
; ---------------------------------------------------------------------------

                .notTails:
                bhs.s   .hyperKnuckles
                move.l  #Map_SuperSonic,(Player_1+mappings).w
                move.b  #-1,(Super_Sonic_Knux_flag).w   ; Hyper
                move.w  #$A00,(Max_speed).w
                move.w  #$30,(Acceleration).w
                move.w  #$100,(Deceleration).w
                move.l  #Obj_HyperSonic_Stars,(Invincibility_stars).w
                move.l  #Obj_HyperSonicKnux_Trail,(Super_stars).w
                bra.s   .continued
; ---------------------------------------------------------------------------

                .hyperKnuckles:
; Bug: Knuckles gets his Hyper after-images, but isn't actually marked as Hyper
                move.l  #Obj_HyperSonicKnux_Trail,(Super_stars).w

                .continued:
                move.b  #$81,(Player_1+object_control).w
                move.b  #0,(Player_1+invincibility_timer).w
                bset    #Status_Invincible,status_secondary(a1)
                moveq   #signextendB(sfx_SuperTransform),d0
                jsr     (Play_SFX).l
                moveq   #signextendB(mus_Invincibility),d0  ; play invincibility theme
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------
; unused
                rts
; ---------------------------------------------------------------------------

SKMonitorIcon_TickLifeOrDelete:
                subq.w  #1,anim_frame_timer(a0)
                bmi.w   Delete_Current_Sprite
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------
Ani_Monitor:
                include "src/objects/shared/monitors/animations/monitor.s"
Map_Monitor:
                include "src/objects/shared/monitors/mappings/monitor.s"
