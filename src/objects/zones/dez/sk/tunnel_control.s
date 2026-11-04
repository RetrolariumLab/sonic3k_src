; Owner: objects/zones/dez/sk
; Responsibility: Tunnel movement control, path state, transition-ring spawning and transport effects
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZTunnelControl:
                move.b  #$A,$31(a0)
                move.b  #$A,$39(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKDEZTunnelCtrl_InitTunnelControl
                move.l  #Obj_DEZTransRingSpawner,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  a1,objoff_2E(a0)
                move.b  #2,$40(a0)

SKDEZTunnelCtrl_InitTunnelControl:
                move.l  #Obj_DEZTunnelControl_Main,(a0)

Obj_DEZTunnelControl_Main:
                lea     (Player_1).w,a1
                lea     $30(a0),a4
                bsr.s   AdvanceDezLightTunnelActor
                lea     (Player_2).w,a1
                lea     $38(a0),a4
                bsr.s   AdvanceDezLightTunnelActor
                movea.w objoff_2E(a0),a1
                lea     $40(a0),a4
                bsr.s   AdvanceDezLightTunnelActor
                move.b  $30(a0),d0
                add.b   $38(a0),d0
                beq.s   SKDEZTunnelCtrl_CullWhenBothInactive
                rts
; ---------------------------------------------------------------------------

SKDEZTunnelCtrl_CullWhenBothInactive:
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

AdvanceDezLightTunnelActor:
                moveq   #0,d0
                move.b  dezTunnel_routine(a4),d0
                move.w  SKDEZTunnelCtrl_RiderStateOffsets(pc,d0.w),d0
                jmp     SKDEZTunnelCtrl_RiderStateOffsets(pc,d0.w)
; End of function AdvanceDezLightTunnelActor

; ---------------------------------------------------------------------------
SKDEZTunnelCtrl_RiderStateOffsets:
                dc.w    DEZTunnelControl_Done-SKDEZTunnelCtrl_RiderStateOffsets
                dc.w    DEZTunnelControl_Setup-SKDEZTunnelCtrl_RiderStateOffsets
                dc.w    DEZTunnelControl_Normal-SKDEZTunnelCtrl_RiderStateOffsets
                dc.w    DEZTunnelControl_CircleLarge-SKDEZTunnelCtrl_RiderStateOffsets
                dc.w    DEZTunnelControl_CircleSmall-SKDEZTunnelCtrl_RiderStateOffsets
                dc.w    DEZTunnelControl_SineDown-SKDEZTunnelCtrl_RiderStateOffsets
                dc.w    DEZTunnelControl_SineUp-SKDEZTunnelCtrl_RiderStateOffsets
; ---------------------------------------------------------------------------

DEZTunnelControl_Done:
                rts
; ---------------------------------------------------------------------------

DEZTunnelControl_Setup:
                subq.b  #1,dezTunnel_timer(a4)
                bpl.s   SKDEZTunnelCtrl_SetupReturn
                addq.b  #2,dezTunnel_routine(a4)
                move.b  #2,anim(a1)
                clr.b   jumping(a1)
                move.b  #$81,object_control(a1)
                move.w  #$800,ground_vel(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.w  #0,angle(a1)
                bset    #1,status(a1)
                bsr.w   DEZLightTunnel_LoadPathData
                cmpi.l  #Obj_DEZTransRingSpawner,(a1)
                beq.s   SKDEZTunnelCtrl_SetupReturn
                cmpi.l  #Obj_DEZTransRingSpawner_Main,(a1)
                beq.s   SKDEZTunnelCtrl_SetupReturn
                move.b  #$96,mapping_frame(a1)
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jmp     (Perform_Player_DPLC).l
; ---------------------------------------------------------------------------

SKDEZTunnelCtrl_SetupReturn:
                rts
; ---------------------------------------------------------------------------

DEZTunnelControl_Normal:
                subq.b  #1,dezTunnel_timer(a4)
                bhi.w   DEZTunnelControl_MoveSprite
                movea.l dezTunnel_currentWaypoint(a4),a2
                move.w  (a2)+,d4
                move.w  d4,x_pos(a1)
                move.w  (a2)+,d5
                move.w  d5,y_pos(a1)
                move.l  a2,dezTunnel_currentWaypoint(a4)

DEZTunnelControl_ReadWaypoint:
                subq.b  #1,dezTunnel_waypointsLeft(a4)
                beq.s   DEZTunnelControl_ReleaseSprite
                tst.b   (a2)
                bpl.s   DEZTunnelControl_NextWaypoint
                move.b  (a2)+,d4
                andi.w  #$7F,d4
                cmpi.l  #Obj_DEZTransRingSpawner_Main,(a1)
                bne.s   SKDEZTunnelCtrl_DecodeCurveAndCenter
                moveq   #0,d0
                move.b  DEZTunnelControl_WaitTimers(pc,d4.w),d0
                move.w  d0,objoff_30(a1)

SKDEZTunnelCtrl_DecodeCurveAndCenter:
                add.b   d4,d4
                move.w  DEZTunnelControl_ScaleFactors(pc,d4.w),d2
                addq.b  #2,d4
                add.b   d4,dezTunnel_routine(a4)
                move.b  (a2)+,dezTunnel_timer(a4)
                move.b  (a2)+,d0
                move.b  d0,dezTunnel_angle(a4)
                addi.b  #$20,d0
                andi.b  #$C0,d0
                jsr     (GetSineCosine).l
                muls.w  d2,d0
                muls.w  d2,d1
                asr.l   #8,d0
                asr.l   #8,d1
                add.w   x_pos(a1),d0
                move.w  d0,$12(a1)
                add.w   y_pos(a1),d1
                move.w  d1,$16(a1)
                cmpi.b  #$A,dezTunnel_routine(a4)
                blo.s   SKDEZTunnelCtrl_CurveInitReturn
                move.w  y_pos(a1),$16(a1)

SKDEZTunnelCtrl_CurveInitReturn:
                rts
; ---------------------------------------------------------------------------
DEZTunnelControl_ScaleFactors:
                dc.w    -$80
                dc.w    -$40
                dc.w    -$80
                dc.w    -$80
DEZTunnelControl_WaitTimers:
                dc.b    1
                dc.b    0
                dc.b    1
                dc.b    1
                even
; ---------------------------------------------------------------------------

DEZTunnelControl_NextWaypoint:
                move.w  (a2)+,d4
                move.w  (a2)+,d5
                move.w  #$C00,d2
                bra.w   DEZLightTunnel_SetupWaypoint
; ---------------------------------------------------------------------------

DEZTunnelControl_ReleaseSprite:
                clr.b   object_control(a1)
                clr.b   dezTunnel_routine(a4)
                rts
; ---------------------------------------------------------------------------

DEZTunnelControl_MoveSprite:
                move.l  x_pos(a1),d2
                move.l  y_pos(a1),d3
                move.w  x_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d2
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d3
                move.l  d2,x_pos(a1)
                move.l  d3,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

DEZTunnelControl_CircleLarge:
                move.b  dezTunnel_angle(a4),d0
                jsr     (GetSineCosine).l
                asr.w   #1,d0
                asr.w   #1,d1
                bra.s   DEZTunnelControl_DoCircle
; ---------------------------------------------------------------------------

DEZTunnelControl_CircleSmall:
                move.b  dezTunnel_angle(a4),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d0
                asr.w   #2,d1

DEZTunnelControl_DoCircle:
                add.w   $12(a1),d0
                move.w  d0,d2
                sub.w   x_pos(a1),d2
                move.w  d0,x_pos(a1)
                asl.w   #8,d2
                move.w  d2,x_vel(a1)
                add.w   $16(a1),d1
                move.w  d1,d2
                sub.w   y_pos(a1),d2
                move.w  d1,y_pos(a1)
                asl.w   #8,d2
                move.w  d2,y_vel(a1)
                movea.l dezTunnel_currentWaypoint(a4),a2
                move.w  (a2)+,d4
                move.w  (a2)+,d5
                cmp.b   dezTunnel_angle(a4),d5
                bne.s   SKDEZTunnelCtrl_StepCircleAngle
                move.b  #4,dezTunnel_routine(a4)
                move.l  a2,dezTunnel_currentWaypoint(a4)
                bra.w   DEZTunnelControl_ReadWaypoint
; ---------------------------------------------------------------------------

SKDEZTunnelCtrl_StepCircleAngle:
                add.b   d4,dezTunnel_angle(a4)
                rts
; ---------------------------------------------------------------------------

DEZTunnelControl_SineDown:
                addq.w  #3,y_pos(a1)
                move.w  #$300,y_vel(a1)
                bra.s   DEZTunnelControl_DoSine
; ---------------------------------------------------------------------------

DEZTunnelControl_SineUp:
                subq.w  #3,y_pos(a1)
                move.w  #-$300,y_vel(a1)

DEZTunnelControl_DoSine:
                move.b  #-1,angle(a1)
                move.b  dezTunnel_angle(a4),d0
                move.b  d0,flip_angle(a1)
                jsr     (GetSineCosine).l
                asr.w   #1,d0
                asr.w   #2,d1
                add.w   $12(a1),d0
                move.w  d0,d2
                sub.w   x_pos(a1),d2
                move.w  d0,x_pos(a1)
                asl.w   #8,d2
                move.w  d2,x_vel(a1)
                movea.l dezTunnel_currentWaypoint(a4),a2
                move.w  (a2)+,d4
                move.w  (a2)+,d5
                cmp.b   dezTunnel_angle(a4),d5
                bne.s   SKDEZTunnelCtrl_StepSineAngle
                move.b  #4,dezTunnel_routine(a4)
                move.w  #0,angle(a1)
                move.l  a2,dezTunnel_currentWaypoint(a4)
                bra.w   DEZTunnelControl_ReadWaypoint
; ---------------------------------------------------------------------------

SKDEZTunnelCtrl_StepSineAngle:
                add.b   d4,dezTunnel_angle(a4)
                rts

; =============== S U B R O U T I N E =======================================

DEZLightTunnel_LoadPathData:
                move.b  subtype(a0),d0
                andi.w  #$1F,d0
                add.w   d0,d0
                add.w   d0,d0
                lea     (DEZTunnelPaths).l,a2
                movea.l (a2,d0.w),a2
                move.w  (a2)+,d0
                subq.b  #1,d0
                move.b  d0,dezTunnel_waypointsLeft(a4)
                move.w  (a2)+,d4
                move.w  d4,x_pos(a1)
                move.w  (a2)+,d5
                move.w  d5,y_pos(a1)
                move.l  a2,dezTunnel_currentWaypoint(a4)
                move.w  (a2)+,d4
                move.w  (a2)+,d5
                move.w  #$C00,d2

DEZLightTunnel_SetupWaypoint:
                moveq   #0,d0
                move.w  d2,d3
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                bge.s   SKDEZTunnelCtrl_GetWaypointYDistance
                neg.w   d0
                neg.w   d2

SKDEZTunnelCtrl_GetWaypointYDistance:
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a1),d1
                bge.s   SKDEZTunnelCtrl_ChooseDominantAxis
                neg.w   d1
                neg.w   d3

SKDEZTunnelCtrl_ChooseDominantAxis:
                cmp.w   d0,d1
                blo.s   DEZLightTunnel_SetupHorizontal
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a1),d1
                swap    d1
                divs.w  d3,d1
                moveq   #0,d0
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                beq.s   SKDEZTunnelCtrl_StoreYDominantSpeeds
                swap    d0
                divs.w  d1,d0

SKDEZTunnelCtrl_StoreYDominantSpeeds:
                move.w  d0,x_vel(a1)
                move.w  d3,y_vel(a1)
                tst.w   d1
                bpl.s   SKDEZTunnelCtrl_StoreYTravelTimer
                neg.w   d1

SKDEZTunnelCtrl_StoreYTravelTimer:
                lsr.w   #8,d1
                move.b  d1,dezTunnel_timer(a4)
                rts
; ---------------------------------------------------------------------------

DEZLightTunnel_SetupHorizontal:
                moveq   #0,d0
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                swap    d0
                divs.w  d2,d0
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a1),d1
                beq.s   SKDEZTunnelCtrl_StoreXDominantSpeeds
                swap    d1
                divs.w  d0,d1

SKDEZTunnelCtrl_StoreXDominantSpeeds:
                move.w  d1,y_vel(a1)
                move.w  d2,x_vel(a1)
                tst.w   d0
                bpl.s   SKDEZTunnelCtrl_StoreXTravelTimer
                neg.w   d0

SKDEZTunnelCtrl_StoreXTravelTimer:
                lsr.w   #8,d0
                move.b  d0,dezTunnel_timer(a4)
                rts
; End of function DEZLightTunnel_LoadPathData

; ---------------------------------------------------------------------------

Obj_DEZTransRingSpawner:
                move.w  #7,objoff_30(a0)
                move.l  #Obj_DEZTransRingSpawner_Main,(a0)

Obj_DEZTransRingSpawner_Main:
                subq.w  #1,objoff_30(a0)
                bpl.w   SKDEZTunnelCtrl_CheckRiderControl
                move.w  #1,objoff_30(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKDEZTunnelCtrl_PlayRingSpawnSound
                move.l  #Obj_DEZTransRing,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_DEZTransRings,mappings(a1)
                move.w  #make_art_tile(ArtTile_DEZMisc+$38,1,0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.w  #$80,priority(a1)
                cmpi.b  #-1,angle(a0)
                bne.s   DEZTransRing_NormalAnim
                move.b  flip_angle(a0),d1
                move.w  #0,priority(a1)
                move.b  d1,d0
                add.b   d0,d0
                bpl.s   DEZTransRing_SineAnim
                bset    #0,status(a1)
                move.w  #$80,priority(a1)

DEZTransRing_SineAnim:
                addq.b  #8,d1
                lsr.b   #4,d1
                andi.b  #7,d1
                addq.b  #8,d1
                move.b  d1,anim(a1)
                bra.s   SKDEZTunnelCtrl_PlayRingSpawnSound
; ---------------------------------------------------------------------------

DEZTransRing_NormalAnim:
                move.w  x_vel(a0),d1
                move.w  y_vel(a0),d2
                jsr     (GetArcTan).l
                addq.b  #8,d0
                lsr.b   #4,d0
                andi.b  #7,d0
                move.b  d0,anim(a1)

; Play the tunnel sound even when allocating its ring failed
SKDEZTunnelCtrl_PlayRingSpawnSound:
                moveq   #signextendB(sfx_LightTunnel),d0
                jsr     (Play_SFX).l

SKDEZTunnelCtrl_CheckRiderControl:
                tst.b   object_control(a0)
                beq.s   SKDEZTunnelCtrl_DeleteRingSpawner
                rts
; ---------------------------------------------------------------------------

SKDEZTunnelCtrl_DeleteRingSpawner:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_DEZTransRing:
                lea     (Ani_DEZTransRings).l,a1
                jsr     (Animate_Sprite).l
                tst.b   routine(a0)
                beq.s   SKDEZTunnelCtrl_DrawTransportRing
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKDEZTunnelCtrl_DrawTransportRing:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_DEZTransRings:
                include "src/objects/shared/zones/dez/animations/transporter_rings.s"
Map_DEZTransRings:
                include "src/objects/shared/zones/dez/mappings/transporter_rings.s"
; End of function Obj_DEZTransRing
