; Owner: objects/zones/mhz/sk
; Responsibility: Mushroom catapult activation, compression, player launch and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZMushroomCatapult:
                move.l  #Map_MHZMushroomCatapult,mappings(a0)
                move.w  #make_art_tile(ArtTile_MHZMisc+$86,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.w  y_pos(a0),$30(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKMHZMushCat_StartCatapult
                move.l  #SKMHZMushCat_PlaceOppositeCap,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  x_pos(a0),$2E(a1)
                move.w  y_pos(a0),$30(a1)
                addi.w  #$40,x_pos(a1)
                tst.b   subtype(a0)
                beq.s   SKMHZMushCat_InitOppositeCapAndFlipper
                subi.w  #2*$40,x_pos(a1)

SKMHZMushCat_InitOppositeCapAndFlipper:
                subi.w  #$18,y_pos(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.w  priority(a0),priority(a1)
                move.b  #$20,width_pixels(a1)
                move.b  #$C,height_pixels(a1)
                move.w  a0,parent3(a1)
                move.w  #$18,$34(a1)
                move.w  a1,parent3(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKMHZMushCat_StartCatapult
                move.l  #SKMHZMushCat_TryLaunchFlipper,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  x_pos(a0),$2E(a1)
                move.w  y_pos(a1),$30(a1)
                subi.w  #$14,y_pos(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  #make_art_tile(ArtTile_MHZMisc+$D9,1,0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.w  priority(a0),priority(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.b  #1,mapping_frame(a1)
                move.w  a0,parent3(a1)

; Activate the root even after a partial child allocation
SKMHZMushCat_StartCatapult:
                move.l  #SKMHZMushCat_UpdateCompressionAndSolid,(a0)

SKMHZMushCat_UpdateCompressionAndSolid:
                movea.w parent3(a0),a1
                bsr.s   UpdateMhzOpposedMushroomCompression
                move.w  $34(a0),d0
                neg.w   d0
                add.w   $30(a0),d0
                move.w  d0,y_pos(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                lea     (SKMHZMushCat_SurfaceHeights).l,a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped2).l
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

UpdateMhzOpposedMushroomCompression:
                move.w  $36(a0),d2
                tst.w   $32(a0)
                bne.s   SKMHZMushCat_StepCompression
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   SKMHZMushCat_TryLatchOppositeContact
                moveq   #0,d2
                tst.w   $34(a0)
                beq.s   SKMHZMushCat_TryLatchOppositeContact
                move.b  #1,$32(a0)
                move.w  #0,$36(a0)
                bra.s   SKMHZMushCat_StepCompression
; ---------------------------------------------------------------------------

SKMHZMushCat_TryLatchOppositeContact:
                move.b  status(a1),d0
                andi.b  #standing_mask,d0
                beq.s   SKMHZMushCat_StepCompression
                moveq   #$18,d2
                cmpi.w  #$18,$34(a0)
                beq.s   SKMHZMushCat_StepCompression
                move.b  #1,$33(a0)
                move.w  #$18,$36(a0)

SKMHZMushCat_StepCompression:
                tst.w   d2
                bne.s   SKMHZMushCat_ExtendCompression
                tst.w   $34(a0)
                beq.s   SKMHZMushCat_TryLaunchAtZero
                subq.w  #8,$34(a0)
                bra.s   SKMHZMushCat_CompressionReturn
; ---------------------------------------------------------------------------

SKMHZMushCat_ExtendCompression:
                cmpi.w  #$18,$34(a0)
                beq.s   SKMHZMushCat_TryLaunchAtFullCompression
                addq.w  #8,$34(a0)

SKMHZMushCat_CompressionReturn:
                rts
; ---------------------------------------------------------------------------

SKMHZMushCat_TryLaunchAtZero:
                tst.b   $32(a0)
                beq.s   SKMHZMushCat_CompressionReturn
                clr.w   $32(a0)
                move.b  status(a1),d0
                andi.b  #standing_mask,d0
                bne.s   SKMHZMushCat_TryLaunchOppositeRiders
                clr.w   $3A(a0)
                rts
; ---------------------------------------------------------------------------

SKMHZMushCat_TryLaunchOppositeRiders:
                lea     (Player_1).w,a2
                moveq   #p1_standing_bit,d6
                bsr.s   LaunchPlayerFromOppositeMhzMushroom
                lea     (Player_2).w,a2
                moveq   #p2_standing_bit,d6
; End of function UpdateMhzOpposedMushroomCompression

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromOppositeMhzMushroom:
                btst    d6,status(a1)
                beq.s   SKMHZMushCat_CompressionReturn
                move.w  #-$E80,d1
                cmpi.w  #$900,$3A(a0)
                bhs.s   SKMHZMushCat_SetOppositeLaunchSpeed
                move.w  #-$D00,d1

SKMHZMushCat_SetOppositeLaunchSpeed:
                move.w  d1,y_vel(a2)
                bra.s   SKMHZMushCat_FinishSpringLaunch
; End of function LaunchPlayerFromOppositeMhzMushroom

; ---------------------------------------------------------------------------

SKMHZMushCat_TryLaunchAtFullCompression:
                tst.b   $33(a0)
                beq.s   SKMHZMushCat_CompressionReturn
                clr.w   $32(a0)
                lea     (Player_1).w,a2
                moveq   #p1_standing_bit,d6
                bsr.s   LaunchPlayerFromMainMhzMushroom
                lea     (Player_2).w,a2
                moveq   #p2_standing_bit,d6

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromMainMhzMushroom:
                btst    d6,status(a0)
                beq.s   SKMHZMushCat_CompressionReturn
                move.w  #-$D00,y_vel(a2)

SKMHZMushCat_FinishSpringLaunch:
                bset    #Status_InAir,status(a2)
                bclr    #Status_OnObj,status(a2)
                clr.b   jumping(a2)
                clr.b   spin_dash_flag(a2)
                move.b  #$10,anim(a2)
                move.b  #2,routine(a2)
                moveq   #signextendB(sfx_MushroomBounce),d0
                jmp     (Play_SFX).l
; End of function LaunchPlayerFromMainMhzMushroom

; ---------------------------------------------------------------------------

SKMHZMushCat_PlaceOppositeCap:
                movea.w parent3(a0),a1
                move.w  $34(a1),d0
                subi.w  #$18,d0
                add.w   $30(a0),d0
                move.w  d0,y_pos(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                lea     (SKMHZMushCat_SurfaceHeights).l,a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped2).l
                move.w  $2E(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

SKMHZMushCat_TryLaunchFlipper:
                movea.w parent3(a0),a1
                move.w  $34(a1),d0
                neg.w   d0
                add.w   $30(a0),d0
                subi.w  #$14,d0
                move.w  d0,y_pos(a0)
                cmpi.w  #$18,$34(a1)
                bne.s   SKMHZMushCat_DrawRestingFlipper
                move.l  #SKMHZMushCat_MoveAndTryReseatFlipper,(a0)
                moveq   #signextendB(sfx_Flipper),d0
                jsr     (Play_SFX).l
                move.w  #$18,$36(a1)
                move.w  #-$800,y_vel(a0)
                tst.w   $3A(a1)
                beq.s   SKMHZMushCat_DrawRestingFlipper
                move.w  #-$A00,y_vel(a0)

SKMHZMushCat_DrawRestingFlipper:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKMHZMushCat_MoveAndTryReseatFlipper:
                jsr     (MoveSprite).l
                movea.w parent3(a0),a1
                move.w  $34(a1),d0
                neg.w   d0
                add.w   $30(a0),d0
                subi.w  #$14,d0
                cmp.w   y_pos(a0),d0
                bhi.s   SKMHZMushCat_DrawFlyingFlipper
                move.w  d0,y_pos(a0)
                move.l  #SKMHZMushCat_TryLaunchFlipper,(a0)
                move.w  #0,$36(a1)
                move.b  #1,$32(a1)
                move.w  y_vel(a0),$3A(a1)
                clr.w   y_vel(a0)

SKMHZMushCat_DrawFlyingFlipper:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
SKMHZMushCat_SurfaceHeights:
                dc.b    4,   5,   6,   7,   8,   9,  $A,  $B,  $B,  $C,  $C,  $C,  $C,  $C,  $C,  $C,  $C,  $C,  $C,  $C
                dc.b    $C,  $C,  $C,  $B,  $B,  $A,   9,   8,   7,   6,   5,   4
                even
Map_MHZMushroomCatapult:
                include "src/objects/shared/zones/mhz/mappings/mushroom_catapult.s"
