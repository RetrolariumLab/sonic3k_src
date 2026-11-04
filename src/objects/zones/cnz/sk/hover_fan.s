; Owner: objects/zones/cnz/sk
; Responsibility: Carnival Night hovering fan motion, player lift and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZHoverFan:
                move.l  #Map_CNZHoverFan,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc+$97,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  x_pos(a0),$30(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$F,d0
                addq.w  #4,d0
                lsl.w   #4,d0
                move.w  d0,$36(a0)
                addi.w  #$30,d0
                move.w  d0,$38(a0)
                andi.w  #$70,d1
                addi.w  #$18,d1
                move.w  d1,$32(a0)
                add.w   d1,d1
                move.w  d1,$34(a0)
                move.b  subtype(a0),d0
                bmi.s   SKCNZHoverFan_SetVisibleVariant
                move.l  #SKCNZHoverFan_UpdateHiddenField,(a0)
                bra.w   SKCNZHoverFan_UpdateHiddenField
; ---------------------------------------------------------------------------

SKCNZHoverFan_SetVisibleVariant:
                andi.w  #$70,d0
                move.w  d0,d1
                lsr.w   #4,d0
                move.b  d0,mapping_frame(a0)
                addi.b  #$10,d1
                move.b  d1,width_pixels(a0)
                btst    #0,status(a0)
                bne.s   SKCNZHoverFan_StartMovingFan
                move.l  #SKCNZHoverFan_UpdateVisibleField,(a0)
                bra.w   SKCNZHoverFan_UpdateVisibleField
; ---------------------------------------------------------------------------

SKCNZHoverFan_StartMovingFan:
                move.l  #SKCNZHoverFan_MoveWithOscillator,(a0)

SKCNZHoverFan_MoveWithOscillator:
                moveq   #0,d0
                move.b  (Oscillating_table+$0E).w,d0
                subi.w  #$30,d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)

SKCNZHoverFan_UpdateVisibleField:
                moveq   #0,d6
                lea     (Player_1).w,a1
                bsr.w   ApplyCnzHoverFanFieldToPlayer
                lea     (Player_2).w,a1
                bsr.w   ApplyCnzHoverFanFieldToPlayer
                tst.w   d6
                beq.s   SKCNZHoverFan_DrawFromOrigin
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$1F,d0
                bne.s   SKCNZHoverFan_DrawFromOrigin
                moveq   #signextendB(sfx_Hoverpad),d0
                jsr     (Play_SFX).l

SKCNZHoverFan_DrawFromOrigin:
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

SKCNZHoverFan_UpdateHiddenField:
                moveq   #0,d6
                lea     (Player_1).w,a1
                bsr.w   ApplyCnzHoverFanFieldToPlayer
                lea     (Player_2).w,a1
                bsr.w   ApplyCnzHoverFanFieldToPlayer
                tst.w   d6
                beq.s   SKCNZHoverFan_CullHiddenFan
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$1F,d0
                bne.s   SKCNZHoverFan_CullHiddenFan
                moveq   #signextendB(sfx_Hoverpad),d0
                jsr     (Play_SFX).l

SKCNZHoverFan_CullHiddenFan:
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

ApplyCnzHoverFanFieldToPlayer:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   $32(a0),d0
                cmp.w   $34(a0),d0
                bhs.w   SKCNZHoverFan_FieldReturn
                moveq   #0,d1
                move.b  (Oscillating_table+$16).w,d1
                add.w   y_pos(a1),d1
                add.w   $36(a0),d1
                sub.w   y_pos(a0),d1
                bcs.s   SKCNZHoverFan_FieldReturn
                cmp.w   $38(a0),d1
                bhs.s   SKCNZHoverFan_FieldReturn
                cmpi.b  #4,routine(a1)
                bhs.w   SKCNZHoverFan_FieldReturn
                tst.b   object_control(a1)
                bne.s   SKCNZHoverFan_FieldReturn
                sub.w   $36(a0),d1
                bcs.s   SKCNZHoverFan_LiftAndSetTumble
                not.w   d1
                add.w   d1,d1

SKCNZHoverFan_LiftAndSetTumble:
                add.w   $36(a0),d1
                neg.w   d1
                asr.w   #4,d1
                add.w   d1,y_pos(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.w  #0,y_vel(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,jumping(a1)
                moveq   #1,d6
                move.w  #1,ground_vel(a1)
                tst.b   flip_angle(a1)
                bne.s   SKCNZHoverFan_FieldReturn
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #$7F,flips_remaining(a1)
                move.b  #8,flip_speed(a1)

SKCNZHoverFan_FieldReturn:
                rts
; End of function ApplyCnzHoverFanFieldToPlayer
