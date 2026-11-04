; Owner: objects/zones/lrz/sk
; Responsibility: Solid rock placement, motion, collision and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZSolidRock:
                move.l  #Map_LRZSolidRock,mappings(a0)
                move.w  #make_art_tile($090,3,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$200,priority(a0)
                move.w  y_pos(a0),$46(a0)
                move.l  #SKLRZSolidRock_WaitForForwardBit,(a0)
                move.w  #-$60,d0
                tst.b   subtype(a0)
                bpl.s   SKLRZSolidRock_SelectSavedEndpoint
                move.w  #-$C0,d0

SKLRZSolidRock_SelectSavedEndpoint:
                move.w  respawn_addr(a0),d1
                beq.s   SKLRZSolidRock_SelectDefaultEndpoint
                movea.w d1,a2
                btst    #0,(a2)
                beq.s   SKLRZSolidRock_SelectDefaultEndpoint
                btst    #6,subtype(a0)
                bne.s   SKLRZSolidRock_TryMirrorInitialOffset

SKLRZSolidRock_InitReverseEndpoint:
                neg.w   d0
                move.w  #-$3F6E,$32(a0)
                move.b  #1,$30(a0)
                move.l  #SKLRZSolidRock_WaitForReverseSignBit,(a0)
                bra.s   SKLRZSolidRock_TryMirrorInitialOffset
; ---------------------------------------------------------------------------

SKLRZSolidRock_SelectDefaultEndpoint:
                btst    #6,subtype(a0)
                bne.s   SKLRZSolidRock_InitReverseEndpoint

SKLRZSolidRock_TryMirrorInitialOffset:
                btst    #0,status(a0)
                beq.s   SKLRZSolidRock_ApplyInitialY
                neg.w   d0

SKLRZSolidRock_ApplyInitialY:
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKLRZSolidRock_WaitForForwardBit:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                btst    #0,(a3,d0.w)
                beq.s   SKLRZSolidRock_CheckSolidAndDraw
                move.l  #SKLRZSolidRock_StepTriggeredMotion,(a0)
                moveq   #signextendB(sfx_DoorOpen),d0
                jsr     (Play_SFX).l
                move.w  respawn_addr(a0),d0
                beq.s   SKLRZSolidRock_BeginForwardMotion
                movea.w d0,a2
                bset    #0,(a2)

SKLRZSolidRock_BeginForwardMotion:
                bra.s   SKLRZSolidRock_StepTriggeredMotion
; ---------------------------------------------------------------------------

SKLRZSolidRock_WaitForReverseSignBit:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d0.w)
                bpl.s   SKLRZSolidRock_CheckSolidAndDraw
                move.l  #SKLRZSolidRock_StepTriggeredMotion,(a0)
                moveq   #signextendB(sfx_DoorOpen),d0
                jsr     (Play_SFX).l
                move.w  respawn_addr(a0),d0
                beq.s   SKLRZSolidRock_StepTriggeredMotion
                movea.w d0,a2
                bclr    #0,(a2)

SKLRZSolidRock_StepTriggeredMotion:
                bsr.w   AdvanceTriggeredLrzSolidRockMotion

SKLRZSolidRock_CheckSolidAndDraw:
                move.w  #$23,d1
                move.w  #$10,d2
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

AdvanceTriggeredLrzSolidRockMotion:
                move.w  #$60,d2
                tst.b   $30(a0)
                bne.s   SKLRZSolidRock_SlowAndRearmReverse
                move.w  $34(a0),d1
                addq.w  #2,d1
                bne.s   SKLRZSolidRock_StoreAccelAndCheckTurn
                move.l  #SKLRZSolidRock_WaitForForwardBit,(a0)

SKLRZSolidRock_StoreAccelAndCheckTurn:
                move.w  d1,$34(a0)
                add.w   d1,$32(a0)
                cmp.b   $32(a0),d2
                bhi.s   SKLRZSolidRock_SelectTravelScale
                move.b  #1,$30(a0)
                bra.s   SKLRZSolidRock_SelectTravelScale
; ---------------------------------------------------------------------------

SKLRZSolidRock_SlowAndRearmReverse:
                move.w  $34(a0),d1
                subq.w  #2,d1
                bne.s   SKLRZSolidRock_StoreDecelAndCheckTurn
                move.l  #SKLRZSolidRock_WaitForReverseSignBit,(a0)

SKLRZSolidRock_StoreDecelAndCheckTurn:
                move.w  d1,$34(a0)
                add.w   d1,$32(a0)
                cmp.b   $32(a0),d2
                bls.s   SKLRZSolidRock_SelectTravelScale
                move.b  #0,$30(a0)

SKLRZSolidRock_SelectTravelScale:
                tst.b   $2C(a0)
                bmi.s   SKLRZSolidRock_DecodeLongOffset
                moveq   #0,d0
                move.b  $32(a0),d0
                subi.w  #$60,d0
                btst    #0,status(a0)
                beq.s   SKLRZSolidRock_ApplyShortOffset
                neg.w   d0

SKLRZSolidRock_ApplyShortOffset:
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKLRZSolidRock_DecodeLongOffset:
                moveq   #0,d0
                move.w  $32(a0),d0
                lsr.w   #7,d0
                subi.w  #$C0,d0
                btst    #0,status(a0)
                beq.s   SKLRZSolidRock_ApplyLongOffset
                neg.w   d0

SKLRZSolidRock_ApplyLongOffset:
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                rts
; End of function AdvanceTriggeredLrzSolidRockMotion

; ---------------------------------------------------------------------------
Map_LRZSolidRock:
                include "src/objects/shared/zones/lrz/mappings/solid_rock.s"
