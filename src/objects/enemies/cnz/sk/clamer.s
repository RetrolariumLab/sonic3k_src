; Owner: objects/enemies/cnz/sk
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
                dc.w    loc_88FDC-Clamer_Index
                dc.w    loc_88FEC-Clamer_Index
                dc.w    loc_8904E-Clamer_Index
                dc.w    loc_89064-Clamer_Index
; ---------------------------------------------------------------------------

loc_88FDC:
                lea     ObjSlot_Clamer(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                lea     ChildObjDat_89148(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_88FEC:
                btst    #0,$38(a0)
                bne.s   loc_89014
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                bhs.s   loc_8900C
                btst    #0,render_flags(a0)
                beq.s   loc_89008
                subq.w  #2,d0

loc_89008:
                tst.w   d0
                beq.s   loc_89036

loc_8900C:
                lea     byte_89170(pc),a1
                jmp     Animate_RawNoSSTMultiDelay(pc)
; ---------------------------------------------------------------------------

loc_89014:
                move.b  #4,routine(a0)
                clr.b   collision_flags(a0)
                bclr    #0,$38(a0)
                move.l  #loc_89056,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_89036:
                move.b  #6,routine(a0)
                move.l  #loc_89056,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)

locret_8904C:
                rts
; ---------------------------------------------------------------------------

loc_8904E:
                lea     byte_89179(pc),a1
                jmp     Animate_RawNoSST(pc)
; ---------------------------------------------------------------------------

loc_89056:
                move.b  #2,routine(a0)
                move.b  #$A,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_89064:
                lea     byte_89185(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.w   locret_8904C
                cmpi.b  #8,mapping_frame(a0)
                bne.w   locret_8904C
                tst.b   render_flags(a0)
                bpl.w   locret_8904C
                lea     ChildObjDat_89150(pc),a2
                jmp     CreateChild5_ComplexAdjusted(pc)
; ---------------------------------------------------------------------------

loc_8908C:
                lea     word_89136(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                movea.w parent3(a0),a1
                move.b  render_flags(a1),render_flags(a0)
                clr.w   art_tile(a0)
                move.l  #loc_890AA,(a0)
                rts
; ---------------------------------------------------------------------------

loc_890AA:
                bsr.w   Check_PlayerCollision
                beq.s   loc_890C4
                move.l  #loc_890C8,(a0)
                bsr.w   sub_890D8
                movea.w parent3(a0),a1
                bset    #0,$38(a1)

loc_890C4:
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_890C8:
                subq.w  #1,$2E(a0)
                bmi.s   loc_890D0
                rts
; ---------------------------------------------------------------------------

loc_890D0:
                move.l  #loc_890AA,(a0)
                rts

; =============== S U B R O U T I N E =======================================

sub_890D8:
                move.w  #$800,d0
                bclr    #Status_Facing,status(a1)
                btst    #0,render_flags(a0)
                beq.s   loc_890F2
                neg.w   d0
                bset    #Status_Facing,status(a1)

loc_890F2:
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
; End of function sub_890D8

; ---------------------------------------------------------------------------
ObjSlot_Clamer:
                dc.w    2-1
                dc.w    make_art_tile(ArtTile_Clamer,1,1)
                dc.w    $12,     0
                dc.l    Map_Clamer
                dc.w    $280
                dc.b    $14, $10,   0,  $A
word_89136:
                dc.w    $280
                dc.b    8,   4,  $B, $D7
ObjDat3_8913C:
                dc.l    Map_Clamer
                dc.w    make_art_tile(ArtTile_Clamer+$70,1,1)
                dc.w    $200
                dc.b    8,   8,   9, $98
ChildObjDat_89148:
                dc.w    1-1
                dc.l    loc_8908C
                dc.b    0,  -8
ChildObjDat_89150:
                dc.w    1-1
                dc.l    loc_86D4A
                dc.l    ObjDat3_8913C
                dc.l    0
                dc.l    MoveSprite2
                dc.b    -$10,   2
                dc.w    -$200,     0
PLCPtr_Clamer:
                dc.l    ArtUnc_Clamer
                dc.l    DPLC_Clamer
byte_89170:
                dc.b    1,   1
                dc.b    0, $5F
                dc.b    1,   1
                dc.b    2,   1
                dc.b    $FC
byte_89179:
                dc.b    0,   0,   1,   2,   3,   4,   3,   2,   1,  $A,   0, $F4
byte_89185:
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
