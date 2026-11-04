; Owner: objects/zones/mhz/sk
; Responsibility: Curled vine player contact, constrained traversal and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZCurledVine:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_3E89C
                move.l  #loc_3E9A6,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_MHZCurledVine,mappings(a1)
                move.w  #make_art_tile(ArtTile_MHZMisc+$C,2,0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.w  #$280,priority(a1)
                move.b  #$40,width_pixels(a1)
                move.b  #$30,height_pixels(a1)
                bset    #6,render_flags(a1)
                move.w  #8,mainspr_childsprites(a1)
                move.l  #$FFF40000,$32(a0)
                bset    #7,status(a0)
                move.w  a1,parent3(a0)
                move.l  #loc_3E8A2,(a0)
                bra.s   loc_3E8A2
; ---------------------------------------------------------------------------

loc_3E89C:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3E8A2:
                movea.w parent3(a0),a1
                moveq   #0,d1
                moveq   #0,d2
                move.b  status(a0),d1
                andi.b  #standing_mask,d1
                beq.s   loc_3E8C4
                move.b  $36(a0),d1
                move.b  $37(a0),d2
                cmp.b   d1,d2
                blo.s   loc_3E8C2
                move.b  d2,d1

loc_3E8C2:
                addq.b  #1,d1

loc_3E8C4:
                move.b  byte_3E8F6(pc,d1.w),d2
                move.w  d2,-(sp)
                lsl.w   #2,d1
                move.l  dword_3E8D2(pc,d1.w),d0
                bra.s   loc_3E900
; ---------------------------------------------------------------------------
dword_3E8D2:
                dc.l    $FFF40000
                dc.l    $FFFA0000
                dc.l    $FFFB0000
                dc.l    $FFFC0000
                dc.l    $FFFD0000
                dc.l    $FFFE0000
                dc.l    $FFFF0000
                dc.l    $FFFF0000
                dc.l    $FFFF0000
byte_3E8F6:
                dc.b    $40
                dc.b    $40
                dc.b    $40
                dc.b    $40
                dc.b    $50
                dc.b    $60
                dc.b    $70
                dc.b    $80
                dc.b    $80
                even
; ---------------------------------------------------------------------------

loc_3E900:
                move.l  $32(a0),d4
                cmp.l   d0,d4
                beq.s   loc_3E918
                bcs.s   loc_3E912
                subi.l  #$10000,d4
                bra.s   loc_3E918
; ---------------------------------------------------------------------------

loc_3E912:
                addi.l  #$10000,d4

loc_3E918:
                move.l  d4,$32(a0)
                move.l  d4,d1
                asr.l   #1,d1
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #$38,d2
                move.l  #$A0000,d5
                moveq   #8-1,d6
                lea     sub2_x_pos(a1),a2
                move.l  d1,-(sp)
                bra.s   loc_3E952
; ---------------------------------------------------------------------------

loc_3E93C:
                move.l  d1,-(sp)
                swap    d5
                move.w  d5,d0
                swap    d5
                jsr     (GetSineCosine).l
                asr.w   #4,d1
                asr.w   #4,d0
                add.w   d1,d2
                add.w   d0,d3

loc_3E952:
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                addq.w  #2,a2
                add.l   d4,d5
                move.l  (sp)+,d1
                add.l   d1,d4
                dbf     d6,loc_3E93C
                move.w  (sp)+,d2
                move.w  #$40,d1
                moveq   #8,d3
                move.w  x_pos(a0),d4
                movea.l a1,a2
                bsr.w   CheckPlayersOnMhzCurledVine
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_3E98A
                rts
; ---------------------------------------------------------------------------

loc_3E98A:
                move.w  respawn_addr(a0),d0
                beq.s   loc_3E996
                movea.w d0,a2
                bclr    #7,(a2)

loc_3E996:
                movea.w parent3(a0),a1
                jsr     (Delete_Referenced_Sprite).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3E9A6:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

CheckPlayersOnMhzCurledVine:
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                moveq   #$37,d5
                movem.l d1-d4,-(sp)
                bsr.s   CheckPlayerOnMhzCurledVineSegments
                movem.l (sp)+,d1-d4
                lea     (Player_1).w,a1
                subq.b  #p2_standing_bit-p1_standing_bit,d6
                moveq   #$36,d5
; End of function CheckPlayersOnMhzCurledVine

; =============== S U B R O U T I N E =======================================

CheckPlayerOnMhzCurledVineSegments:
                btst    d6,status(a0)
                beq.s   loc_3EA1E
                btst    #Status_InAir,status(a1)
                bne.s   loc_3E9E6
                moveq   #0,d0
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_3E9E6
                cmp.w   d2,d0
                blo.s   loc_3E9FA

loc_3E9E6:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,(a0,d5.w)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_3E9FA:
                lsr.w   #4,d0
                move.b  d0,(a0,d5.w)
                add.w   d0,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                move.w  $1A(a2,d0.w),d0
                subq.w  #8,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                sub.w   d1,d0
                move.w  d0,y_pos(a1)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_3EA1E:
                tst.w   y_vel(a1)
                bmi.s   locret_3EA4A
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   locret_3EA4A
                cmp.w   d2,d0
                bhs.s   locret_3EA4A
                lsr.w   #4,d0
                add.w   d0,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                move.w  $1A(a2,d0.w),d0
                subq.w  #8,d0
                jmp     (SKCollision_LandAtCallerComputedTopWithinUnsignedPenetrationWindow).l
; ---------------------------------------------------------------------------

locret_3EA4A:
                rts
; End of function CheckPlayerOnMhzCurledVineSegments

; ---------------------------------------------------------------------------
Map_MHZCurledVine:
                include "src/objects/shared/zones/mhz/mappings/curled_vine.s"
