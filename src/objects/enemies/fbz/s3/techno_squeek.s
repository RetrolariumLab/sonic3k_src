; Owner: objects/enemies/fbz/s3
; Responsibility: Techno Squeek movement and attack states with private child and object resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_TechnoSqueek:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Technosqueek_Index(pc,d0.w),d1
                jsr     Technosqueek_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Technosqueek_Index:
                dc.w    S3TechnoSqueek_InitSwingMode-Technosqueek_Index
                dc.w    S3TechnoSqueek_AnimateHorizontalSwing-Technosqueek_Index
                dc.w    S3TechnoSqueek_AnimateHorizontalTurn-Technosqueek_Index
                dc.w    S3TechnoSqueek_AnimateVerticalSwing-Technosqueek_Index
                dc.w    S3TechnoSqueek_AnimateVerticalTurn-Technosqueek_Index
; ---------------------------------------------------------------------------

S3TechnoSqueek_InitSwingMode:
                move.w  #$800,$2E(a0)
                move.l  #S3TechnoSqueek_UnfreezeVisual,$34(a0)
                cmpi.b  #4,subtype(a0)
                beq.s   S3TechnoSqueek_InitVerticalSwing
                lea     S3TechnoSqueek_HorizontalAttrs(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #S3TechnoSqueek_FirstHorizontalAnim,$30(a0)
                bset    #0,render_flags(a0)
                cmpi.b  #2,subtype(a0)
                bne.s   S3TechnoSqueek_InitHorizontalSwing
                bset    #1,render_flags(a0)

S3TechnoSqueek_InitHorizontalSwing:
                lea     S3TechnoSqueek_VisualChildRecord(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.w  #$400,d0
                move.w  d0,$3A(a0)
                move.w  d0,x_vel(a0)
                move.w  #$20,$3C(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

S3TechnoSqueek_InitVerticalSwing:
                lea     S3TechnoSqueek_VerticalAttrs(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #6,routine(a0)
                move.l  #S3TechnoSqueek_FirstVerticalAnim,$30(a0)
                bset    #1,render_flags(a0)
                lea     S3TechnoSqueek_VisualChildRecord(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.w  #$400,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$20,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

S3TechnoSqueek_AnimateHorizontalSwing:
                jsr     Animate_RawMultiDelayFlipX(pc)
                tst.w   d2
                beq.s   S3TechnoSqueek_StepHorizontalSwing
                cmpi.b  #6,anim_frame(a0)
                bne.s   S3TechnoSqueek_StepHorizontalSwing
                bset    #1,$38(a0)

S3TechnoSqueek_StepHorizontalSwing:
                jsr     Swing_LeftAndRight(pc)
                tst.w   x_vel(a0)
                beq.s   S3TechnoSqueek_BeginHorizontalTurn
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

S3TechnoSqueek_BeginHorizontalTurn:
                move.b  #4,routine(a0)
                move.l  #S3TechnoSqueek_HorizontalTurnAnim,$30(a0)
                move.l  #S3TechnoSqueek_ResumeHorizontalSwing,$34(a0)

S3TechnoSqueek_ResetAnimCursorAndDelay:
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3TechnoSqueek_UnfreezeVisual:
                bclr    #5,$38(a0)

S3TechnoSqueek_SwingReturn:
                rts
; ---------------------------------------------------------------------------

S3TechnoSqueek_AnimateHorizontalTurn:
                jmp     Animate_RawAdjustFlipX(pc)
; ---------------------------------------------------------------------------

S3TechnoSqueek_ResumeHorizontalSwing:
                move.b  #2,routine(a0)
                move.l  #S3TechnoSqueek_RepeatHorizontalAnim,$30(a0)

S3TechnoSqueek_FreezeVisualAndResetAnim:
                bclr    #1,$38(a0)
                bset    #5,$38(a0)
                move.w  #$10,$2E(a0)
                move.l  #S3TechnoSqueek_UnfreezeVisual,$34(a0)
                bra.s   S3TechnoSqueek_ResetAnimCursorAndDelay
; ---------------------------------------------------------------------------

S3TechnoSqueek_AnimateVerticalSwing:
                jsr     Animate_RawMultiDelayFlipY(pc)
                tst.w   d2
                beq.s   S3TechnoSqueek_StepVerticalSwing
                cmpi.b  #6,anim_frame(a0)
                bne.s   S3TechnoSqueek_StepVerticalSwing
                bset    #1,$38(a0)

S3TechnoSqueek_StepVerticalSwing:
                jsr     Swing_UpAndDown(pc)
                tst.w   y_vel(a0)
                beq.s   S3TechnoSqueek_BeginVerticalTurn
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

S3TechnoSqueek_BeginVerticalTurn:
                move.b  #8,routine(a0)
                move.l  #S3TechnoSqueek_VerticalTurnAnim,$30(a0)
                move.l  #S3TechnoSqueek_ResumeVerticalSwing,$34(a0)
                bra.w   S3TechnoSqueek_ResetAnimCursorAndDelay
; ---------------------------------------------------------------------------

S3TechnoSqueek_AnimateVerticalTurn:
                jmp     Animate_RawAdjustFlipY(pc)
; ---------------------------------------------------------------------------

S3TechnoSqueek_ResumeVerticalSwing:
                move.b  #6,routine(a0)
                move.l  #S3TechnoSqueek_RepeatVerticalAnim,$30(a0)
                bra.s   S3TechnoSqueek_FreezeVisualAndResetAnim
; ---------------------------------------------------------------------------

S3TechnoSqueek_UpdateVisual:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  S3TechnoSqueek_VisualStateTable(pc,d0.w),d1
                jsr     S3TechnoSqueek_VisualStateTable(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
S3TechnoSqueek_VisualStateTable:
                dc.w    S3TechnoSqueek_InitVisual-S3TechnoSqueek_VisualStateTable
                dc.w    S3TechnoSqueek_AnimateHorizontalVisual-S3TechnoSqueek_VisualStateTable
                dc.w    S3TechnoSqueek_AnimateVerticalVisual-S3TechnoSqueek_VisualStateTable
; ---------------------------------------------------------------------------

S3TechnoSqueek_InitVisual:
                lea     TechnoSqueekS3_Visual_PartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                movea.w parent3(a0),a1
                cmpi.b  #4,subtype(a1)
                bne.s   S3TechnoSqueek_VisualReturn
                move.b  #4,routine(a0)

S3TechnoSqueek_VisualReturn:
                rts
; ---------------------------------------------------------------------------

S3TechnoSqueek_AnimateHorizontalVisual:
                lea     S3TechnoSqueek_HorizontalVisualAnim(pc),a1
                jsr     Animate_RawNoSST(pc)
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                btst    #1,$38(a1)
                beq.s   S3TechnoSqueek_UpdateHorizontalOffset
                moveq   #2,d0

S3TechnoSqueek_UpdateHorizontalOffset:
                add.w   d0,d0
                move.w  S3TechnoSqueek_HorizontalOffsets(pc,d0.w),child_dx(a0)  ; and child_dy
                btst    #5,$38(a1)
                bne.w   S3TechnoSqueek_SwingReturn
                jmp     Refresh_ChildPositionAdjusted(pc)
; ---------------------------------------------------------------------------
S3TechnoSqueek_HorizontalOffsets:
                dc.b    $14,   4
                dc.b    $C,   4
                dc.b    0,   4
                even
; ---------------------------------------------------------------------------

S3TechnoSqueek_AnimateVerticalVisual:
                lea     S3TechnoSqueek_VerticalVisualAnim(pc),a1
                jsr     Animate_RawNoSST(pc)
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                subq.w  #5,d0
                btst    #1,$38(a1)
                beq.s   S3TechnoSqueek_UpdateVerticalOffset
                moveq   #2,d0

S3TechnoSqueek_UpdateVerticalOffset:
                add.w   d0,d0
                move.w  S3TechnoSqueek_VerticalOffsets(pc,d0.w),child_dx(a0)  ; and child_dy
                btst    #5,$38(a1)
                bne.w   S3TechnoSqueek_SwingReturn
                jmp     Refresh_ChildPositionAdjusted(pc)
; ---------------------------------------------------------------------------
S3TechnoSqueek_VerticalOffsets:
                dc.b    -4, $14
                dc.b    -4,  $C
                dc.b    -4,   0
                even
S3TechnoSqueek_HorizontalAttrs:
                dc.l    Map_TechnoSqueek
                dc.w    make_art_tile(ArtTile_Technosqueek-6,1,1)
                dc.w    $280
                dc.b    $C,   8,   0,  $B
S3TechnoSqueek_VerticalAttrs:
                dc.l    Map_TechnoSqueek
                dc.w    make_art_tile(ArtTile_Technosqueek-6,1,1)
                dc.w    $280
                dc.b    8,  $C,   5,  $B
TechnoSqueekS3_Visual_PartialAttributes:
                dc.w    $280
                dc.b    8,   4,   2,   0
S3TechnoSqueek_VisualChildRecord:
                dc.w    1-1
                dc.l    S3TechnoSqueek_UpdateVisual
                dc.b    $14,   4
S3TechnoSqueek_FirstHorizontalAnim:
                dc.b    0,       0
                dc.b    0,     $17
                dc.b    1,       1
                dc.b    1|$40,   1
                dc.b    0,     $1F
                dc.b    $F4
S3TechnoSqueek_RepeatHorizontalAnim:
                dc.b    0,       0
                dc.b    0,     $37
                dc.b    1,       1
                dc.b    1|$40,   1
                dc.b    0,     $1F
                dc.b    $F4
S3TechnoSqueek_HorizontalTurnAnim:
                dc.b    3,   0,   0,   1, 1|$40,   0,   0,   1, 1|$40,   0, $F4
S3TechnoSqueek_HorizontalVisualAnim:
                dc.b    3,   2,   3,   4, $FC
S3TechnoSqueek_FirstVerticalAnim:
                dc.b    5,       0
                dc.b    5,     $17
                dc.b    6,       1
                dc.b    6|$20,   1
                dc.b    0,     $1F
                dc.b    $F4
S3TechnoSqueek_RepeatVerticalAnim:
                dc.b    5,       0
                dc.b    5,     $37
                dc.b    6,       1
                dc.b    6|$20,   1
                dc.b    5,     $1F
                dc.b    $F4
S3TechnoSqueek_VerticalTurnAnim:
                dc.b    3,   5,   5,   6, 6|$20,   5,   5,   6, 6|$20,   5, $F4
S3TechnoSqueek_VerticalVisualAnim:
                dc.b    3,   7,   8,   9, $FC
                even
