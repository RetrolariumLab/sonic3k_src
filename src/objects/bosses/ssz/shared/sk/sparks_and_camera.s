; Owner: objects/bosses/ssz/shared/sk
; Responsibility: Mecha Sonic spark effects, parent interaction and associated camera transition callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MechaSonic_Sparks:
                lea     ObjDat_MechaSonic_Sparks(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SSZMechaSparks_WaitForPaletteTrigger,(a0)
                bclr    #7,subtype(a0)
                beq.s   SSZMechaSparks_WaitForPaletteTrigger
                bclr    #2,render_flags(a0)

SSZMechaSparks_WaitForPaletteTrigger:
                movea.w parent3(a0),a1
                btst    #6,$38(a1)
                bne.w   SSZMechaChildren_DeleteCurrent
                cmpi.w  #$E88,(Normal_palette_line_2+$12).w
                bne.w   SSZMechaBattleAndChildren_SharedReturn
                moveq   #signextendB(sfx_MechaSpark),d0
                jsr     (Play_SFX).l
                moveq   #0,d0
                bchg    #0,$39(a0)
                bne.s   SSZMechaSparks_SelectOffsetsFrameAndDraw
                moveq   #4,d0

SSZMechaSparks_SelectOffsetsFrameAndDraw:
                add.b   subtype(a0),d0
                lea     SSZMechaSparks_OffsetFrameRows(pc,d0.w),a2
                move.w  (a2)+,child_dx(a0)              ; and child_dy
                move.b  (a2)+,mapping_frame(a0)
                jsr     Refresh_ChildPositionAdjusted(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
SSZMechaSparks_OffsetFrameRows:
                dc.b    -4,  $C,   4
                even
                dc.b    0,   8,   5
                even
                dc.b    8,   4,   6
                even
                dc.b    8,   4,   7
                even
; ---------------------------------------------------------------------------

SSZMechaCollisionProxy_Initialize:
                lea     SSZMechaCollisionProxy_PartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #SSZMecha_TouchProxyFollowAndSubmit,(a0)

SSZMecha_TouchProxyFollowAndSubmit:
                bsr.w   SSZMechaProxy_SetFromParentFrame
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   SSZMechaCollisionProxy_DeleteWithParent
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

SSZMechaCollisionProxy_DeleteWithParent:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

SSZMecha_InitCameraScrollLock:
                move.b  #1,(Scroll_lock).w
                move.l  #SSZMecha_StopPlayerAndAdvanceCamera,(a0)
                rts
; ---------------------------------------------------------------------------

SSZMecha_StopPlayerAndAdvanceCamera:
                bsr.w   SSZScene_ClearP1Velocities
                move.w  (Camera_X_pos).w,d0
                move.w  x_vel(a0),d1
                move.w  (Camera_max_X_pos).w,d2
                addq.w  #6,d0
                cmp.w   d2,d0
                bhs.s   SSZMechaCameraAdvance_ClampAndDelete
                move.w  d0,(Camera_X_pos).w
                rts
; ---------------------------------------------------------------------------

SSZMechaCameraAdvance_ClampAndDelete:
                move.w  d2,(Camera_X_pos).w
                jmp     (Delete_Current_Sprite).l
; End of function SSZMecha_StopPlayerAndAdvanceCamera
