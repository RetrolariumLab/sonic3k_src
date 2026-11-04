; Owner: objects/zones/fbz/sk
; Responsibility: Screw-door movement, player interaction, opening and collision
; Source provenance and ranges: config/reconstruction/source_layout.json
SKFBZScrewDoor_SubtypeDimensions:
                dc.b    8, $20
                dc.b    $20,   8
                dc.b    $40,   8
                even
; ---------------------------------------------------------------------------

Obj_FBZScrewDoor:
                move.b  subtype(a0),d0
                lsr.w   #4,d0
                andi.w  #7,d0
                move.b  d0,anim(a0)
                andi.w  #6,d0
                move.b  SKFBZScrewDoor_SubtypeDimensions(pc,d0.w),width_pixels(a0)
                move.b  SKFBZScrewDoor_SubtypeDimensions+1(pc,d0.w),height_pixels(a0)
                move.l  #Map_FBZScrewDoor,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc+$59,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                lea     (Ani_FBZScrewDoor).l,a1
                jsr     (Animate_Sprite).l
                tst.b   subtype(a0)
                bpl.s   SKFBZScrewDoor_StartTriggerPoll
                move.w  respawn_addr(a0),d0
                beq.s   SKFBZScrewDoor_StartPersistentGate
                movea.w d0,a2
                btst    #0,(a2)
                beq.s   SKFBZScrewDoor_StartPersistentGate
                addi.w  #$40,y_pos(a0)
                move.l  #SKFBZScrewDoor_ResolveSolidAndDraw,(a0)
                bra.w   SKFBZScrewDoor_ResolveSolidAndDraw
; ---------------------------------------------------------------------------

SKFBZScrewDoor_StartPersistentGate:
                move.l  #SKFBZScrewDoor_CheckP1OpenWindow,(a0)
                bra.w   SKFBZScrewDoor_CheckP1OpenWindow
; ---------------------------------------------------------------------------

SKFBZScrewDoor_StartTriggerPoll:
                move.l  #SKFBZScrewDoor_TryOpenFromTrigger,(a0)

SKFBZScrewDoor_TryOpenFromTrigger:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d0.w)
                beq.s   SKFBZScrewDoor_ResolveSolidAndDraw
                move.l  #SKFBZScrewDoor_StepOpening,(a0)
                moveq   #signextendB(sfx_DoorOpen),d0
                jsr     (Play_SFX).l

SKFBZScrewDoor_StepOpening:
                addq.b  #1,$2E(a0)
                cmpi.b  #$80,$2E(a0)
                bne.s   SKFBZScrewDoor_SignTravelOffset
                move.l  #SKFBZScrewDoor_ResolveSolidAndDraw,(a0)

SKFBZScrewDoor_SignTravelOffset:
                moveq   #0,d0
                move.b  $2E(a0),d0
                btst    #4,subtype(a0)
                beq.s   SKFBZScrewDoor_SelectTravelAxis
                neg.w   d0

SKFBZScrewDoor_SelectTravelAxis:
                btst    #5,subtype(a0)
                bne.s   SKFBZScrewDoor_HalveXOffset
                btst    #6,subtype(a0)
                bne.s   SKFBZScrewDoor_PlaceXAndAnimate
                asr.w   #1,d0
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                lea     (Ani_FBZScrewDoor).l,a1
                jsr     (Animate_Sprite).l
                bra.s   SKFBZScrewDoor_ResolveSolidAndDraw
; ---------------------------------------------------------------------------

SKFBZScrewDoor_HalveXOffset:
                asr.w   #1,d0

SKFBZScrewDoor_PlaceXAndAnimate:
                add.w   $44(a0),d0
                move.w  d0,x_pos(a0)
                lea     (Ani_FBZScrewDoor).l,a1
                jsr     (Animate_Sprite).l

SKFBZScrewDoor_ResolveSolidAndDraw:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.w  $44(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

SKFBZScrewDoor_CheckP1OpenWindow:
                lea     (Player_1).w,a1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #-$20,d0
                cmpi.w  #$40,d0
                bhs.s   SKFBZScrewDoor_ResolveSolidAndDraw
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                btst    #0,status(a0)
                beq.s   SKFBZScrewDoor_TrySaveDoorOpened
                neg.w   d0

SKFBZScrewDoor_TrySaveDoorOpened:
                cmpi.w  #$40,d0
                blt.s   SKFBZScrewDoor_ResolveSolidAndDraw
                move.w  respawn_addr(a0),d0
                beq.s   SKFBZScrewDoor_BeginOpening
                movea.w d0,a2
                bset    #0,(a2)

SKFBZScrewDoor_BeginOpening:
                move.l  #SKFBZScrewDoor_StepOpening,(a0)
                bra.w   SKFBZScrewDoor_StepOpening
; ---------------------------------------------------------------------------
Ani_FBZScrewDoor:
                include "src/objects/shared/zones/fbz/animations/screw_door.s"
Map_FBZScrewDoor:
                include "src/objects/shared/zones/fbz/mappings/screw_door.s"
; End of function Obj_FBZScrewDoor
