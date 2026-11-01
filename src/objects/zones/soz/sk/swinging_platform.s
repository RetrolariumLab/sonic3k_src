; Owner: objects/zones/soz/sk
; Responsibility: Swinging platform coordinated motion, player riding and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZSwingingPlatform:
                move.l  #Map_SOZSwingingPlatform,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_414E6
                move.l  #Draw_Sprite,(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  #4,render_flags(a1)
                move.b  #$60,width_pixels(a1)
                move.b  #$60,height_pixels(a1)
                move.w  #$280,priority(a1)
                move.w  x_pos(a0),d2
                move.w  d2,x_pos(a1)
                move.w  y_pos(a0),d3
                move.w  d3,y_pos(a1)
                bset    #6,render_flags(a1)
                lea     sub2_x_pos(a1),a2
                move.b  subtype(a0),d1
                andi.w  #$F,d1
                move.w  d1,mainspr_childsprites(a1)
                subq.w  #1,d1

loc_414CA:
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                move.w  #1,(a2)+
                dbf     d1,loc_414CA
                move.b  #2,sub2_mapframe(a1)
                move.b  #1,mapping_frame(a1)
                move.w  a1,$3C(a0)

loc_414E6:
                move.w  #$4000,angle(a0)
                move.w  #0,$32(a0)
                andi.b  #$F0,subtype(a0)
                move.l  #loc_414FE,(a0)

loc_414FE:
                move.w  x_pos(a0),-(sp)
                bsr.w   PositionSozSwingPlatformAndChain
                move.w  #$20,d1
                move.w  #$11,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectTop).l
                move.w  $44(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_41530
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_41530:
                move.w  respawn_addr(a0),d0
                beq.s   loc_4153C
                movea.w d0,a2
                bclr    #7,(a2)

loc_4153C:
                movea.w $3C(a0),a1
                jsr     (Delete_Referenced_Sprite).l
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

PositionSozSwingPlatformAndChain:
                moveq   #0,d0
                moveq   #0,d1
                move.b  (Oscillating_table+$1A).w,d0
                addi.b  #$80,d0
                tst.b   subtype(a0)
                beq.s   loc_41562
                bsr.w   AdvanceRiderDrivenSozSwingAngle

loc_41562:
                cmp.b   $36(a0),d0
                beq.w   locret_41634
                move.b  d0,$36(a0)
                btst    #0,status(a0)
                beq.s   loc_4157C
                neg.w   d0
                addi.w  #$80,d0

loc_4157C:
                btst    #1,status(a0)
                beq.s   loc_41586
                neg.w   d0

loc_41586:
                jsr     (GetSineCosine).l
                move.w  $46(a0),d2
                move.w  $44(a0),d3
                moveq   #0,d6
                movea.w $3C(a0),a1
                move.w  mainspr_childsprites(a1),d6
                subq.w  #2,d6
                bcs.w   locret_41634
                swap    d0
                swap    d1
                asr.l   #4,d0
                asr.l   #4,d1
                move.l  d0,d4
                move.l  d1,d5
                asr.l   #1,d4
                asr.l   #1,d5
                add.l   d0,d4
                add.l   d1,d5
                lea     sub3_x_pos(a1),a2

loc_415BC:
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
                dbf     d6,loc_415BC
                movem.l d4-d5,-(sp)
                swap    d4
                swap    d5
                add.w   d2,d4
                add.w   d3,d5
                move.w  anim_frame_timer(a1),d2
                move.w  angle(a1),d3
                move.w  d5,anim_frame_timer(a1)
                move.w  d4,angle(a1)
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                movem.l (sp)+,d4-d5
                asr.l   #1,d0
                asr.l   #1,d1
                add.l   d0,d4
                add.l   d1,d5
                swap    d4
                swap    d5
                add.w   $46(a0),d4
                add.w   $44(a0),d5
                move.w  d4,y_pos(a0)
                tst.b   subtype(a0)
                beq.s   loc_41630
                subi.w  #$18,d5
                btst    #0,status(a0)
                beq.s   loc_41630
                addi.w  #$30,d5

loc_41630:
                move.w  d5,x_pos(a0)

locret_41634:
                rts
; End of function PositionSozSwingPlatformAndChain

; =============== S U B R O U T I N E =======================================

AdvanceRiderDrivenSozSwingAngle:
                tst.w   $34(a0)
                beq.s   loc_4164C
                btst    #3,status(a0)
                bne.s   loc_416C0
                subq.w  #1,$34(a0)
                bra.w   loc_416C0
; ---------------------------------------------------------------------------

loc_4164C:
                tst.b   $31(a0)
                bne.s   loc_41668
                btst    #3,status(a0)
                beq.s   loc_416C0
                tst.w   (Debug_placement_mode).w
                bne.w   loc_416C0
                move.b  #1,$31(a0)

loc_41668:
                tst.b   $30(a0)
                bne.s   loc_41698
                move.w  $32(a0),d0
                addi.w  #8,d0
                move.w  d0,$32(a0)
                add.w   d0,angle(a0)
                tst.w   d0
                bne.s   loc_41688
                move.b  #0,$31(a0)

loc_41688:
                cmpi.b  #$80,angle(a0)
                blo.s   loc_416C0
                move.b  #1,$30(a0)
                bra.s   loc_416C0
; ---------------------------------------------------------------------------

loc_41698:
                move.w  $32(a0),d0
                subi.w  #8,d0
                move.w  d0,$32(a0)
                add.w   d0,angle(a0)
                tst.w   d0
                bne.s   loc_416B2
                move.w  #$1E,$34(a0)

loc_416B2:
                cmpi.b  #$80,angle(a0)
                bhs.s   loc_416C0
                move.b  #0,$30(a0)

loc_416C0:
                move.b  angle(a0),d0
                rts
; End of function AdvanceRiderDrivenSozSwingAngle

; ---------------------------------------------------------------------------
Map_SOZSwingingPlatform:
                include "src/objects/shared/zones/soz/mappings/swinging_platform.s"
