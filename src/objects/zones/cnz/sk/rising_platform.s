; Owner: objects/zones/cnz/sk
; Responsibility: Carnival Night rising platform movement, player riding and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZRisingPlatform:
                move.l  #Map_CNZRisingPlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc+$6D,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$30,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #6,y_radius(a0)
                move.l  #SKCNZRisePlat_UpdateMotion,(a0)

SKCNZRisePlat_UpdateMotion:
                bsr.s   UpdateCnzRisingPlatformMotion

SKCNZRisePlat_ResolveSolidAndDraw:
                move.w  #$30,d1
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                lea     (Ani_CNZRisingPlatform).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Ani_CNZRisingPlatform:
                include "src/objects/shared/zones/cnz/animations/rising_platform.s"

; =============== S U B R O U T I N E =======================================

UpdateCnzRisingPlatformMotion:
                move.b  $30(a0),d0
                bne.s   SKCNZRisePlat_MoveWithRidersOrRelease
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   SKCNZRisePlat_StepReturnMotion
                move.b  #1,$30(a0)
                move.w  #1<<8,anim(a0)                  ; and prev_anim

SKCNZRisePlat_StepReturnMotion:
                tst.w   y_vel(a0)
                beq.s   SKCNZRisePlat_ReturnMotionDone
                jsr     (MoveSprite2).l
                addi.w  #8,y_vel(a0)
                tst.w   y_vel(a0)
                bmi.s   SKCNZRisePlat_ReturnMotionDone
                move.w  #0,y_vel(a0)
                move.w  #2<<8,anim(a0)                  ; and prev_anim

SKCNZRisePlat_ReturnMotionDone:
                rts
; ---------------------------------------------------------------------------

SKCNZRisePlat_MoveWithRidersOrRelease:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   SKCNZRisePlat_ReleaseUpward
                jsr     (MoveSprite2).l
                cmpi.w  #$200,y_vel(a0)
                bge.s   SKCNZRisePlat_TryStopAtFloor
                addi.w  #$18,y_vel(a0)

SKCNZRisePlat_TryStopAtFloor:
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKCNZRisePlat_FloorTestReturn
                add.w   d1,y_pos(a0)
                move.l  #SKCNZRisePlat_ResolveSolidAndDraw,(a0)
                move.w  #2<<8,anim(a0)                  ; and prev_anim

SKCNZRisePlat_FloorTestReturn:
                rts
; ---------------------------------------------------------------------------

SKCNZRisePlat_ReleaseUpward:
                neg.w   y_vel(a0)
                subi.w  #$80,y_vel(a0)
                move.b  #0,$30(a0)
                moveq   #signextendB(sfx_BalloonPlatform),d0
                jmp     (Play_SFX).l
; End of function UpdateCnzRisingPlatformMotion
