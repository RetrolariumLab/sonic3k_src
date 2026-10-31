; Owner: objects/zones/mhz/sk
; Responsibility: Mushroom catapult activation, compression, player launch and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZMushroomCatapult:
                move.l  #Map_MHZMushroomCatapult,mappings(a0)
                move.w  #make_art_tile(ArtTile_MHZMisc+$86,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.w  y_pos(a0),$30(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_3F960
                move.l  #loc_3FA8E,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  x_pos(a0),$2E(a1)
                move.w  y_pos(a0),$30(a1)
                addi.w  #$40,x_pos(a1)
                tst.b   subtype(a0)
                beq.s   loc_3F8CE
                subi.w  #2*$40,x_pos(a1)

loc_3F8CE:
                subi.w  #$18,y_pos(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.w  priority(a0),priority(a1)
                move.b  #$20,width_pixels(a1)
                move.b  #$C,height_pixels(a1)
                move.w  a0,parent3(a1)
                move.w  #$18,$34(a1)
                move.w  a1,parent3(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_3F960
                move.l  #loc_3FAC2,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  x_pos(a0),$2E(a1)
                move.w  y_pos(a1),$30(a1)
                subi.w  #$14,y_pos(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  #make_art_tile(ArtTile_MHZMisc+$D9,1,0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.w  priority(a0),priority(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.b  #1,mapping_frame(a1)
                move.w  a0,parent3(a1)

loc_3F960:
                move.l  #loc_3F966,(a0)

loc_3F966:
                movea.w parent3(a0),a1
                bsr.s   sub_3F996
                move.w  $34(a0),d0
                neg.w   d0
                add.w   $30(a0),d0
                move.w  d0,y_pos(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                lea     (byte_3FB50).l,a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped2).l
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_3F996:
                move.w  $36(a0),d2
                tst.w   $32(a0)
                bne.s   loc_3F9E0
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_3F9C0
                moveq   #0,d2
                tst.w   $34(a0)
                beq.s   loc_3F9C0
                move.b  #1,$32(a0)
                move.w  #0,$36(a0)
                bra.s   loc_3F9E0
; ---------------------------------------------------------------------------

loc_3F9C0:
                move.b  status(a1),d0
                andi.b  #standing_mask,d0
                beq.s   loc_3F9E0
                moveq   #$18,d2
                cmpi.w  #$18,$34(a0)
                beq.s   loc_3F9E0
                move.b  #1,$33(a0)
                move.w  #$18,$36(a0)

loc_3F9E0:
                tst.w   d2
                bne.s   loc_3F9F0
                tst.w   $34(a0)
                beq.s   loc_3F9FE
                subq.w  #8,$34(a0)
                bra.s   locret_3F9FC
; ---------------------------------------------------------------------------

loc_3F9F0:
                cmpi.w  #$18,$34(a0)
                beq.s   loc_3FA42
                addq.w  #8,$34(a0)

locret_3F9FC:
                rts
; ---------------------------------------------------------------------------

loc_3F9FE:
                tst.b   $32(a0)
                beq.s   locret_3F9FC
                clr.w   $32(a0)
                move.b  status(a1),d0
                andi.b  #standing_mask,d0
                bne.s   loc_3FA18
                clr.w   $3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_3FA18:
                lea     (Player_1).w,a2
                moveq   #p1_standing_bit,d6
                bsr.s   sub_3FA26
                lea     (Player_2).w,a2
                moveq   #p2_standing_bit,d6
; End of function sub_3F996

; =============== S U B R O U T I N E =======================================

sub_3FA26:
                btst    d6,status(a1)
                beq.s   locret_3F9FC
                move.w  #-$E80,d1
                cmpi.w  #$900,$3A(a0)
                bhs.s   loc_3FA3C
                move.w  #-$D00,d1

loc_3FA3C:
                move.w  d1,y_vel(a2)
                bra.s   loc_3FA66
; End of function sub_3FA26

; ---------------------------------------------------------------------------

loc_3FA42:
                tst.b   $33(a0)
                beq.s   locret_3F9FC
                clr.w   $32(a0)
                lea     (Player_1).w,a2
                moveq   #p1_standing_bit,d6
                bsr.s   sub_3FA5A
                lea     (Player_2).w,a2
                moveq   #p2_standing_bit,d6

; =============== S U B R O U T I N E =======================================

sub_3FA5A:
                btst    d6,status(a0)
                beq.s   locret_3F9FC
                move.w  #-$D00,y_vel(a2)

loc_3FA66:
                bset    #Status_InAir,status(a2)
                bclr    #Status_OnObj,status(a2)
                clr.b   jumping(a2)
                clr.b   spin_dash_flag(a2)
                move.b  #$10,anim(a2)
                move.b  #2,routine(a2)
                moveq   #signextendB(sfx_MushroomBounce),d0
                jmp     (Play_SFX).l
; End of function sub_3FA5A

; ---------------------------------------------------------------------------

loc_3FA8E:
                movea.w parent3(a0),a1
                move.w  $34(a1),d0
                subi.w  #$18,d0
                add.w   $30(a0),d0
                move.w  d0,y_pos(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                lea     (byte_3FB50).l,a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped2).l
                move.w  $2E(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

loc_3FAC2:
                movea.w parent3(a0),a1
                move.w  $34(a1),d0
                neg.w   d0
                add.w   $30(a0),d0
                subi.w  #$14,d0
                move.w  d0,y_pos(a0)
                cmpi.w  #$18,$34(a1)
                bne.s   loc_3FB06
                move.l  #loc_3FB0C,(a0)
                moveq   #signextendB(sfx_Flipper),d0
                jsr     (Play_SFX).l
                move.w  #$18,$36(a1)
                move.w  #-$800,y_vel(a0)
                tst.w   $3A(a1)
                beq.s   loc_3FB06
                move.w  #-$A00,y_vel(a0)

loc_3FB06:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_3FB0C:
                jsr     (MoveSprite).l
                movea.w parent3(a0),a1
                move.w  $34(a1),d0
                neg.w   d0
                add.w   $30(a0),d0
                subi.w  #$14,d0
                cmp.w   y_pos(a0),d0
                bhi.s   loc_3FB4A
                move.w  d0,y_pos(a0)
                move.l  #loc_3FAC2,(a0)
                move.w  #0,$36(a1)
                move.b  #1,$32(a1)
                move.w  y_vel(a0),$3A(a1)
                clr.w   y_vel(a0)

loc_3FB4A:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
byte_3FB50:
                dc.b    4,   5,   6,   7,   8,   9,  $A,  $B,  $B,  $C,  $C,  $C,  $C,  $C,  $C,  $C,  $C,  $C,  $C,  $C
                dc.b    $C,  $C,  $C,  $B,  $B,  $A,   9,   8,   7,   6,   5,   4
                even
Map_MHZMushroomCatapult:
                include "src/objects/shared/zones/mhz/mappings/mushroom_catapult.s"
