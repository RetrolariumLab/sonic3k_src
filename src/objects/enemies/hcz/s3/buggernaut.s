; Owner: objects/enemies/hcz/s3
; Responsibility: Buggernaut parent and baby flight states with private movement, animation and child records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Buggernaut:
                jsr     (Obj_WaitOffscreen).l

Obj_Buggernaut_2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Buggernaut_Index(pc,d0.w),d1
                jsr     Buggernaut_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Buggernaut_Index:
                dc.w    loc_55828-Buggernaut_Index
                dc.w    loc_5585A-Buggernaut_Index
                dc.w    loc_55878-Buggernaut_Index
; ---------------------------------------------------------------------------

loc_55828:
                lea     ObjDat_Buggernaut(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AniRaw_Buggernaut,$30(a0)
                lea     ChildObjDat_Buggernaught_Baby(pc),a2
                jsr     CreateChild1_Normal(pc)
                addq.b  #1,$39(a0)

loc_55844:
                move.b  #2,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_55862,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5585A:
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_55862:
                move.b  #4,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_55844,$34(a0)

locret_55876:
                rts
; ---------------------------------------------------------------------------

loc_55878:
                tst.b   render_flags(a0)
                bpl.s   locret_55876
                jsr     Find_SonicTails(pc)
                jsr     Change_FlipX(pc)
                move.w  #$200,d0
                moveq   #$10,d1
                jsr     Chase_Object(pc)
                bsr.w   sub_5596E
                jsr     (MoveSprite2).l
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Obj_Buggernaught_Baby:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Buggernaught_Baby_Index(pc,d0.w),d1
                jsr     Buggernaught_Baby_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------
Buggernaught_Baby_Index:
                dc.w    loc_558BA-Buggernaught_Baby_Index
                dc.w    loc_558CC-Buggernaught_Baby_Index
                dc.w    loc_55932-Buggernaught_Baby_Index
; ---------------------------------------------------------------------------

loc_558BA:
                lea     ObjDat3_Buggernaught_Baby(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #AniRaw_Buggernaut_Baby,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_558CC:
                jsr     Animate_Raw(pc)
                movea.w parent3(a0),a1
                cmpi.l  #Obj_Buggernaut_2,(a1)
                beq.s   loc_558E2
                bsr.w   sub_5593C
                beq.s   loc_5590A

loc_558E2:
                bclr    #0,render_flags(a0)
                btst    #0,render_flags(a1)
                beq.s   loc_558F6
                bset    #0,render_flags(a0)

loc_558F6:
                move.w  #$200,d0
                moveq   #$20,d1
                jsr     Chase_Object(pc)
                bsr.w   sub_5596E
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_5590A:
                move.b  #4,routine(a0)
                move.w  x_pos(a0),d0
                move.w  #$200,d1
                bset    #0,render_flags(a0)
                cmp.w   (Player_1+x_pos).w,d0
                bhs.s   loc_5592C
                neg.w   d1
                bclr    #0,render_flags(a0)

loc_5592C:
                move.w  d1,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_55932:
                jsr     Animate_Raw(pc)
                jmp     (MoveSprite2).l

; =============== S U B R O U T I N E =======================================

sub_5593C:
                lea     (Dynamic_object_RAM+object_size).w,a2
                move.w  #((Breathing_bubbles)-(Dynamic_object_RAM+object_size))/object_size-1,d0

loc_55944:
                cmpi.l  #Obj_Buggernaut_2,(a2)
                beq.s   loc_55958

loc_5594C:
                lea     next_object(a2),a2
                dbf     d0,loc_55944
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

loc_55958:
                move.b  $39(a2),d1
                addq.b  #1,d1
                cmpi.b  #4,d1
                bhi.s   loc_5594C
                move.b  d1,$39(a2)
                move.w  a2,parent3(a0)
                rts
; End of function sub_5593C

; =============== S U B R O U T I N E =======================================

sub_5596E:
                move.w  y_pos(a0),d0
                move.w  (Water_level).w,d1
                subi.w  #8,d1
                cmp.w   d1,d0
                blo.s   locret_55984
                move.w  #-$200,y_vel(a0)

locret_55984:
                rts
; End of function sub_5596E

; ---------------------------------------------------------------------------
ObjDat_Buggernaut:
                dc.l    Map_Buggernaut
                dc.w    make_art_tile(ArtTile_Buggernaut,1,1)
                dc.w    $280
                dc.b    $10,  $C,   0, $17
ObjDat3_Buggernaught_Baby:
                dc.w    $280
                dc.b    $C,  $C,   3,   0
ChildObjDat_Buggernaught_Baby:
                dc.w    1-1
                dc.l    Obj_Buggernaught_Baby
                dc.b    $20,   0
AniRaw_Buggernaut:
                dc.b    0,   0,   1,   2, $FC
AniRaw_Buggernaut_Baby:
                dc.b    0,   3,   4,   5, $FC
                even
