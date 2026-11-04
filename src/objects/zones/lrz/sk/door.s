; Owner: objects/zones/lrz/sk
; Responsibility: Door trigger state, opening, motion and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZDoor:
                move.l  #Map_LRZDoor,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZMisc,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.w  #$200,priority(a0)
                move.w  y_pos(a0),$46(a0)
                tst.b   (Current_act).w
                beq.s   SKLRZDoor_InitTriggerWait
                move.b  #1,mapping_frame(a0)
                move.w  #make_art_tile($090,2,0),art_tile(a0)
                move.b  #$20,height_pixels(a0)

SKLRZDoor_InitTriggerWait:
                move.l  #SKLRZDoor_TryOpenOnTrigger,(a0)

SKLRZDoor_TryOpenOnTrigger:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d0.w)
                beq.s   SKLRZDoor_CheckSolidAndDraw
                move.l  #SKLRZDoor_StepOpeningAngle,(a0)
                moveq   #signextendB(sfx_DoorOpen),d0
                jsr     (Play_SFX).l

SKLRZDoor_StepOpeningAngle:
                addq.b  #1,$2E(a0)
                cmpi.b  #$40,$2E(a0)
                bne.s   SKLRZDoor_ApplySineLift
                move.l  #SKLRZDoor_CheckSolidAndDraw,(a0)

SKLRZDoor_ApplySineLift:
                move.b  $2E(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d0
                neg.w   d0
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)

SKLRZDoor_CheckSolidAndDraw:
                move.w  #$1B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_LRZDoor:
                include "src/objects/shared/zones/lrz/mappings/door.s"
; End of function Obj_LRZDoor
