; Owner: objects/enemies/aiz/sk
; Responsibility: Rhinobot charge and tracking states, movement helpers and sprite pattern resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Rhinobot:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Rhinobot_Index(pc,d0.w),d1
                jsr     Rhinobot_Index(pc,d1.w)
                lea     DPLCPtr_AIZRhinobot(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     Sprite_CheckDeleteTouchSlotted(pc)
; ---------------------------------------------------------------------------
Rhinobot_Index:
                dc.w    loc_86E7E-Rhinobot_Index
                dc.w    loc_86EC4-Rhinobot_Index
                dc.w    loc_86EEA-Rhinobot_Index
                dc.w    loc_86EEE-Rhinobot_Index
; ---------------------------------------------------------------------------

loc_86E7E:
                lea     ObjSlot_Rhinobot(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                move.b  #8,x_radius(a0)
                move.b  #$10,y_radius(a0)
                move.w  #-$10,d0
                move.w  #-$300,d1
                btst    #0,render_flags(a0)
                beq.s   loc_86EB2
                neg.w   d0
                neg.w   d1
                bset    #3,$38(a0)
                bset    #2,$38(a0)

loc_86EB2:
                move.w  d0,$40(a0)
                move.w  d1,$3E(a0)
                move.l  #loc_86F40,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_86EC4:
                lea     loc_86F92(pc),a3
                bsr.w   sub_870A4
                lea     loc_86F74(pc),a3
                bsr.w   sub_870CA
                move.w  $40(a0),d0
                add.w   d0,x_vel(a0)
                jsr     (MoveSprite2).l
                bsr.w   sub_86FF8
                bra.w   loc_8701C
; ---------------------------------------------------------------------------

loc_86EEA:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_86EEE:
                lea     loc_86FE8(pc),a3
                bsr.w   sub_870CA
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_86EFC:
                cmpi.w  #1,(Current_zone_and_act).w
                beq.s   loc_86F26
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_86F22(pc,d0.w),d1
                jsr     off_86F22(pc,d1.w)
                lea     DPLCPtr_AIZRhinobot(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     Child_Remember_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_86F22:
                dc.w    loc_86F2C-off_86F22
                dc.w    loc_86F3C-off_86F22
; ---------------------------------------------------------------------------

loc_86F26:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_86F2C:
                lea     ObjSlot_87110(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                move.l  #Go_Delete_SpriteSlotted3,$34(a0)

loc_86F3C:
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_86F40:
                bchg    #2,$38(a0)
                move.l  #loc_86F58,$34(a0)
                neg.w   $40(a0)
                neg.w   $3E(a0)
                rts
; ---------------------------------------------------------------------------

loc_86F58:
                bchg    #3,$38(a0)
                bchg    #0,render_flags(a0)
                bclr    #1,$38(a0)
                move.l  #loc_86F40,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_86F74:
                bclr    #2,$38(a0)
                btst    #3,$38(a0)
                bne.s   loc_86F88
                bset    #2,$38(a0)

loc_86F88:
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                bra.s   loc_86F58
; ---------------------------------------------------------------------------

loc_86F92:
                move.b  #4,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.w  #$20,$2E(a0)
                move.l  #loc_86FCE,$34(a0)
                bset    #1,$38(a0)
                moveq   #signextendB(sfx_Blast),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_8712A(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   locret_86FCC
                move.l  #byte_8714A,$30(a1)

locret_86FCC:
                rts
; ---------------------------------------------------------------------------

loc_86FCE:
                move.b  #6,routine(a0)
                move.w  #$400,d0
                btst    #3,$38(a0)
                bne.s   loc_86FE2
                neg.w   d0

loc_86FE2:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_86FE8:
                move.b  #2,routine(a0)
                move.b  #0,mapping_frame(a0)
                bra.w   loc_86F74

; =============== S U B R O U T I N E =======================================

sub_86FF8:
                move.w  x_vel(a0),d0
                beq.s   loc_87016
                btst    #2,$38(a0)
                beq.s   loc_8700E
                cmp.w   $3E(a0),d0
                bge.s   loc_87016
                rts
; ---------------------------------------------------------------------------

loc_8700E:
                cmp.w   $3E(a0),d0
                ble.s   loc_87016
                rts
; ---------------------------------------------------------------------------

loc_87016:
                movea.l $34(a0),a1
                jmp     (a1)
; End of function sub_86FF8

; ---------------------------------------------------------------------------

loc_8701C:
                moveq   #0,d1
                btst    #3,$38(a0)
                beq.s   loc_87054
                btst    #2,$38(a0)
                beq.s   loc_8703C
                cmpi.w  #$80,x_vel(a0)
                bgt.s   loc_8707E
                moveq   #1,d1
                bra.w   loc_8707E
; ---------------------------------------------------------------------------

loc_8703C:
                moveq   #1,d1
                cmpi.w  #$280,x_vel(a0)
                bgt.s   loc_8707E
                moveq   #2,d1
                bset    #1,$38(a0)
                beq.s   loc_87084
                bra.w   loc_8707E
; ---------------------------------------------------------------------------

loc_87054:
                btst    #2,$38(a0)
                bne.s   loc_8706A
                cmpi.w  #-$80,x_vel(a0)
                ble.s   loc_8707E
                moveq   #1,d1
                bra.w   loc_8707E
; ---------------------------------------------------------------------------

loc_8706A:
                moveq   #1,d1
                cmpi.w  #-$280,x_vel(a0)
                ble.s   loc_8707E
                moveq   #2,d1
                bset    #1,$38(a0)
                beq.s   loc_87084

loc_8707E:
                move.b  d1,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_87084:
                move.b  d1,mapping_frame(a0)
                moveq   #signextendB(sfx_Blast),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_87122(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   locret_870A2
                move.l  #byte_8713A,$30(a1)

locret_870A2:
                rts

; =============== S U B R O U T I N E =======================================

sub_870A4:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$20,d3
                bhi.s   locret_870C2
                cmpi.w  #$60,d2
                bhi.s   locret_870C2
                btst    #3,$38(a0)
                bne.s   loc_870BE
                subq.w  #2,d0

loc_870BE:
                tst.w   d0
                bne.s   loc_870C4

locret_870C2:
                rts
; ---------------------------------------------------------------------------

loc_870C4:
                jsr     (a3)
                addq.w  #4,sp
                rts
; End of function sub_870A4

; =============== S U B R O U T I N E =======================================

sub_870CA:
                moveq   #4,d0
                btst    #3,$38(a0)
                bne.s   loc_870D6
                neg.w   d0

loc_870D6:
                move.w  x_pos(a0),d3
                add.w   d0,d3
                move.l  a3,-(sp)
                jsr     (ObjCheckFloorDist2).l
                movea.l (sp)+,a3
                cmpi.w  #-1,d1
                blt.s   loc_870F8
                cmpi.w  #$C,d1
                bge.s   loc_870F8
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_870F8:
                jsr     (a3)
                addq.w  #4,sp
                rts
; End of function sub_870CA

; ---------------------------------------------------------------------------
ObjSlot_Rhinobot:
                dc.w    2-1
                dc.w    make_art_tile(ArtTile_Rhinobot,1,0)
                dc.w    $15,     0
                dc.l    Map_Rhinobot
                dc.w    $280
                dc.b    $14, $10,   0,  $B
ObjSlot_87110:
                dc.w    2-1
                dc.w    make_art_tile(ArtTile_Rhinobot-$B6,0,0)
                dc.w    6,     2
                dc.l    Map_Rhinobot
                dc.w    $200
                dc.b    $C,   8,   4,   0
ChildObjDat_87122:
                dc.w    1-1
                dc.l    loc_86EFC
                dc.b    $C,   8
ChildObjDat_8712A:
                dc.w    1-1
                dc.l    loc_86EFC
                dc.b    $10,   8
DPLCPtr_AIZRhinobot:
                dc.l    ArtUnc_AIZRhinobot
                dc.l    DPLC_Rhinobot
byte_8713A:
                dc.b    2,   4,   4,   5,   6,   7,   4,   5,   6,   7,   4,   5,   6,   7, $F4
                even
byte_8714A:
                dc.b    2,   4,   4,   5,   6,   7,   4,   5,   6,   7, $F4
                even
