; Owner: objects/shared/sk
; Responsibility: Breakable wall contact, player response, fracture geometry and fragment creation with zone-specific mappings
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_BreakableWall:
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.l  #SKWall_UpdateNormalCollision,(a0)
                move.b  subtype(a0),d0
                bpl.s   SKWall_InitializeAIZOrHCZWallResources
                tst.b   (Level_trigger_array).w
                beq.s   SKWall_InitializeAIZOrHCZWallResources
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKWall_InitializeAIZOrHCZWallResources:
                andi.b  #$F,d0
                move.b  d0,mapping_frame(a0)
                move.l  #Map_AIZBreakableWall,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.l  #SKWall_AIZTallSOZRightVel,$34(a0)
                move.l  #SKWall_AIZTallSOZLeftVel,$38(a0)
                cmpi.b  #1,(Current_zone).w
                bne.s   SKWall_SelectMGZWallAndRestrictedBitFour
                move.l  #Map_HCZBreakableWall,mappings(a0)
                move.w  #make_art_tile($001,3,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #SKWall_HCZLBZFragmentRightVel,$34(a0)
                move.l  #SKWall_HCZLBZFragmentLeftVel,$38(a0)
                cmpi.b  #2,mapping_frame(a0)
                bne.s   SKWall_SelectMGZWallAndRestrictedBitFour
                move.w  #make_art_tile(ArtTile_HCZ2KnuxWall,2,0),art_tile(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #SKWall_HCZLBZFragmentRightVel,$34(a0)
                move.l  #SKWall_HCZLBZFragmentLeftVel,$38(a0)
                move.l  #SKWall_UpdateRestrictedCollision,(a0)
                rts
; ---------------------------------------------------------------------------

SKWall_SelectMGZWallAndRestrictedBitFour:
                cmpi.b  #2,(Current_zone).w
                bne.s   SKWall_TryCNZRestrictedWall
                move.l  #Map_MGZBreakableWall,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.l  #SKWall_MGZPrimaryNegativeXVelocities,$34(a0)
                move.l  #SKWall_MGZAlternatePositiveXVelocities,$38(a0)
                btst    #4,subtype(a0)
                beq.s   SKWall_SelectMGZLatchedCollisionFrame
                move.l  #SKWall_UpdateRestrictedCollision,(a0)
                rts
; ---------------------------------------------------------------------------

SKWall_SelectMGZLatchedCollisionFrame:
                cmpi.b  #2,mapping_frame(a0)
                bne.s   SKWall_TryCNZRestrictedWall
                move.l  #SKWall_UpdateLatchedSideCollisionWall,(a0)
                rts
; ---------------------------------------------------------------------------

SKWall_TryCNZRestrictedWall:
                cmpi.b  #3,(Current_zone).w
                bne.s   SKWall_SelectLBZRestrictedWall
                move.l  #Map_CNZSOZBreakableWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc+$CF,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #SKWall_CNZMHZSOZLRZRightVel,$34(a0)
                move.l  #SKWall_CNZMHZSOZLRZLeftVel,$38(a0)
                cmpi.b  #2,mapping_frame(a0)
                bne.s   SKWall_SelectLBZRestrictedWall
                move.l  #SKWall_UpdateRestrictedCollision,(a0)
                rts
; ---------------------------------------------------------------------------

SKWall_SelectLBZRestrictedWall:
                cmpi.b  #6,(Current_zone).w
                bne.s   SKWall_SelectMHZRestrictedWall
                move.l  #Map_LBZBreakableWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,1,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #SKWall_HCZLBZFragmentRightVel,$34(a0)
                move.l  #SKWall_HCZLBZFragmentLeftVel,$38(a0)
                move.l  #SKWall_UpdateRestrictedCollision,(a0)
                rts
; ---------------------------------------------------------------------------

SKWall_SelectMHZRestrictedWall:
                cmpi.b  #7,(Current_zone).w
                bne.s   SKWall_SelectSOZRestrictedAndTallWall
                move.l  #Map_MHZBreakableWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_MHZMisc+$4,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #SKWall_CNZMHZSOZLRZRightVel,$34(a0)
                move.l  #SKWall_CNZMHZSOZLRZLeftVel,$38(a0)
                move.l  #SKWall_UpdateRestrictedCollision,(a0)
                rts
; ---------------------------------------------------------------------------

SKWall_SelectSOZRestrictedAndTallWall:
                cmpi.b  #8,(Current_zone).w
                bne.s   SKWall_SelectLRZOrdinaryWall
                move.l  #Map_CNZSOZBreakableWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_SOZMisc+$C3,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #SKWall_CNZMHZSOZLRZRightVel,$34(a0)
                move.l  #SKWall_CNZMHZSOZLRZLeftVel,$38(a0)
                move.l  #SKWall_UpdateRestrictedCollision,(a0)
                cmpi.b  #4,mapping_frame(a0)
                bne.s   SKWall_ReturnAfterSOZWallSetup
                move.b  #$30,height_pixels(a0)
                move.l  #SKWall_AIZTallSOZRightVel,$34(a0)
                move.l  #SKWall_AIZTallSOZLeftVel,$38(a0)

SKWall_ReturnAfterSOZWallSetup:
                rts
; ---------------------------------------------------------------------------

SKWall_SelectLRZOrdinaryWall:
                cmpi.b  #9,(Current_zone).w
                bne.s   SKWall_UpdateNormalCollision
                move.l  #Map_LRZBreakableWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZ2Misc,3,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #SKWall_CNZMHZSOZLRZRightVel,$34(a0)
                move.l  #SKWall_CNZMHZSOZLRZLeftVel,$38(a0)

SKWall_UpdateNormalCollision:
                move.w  (Player_1+x_vel).w,$30(a0)
                move.w  (Player_2+x_vel).w,$32(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                tst.b   subtype(a0)
                bpl.s   SKWall_FilterOrdinaryWallSideContacts
                tst.b   (Level_trigger_array).w
                beq.s   SKWall_DrawOrdinaryWallInRange
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKWall_FilterOrdinaryWallSideContacts:
                swap    d6
                andi.w  #3,d6
                bne.s   SKWall_CheckNormalBreakP1

SKWall_DrawOrdinaryWallInRange:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKWall_CheckNormalBreakP1:
                lea     (Player_1).w,a1
                move.w  $30(a0),d1
                move.w  d6,d0
                andi.w  #1,d0
                beq.s   SKWall_CheckNormalBreakP2
                tst.b   (Super_Sonic_Knux_flag).w
                bne.s   SKWall_BreakFromP1AndRestoreP2
                cmpi.b  #2,character_id(a1)
                beq.s   SKWall_BreakFromP1AndRestoreP2
                btst    #Status_FireShield,status_secondary(a1)
                bne.s   SKWall_CheckP1RollAndGetSpeed
                btst    #p1_pushing_bit,status(a0)
                beq.s   SKWall_CheckNormalBreakP2

SKWall_CheckP1RollAndGetSpeed:
                cmpi.b  #2,anim(a1)
                bne.s   SKWall_CheckNormalBreakP2
                move.w  d1,d0
                bpl.s   SKWall_CheckP1BreakSpeed
                neg.w   d0

; Require an unsigned speed magnitude of at least $480
SKWall_CheckP1BreakSpeed:
                cmpi.w  #$480,d0
                blo.s   SKWall_CheckNormalBreakP2

SKWall_BreakFromP1AndRestoreP2:
                bclr    #p1_pushing_bit,status(a0)
                bsr.s   BreakWallFromSideImpact
                btst    #p2_pushing_bit,status(a0)
                beq.s   SKWall_DrawOrdinaryWallInRange
                lea     (Player_2).w,a1
                cmpi.b  #2,anim(a1)
                bne.s   SKWall_DrawOrdinaryWallInRange
                move.w  $32(a0),x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #p2_pushing_bit,status(a0)
                bclr    #Status_Push,status(a1)
                bra.s   SKWall_DrawOrdinaryWallInRange
; ---------------------------------------------------------------------------

SKWall_CheckNormalBreakP2:
                lea     (Player_2).w,a1
                move.w  $32(a0),d1
                btst    #p2_pushing_bit,status(a0)
                beq.w   SKWall_DrawOrdinaryWallInRange
                cmpi.b  #2,anim(a1)
                bne.w   SKWall_DrawOrdinaryWallInRange
                move.w  d1,d0
                bpl.s   SKWall_CheckP2SpeedAndBreak
                neg.w   d0

; Require an unsigned speed magnitude of at least $480, then clear the pushing latch
SKWall_CheckP2SpeedAndBreak:
                cmpi.w  #$480,d0
                blo.w   SKWall_DrawOrdinaryWallInRange
                bclr    #p2_pushing_bit,status(a0)

; =============== S U B R O U T I N E =======================================

BreakWallFromSideImpact:
                move.w  d1,x_vel(a1)
                addq.w  #4,x_pos(a1)
                movea.l $34(a0),a4
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   SKWall_FinishImpactAndSpawnFragments
                subi.w  #8,x_pos(a1)
                movea.l $38(a0),a4

SKWall_FinishImpactAndSpawnFragments:
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)         ; set Sonic as not pushing an object
                move.l  #SKWall_MoveWallFragmentAndApplyGravity,(a0)
                addq.b  #1,mapping_frame(a0)
                bsr.s   BreakObjectToPieces

SKWall_MoveWallFragmentAndApplyGravity:
                jsr     (MoveSprite2).l
                addi.w  #$70,y_vel(a0)                  ; make obj fall
                tst.b   render_flags(a0)
                bpl.s   SKWall_DeleteOffscreenFragment
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKWall_DeleteOffscreenFragment:
                jmp     (Delete_Current_Sprite).l
; End of function BreakWallFromSideImpact

; =============== S U B R O U T I N E =======================================

BreakObjectToPieces:
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                move.w  #$80,priority(a0)               ; set priority again when being smashed

BreakObjectToPieces2:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                add.w   d0,d0
                movea.l mappings(a0),a3                 ; get mapping pointer
                adda.w  (a3,d0.w),a3
                move.w  (a3)+,d1
                subq.w  #1,d1
                bset    #5,render_flags(a0)             ; set static mappings flag
                move.l  (a0),d4
                move.b  render_flags(a0),d5             ; get render flags
                movea.l a0,a1
                bra.s   BreakObjectToPieces_InitObject
; ---------------------------------------------------------------------------
; loc_216E2:
BreakObjectToPieces_Loop:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKWall_ReturnFromFragmentAllocation
                addq.w  #6,a3                           ; add to mappings

; loc_216EC:
BreakObjectToPieces_InitObject:
                move.l  d4,code(a1)                     ; get object pointer (in Sonic 1 and 2, this copies the object ID)
                move.l  a3,mappings(a1)                 ; get mappings pointer
                move.b  d5,render_flags(a1)             ; get render flags
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  art_tile(a0),art_tile(a1)
                ori.w   #high_priority,art_tile(a1)     ; change fragment's priority
                move.b  priority(a0),priority(a1)       ; copy priority
                move.b  width_pixels(a0),width_pixels(a1)
                move.b  height_pixels(a0),height_pixels(a1)
                move.w  (a4)+,x_vel(a1)
                move.w  (a4)+,y_vel(a1)
                dbf     d1,BreakObjectToPieces_Loop

SKWall_ReturnFromFragmentAllocation:
                rts
; End of function BreakObjectToPieces

; ---------------------------------------------------------------------------

SKWall_UpdateLatchedSideCollisionWall:
                move.w  (Player_1+x_vel).w,$30(a0)
                move.w  (Player_2+x_vel).w,$32(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                swap    d6
                andi.b  #3,d6
                beq.w   SKWall_DrawLatchedWallInRange
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   SKWall_CheckP2LatchedSideHit
                lea     (Player_1).w,a1
                bclr    #6,$37(a1)
                beq.s   SKWall_CheckP2LatchedSideHit
                move.w  $30(a0),x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                bclr    #p1_pushing_bit,status(a0)
                bsr.s   BreakWallAfterLatchedSideCollision
                andi.b  #2,d6
                beq.s   SKWall_DrawLatchedWallInRange
                lea     (Player_2).w,a1
                bclr    #6,$37(a1)
                beq.s   SKWall_DrawLatchedWallInRange
                move.w  $32(a0),x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                bclr    #p2_pushing_bit,status(a0)
                bra.s   SKWall_DrawLatchedWallInRange
; ---------------------------------------------------------------------------

SKWall_CheckP2LatchedSideHit:
                andi.b  #2,d6
                beq.s   SKWall_DrawLatchedWallInRange
                lea     (Player_2).w,a1
                bclr    #6,$37(a1)
                beq.s   SKWall_DrawLatchedWallInRange
                move.w  $32(a0),x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                bclr    #p2_pushing_bit,status(a0)
                bsr.s   BreakWallAfterLatchedSideCollision

SKWall_DrawLatchedWallInRange:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

BreakWallAfterLatchedSideCollision:
                movea.l $34(a0),a4
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   SKWall_StartLatchedWallFragmentation
                subi.w  #8,x_pos(a1)
                movea.l $38(a0),a4

SKWall_StartLatchedWallFragmentation:
                move.l  #SKWall_MoveWallFragmentAndApplyGravity,(a0)
                addq.b  #1,mapping_frame(a0)
                bsr.w   BreakObjectToPieces
                bra.w   SKWall_MoveWallFragmentAndApplyGravity
; End of function BreakWallAfterLatchedSideCollision

; ---------------------------------------------------------------------------

SKWall_UpdateRestrictedCollision:
                move.w  (Player_1+x_vel).w,$30(a0)
                move.w  (Player_2+x_vel).w,$32(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                tst.b   subtype(a0)
                bpl.s   SKWall_FilterCharacterRestrictedContacts
                tst.b   (Level_trigger_array).w
                beq.s   SKWall_DrawRestrictedWallInRange
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKWall_FilterCharacterRestrictedContacts:
                swap    d6
                andi.w  #3,d6
                bne.s   SKWall_CheckRestrictedBreakP1

SKWall_DrawRestrictedWallInRange:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKWall_CheckRestrictedBreakP1:
                lea     (Player_1).w,a1
                move.w  $30(a0),d1
                move.w  d6,d0
                andi.w  #1,d0
                beq.s   SKWall_CheckRestrictedBreakP2
                cmpi.b  #2,character_id(a1)
                bne.s   SKWall_CheckRestrictedBreakP2
                bclr    #p1_pushing_bit,status(a0)
                bsr.s   BreakWallFromKnucklesImpact
                btst    #p2_pushing_bit,status(a0)
                beq.s   SKWall_DrawRestrictedWallInRange
                lea     (Player_2).w,a1
                cmpi.b  #2,character_id(a1)
                bne.s   SKWall_DrawRestrictedWallInRange
                move.w  $32(a0),x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #p2_pushing_bit,status(a0)
                bclr    #Status_Push,status(a1)
                bra.s   SKWall_DrawRestrictedWallInRange
; ---------------------------------------------------------------------------

SKWall_CheckRestrictedBreakP2:
                lea     (Player_2).w,a1
                move.w  $32(a0),d1
                btst    #p2_pushing_bit,status(a0)
                beq.s   SKWall_DrawRestrictedWallInRange
                cmpi.b  #2,character_id(a1)
                bne.s   SKWall_DrawRestrictedWallInRange
                bclr    #p2_pushing_bit,status(a0)

; =============== S U B R O U T I N E =======================================

BreakWallFromKnucklesImpact:
                move.w  d1,x_vel(a1)
                addq.w  #4,x_pos(a1)
                movea.l $34(a0),a4
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   SKWall_FinalizeKnucklesImpact
                subi.w  #8,x_pos(a1)
                movea.l $38(a0),a4

SKWall_FinalizeKnucklesImpact:
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                cmpi.b  #2,character_id(a1)
                bne.s   SKWall_SpawnKnuxBreakFragments
                cmpi.b  #1,double_jump_flag(a1)
                bne.s   SKWall_SpawnKnuxBreakFragments
                move.b  #2,double_jump_flag(a1)
                move.b  #$21,anim(a1)
                bclr    #Status_Facing,status(a1)
                tst.w   x_vel(a1)
                bpl.s   SKWall_SpawnKnuxBreakFragments
                bset    #Status_Facing,status(a1)

SKWall_SpawnKnuxBreakFragments:
                move.l  #SKWall_MoveWallFragmentAndApplyGravity,(a0)
                addq.b  #1,mapping_frame(a0)
                bsr.w   BreakObjectToPieces
                bra.w   SKWall_MoveWallFragmentAndApplyGravity
; End of function BreakWallFromKnucklesImpact

; ---------------------------------------------------------------------------
SKWall_AIZTallSOZRightVel:
                dc.w    $400, -$500
                dc.w    $600, -$600
                dc.w    $600, -$100
                dc.w    $800, -$200
                dc.w    $680,     0
                dc.w    $880,     0
                dc.w    $600,  $100
                dc.w    $800,  $200
                dc.w    $400,  $500
                dc.w    $600,  $600
                dc.w    $300,  $600
                dc.w    $500,  $700
SKWall_AIZTallSOZLeftVel:
                dc.w    -$600, -$600
                dc.w    -$400, -$500
                dc.w    -$800, -$200
                dc.w    -$600, -$100
                dc.w    -$880,     0
                dc.w    -$680,     0
                dc.w    -$800,  $200
                dc.w    -$600,  $100
                dc.w    -$600,  $600
                dc.w    -$400,  $500
                dc.w    -$500,  $700
                dc.w    -$300,  $600
SKWall_HCZLBZFragmentRightVel:
                dc.w    $400, -$500
                dc.w    $600, -$600
                dc.w    $600, -$100
                dc.w    $800, -$200
                dc.w    $600,  $100
                dc.w    $800,  $200
                dc.w    $400,  $500
                dc.w    $600,  $600
SKWall_HCZLBZFragmentLeftVel:
                dc.w    -$600, -$600
                dc.w    -$400, -$500
                dc.w    -$800, -$200
                dc.w    -$600, -$100
                dc.w    -$800,  $200
                dc.w    -$600,  $100
                dc.w    -$600,  $600
                dc.w    -$400,  $500
SKWall_MGZAlternatePositiveXVelocities:
                dc.w    $400, -$500
                dc.w    $500, -$580
                dc.w    $600, -$600
                dc.w    $700, -$680
                dc.w    $600, -$100
                dc.w    $700, -$180
                dc.w    $800, -$200
                dc.w    $900, -$280
                dc.w    $680,     0
                dc.w    $780,     0
                dc.w    $880,     0
                dc.w    $980,     0
                dc.w    $600,  $100
                dc.w    $700,  $180
                dc.w    $800,  $200
                dc.w    $900,  $280
                dc.w    $400,  $500
                dc.w    $500,  $580
                dc.w    $600,  $600
                dc.w    $700,  $680
SKWall_MGZPrimaryNegativeXVelocities:
                dc.w    -$700, -$680
                dc.w    -$600, -$600
                dc.w    -$500, -$580
                dc.w    -$400, -$500
                dc.w    -$900, -$280
                dc.w    -$800, -$200
                dc.w    -$700, -$180
                dc.w    -$600, -$100
                dc.w    -$980,     0
                dc.w    -$880,     0
                dc.w    -$780,     0
                dc.w    -$680,     0
                dc.w    -$900,  $280
                dc.w    -$800,  $200
                dc.w    -$700,  $180
                dc.w    -$600,  $100
                dc.w    -$700,  $680
                dc.w    -$600,  $600
                dc.w    -$500,  $580
                dc.w    -$400,  $500
SKWall_CNZMHZSOZLRZRightVel:
                dc.w    $400, -$500
                dc.w    $600, -$600
                dc.w    $600, -$100
                dc.w    $800, -$200
                dc.w    $600,  $100
                dc.w    $800,  $200
                dc.w    $400,  $500
                dc.w    $600,  $600
SKWall_CNZMHZSOZLRZLeftVel:
                dc.w    -$600, -$600
                dc.w    -$400, -$500
                dc.w    -$800, -$200
                dc.w    -$600, -$100
                dc.w    -$800,  $200
                dc.w    -$600,  $100
                dc.w    -$600,  $600
                dc.w    -$400,  $500
Map_CNZSOZBreakableWall:
                include "src/objects/shared/zones/cnz/mappings/soz_breakable_wall.s"
Map_MHZBreakableWall:
                include "src/objects/shared/zones/mhz/mappings/breakable_wall.s"
Map_LRZBreakableWall:
                include "src/objects/shared/zones/lrz/mappings/breakable_wall.s"
