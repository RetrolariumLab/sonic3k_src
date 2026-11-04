; Owner: objects/runtime/sk
; Responsibility: Suspend offscreen objects with a private empty mapping until normal activation
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Obj_WaitOffscreen:
                move.l  #Map_Offscreen,mappings(a0)
                bset    #2,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  (sp)+,$34(a0)
                move.l  #SKOffscreenWait_CheckRenderOrCull,(a0)

; The previous draw's render flag takes precedence over the coarse X cull
SKOffscreenWait_CheckRenderOrCull:
                tst.b   render_flags(a0)
                bmi.s   SKOffscreenWait_RestoreInit
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   SKOffscreenWait_ReleaseRespawn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKOffscreenWait_ReleaseRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   SKOffscreenWait_DeleteNow
                movea.w d0,a2
                bclr    #7,(a2)

SKOffscreenWait_DeleteNow:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKOffscreenWait_RestoreInit:
                move.l  $34(a0),(a0)                    ; Restore normal object operation when onscreen
                rts
; End of function Obj_WaitOffscreen

; ---------------------------------------------------------------------------
Map_Offscreen:
                dc.w    0
