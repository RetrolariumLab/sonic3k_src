; Owner: objects/bosses/common/s3
; Responsibility: Shared Robotnik head actors, expression variants and boss-scene display states
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_RobotnikHead:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  RobotnikHead_Index(pc,d0.w),d1
                jsr     RobotnikHead_Index(pc,d1.w)
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
RobotnikHead_Index:
                dc.w    Obj_RobotnikHeadInit-RobotnikHead_Index
                dc.w    Obj_RobotnikHeadMain-RobotnikHead_Index
                dc.w    Obj_RobotnikHeadEnd-RobotnikHead_Index
; ---------------------------------------------------------------------------

Obj_RobotnikHeadInit:
                lea     ObjDat_RobotnikHead(pc),a1
                jsr     (SetUp_ObjAttributes).l
                jsr     (Child_SyncDraw).l
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)

locret_45EE0:
                rts
; ---------------------------------------------------------------------------

Obj_RobotnikHeadMain:
                lea     AniRaw_RobotnikHead(pc),a1
                jsr     (Animate_RawNoSST).l
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   loc_45F08
                btst    #6,status(a1)
                beq.s   locret_45F06
                move.b  #2,mapping_frame(a0)            ; Use hurt mapping frame if parent boss object is currently hurt

locret_45F06:
                rts
; ---------------------------------------------------------------------------

loc_45F08:
                move.b  #4,routine(a0)
                move.b  #3,mapping_frame(a0)            ; Use defeated head frame if parent boss object is defeated
                rts
; ---------------------------------------------------------------------------

Obj_RobotnikHeadEnd:
                rts
; ---------------------------------------------------------------------------

Obj_RobotnikHead2:
                jsr     (Refresh_ChildPositionAdjusted).l
                jsr     (Child_SyncDraw).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  RobotnikHead2_Index(pc,d0.w),d1
                jsr     RobotnikHead2_Index(pc,d1.w)
                btst    #6,$38(a0)
                bne.w   locret_45EE0
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
RobotnikHead2_Index:
                dc.w    Obj_RobotnikHeadInit-RobotnikHead2_Index
                dc.w    Obj_RobotnikHeadMain-RobotnikHead2_Index
                dc.w    Obj_RobotnikHeadEnd-RobotnikHead2_Index
; ---------------------------------------------------------------------------

Obj_FBZRobotnikHead:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FBZRobotnikHead_Index(pc,d0.w),d1
                jsr     FBZRobotnikHead_Index(pc,d1.w)
                jsr     (Child_GetPriority).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
FBZRobotnikHead_Index:
                dc.w    Obj_FBZRobotnikHeadInit-FBZRobotnikHead_Index
                dc.w    Obj_FBZRobotnikHeadMain-FBZRobotnikHead_Index
                dc.w    Obj_RobotnikHeadEnd-FBZRobotnikHead_Index
; ---------------------------------------------------------------------------

Obj_FBZRobotnikHeadInit:
                lea     ObjDat_FBZRobotnikHead(pc),a1
                jsr     (SetUp_ObjAttributes).l
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                rts
; ---------------------------------------------------------------------------

Obj_FBZRobotnikHeadMain:
                move.w  x_pos(a0),d0
                bclr    #0,render_flags(a0)
                cmp.w   (Player_1+x_pos).w,d0
                bhs.s   loc_45F9A
                bset    #0,render_flags(a0)

loc_45F9A:
                clr.b   mapping_frame(a0)
                movea.w $44(a0),a1
; Bug: this should check bit 2 of $38(a1)
                btst    #2,$38(a0)
                beq.s   loc_45FB0
                move.b  #1,mapping_frame(a0)

loc_45FB0:
                btst    #7,status(a1)
                bne.s   loc_45FC8
                btst    #6,status(a1)
                beq.s   locret_45FC6
                move.b  #2,mapping_frame(a0)

locret_45FC6:
                rts
; ---------------------------------------------------------------------------

loc_45FC8:
                move.b  #4,routine(a0)
                move.b  #3,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

Obj_RobotnikHead3:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  RobotnikHead3_Index(pc,d0.w),d1
                jsr     RobotnikHead3_Index(pc,d1.w)
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------
RobotnikHead3_Index:
                dc.w    Obj_RobotnikHead3Init-RobotnikHead3_Index
                dc.w    Obj_RobotnikHead3Main-RobotnikHead3_Index
                dc.w    Obj_RobotnikHeadEnd-RobotnikHead3_Index
; ---------------------------------------------------------------------------

Obj_RobotnikHead3Init:
                lea     ObjDat_RobotnikHead(pc),a1
                jsr     (SetUp_ObjAttributes).l
                movea.w parent3(a0),a1
                btst    #7,art_tile(a1)
                beq.s   locret_46012
                bset    #7,art_tile(a0)

locret_46012:
                rts
; ---------------------------------------------------------------------------

Obj_RobotnikHead3Main:
                lea     AniRaw_RobotnikHead(pc),a1
                jsr     (Animate_RawNoSST).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_4603A
                btst    #6,status(a1)
                beq.s   locret_46038
                move.b  #2,mapping_frame(a0)

locret_46038:
                rts
; ---------------------------------------------------------------------------

loc_4603A:
                move.b  #4,routine(a0)
                move.b  #3,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

Obj_RobotnikHead4:
                jsr     (Refresh_ChildPositionAdjusted).l
                jsr     (Child_SyncDraw).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  RobotnikHead4_Index(pc,d0.w),d1
                jsr     RobotnikHead4_Index(pc,d1.w)
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   loc_46074
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_46074:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
RobotnikHead4_Index:
                dc.w    Obj_RobotnikHead3Init-RobotnikHead4_Index
                dc.w    Obj_RobotnikHead3Main-RobotnikHead4_Index
                dc.w    Obj_RobotnikHeadEnd-RobotnikHead4_Index
