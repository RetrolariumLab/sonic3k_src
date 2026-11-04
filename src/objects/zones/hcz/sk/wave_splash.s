; Owner: objects/zones/hcz/sk
; Responsibility: Hydrocity wave splash state, sprite animation and mapping storage
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_HCZWaveSplash:
                move.l  #Map_HCZWaveSplash,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZWaveSplash,0,1),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                bset    #6,render_flags(a0)
                move.w  #1,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)
                addi.w  #$C0,(a2)+
                move.w  y_pos(a0),(a2)+
                move.l  #SKWaveSplash_PickSurfaceX,(a0)

SKWaveSplash_PickSurfaceX:
                move.w  (Camera_X_pos).w,d1
                andi.w  #$FFE0,d1
                addi.w  #$60,d1
                btst    #0,(Level_frame_counter+1).w
                beq.s   SKWaveSplash_PlaceAtWaterline
                addi.w  #$20,d1

SKWaveSplash_PlaceAtWaterline:
                move.w  d1,x_pos(a0)
                move.w  (Water_level).w,d1
                move.w  d1,y_pos(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)
                addi.w  #$C0,(a2)+
                move.w  y_pos(a0),(a2)+
                tst.b   $32(a0)
                bne.s   SKWaveSplash_CheckResumeFrames
                tst.b   (Ctrl_1_pressed_logical).w
                bmi.s   SKWaveSplash_EnterPausedFrames
                tst.b   (Ctrl_2_pressed_logical).w
                bpl.s   SKWaveSplash_StepNormalFrames

SKWaveSplash_EnterPausedFrames:
                addq.b  #3,mapping_frame(a0)
                move.b  #1,$32(a0)
                bra.s   SKWaveSplash_SyncFrameAndDraw
; ---------------------------------------------------------------------------

SKWaveSplash_CheckResumeFrames:
                tst.w   (Game_paused).w
                bne.s   SKWaveSplash_SyncFrameAndDraw
                move.b  #0,$32(a0)
                subq.b  #3,mapping_frame(a0)

SKWaveSplash_StepNormalFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKWaveSplash_SyncFrameAndDraw
                move.b  #9,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #4,mapping_frame(a0)
                blo.s   SKWaveSplash_SyncFrameAndDraw
                move.b  #1,mapping_frame(a0)

SKWaveSplash_SyncFrameAndDraw:
                move.b  mapping_frame(a0),1(a2)
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------
Map_HCZWaveSplash:
                include "src/objects/shared/zones/hcz/mappings/wave_splash.s"
; End of function Obj_HCZWaveSplash
