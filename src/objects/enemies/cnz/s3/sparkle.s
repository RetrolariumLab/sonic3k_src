; Owner: objects/enemies/cnz/s3
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
                dc.w    loc_56F6E-Sparkle_Index
                dc.w    loc_56F76-Sparkle_Index
                dc.w    loc_56FA2-Sparkle_Index
                dc.w    loc_56FC2-Sparkle_Index
                dc.w    loc_56FC2-Sparkle_Index
; ---------------------------------------------------------------------------

loc_56F6E:
                lea     ObjDat_Sparkle(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_56F76:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$80,d2
                blo.s   loc_56F82
                rts
; ---------------------------------------------------------------------------

loc_56F82:
                move.b  #4,routine(a0)
                move.l  #byte_57116,$30(a0)
                move.l  #loc_56FA6,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)

locret_56FA0:
                rts
; ---------------------------------------------------------------------------

loc_56FA2:
                jmp     Animate_RawGetFaster(pc)
; ---------------------------------------------------------------------------

loc_56FA6:
                move.b  #6,routine(a0)
                move.w  #4,$2E(a0)
                move.l  #loc_56FC6,$34(a0)
                lea     ChildObjDat_57106(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_56FC2:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_56FC6:
                move.b  #8,routine(a0)
                moveq   #$68,d0
                bchg    #1,render_flags(a0)
                bne.s   loc_56FD8
                neg.w   d0

loc_56FD8:
                add.w   d0,y_pos(a0)
                move.w  #$20,$2E(a0)
                move.l  #loc_57002,$34(a0)
                moveq   #signextendB(sfx_Lightning),d0
                jsr     (Play_SFX).l
                tst.b   render_flags(a0)
                bpl.w   locret_56FA0
                lea     ChildObjDat_5710E(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

loc_57002:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_5700A:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5701C(pc,d0.w),d1
                jsr     off_5701C(pc,d1.w)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
off_5701C:
                dc.w    loc_57020-off_5701C
                dc.w    loc_5704C-off_5701C
; ---------------------------------------------------------------------------

loc_57020:
                lea     word_570FA(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                bset    #5,shield_reaction(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                movea.w parent3(a0),a1
                moveq   #$34,d0
                btst    #1,render_flags(a1)
                bne.s   loc_57046
                neg.w   d0

loc_57046:
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_5704C:
                lea     byte_5711B(pc),a1
                jmp     Animate_RawNoSST(pc)
; ---------------------------------------------------------------------------

loc_57054:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_57066(pc,d0.w),d1
                jsr     off_57066(pc,d1.w)
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------
off_57066:
                dc.w    loc_5706C-off_57066
                dc.w    loc_570A2-off_57066
                dc.w    loc_570E8-off_57066
; ---------------------------------------------------------------------------

loc_5706C:
                lea     word_57100(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                bset    #5,shield_reaction(a0)
                movea.w parent3(a0),a1
                move.w  #$600,d0
                btst    #1,render_flags(a1)
                bne.s   loc_5708C
                neg.w   d0

loc_5708C:
                move.w  d0,y_vel(a0)
                move.w  #$600,d0
                tst.b   subtype(a0)
                bne.s   loc_5709C
                neg.w   d0

loc_5709C:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_570A2:
                lea     byte_57126(pc),a1
                jsr     Animate_RawNoSST(pc)
                moveq   #$40,d0
                move.w  x_vel(a0),d1
                bmi.s   loc_570B4
                neg.w   d0

loc_570B4:
                add.w   d0,d1
                cmpi.w  #-$100,d1
                blt.s   loc_570C2
                cmpi.w  #$100,d1
                ble.s   loc_570DC

loc_570C2:
                move.w  d1,x_vel(a0)
                moveq   #$40,d0
                move.w  y_vel(a0),d1
                bmi.s   loc_570D0
                neg.w   d0

loc_570D0:
                add.w   d0,d1
                move.w  d1,y_vel(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_570DC:
                move.b  #4,routine(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_570E8:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------
ObjDat_Sparkle:
                dc.l    Map_Sparkle
                dc.w    make_art_tile(ArtTile_Sparkle,1,1)
                dc.w    $280
                dc.b    $C,  $C,   0,  $B
word_570FA:
                dc.w    $200
                dc.b    $C, $40,   2, $AB
word_57100:
                dc.w    $280
                dc.b    8,   8,   6, $98
ChildObjDat_57106:
                dc.w    1-1
                dc.l    loc_5700A
                dc.b    0,   0
ChildObjDat_5710E:
                dc.w    2-1
                dc.l    loc_57054
                dc.b    0,   0
byte_57116:
                dc.b    9, $10
                dc.b    0,   1
                dc.b    $FC
byte_5711B:
                dc.b    0,   2,   8,   3,   8,   4,   8,   5,   8,   2, $F4
byte_57126:
                dc.b    3,   6,   7, $FC
                even
