; Owner: objects/enemies/aiz/s3
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
                dc.w    loc_54C7A-Rhinobot_Index
                dc.w    loc_54CC0-Rhinobot_Index
                dc.w    loc_54CE6-Rhinobot_Index
                dc.w    loc_54CEA-Rhinobot_Index
; ---------------------------------------------------------------------------

loc_54C7A:
                lea     ObjSlot_Rhinobot(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                move.b  #8,x_radius(a0)
                move.b  #$10,y_radius(a0)
                move.w  #-$10,d0
                move.w  #-$300,d1
                btst    #0,render_flags(a0)
                beq.s   loc_54CAE
                neg.w   d0
                neg.w   d1
                bset    #3,$38(a0)
                bset    #2,$38(a0)

loc_54CAE:
                move.w  d0,$40(a0)
                move.w  d1,$3E(a0)
                move.l  #loc_54D3C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_54CC0:
                lea     loc_54D8E(pc),a3
                bsr.w   TriggerRhinobotChargeForPlayerAhead
                lea     loc_54D70(pc),a3
                bsr.w   FollowRhinobotFloorOrAbortState
                move.w  $40(a0),d0
                add.w   d0,x_vel(a0)
                jsr     (MoveSprite2).l
                bsr.w   DispatchRhinobotVelocityMilestone
                bra.w   loc_54E18
; ---------------------------------------------------------------------------

loc_54CE6:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_54CEA:
                lea     loc_54DE4(pc),a3
                bsr.w   FollowRhinobotFloorOrAbortState
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_54CF8:
                cmpi.w  #1,(Current_zone_and_act).w
                beq.s   loc_54D22
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_54D1E(pc,d0.w),d1
                jsr     off_54D1E(pc,d1.w)
                lea     DPLCPtr_AIZRhinobot(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     Child_Remember_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_54D1E:
                dc.w    loc_54D28-off_54D1E
                dc.w    loc_54D38-off_54D1E
; ---------------------------------------------------------------------------

loc_54D22:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_54D28:
                lea     ObjSlot_54F0C(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                move.l  #Go_Delete_SpriteSlotted3,$34(a0)

loc_54D38:
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

loc_54D3C:
                bchg    #2,$38(a0)
                move.l  #loc_54D54,$34(a0)
                neg.w   $40(a0)
                neg.w   $3E(a0)
                rts
; ---------------------------------------------------------------------------

loc_54D54:
                bchg    #3,$38(a0)
                bchg    #0,render_flags(a0)
                bclr    #1,$38(a0)
                move.l  #loc_54D3C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_54D70:
                bclr    #2,$38(a0)
                btst    #3,$38(a0)
                bne.s   loc_54D84
                bset    #2,$38(a0)

loc_54D84:
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                bra.s   loc_54D54
; ---------------------------------------------------------------------------

loc_54D8E:
                move.b  #4,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.w  #$20,$2E(a0)
                move.l  #loc_54DCA,$34(a0)
                bset    #1,$38(a0)
                moveq   #signextendB(sfx_Blast),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_54F26(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   locret_54DC8
                move.l  #byte_54F46,$30(a1)

locret_54DC8:
                rts
; ---------------------------------------------------------------------------

loc_54DCA:
                move.b  #6,routine(a0)
                move.w  #$400,d0
                btst    #3,$38(a0)
                bne.s   loc_54DDE
                neg.w   d0

loc_54DDE:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_54DE4:
                move.b  #2,routine(a0)
                move.b  #0,mapping_frame(a0)
                bra.w   loc_54D70

; =============== S U B R O U T I N E =======================================

DispatchRhinobotVelocityMilestone:
                move.w  x_vel(a0),d0
                beq.s   loc_54E12
                btst    #2,$38(a0)
                beq.s   loc_54E0A
                cmp.w   $3E(a0),d0
                bge.s   loc_54E12
                rts
; ---------------------------------------------------------------------------

loc_54E0A:
                cmp.w   $3E(a0),d0
                ble.s   loc_54E12
                rts
; ---------------------------------------------------------------------------

loc_54E12:
                movea.l $34(a0),a1
                jmp     (a1)
; End of function DispatchRhinobotVelocityMilestone

; ---------------------------------------------------------------------------

loc_54E18:
                moveq   #0,d1
                btst    #3,$38(a0)
                beq.s   loc_54E50
                btst    #2,$38(a0)
                beq.s   loc_54E38
                cmpi.w  #$80,x_vel(a0)
                bgt.s   loc_54E7A
                moveq   #1,d1
                bra.w   loc_54E7A
; ---------------------------------------------------------------------------

loc_54E38:
                moveq   #1,d1
                cmpi.w  #$280,x_vel(a0)
                bgt.s   loc_54E7A
                moveq   #2,d1
                bset    #1,$38(a0)
                beq.s   loc_54E80
                bra.w   loc_54E7A
; ---------------------------------------------------------------------------

loc_54E50:
                btst    #2,$38(a0)
                bne.s   loc_54E66
                cmpi.w  #-$80,x_vel(a0)
                ble.s   loc_54E7A
                moveq   #1,d1
                bra.w   loc_54E7A
; ---------------------------------------------------------------------------

loc_54E66:
                moveq   #1,d1
                cmpi.w  #-$280,x_vel(a0)
                ble.s   loc_54E7A
                moveq   #2,d1
                bset    #1,$38(a0)
                beq.s   loc_54E80

loc_54E7A:
                move.b  d1,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_54E80:
                move.b  d1,mapping_frame(a0)
                moveq   #signextendB(sfx_Blast),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_54F1E(pc),a2
                jsr     CreateChild1_Normal(pc)
                bne.s   locret_54E9E
                move.l  #byte_54F36,$30(a1)

locret_54E9E:
                rts

; =============== S U B R O U T I N E =======================================

TriggerRhinobotChargeForPlayerAhead:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$20,d3
                bhi.s   locret_54EBE
                cmpi.w  #$60,d2
                bhi.s   locret_54EBE
                btst    #3,$38(a0)
                bne.s   loc_54EBA
                subq.w  #2,d0

loc_54EBA:
                tst.w   d0
                bne.s   loc_54EC0

locret_54EBE:
                rts
; ---------------------------------------------------------------------------

loc_54EC0:
                jsr     (a3)
                addq.w  #4,sp
                rts
; End of function TriggerRhinobotChargeForPlayerAhead

; =============== S U B R O U T I N E =======================================

FollowRhinobotFloorOrAbortState:
                moveq   #4,d0
                btst    #3,$38(a0)
                bne.s   loc_54ED2
                neg.w   d0

loc_54ED2:
                move.w  x_pos(a0),d3
                add.w   d0,d3
                move.l  a3,-(sp)
                jsr     (ObjCheckFloorDist2).l
                movea.l (sp)+,a3
                cmpi.w  #-1,d1
                blt.s   loc_54EF4
                cmpi.w  #$C,d1
                bge.s   loc_54EF4
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_54EF4:
                jsr     (a3)
                addq.w  #4,sp
                rts
; End of function FollowRhinobotFloorOrAbortState

; ---------------------------------------------------------------------------
ObjSlot_Rhinobot:
                dc.w    2-1
                dc.w    make_art_tile(ArtTile_Rhinobot,1,0)
                dc.w    $15,     0
                dc.l    Map_Rhinobot
                dc.w    $280
                dc.b    $14, $10,   0,  $B
ObjSlot_54F0C:
                dc.w    2-1
                dc.w    make_art_tile(ArtTile_Rhinobot-$B6,0,0)
                dc.w    6,     2
                dc.l    Map_Rhinobot
                dc.w    $200
                dc.b    $C,   8,   4,   0
ChildObjDat_54F1E:
                dc.w    1-1
                dc.l    loc_54CF8
                dc.b    $C,   8
ChildObjDat_54F26:
                dc.w    1-1
                dc.l    loc_54CF8
                dc.b    $10,   8
DPLCPtr_AIZRhinobot:
                dc.l    ArtUnc_AIZRhinobot
                dc.l    DPLC_Rhinobot
byte_54F36:
                dc.b    2,   4,   4,   5,   6,   7,   4,   5,   6,   7,   4,   5,   6,   7, $F4
                even
byte_54F46:
                dc.b    2,   4,   4,   5,   6,   7,   4,   5,   6,   7, $F4
                even
