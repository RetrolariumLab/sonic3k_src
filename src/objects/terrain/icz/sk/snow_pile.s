; Owner: objects/terrain/icz/sk
; Responsibility: IceCap snow-pile controller, thrown snow, child helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZSnowPile:
                jsr     Obj_WaitOffscreen(pc)
                moveq   #0,d0
                move.b  subtype(a0),d0
                bclr    #7,d0
                lea     off_8B7F4(pc),a1
                lea     (a1,d0.w),a2
                move.l  (a2)+,(a0)
                movea.l (a2)+,a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_8B56E:
                lea     word_8B590(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   loc_8B58C
                tst.w   d0
                beq.s   loc_8B582
                bsr.w   sub_8B598

loc_8B582:
                swap    d0
                tst.w   d0
                beq.s   loc_8B58C
                bsr.w   sub_8B598

loc_8B58C:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
word_8B590:
                dc.w    -$28,   $50,  -$18,   $20

; =============== S U B R O U T I N E =======================================

sub_8B598:
                movea.w d0,a3
                move.w  d0,$44(a0)
                cmpi.b  #9,anim(a3)
                beq.s   loc_8B5C6
                btst    #Status_InAir,status(a3)
                bne.s   locret_8B5C4
                move.w  x_vel(a3),d2
                move.w  d2,d3
                bpl.s   loc_8B5B8
                neg.w   d2

loc_8B5B8:
                cmpi.w  #$600,d2
                bhs.s   loc_8B5C6
                asr.w   #1,d3
                move.w  d3,ground_vel(a3)

locret_8B5C4:
                rts
; ---------------------------------------------------------------------------

loc_8B5C6:
                move.w  a3,$44(a0)
                lea     ChildObjDat_8B84C(pc),a2
                jsr     CreateChild1_Normal(pc)
                jsr     (Go_Delete_Sprite).l
                addq.w  #4,sp

locret_8B5DA:
                rts
; End of function sub_8B598

; ---------------------------------------------------------------------------

loc_8B5DC:
                lea     word_8B60E(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.w   d0
                bne.s   loc_8B5EC
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

loc_8B5EC:
                move.w  d0,$44(a0)
                beq.s   loc_8B608
                movea.w d0,a1
                move.w  #$800,x_vel(a1)
                move.w  #$800,ground_vel(a1)
                lea     ChildObjDat_8B872(pc),a2
                jsr     CreateChild1_Normal(pc)

loc_8B608:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
word_8B60E:
                dc.w    -8,   $10,  -$10,   $20
; ---------------------------------------------------------------------------

loc_8B616:
                lea     word_8B658(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.w   d0
                bne.s   loc_8B626
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_8B626:
                move.w  d0,$44(a0)
                beq.s   loc_8B652
                movea.w d0,a1
                move.w  #$800,x_vel(a1)
                move.w  #$800,ground_vel(a1)
                lea     ChildObjDat_8B880(pc),a2
                jsr     CreateChild1_Normal(pc)
                btst    #7,subtype(a0)
                beq.s   loc_8B652
                move.w  #$600,d0
                jsr     StartNewLevel(pc)

loc_8B652:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
word_8B658:
                dc.w    -8,   $10,  -$10,   $20
; ---------------------------------------------------------------------------

loc_8B660:
                move.w  a0,(_unkFAAE).w
                btst    #5,$38(a0)
                bne.s   loc_8B6A8
                move.w  (Camera_X_pos_copy).w,x_pos(a0)
                move.w  (Camera_Y_pos_copy).w,y_pos(a0)
                subq.w  #8,y_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.s   locret_8B6A6
                move.w  #8,$2E(a0)
                move.b  (Hyudoro_count).w,d0
                addq.b  #1,d0
                cmpi.b  #$3C,d0
                bhi.s   locret_8B6A6
                move.b  d0,(Hyudoro_count).w
                jsr     (AllocateObject).l
                bne.s   locret_8B6A6
                move.l  #loc_8B6AE,(a1)

locret_8B6A6:
                rts
; ---------------------------------------------------------------------------

loc_8B6A8:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_8B6AE:
                lea     ObjDat3_8B838(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_8B720,(a0)
                jsr     (Random_Number).l
                andi.w  #$1FF,d0
                cmpi.w  #$140,d0
                blo.s   loc_8B6D2
                andi.w  #$3F,d0
                lsl.w   #2,d0

loc_8B6D2:
                add.w   (Camera_X_pos).w,d0
                cmpi.w  #$380,d0
                blo.s   loc_8B756
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subq.w  #4,d0
                move.w  d0,y_pos(a0)
                swap    d0
                move.w  d0,d1
                andi.w  #3,d0
                move.b  RawAni_8B714(pc,d0.w),mapping_frame(a0)
                add.w   d0,d0
                move.w  word_8B718(pc,d0.w),priority(a0)
                andi.w  #$3C,d1
                subi.w  #$20,d1
                move.w  d1,x_vel(a0)
                move.w  #$100,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
RawAni_8B714:
                dc.b    $B, $10,  $B,  $B
                even
word_8B718:
                dc.w    $80
                dc.w    $380
                dc.w    $80
                dc.w    $80
; ---------------------------------------------------------------------------

loc_8B720:
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bmi.s   loc_8B732
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8B732:
                move.l  #loc_8B73A,(a0)
                rts
; ---------------------------------------------------------------------------

loc_8B73A:
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bpl.s   loc_8B756
                bchg    #0,$38(a0)
                bne.w   locret_8B5DA
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8B756:
                move.b  (Hyudoro_count).w,d0
                subq.b  #1,d0
                bmi.s   loc_8B762
                move.b  d0,(Hyudoro_count).w

loc_8B762:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_8B768:
                lea     word_8B844(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_8B786,(a0)
                move.l  #loc_8B790,$34(a0)
                bsr.w   sub_8B7A0
                jsr     Refresh_ChildPositionAdjusted(pc)

loc_8B786:
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8B790:
                move.l  #loc_8B798,(a0)
                rts
; ---------------------------------------------------------------------------

loc_8B798:
                jsr     MoveSprite_LightGravity(pc)
                jmp     Sprite_CheckDeleteXY(pc)

; =============== S U B R O U T I N E =======================================

sub_8B7A0:
                movea.w parent3(a0),a1
                move.w  $44(a1),d0
                beq.s   locret_8B7DA
                movea.w d0,a2
                lea     word_8B7DC(pc),a3
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,$2E(a0)
                add.w   d0,d0
                move.l  (a3,d0.w),x_vel(a0)             ; and y_vel
                btst    #0,render_flags(a2)
                beq.s   locret_8B7DA
                bset    #0,render_flags(a0)
                bset    #0,render_flags(a1)
                neg.w   x_vel(a0)

locret_8B7DA:
                rts
; End of function sub_8B7A0

; ---------------------------------------------------------------------------
word_8B7DC:
                dc.w    -$300, -$200
                dc.w    -$400, -$300
                dc.w    -$400, -$280
                dc.w    -$280, -$200
                dc.w    -$200, -$180
                dc.w    -$200, -$100
off_8B7F4:
                dc.l    loc_8B56E
                dc.l    ObjDat3_8B814
                dc.l    loc_8B5DC
                dc.l    ObjDat3_8B820
                dc.l    loc_8B616
                dc.l    ObjDat3_8B82C
                dc.l    loc_8B660
                dc.l    ObjDat3_8B838
ObjDat3_8B814:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,0)
                dc.w    $80
                dc.b    $18,   8, $20,   0
ObjDat3_8B820:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,1)
                dc.w    $80
                dc.b    8, $10, $21,   0
ObjDat3_8B82C:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,1)
                dc.w    $80
                dc.b    $10, $10, $22,   0
ObjDat3_8B838:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    4,   4,  $B,   0
word_8B844:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    8,   8,   9,   0
ChildObjDat_8B84C:
                dc.w    6-1
                dc.l    loc_8B768
                dc.b    -8,  -8
                dc.l    loc_8B768
                dc.b    8,  -8
                dc.l    loc_8B768
                dc.b    -$18,   0
                dc.l    loc_8B768
                dc.b    -8,   0
                dc.l    loc_8B768
                dc.b    8,   0
                dc.l    loc_8B768
                dc.b    $18,   0
ChildObjDat_8B872:
                dc.w    2-1
                dc.l    loc_8B768
                dc.b    0,  -8
                dc.l    loc_8B768
                dc.b    0,   8
ChildObjDat_8B880:
                dc.w    4-1
                dc.l    loc_8B768
                dc.b    -8,  -8
                dc.l    loc_8B768
                dc.b    0,   8
                dc.l    loc_8B768
                dc.b    8,  -8
                dc.l    loc_8B768
                dc.b    8,   8
