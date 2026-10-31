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
                dc.w    loc_5A108-Flybot767_Index
                dc.w    loc_5A126-Flybot767_Index
                dc.w    loc_5A188-Flybot767_Index
                dc.w    loc_5A1D0-Flybot767_Index
                dc.w    loc_5A204-Flybot767_Index
                dc.w    loc_5A248-Flybot767_Index
; ---------------------------------------------------------------------------

loc_5A108:
                lea     ObjSlot_Flybot767(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                move.l  #byte_5A294,$30(a0)
                move.b  #0,child_dx(a0)
                move.b  #-$40,child_dy(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A126:
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
                beq.s   loc_5A156
                cmpi.w  #$60,d2
                blo.s   loc_5A15E

loc_5A156:
                jsr     Change_FlipXWithVelocity(pc)
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_5A15E:
                move.b  #4,routine(a0)
                clr.w   y_vel(a0)
                move.w  y_pos(a0),$44(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #byte_5A2A0,$30(a0)
                move.l  #loc_5A192,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A188:
                jsr     (MoveSprite2).l
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_5A192:
                move.b  #6,routine(a0)
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                move.w  #$200,d1
                bset    #0,render_flags(a0)
                tst.w   d0
                bne.s   loc_5A1B6
                neg.w   d1
                bclr    #0,render_flags(a0)

loc_5A1B6:
                move.w  d1,x_vel(a0)
                move.l  #byte_5A2A9,$30(a0)
                move.w  #$200,y_vel(a0)
                move.w  #$20,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A1D0:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   loc_5A1E4
                jsr     Find_SonicTails(pc)
                tst.w   d1
                beq.s   loc_5A1E8

loc_5A1E4:
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_5A1E8:
                move.b  #8,routine(a0)
                move.l  #byte_5A2B5,$30(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                neg.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A204:
                jsr     (MoveSprite2).l
                move.w  y_pos(a0),d0
                cmp.w   $44(a0),d0
                blo.s   loc_5A21A
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_5A21A:
                move.b  #$A,routine(a0)
                move.l  #byte_5A294,$30(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_5A272,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A248:
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

loc_5A272:
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
byte_5A294:
                dc.b    4,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9, $FC
byte_5A2A0:
                dc.b    2,  $A,  $A,  $B,  $C,  $D,  $E,  $F, $F4
byte_5A2A9:
                dc.b    3, $10, $10, $11, $12, $13
                dc.b    $F8, .jump-byte_5A2A9

                .jump:
                dc.b    3, $13, $13, $FC
byte_5A2B5:
                dc.b    3,  $A,  $A, $14
                dc.b    $F8, .jump-byte_5A2B5

                .jump:
                dc.b    3, $14, $14, $FC
                even
