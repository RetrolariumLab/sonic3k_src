; Owner: objects/zones/ssz/sk
; Responsibility: Bouncy cloud contact, deformation, player response and movement
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SSZBouncyCloud:
                move.l  #loc_450EC,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$20,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$102,3,1),art_tile(a0)
                move.l  #Map_SSZBouncyCloud,mappings(a0)
                clr.b   $2D(a0)
                move.w  y_pos(a0),y_vel(a0)
                jsr     (Random_Number).l
                andi.w  #$FFF,d0
                addi.w  #$C00,d0
                move.w  d0,$30(a0)

loc_450EC:
                move.l  #$1C00,d0
                move.l  #$80,d1
                jsr     Gradual_SwingOffset(pc)
                add.w   $1A(a0),d0
                move.b  $3E(a0),d1
                move.b  $46(a0),d2
                move.b  d1,d3
                or.b    d2,d3
                beq.s   loc_4511A
                cmp.b   d2,d1
                bhs.s   loc_45114
                exg     d1,d2

loc_45114:
                ext.w   d1
                add.w   d1,d0
                bra.s   loc_45134
; ---------------------------------------------------------------------------

loc_4511A:
                move.b  $39(a0),d1
                move.b  $3F(a0),d2
                move.b  $41(a0),d3
                move.b  $47(a0),d4
                cmp.b   d3,d1
                bhs.s   loc_45130
                exg     d2,d4

loc_45130:
                ext.w   d2
                add.w   d2,d0

loc_45134:
                move.w  d0,y_pos(a0)
                tst.b   routine(a0)
                beq.s   loc_45142
                subq.b  #1,routine(a0)

loc_45142:
                move.b  $2D(a0),anim(a0)
                lea     (Player_1).w,a1
                lea     $38(a0),a2
                moveq   #p1_standing_bit,d6
                bsr.s   SSZCloud_UpdateBounceAndSpin
                lea     (Player_2).w,a1
                lea     $40(a0),a2
                moveq   #p2_standing_bit,d6
                bsr.s   SSZCloud_UpdateBounceAndSpin
                lea     Ani_SSZBouncyCloud(pc),a1
                jsr     (Animate_Sprite).l
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

; Top contact starts the synchronized compression delay. After launch, track angle and recoil
SSZCloud_UpdateBounceAndSpin:
                moveq   #$20,d1
                moveq   #$10,d2
                moveq   #0,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop_1P).l
                tst.b   (a2)
                bne.s   loc_451C2
                btst    d6,status(a0)
                beq.s   locret_451C0
                move.w  x_vel(a1),2(a2)
                move.w  ground_vel(a1),4(a2)
                clr.w   x_vel(a1)
                clr.w   ground_vel(a1)
                move.b  #1,anim(a0)
                move.b  #1,flip_type(a0)
                move.b  routine(a0),d0
                bne.s   loc_451B6
                moveq   #7,d0
                move.b  d0,routine(a0)

loc_451B6:
                move.b  d0,(a2)
                move.b  (byte_4669F).l,6(a2)

locret_451C0:
                rts
; ---------------------------------------------------------------------------

loc_451C2:
                bmi.w   loc_4527A
                subq.b  #1,(a2)
                beq.s   loc_451DC
                move.b  (a2),d0
                ext.w   d0
                lea     byte_46698(pc),a3
                move.b  (a3,d0.w),6(a2)
                bra.w   locret_45278
; ---------------------------------------------------------------------------

loc_451DC:
                moveq   #signextendB(sfx_Bouncy),d0
                jsr     (Play_SFX).l
                move.w  2(a2),x_vel(a1)
                move.w  4(a2),ground_vel(a1)
                move.w  #-$700,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                move.b  #2,routine(a1)
                clr.b   anim(a1)
                st      (a2)
                moveq   #-$1C,d0
                btst    #0,status(a1)
                bne.s   loc_45226
                neg.w   d0
                bclr    #0,(a2)

loc_45226:
                move.b  d0,angle(a1)
                clr.b   $2D(a0)
                clr.b   6(a2)
                move.b  #$26,1(a2)
                lea     word_466C8(pc),a3
                move.w  x_pos(a1),d1
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_45278
                moveq   #4-1,d2

loc_4524A:
                move.l  #loc_452DA,(a1)
                move.w  a0,$2E(a1)
                move.w  (a3)+,d3
                add.w   d1,d3
                move.w  d3,x_pos(a1)
                move.w  (a3)+,d3
                add.w   y_pos(a0),d3
                move.w  d3,y_pos(a1)
                move.w  (a3)+,x_vel(a1)
                move.w  (a3)+,y_vel(a1)
                jsr     (CreateNewSprite4).l
                dbne    d2,loc_4524A

locret_45278:
                rts
; ---------------------------------------------------------------------------

loc_4527A:
                tst.b   $2E(a1)
                bne.s   loc_452D6
                move.b  status(a1),d0
                btst    #1,d0
                beq.s   loc_452D6
                andi.w  #$28,d0
                bne.s   loc_452D6
                move.b  1(a2),d0
                ext.w   d0
                lea     byte_466A0(pc),a3
                move.b  (a3,d0.w),7(a2)
                subq.b  #1,d0
                bmi.s   loc_452A8
                move.b  d0,1(a2)

loc_452A8:
                move.b  angle(a1),d0
                move.l  #$60002,d1
                btst    #0,(a2)
                bne.s   loc_452C4
                tst.b   d0
                bmi.s   loc_452BE
                swap    d1

loc_452BE:
                add.b   d1,d0
                bcc.s   loc_452D0
                bra.s   loc_452CE
; ---------------------------------------------------------------------------

loc_452C4:
                tst.b   d0
                bpl.s   loc_452CA
                swap    d1

loc_452CA:
                sub.b   d1,d0
                bcc.s   loc_452D0

loc_452CE:
                moveq   #0,d0

loc_452D0:
                move.b  d0,angle(a1)
                bne.s   locret_452D8

loc_452D6:
                clr.b   (a2)

locret_452D8:
                rts
; End of function SSZCloud_UpdateBounceAndSpin

; ---------------------------------------------------------------------------

loc_452DA:
                movea.w $2E(a0),a1
                move.w  x_pos(a1),d0
                tst.w   x_vel(a0)
                bpl.s   loc_452F4
                subi.w  #$18,d0
                cmp.w   x_pos(a0),d0
                bls.s   loc_45304
                bra.s   loc_452FE
; ---------------------------------------------------------------------------

loc_452F4:
                addi.w  #$18,d0
                cmp.w   x_pos(a0),d0
                bhs.s   loc_45304

loc_452FE:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_45304:
                move.l  #loc_45336,(a0)
                move.b  #4,render_flags(a0)
                move.b  #4,height_pixels(a0)
                move.b  #4,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$102,3,1),art_tile(a0)
                move.l  #Map_SSZBouncyCloud,mappings(a0)
                move.b  #2,anim(a0)

loc_45336:
                lea     Ani_SSZBouncyCloud(pc),a1
                jsr     (Animate_SpriteIrregularDelay).l
                tst.b   routine(a0)
                beq.s   loc_4534C
                move.l  #Delete_Current_Sprite,(a0)

loc_4534C:
                jsr     (MoveSprite2).l
                lea     x_vel(a0),a1
                bsr.s   DampSszCloudParticleVelocity
                lea     y_vel(a0),a1
                bsr.s   DampSszCloudParticleVelocity
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

DampSszCloudParticleVelocity:
                move.w  (a1),d0
                asr.w   #2,d0
                sub.w   d0,(a1)
                rts
; End of function DampSszCloudParticleVelocity
