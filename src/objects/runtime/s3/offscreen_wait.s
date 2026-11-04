; Owner: objects/runtime/s3
; Responsibility: Suspend offscreen objects with a private empty mapping before their normal activation
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Obj_WaitOffscreen:
                move.l  #Map_Offscreen,mappings(a0)
                bset    #2,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  (sp)+,$34(a0)
                move.l  #S3RuntimeLifetime_OffscreenWait_CheckPriorRenderBeforeCoarseCull,(a0)

S3RuntimeLifetime_OffscreenWait_CheckPriorRenderBeforeCoarseCull:
                tst.b   render_flags(a0)
                bmi.s   S3RuntimeLifetime_OffscreenWait_InstallCapturedInitializationContinuation
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   S3RuntimeLifetime_OffscreenWait_ReleaseRespawnBeforeImmediateClear
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3RuntimeLifetime_OffscreenWait_ReleaseRespawnBeforeImmediateClear:
                move.w  respawn_addr(a0),d0
                beq.s   S3RuntimeLifetime_OffscreenWait_ClearCurrentSlotImmediately
                movea.w d0,a2
                bclr    #7,(a2)

S3RuntimeLifetime_OffscreenWait_ClearCurrentSlotImmediately:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3RuntimeLifetime_OffscreenWait_InstallCapturedInitializationContinuation:
                move.l  $34(a0),(a0)                    ; Restore normal object operation when onscreen
                rts
; End of function Obj_WaitOffscreen

; ---------------------------------------------------------------------------
Map_Offscreen:
                dc.w    0
