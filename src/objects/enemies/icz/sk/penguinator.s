; Owner: objects/enemies/icz/sk
; Responsibility: Penguinator sliding or attack states, snowdust effect actors and private pattern resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Penguinator:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Penguinator_Index(pc,d0.w),d1
                jsr     Penguinator_Index(pc,d1.w)
                lea     DPLCPtr_Penguinator(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     Sprite_CheckDeleteTouchSlotted(pc)
; ---------------------------------------------------------------------------
Penguinator_Index:
                dc.w    loc_8BB0E-Penguinator_Index
                dc.w    loc_8BB6A-Penguinator_Index
                dc.w    loc_8BC04-Penguinator_Index
                dc.w    loc_8BC1E-Penguinator_Index
                dc.w    loc_8BC6C-Penguinator_Index
                dc.w    loc_8BCBA-Penguinator_Index
                dc.w    loc_8BCF4-Penguinator_Index
                dc.w    loc_8BD3C-Penguinator_Index
; ---------------------------------------------------------------------------

loc_8BB0E:
                lea     ObjSlot_Penguinator(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                bclr    #1,render_flags(a0)
                beq.s   loc_8BB24
                bset    #7,art_tile(a0)

loc_8BB24:
                move.b  #2,routine(a0)
                move.b  #$F,y_radius(a0)
                move.b  #4,x_radius(a0)
                bclr    #5,$38(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                clr.w   $2E(a0)
                move.l  #byte_8BE0A,$30(a0)
                move.l  #loc_8BBF4,$34(a0)
                moveq   #2,d0
                btst    #0,render_flags(a0)
                bne.s   loc_8BB64
                neg.w   d0

loc_8BB64:
                move.w  d0,$40(a0)
                rts
; ---------------------------------------------------------------------------

loc_8BB6A:
                jsr     Animate_RawGetFaster(pc)
                beq.s   loc_8BB78
                cmpi.b  #2,$2E(a0)
                bls.s   loc_8BB90

loc_8BB78:
                move.w  $40(a0),d0
                move.w  x_vel(a0),d1
                add.w   d0,d1
                move.w  d1,x_vel(a0)
                jsr     (MoveSprite2).l
                jmp     ObjHitFloor2_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_8BB90:
                jsr     (ObjCheckFloorDist).l
                tst.b   d3
                beq.s   loc_8BBAC
                btst    #0,render_flags(a0)
                beq.s   loc_8BBA6
                bchg    #6,d3

loc_8BBA6:
                btst    #6,d3
                beq.s   loc_8BBE0

loc_8BBAC:
                move.b  #4,routine(a0)
                move.w  #-$200,d0
                move.w  #$40,d1
                btst    #0,render_flags(a0)
                beq.s   loc_8BBC6
                neg.w   d0
                neg.w   d1

loc_8BBC6:
                move.w  d0,x_vel(a0)
                move.w  d1,$40(a0)
                move.l  #byte_8BE11,$30(a0)
                move.l  #loc_8BC08,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8BBE0:
                move.b  #$E,routine(a0)
                move.w  #$40,$2E(a0)
                move.l  #loc_8BBAC,$34(a0)

loc_8BBF4:
                neg.w   x_vel(a0)
                neg.w   $40(a0)
                bchg    #0,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_8BC04:
                jmp     Move_AnimateRaw(pc)
; ---------------------------------------------------------------------------

loc_8BC08:
                move.b  #6,routine(a0)
                move.b  #$B,y_radius(a0)
                move.l  #loc_8BC26,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8BC1E:
                jsr     MoveSprite_LightGravity(pc)
                jmp     ObjHitFloor_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_8BC26:
                tst.b   d3
                move.b  d3,d4
                bpl.s   loc_8BC2E
                neg.b   d4

loc_8BC2E:
                andi.b  #$F8,d4
                beq.s   loc_8BC52
                tst.w   x_vel(a0)
                bmi.s   loc_8BC3E
                bchg    #6,d3

loc_8BC3E:
                btst    #6,d3
                bne.s   loc_8BC52
                neg.w   x_vel(a0)
                neg.w   $40(a0)
                bchg    #0,render_flags(a0)

loc_8BC52:
                move.b  #8,routine(a0)
                move.w  #$20,$2E(a0)
                move.l  #loc_8BC94,$34(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_8BC6C:
                bsr.w   Penguinator_ProbeFloorAhead
                cmpi.w  #-2,d1
                blt.w   loc_8BBF4
                cmpi.w  #$C,d1
                bge.s   loc_8BC08
                add.w   d1,y_pos(a0)
                bsr.w   SetPenguinatorSlidingPoseFromFloorAngle
                bsr.w   Penguinator_TrySkidSoundAndDust
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_8BC94:
                move.b  #$A,routine(a0)
                moveq   #8,d0
                sub.b   mapping_frame(a0),d0
                move.b  d0,anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #byte_8BE16,$30(a0)
                move.l  #loc_8BCDC,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8BCBA:
                bsr.w   Penguinator_ProbeFloorAhead
                cmpi.w  #-2,d1
                blt.w   loc_8BBF4
                cmpi.w  #$C,d1
                bge.w   loc_8BC08
                add.w   d1,y_pos(a0)
                jsr     (MoveSprite2).l
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_8BCDC:
                move.b  #$C,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.b  #$F,y_radius(a0)
                subq.w  #4,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_8BCF4:
                move.w  x_vel(a0),d0
                add.w   $40(a0),d0
                move.w  d0,x_vel(a0)
                beq.s   loc_8BD1C
                bsr.w   Penguinator_ProbeFloorAhead
                cmpi.w  #-2,d1
                blt.s   loc_8BD1C
                cmpi.w  #$C,d1
                bge.s   loc_8BD1C
                add.w   d1,y_pos(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_8BD1C:
                move.b  #$E,routine(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,$2E(a0)
                move.l  #loc_8BB24,$34(a0)
                bchg    #0,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_8BD3C:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Obj_ICZSnowdust:
                lea     ObjDat_ICZSnowdust(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  subtype(a0),d0
                beq.s   loc_8BD6C
                move.l  #Obj_Wait,(a0)
                lsl.w   #2,d0
                subq.w  #1,d0
                move.w  d0,$2E(a0)
                move.l  #loc_8BD6C,$34(a0)

locret_8BD6A:
                rts
; ---------------------------------------------------------------------------

loc_8BD6C:
                move.l  #loc_8BD7A,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

loc_8BD7A:
                lea     byte_8BE1F(pc),a1
                jsr     Animate_RawNoSST(pc)
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

Penguinator_ProbeFloorAhead:
                move.w  x_vel(a0),d3
                ext.l   d3
                lsl.l   #8,d3
                add.l   x_pos(a0),d3
                swap    d3
                jmp     (ObjCheckFloorDist2).l
; End of function Penguinator_ProbeFloorAhead

; =============== S U B R O U T I N E =======================================

SetPenguinatorSlidingPoseFromFloorAngle:
                moveq   #4,d0
                tst.b   d3
                beq.s   loc_8BDAC
                lsr.b   #3,d3
                andi.w  #$F,d3
                move.b  RawAni_8BDB2(pc,d3.w),d0

loc_8BDAC:
                move.b  d0,mapping_frame(a0)
                rts
; End of function SetPenguinatorSlidingPoseFromFloorAngle

; ---------------------------------------------------------------------------
RawAni_8BDB2:
                dc.b    4,  5,  6,  6,  7,  7,  8,  8,  8,  8,  7,  7,  6,  6,  5,  4
                even

; =============== S U B R O U T I N E =======================================

; Play the sound and try one attached snowdust actor when the slide countdown is divisible by four
Penguinator_TrySkidSoundAndDust:
                move.w  $2E(a0),d0
                andi.w  #3,d0
                bne.s   locret_8BD6A
                moveq   #signextendB(sfx_SlideSkidQuiet),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_8BDFA(pc),a2
                jmp     CreateChild1_Normal(pc)
; End of function Penguinator_TrySkidSoundAndDust

; ---------------------------------------------------------------------------
ObjSlot_Penguinator:
                dc.w    4-1
                dc.w    make_art_tile(ArtTile_Penguinator,1,0)
                dc.w    $12,     0
                dc.l    Map_Penguinator
                dc.w    $280
                dc.b    $14, $10,   0, $1A
ObjDat_ICZSnowdust:
                dc.l    Map_ICZSnowdust
                dc.w    make_art_tile(ArtTile_ICZSnowdust,1,0)
                dc.w    0
                dc.b    4, $18,   0,   0
ChildObjDat_8BDFA:
                dc.w    1-1
                dc.l    Obj_ICZSnowdust
                dc.b    0,  $C
DPLCPtr_Penguinator:
                dc.l    ArtUnc_Penguinator
                dc.l    DPLC_Penguinator
byte_8BE0A:
                dc.b    7, $10
                dc.b    0,   1
                dc.b    0,   2
                dc.b    $FC
byte_8BE11:
                dc.b    3,   3,   3,   4, $F4
byte_8BE16:
                dc.b    3,   8,   8,   7,   6,   5,   4,   3, $F4
byte_8BE1F:
                dc.b    0,   0,   0,   1,   2,   3,   4,   5,   4,   3,   2,   1,   0, $F4
                even
