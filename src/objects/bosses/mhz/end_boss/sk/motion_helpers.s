; Owner: objects/bosses/mhz/end_boss/sk
; Responsibility: Mushroom Hill end-boss collision, movement, palette and parent-state helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

OffsetMHZWeatherMachineEffectBySubtype:
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     word_7672E(pc,d0.w),a1
                move.w  (a1)+,d0
                add.w   d0,x_pos(a0)
                move.w  (a1)+,d0
                add.w   d0,y_pos(a0)
                rts
; End of function OffsetMHZWeatherMachineEffectBySubtype

; ---------------------------------------------------------------------------
word_7672E:
                dc.w    -$4D,  -$4E
                dc.w    -$A1,  -$A2
                dc.w    -$F5,  -$F6
                dc.w    -$149, -$14A

; =============== S U B R O U T I N E =======================================

SelectMHZEndBossOverlayLayerBySubtype:
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     word_76754(pc,d0.w),a1
                move.w  (a1)+,priority(a0)
                move.b  (a1)+,mapping_frame(a0)
                rts
; End of function SelectMHZEndBossOverlayLayerBySubtype

; ---------------------------------------------------------------------------
word_76754:
                dc.w    $300
                dc.b    2
                even
                dc.w    $200
                dc.b    3
                even

; =============== S U B R O U T I N E =======================================

SyncMHZEndBossOverlayPositionAndHorizontalFlip:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                bclr    #0,render_flags(a0)
                btst    #0,render_flags(a1)
                beq.s   locret_76780
                bset    #0,render_flags(a0)

locret_76780:
                rts
; End of function SyncMHZEndBossOverlayPositionAndHorizontalFlip

; =============== S U B R O U T I N E =======================================

HandleMHZEndBossPairedHitFlashAndEscapeThreshold:
                movea.w $44(a0),a4
                move.b  collision_property(a0),d0
                tst.b   collision_flags(a0)
                beq.s   loc_767A0
                tst.b   collision_flags(a4)
                bne.w   locret_76820
                subq.b  #1,d0
                move.b  $1C(a4),$1C(a0)

loc_767A0:
                btst    #7,$38(a0)
                bne.s   loc_767B0
                cmpi.b  #1,d0
                bgt.s   loc_767B0
                moveq   #2,d0

loc_767B0:
                move.b  d0,collision_property(a0)
                tst.b   $20(a0)
                bne.s   loc_767E8
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)
                clr.b   collision_flags(a0)
                clr.b   collision_flags(a4)
                lea     (Player_1).w,a1
                tst.b   $1C(a0)
                beq.s   loc_767E4
                lea     (Player_2).w,a1

loc_767E4:
                clr.w   x_vel(a1)

loc_767E8:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_767F6
                addi.w  #2*5,d0

loc_767F6:
                bsr.w   CopyMHZEndBossFiveColorPalette
                subq.b  #1,$20(a0)
                bne.s   locret_76820
                bclr    #6,status(a0)
                cmpi.b  #1,collision_property(a0)
                beq.s   loc_76822
                move.b  $25(a0),collision_flags(a0)
                move.b  $25(a4),collision_flags(a4)
                move.b  #-1,collision_property(a4)

locret_76820:
                rts
; ---------------------------------------------------------------------------

loc_76822:
                move.l  #loc_76164,(a0)
                bclr    #6,$38(a0)
                move.w  #$400,d0
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   loc_7683E
                move.w  #$500,d0

loc_7683E:
                move.w  d0,x_vel(a0)
                st      (_unkFAA9).w
                jsr     (AllocateObject).l
                bne.s   loc_76854
                move.l  #loc_768B6,(a1)

loc_76854:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   locret_76868
                move.b  #$20,subtype(a1)

locret_76868:
                rts
; End of function HandleMHZEndBossPairedHitFlashAndEscapeThreshold

; =============== S U B R O U T I N E =======================================

CopyMHZEndBossFiveColorPalette:
                lea     word_76878(pc),a1
                lea     word_76882(pc,d0.w),a2
                jmp     (CopyWordData_5).l
; End of function CopyMHZEndBossFiveColorPalette

; ---------------------------------------------------------------------------
word_76878:
                dc.w    Normal_palette_line_2+$08, Normal_palette_line_2+$14, Normal_palette_line_2+$16, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
word_76882:
                dc.w    $E42,  $228,     0,  $C40,  $820
                dc.w    $888,  $AAA,  $EEE,  $888,  $AAA
; ---------------------------------------------------------------------------

loc_76896:
                cmpi.w  #$4010,(Camera_X_pos).w
                blo.w   locret_76060
                lea     (ArtKosM_MHZEndBossSpikes).l,a1
                move.w  #tiles_to_bytes(ArtTile_MHZEndBossSpikes),d2
                jsr     (Queue_Kos_Module).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_768B6:
                tst.b   (_unkFAA9).w
                bne.w   locret_76060
                move.l  #loc_768D2,(a0)
                jsr     (AllocateObject).l
                bne.s   loc_768D2
                move.l  #SKRuntime_SecondaryInput_BeginLogicalClearActorIfCodeExists,(a1)

loc_768D2:
                moveq   #0,d0
                lea     (Player_1).w,a1
                bclr    #Status_Facing,status(a1)
                bclr    #Status_Roll,status(a1)
                btst    #Status_InAir,status(a1)
                bne.s   locret_768FC
                move.l  #loc_768FE,(a0)
                move.w  #$55,(Events_fg_5).w
                st      (Ctrl_1_locked).w

locret_768FC:
                rts
; ---------------------------------------------------------------------------

loc_768FE:
                move.w  #(button_right_mask<<8)|button_right_mask,(Ctrl_1_logical).w
                lea     (Player_1).w,a1
                cmpi.w  #$4600,x_pos(a1)
                bhs.s   loc_76912
                rts
; ---------------------------------------------------------------------------

loc_76912:
                move.w  #$4600,x_pos(a1)
                jsr     (Stop_Object).l
                clr.w   (Ctrl_1_logical).w
                jmp     (Delete_Current_Sprite).l
; End of function loc_768FE
