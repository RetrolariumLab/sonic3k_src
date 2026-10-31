; Owner: objects/enemies/cnz/s3
; Responsibility: Clamer attack and projectile state, tracking slots and private graphics resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Clamer:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Clamer_Index(pc,d0.w),d1
                jsr     Clamer_Index(pc,d1.w)
                lea     PLCPtr_Clamer(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     Sprite_CheckDeleteTouchSlotted(pc)
; ---------------------------------------------------------------------------
Clamer_Index:
                dc.w    loc_56D9A-Clamer_Index
                dc.w    loc_56DAA-Clamer_Index
                dc.w    loc_56E0C-Clamer_Index
                dc.w    loc_56E22-Clamer_Index
; ---------------------------------------------------------------------------

loc_56D9A:
                lea     ObjSlot_Clamer(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                lea     ChildObjDat_56EFC(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_56DAA:
                btst    #0,$38(a0)
                bne.s   loc_56DD2
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                bhs.s   loc_56DCA
                btst    #0,render_flags(a0)
                beq.s   loc_56DC6
                subq.w  #2,d0

loc_56DC6:
                tst.w   d0
                beq.s   loc_56DF4

loc_56DCA:
                lea     byte_56F24(pc),a1
                jmp     Animate_RawNoSSTMultiDelay(pc)
; ---------------------------------------------------------------------------

loc_56DD2:
                move.b  #4,routine(a0)
                clr.b   collision_flags(a0)
                bclr    #0,$38(a0)
                move.l  #loc_56E14,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_56DF4:
                move.b  #6,routine(a0)
                move.l  #loc_56E14,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)

locret_56E0A:
                rts
; ---------------------------------------------------------------------------

loc_56E0C:
                lea     byte_56F2D(pc),a1
                jmp     Animate_RawNoSST(pc)
; ---------------------------------------------------------------------------

loc_56E14:
                move.b  #2,routine(a0)
                move.b  #$A,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_56E22:
                lea     byte_56F39(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.w   locret_56E0A
                cmpi.b  #8,mapping_frame(a0)
                bne.w   locret_56E0A
                tst.b   render_flags(a0)
                bpl.w   locret_56E0A
                lea     ChildObjDat_56F04(pc),a2
                jmp     CreateChild5_ComplexAdjusted(pc)
; ---------------------------------------------------------------------------

loc_56E4A:
                lea     word_56EEA(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                movea.w parent3(a0),a1
                move.b  render_flags(a1),render_flags(a0)
                clr.w   art_tile(a0)
                move.l  #loc_56E68,(a0)
                rts
; ---------------------------------------------------------------------------

loc_56E68:
                bsr.w   Check_PlayerCollision
                beq.s   loc_56E78
                move.l  #loc_56E7C,(a0)
                bsr.w   sub_56E8C

loc_56E78:
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_56E7C:
                subq.w  #1,$2E(a0)
                bmi.s   loc_56E84
                rts
; ---------------------------------------------------------------------------

loc_56E84:
                move.l  #loc_56E68,(a0)
                rts

; =============== S U B R O U T I N E =======================================

sub_56E8C:
                move.w  #$800,d0
                bclr    #Status_Facing,status(a1)
                btst    #0,render_flags(a0)
                beq.s   loc_56EA6
                neg.w   d0
                bset    #Status_Facing,status(a1)

loc_56EA6:
                move.w  d0,x_vel(a1)
                move.w  d0,ground_vel(a1)
                move.w  #-$800,y_vel(a1)
                bset    #Status_InAir,status(a1)
                addq.w  #6,y_pos(a1)
                move.b  #$10,anim(a1)
                move.b  #2,routine(a1)
                clr.b   jumping(a1)
                moveq   #signextendB(sfx_Spring),d0
                jsr     (Play_SFX).l
                rts
; End of function sub_56E8C

; ---------------------------------------------------------------------------
ObjSlot_Clamer:
                dc.w    2-1
                dc.w    make_art_tile(ArtTile_Clamer,1,1)
                dc.w    $12,     0
                dc.l    Map_Clamer
                dc.w    $280
                dc.b    $14, $10,   0,  $A
word_56EEA:
                dc.w    $280
                dc.b    8,   4,  $B, $D7
ObjDat3_56EF0:
                dc.l    Map_Clamer
                dc.w    make_art_tile(ArtTile_Clamer+$70,1,1)
                dc.w    $200
                dc.b    8,   8,   9, $98
ChildObjDat_56EFC:
                dc.w    1-1
                dc.l    loc_56E4A
                dc.b    0,  -8
ChildObjDat_56F04:
                dc.w    1-1
                dc.l    loc_54B46
                dc.l    ObjDat3_56EF0
                dc.l    0
                dc.l    MoveSprite2
                dc.b    -$10,   2
                dc.w    -$200,     0
PLCPtr_Clamer:
                dc.l    ArtUnc_Clamer
                dc.l    DPLC_Clamer
byte_56F24:
                dc.b    1,   1
                dc.b    0, $5F
                dc.b    1,   1
                dc.b    2,   1
                dc.b    $FC
byte_56F2D:
                dc.b    0,   0,   1,   2,   3,   4,   3,   2,   1,  $A,   0, $F4
byte_56F39:
                dc.b    0,   2
                dc.b    5,   2
                dc.b    6,   2
                dc.b    7, $2F
                dc.b    8,   5
                dc.b    7, $1F
                dc.b    6,   2
                dc.b    5,   2
                dc.b    0, $1F
                dc.b    $F4
                even
