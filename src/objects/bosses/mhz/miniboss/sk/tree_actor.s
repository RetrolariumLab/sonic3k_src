; Owner: objects/bosses/mhz/miniboss/sk
; Responsibility: Mushroom Hill miniboss tree actor, scene interaction and child motion
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZMinibossTree:
                lea     ObjDat_MHZMinibossTree(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #MHZMini_TreeCheckBossOrReset,(a0)

MHZMini_TreeCheckBossOrReset:
                move.w  (SceneControllerObjectAddress).w,d0
                beq.s   MHZMinibossTree_DrawOrCullHorizontally
                movea.w d0,a1
                cmpi.l  #Obj_MHZMiniboss,(a1)
                bne.s   MHZMinibossTree_DrawOrCullHorizontally
                tst.b   render_flags(a0)
                bmi.s   MHZMini_TreeSyncStateAndTryLog
                move.b  #5,$42(a1)

MHZMini_TreeSyncStateAndTryLog:
                move.b  $42(a1),d0
                cmp.b   mapping_frame(a0),d0
                beq.s   MHZMinibossTree_DrawOrCullHorizontally
                move.b  d0,mapping_frame(a0)
                cmpi.b  #5,d0
                bhs.s   MHZMinibossTree_DrawOrCullHorizontally
                lea     MHZMinibossTree_SingleLogSimpleChild(pc),a2
                jsr     (CreateChild6_Simple).l

MHZMinibossTree_DrawOrCullHorizontally:
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------

MHZMini_InitLogHeightAndMotion:
                lea     MHZMinibossLog_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #MHZMini_LogAnimateAndTryBounce,(a0)
                move.b  #$18,y_radius(a0)
                movea.w (SceneControllerObjectAddress).w,a1
                moveq   #0,d2
                move.b  $42(a1),d2
                move.b  MHZMini_LogYOffsetsByTreeState(pc,d2.w),d3
                ext.w   d3
                add.w   d3,y_pos(a0)
                jsr     (Random_Number).l
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   MHZMini_ChooseStraightOrBouncingLog
                moveq   #0,d0

MHZMini_ChooseStraightOrBouncingLog:
                move.w  #-$400,d1
                btst    #0,d0
                beq.s   MHZMini_StoreLogXSpeedAndDraw
                tst.b   d2
                beq.s   MHZMini_StoreLogXSpeedAndDraw
                move.w  #-$200,d1
                sne     $3A(a0)

MHZMini_StoreLogXSpeedAndDraw:
                move.w  d1,x_vel(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
MHZMini_LogYOffsetsByTreeState:
                dc.b    $40, $20,   0,-$20,-$40,   0
                even
; ---------------------------------------------------------------------------

MHZMini_LogAnimateAndTryBounce:
                lea     MHZMinibossLog_UniformRollingFrameLoop(pc),a1
                jsr     (Animate_RawNoSST).l
                tst.b   $3A(a0)
                beq.s   MHZMini_LogMoveAndCull
                addi.w  #$20,y_vel(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   MHZMini_LogMoveAndCull
                neg.w   y_vel(a0)

MHZMini_LogMoveAndCull:
                jsr     (MoveSprite2).l
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

MHZMini_LogSyncAndSubmitTouch:
                bsr.w   SyncMHZMinibossFrameCollisionProxy
                jmp     (Child_AddToTouchList).l
; End of function Obj_MHZMinibossTree
