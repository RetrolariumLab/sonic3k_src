; Owner: objects/zones/cnz/sk
; Responsibility: Carnival Night cannon initialization, player capture, aiming, launch and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZCannon:
                move.l  #Map_CNZCannon,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc+$23,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$30,width_pixels(a0)
                move.b  #$30,height_pixels(a0)
                move.b  #9,mapping_frame(a0)
                bset    #6,render_flags(a0)
                move.w  #1,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #4,(a2)
                move.l  #SKCNZCannon_UpdateAimRidersAndDraw,(a0)

SKCNZCannon_UpdateAimRidersAndDraw:
                bsr.s   UpdateCnzCannonAimAndMuzzleEffects
                lea     $30(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                move.w  (Ctrl_1_logical).w,d1
                bsr.w   UpdatePlayerInCnzCannon
                addq.w  #1,a2
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d1
                cmpi.w  #2,(Tails_CPU_routine).w
                bne.s   SKCNZCannon_UpdateP2AndBarrel
                move.b  #0,(a2)

SKCNZCannon_UpdateP2AndBarrel:
                bsr.w   UpdatePlayerInCnzCannon
                bsr.w   QueueCnzCannonBarrelPatterns
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

UpdateCnzCannonAimAndMuzzleEffects:
                move.w  $34(a0),d0
                bne.s   SKCNZCannon_StepAimingRotation
                move.w  #$10,d1
                move.w  #$29,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectTop).l
; ---------------------------------------------------------------------------

SKCNZCannon_StepAimingRotation:
                subq.w  #1,d0
                bne.s   SKCNZCannon_TickMuzzleTimer
                move.b  angle(a0),d0
                addq.b  #2,angle(a0)
                jsr     (GetSineCosine).l
                addi.w  #$120,d0
                lsr.w   #6,d0
                move.b  d0,sub2_mapframe(a0)
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$1F,d0
                bne.s   SKCNZCannon_AimReturn
                moveq   #signextendB(sfx_CannonTurn),d0
                jsr     (Play_SFX).l

SKCNZCannon_AimReturn:
                rts
; ---------------------------------------------------------------------------

SKCNZCannon_TickMuzzleTimer:
                subq.w  #1,d0
                bne.s   SKCNZCannon_RotateBackToSolid
                subq.w  #1,$36(a0)
                bpl.s   SKCNZCannon_TrySpawnMuzzleFlash
                move.w  #3,$34(a0)

SKCNZCannon_TrySpawnMuzzleFlash:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #3,d0
                bne.s   SKCNZCannon_MuzzleReturn
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKCNZCannon_MuzzleReturn
                move.l  #Obj_FireShield_Dissipate,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subi.w  #$18,y_pos(a1)
                move.b  sub2_mapframe(a0),d0
                lsl.b   #4,d0
                addi.b  #$80,d0
                jsr     (GetSineCosine).l
                asl.w   #3,d1
                asl.w   #3,d0
                move.w  d1,sub2_x_pos(a1)
                move.w  d0,sub2_y_pos(a1)

SKCNZCannon_MuzzleReturn:
                rts
; ---------------------------------------------------------------------------

SKCNZCannon_RotateBackToSolid:
                move.b  angle(a0),d0
                addq.b  #2,angle(a0)
                jsr     (GetSineCosine).l
                addi.w  #$120,d0
                lsr.w   #6,d0
                move.b  d0,sub2_mapframe(a0)
                cmpi.b  #4,d0
                bne.s   CNZCannonSK_ReturnAfterCenterFrameGate
                move.w  #0,$34(a0)

CNZCannonSK_ReturnAfterCenterFrameGate:
                rts
; End of function UpdateCnzCannonAimAndMuzzleEffects

; =============== S U B R O U T I N E =======================================

UpdatePlayerInCnzCannon:
                move.b  (a2),d0
                bne.s   SKCNZCannon_MoveRiderIntoBarrel
                bclr    d6,status(a0)
                beq.s   SKCNZCannon_CaptureReturn
                bclr    #Status_OnObj,status(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  #$380,priority(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.w  #0,ground_vel(a1)
                move.b  #$81,object_control(a1)
                bset    #Status_Roll,status(a1)
                bset    #Status_InAir,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.b  #1,(a2)

SKCNZCannon_CaptureReturn:
                rts
; ---------------------------------------------------------------------------

SKCNZCannon_MoveRiderIntoBarrel:
                subq.b  #1,d0
                bne.s   SKCNZCannon_TryAimOrFire
                move.w  y_vel(a1),d0
                addi.w  #$38,y_vel(a1)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a1)
                move.w  y_pos(a0),d0
                cmp.w   y_pos(a1),d0
                bhs.s   SKCNZCannon_RiderFallReturn
                move.w  d0,y_pos(a1)
                move.b  #$1C,anim(a1)
                move.b  #2,(a2)

SKCNZCannon_RiderFallReturn:
                rts
; ---------------------------------------------------------------------------

SKCNZCannon_TryAimOrFire:
                subq.b  #1,d0
                bne.w   SKCNZCannon_TryRestoreRiderPriority
                cmpi.w  #2,$34(a0)
                beq.s   SKCNZCannon_FireRiderAndStartMuzzle
                cmpi.w  #$200,$30(a0)
                beq.s   SKCNZCannon_BeginAiming
                cmpi.w  #$202,$30(a0)
                bne.s   SKCNZCannon_CheckFireButton

SKCNZCannon_BeginAiming:
                move.w  #1,$34(a0)

SKCNZCannon_CheckFireButton:
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d1
                beq.s   SKCNZCannon_FireReturn

SKCNZCannon_FireRiderAndStartMuzzle:
                move.b  sub2_mapframe(a0),d0
                lsl.b   #4,d0
                addi.b  #$80,d0
                jsr     (GetSineCosine).l
                asl.w   #4,d1
                asl.w   #4,d0
                move.w  d1,x_vel(a1)
                move.w  d0,y_vel(a1)
                move.w  d1,ground_vel(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subi.w  #$18,y_pos(a1)
                move.b  #0,object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.b   jumping(a1)
                move.b  #2,anim(a1)
                move.w  #2,$34(a0)
                move.w  #$F,$36(a0)
                move.b  #3,(a2)
                move.b  #8,2(a2)

SKCNZCannon_FireReturn:
                rts
; ---------------------------------------------------------------------------

SKCNZCannon_TryRestoreRiderPriority:
                subq.b  #1,2(a2)
                bne.s   SKCNZCannon_PostFireReturn
                move.w  #$100,priority(a1)
                move.b  #0,(a2)

SKCNZCannon_PostFireReturn:
                rts
; End of function UpdatePlayerInCnzCannon

; =============== S U B R O U T I N E =======================================

QueueCnzCannonBarrelPatterns:
                tst.b   render_flags(a0)
                bpl.s   SKCNZCannon_BarrelDplcReturn
                moveq   #0,d0
                move.b  sub2_mapframe(a0),d0
                cmp.b   $2E(a0),d0
                beq.s   SKCNZCannon_BarrelDplcReturn
                move.b  d0,$2E(a0)
                lea     (DPLC_CNZCannon).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   SKCNZCannon_BarrelDplcReturn
                move.w  #tiles_to_bytes(ArtTile_CNZCannon),d4

SKCNZCannon_QueueBarrelTileDma:
                moveq   #0,d1
                move.w  (a2)+,d1
                move.w  d1,d3
                lsr.w   #8,d3
                andi.w  #$F0,d3
                addi.w  #$10,d3
                andi.w  #$FFF,d1
                lsl.l   #5,d1
                addi.l  #ArtUnc_CNZCannon,d1
                move.w  d4,d2
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                dbf     d5,SKCNZCannon_QueueBarrelTileDma

SKCNZCannon_BarrelDplcReturn:
                rts
; End of function QueueCnzCannonBarrelPatterns

; ---------------------------------------------------------------------------
DPLC_CNZCannon:
                include "src/objects/shared/zones/cnz/dplc/cannon.s"
