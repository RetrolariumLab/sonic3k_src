; Owner: objects/shared/s3
; Responsibility: Tunnel exhaust control, directional vents, timed emission and smoke sprite motion
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_TunnelExhaustControl:
                move.l  #Map_TunnelExhaust,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$180,priority(a0)
                tst.b   subtype(a0)
                beq.s   loc_2883E
                move.l  #Obj_TunnelExContinuous,(a0)
                bra.w   Obj_TunnelExContinuous
; ---------------------------------------------------------------------------

loc_2883E:
                move.w  #60,$30(a0)
                tst.w   y_vel(a0)
                beq.s   loc_28854
                bmi.s   loc_28866
                move.w  #6,angle(a0)                    ; angle is 6 if moving downward, 0 if moving upward
                bra.s   loc_28866
; ---------------------------------------------------------------------------

loc_28854:
                move.w  #$C,angle(a0)                   ; If vertical movement is null
                tst.w   x_vel(a0)
                bmi.s   loc_28866
                move.w  #$12,angle(a0)                  ; angle is $C if X velocity is to the left, $12 if to the right

loc_28866:
                tst.b   (Current_act).w
                bne.s   loc_28876
                move.l  #Obj_TunnelExSmoke,(a0)         ; If in act 1, just make smoke
                bra.w   Obj_TunnelExSmoke
; ---------------------------------------------------------------------------

loc_28876:
                move.l  #Obj_TunnelExhaustControlMain,(a0)  ; If in act 2

Obj_TunnelExhaustControlMain:
                subq.w  #1,$2E(a0)
                bpl.s   loc_288F2
                move.w  #4-1,$2E(a0)                    ; Make a new exhaust sprite every 4 frames
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_288F2
                move.l  #Obj_TunnelExhaustUp,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_TunnelExhaust,mappings(a1)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,2,0),art_tile(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.w  #$380,priority(a1)
                move.w  angle(a0),d0
                cmpi.w  #6,d0
                bne.s   loc_288D4
                move.l  #Obj_TunnelExhaustDown,(a1)     ; If moving downward, change the object to use

loc_288D4:
                lea     word_28904(pc,d0.w),a2
                move.w  (a2)+,x_vel(a1)
                move.w  (a2)+,y_vel(a1)
                move.b  (a2)+,render_flags(a1)
                move.b  (a2)+,mapping_frame(a1)
                bne.s   loc_288F2
                move.l  #Obj_TunnelExhaustHorz,(a1)
                bsr.s   sub_2891C

loc_288F2:
                subq.w  #1,$30(a0)                      ; Continue doing this until timer runs out
                bpl.s   loc_288FE
                move.w  #$7FF0,x_pos(a0)

loc_288FE:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------
word_28904:
                dc.w    0                               ; X velocity
                dc.w    -$600                           ; Y velocity
                dc.b    $86                             ; Flip value
                dc.b    1                               ; Mapping frame
                dc.w    0
                dc.w    $400
                dc.b    $84
                dc.b    1
                dc.w    -$600
                dc.w    0
                dc.b    $85
                dc.b    0
                dc.w    $600
                dc.w    0
                dc.b    $84
                dc.b    0

; =============== S U B R O U T I N E =======================================

sub_2891C:
                moveq   #0,d0                           ; Slow down exhaust trickle over time
                move.w  $30(a0),d0
                subi.w  #$3C,d0
                neg.w   d0
                lsl.w   #4,d0
                tst.w   x_vel(a1)
                bmi.s   loc_28932
                neg.w   d0

loc_28932:
                add.w   d0,x_vel(a1)
                rts
; End of function sub_2891C

; ---------------------------------------------------------------------------

Obj_TunnelExhaustUp:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                bne.s   loc_28948
                bchg    #0,render_flags(a0)             ; Change X flip every 2 frames

loc_28948:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bmi.s   loc_28960                       ; If on-screen, branch
                tst.w   y_vel(a0)
                bmi.s   loc_28960                       ; If vertical velocity is going upwards, branch
                move.w  #$7FF0,x_pos(a0)                ; Ensure that the object is definitely offscreen

loc_28960:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_TunnelExhaustDown:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                bne.s   loc_28976
                bchg    #0,render_flags(a0)             ; Change X flip every 2 frames

loc_28976:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bmi.s   loc_28990                       ; If on-screen, branch
                cmpi.w  #$C00,y_vel(a0)
                blt.s   loc_28990                       ; If vertical velocity is less than $C00, branch
                move.w  #$7FF0,x_pos(a0)

loc_28990:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_TunnelExhaustHorz:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                bne.s   loc_289A6
                bchg    #1,render_flags(a0)

loc_289A6:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bmi.s   loc_289C0
                cmpi.w  #$600,y_vel(a0)
                blt.s   loc_289C0
                move.w  #$7FF0,x_pos(a0)

loc_289C0:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_TunnelExContinuous:
                move.b  (Level_frame_counter+1).w,d0    ; This control object creates new sprites continuously
                andi.b  #3,d0
                bne.s   loc_28A2A
                jsr     (AllocateObjectAfterCurrent).l  ; Create a new sprite every four frames
                bne.w   loc_28A2A
                move.l  #Obj_TunnelExhaustTimed,(a1)    ; This is a timed exhaust (the short waterfalls in LBZ2 for example)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_TunnelExhaust,mappings(a1)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,2,0),art_tile(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.w  #$380,priority(a1)
                move.w  #0,x_vel(a1)
                move.w  #$400,y_vel(a1)
                move.b  #$84,render_flags(a1)
                move.b  #1,mapping_frame(a1)
                move.w  #$C-1,$2E(a1)

loc_28A2A:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

Obj_TunnelExhaustTimed:
                subq.w  #1,$2E(a0)
                bpl.s   loc_28A42
                move.w  #$C-1,$2E(a0)
                move.w  #$7FF0,x_pos(a0)

loc_28A42:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                bne.s   loc_28A52
                bchg    #0,render_flags(a0)

loc_28A52:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bmi.s   loc_28A64
                move.w  #$7FF0,x_pos(a0)

loc_28A64:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_TunnelExSmoke:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #3,d0
                bne.s   loc_28A9C
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_28A9C
                move.l  #Obj_FireShield_Dissipate,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  x_vel(a0),x_vel(a1)
                move.w  y_vel(a0),y_vel(a1)

loc_28A9C:
                subq.w  #1,$30(a0)
                bpl.s   loc_28AA8
                move.w  #$7FF0,x_pos(a0)

loc_28AA8:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------
; unused
                move.l  #Map_TunnelExhaust,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$180,priority(a0)
                move.w  #2*60,$30(a0)
                move.l  #loc_28AE0,(a0)

loc_28AE0:
                tst.b   $32(a0)
                bne.s   loc_28B5A
                subq.w  #1,$2E(a0)
                bpl.s   loc_28B5A
                move.w  #4-1,$2E(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_28B5A
                move.l  #loc_28B72,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_TunnelExhaust,mappings(a1)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,2,0),art_tile(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.w  #$380,priority(a1)
                ori.b   #4,render_flags(a1)
                bset    #0,render_flags(a1)
                move.w  #-$800,x_vel(a1)
                moveq   #0,d0
                move.b  subtype(a0),d0
                addq.w  #1,d0
                add.w   d0,d0
                move.w  d0,$2E(a1)
                addi.w  #$10,x_pos(a1)
                move.b  #$C6,collision_flags(a1)

loc_28B5A:
                subq.w  #1,$30(a0)
                bpl.s   loc_28B6C
                move.w  #2*60,$30(a0)
                eori.b  #$FF,$32(a0)

loc_28B6C:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_28B72:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #1,d0
                bne.s   loc_28B82
                bchg    #1,render_flags(a0)

loc_28B82:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   loc_28B94
                move.w  #$7FF0,x_pos(a0)

loc_28B94:
                move.b  collision_property(a0),d0
                beq.w   loc_28BB8
                lea     (Player_1).w,a1
                bclr    #0,collision_property(a0)
                beq.s   loc_28BAA
                bsr.s   sub_28BBE

loc_28BAA:
                lea     (Player_2).w,a1
                bclr    #1,collision_property(a0)
                beq.s   loc_28BB8
                bsr.s   sub_28BBE

loc_28BB8:
                jmp     (Sprite_CheckDeleteTouch3).l

; =============== S U B R O U T I N E =======================================

sub_28BBE:
                tst.b   object_control(a1)
                bne.s   locret_28BFA
                move.w  y_pos(a0),y_pos(a1)
                cmpi.w  #-$1000,x_vel(a1)
                beq.s   locret_28BFA
                move.b  #$1A,anim(a1)
                clr.b   jumping(a1)
                move.w  #0,ground_vel(a1)
                move.w  #-$1000,x_vel(a1)
                move.w  #0,y_vel(a1)
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)

locret_28BFA:
                rts
; End of function sub_28BBE

; ---------------------------------------------------------------------------
Map_TunnelExhaust:
                include "src/objects/shared/zones/lbz/map_lrz_tunnel_exhaust.s"
