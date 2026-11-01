; Owner: objects/shared/sk
; Responsibility: Shared breakable cork floors, player contact, fracture response and zone mapping variants
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CorkFloor:
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.l  #Map_AIZCorkFloor,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.l  #word_2A8B0,$3C(a0)
                cmpi.w  #1,(Current_zone_and_act).w
                bne.s   loc_2A41A
                move.l  #Map_AIZCorkFloor2,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$2C,height_pixels(a0)

loc_2A41A:
                cmpi.b  #3,(Current_zone).w
                bne.s   loc_2A444
                move.l  #Map_CNZCorkFloor,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZPlatform,2,0),art_tile(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #word_2A8E0,$3C(a0)

loc_2A444:
                cmpi.b  #4,(Current_zone).w
                bne.s   loc_2A46E
                move.l  #Map_FBZCorkFloor,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc+$C1,1,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.l  #word_2A884,$3C(a0)

loc_2A46E:
                cmpi.b  #5,(Current_zone).w
                bne.s   loc_2A4C2
                move.l  #Map_ICZCorkFloor,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$24,height_pixels(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.b  #$F,d0
                move.b  d0,mapping_frame(a0)
                andi.b  #$10,d1
                bne.s   loc_2A4AE
                move.l  #loc_2A6D4,(a0)
                bra.w   loc_2A6D4
; ---------------------------------------------------------------------------

loc_2A4AE:
                move.l  #word_2A884,$3C(a0)
                move.w  #make_art_tile(ArtTile_ICZMisc1,2,0),art_tile(a0)
                move.b  #$10,height_pixels(a0)

loc_2A4C2:
                cmpi.b  #6,(Current_zone).w
                bne.s   loc_2A4EC
                move.l  #Map_LBZCorkFloor,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #word_2A8E0,$3C(a0)

loc_2A4EC:
                tst.b   subtype(a0)
                bne.s   loc_2A4FC
                move.l  #loc_2A618,(a0)
                bra.w   loc_2A618
; ---------------------------------------------------------------------------

loc_2A4FC:
                move.l  #loc_2A502,(a0)

loc_2A502:
                move.w  (Chain_bonus_counter).w,$38(a0)
                move.b  (Player_1+anim).w,$34(a0)
                move.b  (Player_2+anim).w,$36(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.b  status(a0),d0
                andi.w  #standing_mask,d0
                bne.s   loc_2A542

loc_2A53C:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_2A542:
                cmpi.b  #p1_standing|p2_standing,d0
                bne.s   loc_2A570
                cmpi.b  #2,$34(a0)
                beq.s   loc_2A558
                cmpi.b  #2,$36(a0)
                bne.s   loc_2A53C

loc_2A558:
                lea     (Player_1).w,a1
                move.b  $34(a0),d0
                bsr.s   ReleaseCorkRiderWithConditionalBounce
                lea     (Player_2).w,a1
                move.b  $36(a0),d0
                bsr.s   ReleaseCorkRiderWithConditionalBounce
                bra.w   loc_2A5D8
; ---------------------------------------------------------------------------

loc_2A570:
                move.b  d0,d1
                andi.b  #8,d1
                beq.s   loc_2A5C0
                cmpi.b  #2,$34(a0)
                bne.s   loc_2A53C
                lea     (Player_1).w,a1
                bsr.s   BouncePlayerFromBrokenCorkFloor
                bra.s   loc_2A5D8

; =============== S U B R O U T I N E =======================================

ReleaseCorkRiderWithConditionalBounce:
                cmpi.b  #2,d0
                bne.s   loc_2A5AC
; End of function ReleaseCorkRiderWithConditionalBounce

; =============== S U B R O U T I N E =======================================

BouncePlayerFromBrokenCorkFloor:
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.w  #-$300,y_vel(a1)

loc_2A5AC:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #2,routine(a1)
                rts
; End of function BouncePlayerFromBrokenCorkFloor

; ---------------------------------------------------------------------------

loc_2A5C0:
                andi.b  #$10,d0
                beq.w   loc_2A53C
                cmpi.b  #2,$36(a0)
                bne.w   loc_2A53C
                lea     (Player_2).w,a1
                bsr.s   BouncePlayerFromBrokenCorkFloor

loc_2A5D8:
                move.w  $38(a0),(Chain_bonus_counter).w
                andi.b  #$E7,status(a0)
                movea.l $3C(a0),a4
                addq.b  #1,mapping_frame(a0)
                move.l  #loc_2A5F8,(a0)
                jsr     (BreakObjectToPieces).l

loc_2A5F8:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.b   render_flags(a0)
                bpl.w   loc_2A612
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2A612:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2A618:
                move.w  (Player_1+y_vel).w,$30(a0)
                move.w  (Player_2+y_vel).w,$32(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                swap    d6
                andi.w  #4|8,d6
                bne.s   loc_2A650
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_2A650:
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   loc_2A674
                lea     (Player_1).w,a1
                move.w  $30(a0),y_vel(a1)
                andi.b  #8,d6
                beq.s   loc_2A68C
                lea     (Player_2).w,a1
                move.w  $32(a0),y_vel(a1)
                bra.s   loc_2A68C
; ---------------------------------------------------------------------------

loc_2A674:
                andi.b  #8,d6
                beq.s   loc_2A686
                lea     (Player_2).w,a1
                move.w  $32(a0),y_vel(a1)
                bra.s   loc_2A68C
; ---------------------------------------------------------------------------

loc_2A686:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_2A68C:
                btst    #p1_standing_bit,status(a0)
                beq.s   loc_2A6A4
                lea     (Player_1).w,a1
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)

loc_2A6A4:
                btst    #p2_standing_bit,status(a0)
                beq.s   loc_2A6BC
                lea     (Player_2).w,a1
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)

loc_2A6BC:
                movea.l $3C(a0),a4
                addq.b  #1,mapping_frame(a0)
                move.l  #loc_2A5F8,(a0)
                jsr     (BreakObjectToPieces).l
                bra.w   loc_2A5F8
; ---------------------------------------------------------------------------

loc_2A6D4:
                move.w  (Chain_bonus_counter).w,$38(a0)
                move.b  (Player_1+anim).w,$34(a0)
                move.b  (Player_2+anim).w,$36(a0)
                lea     (byte_2A894).l,a2
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  x_pos(a0),d4
                jsr     (CollidePlayersWithHeightProfileKeepAirState).l
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_2A716

loc_2A710:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_2A716:
                cmpi.b  #p1_standing|p2_standing,d0
                bne.s   loc_2A77A
                cmpi.b  #2,$34(a0)
                bne.s   loc_2A732
                tst.b   subtype(a0)
                bmi.s   loc_2A762
                cmpi.b  #$E,(Player_1+top_solid_bit).w
                beq.s   loc_2A762

loc_2A732:
                move.b  #$C,(Player_1+top_solid_bit).w
                move.b  #$D,(Player_1+lrb_solid_bit).w
                cmpi.b  #2,$36(a0)
                bne.s   loc_2A754
                tst.b   subtype(a0)
                bmi.s   loc_2A762
                cmpi.b  #$E,(Player_2+top_solid_bit).w
                beq.s   loc_2A762

loc_2A754:
                move.b  #$C,(Player_2+top_solid_bit).w
                move.b  #$D,(Player_2+lrb_solid_bit).w
                bra.s   loc_2A710
; ---------------------------------------------------------------------------

loc_2A762:
                lea     (Player_1).w,a1
                move.b  $34(a0),d0
                bsr.s   ReleaseIczCorkRiderWithConditionalRoll
                lea     (Player_2).w,a1
                move.b  $36(a0),d0
                bsr.s   ReleaseIczCorkRiderWithConditionalRoll
                bra.w   loc_2A816
; ---------------------------------------------------------------------------

loc_2A77A:
                move.b  d0,d1
                andi.b  #8,d1
                beq.s   loc_2A7E2
                cmpi.b  #2,$34(a0)
                bne.s   loc_2A798
                tst.b   subtype(a0)
                bmi.s   loc_2A7A8
                cmpi.b  #$E,(Player_1+top_solid_bit).w
                beq.s   loc_2A7A8

loc_2A798:
                move.b  #$C,(Player_1+top_solid_bit).w
                move.b  #$D,(Player_1+lrb_solid_bit).w
                bra.w   loc_2A710
; ---------------------------------------------------------------------------

loc_2A7A8:
                lea     (Player_1).w,a1
                bsr.s   ReleasePlayerFromIczCorkFloor
                bra.s   loc_2A816

; =============== S U B R O U T I N E =======================================

ReleaseIczCorkRiderWithConditionalRoll:
                cmpi.b  #2,d0
                bne.s   loc_2A7CE
; End of function ReleaseIczCorkRiderWithConditionalRoll

; =============== S U B R O U T I N E =======================================

ReleasePlayerFromIczCorkFloor:
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)

loc_2A7CE:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #2,routine(a1)
                rts
; End of function ReleasePlayerFromIczCorkFloor

; ---------------------------------------------------------------------------

loc_2A7E2:
                andi.b  #$10,d0
                beq.w   loc_2A710
                cmpi.b  #2,$36(a0)
                bne.s   loc_2A800
                tst.b   subtype(a0)
                bmi.s   loc_2A810
                cmpi.b  #$E,(Player_2+top_solid_bit).w
                beq.s   loc_2A810

loc_2A800:
                move.b  #$C,(Player_2+top_solid_bit).w
                move.b  #$D,(Player_2+lrb_solid_bit).w
                bra.w   loc_2A710
; ---------------------------------------------------------------------------

loc_2A810:
                lea     (Player_2).w,a1
                bsr.s   ReleasePlayerFromIczCorkFloor

loc_2A816:
                move.w  $38(a0),(Chain_bonus_counter).w
                andi.b  #$E7,status(a0)
                lea     (word_2A84C).l,a4
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                addq.b  #1,mapping_frame(a0)
                move.l  d0,d1
                add.w   d0,d0
                add.w   d0,d0
                lea     (a4,d0.w),a4
                move.l  #loc_2A5F8,(a0)
                jsr     (BreakObjectToPieces).l
                bra.w   loc_2A5F8
; ---------------------------------------------------------------------------
word_2A84C:
                dc.w    -$140, -$A00
                dc.w    $140, -$A00
                dc.w    -$120, -$900
                dc.w    $120, -$900
                dc.w    -$100, -$800
                dc.w    $100, -$800
                dc.w    -$E0, -$700
                dc.w    $E0, -$700
                dc.w    -$C0, -$600
                dc.w    $C0, -$600
                dc.w    -$A0, -$580
                dc.w    $A0, -$580
                dc.w    -$80, -$500
                dc.w    $80, -$500
word_2A884:
                dc.w    -$200, -$200
                dc.w    $200, -$200
                dc.w    -$100, -$100
                dc.w    $100, -$100
byte_2A894:
                dc.b    $23, $23
                dc.b    $22, $22
                dc.b    $21, $21
                dc.b    $20, $1F
                dc.b    $1F, $1E
                dc.b    $1E, $1D
                dc.b    $1D, $1C
                dc.b    $1B, $1B
                dc.b    $1A, $1A
                dc.b    $19, $19
                dc.b    $17, $16
                dc.b    $15, $15
                dc.b    $14, $14
                dc.b    $13, $13
word_2A8B0:
                dc.w    -$100, -$200
                dc.w    $100, -$200
                dc.w    -$E0, -$1C0
                dc.w    $E0, -$1C0
                dc.w    -$C0, -$180
                dc.w    $C0, -$180
                dc.w    -$A0, -$140
                dc.w    $A0, -$140
                dc.w    -$80, -$100
                dc.w    $80, -$100
                dc.w    -$60,  -$C0
                dc.w    $60,  -$C0
word_2A8E0:
                dc.w    -$400, -$400
                dc.w    -$200, -$400
                dc.w    $200, -$400
                dc.w    $400, -$400
                dc.w    -$3C0, -$3C0
                dc.w    -$1C0, -$3C0
                dc.w    $1C0, -$3C0
                dc.w    $3C0, -$3C0
                dc.w    -$380, -$380
                dc.w    -$180, -$380
                dc.w    $180, -$380
                dc.w    $380, -$380
                dc.w    -$340, -$340
                dc.w    -$140, -$340
                dc.w    $140, -$340
                dc.w    $340, -$340
