; Owner: objects/zones/lbz/s3
; Responsibility: Launch Base exploding trigger collision, activation and destruction state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZExplodingTrigger:
                move.l  #Map_LBZExplodingTrigger,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZMisc+$70,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  #$C6,collision_flags(a0)
                move.l  #S3LBZBlastTrig_CheckContactsAndSwitch,(a0)

S3LBZBlastTrig_CheckContactsAndSwitch:
                move.b  collision_property(a0),d0
                beq.w   S3LBZBlastTrig_DrawAndCheckTouch
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                moveq   #0,d3
                lea     (Player_1).w,a1
                bclr    #0,collision_property(a0)
                beq.s   S3LBZBlastTrig_TryP2Contact
                bsr.s   ActivateLbzExplodingTrigger

S3LBZBlastTrig_TryP2Contact:
                lea     (Player_2).w,a1
                bclr    #1,collision_property(a0)
                beq.s   S3LBZBlastTrig_DrawAndCheckTouch
                bsr.s   ActivateLbzExplodingTrigger

S3LBZBlastTrig_DrawAndCheckTouch:
                jmp     (Sprite_CheckDeleteTouch3).l

; =============== S U B R O U T I N E =======================================

ActivateLbzExplodingTrigger:
                cmpi.b  #2,anim(a1)
                bne.s   S3LBZBlastTrig_ActivationReturn
                neg.w   x_vel(a1)
                neg.w   y_vel(a1)
                bchg    d3,(a3)
                move.l  #Obj_Explosion,(a0)
                move.b  #2,routine(a0)
                clr.b   collision_flags(a0)
                clr.b   collision_property(a0)

S3LBZBlastTrig_ActivationReturn:
                rts
; End of function ActivateLbzExplodingTrigger

; ---------------------------------------------------------------------------
Map_LBZExplodingTrigger:
                include "src/objects/shared/zones/lbz/mappings/exploding_trigger.s"
