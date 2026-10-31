; Owner: objects/zones/dez/sk
; Responsibility: Tunnel launcher capture, launch countdown, player transport and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZTunnelLauncher:
                move.l  #Map_DEZTunnelLauncher,mappings(a0)
                move.w  #make_art_tile(ArtTile_DEZMisc+$38,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                andi.b  #$FE,render_flags(a0)
                move.b  #$48,width_pixels(a0)
                move.b  #$50,height_pixels(a0)
                move.w  #$80,priority(a0)
                bset    #6,render_flags(a0)
                lea     sub2_x_pos(a0),a2
                move.w  #1,mainspr_childsprites(a0)
                move.w  x_pos(a0),d2
                addi.w  #$38,d2
                btst    #0,status(a0)
                beq.s   loc_48242
                subi.w  #2*$38,d2

loc_48242:
                move.w  d2,(a2)+
                move.w  y_pos(a0),d3
                subi.w  #$2C,d3
                btst    #1,status(a0)
                beq.s   loc_4825E
                addi.w  #2*$2C,d3
                bset    #0,render_flags(a0)

loc_4825E:
                move.w  d3,(a2)+
                move.w  #0,(a2)+
                move.b  #0,mapping_frame(a0)
                move.l  #Obj_DEZTunnelLauncher_Main,(a0)

Obj_DEZTunnelLauncher_Main:
                lea     $30(a0),a4
                lea     (Player_1).w,a1
                bsr.w   sub_48370
                lea     $38(a0),a4
                lea     (Player_2).w,a1
                bsr.w   sub_48370
                tst.w   $2E(a0)
                beq.w   loc_48316
                subq.b  #1,$2E(a0)
                bne.s   loc_482F4
                move.b  #60,$2E(a0)
                tst.b   $2F(a0)
                beq.s   loc_482F4
                subq.b  #1,$2F(a0)
                moveq   #signextendB(sfx_LaunchGo),d0
                cmpi.b  #7,$2F(a0)
                beq.s   loc_482B2
                moveq   #signextendB(sfx_LaunchReady),d0

loc_482B2:
                jsr     (Play_SFX).l
                cmpi.b  #7,$2F(a0)
                bne.s   loc_482F4
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_482EE
                move.l  #Obj_DEZTunnelControl,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  subtype(a0),subtype(a1)
                move.b  $30(a0),$30(a1)
                move.b  $38(a0),$38(a1)

loc_482EE:
                move.l  #Obj_DEZTunnelLauncher_Countdown,(a0)

loc_482F4:
                subq.b  #1,mapping_frame(a0)
                bne.s   loc_48300
                move.b  #2,mapping_frame(a0)

loc_48300:
                move.b  #0,sub2_mapframe(a0)
                move.b  $2E(a0),d0
                andi.b  #1,d0
                beq.s   loc_48316
                move.b  $2F(a0),sub2_mapframe(a0)

loc_48316:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_DEZTunnelLauncher_Countdown:
                subq.b  #1,$2E(a0)
                bne.s   loc_48348
                move.w  #0,$2E(a0)
                move.b  #0,mapping_frame(a0)
                move.b  #0,sub2_mapframe(a0)
                move.b  #0,$30(a0)
                move.b  #0,$38(a0)
                move.l  #Obj_DEZTunnelLauncher_Main,(a0)
                bra.s   loc_4836A
; ---------------------------------------------------------------------------

loc_48348:
                move.b  #0,sub2_mapframe(a0)
                move.b  $2E(a0),d0
                andi.b  #1,d0
                beq.s   loc_4835E
                move.b  $2F(a0),sub2_mapframe(a0)

loc_4835E:
                cmpi.b  #6,mapping_frame(a0)
                beq.s   loc_4836A
                addq.b  #1,mapping_frame(a0)

loc_4836A:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

dezTunnel_routine:          equ     0
dezTunnel_timer:            equ     1
dezTunnel_waypointsLeft:    equ     2
dezTunnel_angle:            equ     3
dezTunnel_currentWaypoint:  equ     4

sub_48370:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addq.w  #8,d0
                cmpi.w  #$10,d0
                bhs.w   locret_48422
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   locret_48422
                btst    #Status_InAir,status(a1)
                bne.w   locret_48422
                tst.b   object_control(a1)
                bne.s   locret_48422
                move.w  x_pos(a0),x_pos(a1)
                move.b  status(a0),d0
                andi.b  #1,d0
                andi.b  #$FE,status(a1)
                or.b    d0,status(a1)
                move.l  a0,-(sp)
                movea.l a1,a0
                jsr     (Player_TouchFloor).l
                movea.l (sp)+,a0
                move.b  #$81,object_control(a1)
                move.b  #9,anim(a1)
                move.b  #2,dezTunnel_routine(a4)
                tst.b   $2F(a0)
                bne.s   locret_48422
                moveq   #signextendB(sfx_LaunchGrab),d0
                jsr     (Play_SFX).l
                cmpa.w  #Player_1,a1
                bne.s   loc_48410
                move.w  #$3C0A,$2E(a0)
                move.b  #$A,sub2_mapframe(a0)
                moveq   #signextendB(sfx_LaunchReady),d0
                jsr     (Play_SFX).l
                tst.b   mapping_frame(a0)
                bne.s   locret_4840E
                move.b  #7,mapping_frame(a0)

locret_4840E:
                rts
; ---------------------------------------------------------------------------

loc_48410:
                move.w  #$3C00,$2E(a0)
                tst.b   mapping_frame(a0)
                bne.s   locret_48422
                move.b  #7,mapping_frame(a0)

locret_48422:
                rts
; End of function sub_48370

; ---------------------------------------------------------------------------
Map_DEZTunnelLauncher:
                include "src/objects/shared/zones/dez/mappings/tunnel_launcher.s"
