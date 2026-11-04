; Owner: objects/enemies/lbz/s3
; Responsibility: Flybot 767 flight and attack states with tracking-slot and pattern resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Flybot767:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Flybot767_Index(pc,d0.w),d1
                jsr     Flybot767_Index(pc,d1.w)
                lea     DPLCPtr_Flybot767(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     (Sprite_CheckDeleteTouchSlotted).l
; ---------------------------------------------------------------------------
Flybot767_Index:
                dc.w    S3Flybot767_InitSlotsAndChaseOffset-Flybot767_Index
                dc.w    S3Flybot767_ChaseP1AndTryDive-Flybot767_Index
                dc.w    S3Flybot767_MoveDuringWindup-Flybot767_Index
                dc.w    S3Flybot767_DiveAndCheckRecovery-Flybot767_Index
                dc.w    S3Flybot767_RiseToEntryHeight-Flybot767_Index
                dc.w    S3Flybot767_ChaseDuringCooldown-Flybot767_Index
; ---------------------------------------------------------------------------

S3Flybot767_InitSlotsAndChaseOffset:
                lea     ObjSlot_Flybot767(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                move.l  #S3Flybot767_ChaseAnim,$30(a0)
                move.b  #0,child_dx(a0)
                move.b  #-$40,child_dy(a0)
                rts
; ---------------------------------------------------------------------------

S3Flybot767_ChaseP1AndTryDive:
                lea     (Player_1).w,a1
                move.w  #$200,d0
                moveq   #$10,d1
                jsr     Chase_ObjectXOnly(pc)
                move.w  #$100,d0
                moveq   #$10,d1
                jsr     Chase_ObjectYOnly(pc)
                jsr     (MoveSprite2).l
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                tst.w   d1
                beq.s   S3Flybot767_FaceMotionAndAnimate
                cmpi.w  #$60,d2
                blo.s   S3Flybot767_BeginDiveWindup

S3Flybot767_FaceMotionAndAnimate:
                jsr     Change_FlipXWithVelocity(pc)
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

S3Flybot767_BeginDiveWindup:
                move.b  #4,routine(a0)
                clr.w   y_vel(a0)
                move.w  y_pos(a0),$44(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #S3Flybot767_DiveWindupAnim,$30(a0)
                move.l  #S3Flybot767_ChooseDiveDirection,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3Flybot767_MoveDuringWindup:
                jsr     (MoveSprite2).l
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

S3Flybot767_ChooseDiveDirection:
                move.b  #6,routine(a0)
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                move.w  #$200,d1
                bset    #0,render_flags(a0)
                tst.w   d0
                bne.s   S3Flybot767_SetDiveSpeedAndDelay
                neg.w   d1
                bclr    #0,render_flags(a0)

S3Flybot767_SetDiveSpeedAndDelay:
                move.w  d1,x_vel(a0)
                move.l  #S3Flybot767_DescentAnim,$30(a0)
                move.w  #$200,y_vel(a0)
                move.w  #$20,$2E(a0)
                rts
; ---------------------------------------------------------------------------

S3Flybot767_DiveAndCheckRecovery:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   S3Flybot767_AnimateDescent
                jsr     Find_SonicTails(pc)
                tst.w   d1
                beq.s   S3Flybot767_BeginAscent

S3Flybot767_AnimateDescent:
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

S3Flybot767_BeginAscent:
                move.b  #8,routine(a0)
                move.l  #S3Flybot767_AscentAnim,$30(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                neg.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3Flybot767_RiseToEntryHeight:
                jsr     (MoveSprite2).l
                move.w  y_pos(a0),d0
                cmp.w   $44(a0),d0
                blo.s   S3Flybot767_BeginChaseCooldown
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

S3Flybot767_BeginChaseCooldown:
                move.b  #$A,routine(a0)
                move.l  #S3Flybot767_ChaseAnim,$30(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #S3Flybot767_RearmDiveCheck,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3Flybot767_ChaseDuringCooldown:
                lea     (Player_1).w,a1
                move.w  #$200,d0
                moveq   #$10,d1
                jsr     Chase_ObjectXOnly(pc)
                move.w  #$100,d0
                moveq   #$10,d1
                jsr     Chase_ObjectYOnly(pc)
                jsr     (MoveSprite2).l
                jsr     Change_FlipXWithVelocity(pc)
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

S3Flybot767_RearmDiveCheck:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------
ObjSlot_Flybot767:
                dc.w    3-1
                dc.w    make_art_tile(ArtTile_Flybot767,1,1)
                dc.w    $C,     0
                dc.l    Map_Flybot767
                dc.w    $280
                dc.b    $10, $10,   0, $1A
DPLCPtr_Flybot767:
                dc.l    ArtUnc_Flybot767
                dc.l    DPLC_Flybot767
S3Flybot767_ChaseAnim:
                dc.b    4,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9, $FC
S3Flybot767_DiveWindupAnim:
                dc.b    2,  $A,  $A,  $B,  $C,  $D,  $E,  $F, $F4
S3Flybot767_DescentAnim:
                dc.b    3, $10, $10, $11, $12, $13
                dc.b    $F8, .jump-S3Flybot767_DescentAnim

                .jump:
                dc.b    3, $13, $13, $FC
S3Flybot767_AscentAnim:
                dc.b    3,  $A,  $A, $14
                dc.b    $F8, .jump-S3Flybot767_AscentAnim

                .jump:
                dc.b    3, $14, $14, $FC
                even
