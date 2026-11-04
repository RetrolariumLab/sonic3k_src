; Owner: objects/zones/soz/sk
; Responsibility: Rising sand wall timing, coordinated movement and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZRisingSandWall:
                move.l  #Map_SOZRisingSandWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_SOZMisc+$69,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$34,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.w  #$19,$30(a0)
                move.l  #SKSOZSandWall_CheckBothForActivation,(a0)

SKSOZSandWall_CheckBothForActivation:
                moveq   #0,d1
                move.b  subtype(a0),d1
                move.w  d1,d2
                add.w   d2,d2
                lea     (Player_1).w,a1
                bsr.s   ActivateSozRisingSandWallNearPlayer
                lea     (Player_2).w,a1
                bsr.s   ActivateSozRisingSandWallNearPlayer
                bra.w   SKSOZSandWall_CheckSolidAndDraw

; =============== S U B R O U T I N E =======================================

ActivateSozRisingSandWallNearPlayer:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                cmp.w   d2,d0
                bhs.w   SKSOZSandWall_ActivationReturn
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$A4,d0
                cmpi.w  #$C0,d0
                bhs.s   SKSOZSandWall_ActivationReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKSOZSandWall_ActivationReturn
                bset    #6,render_flags(a0)
                move.w  #2,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),d0
                move.w  d0,(a2)+
                move.w  #9,(a2)+
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #0,(a2)+
                move.b  #3,anim_frame_timer(a0)
                moveq   #signextendB(sfx_SandwallRise),d0
                jsr     (Play_SFX).l
                move.l  #SKSOZSandWall_AnimateAnchoredRiseDust,(a0)

SKSOZSandWall_ActivationReturn:
                rts
; End of function ActivateSozRisingSandWallNearPlayer

; ---------------------------------------------------------------------------

SKSOZSandWall_AnimateAnchoredRiseDust:
                lea     sub2_x_pos(a0),a2
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKSOZSandWall_StepRiseAndCheckEnd
                move.b  #3,anim_frame_timer(a0)
                addq.b  #1,sub2_mapframe(a0)
                cmpi.b  #$D,sub2_mapframe(a0)
                blo.s   SKSOZSandWall_StepRiseAndCheckEnd
                move.b  #9,sub2_mapframe(a0)

SKSOZSandWall_StepRiseAndCheckEnd:
                subq.w  #4,y_pos(a0)
                move.w  y_pos(a0),$20(a0)
                subq.w  #1,$30(a0)
                bpl.s   SKSOZSandWall_CheckSolidAndDraw
                bclr    #6,render_flags(a0)
                move.w  #0,mainspr_childsprites(a0)
                move.l  #SKSOZSandWall_CheckSolidAndP1Roll,(a0)

SKSOZSandWall_CheckSolidAndDraw:
                move.w  #$17,d1
                move.w  #$34,d2
                move.w  #$35,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKSOZSandWall_CheckSolidAndP1Roll:
                move.w  #$17,d1
                move.w  #$34,d2
                move.w  #$35,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                swap    d6
                andi.w  #3,d6
                beq.w   SKSOZSandWall_DrawWall
                btst    #0,d6
                beq.s   SKSOZSandWall_TryBreakWithP2Roll
                lea     (Player_1).w,a1
                cmpi.b  #2,anim(a1)
                bne.s   SKSOZSandWall_TryBreakWithP2Roll
                asr     x_vel(a1)
                asr     ground_vel(a1)
                bra.s   SKSOZSandWall_BeginDissolveAndRelease
; ---------------------------------------------------------------------------

SKSOZSandWall_TryBreakWithP2Roll:
                btst    #1,d6
                beq.s   SKSOZSandWall_DrawWall
                lea     (Player_2).w,a1
                cmpi.b  #2,anim(a1)
                bne.s   SKSOZSandWall_DrawWall
                asr     x_vel(a1)
                asr     ground_vel(a1)

SKSOZSandWall_BeginDissolveAndRelease:
                moveq   #signextendB(sfx_SandSplash),d0
                jsr     (Play_SFX).l
                move.l  #SKSOZSandWall_TickDissolve,(a0)
                move.b  #5,anim_frame_timer(a0)
                move.b  #1,mapping_frame(a0)
                lea     (Player_1).w,a1
                bclr    #p1_standing_bit,status(a0)
                beq.s   SKSOZSandWall_ClearP1Push
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)

SKSOZSandWall_ClearP1Push:
                bclr    #p1_pushing_bit,status(a0)
                beq.s   SKSOZSandWall_ReleaseP2Standing
                bclr    #Status_Push,status(a1)

SKSOZSandWall_ReleaseP2Standing:
                lea     (Player_2).w,a1
                bclr    #p2_standing_bit,status(a0)
                beq.s   SKSOZSandWall_ClearP2Push
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)

SKSOZSandWall_ClearP2Push:
                bclr    #p2_pushing_bit,status(a0)
                beq.s   SKSOZSandWall_DrawWall
                bclr    #Status_Push,status(a1)

SKSOZSandWall_DrawWall:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKSOZSandWall_TickDissolve:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKSOZSandWall_DrawDissolve
                move.b  #5,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #9,mapping_frame(a0)
                blo.s   SKSOZSandWall_DrawDissolve
                move.w  #$7F00,x_pos(a0)

SKSOZSandWall_DrawDissolve:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_SOZRisingSandWall:
                include "src/objects/shared/zones/soz/mappings/rising_sand_wall.s"
