; Owner: objects/enemies/mgz/s3
; Responsibility: Spiker enemy state machine, projectile motion and private construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Spiker:
                jsr     (Obj_WaitOffscreen).l
                moveq   #$A,d0
                bsr.w   sub_56B8C
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Spiker_Index(pc,d0.w),d1
                jsr     Spiker_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Spiker_Index:
                dc.w    loc_5697E-Spiker_Index
                dc.w    loc_5698E-Spiker_Index
                dc.w    loc_569A8-Spiker_Index
                dc.w    loc_569C2-Spiker_Index
                dc.w    loc_569E2-Spiker_Index
                dc.w    loc_569F6-Spiker_Index
; ---------------------------------------------------------------------------

loc_5697E:
                lea     ObjDat_Spiker(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     ChildObjDat_56BDC(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_5698E:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                blo.s   loc_5699A
                rts
; ---------------------------------------------------------------------------

loc_5699A:
                move.b  #4,routine(a0)
                move.w  #7,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_569A8:
                subq.w  #1,y_pos(a0)
                subq.w  #1,$2E(a0)
                bmi.s   loc_569B4
                rts
; ---------------------------------------------------------------------------

loc_569B4:
                move.b  #6,routine(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_569C2:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   loc_569CE
                rts
; ---------------------------------------------------------------------------

loc_569CE:
                move.b  #8,routine(a0)
                bclr    #2,$38(a0)
                move.w  #7,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_569E2:
                addq.w  #1,y_pos(a0)
                subq.w  #1,$2E(a0)
                bmi.s   loc_569EE
                rts
; ---------------------------------------------------------------------------

loc_569EE:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_569F6:
                lea     byte_56C08(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   locret_56A2A
                cmpi.b  #4,anim_frame(a0)
                bne.s   locret_56A2A
                movea.w $44(a0),a1
                move.w  #-$600,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                move.b  #2,routine(a1)

locret_56A2A:
                rts
; ---------------------------------------------------------------------------

loc_56A2C:
                move.b  $3A(a0),routine(a0)
                move.b  #$A,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_56A3A:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_56A50(pc,d0.w),d1
                jsr     off_56A50(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_56A50:
                dc.w    loc_56A58-off_56A50
                dc.w    loc_56A6E-off_56A50
                dc.w    loc_56A84-off_56A50
                dc.w    loc_56AC0-off_56A50
; ---------------------------------------------------------------------------

loc_56A58:
                lea     word_56BC4(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                tst.b   subtype(a0)
                bne.s   locret_56A6C
                bset    #0,render_flags(a0)

locret_56A6C:
                rts
; ---------------------------------------------------------------------------

loc_56A6E:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_56A7C
                rts
; ---------------------------------------------------------------------------

loc_56A7C:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_56A84:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   loc_56AB8
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   locret_56AA6
                tst.b   subtype(a0)
                beq.s   loc_56AA2
                subq.w  #2,d0

loc_56AA2:
                tst.w   d0
                beq.s   loc_56AA8

locret_56AA6:
                rts
; ---------------------------------------------------------------------------

loc_56AA8:
                move.b  #6,routine(a0)
                move.l  #loc_56AE6,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_56AB8:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_56AC0:
                lea     byte_56C11(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   locret_56AE4
                cmpi.b  #4,mapping_frame(a0)
                bne.s   locret_56AE4
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_56BF0(pc),a2
                jsr     CreateChild5_ComplexAdjusted(pc)

locret_56AE4:
                rts
; ---------------------------------------------------------------------------

loc_56AE6:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_56AEE:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_56B04(pc,d0.w),d1
                jsr     off_56B04(pc,d1.w)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
off_56B04:
                dc.w    loc_56B0A-off_56B04
                dc.w    loc_56B12-off_56B04
                dc.w    loc_56B52-off_56B04
; ---------------------------------------------------------------------------

loc_56B0A:
                lea     word_56BCA(pc),a1
                jsr     SetUp_ObjAttributes3(pc)

loc_56B12:
                jsr     Check_PlayerCollision(pc)
                bne.s   loc_56B1A
                rts
; ---------------------------------------------------------------------------

loc_56B1A:
                bsr.w   sub_56B64
                move.b  #4,routine(a0)
                clr.b   collision_flags(a0)
                move.w  #$10,$2E(a0)
                move.l  #loc_56B56,$34(a0)
                movea.w parent3(a0),a1
                bset    #3,$38(a1)
                move.b  #1,mapping_frame(a1)
                clr.b   collision_flags(a1)
                move.w  $44(a0),$44(a1)
                rts
; ---------------------------------------------------------------------------

loc_56B52:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_56B56:
                move.b  #2,routine(a0)
                move.b  #$CA,collision_flags(a0)
                rts

; =============== S U B R O U T I N E =======================================

sub_56B64:
                clr.w   y_vel(a1)
                bset    #Status_InAir,status(a1)
                addq.w  #6,y_pos(a1)
                move.b  #2,routine(a1)
                clr.b   jumping(a1)
                bclr    #Status_RollJump,status(a1)
                moveq   #signextendB(sfx_Spring),d0
                jsr     (Play_SFX).l
                rts
; End of function sub_56B64

; =============== S U B R O U T I N E =======================================

sub_56B8C:
                btst    #3,$38(a0)
                bne.s   loc_56B96
                rts
; ---------------------------------------------------------------------------

loc_56B96:
                bclr    #3,$38(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.b  routine(a0),$3A(a0)
                move.b  d0,routine(a0)
                move.l  #loc_56A2C,$34(a0)
                rts
; End of function sub_56B8C

; ---------------------------------------------------------------------------
ObjDat_Spiker:
                dc.l    Map_Spiker
                dc.w    make_art_tile(ArtTile_Spiker,1,0)
                dc.w    $280
                dc.b    $20, $10,   0,  $A
word_56BC4:
                dc.w    $280
                dc.b    $20,   4,   3,   0
word_56BCA:
                dc.w    $200
                dc.b    $20,   4,   7, $CA
ObjDat3_56BD0:
                dc.l    Map_Spiker
                dc.w    make_art_tile(ArtTile_Spiker,0,0)
                dc.w    $280
                dc.b    4,   4,   5, $98
ChildObjDat_56BDC:
                dc.w    3-1
                dc.l    loc_56A3A
                dc.b    -$10,  $C
                dc.l    loc_56A3A
                dc.b    $10,  $C
                dc.l    loc_56AEE
                dc.b    0, -$C
ChildObjDat_56BF0:
                dc.w    1-1
                dc.l    loc_54B46
                dc.l    ObjDat3_56BD0
                dc.l    byte_56C1A
                dc.l    MoveSlowFall_AnimateRaw
                dc.b    4,   0
                dc.w    $200, -$200
byte_56C08:
                dc.b    1,   0
                dc.b    2,   1
                dc.b    1,   0
                dc.b    0,   5
                dc.b    $F4
byte_56C11:
                dc.b    3,   1
                dc.b    3,  $F
                dc.b    4,   7
                dc.b    3, $3F
                dc.b    $F4
byte_56C1A:
                dc.b    1,   5,   6, $FC
                even
