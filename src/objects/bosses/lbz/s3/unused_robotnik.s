; Owner: objects/bosses/lbz/s3
; Responsibility: Preserved unused Launch Base Robotnik actor initialization and state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZ2UnusedRobotnik:
                lea     ObjDat_LBZ2UnusedRobotnik(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #LBZShipS3_LegacyScaleMoveAndDraw,(a0)
                bset    #0,render_flags(a0)
                move.w  #tiles_to_bytes(ArtTile_LBZFinalBoss2),$3A(a0)
                move.b  #$30,$25(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$60,d0
                move.w  d0,x_pos(a0)
                move.w  d0,$30(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$100,d0
                move.w  d0,y_pos(a0)
                move.w  d0,$34(a0)
                move.w  #$800,x_vel(a0)
                move.w  #-$3C0,y_vel(a0)
                move.b  #4,$40(a0)
                move.l  #ArtScaled_LBZ2UnusedRobotnik,$42(a0)
                move.b  #1,$3E(a0)
                bsr.w   Perform_Art_Scaling
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZShipS3_LegacyScaleMoveAndDraw:
                bsr.w   LBZUnusedRobotnik_StepArtAndScale
                bsr.w   LBZUnusedRobotnik_AdjustVel
                bsr.w   LBZUnusedRobotnik_IntegrateAndProject
                jmp     (Draw_Sprite).l
; End of function Obj_LBZ2UnusedRobotnik
