; Owner: objects/enemies/sk
; Responsibility: Fireworm enemy, linked motion, attacks, collision and private object resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Fireworm:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Fireworm_Index(pc,d0.w),d1
                jsr     Fireworm_Index(pc,d1.w)
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------
Fireworm_Index:
                dc.w    SKFirewormSpawn_InitSpawnMarker-Fireworm_Index
                dc.w    SKFirewormSpawn_CheckNearestPlayer-Fireworm_Index
                dc.w    SKFirewormSpawn_Spent-Fireworm_Index
; ---------------------------------------------------------------------------

SKFirewormSpawn_InitSpawnMarker:
                lea     FirewormSK_Placeholder_FullAttributes(pc),a1
                jmp     (SetUp_ObjAttributes).l
; ---------------------------------------------------------------------------

SKFirewormSpawn_CheckNearestPlayer:
                jsr     (Find_SonicTails).l
                cmpi.w  #$80,d2
                blo.s   SKFirewormSpawn_TrySpawnHead
                rts
; ---------------------------------------------------------------------------

; Consume the spawn attempt even if allocating the head failed
SKFirewormSpawn_TrySpawnHead:
                move.b  #4,routine(a0)
                lea     SKFirewormSpawn_HeadChild(pc),a2
                jsr     (CreateChild1_Normal).l
                bne.s   SKFirewormSpawn_SpawnReturn
                move.b  subtype(a0),subtype(a1)

SKFirewormSpawn_SpawnReturn:
                rts
; ---------------------------------------------------------------------------

SKFirewormSpawn_Spent:
                rts
; ---------------------------------------------------------------------------

SKFirewormHead_DispatchHeadAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  FirewormSK_Head_FiveRelativeStateOffsets(pc,d0.w),d1
                jsr     FirewormSK_Head_FiveRelativeStateOffsets(pc,d1.w)
                lea     DPLCPtr_Fireworm(pc),a2
                jsr     (Perform_DPLC).l
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   SKFirewormHead_ReleaseSlotAndDelete
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKFirewormHead_ReleaseSlotAndDelete:
                jmp     (Go_Delete_SpriteSlotted2).l
; ---------------------------------------------------------------------------
FirewormSK_Head_FiveRelativeStateOffsets:
                dc.w    SKFirewormHead_InitHead-FirewormSK_Head_FiveRelativeStateOffsets
                dc.w    SKFirewormHead_BeginApproachToP1-FirewormSK_Head_FiveRelativeStateOffsets
                dc.w    SKFirewormHead_MoveAndTickApproach-FirewormSK_Head_FiveRelativeStateOffsets
                dc.w    SKFirewormMove_SwingAndAnimate-FirewormSK_Head_FiveRelativeStateOffsets
                dc.w    SKFirewormMove_AnimateTurnAndAccelLeft-FirewormSK_Head_FiveRelativeStateOffsets
; ---------------------------------------------------------------------------

SKFirewormHead_InitHead:
                lea     ObjSlot_Fireworm(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l

SKFirewormHead_BeginApproachToP1:
                move.b  #4,routine(a0)
                move.w  #3,$2E(a0)
                move.l  #SKFirewormHead_TrySpawnSegmentsAndSwing,$34(a0)
                move.w  #-$100,d4
                jmp     (Set_VelocityXTrackSonic).l
; ---------------------------------------------------------------------------

SKFirewormHead_MoveAndTickApproach:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKFirewormHead_TrySpawnSegmentsAndSwing:
                move.b  #1,mapping_frame(a0)
                lea     FirewormSK_Head_FourNormalSegmentRecords(pc),a2
                jsr     (CreateChild1_Normal).l

SKFirewormMove_InitSwing:
                move.b  #6,routine(a0)
                move.w  #-$100,$42(a0)
                move.l  #SKFirewormMove_SwingAnimation,$30(a0)

SKFirewormMove_ResetSwingBudget:
                move.b  #8,$39(a0)
                move.w  #$80,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

SKFirewormMove_SwingAndAnimate:
                jsr     (Swing_UpAndDown_Count).l
                bne.s   SKFirewormMove_BeginTurn
                jsr     (MoveSprite2).l
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

SKFirewormMove_BeginTurn:
                move.b  #8,routine(a0)
                move.w  x_vel(a0),$44(a0)
                move.w  $42(a0),y_vel(a0)
                neg.w   $42(a0)
                clr.w   $2E(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKFirewormMove_AnimateTurnAndAccelLeft:
                lea     FirewormSK_Mover_SuppliedFlipXTurnPairs(pc),a1
                jsr     (Animate_RawNoSSTMultiDelayFlipX).l
                addq.w  #1,$2E(a0)
                tst.w   $44(a0)
                bmi.s   SKFirewormMove_AccelRight
                move.w  x_vel(a0),d0
                subi.w  #$10,d0
                cmpi.w  #-$100,d0
                ble.s   SKFirewormMove_ResumeSwing
                move.w  d0,x_vel(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

SKFirewormMove_AccelRight:
                move.w  x_vel(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$100,d0
                bge.s   SKFirewormMove_ResumeSwing
                move.w  d0,x_vel(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

; Resume when the proposed speed reaches its bound. Keep the last stored speed
SKFirewormMove_ResumeSwing:
                move.b  #6,routine(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                bra.w   SKFirewormMove_ResetSwingBudget
; ---------------------------------------------------------------------------

SKFirewormSeg_DispatchSegmentAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKFirewormSeg_SegmentStateOffsets(pc,d0.w),d1
                jsr     SKFirewormSeg_SegmentStateOffsets(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
SKFirewormSeg_SegmentStateOffsets:
                dc.w    SKFirewormSeg_InitStaggeredSegment-SKFirewormSeg_SegmentStateOffsets
                dc.w    SKFirewormSeg_TickStaggerDelay-SKFirewormSeg_SegmentStateOffsets
                dc.w    SKFirewormSeg_TickStaggerDelay-SKFirewormSeg_SegmentStateOffsets
                dc.w    SKFirewormMove_SwingAndAnimate-SKFirewormSeg_SegmentStateOffsets
                dc.w    SKFirewormMove_AnimateTurnAndAccelLeft-SKFirewormSeg_SegmentStateOffsets
; ---------------------------------------------------------------------------

SKFirewormSeg_InitStaggeredSegment:
                lea     FirewormSK_Segment_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  FirewormSK_Segment_FourStaggerDelayWords(pc,d0.w),$2E(a0)
                move.l  #SKFirewormSeg_TrySpawnFlameAndSwing,$34(a0)
                movea.w parent3(a0),a1
                move.w  x_vel(a1),x_vel(a0)
                move.b  render_flags(a1),render_flags(a0)
                rts
; ---------------------------------------------------------------------------
FirewormSK_Segment_FourStaggerDelayWords:
                dc.w    $B,   $16,   $21,   $2C
; ---------------------------------------------------------------------------

SKFirewormSeg_TickStaggerDelay:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKFirewormSeg_TrySpawnFlameAndSwing:
                lea     FirewormSK_Segment_OneNormalFlameRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                bra.w   SKFirewormMove_InitSwing
; ---------------------------------------------------------------------------

SKFirewormFlame_FollowAndDispatchFlame:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKFirewormFlame_FlameStateOffsets(pc,d0.w),d1
                jsr     SKFirewormFlame_FlameStateOffsets(pc,d1.w)
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------
SKFirewormFlame_FlameStateOffsets:
                dc.w    SKFirewormFlame_InitFlame-SKFirewormFlame_FlameStateOffsets
                dc.w    FirewormSK_Flame_DecodeUniformAnimation-SKFirewormFlame_FlameStateOffsets
                dc.w    FirewormSK_Flame_CountRandomWordWait-SKFirewormFlame_FlameStateOffsets
; ---------------------------------------------------------------------------

SKFirewormFlame_InitFlame:
                lea     FirewormSK_Flame_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SKFirewormFlame_FlameAnimation,$30(a0)
                move.l  #SKFirewormFlame_BeginRandomPause,$34(a0)
                bset    #4,shield_reaction(a0)
                rts
; ---------------------------------------------------------------------------

FirewormSK_Flame_DecodeUniformAnimation:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

SKFirewormFlame_BeginRandomPause:
                move.b  #4,routine(a0)
                move.b  #7,mapping_frame(a0)
                jsr     (Random_Number).l
                andi.w  #$3F,d0
                move.w  d0,$2E(a0)
                move.l  #SKFirewormFlame_ResumeFlameAnimation,$34(a0)
                rts
; ---------------------------------------------------------------------------

FirewormSK_Flame_CountRandomWordWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKFirewormFlame_ResumeFlameAnimation:
                move.b  #2,routine(a0)
                move.l  #SKFirewormFlame_BeginRandomPause,$34(a0)
                rts
; ---------------------------------------------------------------------------
FirewormSK_Placeholder_FullAttributes:
                dc.l    Map_FirewormSegments
                dc.w    make_art_tile(ArtTile_FirewormSegments,3,1)
                dc.w    $280
                dc.b    $C,  $C,   0,   0
ObjSlot_Fireworm:
                dc.w    2-1
                dc.w    make_art_tile(ArtTile_Fireworm,1,1)
                dc.w    9,     0
                dc.l    Map_Fireworm
                dc.w    $180
                dc.b    $C,  $C,   0, $1A
FirewormSK_Segment_FullAttributes:
                dc.l    Map_FirewormSegments
                dc.w    make_art_tile(ArtTile_FirewormSegments,1,1)
                dc.w    $200
                dc.b    8,   8,   1, $98
FirewormSK_Flame_PartialAttributes:
                dc.w    $180
                dc.b    8,   8,   3, $98
SKFirewormSpawn_HeadChild:
                dc.w    1-1
                dc.l    SKFirewormHead_DispatchHeadAndDraw
                dc.b    0,  -8
FirewormSK_Head_FourNormalSegmentRecords:
                dc.w    4-1
                dc.l    SKFirewormSeg_DispatchSegmentAndDraw
                dc.b    0,   0
                dc.l    SKFirewormSeg_DispatchSegmentAndDraw
                dc.b    0,   0
                dc.l    SKFirewormSeg_DispatchSegmentAndDraw
                dc.b    0,   0
                dc.l    SKFirewormSeg_DispatchSegmentAndDraw
                dc.b    0,   0
FirewormSK_Segment_OneNormalFlameRecord:
                dc.w    1-1
                dc.l    SKFirewormFlame_FollowAndDispatchFlame
                dc.b    0, -$E
DPLCPtr_Fireworm:
                dc.l    ArtUnc_Fireworm
                dc.l    DPLC_Fireworm
SKFirewormMove_SwingAnimation:
                dc.b    1,   3
                dc.b    1,   6
                dc.b    2,   8
                dc.b    3,   1
                dc.b    $F8, .jump-SKFirewormMove_SwingAnimation

                .jump:
                dc.b    3, $7F
                dc.b    $FC
FirewormSK_Mover_SuppliedFlipXTurnPairs:
                dc.b    3,       7
                dc.b    2,       7
                dc.b    2|$40,   7
                dc.b    3,     $7F
                dc.b    $FC
SKFirewormFlame_FlameAnimation:
                dc.b    3,   4,   4,   5,   6, $F4
                even
Map_FirewormSegments:
                include "src/objects/shared/fireworm/mappings/segments.s"
DPLC_Fireworm:
                include "src/objects/shared/fireworm/dplc/fireworm.s"
Map_Fireworm:
                include "src/objects/shared/fireworm/mappings/fireworm.s"
