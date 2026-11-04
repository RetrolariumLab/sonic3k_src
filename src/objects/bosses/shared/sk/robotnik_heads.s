; Owner: objects/bosses/shared/sk
; Responsibility: Robotnik and Mecha Sonic head variants, initialization and parent-linked expression or movement states
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
                move.l  #AniRaw_RobotnikHead,$30(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   Obj_RobotnikHeadEnd

; =============== S U B R O U T I N E =======================================

EggRoboHead_SetVisualsAndQueueArt:
                move.l  #Map_EggRoboHead,mappings(a0)   ; If player is Knuckles, use EggRobo head

RobotnikSK_HeadLoadEggRoboAnimAndArt:
                move.l  #AniRaw_EggRoboHead,$30(a0)
                lea     (ArtKosM_EggRoboHead).l,a1
                move.w  #tiles_to_bytes(ArtTile_RobotnikShip),d2
                jmp     (Queue_Kos_Module).l
; End of function EggRoboHead_SetVisualsAndQueueArt

; ---------------------------------------------------------------------------

Obj_RobotnikHeadMain:
                jsr     (Animate_Raw).l
                movea.w $44(a0),a1
                btst    #7,status(a1)
                bne.s   RobotnikSK_HeadSetDefeatFrame
                btst    #6,status(a1)
                beq.s   RobotnikSK_HeadExpressionReturn
                move.b  #2,mapping_frame(a0)            ; Use hurt mapping frame if parent boss object is currently hurt

RobotnikSK_HeadExpressionReturn:
                rts
; ---------------------------------------------------------------------------

RobotnikSK_HeadSetDefeatFrame:
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
                bne.w   Obj_RobotnikHeadEnd
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
                move.l  #AniRaw_RobotnikHead,$30(a0)
                movea.w parent3(a0),a1
                move.w  parent3(a1),$44(a0)
                cmpi.b  #2,(Player_1+character_id).w
                bne.w   Obj_RobotnikHeadEnd
                bra.w   EggRoboHead_SetVisualsAndQueueArt
; ---------------------------------------------------------------------------

Obj_FBZRobotnikHeadMain:
                move.w  x_pos(a0),d0
                bclr    #0,render_flags(a0)
                cmp.w   (Player_1+x_pos).w,d0
                bhs.s   RobotnikSK_FBZHeadResetAndCheckRequest
                bset    #0,render_flags(a0)

RobotnikSK_FBZHeadResetAndCheckRequest:
                clr.b   mapping_frame(a0)
                movea.w $44(a0),a1
; Bug: this should check bit 2 of $38(a1)
                btst    #2,$38(a0)
                beq.s   RobotnikSK_FBZHeadCheckRootExpression
                move.b  #1,mapping_frame(a0)

RobotnikSK_FBZHeadCheckRootExpression:
                btst    #7,status(a1)
                bne.s   RobotnikSK_FBZHeadSetDefeatFrame
                btst    #6,status(a1)
                beq.s   RobotnikSK_FBZHeadExpressionReturn
                move.b  #2,mapping_frame(a0)

RobotnikSK_FBZHeadExpressionReturn:
                rts
; ---------------------------------------------------------------------------

RobotnikSK_FBZHeadSetDefeatFrame:
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
                dc.w    Obj_RobotnikHead3End-RobotnikHead3_Index
; ---------------------------------------------------------------------------

Obj_RobotnikHead3Init:
                lea     ObjDat_RobotnikHead(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #AniRaw_RobotnikHead,$30(a0)
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   RobotnikSK_DirectHeadCopyParentPriority
                bsr.w   EggRoboHead_SetVisualsAndQueueArt

RobotnikSK_DirectHeadCopyParentPriority:
                movea.w parent3(a0),a1
                btst    #7,art_tile(a1)
                beq.s   RobotnikSK_DirectHeadPriorityInitReturn
                bset    #7,art_tile(a0)

RobotnikSK_DirectHeadPriorityInitReturn:
                rts
; ---------------------------------------------------------------------------

Obj_RobotnikHead3Main:
                jsr     (Animate_Raw).l
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   RobotnikSK_DirectHeadSetDefeatFrame
                btst    #6,status(a1)
                beq.s   RobotnikSK_DirectHeadExpressionReturn
                move.b  #2,mapping_frame(a0)

RobotnikSK_DirectHeadExpressionReturn:
                rts
; ---------------------------------------------------------------------------

RobotnikSK_DirectHeadSetDefeatFrame:
                move.b  #4,routine(a0)
                move.b  #3,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

Obj_RobotnikHead3End:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.w   Obj_RobotnikHeadEnd
                lea     AniRaw_RobotnikHead(pc),a1
                jmp     (Animate_RawNoSST).l
; ---------------------------------------------------------------------------

Obj_RobotnikHead4:
                jsr     (Refresh_ChildPositionAdjusted).l
                jsr     (Child_GetPriority).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  RobotnikHead4_Index(pc,d0.w),d1
                jsr     RobotnikHead4_Index(pc,d1.w)
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   RobotnikSK_DirectHeadDeleteOnRelease
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

RobotnikSK_DirectHeadDeleteOnRelease:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
RobotnikHead4_Index:
                dc.w    Obj_RobotnikHead3Init-RobotnikHead4_Index
                dc.w    Obj_RobotnikHead3Main-RobotnikHead4_Index
                dc.w    Obj_RobotnikHead3End-RobotnikHead4_Index
; ---------------------------------------------------------------------------

Obj_MechaSonicHead:
                lea     ObjDat_MechaSonicHead(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #Obj_MechaSonicHeadMain,(a0)
                lea     (ArtKosM_MechaSonicHead).l,a1
                move.w  #tiles_to_bytes(ArtTile_RobotnikShip),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

Obj_MechaSonicHeadMain:
                jsr     (Refresh_ChildPositionAdjusted).l
                tst.b   (MechaSonicHeadDeleteOrOverlayLowByte).w
                bne.s   RobotnikSK_MechaHeadDeleteOnSceneFlag
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

RobotnikSK_MechaHeadDeleteOnSceneFlag:
                jmp     (Delete_Current_Sprite).l
