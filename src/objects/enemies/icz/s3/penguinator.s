; Owner: objects/enemies/icz/s3
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
                dc.w    loc_592A6-Penguinator_Index
                dc.w    loc_59302-Penguinator_Index
                dc.w    loc_5939C-Penguinator_Index
                dc.w    loc_593B6-Penguinator_Index
                dc.w    loc_59404-Penguinator_Index
                dc.w    loc_59452-Penguinator_Index
                dc.w    loc_5948C-Penguinator_Index
                dc.w    loc_594D4-Penguinator_Index
; ---------------------------------------------------------------------------

loc_592A6:
                lea     ObjSlot_Penguinator(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                bclr    #1,render_flags(a0)
                beq.s   loc_592BC
                bset    #7,art_tile(a0)

loc_592BC:
                move.b  #2,routine(a0)
                move.b  #$F,y_radius(a0)
                move.b  #4,x_radius(a0)
                bclr    #5,$38(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                clr.w   $2E(a0)
                move.l  #byte_595A2,$30(a0)
                move.l  #loc_5938C,$34(a0)
                moveq   #2,d0
                btst    #0,render_flags(a0)
                bne.s   loc_592FC
                neg.w   d0

loc_592FC:
                move.w  d0,$40(a0)
                rts
; ---------------------------------------------------------------------------

loc_59302:
                jsr     Animate_RawGetFaster(pc)
                beq.s   loc_59310
                cmpi.b  #2,$2E(a0)
                bls.s   loc_59328

loc_59310:
                move.w  $40(a0),d0
                move.w  x_vel(a0),d1
                add.w   d0,d1
                move.w  d1,x_vel(a0)
                jsr     (MoveSprite2).l
                jmp     ObjHitFloor2_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_59328:
                jsr     (ObjCheckFloorDist).l
                tst.b   d3
                beq.s   loc_59344
                btst    #0,render_flags(a0)
                beq.s   loc_5933E
                bchg    #6,d3

loc_5933E:
                btst    #6,d3
                beq.s   loc_59378

loc_59344:
                move.b  #4,routine(a0)
                move.w  #-$200,d0
                move.w  #$40,d1
                btst    #0,render_flags(a0)
                beq.s   loc_5935E
                neg.w   d0
                neg.w   d1

loc_5935E:
                move.w  d0,x_vel(a0)
                move.w  d1,$40(a0)
                move.l  #byte_595A9,$30(a0)
                move.l  #loc_593A0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_59378:
                move.b  #$E,routine(a0)
                move.w  #$40,$2E(a0)
                move.l  #loc_59344,$34(a0)

loc_5938C:
                neg.w   x_vel(a0)
                neg.w   $40(a0)
                bchg    #0,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_5939C:
                jmp     Move_AnimateRaw(pc)
; ---------------------------------------------------------------------------

loc_593A0:
                move.b  #6,routine(a0)
                move.b  #$B,y_radius(a0)
                move.l  #loc_593BE,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_593B6:
                jsr     MoveSprite_LightGravity(pc)
                jmp     ObjHitFloor_DoRoutine(pc)
; ---------------------------------------------------------------------------

loc_593BE:
                tst.b   d3
                move.b  d3,d4
                bpl.s   loc_593C6
                neg.b   d4

loc_593C6:
                andi.b  #$F8,d4
                beq.s   loc_593EA
                tst.w   x_vel(a0)
                bmi.s   loc_593D6
                bchg    #6,d3

loc_593D6:
                btst    #6,d3
                bne.s   loc_593EA
                neg.w   x_vel(a0)
                neg.w   $40(a0)
                bchg    #0,render_flags(a0)

loc_593EA:
                move.b  #8,routine(a0)
                move.w  #$20,$2E(a0)
                move.l  #loc_5942C,$34(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_59404:
                bsr.w   Penguinator_ProbeFloorAhead
                cmpi.w  #-2,d1
                blt.w   loc_5938C
                cmpi.w  #$C,d1
                bge.s   loc_593A0
                add.w   d1,y_pos(a0)
                bsr.w   SetPenguinatorSlidingPoseFromFloorAngle
                bsr.w   Penguinator_TrySkidSoundAndDust
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5942C:
                move.b  #$A,routine(a0)
                moveq   #8,d0
                sub.b   mapping_frame(a0),d0
                move.b  d0,anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #byte_595AE,$30(a0)
                move.l  #loc_59474,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_59452:
                bsr.w   Penguinator_ProbeFloorAhead
                cmpi.w  #-2,d1
                blt.w   loc_5938C
                cmpi.w  #$C,d1
                bge.w   loc_593A0
                add.w   d1,y_pos(a0)
                jsr     (MoveSprite2).l
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_59474:
                move.b  #$C,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.b  #$F,y_radius(a0)
                subq.w  #4,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_5948C:
                move.w  x_vel(a0),d0
                add.w   $40(a0),d0
                move.w  d0,x_vel(a0)
                beq.s   loc_594B4
                bsr.w   Penguinator_ProbeFloorAhead
                cmpi.w  #-2,d1
                blt.s   loc_594B4
                cmpi.w  #$C,d1
                bge.s   loc_594B4
                add.w   d1,y_pos(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_594B4:
                move.b  #$E,routine(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,$2E(a0)
                move.l  #loc_592BC,$34(a0)
                bchg    #0,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_594D4:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Obj_ICZSnowdust:
                lea     ObjDat_ICZSnowdust(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  subtype(a0),d0
                beq.s   loc_59504
                move.l  #Obj_Wait,(a0)
                lsl.w   #2,d0
                subq.w  #1,d0
                move.w  d0,$2E(a0)
                move.l  #loc_59504,$34(a0)

locret_59502:
                rts
; ---------------------------------------------------------------------------

loc_59504:
                move.l  #loc_59512,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

loc_59512:
                lea     byte_595B7(pc),a1
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
                beq.s   loc_59544
                lsr.b   #3,d3
                andi.w  #$F,d3
                move.b  RawAni_5954A(pc,d3.w),d0

loc_59544:
                move.b  d0,mapping_frame(a0)
                rts
; End of function SetPenguinatorSlidingPoseFromFloorAngle

; ---------------------------------------------------------------------------
RawAni_5954A:
                dc.b    4,  5,  6,  6,  7,  7,  8,  8,  8,  8,  7,  7,  6,  6,  5,  4
                even

; =============== S U B R O U T I N E =======================================

; Play the sound and try one attached snowdust actor when the slide countdown is divisible by four
Penguinator_TrySkidSoundAndDust:
                move.w  $2E(a0),d0
                andi.w  #3,d0
                bne.s   locret_59502
                moveq   #signextendB(sfx_SlideSkidQuiet),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_59592(pc),a2
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
ChildObjDat_59592:
                dc.w    1-1
                dc.l    Obj_ICZSnowdust
                dc.b    0,  $C
DPLCPtr_Penguinator:
                dc.l    ArtUnc_Penguinator
                dc.l    DPLC_Penguinator
byte_595A2:
                dc.b    7, $10
                dc.b    0,   1
                dc.b    0,   2
                dc.b    $FC
byte_595A9:
                dc.b    3,   3,   3,   4, $F4
byte_595AE:
                dc.b    3,   8,   8,   7,   6,   5,   4,   3, $F4
byte_595B7:
                dc.b    0,   0,   0,   1,   2,   3,   4,   5,   4,   3,   2,   1,   0, $F4
                even
