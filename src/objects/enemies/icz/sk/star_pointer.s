; Owner: objects/enemies/icz/sk
; Responsibility: Star Pointer enemy and child motion with private construction data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_StarPointer:
                jsr     (Obj_WaitOffscreen).l
                lea     ObjDat_StarPointer(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_8BE74,(a0)
                bclr    #1,render_flags(a0)
                beq.s   loc_8BE50
                bset    #7,art_tile(a0)

loc_8BE50:
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.w  #6,d0
                move.w  word_8BE6C(pc,d0.w),d4
                jsr     (Set_VelocityXTrackSonic).l
                lea     ChildObjDat_8BFA0(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------
word_8BE6C:
                dc.w    -$40,  -$60,  -$80, -$100
; ---------------------------------------------------------------------------

loc_8BE74:
                jsr     (MoveSprite2).l
                jsr     Find_SonicTails(pc)
                cmpi.w  #$80,d2
                bhs.s   loc_8BE92
                btst    #0,render_flags(a0)
                beq.s   loc_8BE8E
                subq.w  #2,d0

loc_8BE8E:
                tst.w   d0
                beq.s   loc_8BE96

loc_8BE92:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_8BE96:
                move.l  #loc_8BEA6,(a0)
                bset    #1,$38(a0)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_8BEA6:
                jsr     (MoveSprite2).l
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_8BEB0:
                lea     word_8BF9A(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                bset    #3,shield_reaction(a0)
                move.b  #8,x_radius(a0)
                move.l  #loc_8BEE6,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                move.b  byte_8BEE2(pc,d0.w),$3C(a0)
                move.l  #loc_8BF64,$34(a0)
                rts
; ---------------------------------------------------------------------------
byte_8BEE2:
                dc.b    0, $40, $80, $C0
                even
; ---------------------------------------------------------------------------

loc_8BEE6:
                btst    #0,(V_int_run_count+3).w
                bne.s   loc_8BF3E
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                beq.s   loc_8BF02
                addq.b  #1,$3C(a0)
                bra.w   loc_8BF06
; ---------------------------------------------------------------------------

loc_8BF02:
                subq.b  #1,$3C(a0)

loc_8BF06:
                bne.s   loc_8BF3E
                btst    #1,$38(a1)
                beq.s   loc_8BF3E
                move.l  #loc_8BF4C,(a0)
                move.w  x_vel(a1),d0
                asl.w   #1,d0
                move.l  #ObjHitWall_DoRoutine,$30(a0)
                move.w  #8,$44(a0)
                move.w  d0,x_vel(a0)
                bpl.s   loc_8BF3E
                move.l  #ObjHitWall2_DoRoutine,$30(a0)
                move.w  #-8,$44(a0)

loc_8BF3E:
                bsr.w   RunStarPointerSpikeCallbackWhenCollisionCleared
                moveq   #4,d2
                jsr     MoveSprite_CircularSimple(pc)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

loc_8BF4C:
                jsr     (MoveSprite2).l
                movea.l $30(a0),a1
                move.w  $44(a0),d3
                jsr     (a1)
                bsr.w   RunStarPointerSpikeCallbackWhenCollisionCleared
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------

loc_8BF64:
                move.l  #loc_8BF74,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8BF74:
                lea     byte_8BFA8(pc),a1
                jsr     Animate_RawNoSST(pc)
                jmp     Sprite_CheckDeleteTouchXY(pc)

; =============== S U B R O U T I N E =======================================

RunStarPointerSpikeCallbackWhenCollisionCleared:
                tst.b   collision_flags(a0)
                bne.s   locret_8BF8C
                movea.l $34(a0),a1
                jsr     (a1)

locret_8BF8C:
                rts
; End of function RunStarPointerSpikeCallbackWhenCollisionCleared

; ---------------------------------------------------------------------------
ObjDat_StarPointer:
                dc.l    Map_StarPointer
                dc.w    make_art_tile(ArtTile_StarPointer,1,0)
                dc.w    $280
                dc.b    8,   8,   0,  $B
word_8BF9A:
                dc.w    $280
                dc.b    8,   8,   1, $8B
ChildObjDat_8BFA0:
                dc.w    4-1
                dc.l    loc_8BEB0
                dc.b    0,   0
byte_8BFA8:
                dc.b    3,   1,   2,   3, $F4
                even
