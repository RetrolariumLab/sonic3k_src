; Owner: objects/zones/fbz/sk
; Responsibility: Magnetic pendulum motion, attraction, player interactions and coordinated sprites
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZMagneticPendulum:
                move.l  #SKFBZPend_CullAndSignalContact,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$180,priority(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc2+$51,1,0),art_tile(a0)
                move.l  #Map_FBZMagneticPendulum,mappings(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKFBZPend_ChooseInitialOrientation
                move.w  a1,$44(a0)
                move.l  #SKFBZPend_InitContactAndTryLinks,(a1)
                move.w  x_pos(a0),$12(a1)
                move.w  y_pos(a0),$16(a1)
                move.w  a0,parent3(a1)

SKFBZPend_ChooseInitialOrientation:
                moveq   #-$80,d0
                tst.b   subtype(a0)
                bpl.s   SKFBZPend_RestoreSavedEndpoint
                addi.w  #$40,d0
                move.b  #1,mapping_frame(a0)

SKFBZPend_RestoreSavedEndpoint:
                move.w  respawn_addr(a0),d1
                beq.s   SKFBZPend_SetInitialAngle
                movea.w d1,a1
                btst    #0,(a1)
                beq.s   SKFBZPend_SetInitialAngle
                st      $2E(a0)
                addi.w  #$80,d0

SKFBZPend_SetInitialAngle:
                move.b  d0,angle(a0)

SKFBZPend_CullAndSignalContact:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bls.s   SKFBZPend_DispatchPlayerMotion
                move.w  $44(a0),d0
                beq.s   SKFBZPend_PrepareSavedEndpoint
                movea.w d0,a1
                st      routine(a1)

SKFBZPend_PrepareSavedEndpoint:
                move.w  respawn_addr(a0),d0
                beq.s   SKFBZPend_DeleteOutOfRange
                movea.w d0,a1
                move.b  angle(a0),d0
                tst.b   subtype(a0)
                bmi.s   SKFBZPend_ClassifyEndpoint
                addi.b  #$40,d0

SKFBZPend_ClassifyEndpoint:
                moveq   #0,d1
                tst.b   d0
                bmi.s   SKFBZPend_StoreEndpointByte
                moveq   #1,d1

SKFBZPend_StoreEndpointByte:
                move.b  d1,(a1)

SKFBZPend_DeleteOutOfRange:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKFBZPend_DispatchPlayerMotion:
                lea     (Player_1).w,a2
                tst.b   $2F(a0)
                beq.w   SKFBZPend_DrawPendulum
                bmi.s   SKFBZPend_StepSwingAngle
                move.w  x_vel(a2),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,x_pos(a2)
                move.w  y_vel(a2),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a2)
                subq.b  #1,$2F(a0)
                bne.w   SKFBZPend_DrawPendulum
                clr.b   object_control(a2)
                bclr    #Status_InAir,status(a2)
                bra.w   SKFBZPend_DrawPendulum
; ---------------------------------------------------------------------------

SKFBZPend_StepSwingAngle:
                move.w  $30(a0),d0
                add.w   d0,angle(a0)
                moveq   #6,d1
                move.b  angle(a0),d0
                subi.b  #$40,d0
                bmi.s   SKFBZPend_AccelerateAndCheckEnds
                neg.w   d1

SKFBZPend_AccelerateAndCheckEnds:
                add.w   d1,$30(a0)
                move.b  angle(a0),d0
                tst.b   subtype(a0)
                bpl.s   SKFBZPend_CheckUprightSwingEnds
                tst.w   $30(a0)
                bpl.s   SKFBZPend_ClampSideSwing
                tst.b   d0
                bpl.w   SKFBZPend_TryProjectCapturedP1
                cmpi.b  #-$40,d0
                bhi.w   SKFBZPend_TryProjectCapturedP1
                moveq   #-$40,d0
                moveq   #0,d1
                bra.s   SKFBZPend_SnapEndAndTryRelease
; ---------------------------------------------------------------------------

SKFBZPend_ClampSideSwing:
                tst.b   d0
                bmi.w   SKFBZPend_TryProjectCapturedP1
                cmpi.b  #$40,d0
                blo.w   SKFBZPend_TryProjectCapturedP1
                moveq   #$40,d0
                moveq   #-1,d1
                bra.s   SKFBZPend_SnapEndAndTryRelease
; ---------------------------------------------------------------------------

SKFBZPend_CheckUprightSwingEnds:
                addi.b  #$40,d0
                tst.w   $30(a0)
                bpl.s   SKFBZPend_ClampUprightSwing
                tst.b   d0
                bpl.w   SKFBZPend_TryProjectCapturedP1
                cmpi.b  #-$40,d0
                bhi.w   SKFBZPend_TryProjectCapturedP1
                moveq   #-$80,d0
                moveq   #0,d1
                bra.s   SKFBZPend_SnapEndAndTryRelease
; ---------------------------------------------------------------------------

SKFBZPend_ClampUprightSwing:
                tst.b   d0
                bmi.w   SKFBZPend_TryProjectCapturedP1
                cmpi.b  #$40,d0
                blo.w   SKFBZPend_TryProjectCapturedP1
                moveq   #0,d0
                moveq   #-1,d1

SKFBZPend_SnapEndAndTryRelease:
                move.b  d0,angle(a0)
                clr.b   $27(a0)
                move.b  d1,$2E(a0)
                clr.b   $2F(a0)
                moveq   #signextendB(sfx_Clank),d0
                jsr     (Play_SFX).l
                tst.b   $32(a0)
                beq.w   SKFBZPend_DrawPendulum
                clr.b   $32(a0)
                move.b  #1,$2F(a0)
                moveq   #0,d0
                move.w  $30(a0),d0
                bpl.s   SKFBZPend_CalcEndpointSpeed
                neg.w   d0

SKFBZPend_CalcEndpointSpeed:
                lsl.l   #8,d0
                divu.w  #$51,d0
                cmpi.w  #$100,d0
                bhs.s   SKFBZPend_SetHorizontalExitSpeed
                move.w  #$100,d0

; X velocity is negative at both ends. The endpoint angle selects the ground-speed sign
SKFBZPend_SetHorizontalExitSpeed:
                tst.b   subtype(a0)
                bpl.s   SKFBZPend_SetVerticalExitSpeed
                clr.w   y_vel(a2)
                neg.w   d0
                move.w  d0,x_vel(a2)
                move.w  d0,ground_vel(a2)
                tst.b   angle(a0)
                bmi.s   SKFBZPend_CalcPlayerOrbit
                neg.w   ground_vel(a2)
                bra.s   SKFBZPend_CalcPlayerOrbit
; ---------------------------------------------------------------------------

SKFBZPend_SetVerticalExitSpeed:
                clr.w   x_vel(a2)
                move.w  d0,y_vel(a2)
                move.w  d0,ground_vel(a2)
                tst.b   angle(a0)
                bpl.s   SKFBZPend_CalcPlayerOrbit
                neg.w   ground_vel(a2)
                bra.s   SKFBZPend_CalcPlayerOrbit
; ---------------------------------------------------------------------------

SKFBZPend_TryProjectCapturedP1:
                tst.b   $32(a0)
                beq.w   SKFBZPend_DrawPendulum

SKFBZPend_CalcPlayerOrbit:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                swap    d1
                clr.w   d1
                asr.l   #1,d1
                move.l  d1,d3
                asr.l   #3,d3
                add.l   d3,d1
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d2
                asr.l   #3,d2
                add.l   d2,d0
                btst    #Status_Roll,status(a2)
                bne.s   SKFBZPend_ShrinkOrbitForRoll
                asr.l   #2,d3
                add.l   d3,d1
                asr.l   #2,d2
                add.l   d2,d0
                bra.s   SKFBZPend_PlaceAndCheckTangent
; ---------------------------------------------------------------------------

SKFBZPend_ShrinkOrbitForRoll:
                asr.l   #4,d3
                sub.l   d3,d1
                asr.l   #4,d2
                sub.l   d2,d0

SKFBZPend_PlaceAndCheckTangent:
                swap    d1
                add.w   x_pos(a0),d1
                move.w  d1,x_pos(a2)
                swap    d0
                add.w   y_pos(a0),d0
                move.w  d0,y_pos(a2)
                move.b  angle(a0),d0
                addi.b  #$40,d0
                move.b  d0,angle(a2)
                tst.b   $32(a0)
                beq.w   SKFBZPend_DrawPendulum
                move.b  angle(a0),d0
                addi.b  #$40,d0
                jsr     (GetSineCosine).l
                tst.w   $30(a0)
                bpl.s   SKFBZPend_SetTangentAndTryJump
                neg.w   d1
                neg.w   d0

SKFBZPend_SetTangentAndTryJump:
                move.w  d1,x_vel(a2)
                move.w  d0,y_vel(a2)
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   SKFBZPend_DrawPendulum
                clr.b   $32(a0)
                clr.b   object_control(a2)
                clr.b   spin_dash_flag(a2)
                bset    #Status_InAir,status(a2)
                move.b  #1,jumping(a2)
                bset    #Status_Roll,status(a2)
                move.b  #2,anim(a2)
                move.b  #$E,y_radius(a2)
                move.b  #7,x_radius(a2)
                clr.w   ground_vel(a2)
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                move.w  d1,d3
                lsl.w   #3,d1
                sub.w   d3,d1
                move.w  d1,x_vel(a2)
                move.w  d0,d2
                lsl.w   #3,d0
                sub.w   d2,d0
                move.w  d0,y_vel(a2)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l

SKFBZPend_DrawPendulum:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKFBZPend_InitContactAndTryLinks:
                move.l  #SKFBZPend_CheckContactTeardown,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$180,priority(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc2+$51,1,0),art_tile(a0)
                move.l  #Map_FBZMagneticPendulum,mappings(a0)
                move.b  #3,mapping_frame(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKFBZPend_CheckContactTeardown
                move.w  a1,$44(a0)
                move.l  #SKFBZPend_InitLinkSprites,(a1)
                move.w  $12(a0),x_pos(a1)
                move.w  $16(a0),y_pos(a1)
                move.w  parent3(a0),parent3(a1)

SKFBZPend_CheckContactTeardown:
                tst.b   routine(a0)
                beq.s   SKFBZPend_ProjectAndTestContact
                move.w  $44(a0),d0
                beq.s   SKFBZPend_DeleteContact
                movea.w d0,a1
                st      routine(a1)

SKFBZPend_DeleteContact:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKFBZPend_ProjectAndTestContact:
                movea.w parent3(a0),a1
                move.b  angle(a1),d0
                jsr     (GetSineCosine).l
                swap    d1
                clr.w   d1
                asr.l   #1,d1
                move.l  d1,d3
                asr.l   #3,d3
                sub.l   d3,d1
                swap    d1
                add.w   $12(a0),d1
                move.w  d1,x_pos(a0)
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d3
                asr.l   #3,d3
                sub.l   d3,d0
                swap    d0
                add.w   $16(a0),d0
                move.w  d0,y_pos(a0)
                tst.b   $2F(a1)
                bne.w   SKFBZPend_DrawContact
                lea     (Player_1).w,a2
                tst.b   object_control(a2)
                bne.w   SKFBZPend_DrawContact
                cmpi.b  #4,routine(a2)
                bhs.w   SKFBZPend_DrawContact
                tst.w   (Debug_placement_mode).w
                bne.w   SKFBZPend_DrawContact
                tst.b   subtype(a1)
                bpl.s   SKFBZPend_CheckUpwardApproach
                tst.w   x_vel(a2)
                bmi.w   SKFBZPend_DrawContact
                move.w  x_pos(a0),d0
                subq.w  #8,d0
                cmp.w   x_pos(a2),d0
                bhi.w   SKFBZPend_DrawContact
                addi.w  #$18,d0
                cmp.w   x_pos(a2),d0
                blo.w   SKFBZPend_DrawContact
                moveq   #$1D,d0
                moveq   #$21,d1
                btst    #Status_Roll,status(a2)
                bne.s   SKFBZPend_SignSideCaptureBand
                moveq   #$22,d0
                moveq   #$26,d1
                cmpi.w  #2,(Player_mode).w
                bne.s   SKFBZPend_SignSideCaptureBand
                moveq   #$1E,d0
                moveq   #$22,d1

SKFBZPend_SignSideCaptureBand:
                tst.b   $2E(a1)
                beq.s   SKFBZPend_CheckSideCaptureBand
                subq.w  #1,d0
                neg.w   d0
                subq.w  #1,d1
                neg.w   d1
                exg     d0,d1

SKFBZPend_CheckSideCaptureBand:
                move.w  y_pos(a0),d2
                sub.w   d0,d2
                cmp.w   y_pos(a2),d2
                blo.w   SKFBZPend_DrawContact
                move.w  y_pos(a0),d2
                sub.w   d1,d2
                cmp.w   y_pos(a2),d2
                bhi.w   SKFBZPend_DrawContact
                move.w  x_vel(a2),d0
                bra.s   SKFBZPend_CalcCaptureAngularSpeed
; ---------------------------------------------------------------------------

SKFBZPend_CheckUpwardApproach:
                tst.w   y_vel(a2)
                bpl.w   SKFBZPend_DrawContact
                move.w  y_pos(a0),d0
                addq.w  #8,d0
                cmp.w   y_pos(a2),d0
                blo.s   SKFBZPend_DrawContact
                subi.w  #$18,d0
                cmp.w   y_pos(a2),d0
                bhi.s   SKFBZPend_DrawContact
                moveq   #$1D,d0
                moveq   #$21,d1
                btst    #Status_Roll,status(a2)
                bne.s   SKFBZPend_SignUprightCaptureBand
                moveq   #$22,d0
                moveq   #$26,d1
                cmpi.w  #2,(Player_mode).w
                bne.s   SKFBZPend_SignUprightCaptureBand
                moveq   #$1E,d0
                moveq   #$22,d1

SKFBZPend_SignUprightCaptureBand:
                tst.b   $2E(a1)
                beq.s   SKFBZPend_CheckUprightCaptureBand
                subq.w  #1,d0
                neg.w   d0
                subq.w  #1,d1
                neg.w   d1
                exg     d0,d1

SKFBZPend_CheckUprightCaptureBand:
                move.w  x_pos(a0),d2
                sub.w   d0,d2
                cmp.w   x_pos(a2),d2
                blo.s   SKFBZPend_DrawContact
                move.w  x_pos(a0),d2
                sub.w   d1,d2
                cmp.w   x_pos(a2),d2
                bhi.s   SKFBZPend_DrawContact
                move.w  y_vel(a2),d0
                neg.w   d0

SKFBZPend_CalcCaptureAngularSpeed:
                mulu.w  #$51,d0
                lsr.l   #8,d0
                tst.b   $2E(a1)
                beq.s   SKFBZPend_LatchSwingAndCaptureP1
                neg.w   d0

; The contact actor latches control here. The pendulum positions P1 on its next update
SKFBZPend_LatchSwingAndCaptureP1:
                st      $2F(a1)
                move.w  d0,$30(a1)
                st      $32(a1)
                move.b  #1,object_control(a2)

SKFBZPend_DrawContact:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKFBZPend_InitLinkSprites:
                move.l  #SKFBZPend_CheckLinkTeardown,(a0)
                move.b  #$44,render_flags(a0)
                move.b  #$70,height_pixels(a0)
                move.b  #$70,width_pixels(a0)
                move.w  #$180,priority(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc2+$51,1,0),art_tile(a0)
                move.l  #Map_FBZMagneticPendulum,mappings(a0)
                move.w  #5,mainspr_childsprites(a0)

SKFBZPend_CheckLinkTeardown:
                tst.b   routine(a0)
                beq.s   SKFBZPend_CalcFirstLinkAndStep
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKFBZPend_CalcFirstLinkAndStep:
                movea.w parent3(a0),a1
                move.w  x_pos(a0),d3
                swap    d3
                clr.w   d3
                move.w  y_pos(a0),d2
                swap    d2
                clr.w   d2
                move.b  angle(a1),d0
                jsr     (GetSineCosine).l
                swap    d1
                clr.w   d1
                asr.l   #4,d1
                swap    d0
                clr.w   d0
                asr.l   #4,d0
                add.l   d1,d3
                add.l   d0,d2
                move.l  d1,d5
                move.l  d0,d4
                asr.l   #2,d5
                asr.l   #2,d4
                add.l   d5,d3
                add.l   d4,d2
                asr.l   #2,d5
                asr.l   #2,d4
                add.l   d5,d1
                add.l   d4,d0
                lea     sub2_x_pos(a0),a1
                moveq   #5-1,d4

SKFBZPend_PlaceLinksAndDraw:
                swap    d3
                swap    d2
                move.w  d3,(a1)+
                move.w  d2,(a1)+
                addq.w  #1,a1
                move.b  #2,(a1)+
                swap    d3
                swap    d2
                add.l   d1,d3
                add.l   d0,d2
                dbf     d4,SKFBZPend_PlaceLinksAndDraw
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_FBZMagneticPendulum:
                include "src/objects/shared/zones/fbz/mappings/magnetic_pendulum.s"
; End of function Obj_FBZMagneticPendulum
