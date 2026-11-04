; Owner: game/level/sk
; Responsibility: New-level transition actor, player state preparation and restart control helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_StartNewLevel:
                lea     (Player_1).w,a1
                lea     word_86426(pc),a2
                jsr     (Check_InMyRange).l
                beq.w   SKReturn_AttrSetup
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_86418
                cmpi.b  #9,(Current_zone).w
                bne.s   loc_86418
                st      (SRAM_mask_interrupts_flag).w
                jsr     (SaveGame).l

loc_86418:
                moveq   #0,d0
                move.w  subtype(a0),d0
                lsr.w   #1,d0
                rol.b   #1,d0
                jmp     StartNewLevel(pc)
; ---------------------------------------------------------------------------
word_86426:
                dc.w    -$10,   $20,  -$80,  $100
; ---------------------------------------------------------------------------

loc_8642E:
                st      (Screen_shake_flag).w
                move.l  #loc_86438,(a0)

loc_86438:
                tst.w   (Screen_shake_flag).w
                beq.s   loc_86452
                move.b  (V_int_run_count+3).w,d1
                andi.b  #$F,d1
                bne.w   SKReturn_AttrSetup
                moveq   #signextendB(sfx_Rumble2),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

loc_86452:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

SKPositionMultiSpriteChildrenFromSignedBytePairs:
                lea     sub2_x_pos(a0),a2
                move.w  mainspr_childsprites(a0),d0
                subq.w  #1,d0
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3

loc_8646A:
                move.b  (a1)+,d1
                ext.w   d1
                btst    #0,render_flags(a0)
                beq.s   loc_86478
                neg.w   d1

loc_86478:
                add.w   d2,d1
                move.w  d1,(a2)+
                move.b  (a1)+,d1
                ext.w   d1
                add.w   d3,d1
                move.w  d1,(a2)+
                addq.w  #2,a2
                dbf     d0,loc_8646A
                rts
; End of function SKPositionMultiSpriteChildrenFromSignedBytePairs
