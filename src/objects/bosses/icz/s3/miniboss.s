; Owner: objects/bosses/icz/s3
; Responsibility: IceCap miniboss lifecycle, attacks, child actors, helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZMiniboss:
                cmpi.w  #$501,(Apparent_zone_and_act).w
                beq.s   loc_4E3E6
                lea     word_4E3EC(pc),a1
                jsr     (Check_CameraInRange).l
                move.l  #loc_4E3F4,(a0)
                move.b  #1,(Boss_flag).w
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #2*60,$2E(a0)
                move.b  #mus_Miniboss,$26(a0)
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  (Camera_target_max_Y_pos).w,(Camera_stored_max_Y_pos).w
                move.w  #$2B8,(Camera_target_max_Y_pos).w
                move.w  #$6F0,$1C(a0)
                move.w  #$6F0,(Camera_max_X_pos).w
                move.l  #loc_4E3FA,$34(a0)
                moveq   #PLCID_5F,d0
                jsr     (Load_PLC).l
                lea     Pal_ICZMiniboss(pc),a1
                jmp     PalLoad_Line1(pc)
; ---------------------------------------------------------------------------

loc_4E3E6:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
word_4E3EC:
                dc.w    0,  $380,  $690,  $6F0
; ---------------------------------------------------------------------------

loc_4E3F4:
                jmp     (loc_541C8).l
; ---------------------------------------------------------------------------

loc_4E3FA:
                move.l  #loc_4E402,(a0)

locret_4E400:
                rts
; ---------------------------------------------------------------------------

loc_4E402:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4E418(pc,d0.w),d1
                jsr     off_4E418(pc,d1.w)
                bsr.w   sub_4EAC2
                jmp     Draw_And_Touch_Sprite(pc)
; ---------------------------------------------------------------------------
off_4E418:
                dc.w    loc_4E42E-off_4E418
                dc.w    loc_4E466-off_4E418
                dc.w    loc_4E48C-off_4E418
                dc.w    loc_4E4B6-off_4E418
                dc.w    loc_4E4F8-off_4E418
                dc.w    loc_4E530-off_4E418
                dc.w    loc_4E4B6-off_4E418
                dc.w    loc_4E582-off_4E418
                dc.w    loc_4E5AC-off_4E418
                dc.w    loc_4E5CC-off_4E418
                dc.w    loc_4E466-off_4E418
; ---------------------------------------------------------------------------

loc_4E42E:
                lea     ObjDat3_4EB48(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #6,collision_property(a0)
                move.w  #$200,$3E(a0)
                move.w  #$80,y_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #loc_4E470,$34(a0)
                lea     ChildObjDat_4EB92(pc),a2
                jsr     CreateChild6_Simple(pc)
                lea     ChildObjDat_4EB6C(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_4E466:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4E470:
                move.b  #4,routine(a0)
                bset    #3,$38(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_4E490,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4E48C:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4E490:
                move.b  #6,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_4E4BE,$34(a0)
                lea     (word_16322C).l,a1

loc_4E4AA:
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                rts
; ---------------------------------------------------------------------------

loc_4E4B6:
                jsr     Run_PalRotationScript(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4E4BE:
                bset    #2,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_4E4DC,$34(a0)
                moveq   #signextendB(sfx_TunnelBooster),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_4E4DC:
                move.b  #8,routine(a0)
                move.w  #$300,y_vel(a0)
                move.w  #7,$2E(a0)
                move.l  #loc_4E506,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4E4F8:
                jsr     (MoveSprite2).l
                jsr     Run_PalRotationScript(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4E506:
                bsr.w   sub_4EA3C

loc_4E50A:
                move.b  #$A,routine(a0)
                move.w  #$300,y_vel(a0)
                neg.w   $3E(a0)
                move.w  $3E(a0),x_vel(a0)
                move.w  #$5F,$2E(a0)
                moveq   #signextendB(sfx_BossRotate),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_4E530:
                jsr     Run_PalRotationScript(pc)
                subq.w  #1,$2E(a0)
                bmi.s   loc_4E546
                addi.w  #-$10,y_vel(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_4E546:
                move.b  #$C,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_4E564,$34(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                jsr     Run_PalRotationScript(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4E564:
                subq.b  #1,$39(a0)
                bpl.s   loc_4E50A
                move.b  #$E,routine(a0)
                bset    #1,$38(a0)
                cmpi.w  #$6F0+$A0,x_pos(a0)
                scs     $43(a0)
                rts
; ---------------------------------------------------------------------------

loc_4E582:
                btst    #1,$38(a0)
                beq.s   loc_4E58E
                jmp     Run_PalRotationScript(pc)
; ---------------------------------------------------------------------------

loc_4E58E:
                move.b  #$10,routine(a0)
                bclr    #2,$38(a0)
                move.l  #loc_4E5B0,(Palette_rotation_custom).w
                lea     (word_163298).l,a1
                bra.w   loc_4E4AA
; ---------------------------------------------------------------------------

loc_4E5AC:
                jmp     Run_PalRotationScript(pc)
; ---------------------------------------------------------------------------

loc_4E5B0:
                move.b  #$12,routine(a0)
                move.w  #$222,(Normal_palette_line_2+$14).w
                move.w  #$3F,$2E(a0)
                move.l  #loc_4E5D0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4E5CC:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4E5D0:
                move.b  #$14,routine(a0)
                move.w  #-$100,y_vel(a0)
                clr.w   x_vel(a0)
                move.w  #$17,$2E(a0)
                move.l  #loc_4E5F0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4E5F0:
                move.b  #4,routine(a0)
                move.w  #$FF,$2E(a0)
                move.l  #loc_4E490,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4E606:
                jsr     (Obj_EndSignControl).l
                movea.w (_unkFAAE).w,a1
                cmpi.l  #loc_58DF8,(a1)
                bne.s   loc_4E61E
                bset    #5,$38(a1)

loc_4E61E:
                jsr     (AllocateObject).l
                bne.s   loc_4E62C
                move.l  #loc_4E634,(a1)

loc_4E62C:
                lea     ChildObjDat_4EB98(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_4E634:
                move.l  #loc_4E654,(a0)
                lea     (word_4EBE2).l,a1
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                move.l  #Go_Delete_Sprite,(Palette_rotation_custom).w
                rts
; ---------------------------------------------------------------------------

loc_4E654:
                jmp     Run_PalRotationScript(pc)
; ---------------------------------------------------------------------------

loc_4E658:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4E670(pc,d0.w),d1
                jsr     off_4E670(pc,d1.w)
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                jmp     Child_Draw_Sprite2_FlickerMove(pc)
; ---------------------------------------------------------------------------
off_4E670:
                dc.w    loc_4E678-off_4E670
                dc.w    loc_4E684-off_4E670
                dc.w    loc_4E6A4-off_4E670
                dc.w    locret_4E6C0-off_4E670
; ---------------------------------------------------------------------------

loc_4E678:
                lea     word_4EB54(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                bra.w   loc_4E8AA
; ---------------------------------------------------------------------------

loc_4E684:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_4E692
                rts
; ---------------------------------------------------------------------------

loc_4E692:
                move.b  #4,routine(a0)
                move.l  #loc_4E6B8,$34(a0)
                bra.w   loc_4E8C0
; ---------------------------------------------------------------------------

loc_4E6A4:
                move.b  x_vel(a0),d0
                add.b   d0,child_dx(a0)
                move.b  x_vel+1(a0),d0
                add.b   d0,child_dy(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4E6B8:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

locret_4E6C0:
                rts
; ---------------------------------------------------------------------------

loc_4E6C2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_4E6D6(pc,d0.w),d1
                jsr     off_4E6D6(pc,d1.w)
                moveq   #0,d0
                jmp     Child_DrawTouch_Sprite2_FlickerMove(pc)
; ---------------------------------------------------------------------------
off_4E6D6:
                dc.w    loc_4E6EE-off_4E6D6
                dc.w    loc_4E6FA-off_4E6D6
                dc.w    loc_4E724-off_4E6D6
                dc.w    loc_4E75E-off_4E6D6
                dc.w    loc_4E77E-off_4E6D6
                dc.w    loc_4E796-off_4E6D6
                dc.w    loc_4E7B6-off_4E6D6
                dc.w    loc_4E800-off_4E6D6
                dc.w    loc_4E75E-off_4E6D6
                dc.w    loc_4E84C-off_4E6D6
                dc.w    loc_4E75E-off_4E6D6
                dc.w    locret_4E884-off_4E6D6
; ---------------------------------------------------------------------------

loc_4E6EE:
                lea     ObjDat3_4EB5A(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bra.w   loc_4E8EC
; ---------------------------------------------------------------------------

loc_4E6FA:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_4E708
                rts
; ---------------------------------------------------------------------------

loc_4E708:
                move.b  #4,routine(a0)
                move.w  #-$40,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_4E73E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4E724:
                moveq   #1,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   loc_4E730
                neg.w   d0

loc_4E730:
                add.w   d0,x_pos(a0)
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4E73E:
                move.b  #6,routine(a0)
                move.w  #$180,priority(a0)
                bsr.w   sub_4E932
                move.w  #$1F,$2E(a0)
                move.l  #loc_4E768,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4E75E:
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4E768:
                move.b  #8,routine(a0)
                move.b  #$8B,collision_flags(a0)
                moveq   #signextendB(sfx_BossRotate),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_4E77E:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_4E78E
                bra.w   loc_4E98E
; ---------------------------------------------------------------------------

loc_4E78E:
                move.b  #$A,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_4E796:
                movea.w parent3(a0),a1
                moveq   #0,d0
                tst.b   $43(a1)
                bne.s   loc_4E7A4
                moveq   #-$80,d0

loc_4E7A4:
                cmp.b   $3D(a0),d0
                beq.s   loc_4E7AE
                bra.w   loc_4E98E
; ---------------------------------------------------------------------------

loc_4E7AE:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_4E7B6:
                addq.b  #4,$3C(a0)
                lea     (ICZMiniboss_OrbAngleLookup).l,a2
                jsr     MoveSprite_AtAngleLookup(pc)
                moveq   #0,d0
                bsr.w   sub_4E9A6
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_4E7F0
                tst.b   subtype(a0)
                bne.w   locret_4E400
                moveq   #0,d0
                tst.b   $43(a1)
                bne.s   loc_4E7E8
                moveq   #-$80,d0

loc_4E7E8:
                cmp.b   $3C(a0),d0
                bne.w   locret_4E400

loc_4E7F0:
                move.b  #$E,routine(a0)
                bclr    #1,$38(a1)
                bra.w   loc_4EA58
; ---------------------------------------------------------------------------

loc_4E800:
                move.b  $3C(a0),d0
                cmp.b   $42(a0),d0
                beq.s   loc_4E81E
                addq.b  #4,$3C(a0)
                lea     (ICZMiniboss_OrbAngleLookup).l,a2
                jsr     MoveSprite_AtAngleLookup(pc)
                moveq   #0,d0
                bra.w   sub_4E9A6
; ---------------------------------------------------------------------------

loc_4E81E:
                move.b  #$10,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_4E834,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4E834:
                move.b  #$12,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_4E850,$34(a0)
                bra.w   loc_4EAB8
; ---------------------------------------------------------------------------

loc_4E84C:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_4E850:
                move.b  #$14,routine(a0)
                moveq   #signextendB(sfx_LevelProjectile),d0
                jsr     (Play_SFX).l
                move.w  #$400,y_vel(a0)
                clr.w   x_vel(a0)
                move.w  #$45,$2E(a0)
                move.l  #loc_4E878,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4E878:
                move.b  #2,routine(a0)
                clr.b   collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

locret_4E884:
                rts
; ---------------------------------------------------------------------------

loc_4E886:
                lea     word_4EB66(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                addi.b  #$B,d0
                move.b  d0,mapping_frame(a0)
                moveq   #8,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------

loc_4E8AA:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  RawAni_4E8BA(pc,d0.w),mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------
RawAni_4E8BA:
                dc.b    1,   9,   3,   2,  $A,   4
                even
; ---------------------------------------------------------------------------

loc_4E8C0:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_4E8D4(pc,d0.w),x_vel(a0)
                move.w  word_4E8E0(pc,d0.w),$2E(a0)
                rts
; ---------------------------------------------------------------------------
word_4E8D4:
                dc.w    -1,  $1FF,     1,    -1,  $1FF,     1
word_4E8E0:
                dc.w    2,     2,     3,     6,     6,     8
; ---------------------------------------------------------------------------

loc_4E8EC:
                move.w  #$2B8+$D8,y_pos(a0)

loc_4E8F2:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_4E922(pc,d0.w),d2
                jsr     (Random_Number).l
                andi.w  #7,d0
                subq.w  #3,d0
                add.w   d0,d2
                move.w  #$6F0,x_pos(a0)
                add.w   d2,x_pos(a0)
                swap    d0
                andi.w  #7,d0
                subq.w  #3,d0
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
word_4E922:
                dc.w    -$20
                dc.w    $20
                dc.w    $60
                dc.w    $A0
                dc.w    $E0
                dc.w    $120
                dc.w    $160
                dc.w    $1A0

; =============== S U B R O U T I N E =======================================

sub_4E932:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #4,d0
                move.b  d0,$3C(a0)
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                movem.w d0-d1,-(sp)
                lea     (ICZMiniboss_OrbAngleLookup).l,a2
                jsr     MoveSprite_AtAngleLookup(pc)
                moveq   #0,d0
                moveq   #0,d1
                moveq   #0,d2
                moveq   #0,d3
                movem.w (sp)+,d0-d1
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                move.w  d0,x_pos(a0)
                move.w  d1,y_pos(a0)
                swap    d0
                swap    d1
                swap    d2
                swap    d3
                sub.l   d0,d2
                sub.l   d1,d3
                lsl.l   #3,d2
                lsl.l   #3,d3
                swap    d2
                swap    d3
                move.w  d2,x_vel(a0)
                move.w  d3,y_vel(a0)
                rts
; End of function sub_4E932

; ---------------------------------------------------------------------------

loc_4E98E:
                addq.b  #4,$3C(a0)
                lea     (ICZMiniboss_OrbAngleLookup).l,a2
                jsr     MoveSprite_AtAngleLookup(pc)
                move.b  $3D(a0),d0
                addq.b  #1,d0
                move.b  d0,$3D(a0)

; =============== S U B R O U T I N E =======================================

sub_4E9A6:
                jsr     (GetSineCosine).l
                tst.w   d1
                bpl.s   loc_4E9B2
                neg.w   d1

loc_4E9B2:
                move.w  y_pos(a0),d2
                move.w  y_pos(a1),d4
                sub.w   d4,d2
                scs     d3
                bcc.s   loc_4E9C2
                neg.w   d2

loc_4E9C2:
                mulu.w  d1,d2
                lsr.l   #8,d2
                cmpi.b  #$40,$3D(a0)
                blo.s   loc_4E9D8
                cmpi.b  #-$40,$3D(a0)
                bhs.s   loc_4E9D8
                not.b   d3

loc_4E9D8:
                tst.b   d3
                beq.s   loc_4E9DE
                neg.w   d2

loc_4E9DE:
                add.w   d2,d4
                move.w  d4,y_pos(a0)
                move.b  $3D(a0),d0
                spl     d3
                cmpi.b  #$40,$3C(a0)
                blo.s   loc_4E9FC
                cmpi.b  #-$40,$3C(a0)
                bhs.s   loc_4E9FC
                not.b   d3

loc_4E9FC:
                move.b  #6,mapping_frame(a0)
                cmpi.b  #$20,d0
                blo.s   loc_4EA2A
                cmpi.b  #$60,d0
                blo.s   loc_4EA1A
                cmpi.b  #-$60,d0
                blo.s   loc_4EA2A
                cmpi.b  #-$20,d0
                bhs.s   loc_4EA2A

loc_4EA1A:
                move.b  #5,mapping_frame(a0)
                tst.b   d3
                bne.s   loc_4EA2A
                move.b  #8,mapping_frame(a0)

loc_4EA2A:
                move.w  #$180,priority(a0)
                tst.b   d3
                bne.s   locret_4EA3A
                move.w  #$300,priority(a0)

locret_4EA3A:
                rts
; End of function sub_4E9A6

; =============== S U B R O U T I N E =======================================

sub_4EA3C:
                move.b  $3A(a0),d0
                addq.b  #1,$3A(a0)
                andi.w  #7,d0
                move.b  byte_4EA50(pc,d0.w),$39(a0)
                rts
; End of function sub_4EA3C

; ---------------------------------------------------------------------------
byte_4EA50:
                dc.b    1,   0,   1,   1,   0,   1,   0,   0
                even
; ---------------------------------------------------------------------------

loc_4EA58:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d1
                tst.b   $43(a1)
                bne.s   loc_4EA6E
                addq.w  #8,d1

loc_4EA6E:
                move.b  byte_4EA88(pc,d1.w),$42(a0)
                add.w   d0,d0
                move.l  word_4EA98(pc,d0.w),x_vel(a0)   ; and y_vel
                tst.b   $43(a1)
                bne.s   locret_4EA86
                neg.w   x_vel(a0)

locret_4EA86:
                rts
; ---------------------------------------------------------------------------
byte_4EA88:
                dc.b    $60, $5C, $58, $54, $50, $4C, $48, $44
                dc.b    $E0, $DC, $D8, $D4, $D0, $CC, $C8, $C4
                even
word_4EA98:
                dc.w    -$300, -$400
                dc.w    -$200, -$400
                dc.w    -$100, -$400
                dc.w    0, -$400
                dc.w    $100, -$400
                dc.w    $200, -$400
                dc.w    $300, -$400
                dc.w    $400, -$400
; ---------------------------------------------------------------------------

loc_4EAB8:
                move.w  #$2B8-$40,y_pos(a0)
                bra.w   loc_4E8F2

; =============== S U B R O U T I N E =======================================

sub_4EAC2:
                tst.b   collision_flags(a0)
                bne.s   locret_4EB0C
                tst.b   collision_property(a0)
                beq.s   loc_4EB0E
                tst.b   $20(a0)
                bne.s   loc_4EAE2
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_4EAE2:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_4EAF6
                addi.w  #2*2,d0

loc_4EAF6:
                bsr.w   sub_4EB2A
                subq.b  #1,$20(a0)
                bne.s   locret_4EB0C
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_4EB0C:
                rts
; ---------------------------------------------------------------------------

loc_4EB0E:
                move.l  #Wait_Draw,(a0)
                move.l  #loc_4E606,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                jmp     BossDefeated_StopTimer(pc)
; End of function sub_4EAC2

; =============== S U B R O U T I N E =======================================

sub_4EB2A:
                lea     word_4EB3C(pc),a1
                lea     word_4EB40(pc,d0.w),a2
                rept    2
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+
                endm
                rts
; End of function sub_4EB2A

; ---------------------------------------------------------------------------
word_4EB3C:
                dc.w    Normal_palette_line_2+$14, Normal_palette_line_2+$16
word_4EB40:
                dc.w    $222,   $20
                dc.w    $EEE,  $EEE
ObjDat3_4EB48:
                dc.l    Map_ICZMiniboss
                dc.w    make_art_tile(ArtTile_ICZMiniboss,1,1)
                dc.w    $280
                dc.b    $18, $18,   0,   6
word_4EB54:
                dc.w    $280
                dc.b    $10,  $C,   1,   0
ObjDat3_4EB5A:
                dc.l    Map_ICZMiniboss
                dc.w    make_art_tile(ArtTile_ICZMiniboss,2,0)
                dc.w    $280
                dc.b    $C,  $C,   6,   0
word_4EB66:
                dc.w    $180
                dc.b    $C,  $C,  $B,   0
ChildObjDat_4EB6C:
                dc.w    6-1
                dc.l    loc_4E658
                dc.b    -$E, -$B
                dc.l    loc_4E658
                dc.b    $E, -$B
                dc.l    loc_4E658
                dc.b    0, $12
                dc.l    loc_4E658
                dc.b    -$E, -$B
                dc.l    loc_4E658
                dc.b    $E, -$B
                dc.l    loc_4E658
                dc.b    0,  $E
ChildObjDat_4EB92:
                dc.w    8-1
                dc.l    loc_4E6C2
ChildObjDat_4EB98:
                dc.w    4-1
                dc.l    loc_4E886
                dc.b    -$C, -$C
                dc.l    loc_4E886
                dc.b    $C, -$C
                dc.l    loc_4E886
                dc.b    -$C,  $C
                dc.l    loc_4E886
                dc.b    $C,  $C
                dc.b    0
                dc.b    3
                dc.b    1
                dc.b    3
                dc.b    2
                dc.b    3
                dc.b    3
                dc.b    3
                dc.b    4
                dc.b    3
                dc.b    5
                dc.b    3
                dc.b    6
                dc.b    3
                dc.b    $F4
                even
Pal_ICZMiniboss:
                binclude "data/Levels/ICZ/Palettes/Miniboss.bin"
                even
