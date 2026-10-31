; Owner: objects/enemies/cnz/sk
; Responsibility: Sparkle controller and child actors with private attributes and construction data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Sparkle:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Sparkle_Index(pc,d0.w),d1
                jsr     Sparkle_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Sparkle_Index:
                dc.w    loc_891BA-Sparkle_Index
                dc.w    loc_891C2-Sparkle_Index
                dc.w    loc_891EE-Sparkle_Index
                dc.w    loc_8920E-Sparkle_Index
                dc.w    loc_8920E-Sparkle_Index
; ---------------------------------------------------------------------------

loc_891BA:
                lea     ObjDat_Sparkle(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_891C2:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$80,d2
                blo.s   loc_891CE
                rts
; ---------------------------------------------------------------------------

loc_891CE:
                move.b  #4,routine(a0)
                move.l  #byte_89362,$30(a0)
                move.l  #loc_891F2,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)

locret_891EC:
                rts
; ---------------------------------------------------------------------------

loc_891EE:
                jmp     Animate_RawGetFaster(pc)
; ---------------------------------------------------------------------------

loc_891F2:
                move.b  #6,routine(a0)
                move.w  #4,$2E(a0)
                move.l  #loc_89212,$34(a0)
                lea     ChildObjDat_89352(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_8920E:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_89212:
                move.b  #8,routine(a0)
                moveq   #$68,d0
                bchg    #1,render_flags(a0)
                bne.s   loc_89224
                neg.w   d0

loc_89224:
                add.w   d0,y_pos(a0)
                move.w  #$20,$2E(a0)
                move.l  #loc_8924E,$34(a0)
                moveq   #signextendB(sfx_Lightning),d0
                jsr     (Play_SFX).l
                tst.b   render_flags(a0)
                bpl.w   locret_891EC
                lea     ChildObjDat_8935A(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

loc_8924E:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_89256:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_89268(pc,d0.w),d1
                jsr     off_89268(pc,d1.w)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
off_89268:
                dc.w    loc_8926C-off_89268
                dc.w    loc_89298-off_89268
; ---------------------------------------------------------------------------

loc_8926C:
                lea     word_89346(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                bset    #5,shield_reaction(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                movea.w parent3(a0),a1
                moveq   #$34,d0
                btst    #1,render_flags(a1)
                bne.s   loc_89292
                neg.w   d0

loc_89292:
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_89298:
                lea     byte_89367(pc),a1
                jmp     Animate_RawNoSST(pc)
; ---------------------------------------------------------------------------

loc_892A0:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_892B2(pc,d0.w),d1
                jsr     off_892B2(pc,d1.w)
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------
off_892B2:
                dc.w    loc_892B8-off_892B2
                dc.w    loc_892EE-off_892B2
                dc.w    loc_89334-off_892B2
; ---------------------------------------------------------------------------

loc_892B8:
                lea     word_8934C(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                bset    #5,shield_reaction(a0)
                movea.w parent3(a0),a1
                move.w  #$600,d0
                btst    #1,render_flags(a1)
                bne.s   loc_892D8
                neg.w   d0

loc_892D8:
                move.w  d0,y_vel(a0)
                move.w  #$600,d0
                tst.b   subtype(a0)
                bne.s   loc_892E8
                neg.w   d0

loc_892E8:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_892EE:
                lea     byte_89372(pc),a1
                jsr     Animate_RawNoSST(pc)
                moveq   #$40,d0
                move.w  x_vel(a0),d1
                bmi.s   loc_89300
                neg.w   d0

loc_89300:
                add.w   d0,d1
                cmpi.w  #-$100,d1
                blt.s   loc_8930E
                cmpi.w  #$100,d1
                ble.s   loc_89328

loc_8930E:
                move.w  d1,x_vel(a0)
                moveq   #$40,d0
                move.w  y_vel(a0),d1
                bmi.s   loc_8931C
                neg.w   d0

loc_8931C:
                add.w   d0,d1
                move.w  d1,y_vel(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_89328:
                move.b  #4,routine(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_89334:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------
ObjDat_Sparkle:
                dc.l    Map_Sparkle
                dc.w    make_art_tile(ArtTile_Sparkle,1,1)
                dc.w    $280
                dc.b    $C,  $C,   0,  $B
word_89346:
                dc.w    $200
                dc.b    $C, $40,   2, $AB
word_8934C:
                dc.w    $280
                dc.b    8,   8,   6, $98
ChildObjDat_89352:
                dc.w    1-1
                dc.l    loc_89256
                dc.b    0,   0
ChildObjDat_8935A:
                dc.w    2-1
                dc.l    loc_892A0
                dc.b    0,   0
byte_89362:
                dc.b    9, $10
                dc.b    0,   1
                dc.b    $FC
byte_89367:
                dc.b    0,   2,   8,   3,   8,   4,   8,   5,   8,   2, $F4
byte_89372:
                dc.b    3,   6,   7, $FC
                even
