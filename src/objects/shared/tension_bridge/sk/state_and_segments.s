; Owner: objects/shared/tension_bridge/sk
; Responsibility: Tension bridge initialization, coordinated segments, player state and active control
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_TensionBridge:
                move.l  #loc_387E0,(a0)
                move.l  #Map_TensionBridge,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZ2BlockPlat+$10,2,0),art_tile(a0)
                move.w  #$200,priority(a0)
                cmpi.b  #5,(Current_zone).w
                bne.s   loc_386D0
                move.l  #loc_38882,(a0)
                move.l  #Map_ICZTensionBridge,mappings(a0)
                move.w  #make_art_tile(ArtTile_ICZMisc1,2,0),art_tile(a0)
                tst.b   subtype(a0)
                bpl.s   loc_386D0
                move.l  #loc_38946,(a0)
                andi.b  #$7F,subtype(a0)

loc_386D0:
                cmpi.b  #9,(Current_zone).w
                bne.s   loc_386DE
                move.w  #make_art_tile($113,3,1),art_tile(a0)

loc_386DE:
                tst.b   subtype(a0)
                bpl.s   loc_386F0
                move.l  #loc_387B6,(a0)
                andi.b  #$7F,subtype(a0)

loc_386F0:
                move.b  #4,render_flags(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  y_pos(a0),d2
                move.w  d2,$3C(a0)
                move.w  x_pos(a0),d3
                lea     subtype(a0),a2
                moveq   #0,d1
                move.b  (a2),d1
                move.w  d1,d0
                lsr.w   #1,d0
                lsl.w   #4,d0
                sub.w   d0,d3
                swap    d1
                move.w  #8,d1
                bsr.s   sub_38756
                move.w  $30(a1),d0
                subq.w  #8,d0
                move.w  d0,x_pos(a1)
                move.l  a1,$30(a0)
                swap    d1
                subq.w  #8,d1
                bls.s   loc_38752
                move.w  d1,d4
                bsr.s   sub_38756
                move.l  a1,$34(a0)
                move.w  d4,d0
                add.w   d0,d0
                add.w   d4,d0
                move.w  sub2_x_pos(a1,d0.w),d0
                subq.w  #8,d0
                move.w  d0,x_pos(a1)

loc_38752:
                bra.w   loc_387E0

; =============== S U B R O U T I N E =======================================

sub_38756:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_387B4
                move.l  #loc_3887C,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.w  priority(a0),priority(a1)
                bset    #6,render_flags(a1)
                move.b  #$40,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.w  d1,mainspr_childsprites(a1)
                subq.b  #1,d1
                lea     sub2_x_pos(a1),a2

loc_387A4:
                move.w  d3,(a2)+
                move.w  d2,(a2)+
                move.w  #0,(a2)+
                addi.w  #$10,d3
                dbf     d1,loc_387A4

locret_387B4:
                rts
; End of function sub_38756

; ---------------------------------------------------------------------------

loc_387B6:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                tst.b   (a3)
                beq.s   loc_387E0
                move.l  #loc_3890C,(a0)
                move.b  #$E,$34(a0)
                move.l  #loc_388E4,d4
                bra.w   loc_389C8
; ---------------------------------------------------------------------------

loc_387E0:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_387F6
                tst.b   $3E(a0)
                beq.s   loc_38822
                subq.b  #4,$3E(a0)
                bra.s   loc_3881E
; ---------------------------------------------------------------------------

loc_387F6:
                andi.b  #$10,d0
                beq.s   loc_38812
                move.b  $3F(a0),d0
                sub.b   $3B(a0),d0
                beq.s   loc_38812
                bcc.s   loc_3880E
                addq.b  #1,$3F(a0)
                bra.s   loc_38812
; ---------------------------------------------------------------------------

loc_3880E:
                subq.b  #1,$3F(a0)

loc_38812:
                cmpi.b  #$40,$3E(a0)
                beq.s   loc_3881E
                addq.b  #4,$3E(a0)

loc_3881E:
                bsr.w   sub_38CC2

loc_38822:
                moveq   #0,d1
                move.b  subtype(a0),d1
                lsl.w   #3,d1
                move.w  d1,d2
                addq.w  #8,d1
                add.w   d2,d2
                moveq   #8,d3
                move.w  x_pos(a0),d4
                bsr.w   sub_38A88

loc_3883A:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_3884E
                rts
; ---------------------------------------------------------------------------

loc_3884E:
                movea.l $30(a0),a1
                jsr     (Delete_Referenced_Sprite).l
                cmpi.b  #8,subtype(a0)
                bls.s   loc_3886A
                movea.l $34(a0),a1
                jsr     (Delete_Referenced_Sprite).l

loc_3886A:
                move.w  respawn_addr(a0),d0
                beq.s   loc_38876
                movea.w d0,a2
                bclr    #7,(a2)

loc_38876:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3887C:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_38882:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_38898
                tst.b   $3E(a0)
                beq.s   loc_388C4
                subq.b  #4,$3E(a0)
                bra.s   loc_388C0
; ---------------------------------------------------------------------------

loc_38898:
                andi.b  #p2_standing,d0
                beq.s   loc_388B4
                move.b  $3F(a0),d0
                sub.b   $3B(a0),d0
                beq.s   loc_388B4
                bcc.s   loc_388B0
                addq.b  #1,$3F(a0)
                bra.s   loc_388B4
; ---------------------------------------------------------------------------

loc_388B0:
                subq.b  #1,$3F(a0)

loc_388B4:
                cmpi.b  #$40,$3E(a0)
                beq.s   loc_388C0
                addq.b  #4,$3E(a0)

loc_388C0:
                bsr.w   sub_38CC2

loc_388C4:
                moveq   #0,d1
                move.b  subtype(a0),d1
                lsl.w   #3,d1
                move.w  d1,d2
                addq.w  #8,d1
                add.w   d2,d2
                moveq   #8,d3
                move.w  x_pos(a0),d4
                bsr.w   sub_38A88
                bsr.w   sub_38C12
                bra.w   loc_3883A
; ---------------------------------------------------------------------------

loc_388E4:
                tst.b   $34(a0)
                beq.s   loc_388F4
                subq.b  #1,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_388F4:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bpl.s   loc_38906
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_38906:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3890C:
                tst.b   $34(a0)
                beq.s   loc_38918
                subq.b  #1,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_38918:
                bclr    #p1_standing_bit,status(a0)
                beq.s   loc_3892C
                bclr    #Status_OnObj,(Player_1+status).w
                bset    #Status_InAir,(Player_1+status).w

loc_3892C:
                bclr    #p2_standing_bit,status(a0)
                beq.s   loc_38940
                bclr    #Status_OnObj,(Player_2+status).w
                bset    #Status_InAir,(Player_2+status).w

loc_38940:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_38946:
                bsr.w   sub_38D74
                move.l  #loc_38950,(a0)

loc_38950:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_38966
                tst.b   $3E(a0)
                beq.s   loc_389A8
                subq.b  #4,$3E(a0)
                bra.s   loc_389A4
; ---------------------------------------------------------------------------

loc_38966:
                moveq   #0,d1
                move.b  subtype(a0),d1
                lsl.w   #3,d1
                move.w  d1,d2
                addq.w  #8,d1
                add.w   d2,d2
                bsr.w   sub_38BD8
                move.b  status(a0),d0
                andi.b  #p2_standing,d0
                beq.s   loc_38998
                move.b  $3F(a0),d0
                sub.b   $3B(a0),d0
                beq.s   loc_38998
                bcc.s   loc_38994
                addq.b  #1,$3F(a0)
                bra.s   loc_38998
; ---------------------------------------------------------------------------

loc_38994:
                subq.b  #1,$3F(a0)

loc_38998:
                cmpi.b  #$40,$3E(a0)
                beq.s   loc_389A4
                addq.b  #4,$3E(a0)

loc_389A4:
                bsr.w   sub_38D74

loc_389A8:
                moveq   #0,d1
                move.b  subtype(a0),d1
                lsl.w   #3,d1
                move.w  d1,d2
                addq.w  #8,d1
                add.w   d2,d2
                moveq   #8,d3
                move.w  x_pos(a0),d4
                bsr.w   sub_38B2A
                bsr.w   sub_38C12
                bra.w   loc_3883A
; ---------------------------------------------------------------------------

loc_389C8:
                movea.l $30(a0),a3
                bsr.s   sub_389DE
                cmpi.b  #8,subtype(a0)
                bls.s   locret_389DC
                movea.l $34(a0),a3
                bsr.s   sub_389DE

locret_389DC:
                rts
