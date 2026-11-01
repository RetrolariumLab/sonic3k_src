; Owner: objects/zones/dez/sk
; Responsibility: Teleporter player capture, path state, transport and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZTeleporter:
                lea     (Player_1).w,a1
                lea     $30(a0),a4
                bsr.s   UpdatePlayerInDezTeleporter
                lea     (Player_2).w,a1
                lea     $3A(a0),a4
                bsr.s   UpdatePlayerInDezTeleporter
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerInDezTeleporter:
                moveq   #0,d0
                move.b  (a4),d0
                move.w  off_48C3C(pc,d0.w),d0
                jmp     off_48C3C(pc,d0.w)
; End of function UpdatePlayerInDezTeleporter

; ---------------------------------------------------------------------------
off_48C3C:
                dc.w    loc_48C44-off_48C3C
                dc.w    loc_48D2C-off_48C3C
                dc.w    loc_48DCA-off_48C3C
                dc.w    loc_48E94-off_48C3C
; ---------------------------------------------------------------------------

loc_48C44:
                tst.w   (Debug_placement_mode).w
                bne.w   locret_48D2A
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addq.w  #3,d0
                btst    #0,status(a0)
                beq.s   loc_48C62
                addi.w  #$A,d0

loc_48C62:
                cmpi.w  #$10,d0
                bhs.w   locret_48D2A
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$20,d1
                cmpi.w  #$40,d1
                bhs.w   locret_48D2A
                tst.b   object_control(a1)
                bne.w   locret_48D2A
                btst    #Status_InAir,status(a1)
                bne.w   locret_48D2A
                btst    #0,(_unkFAB8).w
                bne.w   locret_48D2A
                movea.w interact(a1),a3
                cmpi.l  #Obj_DEZTeleporter,(a3)
                bne.s   loc_48CB0
                move.w  a4,d0
                sub.w   a0,d0
                tst.b   (a3,d0.w)
                bne.s   locret_48D2A

loc_48CB0:
                move.w  a0,interact(a1)
                addq.b  #2,(a4)
                move.b  #$83,object_control(a1)
                move.b  #0,anim(a1)
                move.w  #0,ground_vel(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)
                move.w  x_pos(a0),x_pos(a1)
                bclr    #Status_Roll,status(a1)
                beq.s   loc_48D10
                move.b  y_radius(a1),d0
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                sub.b   default_y_radius(a1),d0
                ext.w   d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_48D0C
                neg.w   d0

loc_48D0C:
                add.w   d0,y_pos(a1)

loc_48D10:
                clr.b   1(a4)
                clr.w   2(a4)
                btst    #Status_Facing,status(a1)
                beq.s   loc_48D26
                move.b  #6,2(a4)

loc_48D26:
                clr.w   4(a4)

locret_48D2A:
                rts
; ---------------------------------------------------------------------------

loc_48D2C:
                addq.w  #8,4(a4)
                cmpi.w  #$300,4(a4)
                bne.s   loc_48D66
                move.b  subtype(a0),d0
                andi.w  #$7F,d0
                move.w  d0,6(a4)
                lsr.w   #1,d0
                move.w  d0,8(a4)
                move.w  #$1000,d0
                btst    #1,status(a0)
                bne.s   loc_48D58
                neg.w   d0

loc_48D58:
                move.w  d0,y_vel(a1)
                addq.b  #2,(a4)
                moveq   #signextendB(sfx_SuperTransform),d0
                jsr     (Play_SFX).l

loc_48D66:
                move.w  2(a4),d0
                add.w   4(a4),d0
                cmpi.w  #$C00,d0
                blo.s   loc_48D78
                subi.w  #$C00,d0

loc_48D78:
                move.w  d0,2(a4)
                moveq   #0,d0
                move.b  2(a4),d0
                move.b  RawAni_48DB2(pc,d0.w),mapping_frame(a1)
                andi.b  #$FC,render_flags(a1)
                move.b  byte_48DBE(pc,d0.w),d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_48D9C
                ori.b   #2,d0

loc_48D9C:
                or.b    d0,render_flags(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                move.l  a2,-(sp)
                jsr     (Perform_Player_DPLC).l
                movea.l (sp)+,a2
                rts
; ---------------------------------------------------------------------------
RawAni_48DB2:
                dc.b    $55, $59, $5A, $5B, $5A, $59, $55, $56, $57, $58, $57, $56
byte_48DBE:
                dc.b    0,   1,   1,   0,   0,   0,   1,   1,   1,   0,   0,   0
                even
; ---------------------------------------------------------------------------

loc_48DCA:
                move.w  6(a4),d1
                move.w  8(a4),d2
                cmp.w   d2,d1
                bne.s   loc_48DF6
                cmpa.w  #Player_1,a1
                bne.s   loc_48DF6
                move.b  subtype(a0),d0
                rol.b   #1,d0
                andi.b  #1,d0
                cmp.b   (Reverse_gravity_flag).w,d0
                bne.s   loc_48DF2
                move.b  #1,1(a4)

loc_48DF2:
                move.b  d0,(Reverse_gravity_flag).w

loc_48DF6:
                move.b  #0,invulnerability_timer(a1)
                cmpi.w  #5,d1
                bcs.s   loc_48E10
                add.w   d2,d2
                subq.w  #5,d2
                cmp.w   d2,d1
                bhs.s   loc_48E10
                move.b  #1,invulnerability_timer(a1)

loc_48E10:
                subq.w  #1,6(a4)
                bmi.s   loc_48E2C
                move.l  y_pos(a1),d3
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d3
                move.l  d3,y_pos(a1)
                bra.w   loc_48D66
; ---------------------------------------------------------------------------

loc_48E2C:
                addq.b  #2,(a4)
                clr.b   object_control(a1)
                move.w  #0,y_vel(a1)
                moveq   #9,d0
                cmpi.b  #1,character_id(a1)
                bne.s   loc_48E44
                moveq   #$11,d0

loc_48E44:
                tst.b   subtype(a0)
                bpl.s   loc_48E6A
                neg.w   d0
                btst    #1,status(a0)
                beq.s   loc_48E88
                moveq   #7,d0
                cmpi.b  #1,character_id(a1)
                bne.s   loc_48E60
                subq.w  #8,d0

loc_48E60:
                tst.b   1(a4)
                beq.s   loc_48E8E
                moveq   #$10,d0
                bra.s   loc_48E8E
; ---------------------------------------------------------------------------

loc_48E6A:
                btst    #1,status(a0)
                bne.s   loc_48E88
                moveq   #-7,d0
                cmpi.b  #1,character_id(a1)
                bne.s   loc_48E7E
                addq.w  #8,d0

loc_48E7E:
                tst.b   1(a4)
                beq.s   loc_48E8E
                moveq   #-$10,d0
                bra.s   loc_48E8E
; ---------------------------------------------------------------------------

loc_48E88:
                tst.b   1(a4)
                bne.s   locret_48E92

loc_48E8E:
                add.w   d0,y_pos(a1)

locret_48E92:
                rts
; ---------------------------------------------------------------------------

loc_48E94:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                blo.s   locret_48EAC
                clr.w   $42(a1)
                clr.b   (a4)

locret_48EAC:
                rts
