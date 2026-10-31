; Owner: objects/ending/sk
; Responsibility: Create ending or continue scene sprites, apply scene position, load Knuckles pose patterns and initialize child animation
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Create_Continue_Sprite:
                moveq   #0,d3

                .loop:
                jsr     (AllocateObject).l
                move.l  #loc_5EDAC,(a1)
                move.b  d1,subtype(a1)
                move.b  d3,$2D(a1)
                move.w  (a2,d3.w),x_pos(a1)
                move.w  2(a2,d3.w),y_pos(a1)
                addq.w  #4,d3
                dbf     d2,.loop
                rts
; End of function Create_Continue_Sprite

; =============== S U B R O U T I N E =======================================

sub_5FE48:
                bclr    #6,$38(a0)
                move.w  $3A(a0),d0
                sub.w   (_unkEE98).w,d0
                addi.w  #$80,d0
                move.w  d0,x_pos(a0)
                cmpi.w  #$200,d0
                bhs.s   loc_5FE7A
                move.w  $3C(a0),d0
                sub.w   (_unkEE9C).w,d0
                addi.w  #$80,d0
                move.w  d0,y_pos(a0)
                cmpi.w  #$200,d0
                blo.s   locret_5FE80

loc_5FE7A:
                bset    #6,$38(a0)

locret_5FE80:
                rts
; End of function sub_5FE48

; =============== S U B R O U T I N E =======================================

sub_5FE82:
                moveq   #0,d0
                lea     (_unkFA82).w,a1
                move.l  d0,(a1)+
                move.l  d0,(a1)+
                moveq   #2,d0
                cmpi.b  #7,(Super_emerald_count).w
                beq.s   loc_5FEA2
                moveq   #0,d0
                cmpi.b  #7,(Chaos_emerald_count).w
                beq.s   loc_5FEA2
                moveq   #-2,d0

loc_5FEA2:
                move.b  d0,(_unkFA88).w
                rts
; End of function sub_5FE82

; =============== S U B R O U T I N E =======================================

KnucklesEnding_Load_PLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   $3A(a0),d0
                beq.s   .end
                move.b  d0,$3A(a0)
                lea     (PLC_Knuckles).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   .end
                move.w  #tiles_to_bytes(ArtTile_Ending_Knuckles),d4
                move.l  #ArtUnc_Knux,d6

                .loop:
                moveq   #0,d1
                move.w  (a2)+,d1
                move.w  d1,d3
                lsr.w   #8,d3
                andi.w  #$F0,d3
                addi.w  #$10,d3
                andi.w  #$FFF,d1
                lsl.l   #5,d1
                add.l   d6,d1
                move.w  d4,d2
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                dbf     d5,.loop

                .end:
                rts
; End of function KnucklesEnding_Load_PLC

; =============== S U B R O U T I N E =======================================

sub_5FEFE:
                move.w  (Player_mode).w,d0
                andi.w  #3,d0
                add.w   d0,d0
                adda.w  d0,a1
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d0,x_pos(a0)
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d0,y_pos(a0)

locret_5FF1A:
                rts
; End of function sub_5FEFE

; =============== S U B R O U T I N E =======================================

sub_5FF1C:
                moveq   #0,d0
                move.b  subtype(a0),d0
                adda.w  d0,a1
                move.w  (a1)+,x_pos(a0)
                move.w  (a1)+,y_pos(a0)
                bclr    #2,render_flags(a0)
                lea     (Normal_palette_line_2).w,a1
                moveq   #0,d0
                moveq   #bytesToLcnt($20),d1

loc_5FF3A:
                move.l  d0,(a1)+
                dbf     d1,loc_5FF3A
                jsr     (AllocateObject).l
                bne.s   locret_5FF60
                move.l  #loc_5FF62,(a1)
                move.w  #Normal_palette_line_2,$30(a1)
                move.w  #Target_palette_line_2,$32(a1)
                move.w  #$F,$3A(a1)

locret_5FF60:
                rts
; End of function sub_5FF1C

; ---------------------------------------------------------------------------

loc_5FF62:
                move.b  #7,$39(a0)
                move.l  #loc_5FF6E,(a0)

loc_5FF6E:
                subq.w  #1,$2E(a0)
                bpl.s   locret_5FF92
                move.w  #3,$2E(a0)
                movea.w $30(a0),a1
                move.w  $3A(a0),d0

loc_5FF82:
                jsr     (sub_85EB4).l
                dbf     d0,loc_5FF82
                subq.b  #1,$39(a0)
                bmi.s   loc_5FF94

locret_5FF92:
                rts
; ---------------------------------------------------------------------------

loc_5FF94:
                move.l  #loc_5FFA6,(a0)
                move.b  #7,$39(a0)
                move.w  #3,$2E(a0)

loc_5FFA6:
                subq.w  #1,$2E(a0)
                bpl.s   locret_5FF92
                move.w  #3,$2E(a0)
                movea.w $30(a0),a1
                movea.w $32(a0),a2
                move.w  $3A(a0),d0

loc_5FFBE:
                jsr     (sub_85F2A).l
                dbf     d0,loc_5FFBE
                subq.b  #1,$39(a0)
                bpl.s   locret_5FF92
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_5FFD4:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     (a1,d0.w),a1
                movea.w parent3(a0),a2
                move.b  (a1)+,d0
                ext.w   d0
                move.w  x_pos(a2),d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.b  (a1)+,d0
                ext.w   d0
                move.w  y_pos(a2),d1
                add.w   d0,d1
                move.w  d1,y_pos(a0)
                rts
