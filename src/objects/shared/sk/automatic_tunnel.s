; Owner: objects/shared/sk
; Responsibility: Automatic tunnel player capture, scripted movement, final movement and release
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_AutomaticTunnelDelayed:
                subq.b  #1,anim_frame_timer(a0)
                bmi.s   loc_295CA
                rts
; ---------------------------------------------------------------------------

loc_295CA:
                move.b  #0,anim_frame_timer(a0)

Obj_AutomaticTunnel:
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$280,priority(a0)
                move.l  #loc_295E8,(a0)

loc_295E8:
                lea     (Player_1).w,a1
                lea     $30(a0),a4
                bsr.s   sub_2960E
                lea     (Player_2).w,a1
                lea     $3A(a0),a4
                bsr.s   sub_2960E
                move.b  $30(a0),d0
                add.b   $3A(a0),d0
                beq.s   loc_29608                       ; As long as this object is attached to a character, do not destroy it
                rts
; ---------------------------------------------------------------------------

loc_29608:
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_2960E:
                moveq   #0,d0
                move.b  (a4),d0
                move.w  AutoTunnel_Index(pc,d0.w),d0
                jmp     AutoTunnel_Index(pc,d0.w)
; End of function sub_2960E

; ---------------------------------------------------------------------------
AutoTunnel_Index:
                dc.w    Obj_AutoTunnelInit-AutoTunnel_Index
                dc.w    Obj_AutoTunnelRun-AutoTunnel_Index
                dc.w    Obj_AutoTunnelLastMove-AutoTunnel_Index
; ---------------------------------------------------------------------------

Obj_AutoTunnelInit:
                tst.w   (Debug_placement_mode).w
                bne.w   locret_296D2                    ; If debug mode is on, don't bother
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   locret_296D2
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$18,d1
                cmpi.w  #$28,d1
                bhs.w   locret_296D2                    ; Only activate if player is in range
                tst.b   object_control(a1)
                bne.s   locret_296D2                    ; If under control of another object, don't activate
                addq.b  #2,(a4)
                move.b  #$81,object_control(a1)         ; Lock this object to Sonic/Tails
                move.b  #2,anim(a1)                     ; Set player to rolling animation
                clr.b   jumping(a1)                     ; Ensure they're no longer jumping
                move.w  #$800,ground_vel(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)                    ; Null actual velocity but make player very fast
                bclr    #p1_pushing_bit,status(a0)
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)        ; Player is not pushing anything and not in the air
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)             ; Lock player's position to object's position
                clr.b   1(a4)
                bsr.w   AutoTunnel_GetPath              ; Get the first path of the tunnel
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l
                btst    #5,subtype(a0)
                beq.s   locret_296D2
                tst.b   (Current_act).w                 ; If bit 5 of object subtype is set and we're in an act 2
                beq.s   locret_296D2
                bclr    #Status_FireShield,status_secondary(a1)
                beq.s   loc_296C4
                bclr    #Status_Shield,status_secondary(a1)

loc_296C4:
                bclr    #Status_LtngShield,status_secondary(a1)
                beq.s   locret_296D2
                bclr    #Status_Shield,status_secondary(a1)  ; Disable fire/lightning shields. This is probably for the water tunnels in LBZ2

locret_296D2:
                rts
; ---------------------------------------------------------------------------

Obj_AutoTunnelRun:
                subq.b  #1,2(a4)
                bhi.w   loc_29768
                movea.l 6(a4),a2                        ; If timer has exhausted, get address of path data
                move.w  (a2)+,d4
                move.w  d4,x_pos(a1)
                move.w  (a2)+,d5
                move.w  d5,y_pos(a1)                    ; Get the new starting position
                tst.b   subtype(a0)
                bpl.s   loc_296F4
                subq.w  #8,a2                           ; See if we're going backwards

loc_296F4:
                move.l  a2,6(a4)                        ; Replace address of path
                subq.w  #4,4(a4)
                beq.s   loc_2970A                       ; If path has exhausted, branch
                move.w  (a2)+,d4
                move.w  (a2)+,d5
                move.w  #$1000,d2
                bra.w   AutoTunnel_CalcSpeed            ; Get new velocity
; ---------------------------------------------------------------------------

loc_2970A:
                addq.b  #2,(a4)                         ; Go to next routine
                move.b  #2,2(a4)
                andi.w  #$FFF,y_pos(a1)                 ; Make sure the player's Y position remains valid
                btst    #6,subtype(a0)                  ; If bit 6 is not set
                bne.s   loc_2972C
                move.w  #0,x_vel(a1)                    ; Then stop player movement. Otherwise he'll continue moving
                move.w  #0,y_vel(a1)

loc_2972C:
                moveq   #signextendB(sfx_TubeLauncher),d0
                jsr     (Play_SFX).l                    ; Play that nifty little cannon shooting sound
                btst    #5,subtype(a0)
                beq.s   loc_29768
                movea.l a1,a2                           ; If bit 5 set (for LBZ2, again), make the waterfall
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_29766
                move.l  #Obj_TunnelExhaustControl,(a1)
                move.w  x_pos(a2),x_pos(a1)
                move.w  y_pos(a2),y_pos(a1)
                move.w  x_vel(a2),x_vel(a1)
                move.w  y_vel(a2),y_vel(a1)

loc_29766:
                movea.l a2,a1

loc_29768:
                move.l  x_pos(a1),d2                    ; Perform movement
                move.l  y_pos(a1),d3
                move.w  x_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d2
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d3                           ; Add velocity to player
                move.l  d2,x_pos(a1)
                move.l  d3,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

Obj_AutoTunnelLastMove:
                subq.b  #1,2(a4)
                bne.s   loc_2979A                       ; This is the last movement
                clr.b   object_control(a1)
                clr.b   (a4)

loc_2979A:
                addi.w  #$38,y_vel(a1)                  ; Reapply gravity
                bra.s   loc_29768

; =============== S U B R O U T I N E =======================================

AutoTunnel_GetPath:
                move.b  subtype(a0),d0
                bpl.s   loc_297D6
                andi.w  #$1F,d0                         ; If negative, then the path is reversed
                add.w   d0,d0
                add.w   d0,d0
                lea     (AutoTunnel_Data).l,a2
                movea.l (a2,d0.w),a2                    ; Get address of movement data
                move.w  (a2)+,d0
                subq.w  #4,d0
                move.w  d0,4(a4)
                lea     (a2,d0.w),a2
                move.w  (a2)+,d4
                move.w  d4,x_pos(a1)
                move.w  (a2)+,d5
                move.w  d5,y_pos(a1)                    ; Set absolute position of player
                subq.w  #8,a2
                bra.s   loc_2980C
; ---------------------------------------------------------------------------

loc_297D6:
                cmpi.b  #$10,d0
                bne.s   loc_297E6
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_297E6
                moveq   #0,d0                           ; If playing as Tails, use path 0 when doing path $10

loc_297E6:
                andi.w  #$1F,d0
                add.w   d0,d0
                add.w   d0,d0
                lea     (AutoTunnel_Data).l,a2
                movea.l (a2,d0.w),a2
                move.w  (a2)+,4(a4)
                subq.w  #4,4(a4)
                move.w  (a2)+,d4
                move.w  d4,x_pos(a1)
                move.w  (a2)+,d5
                move.w  d5,y_pos(a1)                    ; Set absolute position of player

loc_2980C:
                move.l  a2,6(a4)
                move.w  (a2)+,d4
                move.w  (a2)+,d5                        ; Get next position
                move.w  #$1000,d2

AutoTunnel_CalcSpeed:
                moveq   #0,d0
                move.w  d2,d3
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                bge.s   loc_29828
                neg.w   d0
                neg.w   d2                              ; Change X velocity depending on direction of destination

loc_29828:
                moveq   #0,d1
                move.w  d5,d1
                sub.w   $14(a1),d1
                bge.s   loc_29836
                neg.w   d1
                neg.w   d3                              ; Change Y velocity depending on direction of destination

loc_29836:
                cmp.w   d0,d1
                blo.s   loc_29868
                moveq   #0,d1                           ; If X distance is less than Y distance
                move.w  d5,d1
                sub.w   y_pos(a1),d1
                swap    d1
                divs.w  d3,d1
                moveq   #0,d0
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                beq.s   loc_29854
                swap    d0
                divs.w  d1,d0

loc_29854:
                move.w  d0,x_vel(a1)                    ; Calculate and set X velocity assuming a Y velocity of $10 pixels
                move.w  d3,y_vel(a1)
                tst.w   d1
                bpl.s   loc_29862
                neg.w   d1

loc_29862:
                move.w  d1,2(a4)                        ; The quotient of the distance/speed produces a proper timer used for movement
                rts
; ---------------------------------------------------------------------------

loc_29868:
                moveq   #0,d0                           ; If Y distance is less than X distance
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                swap    d0
                divs.w  d2,d0
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a1),d1
                beq.s   loc_29882
                swap    d1
                divs.w  d0,d1

loc_29882:
                move.w  d1,y_vel(a1)                    ; Calculate and set Y velocity assuming a X velocity of $10 pixels
                move.w  d2,x_vel(a1)
                tst.w   d0
                bpl.s   loc_29890
                neg.w   d0

loc_29890:
                move.w  d0,2(a4)                        ; See above
                rts
; End of function AutoTunnel_GetPath
