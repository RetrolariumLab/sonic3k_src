; Owner: objects/terrain/icz/s3
; Responsibility: IceCap snow-pile controller, thrown snow, child helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZSnowPile:
                jsr     Obj_WaitOffscreen(pc)
                moveq   #0,d0
                move.b  subtype(a0),d0
                bclr    #7,d0
                lea     off_58F8C(pc),a1
                lea     (a1,d0.w),a2
                move.l  (a2)+,(a0)
                movea.l (a2)+,a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_58D06:
                lea     word_58D28(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   loc_58D24
                tst.w   d0
                beq.s   loc_58D1A
                bsr.w   ApplyIczSnowPileDragOrBreak

loc_58D1A:
                swap    d0
                tst.w   d0
                beq.s   loc_58D24
                bsr.w   ApplyIczSnowPileDragOrBreak

loc_58D24:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
word_58D28:
                dc.w    -$28,   $50,  -$18,   $20

; =============== S U B R O U T I N E =======================================

ApplyIczSnowPileDragOrBreak:
                movea.w d0,a3
                move.w  d0,$44(a0)
                cmpi.b  #9,anim(a3)
                beq.s   loc_58D5E
                btst    #Status_InAir,status(a3)
                bne.s   locret_58D5C
                move.w  x_vel(a3),d2
                move.w  d2,d3
                bpl.s   loc_58D50
                neg.w   d2

loc_58D50:
                cmpi.w  #$600,d2
                bhs.s   loc_58D5E
                asr.w   #1,d3
                move.w  d3,ground_vel(a3)

locret_58D5C:
                rts
; ---------------------------------------------------------------------------

loc_58D5E:
                move.w  a3,$44(a0)
                lea     ChildObjDat_58FE4(pc),a2
                jsr     CreateChild1_Normal(pc)
                jsr     (Go_Delete_Sprite).l
                addq.w  #4,sp

locret_58D72:
                rts
; End of function ApplyIczSnowPileDragOrBreak

; ---------------------------------------------------------------------------

loc_58D74:
                lea     word_58DA6(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.w   d0
                bne.s   loc_58D84
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

loc_58D84:
                move.w  d0,$44(a0)
                beq.s   loc_58DA0
                movea.w d0,a1
                move.w  #$800,x_vel(a1)
                move.w  #$800,ground_vel(a1)
                lea     ChildObjDat_5900A(pc),a2
                jsr     CreateChild1_Normal(pc)

loc_58DA0:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
word_58DA6:
                dc.w    -8,   $10,  -$10,   $20
; ---------------------------------------------------------------------------

loc_58DAE:
                lea     word_58DF0(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.w   d0
                bne.s   loc_58DBE
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_58DBE:
                move.w  d0,$44(a0)
                beq.s   loc_58DEA
                movea.w d0,a1
                move.w  #$800,x_vel(a1)
                move.w  #$800,ground_vel(a1)
                lea     ChildObjDat_59018(pc),a2
                jsr     CreateChild1_Normal(pc)
                btst    #7,subtype(a0)
                beq.s   loc_58DEA
                move.w  #$600,d0
                jsr     StartNewLevel(pc)

loc_58DEA:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
word_58DF0:
                dc.w    -8,   $10,  -$10,   $20
; ---------------------------------------------------------------------------

loc_58DF8:
                move.w  a0,(_unkFAAE).w
                btst    #5,$38(a0)
                bne.s   loc_58E40
                move.w  (Camera_X_pos_copy).w,x_pos(a0)
                move.w  (Camera_Y_pos_copy).w,y_pos(a0)
                subq.w  #8,y_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.s   locret_58E3E
                move.w  #8,$2E(a0)
                move.b  (Hyudoro_count).w,d0
                addq.b  #1,d0
                cmpi.b  #$3C,d0
                bhi.s   locret_58E3E
                move.b  d0,(Hyudoro_count).w
                jsr     (AllocateObject).l
                bne.s   locret_58E3E
                move.l  #loc_58E46,(a1)

locret_58E3E:
                rts
; ---------------------------------------------------------------------------

loc_58E40:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_58E46:
                lea     ObjDat3_58FD0(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_58EB8,(a0)
                jsr     (Random_Number).l
                andi.w  #$1FF,d0
                cmpi.w  #$140,d0
                blo.s   loc_58E6A
                andi.w  #$3F,d0
                lsl.w   #2,d0

loc_58E6A:
                add.w   (Camera_X_pos).w,d0
                cmpi.w  #$380,d0
                blo.s   loc_58EEE
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subq.w  #4,d0
                move.w  d0,y_pos(a0)
                swap    d0
                move.w  d0,d1
                andi.w  #3,d0
                move.b  RawAni_58EAC(pc,d0.w),mapping_frame(a0)
                add.w   d0,d0
                move.w  word_58EB0(pc,d0.w),priority(a0)
                andi.w  #$3C,d1
                subi.w  #$20,d1
                move.w  d1,x_vel(a0)
                move.w  #$100,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
RawAni_58EAC:
                dc.b    $B, $10,  $B,  $B
                even
word_58EB0:
                dc.w    $80
                dc.w    $380
                dc.w    $80
                dc.w    $80
; ---------------------------------------------------------------------------

loc_58EB8:
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bmi.s   loc_58ECA
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_58ECA:
                move.l  #loc_58ED2,(a0)
                rts
; ---------------------------------------------------------------------------

loc_58ED2:
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bpl.s   loc_58EEE
                bchg    #0,$38(a0)
                bne.w   locret_58D72
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_58EEE:
                move.b  (Hyudoro_count).w,d0
                subq.b  #1,d0
                bmi.s   loc_58EFA
                move.b  d0,(Hyudoro_count).w

loc_58EFA:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_58F00:
                lea     word_58FDC(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_58F1E,(a0)
                move.l  #loc_58F28,$34(a0)
                bsr.w   ICZSnowFragment_InitLaunch
                jsr     Refresh_ChildPositionAdjusted(pc)

loc_58F1E:
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_58F28:
                move.l  #loc_58F30,(a0)
                rts
; ---------------------------------------------------------------------------

loc_58F30:
                jsr     MoveSprite_LightGravity(pc)
                jmp     Sprite_CheckDeleteXY(pc)

; =============== S U B R O U T I N E =======================================

; Set the wait and indexed launch speeds. If the recorded player faces left, mirror both actors and negate the fragment's X velocity
ICZSnowFragment_InitLaunch:
                movea.w parent3(a0),a1
                move.w  $44(a1),d0
                beq.s   locret_58F72
                movea.w d0,a2
                lea     word_58F74(pc),a3
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,$2E(a0)
                add.w   d0,d0
                move.l  (a3,d0.w),x_vel(a0)             ; and y_vel
                btst    #0,render_flags(a2)
                beq.s   locret_58F72
                bset    #0,render_flags(a0)
                bset    #0,render_flags(a1)
                neg.w   x_vel(a0)

locret_58F72:
                rts
; End of function ICZSnowFragment_InitLaunch

; ---------------------------------------------------------------------------
word_58F74:
                dc.w    -$300, -$200
                dc.w    -$400, -$300
                dc.w    -$400, -$280
                dc.w    -$280, -$200
                dc.w    -$200, -$180
                dc.w    -$200, -$100
off_58F8C:
                dc.l    loc_58D06
                dc.l    ObjDat3_58FAC
                dc.l    loc_58D74
                dc.l    ObjDat3_58FB8
                dc.l    loc_58DAE
                dc.l    ObjDat3_58FC4
                dc.l    loc_58DF8
                dc.l    ObjDat3_58FD0
ObjDat3_58FAC:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,0)
                dc.w    $80
                dc.b    $18,   8, $20,   0
ObjDat3_58FB8:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,1)
                dc.w    $80
                dc.b    8, $10, $21,   0
ObjDat3_58FC4:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,1)
                dc.w    $80
                dc.b    $10, $10, $22,   0
ObjDat3_58FD0:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    4,   4,  $B,   0
word_58FDC:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    8,   8,   9,   0
ChildObjDat_58FE4:
                dc.w    6-1
                dc.l    loc_58F00
                dc.b    -8,  -8
                dc.l    loc_58F00
                dc.b    8,  -8
                dc.l    loc_58F00
                dc.b    -$18,   0
                dc.l    loc_58F00
                dc.b    -8,   0
                dc.l    loc_58F00
                dc.b    8,   0
                dc.l    loc_58F00
                dc.b    $18,   0
ChildObjDat_5900A:
                dc.w    2-1
                dc.l    loc_58F00
                dc.b    0,  -8
                dc.l    loc_58F00
                dc.b    0,   8
ChildObjDat_59018:
                dc.w    4-1
                dc.l    loc_58F00
                dc.b    -8,  -8
                dc.l    loc_58F00
                dc.b    0,   8
                dc.l    loc_58F00
                dc.b    8,  -8
                dc.l    loc_58F00
                dc.b    8,   8
