; Owner: objects/zones/lbz/s3
; Responsibility: Launch Base riding grapple initialization, constrained travel, player attachment and release
; Source provenance and ranges: config/reconstruction/source_layout.json
LBZRideGrapple_Range:
                dc.w    $A08,  $C78                     ; 0
                dc.w    $1208, $14F8                    ; 1
                dc.w    $1A08, $1BB8                    ; 2
                dc.w    $1C48, $2078                    ; 3
                dc.w    $2688, $2878                    ; 4
                dc.w    $2988, $2DF8                    ; 5
                dc.w    $2F88, $3178                    ; 6
                dc.w    $E68, $1098                     ; 7
                dc.w    $CE8, $1498                     ; 8
                dc.w    $E68, $1398                     ; 9
                dc.w    $20E8, $2418                    ; A
                dc.w    $2B08, $2E98                    ; B
                dc.w    $39E8, $3C98                    ; C
; ---------------------------------------------------------------------------

Obj_LBZRideGrapple:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.b  #$20,height_pixels(a0)
                move.w  x_pos(a0),$38(a0)
                move.b  subtype(a0),d0
                andi.w  #$7F,d0
                lsl.w   #2,d0
                move.l  LBZRideGrapple_Range(pc,d0.w),$34(a0)
                move.l  #Map_LBZRideGrapple,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZMisc+$70,1,0),art_tile(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_2562A
                move.l  #loc_25752,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.w  priority(a0),priority(a1)
                bset    #6,render_flags(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$20,height_pixels(a1)
                moveq   #6,d1
                move.w  d1,mainspr_childsprites(a1)
                subq.b  #1,d1
                lea     sub2_x_pos(a1),a2

loc_25610:
                move.w  x_pos(a1),(a2)+
                move.w  y_pos(a1),(a2)+
                move.w  #1,(a2)+
                dbf     d1,loc_25610
                move.b  #2,mapping_frame(a1)
                move.w  a1,$3C(a0)

loc_2562A:
                move.l  #loc_25630,(a0)

loc_25630:
                bsr.w   UpdateLbzRideGrappleSwingAndChain
                bsr.w   UpdatePlayersOnLbzRideGrapple
                tst.w   $30(a0)
                beq.s   loc_2564C
                cmpi.w  #$28,$3A(a0)
                bne.s   loc_2564C
                move.l  #loc_256A0,(a0)

loc_2564C:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_25666
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_25666:
                move.w  $38(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_25680
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_25680:
                move.w  respawn_addr(a0),d0
                beq.s   loc_2568C
                movea.w d0,a2
                bclr    #7,(a2)

loc_2568C:
                move.w  $3C(a0),d0
                beq.s   loc_2569A
                movea.w d0,a1
                jsr     (Delete_Referenced_Sprite).l

loc_2569A:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_256A0:
                jsr     (MoveSprite2).l
                btst    #0,status(a0)
                beq.s   loc_256C2
                subi.w  #$20,x_vel(a0)
                tst.w   x_vel(a0)
                bmi.s   loc_256D4
                subi.w  #$60,x_vel(a0)
                bra.s   loc_256D4
; ---------------------------------------------------------------------------

loc_256C2:
                addi.w  #$20,x_vel(a0)
                tst.w   x_vel(a0)
                bpl.s   loc_256D4
                addi.w  #$60,x_vel(a0)

loc_256D4:
                move.w  x_pos(a0),d0
                move.w  $34(a0),d1
                cmp.w   d1,d0
                bhi.s   loc_256F2
                move.w  d1,x_pos(a0)
                bsr.s   ReleaseLbzRideGrapplePlayersAtEndpoint
                tst.w   x_vel(a0)
                bpl.s   loc_256F2
                move.w  #0,x_vel(a0)

loc_256F2:
                move.w  $36(a0),d1
                cmp.w   d1,d0
                blo.s   loc_2570C
                move.w  d1,x_pos(a0)
                bsr.s   ReleaseLbzRideGrapplePlayersAtEndpoint
                tst.w   x_vel(a0)
                bmi.s   loc_2570C
                move.w  #0,x_vel(a0)

loc_2570C:
                bsr.w   UpdateLbzRideGrappleSwingAndChain
                bsr.w   UpdatePlayersOnLbzRideGrapple
                bra.w   loc_2564C

; =============== S U B R O U T I N E =======================================

ReleaseLbzRideGrapplePlayersAtEndpoint:
                tst.b   subtype(a0)
                bmi.s   locret_25750
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                bsr.s   ReleasePlayerFromLbzRideGrappleEndpoint
                lea     (Player_2).w,a1
                addq.w  #1,a2
; End of function ReleaseLbzRideGrapplePlayersAtEndpoint

; =============== S U B R O U T I N E =======================================

ReleasePlayerFromLbzRideGrappleEndpoint:
                tst.b   (a2)
                beq.s   locret_25750
                move.w  x_vel(a0),x_vel(a1)
                move.w  #0,y_vel(a1)
                bset    #Status_InAir,status(a1)
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)

locret_25750:
                rts
; End of function ReleasePlayerFromLbzRideGrappleEndpoint

; ---------------------------------------------------------------------------

loc_25752:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

UpdatePlayersOnLbzRideGrapple:
                movea.w $3C(a0),a3
                lea     $31(a0),a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2).w,d0
                bsr.s   UpdatePlayerOnLbzRideGrapple
                lea     (Player_1).w,a1
                subq.w  #1,a2
                move.w  (Ctrl_1).w,d0
; End of function UpdatePlayersOnLbzRideGrapple

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnLbzRideGrapple:
                tst.b   (a2)
                beq.w   loc_25868
                tst.b   render_flags(a1)
                bpl.s   loc_257DC
                cmpi.b  #4,routine(a1)
                bhs.s   loc_257DC
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.w   loc_257EA
                clr.b   $2E(a1)
                clr.b   (a2)
                move.b  #$12,2(a2)
                andi.w  #(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
                beq.w   loc_257AA
                move.b  #$3C,2(a2)

loc_257AA:
                move.w  x_vel(a0),x_vel(a1)
                move.w  #-$380,y_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                rts
; ---------------------------------------------------------------------------

loc_257DC:
                clr.b   object_control(a1)
                clr.b   (a2)
                move.b  #$3C,2(a2)
                rts
; ---------------------------------------------------------------------------

loc_257EA:
                btst    #button_left+8,d0
                beq.s   loc_257F6
                bset    #Status_Facing,status(a1)

loc_257F6:
                btst    #button_right+8,d0
                beq.s   loc_25802
                bclr    #Status_Facing,status(a1)

loc_25802:
                move.b  status(a1),status(a0)
                move.b  status(a1),d0
                andi.b  #1<<Status_Facing,d0
                andi.b  #$FE,render_flags(a1)
                or.b    d0,render_flags(a1)
                move.w  x_pos(a3),x_pos(a1)
                move.w  y_pos(a3),y_pos(a1)
                addi.w  #$24,y_pos(a1)

loc_2582C:
                moveq   #0,d0
                move.b  angle(a0),d0
                btst    #Status_Facing,status(a1)
                beq.s   loc_2583C
                neg.b   d0

loc_2583C:
                addq.b  #8,d0
                lsr.w   #4,d0
                move.b  byte_25858(pc,d0.w),mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------
byte_25858:
                dc.b    $91, $91, $90, $90, $90, $90, $90, $90, $92, $92, $92, $92, $92, $92, $91, $91
                even
; ---------------------------------------------------------------------------

loc_25868:
                tst.b   2(a2)
                beq.s   loc_25876
                subq.b  #1,2(a2)
                bne.w   locret_258F0

loc_25876:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   locret_258F0
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                subi.w  #$18,d1
                cmpi.w  #$18,d1
                bhs.w   locret_258F0
                tst.b   object_control(a1)
                bne.s   locret_258F0
                cmpi.b  #4,routine(a1)
                bhs.s   locret_258F0
                tst.w   (Debug_placement_mode).w
                bne.s   locret_258F0
                move.b  status(a1),status(a0)
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$24,y_pos(a1)
                move.b  #$14,anim(a1)
                move.b  #0,spin_dash_flag(a1)
                move.b  #3,object_control(a1)
                move.b  #1,(a2)
                bra.w   loc_2582C
; ---------------------------------------------------------------------------

locret_258F0:
                rts
; End of function UpdatePlayerOnLbzRideGrapple

; =============== S U B R O U T I N E =======================================

UpdateLbzRideGrappleSwingAndChain:
                tst.w   $30(a0)
                beq.s   loc_25906
                move.w  $3A(a0),d2
                cmpi.w  #$28,d2
                beq.s   loc_2592C
                addq.w  #1,d2
                bra.s   loc_25928
; ---------------------------------------------------------------------------

loc_25906:
                move.w  $3A(a0),d2
                beq.s   loc_25910
                subq.w  #1,d2
                bne.s   loc_25928

loc_25910:
                clr.w   angle(a0)
                clr.b   $40(a0)
                clr.w   $3E(a0)
                move.w  #0,x_vel(a0)
                move.l  #loc_25630,(a0)

loc_25928:
                move.w  d2,$3A(a0)

loc_2592C:
                mulu.w  #$33,d2
                move.w  x_vel(a0),d0
                bne.s   loc_25970
                tst.b   $40(a0)
                bne.s   loc_25956
                move.w  $3E(a0),d1
                addi.w  #$40,d1
                move.w  d1,$3E(a0)
                add.w   d1,angle(a0)
                bmi.s   loc_2596E
                move.b  #1,$40(a0)
                bra.s   loc_2596E
; ---------------------------------------------------------------------------

loc_25956:
                move.w  $3E(a0),d1
                subi.w  #$40,d1
                move.w  d1,$3E(a0)
                add.w   d1,angle(a0)
                bpl.s   loc_2596E
                move.b  #0,$40(a0)

loc_2596E:
                bra.s   loc_259B0
; ---------------------------------------------------------------------------

loc_25970:
                neg.w   d0
                asl.w   #2,d0
                sub.w   angle(a0),d0
                bge.s   loc_2598A
                cmpi.w  #-$3000,angle(a0)
                ble.s   loc_2598A
                subi.w  #$180,angle(a0)
                bra.s   loc_25998
; ---------------------------------------------------------------------------

loc_2598A:
                cmpi.w  #$3000,angle(a0)
                bge.s   loc_25998
                addi.w  #$180,angle(a0)

loc_25998:
                move.b  #0,$40(a0)
                tst.w   x_vel(a0)
                bpl.s   loc_259AA
                move.b  #1,$40(a0)

loc_259AA:
                move.w  #0,$3E(a0)

loc_259B0:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  d2,d0
                muls.w  d2,d1
                move.l  x_pos(a0),d2
                move.l  y_pos(a0),d3
                movea.w $3C(a0),a1
                moveq   #6-1,d4
                lea     sub2_x_pos(a1),a2

loc_259D0:
                swap    d2
                swap    d3
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                addq.w  #2,a2
                swap    d2
                swap    d3
                add.l   d0,d2
                add.l   d1,d3
                dbf     d4,loc_259D0
                move.w  $36(a1),x_pos(a1)
                move.w  $38(a1),y_pos(a1)
                rts
; End of function UpdateLbzRideGrappleSwingAndChain

; ---------------------------------------------------------------------------
Map_LBZRideGrapple:
                include "src/objects/shared/zones/lbz/mappings/ride_grapple.s"
