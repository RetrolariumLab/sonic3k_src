; Owner: objects/shared/s3
; Responsibility: Invisible horizontal and vertical harmful regions, product-specific shock or lava reactions and shared player contact geometry
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_InvisibleHurtBlockHorizontal:
                move.l  #Map_InvisibleBlock,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ring,0,1),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$F0,d0
                addi.w  #$10,d0
                lsr.w   #1,d0
                move.b  d0,width_pixels(a0)
                andi.w  #$F,d1
                addq.w  #1,d1
                lsl.w   #3,d1
                move.b  d1,height_pixels(a0)
                btst    #0,status(a0)
                beq.s   loc_1D0E0
                move.l  #loc_1D15C,(a0)
                rts
; ---------------------------------------------------------------------------

loc_1D0E0:
                btst    #1,status(a0)
                beq.s   loc_1D0F0
                move.l  #loc_1D1C0,(a0)
                rts
; ---------------------------------------------------------------------------

loc_1D0F0:
                move.l  #loc_1D0F6,(a0)

loc_1D0F6:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull2
                move.b  status(a0),d6
                andi.b  #standing_mask,d6
                beq.s   loc_1D13A
                move.b  d6,d0
                andi.b  #p1_standing,d0
                beq.s   loc_1D12C
                lea     (Player_1).w,a1
                bsr.w   sub_228EC

loc_1D12C:
                andi.b  #p2_standing,d6
                beq.s   loc_1D13A
                lea     (Player_2).w,a1
                bsr.w   sub_228EC

loc_1D13A:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_1C778
                tst.w   (Debug_placement_mode).w
                beq.s   locret_1D15A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_1D15A:
                rts
; ---------------------------------------------------------------------------

loc_1D15C:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull2
                swap    d6
                andi.w  #3,d6
                beq.s   loc_1D19E
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   loc_1D190
                lea     (Player_1).w,a1
                bsr.w   sub_228EC

loc_1D190:
                andi.b  #2,d6
                beq.s   loc_1D19E
                lea     (Player_2).w,a1
                bsr.w   sub_228EC

loc_1D19E:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_1C778
                tst.w   (Debug_placement_mode).w
                beq.s   locret_1D1BE
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_1D1BE:
                rts
; ---------------------------------------------------------------------------

loc_1D1C0:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull2
                swap    d6
                andi.w  #$C,d6
                beq.s   loc_1D202
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   loc_1D1F4
                lea     (Player_1).w,a1
                bsr.w   sub_228EC

loc_1D1F4:
                andi.b  #8,d6
                beq.s   loc_1D202
                lea     (Player_2).w,a1
                bsr.w   sub_228EC

loc_1D202:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_1C778
                tst.w   (Debug_placement_mode).w
                beq.s   locret_1D222
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_1D222:
                rts
; ---------------------------------------------------------------------------

Obj_InvisibleHurtBlockVertical:
                move.l  #Map_InvisibleBlock,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ring,0,1),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$F0,d0
                addi.w  #$10,d0
                lsr.w   #1,d0
                move.b  d0,width_pixels(a0)
                andi.w  #$F,d1
                addq.w  #1,d1
                lsl.w   #3,d1
                move.b  d1,height_pixels(a0)
                btst    #0,status(a0)
                beq.s   loc_1D26E
                move.l  #loc_1D2EA,(a0)
                rts
; ---------------------------------------------------------------------------

loc_1D26E:
                btst    #1,status(a0)
                beq.s   loc_1D27E
                move.l  #loc_1D34E,(a0)
                rts
; ---------------------------------------------------------------------------

loc_1D27E:
                move.l  #loc_1D284,(a0)

loc_1D284:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull2
                move.b  status(a0),d6
                andi.b  #standing_mask,d6
                beq.s   loc_1D2C8
                move.b  d6,d0
                andi.b  #p1_standing,d0
                beq.s   loc_1D2BA
                lea     (Player_1).w,a1
                bsr.w   sub_1D3B2

loc_1D2BA:
                andi.b  #p2_standing,d6
                beq.s   loc_1D2C8
                lea     (Player_2).w,a1
                bsr.w   sub_1D3B2

loc_1D2C8:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_1C778
                tst.w   (Debug_placement_mode).w
                beq.s   locret_1D2E8
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_1D2E8:
                rts
; ---------------------------------------------------------------------------

loc_1D2EA:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull2
                swap    d6
                andi.w  #3,d6
                beq.s   loc_1D32C
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   loc_1D31E
                lea     (Player_1).w,a1
                bsr.w   sub_1D3B2

loc_1D31E:
                andi.b  #2,d6
                beq.s   loc_1D32C
                lea     (Player_2).w,a1
                bsr.w   sub_1D3B2

loc_1D32C:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_1C778
                tst.w   (Debug_placement_mode).w
                beq.s   locret_1D34C
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_1D34C:
                rts
; ---------------------------------------------------------------------------

loc_1D34E:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull2
                swap    d6
                andi.w  #$C,d6
                beq.s   loc_1D390
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   loc_1D382
                lea     (Player_1).w,a1
                bsr.w   sub_1D3B2

loc_1D382:
                andi.b  #8,d6
                beq.s   loc_1D390
                lea     (Player_2).w,a1
                bsr.w   sub_1D3B2

loc_1D390:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_1C778
                tst.w   (Debug_placement_mode).w
                beq.s   locret_1D3B0
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_1D3B0:
                rts

; =============== S U B R O U T I N E =======================================

sub_1D3B2:
                move.w  d6,-(sp)
                move.l  a0,-(sp)
                movea.l a1,a0
                jsr     (Kill_Character).l
                movea.l (sp)+,a0
                move.w  (sp)+,d6
                rts
; End of function sub_1D3B2
