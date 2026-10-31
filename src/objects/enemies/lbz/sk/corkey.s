; Owner: objects/enemies/lbz/sk
; Responsibility: Corkey flying enemy, spawned projectiles and private construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Corkey:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Corkey_Index(pc,d0.w),d1
                jsr     Corkey_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Corkey_Index:
                dc.w    loc_8C746-Corkey_Index
                dc.w    loc_8C79C-Corkey_Index
                dc.w    loc_8C7CC-Corkey_Index
; ---------------------------------------------------------------------------

loc_8C746:
                lea     ObjDat_Corkey(pc),a1
                jsr     (SetUp_ObjAttributes).l
                moveq   #-1,d0
                btst    #0,render_flags(a0)
                beq.s   loc_8C75C
                neg.w   d0

loc_8C75C:
                move.w  d0,$40(a0)
                move.b  subtype(a0),d0
                move.b  d0,$2F(a0)
                move.l  #loc_8C7BC,$34(a0)
                add.b   d0,d0
                move.b  d0,subtype(a0)
                lea     ChildObjDat_8C90E(pc),a2
                jsr     (CreateChild1_Normal).l

loc_8C780:
                jsr     (Random_Number).l
                andi.w  #$3F,d0
                move.w  d0,d1
                andi.w  #$30,d1
                bne.s   loc_8C796
                ori.w   #$30,d0

loc_8C796:
                move.w  d0,$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_8C79C:
                subq.w  #1,$3A(a0)
                bmi.s   loc_8C7AE
                move.w  $40(a0),d0
                add.w   d0,x_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_8C7AE:
                move.b  #4,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_8C7BC:
                neg.w   $40(a0)
                clr.b   $2E(a0)
                move.b  subtype(a0),$2F(a0)
                rts
; ---------------------------------------------------------------------------

loc_8C7CC:
                btst    #1,$38(a0)
                beq.s   loc_8C7D6
                rts
; ---------------------------------------------------------------------------

loc_8C7D6:
                move.b  #2,routine(a0)
                bra.s   loc_8C780
; ---------------------------------------------------------------------------

loc_8C7DE:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_8C7F0(pc,d0.w),d1
                jsr     off_8C7F0(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_8C7F0:
                dc.w    loc_8C7F8-off_8C7F0
                dc.w    loc_8C802-off_8C7F0
                dc.w    loc_8C82C-off_8C7F0
                dc.w    loc_8C8A8-off_8C7F0
; ---------------------------------------------------------------------------

loc_8C7F8:
                lea     word_8C900(pc),a1
                jmp     (SetUp_ObjAttributes3).l
; ---------------------------------------------------------------------------

loc_8C802:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   locret_8C82A
                move.b  #4,routine(a0)
                move.l  #loc_8C88C,$34(a0)
                move.l  #byte_8C92E,$30(a0)

locret_8C82A:
                rts
; ---------------------------------------------------------------------------

loc_8C82C:
                jsr     (Animate_RawGetFaster).l
                tst.w   d2
                bpl.s   locret_8C84E
                cmpi.b  #4,$2F(a0)
                beq.s   loc_8C850
                cmpi.b  #5,$2F(a0)
                beq.s   loc_8C864
                cmpi.b  #6,$2F(a0)
                beq.s   loc_8C878

locret_8C84E:
                rts
; ---------------------------------------------------------------------------

loc_8C850:
                lea     ChildObjDat_8C916(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #byte_8C933,$30(a1)
                rts
; ---------------------------------------------------------------------------

loc_8C864:
                lea     ChildObjDat_8C91E(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #byte_8C93C,$30(a1)
                rts
; ---------------------------------------------------------------------------

loc_8C878:
                lea     ChildObjDat_8C926(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #byte_8C945,$30(a1)
                rts
; ---------------------------------------------------------------------------

loc_8C88C:
                move.b  #6,routine(a0)
                move.b  #2,mapping_frame(a0)
                move.w  #7,$2E(a0)
                move.l  #loc_8C8AE,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8C8A8:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_8C8AE:
                move.b  #2,routine(a0)
                move.b  #1,mapping_frame(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_8C8C6:
                lea     word_8C906(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_8C8E6,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                moveq   #signextendB(sfx_Laser),d0
                jsr     (Play_SFX).l

loc_8C8E6:
                addq.w  #1,$3A(a0)
                jsr     (Animate_RawMultiDelay).l
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
ObjDat_Corkey:
                dc.l    Map_Corkey
                dc.w    make_art_tile(ArtTile_Corkey,1,0)
                dc.w    $280
                dc.b    $10,  $C,   0,  $B
word_8C900:
                dc.w    $280
                dc.b    8,   4,   1,   0
word_8C906:
                dc.w    make_art_tile(ArtTile_Corkey,0,0)
                dc.w    $280
                dc.b    4, $50,   0, $A0
ChildObjDat_8C90E:
                dc.w    1-1
                dc.l    loc_8C7DE
                dc.b    0,  $C
ChildObjDat_8C916:
                dc.w    1-1
                dc.l    loc_8C8C6
                dc.b    -4, $54
ChildObjDat_8C91E:
                dc.w    1-1
                dc.l    loc_8C8C6
                dc.b    4, $54
ChildObjDat_8C926:
                dc.w    1-1
                dc.l    loc_8C8C6
                dc.b    0, $54
byte_8C92E:
                dc.b    7, $10
                dc.b    1,   3
                dc.b    $FC
byte_8C933:
                dc.b    6,   0
                dc.b    6,   0
                dc.b    7,   4
                dc.b    5,   0
                dc.b    $F4
byte_8C93C:
                dc.b    5,   0
                dc.b    5,   0
                dc.b    7,   4
                dc.b    6,   0
                dc.b    $F4
byte_8C945:
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    6,   3
                dc.b    $F4
                even
