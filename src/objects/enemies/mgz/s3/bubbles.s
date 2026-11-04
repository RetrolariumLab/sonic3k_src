; Owner: objects/enemies/mgz/s3
; Responsibility: Bubbles enemy states, tracking-slot resources and graphics loading descriptors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_BubblesBadnik:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  BubblesBadnik_Index(pc,d0.w),d1
                jsr     BubblesBadnik_Index(pc,d1.w)
                move.b  #$12,collision_flags(a0)
                cmpi.b  #4,mapping_frame(a0)
                bne.s   S3BubblesBadnik_LoadFrameAndDraw
                move.b  #$86,collision_flags(a0)

S3BubblesBadnik_LoadFrameAndDraw:
                lea     PLCPtr_BubblesBadnik(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     Sprite_CheckDeleteTouchSlotted(pc)
; ---------------------------------------------------------------------------
BubblesBadnik_Index:
                dc.w    S3BubblesBadnik_InitSlotAndVelocity-BubblesBadnik_Index
                dc.w    S3BubblesBadnik_BobAndCheckTurn-BubblesBadnik_Index
                dc.w    S3BubblesBadnik_AnimateAndTryTurnSound-BubblesBadnik_Index
; ---------------------------------------------------------------------------

S3BubblesBadnik_InitSlotAndVelocity:
                lea     ObjSlot_BubblesBadnik(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                move.w  #-$80,x_vel(a0)
                btst    #0,render_flags(a0)
                beq.s   S3BubblesBadnik_InitIdleAnimAndSwing
                neg.w   x_vel(a0)

S3BubblesBadnik_InitIdleAnimAndSwing:
                move.l  #S3BubblesBadnik_IdleAnim,$30(a0)
                move.w  #$100,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #2,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

S3BubblesBadnik_BobAndCheckTurn:
                jsr     Animate_RawMultiDelay(pc)
                move.w  y_vel(a0),d4
                jsr     Swing_UpAndDown(pc)
                tst.w   y_vel(a0)
                bne.s   S3BubblesBadnik_MoveAfterIdleSwing
                tst.w   d4
                bmi.s   S3BubblesBadnik_MoveAfterIdleSwing
                move.b  #4,routine(a0)
                move.l  #S3BubblesBadnik_TurnAnim,$30(a0)
                move.l  #S3BubblesBadnik_RestartIdleAnim,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)

S3BubblesBadnik_MoveAfterIdleSwing:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

; Play the tick when the animation cursor reaches 4 on a fresh pair
S3BubblesBadnik_AnimateAndTryTurnSound:
                jsr     Animate_RawMultiDelay(pc)
                beq.s   S3BubblesBadnik_TryReverseAtSwingTurn
                cmpi.b  #4,anim_frame(a0)
                bne.s   S3BubblesBadnik_TryReverseAtSwingTurn
                moveq   #signextendB(sfx_ChainTick),d0
                jsr     (Play_SFX).l

S3BubblesBadnik_TryReverseAtSwingTurn:
                jsr     Swing_UpAndDown(pc)
                tst.w   d3
                beq.s   S3BubblesBadnik_MoveAfterTurn
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

S3BubblesBadnik_MoveAfterTurn:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

S3BubblesBadnik_RestartIdleAnim:
                move.b  #2,routine(a0)
                move.l  #S3BubblesBadnik_IdleAnim,$30(a0)
                rts
; ---------------------------------------------------------------------------
ObjSlot_BubblesBadnik:
                dc.w    2-1
                dc.w    make_art_tile(ArtTile_BubblesBadnik,1,1)
                dc.w    $18,     0
                dc.l    Map_BubblesBadnik
                dc.w    $280
                dc.b    $14, $18,   0,   0
PLCPtr_BubblesBadnik:
                dc.l    ArtUnc_BubblesBadnik
                dc.l    DPLC_BubblesBadnik
S3BubblesBadnik_TurnAnim:
                dc.b    0,  $F
                dc.b    0, $77
                dc.b    1,   3
                dc.b    2,   3
                dc.b    2,   3
                dc.b    1,   3
                dc.b    0, $77
                dc.b    $F4
S3BubblesBadnik_IdleAnim:
                dc.b    0, $7F
                dc.b    3,   3
                dc.b    4, $6B
                dc.b    4, $6B
                dc.b    3,   3
                dc.b    0, $7F
                dc.b    $FC
                even
