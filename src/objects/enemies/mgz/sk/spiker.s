; Owner: objects/enemies/mgz/sk
; Responsibility: Spiker enemy state machine, projectile motion and private construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Spiker:
                jsr     (Obj_WaitOffscreen).l
                moveq   #$A,d0
                bsr.w   ConsumeSpikerSpringRequestAndSaveRoutine
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Spiker_Index(pc,d0.w),d1
                jsr     Spiker_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Spiker_Index:
                dc.w    loc_88BC0-Spiker_Index
                dc.w    loc_88BD0-Spiker_Index
                dc.w    loc_88BEA-Spiker_Index
                dc.w    loc_88C04-Spiker_Index
                dc.w    loc_88C24-Spiker_Index
                dc.w    loc_88C38-Spiker_Index
; ---------------------------------------------------------------------------

loc_88BC0:
                lea     ObjDat_Spiker(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     ChildObjDat_88E1E(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_88BD0:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                blo.s   loc_88BDC
                rts
; ---------------------------------------------------------------------------

loc_88BDC:
                move.b  #4,routine(a0)
                move.w  #7,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_88BEA:
                subq.w  #1,y_pos(a0)
                subq.w  #1,$2E(a0)
                bmi.s   loc_88BF6
                rts
; ---------------------------------------------------------------------------

loc_88BF6:
                move.b  #6,routine(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_88C04:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   loc_88C10
                rts
; ---------------------------------------------------------------------------

loc_88C10:
                move.b  #8,routine(a0)
                bclr    #2,$38(a0)
                move.w  #7,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_88C24:
                addq.w  #1,y_pos(a0)
                subq.w  #1,$2E(a0)
                bmi.s   loc_88C30
                rts
; ---------------------------------------------------------------------------

loc_88C30:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_88C38:
                lea     byte_88E4A(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   locret_88C6C
                cmpi.b  #4,anim_frame(a0)
                bne.s   locret_88C6C
                movea.w $44(a0),a1
                move.w  #-$600,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                move.b  #2,routine(a1)

locret_88C6C:
                rts
; ---------------------------------------------------------------------------

loc_88C6E:
                move.b  $3A(a0),routine(a0)
                move.b  #$A,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_88C7C:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_88C92(pc,d0.w),d1
                jsr     off_88C92(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_88C92:
                dc.w    loc_88C9A-off_88C92
                dc.w    loc_88CB0-off_88C92
                dc.w    loc_88CC6-off_88C92
                dc.w    loc_88D02-off_88C92
; ---------------------------------------------------------------------------

loc_88C9A:
                lea     word_88E06(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                tst.b   subtype(a0)
                bne.s   locret_88CAE
                bset    #0,render_flags(a0)

locret_88CAE:
                rts
; ---------------------------------------------------------------------------

loc_88CB0:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_88CBE
                rts
; ---------------------------------------------------------------------------

loc_88CBE:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_88CC6:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   loc_88CFA
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   locret_88CE8
                tst.b   subtype(a0)
                beq.s   loc_88CE4
                subq.w  #2,d0

loc_88CE4:
                tst.w   d0
                beq.s   loc_88CEA

locret_88CE8:
                rts
; ---------------------------------------------------------------------------

loc_88CEA:
                move.b  #6,routine(a0)
                move.l  #loc_88D28,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_88CFA:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_88D02:
                lea     byte_88E53(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   locret_88D26
                cmpi.b  #4,mapping_frame(a0)
                bne.s   locret_88D26
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_88E32(pc),a2
                jsr     CreateChild5_ComplexAdjusted(pc)

locret_88D26:
                rts
; ---------------------------------------------------------------------------

loc_88D28:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_88D30:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_88D46(pc,d0.w),d1
                jsr     off_88D46(pc,d1.w)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
off_88D46:
                dc.w    loc_88D4C-off_88D46
                dc.w    loc_88D54-off_88D46
                dc.w    loc_88D94-off_88D46
; ---------------------------------------------------------------------------

loc_88D4C:
                lea     word_88E0C(pc),a1
                jsr     SetUp_ObjAttributes3(pc)

loc_88D54:
                jsr     Check_PlayerCollision(pc)
                bne.s   loc_88D5C
                rts
; ---------------------------------------------------------------------------

loc_88D5C:
                bsr.w   PrimeSpikerSpringContactPlayer
                move.b  #4,routine(a0)
                clr.b   collision_flags(a0)
                move.w  #$10,$2E(a0)
                move.l  #loc_88D98,$34(a0)
                movea.w parent3(a0),a1
                bset    #3,$38(a1)
                move.b  #1,mapping_frame(a1)
                clr.b   collision_flags(a1)
                move.w  $44(a0),$44(a1)
                rts
; ---------------------------------------------------------------------------

loc_88D94:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_88D98:
                move.b  #2,routine(a0)
                move.b  #$CA,collision_flags(a0)
                rts

; =============== S U B R O U T I N E =======================================

PrimeSpikerSpringContactPlayer:
                clr.w   y_vel(a1)
                bset    #Status_InAir,status(a1)
                addq.w  #6,y_pos(a1)
                move.b  #2,routine(a1)
                clr.b   jumping(a1)
                bclr    #Status_RollJump,status(a1)
                moveq   #signextendB(sfx_Spring),d0
                jsr     (Play_SFX).l
                rts
; End of function PrimeSpikerSpringContactPlayer

; =============== S U B R O U T I N E =======================================

ConsumeSpikerSpringRequestAndSaveRoutine:
                btst    #3,$38(a0)
                bne.s   loc_88DD8
                rts
; ---------------------------------------------------------------------------

loc_88DD8:
                bclr    #3,$38(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.b  routine(a0),$3A(a0)
                move.b  d0,routine(a0)
                move.l  #loc_88C6E,$34(a0)
                rts
; End of function ConsumeSpikerSpringRequestAndSaveRoutine

; ---------------------------------------------------------------------------
ObjDat_Spiker:
                dc.l    Map_Spiker
                dc.w    make_art_tile(ArtTile_Spiker,1,0)
                dc.w    $280
                dc.b    $20, $10,   0,  $A
word_88E06:
                dc.w    $280
                dc.b    $20,   4,   3,   0
word_88E0C:
                dc.w    $200
                dc.b    $20,   4,   7, $CA
ObjDat3_88E12:
                dc.l    Map_Spiker
                dc.w    make_art_tile(ArtTile_Spiker,0,0)
                dc.w    $280
                dc.b    4,   4,   5, $98
ChildObjDat_88E1E:
                dc.w    3-1
                dc.l    loc_88C7C
                dc.b    -$10,  $C
                dc.l    loc_88C7C
                dc.b    $10,  $C
                dc.l    loc_88D30
                dc.b    0, -$C
ChildObjDat_88E32:
                dc.w    1-1
                dc.l    SKCallbackShot_InitDeflectable
                dc.l    ObjDat3_88E12
                dc.l    byte_88E5C
                dc.l    MoveSlowFall_AnimateRaw
                dc.b    4,   0
                dc.w    $200, -$200
byte_88E4A:
                dc.b    1,   0
                dc.b    2,   1
                dc.b    1,   0
                dc.b    0,   5
                dc.b    $F4
byte_88E53:
                dc.b    3,   1
                dc.b    3,  $F
                dc.b    4,   7
                dc.b    3, $3F
                dc.b    $F4
byte_88E5C:
                dc.b    1,   5,   6, $FC
                even
