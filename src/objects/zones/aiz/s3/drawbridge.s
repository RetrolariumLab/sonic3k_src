; Owner: objects/zones/aiz/s3
; Responsibility: Angel Island drawbridge initialization, coordinated movement, collision and mapping geometry
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZDrawBridge:
                move.l  #Map_AIZDrawBridge,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,1),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #$60,height_pixels(a0)
                ori.b   #$80,status(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                subi.w  #$68,y_pos(a0)
                move.b  #-$40,$38(a0)
                moveq   #-$10,d4
                btst    #1,status(a0)
                beq.s   loc_2A84E
                addi.w  #$D0,y_pos(a0)
                move.b  #$40,$38(a0)
                neg.w   d4

loc_2A84E:
                move.w  #$200,d1
                btst    #0,status(a0)
                beq.s   loc_2A85C
                neg.w   d1

loc_2A85C:
                move.w  d1,$34(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_2A92E
                move.l  #loc_2AA48,(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.w  priority(a0),priority(a1)
                move.b  #4,render_flags(a1)
                bset    #6,render_flags(a1)
                move.b  #$40,width_pixels(a1)
                move.b  #$40,height_pixels(a1)
                move.w  $30(a0),d2
                move.w  $32(a0),d3
                moveq   #8,d1
                move.w  d1,mainspr_childsprites(a1)
                subq.w  #1,d1
                lea     sub2_x_pos(a1),a2

loc_2A8AE:
                add.w   d4,d3
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                move.w  #1,(a2)+
                dbf     d1,loc_2A8AE
                move.w  $30(a1),x_pos(a1)
                move.w  $32(a1),y_pos(a1)
                move.w  a1,$3C(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_2A92E
                move.l  #loc_2AA48,(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.w  priority(a0),priority(a1)
                move.b  #4,render_flags(a1)
                bset    #6,render_flags(a1)
                move.b  #$40,width_pixels(a1)
                move.b  #$40,height_pixels(a1)
                moveq   #4,d1
                move.w  d1,mainspr_childsprites(a1)
                subq.w  #1,d1
                lea     sub2_x_pos(a1),a2

loc_2A910:
                add.w   d4,d3
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                move.w  #1,(a2)+
                dbf     d1,loc_2A910
                move.w  sub2_x_pos(a1),x_pos(a1)
                move.w  sub2_y_pos(a1),y_pos(a1)
                move.w  a1,$3E(a0)

loc_2A92E:
                move.l  #loc_2A934,(a0)

loc_2A934:
                tst.b   (_unkFAA3).w
                beq.s   loc_2A978
                tst.b   $36(a0)
                bne.s   loc_2A978
                move.b  #1,$36(a0)
                moveq   #signextendB(sfx_FlipBridge),d0
                jsr     (Play_SFX).l
                move.w  #$68,d1
                btst    #0,status(a0)
                beq.s   loc_2A95C
                neg.w   d1

loc_2A95C:
                move.w  $30(a0),x_pos(a0)
                move.w  $32(a0),y_pos(a0)
                add.w   d1,x_pos(a0)
                move.b  #$60,width_pixels(a0)
                move.b  #8,height_pixels(a0)

loc_2A978:
                tst.b   $36(a0)
                beq.s   loc_2A9AA
                tst.b   $38(a0)
                beq.s   loc_2A98C
                cmpi.b  #$80,$38(a0)
                bne.s   loc_2A9A2

loc_2A98C:
                move.b  #0,$36(a0)
                moveq   #signextendB(sfx_FlipBridge),d0
                jsr     (Play_SFX).l
                move.l  #loc_2A9B0,(a0)
                bra.s   loc_2A9AA
; ---------------------------------------------------------------------------

loc_2A9A2:
                move.w  $34(a0),d0
                add.w   d0,$38(a0)

loc_2A9AA:
                bsr.w   PositionAizDrawbridgePieces
                bra.s   loc_2A9CC
; ---------------------------------------------------------------------------

loc_2A9B0:
                tst.b   (_unkFAA9).w
                beq.s   loc_2A9CC
                move.l  #loc_2AB1A,(a0)
                move.b  #$E,$34(a0)
                move.l  #loc_2AAF2,d4
                bra.w   loc_2AB60
; ---------------------------------------------------------------------------

loc_2A9CC:
                move.w  #$13,d1
                move.w  #$60,d2
                move.w  #$61,d3
                move.b  $38(a0),d0
                beq.s   loc_2A9EA
                cmpi.b  #$40,d0
                beq.s   loc_2A9F6
                cmpi.b  #-$40,d0
                beq.s   loc_2A9F6

loc_2A9EA:
                move.w  #$6B,d1
                move.w  #8,d2
                move.w  #8,d3

loc_2A9F6:
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull2).l
                move.w  $30(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_2AA1A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2AA1A:
                move.w  $3C(a0),d0
                beq.s   loc_2AA28
                movea.w d0,a1
                jsr     (Delete_Referenced_Sprite).l

loc_2AA28:
                move.w  $3E(a0),d0
                beq.s   loc_2AA36
                movea.w d0,a1
                jsr     (Delete_Referenced_Sprite).l

loc_2AA36:
                move.w  respawn_addr(a0),d0
                beq.s   loc_2AA42
                movea.w d0,a2
                bclr    #7,(a2)

loc_2AA42:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2AA48:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

PositionAizDrawbridgePieces:
                tst.b   $36(a0)
                beq.w   locret_2AAF0
                moveq   #0,d0
                moveq   #0,d1
                move.b  $38(a0),d0
                jsr     (GetSineCosine).l
                move.w  $32(a0),d2
                move.w  $30(a0),d3
                moveq   #0,d6
                movea.w $3C(a0),a1
                move.w  mainspr_childsprites(a1),d6
                subq.w  #1,d6
                bcs.s   locret_2AAF0
                swap    d0
                swap    d1
                asr.l   #4,d0
                asr.l   #4,d1
                move.l  d0,d4
                move.l  d1,d5
                lea     sub2_x_pos(a1),a2

loc_2AA8A:
                movem.l d4-d5,-(sp)
                swap    d4
                swap    d5
                add.w   d2,d4
                add.w   d3,d5
                move.w  d5,(a2)+
                move.w  d4,(a2)+
                movem.l (sp)+,d4-d5
                add.l   d0,d4
                add.l   d1,d5
                addq.w  #2,a2
                dbf     d6,loc_2AA8A
                move.w  $30(a1),x_pos(a1)
                move.w  $32(a1),y_pos(a1)
                moveq   #0,d6
                movea.w $3E(a0),a1
                move.w  mainspr_childsprites(a1),d6
                subq.w  #1,d6
                bcs.s   locret_2AAF0
                lea     sub2_x_pos(a1),a2

loc_2AAC6:
                movem.l d4-d5,-(sp)
                swap    d4
                swap    d5
                add.w   d2,d4
                add.w   d3,d5
                move.w  d5,(a2)+
                move.w  d4,(a2)+
                movem.l (sp)+,d4-d5
                add.l   d0,d4
                add.l   d1,d5
                addq.w  #2,a2
                dbf     d6,loc_2AAC6
                move.w  sub2_x_pos(a1),x_pos(a1)
                move.w  sub2_y_pos(a1),y_pos(a1)

locret_2AAF0:
                rts
; End of function PositionAizDrawbridgePieces

; ---------------------------------------------------------------------------

loc_2AAF2:
                tst.b   $34(a0)
                beq.s   loc_2AB02
                subq.b  #1,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2AB02:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bpl.s   loc_2AB14
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2AB14:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2AB1A:
                tst.b   $34(a0)
                beq.s   loc_2AB26
                subq.b  #1,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_2AB26:
                bclr    #p1_standing_bit,status(a0)
                beq.s   loc_2AB40
                bclr    #Status_OnObj,(Player_1+status).w
                bset    #Status_InAir,(Player_1+status).w
                move.b  #$1B,(Player_1+anim).w

loc_2AB40:
                bclr    #p2_standing_bit,status(a0)
                beq.s   loc_2AB5A
                bclr    #Status_OnObj,(Player_2+status).w
                bset    #Status_InAir,(Player_2+status).w
                move.b  #$1B,(Player_2+anim).w

loc_2AB5A:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2AB60:
                move.w  $3C(a0),d0
                beq.s   loc_2AB6A
                movea.w d0,a3
                bsr.s   SplitAizDrawbridgeBankWithExplosions

loc_2AB6A:
                move.w  $3E(a0),d0
                beq.s   locret_2AB74
                movea.w d0,a3
                bsr.s   SplitAizDrawbridgeBankWithExplosions

locret_2AB74:
                rts
; ---------------------------------------------------------------------------

SplitAizDrawbridgeBankWithExplosions:
                lea     (byte_2AC10).l,a4
                lea     sub2_x_pos(a3),a2
                move.w  mainspr_childsprites(a3),d6
                subq.w  #1,d6
                bclr    #6,render_flags(a3)
                movea.l a3,a1
                bra.s   loc_2AB98
; ---------------------------------------------------------------------------

loc_2AB90:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_2ABFC

loc_2AB98:
                move.l  d4,(a1)
                move.l  mappings(a3),mappings(a1)
                move.b  render_flags(a3),render_flags(a1)
                move.w  art_tile(a3),art_tile(a1)
                move.w  priority(a3),priority(a1)
                move.b  width_pixels(a3),width_pixels(a1)
                move.b  height_pixels(a3),height_pixels(a1)
                move.w  priority(a3),priority(a1)
                move.w  (a2)+,x_pos(a1)
                move.w  (a2)+,y_pos(a1)
                move.w  (a2)+,d0
                move.b  d0,mapping_frame(a1)
                move.b  (a4)+,$34(a1)
                movea.l a1,a5
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_2ABFC
                move.l  #loc_1C31E,(a1)
                move.w  x_pos(a5),x_pos(a1)
                move.w  y_pos(a5),y_pos(a1)
                move.b  -1(a4),anim_frame_timer(a1)
                dbf     d6,loc_2AB90

loc_2ABFC:
                move.w  #0,sub2_x_pos(a3)
                move.w  #0,sub2_y_pos(a3)
                moveq   #signextendB(sfx_BridgeCollapse),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------
byte_2AC10:
                dc.b    8
                dc.b    $10
                dc.b    $C
                dc.b    $E
                dc.b    6
                dc.b    $A
                dc.b    4
                dc.b    2
                dc.b    8
                dc.b    $10
                dc.b    $C
                dc.b    $E
                dc.b    6
                dc.b    $A
                dc.b    4
                dc.b    2
                even
Map_AIZDrawBridge:
                include "src/objects/shared/zones/aiz/mappings/drawbridge.s"
