; Owner: objects/zones/soz/sk
; Responsibility: Pushable rock collision, player pushing, movement and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SOZPushableRock:
                move.l  #Map_SOZPushableRock,mappings(a0)
                move.w  #make_art_tile(ArtTile_SOZMisc+$8C,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.b  #$B,y_radius(a0)
                move.w  #$280,priority(a0)

Load_SOZ_Pushable_Rock_Track_Ride_Info:
                lea     (SOZRockRideInfo).l,a1
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.w  #$1F,d0
                add.w   d0,d0
                add.w   d0,d0
                movea.l (a1,d0.w),a1
                move.w  (a1)+,$3A(a0)
                move.l  a1,$36(a0)
                tst.b   subtype(a0)
                bpl.s   loc_405A4
                move.w  a0,(_unkF7C4).w
                move.l  #loc_405D6,(a0)
                bra.s   loc_405D6
; ---------------------------------------------------------------------------

loc_405A4:
                move.l  #loc_405AA,(a0)

loc_405AA:
                move.b  (Player_1+status).w,$30(a0)
                move.b  (Player_2+status).w,$31(a0)
                move.w  #$1B,d1
                move.w  #$C,d2
                move.w  #$D,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                bsr.w   sub_406B4
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_405D6:
                bra.s   loc_405AA
; ---------------------------------------------------------------------------

loc_405D8:
                move.w  x_pos(a0),-(sp)
                jsr     (MoveSprite).l
                move.w  (sp)+,d4
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$120,d0
                cmp.w   y_pos(a0),d0
                bgt.s   loc_405FA
                move.w  #$7F00,d4
                move.w  d4,x_pos(a0)

loc_405FA:
                move.w  $3A(a0),d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_4063C
                move.w  d0,y_pos(a0)
                move.w  #0,y_vel(a0)
                movea.l $36(a0),a1
                move.w  (a1)+,d0
                bpl.s   loc_4061E
                move.l  #loc_406AE,(a0)
                bra.s   loc_4063C
; ---------------------------------------------------------------------------

loc_4061E:
                move.w  d0,$3A(a0)
                move.l  a1,$36(a0)
                move.l  #loc_40654,(a0)
                move.w  #$100,x_vel(a0)
                cmp.w   x_pos(a0),d0
                bhs.s   loc_4063C
                neg.w   x_vel(a0)

loc_4063C:
                move.w  #$1B,d1
                move.w  #$C,d2
                move.w  #$D,d3
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_40654:
                move.w  x_pos(a0),-(sp)
                jsr     (MoveSprite2).l
                move.w  (sp)+,d4
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$1F,d0
                bne.s   loc_40672
                moveq   #signextendB(sfx_BlockConveyor),d0
                jsr     (Play_SFX).l

loc_40672:
                tst.w   x_vel(a0)
                bmi.s   loc_40684
                move.w  $3A(a0),d0
                cmp.w   x_pos(a0),d0
                bhi.s   loc_406AC
                bra.s   loc_4068E
; ---------------------------------------------------------------------------

loc_40684:
                move.w  $3A(a0),d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_406AC

loc_4068E:
                movea.l $36(a0),a1
                move.w  (a1)+,d0
                bpl.s   loc_4069E
                move.l  #loc_406AE,(a0)
                bra.s   loc_4063C
; ---------------------------------------------------------------------------

loc_4069E:
                move.w  d0,$3A(a0)
                move.l  a1,$36(a0)
                move.l  #loc_405D8,(a0)

loc_406AC:
                bra.s   loc_4063C
; ---------------------------------------------------------------------------

loc_406AE:
                move.w  x_pos(a0),d4
                bra.s   loc_4063C

; =============== S U B R O U T I N E =======================================

sub_406B4:
                moveq   #0,d5
                move.b  status(a0),d3
                andi.b  #pushing_mask,d3
                beq.w   locret_406E2
                move.w  x_pos(a0),d2
                lea     (Player_1).w,a1
                move.b  $30(a0),d0
                moveq   #p1_pushing_bit,d6
                bsr.s   sub_406E4
                tst.w   d5
                bne.s   locret_406E2
                lea     (Player_2).w,a1
                move.b  $31(a0),d0
                moveq   #p2_pushing_bit,d6
                bsr.s   sub_406E4

locret_406E2:
                rts
; End of function sub_406B4

; =============== S U B R O U T I N E =======================================

sub_406E4:
                btst    d6,d3
                beq.s   locret_4075C
                cmp.w   x_pos(a1),d2
                bhs.s   loc_40726
                btst    #5,d0
                beq.s   locret_4075C
                subq.w  #1,$32(a0)
                bpl.s   loc_40722
                move.w  #4,$32(a0)
                subq.w  #1,x_pos(a0)
                subq.w  #1,x_pos(a1)
                bsr.s   sub_4076E
                move.w  x_pos(a0),d3
                addi.w  #$10,d3
                jsr     (ObjCheckFloorDist2).l
                cmpi.w  #$E,d1
                bgt.s   loc_4075E
                add.w   d1,y_pos(a0)

loc_40722:
                moveq   #1,d5
                rts
; ---------------------------------------------------------------------------

loc_40726:
                btst    #5,d0
                beq.s   locret_4075C
                subq.w  #1,$32(a0)
                bpl.s   loc_40722
                move.w  #4,$32(a0)
                addq.w  #1,x_pos(a0)
                addq.w  #1,x_pos(a1)
                bsr.s   sub_4076E
                move.w  x_pos(a0),d3
                subi.w  #$10,d3
                jsr     (ObjCheckFloorDist2).l
                cmpi.w  #$E,d1
                bgt.s   loc_4075E
                add.w   d1,y_pos(a0)
                moveq   #1,d5

locret_4075C:
                rts
; ---------------------------------------------------------------------------

loc_4075E:
                bset    #1,status(a0)
                move.l  #loc_405D8,(a0)
                moveq   #1,d5
                rts
; End of function sub_406E4

; =============== S U B R O U T I N E =======================================

sub_4076E:
                moveq   #signextendB(sfx_PushBlock),d0
                jmp     (Play_SFX).l
; End of function sub_4076E

; ---------------------------------------------------------------------------
Map_SOZPushableRock:
                include "src/objects/shared/zones/soz/mappings/pushable_rock.s"
