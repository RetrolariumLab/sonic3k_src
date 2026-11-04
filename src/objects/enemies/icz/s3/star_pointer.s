; Owner: objects/enemies/icz/s3
; Responsibility: Star Pointer enemy and child motion with private construction data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_StarPointer:
                jsr     (Obj_WaitOffscreen).l
                lea     ObjDat_StarPointer(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_5960C,(a0)
                bclr    #1,render_flags(a0)
                beq.s   loc_595E8
                bset    #7,art_tile(a0)

loc_595E8:
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.w  #6,d0
                move.w  word_59604(pc,d0.w),d4
                jsr     (Set_VelocityXTrackSonic).l
                lea     ChildObjDat_59738(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------
word_59604:
                dc.w    -$40,  -$60,  -$80, -$100
; ---------------------------------------------------------------------------

loc_5960C:
                jsr     (MoveSprite2).l
                jsr     Find_SonicTails(pc)
                cmpi.w  #$80,d2
                bhs.s   loc_5962A
                btst    #0,render_flags(a0)
                beq.s   loc_59626
                subq.w  #2,d0

loc_59626:
                tst.w   d0
                beq.s   loc_5962E

loc_5962A:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_5962E:
                move.l  #loc_5963E,(a0)
                bset    #1,$38(a0)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_5963E:
                jsr     (MoveSprite2).l
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_59648:
                lea     word_59732(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                bset    #3,shield_reaction(a0)
                move.b  #8,x_radius(a0)
                move.l  #loc_5967E,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                move.b  byte_5967A(pc,d0.w),$3C(a0)
                move.l  #loc_596FC,$34(a0)
                rts
; ---------------------------------------------------------------------------
byte_5967A:
                dc.b    0, $40, $80, $C0
                even
; ---------------------------------------------------------------------------

loc_5967E:
                btst    #0,(V_int_run_count+3).w
                bne.s   loc_596D6
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                beq.s   loc_5969A
                addq.b  #1,$3C(a0)
                bra.w   loc_5969E
; ---------------------------------------------------------------------------

loc_5969A:
                subq.b  #1,$3C(a0)

loc_5969E:
                bne.s   loc_596D6
                btst    #1,$38(a1)
                beq.s   loc_596D6
                move.l  #loc_596E4,(a0)
                move.w  x_vel(a1),d0
                asl.w   #1,d0
                move.l  #ObjHitWall_DoRoutine,$30(a0)
                move.w  #8,$44(a0)
                move.w  d0,x_vel(a0)
                bpl.s   loc_596D6
                move.l  #ObjHitWall2_DoRoutine,$30(a0)
                move.w  #-8,$44(a0)

loc_596D6:
                bsr.w   StarPointerSpike_CheckHitCallback
                moveq   #4,d2
                jsr     MoveSprite_CircularSimple(pc)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_596E4:
                jsr     (MoveSprite2).l
                movea.l $30(a0),a1
                move.w  $44(a0),d3
                jsr     (a1)
                bsr.w   StarPointerSpike_CheckHitCallback
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------

loc_596FC:
                move.l  #loc_5970C,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5970C:
                lea     byte_59740(pc),a1
                jsr     Animate_RawNoSST(pc)
                jmp     Sprite_CheckDeleteTouchXY(pc)

; =============== S U B R O U T I N E =======================================

; Run the stored callback when the collision byte is clear. The callback selects the vanish or deletion path
StarPointerSpike_CheckHitCallback:
                tst.b   collision_flags(a0)
                bne.s   locret_59724
                movea.l $34(a0),a1
                jsr     (a1)

locret_59724:
                rts
; End of function StarPointerSpike_CheckHitCallback

; ---------------------------------------------------------------------------
ObjDat_StarPointer:
                dc.l    Map_StarPointer
                dc.w    make_art_tile(ArtTile_StarPointer,1,0)
                dc.w    $280
                dc.b    8,   8,   0,  $B
word_59732:
                dc.w    $280
                dc.b    8,   8,   1, $8B
ChildObjDat_59738:
                dc.w    4-1
                dc.l    loc_59648
                dc.b    0,   0
byte_59740:
                dc.b    3,   1,   2,   3, $F4
                even
