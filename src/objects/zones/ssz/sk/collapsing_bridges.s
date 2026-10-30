; Owner: objects/zones/ssz/sk
; Responsibility: Normal and diagonal collapsing bridge segment state and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SSZCollapsingBridge:
                move.l  #loc_44C76,(a0)
                bset    #2,render_flags(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$20,width_pixels(a0)
                move.w  #$180,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$20,2,1),art_tile(a0)
                move.l  #Map_SSZCollapsingBridge,mappings(a0)
                bset    #7,status(a0)

loc_44C76:
                moveq   #$20,d1
                moveq   #$10,d2
                moveq   #9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                tst.b   subtype(a0)
                bmi.s   loc_44C96
                move.b  status(a0),d0
                andi.w  #standing_mask,d0
                bne.s   loc_44C9C

loc_44C96:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_44C9C:
                lea     (Player_1).w,a1
                btst    #p1_standing_bit,d0
                bne.s   loc_44CAA
                lea     (Player_2).w,a1

loc_44CAA:
                moveq   #$18,d1
                moveq   #$10,d2
                move.w  #$102,d3
                move.w  x_pos(a0),d4
                cmp.w   x_pos(a1),d4
                scc     $2E(a0)
                bcs.s   loc_44CC6
                neg.w   d1
                neg.w   d2
                ror.w   #8,d3

loc_44CC6:
                add.w   d4,d1
                btst    #0,render_flags(a0)
                beq.s   loc_44CD2
                ror.w   #8,d3

loc_44CD2:
                moveq   #6,d4
                moveq   #4-1,d5
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_44D0E

loc_44CDE:
                move.l  #loc_45052,(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.w  d1,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  d3,mapping_frame(a1)
                move.w  d4,$2E(a1)
                sub.w   d2,d1
                ror.w   #8,d3
                addi.w  #6,d4
                jsr     (CreateNewSprite4).l
                dbne    d5,loc_44CDE

loc_44D0E:
                move.l  #loc_44D22,(a0)
                move.w  #6,$30(a0)
                move.w  #$20,$32(a0)
                rts
; ---------------------------------------------------------------------------

loc_44D22:
                subq.w  #1,$30(a0)
                bne.s   loc_44D48
                move.w  #6,$30(a0)
                subq.w  #8,$32(a0)
                bne.s   loc_44D3A
                move.w  #$7FFF,x_pos(a0)

loc_44D3A:
                moveq   #8,d0
                tst.b   $2E(a0)
                bne.s   loc_44D44
                neg.w   d0

loc_44D44:
                add.w   d0,x_pos(a0)

loc_44D48:
                move.w  $32(a0),d1
                moveq   #$10,d2
                moveq   #9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

Obj_SSZCollapsingBridgeDiagonal:
                move.l  #loc_44D98,(a0)
                ori.b   #$44,render_flags(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #$40,width_pixels(a0)
                move.w  #$180,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$20,2,1),art_tile(a0)
                move.l  #Map_SSZCollapsingBridge,mappings(a0)
                move.b  #3,mapping_frame(a0)
                bset    #7,status(a0)

loc_44D98:
                move.b  status(a0),d0
                move.w  d0,-(sp)
                moveq   #$40,d1
                lea     byte_46658(pc),a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped2).l
                move.w  (sp)+,d0
                btst    #p1_standing_bit,d0
                beq.s   loc_44DCE
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                beq.s   loc_44DCE
                tst.b   jumping(a1)
                bne.s   loc_44DCE
                bclr    #Status_InAir,status(a1)

loc_44DCE:
                btst    #p2_standing_bit,d0
                beq.s   loc_44DEC
                lea     (Player_2).w,a1
                btst    #Status_InAir,status(a1)
                beq.s   loc_44DEC
                tst.b   jumping(a1)
                bne.s   loc_44DEC
                bclr    #Status_InAir,status(a1)

loc_44DEC:
                tst.b   subtype(a0)
                bmi.s   loc_44DFC
                move.b  status(a0),d0
                andi.w  #standing_mask,d0
                bne.s   loc_44E02

loc_44DFC:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_44E02:
                lea     (Player_1).w,a1
                btst    #p1_standing_bit,d0
                bne.s   loc_44E10
                lea     (Player_2).w,a1

loc_44E10:
                moveq   #$38,d1
                moveq   #$10,d2
                move.w  #$405,d3
                moveq   #-8,d6
                move.w  x_pos(a0),d4
                cmp.w   x_pos(a1),d4
                scc     $2E(a0)
                bcs.s   loc_44E30
                neg.w   d1
                neg.w   d2
                ror.w   #8,d3
                neg.l   d6

loc_44E30:
                add.w   d4,d1
                btst    #0,render_flags(a0)
                beq.s   loc_44E3E
                ror.w   #8,d3
                neg.l   d6

loc_44E3E:
                tst.l   d6
                bmi.s   loc_44E44
                addq.l  #8,d6

loc_44E44:
                moveq   #6,d4
                moveq   #8-1,d5
                swap    d7
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_44E9C

loc_44E52:
                move.l  #loc_45052,(a1)
                move.b  render_flags(a0),d7
                andi.w  #$BF,d7
                move.b  d7,render_flags(a1)
                move.w  d1,x_pos(a1)
                move.w  y_pos(a0),d7
                add.w   d6,d7
                move.w  d7,y_pos(a1)
                move.b  d3,mapping_frame(a1)
                move.w  d4,object_control(a1)
                sub.w   d2,d1
                ror.w   #8,d3
                addi.w  #6,d4
                btst    #0,d5
                bne.s   loc_44E92
                tst.l   d6
                bmi.s   loc_44E90
                subq.w  #8,d6
                bra.s   loc_44E92
; ---------------------------------------------------------------------------

loc_44E90:
                addq.w  #8,d6

loc_44E92:
                jsr     (CreateNewSprite4).l
                dbne    d5,loc_44E52

loc_44E9C:
                swap    d7
                move.l  #loc_44EBA,(a0)
                move.w  #6,$30(a0)
                move.w  #$40,$32(a0)
                move.l  #byte_46658,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_44EBA:
                subq.w  #1,$30(a0)
                bne.s   loc_44EF6
                move.w  #6,$30(a0)
                addq.l  #4,$34(a0)
                subq.w  #8,$32(a0)
                bne.s   loc_44ED6
                move.w  #$7FFF,x_pos(a0)

loc_44ED6:
                moveq   #8,d0
                moveq   #2,d1
                tst.b   $2E(a0)
                bne.s   loc_44EE4
                neg.w   d0
                neg.w   d1

loc_44EE4:
                add.w   d0,x_pos(a0)
                btst    #0,render_flags(a0)
                beq.s   loc_44EF2
                neg.w   d1

loc_44EF2:
                sub.w   d1,y_pos(a0)

loc_44EF6:
                move.b  status(a0),d0
                move.w  d0,-(sp)
                move.w  $32(a0),d1
                movea.l $34(a0),a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped2).l
                move.w  (sp)+,d0
                btst    #p1_standing_bit,d0
                beq.s   loc_44F2E
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                beq.s   loc_44F2E
                tst.b   jumping(a1)
                bne.s   loc_44F2E
                bclr    #Status_InAir,status(a1)

loc_44F2E:
                btst    #p2_standing_bit,d0
                beq.s   loc_44F4C
                lea     (Player_2).w,a1
                btst    #Status_InAir,status(a1)
                beq.s   loc_44F4C
                tst.b   jumping(a1)
                bne.s   loc_44F4C
                bclr    #Status_InAir,status(a1)

loc_44F4C:
                jmp     (Delete_Sprite_If_Not_In_Range).l
