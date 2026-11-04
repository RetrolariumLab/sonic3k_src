; Owner: objects/enemies/icz/s3
; Responsibility: Snale Blaster locomotion and projectile states with private child or object resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SnaleBlaster:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SnaleBlaster_Index(pc,d0.w),d1
                jsr     SnaleBlaster_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
SnaleBlaster_Index:
                dc.w    loc_5976C-SnaleBlaster_Index
                dc.w    loc_5978A-SnaleBlaster_Index
                dc.w    loc_597BE-SnaleBlaster_Index
                dc.w    loc_597EA-SnaleBlaster_Index
                dc.w    loc_59842-SnaleBlaster_Index
                dc.w    loc_5986C-SnaleBlaster_Index
                dc.w    loc_5988C-SnaleBlaster_Index
; ---------------------------------------------------------------------------

loc_5976C:
                lea     ObjDat_SnaleBlaster(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  #$20,$2E(a0)
                move.l  #loc_597A6,$34(a0)
                lea     ChildObjDat_59A1C(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_5978A:
                move.b  #$1A,collision_flags(a0)
                clr.b   collision_property(a0)
                btst    #1,$38(a0)
                bne.s   loc_597A2
                move.b  #$7F,collision_property(a0)

loc_597A2:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_597A6:
                move.b  #4,routine(a0)
                move.l  #byte_59A48,$30(a0)
                move.l  #loc_597C8,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_597BE:
                move.b  #$1A,collision_flags(a0)
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_597C8:
                move.w  #-2,$40(a0)
                move.l  #byte_59A52,$30(a0)

loc_597D6:
                move.b  #6,routine(a0)
                move.b  #2,$39(a0)
                bclr    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_597EA:
                move.b  #$1A,collision_flags(a0)
                move.b  #$7F,collision_property(a0)
                bsr.w   SnaleBlaster_TryRetractNearRoll
                jsr     Animate_RawMultiDelay(pc)
                tst.w   d2
                beq.s   locret_59820
                moveq   #3,d0
                tst.w   $40(a0)
                bmi.s   loc_5980C
                moveq   #4,d0

loc_5980C:
                cmp.b   mapping_frame(a0),d0
                bne.s   locret_59820
                move.w  $40(a0),d0
                add.w   d0,y_pos(a0)
                subq.b  #1,$39(a0)
                bmi.s   loc_59822

locret_59820:
                rts
; ---------------------------------------------------------------------------

loc_59822:
                move.b  #2,routine(a0)
                move.w  #$90,$2E(a0)
                bset    #1,$38(a0)
                move.l  #loc_597D6,$34(a0)
                neg.w   $40(a0)
                rts
; ---------------------------------------------------------------------------

loc_59842:
                move.b  #$7F,collision_property(a0)
                subq.b  #1,mapping_frame(a0)
                beq.s   loc_59850
                rts
; ---------------------------------------------------------------------------

loc_59850:
                move.b  #$A,routine(a0)
                move.b  #$7F,collision_property(a0)
                move.w  #60-1,$2E(a0)
                move.l  #loc_59876,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5986C:
                move.b  #$7F,collision_property(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_59876:
                move.b  #$C,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_59890,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5988C:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_59890:
                move.b  #$1A,collision_flags(a0)
                move.b  #$7F,collision_property(a0)
                move.w  #2,$2E(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #3,mapping_frame(a0)
                blo.s   locret_598B4
                move.b  #6,routine(a0)

locret_598B4:
                rts
; ---------------------------------------------------------------------------

loc_598B6:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_598CC(pc,d0.w),d1
                jsr     off_598CC(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_598CC:
                dc.w    loc_598D2-off_598CC
                dc.w    loc_598DA-off_598CC
                dc.w    Animate_RawMultiDelay-off_598CC
; ---------------------------------------------------------------------------

loc_598D2:
                lea     word_59A14(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_598DA:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_598E8
                rts
; ---------------------------------------------------------------------------

loc_598E8:
                move.b  #4,routine(a0)
                move.l  #byte_59A57,$30(a0)
                move.l  #loc_59900,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_59900:
                move.b  #2,routine(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_59912:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_59928(pc,d0.w),d1
                jsr     off_59928(pc,d1.w)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
off_59928:
                dc.w    loc_59930-off_59928
                dc.w    loc_59938-off_59928
                dc.w    loc_5996C-off_59928
                dc.w    loc_599B8-off_59928
; ---------------------------------------------------------------------------

loc_59930:
                lea     word_59A1A(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_59938:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_59946
                rts
; ---------------------------------------------------------------------------

loc_59946:
                move.b  #4,routine(a0)
                move.l  #byte_59A62,$30(a0)
                tst.b   subtype(a0)
                beq.s   loc_59962
                move.l  #byte_59A6B,$30(a0)

loc_59962:
                move.l  #loc_599B0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5996C:
                jsr     Animate_RawMultiDelay(pc)
                tst.w   d2
                beq.s   locret_599AE
                bmi.s   locret_599AE
                cmpi.b  #4,anim_frame(a0)
                bne.s   locret_599AE
                tst.b   render_flags(a0)
                bpl.s   locret_599AE
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_59A30(pc),a2
                jsr     CreateChild2_Complex(pc)
                movea.w parent3(a0),a2
                btst    #0,render_flags(a2)
                beq.s   loc_599A4
                neg.w   x_vel(a1)

loc_599A4:
                tst.b   subtype(a0)
                beq.s   locret_599AE
                neg.w   y_vel(a1)

locret_599AE:
                rts
; ---------------------------------------------------------------------------

loc_599B0:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_599B8:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_599C6
                rts
; ---------------------------------------------------------------------------

loc_599C6:
                move.b  #2,routine(a0)
                rts

; =============== S U B R O U T I N E =======================================

; Require the horizontally nearest player to be rolling with both separations below $30. Skip the rest of the current movement state on success
SnaleBlaster_TryRetractNearRoll:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$30,d2
                bhs.s   locret_599E6
                cmpi.w  #$30,d3
                bhs.s   locret_599E6
                cmpi.b  #2,anim(a1)
                beq.s   loc_599E8

locret_599E6:
                rts
; ---------------------------------------------------------------------------

loc_599E8:
                move.b  #8,routine(a0)
                move.b  #3,mapping_frame(a0)
                addq.w  #4,sp
                rts
; End of function SnaleBlaster_TryRetractNearRoll

; ---------------------------------------------------------------------------
ObjDat_SnaleBlaster:
                dc.l    Map_SnaleBlaster
                dc.w    make_art_tile(ArtTile_SnaleBlaster,1,0)
                dc.w    $200
                dc.b    $10, $10,   0,  $B
word_59A14:
                dc.w    $180
                dc.b    4,  $C,   5,   0
word_59A1A:
                dc.w    $200
                dc.b    4,   4,   7,   0
ObjDat3_59A10:
                dc.l    Map_SnaleBlaster
                dc.w    make_art_tile(ArtTile_SnaleBlaster,0,1)
                dc.w    $200
                dc.b    4,   4,   9, $98
ChildObjDat_59A1C:
                dc.w    3-1
                dc.l    loc_59912
                dc.b    -8,   0
                dc.l    loc_59912
                dc.b    -8,   7
                dc.l    loc_598B6
                dc.b    -8,   4
ChildObjDat_59A30:
                dc.w    1-1
                dc.l    S3CallbackShot_InitDeflectable
                dc.l    ObjDat3_59A10
                dc.l    0
                dc.l    MoveSprite2
                dc.b    0,   0
                dc.w    -$200, -$100
byte_59A48:
                dc.b    5,   0,   1,   2,   3,   4,   4,   4,   4, $F4
byte_59A52:
                dc.b    4,  $F
                dc.b    3,  $F
                dc.b    $FC
byte_59A57:
                dc.b    5,   2
                dc.b    6,   2
                dc.b    $A, $5F
                dc.b    6,   2
                dc.b    5,   2
                dc.b    $F4
byte_59A62:
                dc.b    7,   2
                dc.b    7, $1F
                dc.b    8,   3
                dc.b    7,   0
                dc.b    $F4
byte_59A6B:
                dc.b    7,   2
                dc.b    7, $2F
                dc.b    8,   3
                dc.b    7,   0
                dc.b    $F4
                even
