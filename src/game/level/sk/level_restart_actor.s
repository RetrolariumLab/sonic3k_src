; Owner: game/level/sk
; Responsibility: New-level transition actor, player state preparation and restart control helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_StartNewLevel:
                lea     (Player_1).w,a1
                lea     SKLevel_RestartActorPlayerRangeRectangle(pc),a2
                jsr     (Check_InMyRange).l
                beq.w   SKReturn_AttrSetup
                cmpi.w  #3,(Player_mode).w
                bne.s   SKLevel_RestartFromActorSubtype
                cmpi.b  #9,(Current_zone).w
                bne.s   SKLevel_RestartFromActorSubtype
                st      (SRAM_mask_interrupts_flag).w
                jsr     (SaveGame).l

SKLevel_RestartFromActorSubtype:
                moveq   #0,d0
                move.w  subtype(a0),d0
                lsr.w   #1,d0
                rol.b   #1,d0
                jmp     StartNewLevel(pc)
; ---------------------------------------------------------------------------
SKLevel_RestartActorPlayerRangeRectangle:
                dc.w    -$10,   $20,  -$80,  $100
; ---------------------------------------------------------------------------

SKLevel_InitializeScreenShakeRumbleActor:
                st      (Screen_shake_flag).w
                move.l  #SKLevel_WaitForScreenShakeAndPulseRumble,(a0)

SKLevel_WaitForScreenShakeAndPulseRumble:
                tst.w   (Screen_shake_flag).w
                beq.s   SKLevel_DeleteFinishedScreenShakeActor
                move.b  (V_int_run_count+3).w,d1
                andi.b  #$F,d1
                bne.w   SKReturn_AttrSetup
                moveq   #signextendB(sfx_Rumble2),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

SKLevel_DeleteFinishedScreenShakeActor:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

; Add signed byte offset pairs to the parent position and mirror X when requested
SKMultiSprite_PositionChildren:
                lea     sub2_x_pos(a0),a2
                move.w  mainspr_childsprites(a0),d0
                subq.w  #1,d0
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3

SKLevel_ReadMirroredChildX:
                move.b  (a1)+,d1
                ext.w   d1
                btst    #0,render_flags(a0)
                beq.s   SKLevel_StoreChildPosition
                neg.w   d1

SKLevel_StoreChildPosition:
                add.w   d2,d1
                move.w  d1,(a2)+
                move.b  (a1)+,d1
                ext.w   d1
                add.w   d3,d1
                move.w  d1,(a2)+
                addq.w  #2,a2
                dbf     d0,SKLevel_ReadMirroredChildX
                rts
; End of function SKMultiSprite_PositionChildren
