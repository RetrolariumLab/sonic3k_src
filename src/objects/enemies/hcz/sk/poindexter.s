; Owner: objects/enemies/hcz/sk
; Responsibility: Poindexter launch and attack states with private attributes and animation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Poindexter:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Poindexter_Index(pc,d0.w),d1
                jsr     Poindexter_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Poindexter_Index:
                dc.w    loc_88298-Poindexter_Index
                dc.w    loc_882E6-Poindexter_Index
; ---------------------------------------------------------------------------

loc_88298:
                lea     ObjDat_Poindexter(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AniRaw_Poindexter,$30(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                add.w   d0,d0
                move.w  d0,$2E(a0)
                add.w   d0,d0
                move.w  d0,$3A(a0)
                move.l  #loc_8830E,$34(a0)
                move.w  #-$40,d4
                jsr     Set_VelocityXTrackSonic(pc)
                move.w  #$20,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #1,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_882E6:
                jsr     Swing_UpAndDown(pc)
                jsr     (MoveSprite2).l
                jsr     Animate_RawMultiDelay(pc)
                jsr     Obj_Wait(pc)
                move.b  #$A,collision_flags(a0)
                cmpi.b  #2,mapping_frame(a0)
                bne.s   locret_8830C
                move.b  #$86,collision_flags(a0)

locret_8830C:
                rts
; ---------------------------------------------------------------------------

loc_8830E:
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  $3A(a0),$2E(a0)
                rts
; ---------------------------------------------------------------------------
ObjDat_Poindexter:
                dc.l    Map_Poindexter
                dc.w    make_art_tile(ArtTile_Pointdexter,1,1)
                dc.w    $280
                dc.b    $14, $14,   0,   0
AniRaw_Poindexter:
                dc.b    0, $7F
                dc.b    1,   4
                dc.b    2, $3F
                dc.b    1,   4
                dc.b    $FC
                even
