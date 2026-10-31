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
                dc.w    loc_574DA-Technosqueek_Index
                dc.w    loc_57574-Technosqueek_Index
                dc.w    loc_575C6-Technosqueek_Index
                dc.w    loc_575F4-Technosqueek_Index
                dc.w    loc_57638-Technosqueek_Index
; ---------------------------------------------------------------------------

loc_574DA:
                move.w  #$800,$2E(a0)
                move.l  #loc_575BE,$34(a0)
                cmpi.b  #4,subtype(a0)
                beq.s   loc_57536
                lea     ObjDat_576F2(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #byte_57718,$30(a0)
                bset    #0,render_flags(a0)
                cmpi.b  #2,subtype(a0)
                bne.s   loc_57514
                bset    #1,render_flags(a0)

loc_57514:
                lea     ChildObjDat_57710(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.w  #$400,d0
                move.w  d0,$3A(a0)
                move.w  d0,x_vel(a0)
                move.w  #$20,$3C(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_57536:
                lea     ObjDat3_576FE(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #6,routine(a0)
                move.l  #byte_5773E,$30(a0)
                bset    #1,render_flags(a0)
                lea     ChildObjDat_57710(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.w  #$400,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$20,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_57574:
                jsr     Animate_RawMultiDelayFlipX(pc)
                tst.w   d2
                beq.s   loc_5758A
                cmpi.b  #6,anim_frame(a0)
                bne.s   loc_5758A
                bset    #1,$38(a0)

loc_5758A:
                jsr     Swing_LeftAndRight(pc)
                tst.w   x_vel(a0)
                beq.s   loc_5759E
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5759E:
                move.b  #4,routine(a0)
                move.l  #byte_5772E,$30(a0)
                move.l  #loc_575CA,$34(a0)

loc_575B4:
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_575BE:
                bclr    #5,$38(a0)

locret_575C4:
                rts
; ---------------------------------------------------------------------------

loc_575C6:
                jmp     Animate_RawAdjustFlipX(pc)
; ---------------------------------------------------------------------------

loc_575CA:
                move.b  #2,routine(a0)
                move.l  #byte_57723,$30(a0)

loc_575D8:
                bclr    #1,$38(a0)
                bset    #5,$38(a0)
                move.w  #$10,$2E(a0)
                move.l  #loc_575BE,$34(a0)
                bra.s   loc_575B4
; ---------------------------------------------------------------------------

loc_575F4:
                jsr     Animate_RawMultiDelayFlipY(pc)
                tst.w   d2
                beq.s   loc_5760A
                cmpi.b  #6,anim_frame(a0)
                bne.s   loc_5760A
                bset    #1,$38(a0)

loc_5760A:
                jsr     Swing_UpAndDown(pc)
                tst.w   y_vel(a0)
                beq.s   loc_5761E
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5761E:
                move.b  #8,routine(a0)
                move.l  #byte_57754,$30(a0)
                move.l  #loc_5763C,$34(a0)
                bra.w   loc_575B4
; ---------------------------------------------------------------------------

loc_57638:
                jmp     Animate_RawAdjustFlipY(pc)
; ---------------------------------------------------------------------------

loc_5763C:
                move.b  #6,routine(a0)
                move.l  #byte_57749,$30(a0)
                bra.s   loc_575D8
; ---------------------------------------------------------------------------

loc_5764C:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5765E(pc,d0.w),d1
                jsr     off_5765E(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_5765E:
                dc.w    loc_57664-off_5765E
                dc.w    loc_57680-off_5765E
                dc.w    loc_576B8-off_5765E
; ---------------------------------------------------------------------------

loc_57664:
                lea     word_5770A(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                movea.w parent3(a0),a1
                cmpi.b  #4,subtype(a1)
                bne.s   locret_5767E
                move.b  #4,routine(a0)

locret_5767E:
                rts
; ---------------------------------------------------------------------------

loc_57680:
                lea     byte_57739(pc),a1
                jsr     Animate_RawNoSST(pc)
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                btst    #1,$38(a1)
                beq.s   loc_5769C
                moveq   #2,d0

loc_5769C:
                add.w   d0,d0
                move.w  byte_576B2(pc,d0.w),child_dx(a0)  ; and child_dy
                btst    #5,$38(a1)
                bne.w   locret_575C4
                jmp     Refresh_ChildPositionAdjusted(pc)
; ---------------------------------------------------------------------------
byte_576B2:
                dc.b    $14,   4
                dc.b    $C,   4
                dc.b    0,   4
                even
; ---------------------------------------------------------------------------

loc_576B8:
                lea     byte_5775F(pc),a1
                jsr     Animate_RawNoSST(pc)
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                subq.w  #5,d0
                btst    #1,$38(a1)
                beq.s   loc_576D6
                moveq   #2,d0

loc_576D6:
                add.w   d0,d0
                move.w  byte_576EC(pc,d0.w),child_dx(a0)  ; and child_dy
                btst    #5,$38(a1)
                bne.w   locret_575C4
                jmp     Refresh_ChildPositionAdjusted(pc)
; ---------------------------------------------------------------------------
byte_576EC:
                dc.b    -4, $14
                dc.b    -4,  $C
                dc.b    -4,   0
                even
ObjDat_576F2:
                dc.l    Map_TechnoSqueek
                dc.w    make_art_tile(ArtTile_Technosqueek-6,1,1)
                dc.w    $280
                dc.b    $C,   8,   0,  $B
ObjDat3_576FE:
                dc.l    Map_TechnoSqueek
                dc.w    make_art_tile(ArtTile_Technosqueek-6,1,1)
                dc.w    $280
                dc.b    8,  $C,   5,  $B
word_5770A:
                dc.w    $280
                dc.b    8,   4,   2,   0
ChildObjDat_57710:
                dc.w    1-1
                dc.l    loc_5764C
                dc.b    $14,   4
byte_57718:
                dc.b    0,       0
                dc.b    0,     $17
                dc.b    1,       1
                dc.b    1|$40,   1
                dc.b    0,     $1F
                dc.b    $F4
byte_57723:
                dc.b    0,       0
                dc.b    0,     $37
                dc.b    1,       1
                dc.b    1|$40,   1
                dc.b    0,     $1F
                dc.b    $F4
byte_5772E:
                dc.b    3,   0,   0,   1, 1|$40,   0,   0,   1, 1|$40,   0, $F4
byte_57739:
                dc.b    3,   2,   3,   4, $FC
byte_5773E:
                dc.b    5,       0
                dc.b    5,     $17
                dc.b    6,       1
                dc.b    6|$20,   1
                dc.b    0,     $1F
                dc.b    $F4
byte_57749:
                dc.b    5,       0
                dc.b    5,     $37
                dc.b    6,       1
                dc.b    6|$20,   1
                dc.b    5,     $1F
                dc.b    $F4
byte_57754:
                dc.b    3,   5,   5,   6, 6|$20,   5,   5,   6, 6|$20,   5, $F4
byte_5775F:
                dc.b    3,   7,   8,   9, $FC
                even
