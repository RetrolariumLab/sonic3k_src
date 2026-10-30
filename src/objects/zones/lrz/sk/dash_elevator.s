; Owner: objects/zones/lrz/sk
; Responsibility: Dash elevator activation, motion, player riding and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZDashElevator:
                move.l  #Map_LRZDashElevator,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZMisc,0,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  y_pos(a0),$46(a0)
                moveq   #0,d1
                move.b  subtype(a0),d0
                bpl.s   loc_42F54
                moveq   #$20,d1
                move.w  d1,$30(a0)

loc_42F54:
                andi.w  #$7F,d0
                lsl.w   #3,d0
                move.w  d0,$34(a0)
                bclr    #0,status(a0)
                beq.s   loc_42F72
                move.w  d0,$30(a0)
                sub.w   d1,$30(a0)
                sub.w   d0,$46(a0)

loc_42F72:
                move.l  #loc_42F78,(a0)

loc_42F78:
                moveq   #0,d5
                lea     $2E(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.w   sub_4301C
                addq.w  #1,a2
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   sub_4301C
                move.l  $30(a0),d0
                swap    d5
                asr.l   #3,d5
                add.l   d5,d0
                bpl.s   loc_42FA4
                moveq   #0,d0
                moveq   #0,d5

loc_42FA4:
                move.l  $34(a0),d1
                cmp.l   d1,d0
                blo.s   loc_42FB0
                move.l  d1,d0
                moveq   #0,d5

loc_42FB0:
                move.l  d0,$30(a0)
                swap    d0
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #3,d0
                bne.s   loc_43000
                tst.l   d5
                beq.s   loc_43000
                bpl.s   loc_42FE2
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #3,mapping_frame(a0)
                blo.s   loc_42FEE
                move.b  #0,mapping_frame(a0)
                bra.s   loc_42FEE
; ---------------------------------------------------------------------------

loc_42FE2:
                subq.b  #1,mapping_frame(a0)
                bcc.s   loc_42FEE
                move.b  #2,mapping_frame(a0)

loc_42FEE:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   loc_43000
                moveq   #signextendB(sfx_ConveyorPlatform),d0
                jsr     (Play_SFX).l

loc_43000:
                move.w  #$2B,d1
                move.w  #8,d2
                move.w  #9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_4301C:
                tst.b   (a2)
                bne.s   loc_4303A
                btst    d6,status(a0)
                beq.s   locret_43038
                cmpi.b  #9,anim(a1)
                bne.s   locret_43038
                move.w  x_pos(a0),x_pos(a1)
                move.b  #1,(a2)

locret_43038:
                rts
; ---------------------------------------------------------------------------

loc_4303A:
                btst    #Status_InAir,status(a1)
                bne.s   loc_43052
                cmpi.b  #2,anim(a1)
                beq.s   loc_4305E
                cmpi.b  #9,anim(a1)
                beq.s   loc_4305E

loc_43052:
                move.w  #0,x_vel(a1)
                move.b  #0,(a2)
                rts
; ---------------------------------------------------------------------------

loc_4305E:
                move.w  x_pos(a0),x_pos(a1)
                move.w  ground_vel(a1),d0
                beq.s   loc_43082
                bpl.s   loc_43076
                addi.w  #$40,d0
                bcc.s   loc_4307E
                moveq   #0,d0
                bra.s   loc_4307E
; ---------------------------------------------------------------------------

loc_43076:
                subi.w  #$40,d0
                bcc.s   loc_4307E
                moveq   #0,d0

loc_4307E:
                move.w  d0,ground_vel(a1)

loc_43082:
                moveq   #8,d0
                add.b   spin_dash_counter(a1),d0
                btst    #Status_Facing,status(a1)
                bne.s   loc_43092
                neg.w   d0

loc_43092:
                add.w   d0,d5
                rts
; End of function sub_4301C

; ---------------------------------------------------------------------------
Map_LRZDashElevator:
                include "src/objects/shared/zones/lrz/map_dash_elevator.s"
