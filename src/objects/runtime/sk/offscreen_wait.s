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
                move.l  #loc_85AD2,(a0)

loc_85AD2:
                tst.b   render_flags(a0)
                bmi.s   loc_85B02
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_85AF0
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_85AF0:
                move.w  respawn_addr(a0),d0
                beq.s   loc_85AFC
                movea.w d0,a2
                bclr    #7,(a2)

loc_85AFC:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_85B02:
                move.l  $34(a0),(a0)                    ; Restore normal object operation when onscreen
                rts
; End of function Obj_WaitOffscreen

; ---------------------------------------------------------------------------
Map_Offscreen:
                dc.w    0
