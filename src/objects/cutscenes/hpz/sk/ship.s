; Owner: objects/cutscenes/hpz/sk
; Responsibility: Hidden Palace ship actor state, synchronized motion and interaction callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

HPZShip_InitReferenceAndAttachments:
                lea     SKHpzSszSceneShip_CoreAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  a0,(_unkFAAE).w
                move.l  #HPZShip_WaitForCraneSignal,(a0)
                bset    #0,render_flags(a0)
                move.w  #$1640,x_pos(a0)
                move.w  #$2D0,y_pos(a0)
                lea     (Child1_MakeRoboHead4).l,a2
                jsr     (CreateChild1_Normal).l
                lea     SKHpzShip_LiftingCraneHeadSpawnList(pc),a2
                jsr     (CreateChild1_Normal).l

HPZShip_WaitForCraneSignal:
                btst    #2,$38(a0)
                beq.s   HPZShip_DrawWaitingShip
                move.l  #HPZShip_MoveInitialDriftAndTick,(a0)
                move.w  #$100,x_vel(a0)
                move.w  #$180,y_vel(a0)
                move.w  #$40,$2E(a0)
                move.l  #HPZShip_BeginSwingAndTryFlame,$34(a0)

HPZShip_DrawWaitingShip:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HPZShip_MoveInitialDriftAndTick:
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HPZShip_BeginSwingAndTryFlame:
                move.l  #HPZShip_SwingAndAdvance,(a0)
                clr.w   x_vel(a0)
                jsr     (Swing_Setup1).l
                lea     (Child1_MakeRoboShipFlame).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

HPZShip_SwingAndAdvance:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                btst    #6,status(a0)
                bne.s   HPZShip_CheckApproachAndSpawnCranes
                addq.w  #2,x_pos(a0)

HPZShip_CheckApproachAndSpawnCranes:
                cmpi.w  #$1890,x_pos(a0)
                blo.s   HPZShip_TickHitPauseAndDraw
                move.l  #HPZShip_CheckBothCranesReady,(a0)
                bset    #4,$38(a0)
                clr.w   x_vel(a0)
                move.b  #$F,collision_flags(a0)
                move.b  #-1,collision_property(a0)
                lea     SKHpzShip_TwoCraneBranchRootsSpawnList(pc),a2
                jsr     (CreateChild3_NormalRepeated).l

HPZShip_TickHitPauseAndDraw:
                bsr.w   HPZShip_TickMovingHitPause
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HPZShip_CheckBothCranesReady:
                move.b  (_unkFAB8).w,d0
                andi.b  #$C,d0
                cmpi.b  #$C,d0
                bne.s   HPZShip_SwingFlashAndDrawTouch
                move.l  #HPZShip_WaitForDepartureAndSetSpeed,(a0)
                bset    #4,(_unkFAB8).w

HPZShip_SwingFlashAndDrawTouch:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                bsr.w   HPZShip_TickHitFlashAndRestoreColl
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

HPZShip_WaitForDepartureAndSetSpeed:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                btst    #5,(_unkFAB8).w
                beq.s   HPZShip_FlashAndDrawDeparture
                move.l  #HPZShip_MoveExitAndCheckCameraMargin,(a0)
                move.w  #$190,x_vel(a0)
                bclr    #4,$38(a0)
                lea     (Child1_MakeRoboShipFlame).l,a2
                jsr     (CreateChild1_Normal).l

HPZShip_FlashAndDrawDeparture:
                bsr.w   HPZShip_TickHitFlashAndRestoreColl
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

HPZShip_MoveExitAndCheckCameraMargin:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$200,d0
                cmp.w   x_pos(a0),d0
                blo.s   HPZShip_DeleteEmeraldAndQueueWarp
                bsr.w   HPZShip_TickHitFlashAndRestoreColl
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

HPZShip_DeleteEmeraldAndQueueWarp:
                ori.b   #$30,$38(a0)
                movea.w (_unkFABA).w,a1
                jsr     (Delete_Referenced_Sprite).l
                clr.w   (_unkFABA).w
                clr.w   (Palette_cycle_counter1).w
                lea     (ArtKosM_Teleporter).l,a1
                move.w  #tiles_to_bytes(ArtTile_HPZTeleporter),d2
                jsr     (Queue_Kos_Module).l
                jmp     (Go_Delete_Sprite).l
; End of function HPZShip_InitReferenceAndAttachments
