; Owner: objects/zones/lbz/s3
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
                beq.s   loc_28C5E
                move.b  #0,mapping_frame(a0)            ; If BIT 6 of subtype set, the elevator remains closed
                move.b  #0,angle(a0)
                move.l  #Obj_LBZTubeElevatorClosed,(a0)
                bra.s   Obj_LBZTubeElevatorClosed
; ---------------------------------------------------------------------------

loc_28C5E:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_28CAA
                move.l  #loc_28D5E,(a1)
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

loc_28CAA:
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
                beq.s   loc_28D00
                tst.b   object_control(a1)
                beq.s   loc_28D00
                movea.w interact(a1),a2
                cmpi.l  #Obj_LBZTubeElevatorActive,(a2)
                bne.s   loc_28D00
                move.w  #$7FF0,x_pos(a0)

loc_28D00:
                lea     $2E(a0),a4
                addq.b  #2,1(a4)
                move.b  1(a4),d0
                cmpi.b  #$B0,d0
                blo.s   loc_28D1C
                cmpi.b  #$D0,d0
                bhs.s   loc_28D1C
                addi.b  #$20,d0

loc_28D1C:
                move.b  d0,1(a4)
                jsr     (GetSineCosine).l
                cmpi.w  #$100,d0
                bne.s   loc_28D2E
                subq.w  #1,d0

loc_28D2E:
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

loc_28D5E:
                movea.w parent(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                tst.b   render_flags(a1)
                bpl.s   loc_28D88
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.b  byte_28D8E(pc,d0.w),d0
                ext.w   d0
                add.w   x_pos(a1),d0
                move.w  d0,x_pos(a0)

loc_28D88:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
byte_28D8E:
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
                beq.s   loc_28DC4
                cmpi.w  #$202,$38(a0)
                bne.s   loc_28DD0

loc_28DC4:
                addq.b  #2,(a4)
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l
                bra.s   LBZTubeElevator_StartSpin
; ---------------------------------------------------------------------------

loc_28DD0:
                addq.b  #2,1(a4)
                move.b  1(a4),d0
                cmpi.b  #$B0,d0
                blo.s   loc_28DE8
                cmpi.b  #$D0,d0
                bhs.s   loc_28DE8
                addi.b  #$20,d0

loc_28DE8:
                move.b  d0,1(a4)
                jsr     (GetSineCosine).l
                cmpi.w  #$100,d0
                bne.s   loc_28DFA
                subq.w  #1,d0

loc_28DFA:
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
                bcc.s   loc_28E32
                addi.w  #$600,d0

loc_28E32:
                move.w  d0,mapping_frame(a0)
                move.w  angle(a0),d0
                sub.w   $3C(a0),d0
                bcc.s   loc_28E44
                addi.w  #$C00,d0

loc_28E44:
                move.w  d0,angle(a0)
                cmpi.w  #$180,$3C(a0)                   ; Accelerate speed of spinning
                bhs.s   loc_28E8E                       ; When maxed out, branch
                addq.w  #2,$3C(a0)

loc_28E54:
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

loc_28E8E:
                addq.b  #2,(a4)                         ; Next routine
                move.w  #$180,$3C(a0)
                clr.b   1(a4)
                bsr.w   AutoTunnel_GetPath              ; Get auto tunnel path
                move.b  #1,(Fast_V_scroll_flag).w       ; Y camera follows Sonic differently
                bra.s   loc_28E54
; ---------------------------------------------------------------------------

LBZTubeElevator_MovePath:
                move.w  mapping_frame(a0),d0            ; Continuing spinning mapping frame
                sub.w   $3C(a0),d0
                bcc.s   loc_28EB4
                addi.w  #$600,d0

loc_28EB4:
                move.w  d0,mapping_frame(a0)
                move.w  angle(a0),d0
                sub.w   $3C(a0),d0
                bcc.s   loc_28EC6
                addi.w  #$C00,d0

loc_28EC6:
                move.w  d0,angle(a0)
                subq.b  #1,2(a4)
                bhi.w   loc_28F18
                movea.l 6(a4),a2                        ; Check for new path
                move.w  (a2)+,d4
                move.w  d4,x_pos(a1)
                move.w  (a2)+,d5
                move.w  d5,y_pos(a1)
                move.l  a2,6(a4)
                subq.w  #4,4(a4)
                beq.s   loc_28EF8
                move.w  (a2)+,d4
                move.w  (a2)+,d5
                move.w  #$1000,d2
                bra.w   AutoTunnel_CalcSpeed            ; Recalc speed
; ---------------------------------------------------------------------------

loc_28EF8:
                addq.b  #2,(a4)                         ; If end of path reached, next routine
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)                    ; Null momentum of player
                move.w  y_pos(a0),$46(a0)               ; Backup Y position
                clr.b   1(a4)                           ; Zero out angle
                move.b  #0,(Fast_V_scroll_flag).w       ; Restore normal Camera Y follow
                rts
; ---------------------------------------------------------------------------

loc_28F18:
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
                bcc.s   loc_28F4C
                addi.w  #$600,d0

loc_28F4C:
                move.w  d0,mapping_frame(a0)
                move.w  angle(a0),d0
                sub.w   $3C(a0),d0                      ; Spin spin spinning
                bcc.s   loc_28F5E
                addi.w  #$C00,d0

loc_28F5E:
                move.w  d0,angle(a0)
                cmpi.w  #8,$3C(a0)
                bne.s   loc_28F86
                cmpi.b  #2,mapping_frame(a0)            ; When minimum speed reached and correct rotation on tube
                bne.s   LBZTubeElevator_WaitExit
                addq.b  #2,(a4)                         ; Next routine
                move.w  respawn_addr(a0),d0
                beq.s   loc_28F84
                movea.w d0,a2
                bclr    #7,(a2)                         ; Restore jump control on player
                clr.w   respawn_addr(a0)

loc_28F84:
                bra.s   LBZTubeElevator_WaitExit
; ---------------------------------------------------------------------------

loc_28F86:
                subq.w  #4,$3C(a0)                      ; Subtract spin speed

LBZTubeElevator_WaitExit:
                addq.b  #2,1(a4)                        ; Change bobbing angle
                move.b  1(a4),d0
                cmpi.b  #$B0,d0
                blo.s   loc_28FA2
                cmpi.b  #$D0,d0
                bhs.s   loc_28FA2
                addi.b  #$20,d0

loc_28FA2:
                move.b  d0,1(a4)
                jsr     (GetSineCosine).l
                cmpi.w  #$100,d0
                bne.s   loc_28FB4
                subq.w  #1,d0

loc_28FB4:
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
                bne.s   locret_28FEE
                addq.b  #2,(a4)                         ; When player is no longer standing on object, next routine
                move.b  #0,anim_frame_timer(a0)

locret_28FEE:
                rts
; ---------------------------------------------------------------------------

LBZTubeElevator_EndSpin:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   LBZTubeElevator_Closed
                move.b  #$F,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)            ; Spin object until closed frame is on
                cmpi.b  #6,mapping_frame(a0)
                blo.s   loc_29010
                move.b  #0,mapping_frame(a0)
                addq.b  #2,(a4)

loc_29010:
                addq.b  #1,angle(a0)
                cmpi.b  #6,angle(a0)
                blo.s   LBZTubeElevator_Closed
                move.b  #0,angle(a0)

LBZTubeElevator_Closed:
                addq.b  #2,1(a4)                        ; Add to bobbing angle
                move.b  1(a4),d0
                cmpi.b  #$B0,d0
                blo.s   loc_2903A
                cmpi.b  #$D0,d0
                bhs.s   loc_2903A
                addi.b  #$20,d0

loc_2903A:
                move.b  d0,1(a4)
                jsr     (GetSineCosine).l
                cmpi.w  #$100,d0
                bne.s   loc_2904C
                subq.w  #1,d0

loc_2904C:
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
                bne.w   loc_29128
                tst.w   (Debug_placement_mode).w
                bne.w   locret_29126                    ; Do nothing if currently in debug state
                cmpa.w  #Player_2,a1
                bne.s   loc_2909A
                btst    #p2_standing_bit,status(a0)
                beq.s   loc_2909A
                tst.b   -1(a2)
                bne.s   loc_290D6

loc_2909A:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addq.w  #3,d0
                btst    #0,status(a0)
                beq.s   loc_290B0
                addi.w  #$A,d0

loc_290B0:
                cmpi.w  #$10,d0
                bhs.s   locret_29126
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$20,d1
                cmpi.w  #$40,d1                         ; Check if in range
                bhs.s   locret_29126
                tst.b   object_control(a1)
                bne.s   locret_29126                    ; If player is already under control, skip all this
                btst    #Status_InAir,status(a1)
                bne.s   locret_29126                    ; If player is in the air, skip all this

loc_290D6:
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

locret_29126:
                rts
; ---------------------------------------------------------------------------

loc_29128:
                subq.b  #2,d0                           ; If player already inside
                bne.w   locret_291A2
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),d0
                addi.w  #$18,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                sub.w   d1,d0
                move.w  d0,y_pos(a1)                    ; Match player position
                cmpi.b  #8,$2E(a0)
                bne.s   loc_2915E
                bset    #Status_Facing,status(a1)
                move.b  #0,object_control(a1)
                addq.b  #2,(a2)

loc_2915E:
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

locret_291A2:
                rts
; End of function LBZTubeElevator_CheckPlayer

; ---------------------------------------------------------------------------
Map_LBZTubeElevator:
                include "src/objects/shared/zones/lbz/mappings/tube_elevator.s"
