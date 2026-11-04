; Owner: objects/zones/fbz/sk
; Responsibility: Floating platform movement, player riding and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
SKFBZFloatPlat_MotionTable:
                dc.l    SKFBZFloatPlat_BobVertically
                dc.l    SKFBZFloatPlat_ReadSmallOscillator
                dc.l    SKFBZFloatPlat_ReadLargeOscillator
                dc.l    SKFBZFloatPlat_CalcSignedOrbitAngle
                dc.l    SKFBZFloatPlat_TryLatchStanding
; ---------------------------------------------------------------------------

Obj_FBZFloatingPlatform:
                move.l  #Map_FBZFloatingPlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc+$A,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  #$8C,collision_flags(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$70,d0
                lsr.w   #2,d0
                move.l  SKFBZFloatPlat_MotionTable(pc,d0.w),$40(a0)
                andi.w  #$F,d1
                lsl.w   #4,d1
                move.b  d1,angle(a0)
                move.l  #SKFBZFloatPlat_UpdateMotionAndSolid,(a0)

SKFBZFloatPlat_UpdateMotionAndSolid:
                move.w  x_pos(a0),-(sp)
                movea.l $40(a0),a1
                jsr     (a1)
                move.w  #$2B,d1
                move.w  #$C,d2
                move.w  #-$D,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull_Offset).l
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKFBZFloatPlat_DrawFromBaseX
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #3,mapping_frame(a0)
                blo.s   SKFBZFloatPlat_DrawFromBaseX
                move.b  #0,mapping_frame(a0)

SKFBZFloatPlat_DrawFromBaseX:
                move.w  $44(a0),d0
                jmp     (SKTouchCull_TestAnchorAndDraw).l
; ---------------------------------------------------------------------------

SKFBZFloatPlat_BobVertically:
                move.b  $27(a0),d0
                addq.b  #1,$27(a0)
                jsr     (GetSineCosine).l
                asr.w   #5,d0
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKFBZFloatPlat_ReadSmallOscillator:
                moveq   #0,d0
                move.b  (Oscillating_table+$0A).w,d0
                subi.w  #$20,d0
                bra.s   SKFBZFloatPlat_SignVerticalOffset
; ---------------------------------------------------------------------------

SKFBZFloatPlat_ReadLargeOscillator:
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                subi.w  #$40,d0

SKFBZFloatPlat_SignVerticalOffset:
                btst    #0,status(a0)
                beq.s   SKFBZFloatPlat_SetYFromBase
                neg.w   d0

SKFBZFloatPlat_SetYFromBase:
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKFBZFloatPlat_CalcSignedOrbitAngle:
                move.b  (Level_frame_counter+1).w,d0
                btst    #0,status(a0)
                beq.s   SKFBZFloatPlat_ProjectOrbit64
                neg.b   d0

SKFBZFloatPlat_ProjectOrbit64:
                add.b   angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d0
                asr.w   #2,d1
                add.w   $44(a0),d0
                move.w  d0,x_pos(a0)
                add.w   $46(a0),d1
                move.w  d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKFBZFloatPlat_TryLatchStanding:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   SKFBZFloatPlat_BobVertically
                move.l  #SKFBZFloatPlat_WaitForPulsePhase,$40(a0)

SKFBZFloatPlat_WaitForPulsePhase:
                move.b  $27(a0),d0
                andi.b  #$7F,d0
                bne.w   SKFBZFloatPlat_BobVertically
                move.l  #SKFBZFloatPlat_AcceleratePulse,$40(a0)
                move.b  #0,$27(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lsl.w   #1,d0
                addi.w  #$28,d0
                move.w  d0,$36(a0)

SKFBZFloatPlat_AcceleratePulse:
                move.w  $36(a0),d2
                subq.w  #1,d2
                tst.b   $30(a0)
                bne.s   SKFBZFloatPlat_DeceleratePulse
                move.w  $34(a0),d1
                addq.w  #4,d1
                move.w  d1,$34(a0)
                add.w   d1,$32(a0)
                cmp.b   $32(a0),d2
                bhi.s   SKFBZFloatPlat_ScaleAndSignPulse
                move.b  #1,$30(a0)
                bra.s   SKFBZFloatPlat_ScaleAndSignPulse
; ---------------------------------------------------------------------------

SKFBZFloatPlat_DeceleratePulse:
                move.w  $34(a0),d1
                subq.w  #4,d1
                move.w  d1,$34(a0)
                add.w   d1,$32(a0)
                cmp.b   $32(a0),d2
                bls.s   SKFBZFloatPlat_ScaleAndSignPulse
                move.b  #0,$30(a0)

SKFBZFloatPlat_ScaleAndSignPulse:
                moveq   #0,d0
                move.w  $32(a0),d0
                lsr.w   #6,d0
                btst    #0,status(a0)
                beq.s   SKFBZFloatPlat_PlacePulseOrResumeBob
                neg.w   d0

; When the pulse stops, keep the new baseline and switch to ordinary bobbing
SKFBZFloatPlat_PlacePulseOrResumeBob:
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                tst.w   $34(a0)
                bne.s   SKFBZFloatPlat_PulseReturn
                move.w  y_pos(a0),$46(a0)
                move.l  #SKFBZFloatPlat_BobVertically,$40(a0)

SKFBZFloatPlat_PulseReturn:
                rts
; ---------------------------------------------------------------------------
Map_FBZFloatingPlatform:
                include "src/objects/shared/zones/fbz/mappings/floating_platform.s"
