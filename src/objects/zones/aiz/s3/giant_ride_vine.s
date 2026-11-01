; Owner: objects/zones/aiz/s3
; Responsibility: Giant Angel Island ride-vine motion, player positioning and shared vine mapping storage
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZGiantRideVine:
                movea.l a0,a1
                move.l  #loc_2082C,(a1)
                bsr.w   InitializeAizGiantVineSprite
                move.b  #$21,mapping_frame(a1)
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                move.b  subtype(a0),d1
                andi.w  #$F,d1
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_20802
                move.w  #-$1B0,$44(a1)
                move.w  #$800,$38(a1)
                move.w  a1,$3E(a0)
                move.l  #loc_20874,(a1)
                move.w  a0,$3C(a1)
                move.b  subtype(a0),d0
                andi.b  #$F0,d0
                move.b  d0,$42(a1)
                bra.s   loc_207D4
; ---------------------------------------------------------------------------

loc_207BC:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_20802
                move.l  #loc_20908,(a1)
                move.w  a2,$3C(a1)
                move.w  a1,$3E(a2)

loc_207D4:
                movea.l a1,a2
                bsr.s   InitializeAizGiantVineSprite
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                addi.w  #$10,d3
                addq.w  #1,$36(a0)
                move.w  $36(a0),$36(a1)
                dbf     d1,loc_207BC
                move.l  #loc_20968,(a1)
                move.b  #$20,mapping_frame(a1)
                move.w  a1,$40(a0)

loc_20802:
                bra.s   loc_2082C

; =============== S U B R O U T I N E =======================================

InitializeAizGiantVineSprite:
                move.b  #4,render_flags(a1)
                move.b  #8,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.w  #$200,priority(a1)
                move.l  #Map_AIZRideVine,mappings(a1)
                move.w  #make_art_tile(ArtTile_AIZSwingVine,0,0),art_tile(a1)
                rts
; End of function InitializeAizGiantVineSprite

; ---------------------------------------------------------------------------

loc_2082C:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_20846
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_20846:
                move.w  $36(a0),d2
                subq.w  #1,d2
                bcs.s   loc_20862
                movea.w $3E(a0),a2

loc_20852:
                movea.l a2,a1
                movea.w $3E(a1),a2
                jsr     (Delete_Referenced_Sprite).l
                dbf     d2,loc_20852

loc_20862:
                move.w  respawn_addr(a0),d0
                beq.s   loc_2086E
                movea.w d0,a2
                bclr    #7,(a2)

loc_2086E:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_20874:
                tst.b   (a0)
                bne.s   loc_208A6
                move.b  (AIZ_vine_angle).w,d0
                add.b   $42(a0),d0
                jsr     (GetSineCosine).l
                muls.w  #$2C,d0
                move.w  d0,angle(a0)
                asr.w   #3,d0
                move.w  d0,$3A(a0)
                move.b  angle(a0),d0
                addq.b  #4,d0
                lsr.b   #3,d0
                move.b  d0,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_208A6:
                moveq   #0,d2
                move.b  $38(a0),d2
                move.w  $44(a0),d0
                move.w  #0,d1
                tst.w   $2E(a0)
                bne.s   loc_208D2
                add.w   d2,d0
                move.w  d0,$44(a0)
                add.w   d0,$42(a0)
                cmp.b   $42(a0),d1
                bgt.s   loc_208E8
                move.w  #1,$2E(a0)
                bra.s   loc_208E8
; ---------------------------------------------------------------------------

loc_208D2:
                sub.w   d2,d0
                move.w  d0,$44(a0)
                add.w   d0,$42(a0)
                cmp.b   $42(a0),d1
                ble.s   loc_208E8
                move.w  #0,$2E(a0)

loc_208E8:
                move.w  $42(a0),d0
                move.w  d0,angle(a0)
                asr.w   #3,d0
                move.w  d0,$3A(a0)
                move.b  angle(a0),d0
                addq.b  #4,d0
                lsr.b   #3,d0
                move.b  d0,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_20908:
                movea.w $3C(a0),a1
                move.w  $3A(a1),$3A(a0)
                move.w  angle(a1),d0
                add.w   $3A(a0),d0
                move.w  d0,angle(a0)
                move.b  angle(a0),d0
                addq.b  #4,d0
                lsr.b   #3,d0
                move.b  d0,mapping_frame(a0)
                bsr.w   PositionAizGiantVineLink
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

PositionAizGiantVineLink:
                movea.w $3C(a0),a1
                move.b  angle(a1),d0
                addq.b  #4,d0
                andi.b  #$F8,d0
                jsr     (GetSineCosine).l
                neg.w   d0
                addi.w  #8,d0
                addi.w  #8,d1
                asr.w   #4,d0
                asr.w   #4,d1
                add.w   x_pos(a1),d0
                move.w  d0,x_pos(a0)
                add.w   y_pos(a1),d1
                move.w  d1,y_pos(a0)
                rts
; End of function PositionAizGiantVineLink

; ---------------------------------------------------------------------------

loc_20968:
                move.w  x_pos(a0),d4
                move.w  y_pos(a0),d5
                bsr.w   PositionAizGiantVineLink
                cmp.w   x_pos(a0),d4
                beq.s   loc_2097E
                move.w  d4,$42(a0)

loc_2097E:
                cmp.w   y_pos(a0),d5
                beq.s   loc_20988
                move.w  d5,$44(a0)

loc_20988:
                lea     $32(a0),a2
                lea     (Player_1).w,a1
                move.w  (Ctrl_1_logical).w,d0
                bsr.w   UpdatePlayerOnAizVineHandle
                lea     (Player_2).w,a1
                addq.w  #1,a2
                move.w  (Ctrl_2_logical).w,d0
                bsr.w   UpdatePlayerOnAizVineHandle
                tst.w   $32(a0)
                beq.s   loc_209B2
                tst.w   $30(a0)
                bne.s   locret_209B8

loc_209B2:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_209B8:
                rts
; ---------------------------------------------------------------------------
Map_AIZRideVine:
                include "src/objects/shared/zones/aiz/mappings/ride_vine_s3.s"
