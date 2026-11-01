; Owner: objects/bosses/mhz/miniboss/sk
; Responsibility: Mushroom Hill miniboss tree actor, scene interaction and child motion
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZMinibossTree:
                lea     ObjDat_MHZMinibossTree(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_75A94,(a0)

loc_75A94:
                move.w  (_unkFAA4).w,d0
                beq.s   loc_75ACE
                movea.w d0,a1
                cmpi.l  #Obj_MHZMiniboss,(a1)
                bne.s   loc_75ACE
                tst.b   render_flags(a0)
                bmi.s   loc_75AB0
                move.b  #5,$42(a1)

loc_75AB0:
                move.b  $42(a1),d0
                cmp.b   mapping_frame(a0),d0
                beq.s   loc_75ACE
                move.b  d0,mapping_frame(a0)
                cmpi.b  #5,d0
                bhs.s   loc_75ACE
                lea     ChildObjDat_75E98(pc),a2
                jsr     (CreateChild6_Simple).l

loc_75ACE:
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------

loc_75AD4:
                lea     ObjDat3_75E72(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_75B34,(a0)
                move.b  #$18,y_radius(a0)
                movea.w (_unkFAA4).w,a1
                moveq   #0,d2
                move.b  $42(a1),d2
                move.b  byte_75B2E(pc,d2.w),d3
                ext.w   d3
                add.w   d3,y_pos(a0)
                jsr     (Random_Number).l
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   loc_75B0E
                moveq   #0,d0

loc_75B0E:
                move.w  #-$400,d1
                btst    #0,d0
                beq.s   loc_75B24
                tst.b   d2
                beq.s   loc_75B24
                move.w  #-$200,d1
                sne     $3A(a0)

loc_75B24:
                move.w  d1,x_vel(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
byte_75B2E:
                dc.b    $40, $20,   0,-$20,-$40,   0
                even
; ---------------------------------------------------------------------------

loc_75B34:
                lea     byte_75F12(pc),a1
                jsr     (Animate_RawNoSST).l
                tst.b   $3A(a0)
                beq.s   loc_75B58
                addi.w  #$20,y_vel(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_75B58
                neg.w   y_vel(a0)

loc_75B58:
                jsr     (MoveSprite2).l
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

loc_75B64:
                bsr.w   SyncMHZMinibossFrameCollisionProxy
                jmp     (Child_AddToTouchList).l
; End of function Obj_MHZMinibossTree
