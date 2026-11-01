; Owner: objects/zones/mhz/sk
; Responsibility: Sticky vine capture, climbing or movement control and player release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZStickyVine:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_3EAC4
                move.l  #loc_3ED0A,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_MHZStickyVine,mappings(a1)
                move.w  #make_art_tile(ArtTile_MHZMisc+$C3,2,0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.w  #$200,priority(a1)
                move.b  #$80,width_pixels(a1)
                move.b  #$80,height_pixels(a1)
                bset    #6,render_flags(a1)
                moveq   #8,d1
                move.w  d1,mainspr_childsprites(a1)
                subq.b  #1,d1
                lea     sub2_x_pos(a1),a2

loc_3EAA8:
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #0,(a2)+
                dbf     d1,loc_3EAA8
                move.w  a1,parent3(a0)
                move.l  #loc_3EACA,(a0)
                rts
; ---------------------------------------------------------------------------

loc_3EAC4:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3EACA:
                lea     (Player_1).w,a1
                bsr.s   loc_3EADA
                lea     (Player_2).w,a1
                bsr.s   loc_3EADA
                bra.w   loc_3EBF8
; ---------------------------------------------------------------------------

loc_3EADA:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$C,d0
                cmpi.w  #$18,d0
                bhs.w   locret_3EB24
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$18,d0
                cmpi.w  #$30,d0
                bhs.w   locret_3EB24
                tst.w   (Debug_placement_mode).w
                bne.s   locret_3EB24
                cmpi.b  #4,routine(a1)
                bhs.w   locret_3EB24
                tst.b   object_control(a1)
                bne.w   locret_3EB24
                move.l  #loc_3EB26,(a0)
                move.l  a1,$2E(a0)

locret_3EB24:
                rts
; ---------------------------------------------------------------------------

loc_3EB26:
                movea.l $2E(a0),a1
                tst.b   spin_dash_flag(a1)
                beq.s   loc_3EB3C
                move.b  #1,$3D(a0)
                move.b  #$10,$3E(a0)

loc_3EB3C:
                move.l  x_pos(a1),d0
                move.l  y_pos(a1),d1
                bsr.w   LayOutMhzStickyVineSegments
                bsr.w   ApplyMhzStickyVinePullToPlayer
                bra.w   loc_3EBF8
; ---------------------------------------------------------------------------

loc_3EB50:
                movea.l $2E(a0),a1
                move.l  $30(a0),d0
                move.l  $34(a0),d1
                bsr.w   LayOutMhzStickyVineSegments
                move.w  $30(a0),d0
                sub.w   x_pos(a0),d0
                beq.s   loc_3EB7A
                bcc.s   loc_3EB74
                addq.w  #2,d0
                bcc.s   loc_3EB7A
                moveq   #0,d0
                bra.s   loc_3EB7A
; ---------------------------------------------------------------------------

loc_3EB74:
                subq.w  #2,d0
                bcc.s   loc_3EB7A
                moveq   #0,d0

loc_3EB7A:
                move.w  d0,d2
                add.w   x_pos(a0),d2
                move.w  d2,$30(a0)
                move.w  $34(a0),d1
                sub.w   y_pos(a0),d1
                beq.s   loc_3EBEE
                bcc.s   loc_3EBBA
                move.w  y_vel(a0),d2
                addi.w  #$38,y_vel(a0)
                ext.l   d2
                asl.l   #8,d2
                add.l   d2,$34(a0)
                move.w  $34(a0),d2
                cmp.w   y_pos(a0),d2
                blo.s   loc_3EBEE
                move.w  y_pos(a0),$34(a0)
                move.w  #0,y_vel(a0)
                bra.s   loc_3EBEE
; ---------------------------------------------------------------------------

loc_3EBBA:
                tst.w   y_vel(a0)
                bpl.s   loc_3EBD4
                move.w  y_vel(a0),d2
                addi.w  #$38,y_vel(a0)
                ext.l   d2
                asl.l   #8,d2
                add.l   d2,$34(a0)
                bra.s   loc_3EBEE
; ---------------------------------------------------------------------------

loc_3EBD4:
                subq.w  #2,$34(a0)
                move.w  $34(a0),d2
                cmp.w   y_pos(a0),d2
                bhs.s   loc_3EBEE
                move.w  y_pos(a0),$34(a0)
                move.w  #0,y_vel(a0)

loc_3EBEE:
                or.w    d0,d1
                bne.s   loc_3EBF8
                move.l  #loc_3EACA,(a0)

loc_3EBF8:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_3EC0E
                rts
; ---------------------------------------------------------------------------

loc_3EC0E:
                move.w  respawn_addr(a0),d0
                beq.s   loc_3EC1A
                movea.w d0,a2
                bclr    #7,(a2)

loc_3EC1A:
                movea.w parent3(a0),a1
                jsr     (Delete_Referenced_Sprite).l
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

LayOutMhzStickyVineSegments:
                movea.w parent3(a0),a2
                move.l  x_pos(a0),d2
                move.l  y_pos(a0),d3
                sub.l   d2,d0
                sub.l   d3,d1
                movem.l d0-d1,-(sp)
                asr.l   #3,d0
                asr.l   #3,d1
                lea     $48(a2),a3
                moveq   #8-1,d6
                bra.s   loc_3EC4E
; ---------------------------------------------------------------------------

loc_3EC4A:
                add.l   d0,d2
                add.l   d1,d3

loc_3EC4E:
                subq.w  #2,a3
                swap    d3
                move.w  d3,-(a3)
                swap    d3
                swap    d2
                move.w  d2,-(a3)
                swap    d2
                dbf     d6,loc_3EC4A
                movem.l (sp)+,d1-d2
                rts
; End of function LayOutMhzStickyVineSegments

; =============== S U B R O U T I N E =======================================

ApplyMhzStickyVinePullToPlayer:
                swap    d1
                swap    d2
                move.w  d1,d3
                bpl.s   loc_3EC70
                neg.w   d3

loc_3EC70:
                move.w  d2,d4
                bpl.s   loc_3EC76
                neg.w   d4

loc_3EC76:
                add.w   d4,d3
                add.w   d3,d3
                jsr     (GetArcTan).l
                jsr     (GetSineCosine).l
                muls.w  d3,d1
                muls.w  d3,d0
                asl.l   #1,d0
                asl.l   #2,d1
                sub.l   d1,x_pos(a1)
                btst    #Status_InAir,status(a1)
                beq.s   loc_3ECAA
                sub.l   d0,y_pos(a1)
                tst.w   y_vel(a1)
                bmi.s   loc_3ECCC
                asr     x_vel(a1)
                bra.s   loc_3ECCC
; ---------------------------------------------------------------------------

loc_3ECAA:
                asr.l   #8,d1
                tst.w   d1
                bpl.s   loc_3ECB2
                neg.w   d1

loc_3ECB2:
                move.w  ground_vel(a1),d0
                bpl.s   loc_3ECBA
                neg.w   d0

loc_3ECBA:
                cmpi.w  #$200,d0
                blo.s   loc_3ECCC
                subi.w  #$10,d0
                cmp.w   d1,d0
                bhs.s   loc_3ECCC
                asr     ground_vel(a1)

loc_3ECCC:
                tst.b   $3D(a0)
                beq.s   loc_3ED02
                tst.b   spin_dash_flag(a1)
                bne.s   loc_3ED02
                subq.b  #1,$3E(a0)
                bne.s   loc_3ED02
                move.l  x_pos(a1),$30(a0)
                move.l  y_pos(a1),$34(a0)
                move.w  #-$600,y_vel(a0)
                move.b  #0,$3D(a0)
                move.b  #0,$3E(a0)
                move.l  #loc_3EB50,(a0)

loc_3ED02:
                bclr    #Status_Push,status(a1)
                rts
; End of function ApplyMhzStickyVinePullToPlayer

; ---------------------------------------------------------------------------

loc_3ED0A:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_MHZStickyVine:
                include "src/objects/shared/zones/mhz/mappings/sticky_vine.s"
