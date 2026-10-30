; Owner: objects/zones/lbz/sk
; Responsibility: Launch Base tube elevator initialization, movement dispatch, player transport and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZTubeElevator:
                move.l  #Map_LBZTubeElevator,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZTubeTrans,1,0),art_tile(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$30,height_pixels(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                btst    #6,subtype(a0)
                beq.s   loc_29CEC
                move.b  #0,mapping_frame(a0)            ; If BIT 6 of subtype set, the elevator remains closed
                move.b  #0,angle(a0)
                move.l  #Obj_LBZTubeElevatorClosed,(a0)
                bra.s   Obj_LBZTubeElevatorClosed
; ---------------------------------------------------------------------------

loc_29CEC:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_29D38
                move.l  #loc_29DEC,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_LBZTubeElevator,mappings(a1)
                move.w  #make_art_tile(ArtTile_LBZTubeTrans,1,0),art_tile(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                ori.b   #4,render_flags(a1)
                move.w  #$280,priority(a1)
                move.b  #6,mapping_frame(a1)
                move.w  a0,parent(a1)

loc_29D38:
                move.b  #2,mapping_frame(a0)
                move.b  #2,angle(a0)
                move.l  #Obj_LBZTubeElevatorActive,(a0)

Obj_LBZTubeElevatorActive:
                bsr.w   LBZTubeElevator_Action
                lea     (Player_1).w,a1
                lea     $38(a0),a2
                bsr.w   LBZTubeElevator_CheckPlayer
                lea     (Player_2).w,a1
                addq.w  #1,a2
                bsr.w   LBZTubeElevator_CheckPlayer
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_LBZTubeElevatorClosed:
                lea     (Player_1).w,a1
                btst    #Status_OnObj,status(a1)
                beq.s   loc_29D8E
                tst.b   object_control(a1)
                beq.s   loc_29D8E
                movea.w interact(a1),a2
                cmpi.l  #Obj_LBZTubeElevatorActive,(a2)
                bne.s   loc_29D8E
                move.w  #$7FF0,x_pos(a0)

loc_29D8E:
                lea     $2E(a0),a4
                addq.b  #2,1(a4)
                move.b  1(a4),d0
                cmpi.b  #$B0,d0
                blo.s   loc_29DAA
                cmpi.b  #$D0,d0
                bhs.s   loc_29DAA
                addi.b  #$20,d0

loc_29DAA:
                move.b  d0,1(a4)
                jsr     (GetSineCosine).l
                cmpi.w  #$100,d0
                bne.s   loc_29DBC
                subq.w  #1,d0

loc_29DBC:
                asr.w   #6,d0
                move.w  $46(a0),d2
                sub.w   d0,d2
                move.w  d2,y_pos(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_29DEC:
                movea.w parent(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                tst.b   render_flags(a1)
                bpl.s   loc_29E16
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.b  byte_29E1C(pc,d0.w),d0
                ext.w   d0
                add.w   x_pos(a1),d0
                move.w  d0,x_pos(a0)

loc_29E16:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
byte_29E1C:
                dc.b    0,  -8,  -8,   0,   8,   8
                even

; =============== S U B R O U T I N E =======================================

LBZTubeElevator_Action:
                lea     $2E(a0),a4
                movea.l a0,a1
                moveq   #0,d0
                move.b  (a4),d0
                move.w  LBZTubeElevator_Index(pc,d0.w),d0
                jmp     LBZTubeElevator_Index(pc,d0.w)
; End of function LBZTubeElevator_Action

; ---------------------------------------------------------------------------
LBZTubeElevator_Index:
                dc.w    LBZTubeElevator_WaitPlayer-LBZTubeElevator_Index
                dc.w    LBZTubeElevator_StartSpin-LBZTubeElevator_Index
                dc.w    LBZTubeElevator_MovePath-LBZTubeElevator_Index
                dc.w    LBZTubeElevator_SlowSpin-LBZTubeElevator_Index
                dc.w    LBZTubeElevator_WaitExit-LBZTubeElevator_Index
                dc.w    LBZTubeElevator_EndSpin-LBZTubeElevator_Index
                dc.w    LBZTubeElevator_Closed-LBZTubeElevator_Index
; ---------------------------------------------------------------------------

LBZTubeElevator_WaitPlayer:
                cmpi.w  #$200,$38(a0)
                beq.s   loc_29E52
                cmpi.w  #$202,$38(a0)
                bne.s   loc_29E5E

loc_29E52:
                addq.b  #2,(a4)
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l
                bra.s   LBZTubeElevator_StartSpin
; ---------------------------------------------------------------------------

loc_29E5E:
                addq.b  #2,1(a4)
                move.b  1(a4),d0
                cmpi.b  #$B0,d0
                blo.s   loc_29E76
                cmpi.b  #$D0,d0
                bhs.s   loc_29E76
                addi.b  #$20,d0

loc_29E76:
                move.b  d0,1(a4)
                jsr     (GetSineCosine).l
                cmpi.w  #$100,d0
                bne.s   loc_29E88
                subq.w  #1,d0

loc_29E88:
                asr.w   #6,d0
                move.w  $46(a0),d2
                sub.w   d0,d2
                move.w  d2,y_pos(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                move.w  #8,d2
                move.w  #$20,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull_Offset).l
                rts
; ---------------------------------------------------------------------------

LBZTubeElevator_StartSpin:
                move.w  mapping_frame(a0),d0            ; Get current mapping frame +
                sub.w   $3C(a0),d0
                bcc.s   loc_29EC0
                addi.w  #$600,d0

loc_29EC0:
                move.w  d0,mapping_frame(a0)
                move.w  angle(a0),d0
                sub.w   $3C(a0),d0
                bcc.s   loc_29ED2
                addi.w  #$C00,d0

loc_29ED2:
                move.w  d0,angle(a0)
                cmpi.w  #$180,$3C(a0)                   ; Accelerate speed of spinning
                bhs.s   loc_29F1C                       ; When maxed out, branch
                addq.w  #2,$3C(a0)

loc_29EE2:
                move.b  1(a4),d0                        ; Increment bobbing angle
                addq.b  #2,1(a4)
                jsr     (GetSineCosine).l
                asr.w   #6,d0
                move.w  $46(a0),d2
                sub.w   d0,d2
                move.w  d2,y_pos(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                rts
; ---------------------------------------------------------------------------

loc_29F1C:
                addq.b  #2,(a4)                         ; Next routine
                move.w  #$180,$3C(a0)
                clr.b   1(a4)
                bsr.w   AutoTunnel_GetPath              ; Get auto tunnel path
                move.b  #1,(Fast_V_scroll_flag).w       ; Y camera follows Sonic differently
                bra.s   loc_29EE2
; ---------------------------------------------------------------------------

LBZTubeElevator_MovePath:
                move.w  mapping_frame(a0),d0            ; Continuing spinning mapping frame
                sub.w   $3C(a0),d0
                bcc.s   loc_29F42
                addi.w  #$600,d0

loc_29F42:
                move.w  d0,mapping_frame(a0)
                move.w  angle(a0),d0
                sub.w   $3C(a0),d0
                bcc.s   loc_29F54
                addi.w  #$C00,d0

loc_29F54:
                move.w  d0,angle(a0)
                subq.b  #1,2(a4)
                bhi.w   loc_29FA6
                movea.l 6(a4),a2                        ; Check for new path
                move.w  (a2)+,d4
                move.w  d4,x_pos(a1)
                move.w  (a2)+,d5
                move.w  d5,y_pos(a1)
                move.l  a2,6(a4)
                subq.w  #4,4(a4)
                beq.s   loc_29F86
                move.w  (a2)+,d4
                move.w  (a2)+,d5
                move.w  #$1000,d2
                bra.w   AutoTunnel_CalcSpeed            ; Recalc speed
; ---------------------------------------------------------------------------

loc_29F86:
                addq.b  #2,(a4)                         ; If end of path reached, next routine
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)                    ; Null momentum of player
                move.w  y_pos(a0),$46(a0)               ; Backup Y position
                clr.b   1(a4)                           ; Zero out angle
                move.b  #0,(Fast_V_scroll_flag).w       ; Restore normal Camera Y follow
                rts
; ---------------------------------------------------------------------------

loc_29FA6:
                move.l  x_pos(a1),d2                    ; Move tube elevator based on autotunnel speed
                move.l  y_pos(a1),d3
                move.w  x_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d2
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d3
                move.l  d2,x_pos(a1)
                move.l  d3,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

LBZTubeElevator_SlowSpin:
                move.w  mapping_frame(a0),d0
                sub.w   $3C(a0),d0
                bcc.s   loc_29FDA
                addi.w  #$600,d0

loc_29FDA:
                move.w  d0,mapping_frame(a0)
                move.w  angle(a0),d0
                sub.w   $3C(a0),d0                      ; Spin spin spinning
                bcc.s   loc_29FEC
                addi.w  #$C00,d0

loc_29FEC:
                move.w  d0,angle(a0)
                cmpi.w  #8,$3C(a0)
                bne.s   loc_2A014
                cmpi.b  #2,mapping_frame(a0)            ; When minimum speed reached and correct rotation on tube
                bne.s   LBZTubeElevator_WaitExit
                addq.b  #2,(a4)                         ; Next routine
                move.w  respawn_addr(a0),d0
                beq.s   loc_2A012
                movea.w d0,a2
                bclr    #7,(a2)                         ; Restore jump control on player
                clr.w   respawn_addr(a0)

loc_2A012:
                bra.s   LBZTubeElevator_WaitExit
; ---------------------------------------------------------------------------

loc_2A014:
                subq.w  #4,$3C(a0)                      ; Subtract spin speed

LBZTubeElevator_WaitExit:
                addq.b  #2,1(a4)                        ; Change bobbing angle
                move.b  1(a4),d0
                cmpi.b  #$B0,d0
                blo.s   loc_2A030
                cmpi.b  #$D0,d0
                bhs.s   loc_2A030
                addi.b  #$20,d0

loc_2A030:
                move.b  d0,1(a4)
                jsr     (GetSineCosine).l
                cmpi.w  #$100,d0
                bne.s   loc_2A042
                subq.w  #1,d0

loc_2A042:
                asr.w   #6,d0
                move.w  $46(a0),d2
                sub.w   d0,d2
                move.w  d2,y_pos(a0)                    ; Apply bobbing motion
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                move.w  #8,d2
                move.w  #$20,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull_Offset).l
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   locret_2A07C
                addq.b  #2,(a4)                         ; When player is no longer standing on object, next routine
                move.b  #0,anim_frame_timer(a0)

locret_2A07C:
                rts
; ---------------------------------------------------------------------------

LBZTubeElevator_EndSpin:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   LBZTubeElevator_Closed
                move.b  #$F,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)            ; Spin object until closed frame is on
                cmpi.b  #6,mapping_frame(a0)
                blo.s   loc_2A09E
                move.b  #0,mapping_frame(a0)
                addq.b  #2,(a4)

loc_2A09E:
                addq.b  #1,angle(a0)
                cmpi.b  #6,angle(a0)
                blo.s   LBZTubeElevator_Closed
                move.b  #0,angle(a0)

LBZTubeElevator_Closed:
                addq.b  #2,1(a4)                        ; Add to bobbing angle
                move.b  1(a4),d0
                cmpi.b  #$B0,d0
                blo.s   loc_2A0C8
                cmpi.b  #$D0,d0
                bhs.s   loc_2A0C8
                addi.b  #$20,d0

loc_2A0C8:
                move.b  d0,1(a4)
                jsr     (GetSineCosine).l
                cmpi.w  #$100,d0
                bne.s   loc_2A0DA
                subq.w  #1,d0

loc_2A0DA:
                asr.w   #6,d0
                move.w  $46(a0),d2
                sub.w   d0,d2
                move.w  d2,y_pos(a0)                    ; Apply bobbing offset
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l             ; Fully closed
                rts

; =============== S U B R O U T I N E =======================================

LBZTubeElevator_CheckPlayer:
                move.b  (a2),d0
                bne.w   loc_2A1B6
                tst.w   (Debug_placement_mode).w
                bne.w   locret_2A1B4                    ; Do nothing if currently in debug state
                cmpa.w  #Player_2,a1
                bne.s   loc_2A128
                btst    #p2_standing_bit,status(a0)
                beq.s   loc_2A128
                tst.b   -1(a2)
                bne.s   loc_2A164

loc_2A128:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addq.w  #3,d0
                btst    #0,status(a0)
                beq.s   loc_2A13E
                addi.w  #$A,d0

loc_2A13E:
                cmpi.w  #$10,d0
                bhs.s   locret_2A1B4
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$20,d1
                cmpi.w  #$40,d1                         ; Check if in range
                bhs.s   locret_2A1B4
                tst.b   object_control(a1)
                bne.s   locret_2A1B4                    ; If player is already under control, skip all this
                btst    #Status_InAir,status(a1)
                bne.s   locret_2A1B4                    ; If player is in the air, skip all this

loc_2A164:
                addq.b  #2,(a2)
                move.b  #$83,object_control(a1)         ; Object control of player, control of animation too
                move.b  #0,anim(a1)                     ; Clear player animation
                clr.b   jumping(a1)
                move.w  #0,ground_vel(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)                    ; Null momentum
                bclr    #p1_pushing_bit,status(a0)
                bclr    #Status_Push,status(a1)         ; Not pushing
                bclr    #Status_InAir,status(a1)        ; Not in air
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),d0                    ; Match player position to object position
                addi.w  #$18,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                sub.w   d1,d0
                move.w  d0,y_pos(a1)

locret_2A1B4:
                rts
; ---------------------------------------------------------------------------

loc_2A1B6:
                subq.b  #2,d0                           ; If player already inside
                bne.w   locret_2A230
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),d0
                addi.w  #$18,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                sub.w   d1,d0
                move.w  d0,y_pos(a1)                    ; Match player position
                cmpi.b  #8,$2E(a0)
                bne.s   loc_2A1EC
                bset    #Status_Facing,status(a1)
                move.b  #0,object_control(a1)
                addq.b  #2,(a2)

loc_2A1EC:
                moveq   #0,d0
                move.b  angle(a0),d0
                move.b  LBZTubeElevator_PlayerFrame(pc,d0.w),mapping_frame(a1)
                andi.b  #$FC,render_flags(a1)
                move.b  LBZTubeElevator_PlayerFlip(pc,d0.w),d0
                or.b    d0,render_flags(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------
LBZTubeElevator_PlayerFrame:
                dc.b    $55, $59, $5A, $5B, $5A, $59, $55, $56, $57, $58, $57, $56
LBZTubeElevator_PlayerFlip:
                dc.b    0,   1,   1,   0,   0,   0,   1,   1,   1,   0,   0,   0
                even
; ---------------------------------------------------------------------------

locret_2A230:
                rts
; End of function LBZTubeElevator_CheckPlayer
