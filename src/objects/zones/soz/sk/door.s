; Owner: objects/zones/soz/sk
; Responsibility: Door trigger state, opening, motion and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZDoor:
                move.l  #Map_SOZDoor,mappings(a0)
                move.w  #make_art_tile(ArtTile_SOZMisc+$8C,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$40,height_pixels(a0)
                move.w  #$200,priority(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                move.b  (a3,d0.w),d0
                move.w  d0,$36(a0)
                move.b  subtype(a0),d0
                andi.w  #$F0,d0
                beq.s   SKSOZDoor_InitVerticalTracking
                move.b  #1,mapping_frame(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.l  #SKSOZDoor_TrackHorizontalTrigger,(a0)
                bra.s   SKSOZDoor_TrackHorizontalTrigger
; ---------------------------------------------------------------------------

SKSOZDoor_InitVerticalTracking:
                move.l  #SKSOZDoor_TrackVerticalTrigger,(a0)

SKSOZDoor_TrackVerticalTrigger:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                move.b  (a3,d0.w),d0
                moveq   #1,d1
                cmp.w   $36(a0),d0
                beq.s   SKSOZDoor_GetSignedYOffset
                bcc.s   SKSOZDoor_StepVerticalTravel
                neg.w   d1

SKSOZDoor_StepVerticalTravel:
                add.w   d1,$36(a0)

SKSOZDoor_GetSignedYOffset:
                move.w  $36(a0),d0
                btst    #0,status(a0)
                bne.s   SKSOZDoor_ApplyYOffset
                neg.w   d0

SKSOZDoor_ApplyYOffset:
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)

SKSOZDoor_CheckSolidAndDraw:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKSOZDoor_TrackHorizontalTrigger:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                move.b  (a3,d0.w),d0
                moveq   #1,d1
                cmp.w   $36(a0),d0
                beq.s   SKSOZDoor_GetSignedXOffset
                bcc.s   SKSOZDoor_StepHorizontalTravel
                neg.w   d1

SKSOZDoor_StepHorizontalTravel:
                add.w   d1,$36(a0)

SKSOZDoor_GetSignedXOffset:
                move.w  $36(a0),d0
                btst    #0,status(a0)
                bne.s   SKSOZDoor_ApplyXOffset
                neg.w   d0

SKSOZDoor_ApplyXOffset:
                add.w   $44(a0),d0
                move.w  d0,x_pos(a0)
                bra.s   SKSOZDoor_CheckSolidAndDraw
; ---------------------------------------------------------------------------
Map_SOZDoor:
                include "src/objects/shared/zones/soz/mappings/door.s"
; End of function Obj_SOZDoor
