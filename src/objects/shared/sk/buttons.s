; Owner: objects/shared/sk
; Responsibility: Shared button collision, trigger state and zone or competition mapping variants
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_Button:
                tst.w   (Competition_mode).w
                bne.w   SKButton_InitializeCompetitionButton
                move.l  #Map_Button,mappings(a0)
                move.w  #make_art_tile(ArtTile_GrayButton,0,0),art_tile(a0)
                cmpi.b  #1,(Current_zone).w
                bne.s   SKButton_SelectCNZMappingOverride
                move.l  #Map_HCZButton,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZButton,1,0),art_tile(a0)

SKButton_SelectCNZMappingOverride:
                cmpi.b  #3,(Current_zone).w
                bne.s   SKButton_SelectFBZArtOnlyOverride
                move.l  #Map_CNZButton,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc+$C9,2,0),art_tile(a0)

SKButton_SelectFBZArtOnlyOverride:
                cmpi.b  #4,(Current_zone).w
                bne.s   SKButton_SelectLRZMappingAndActArt
                move.w  #make_art_tile(ArtTile_FBZButton,0,0),art_tile(a0)

SKButton_SelectLRZMappingAndActArt:
                cmpi.b  #9,(Current_zone).w
                bne.s   SKButton_InitNormalGeometry
                move.l  #Map_LRZButton,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZMisc,3,0),art_tile(a0)
                tst.b   (Current_act).w
                beq.s   SKButton_InitNormalGeometry
                move.w  #make_art_tile(ArtTile_LRZ2Misc+$1C,1,0),art_tile(a0)

SKButton_InitNormalGeometry:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  #$200,priority(a0)
                addq.w  #4,y_pos(a0)
                btst    #5,subtype(a0)
                beq.s   SKButton_InstallNormalFullSolidHandler
                move.l  #SKButton_UpdateNormalTopOnlyButton,(a0)
                bra.w   SKButton_UpdateNormalTopOnlyButton
; ---------------------------------------------------------------------------

SKButton_InstallNormalFullSolidHandler:
                move.l  #SKButton_UpdateNormalFullSolidButton,(a0)

SKButton_UpdateNormalFullSolidButton:
                tst.b   render_flags(a0)
                bpl.s   SKButton_DrawFullSolidIfVisible
                move.w  #$1B,d1
                move.w  #4,d2
                move.w  #5,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.b  #0,mapping_frame(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                moveq   #0,d3
                btst    #6,subtype(a0)
                beq.s   SKButton_UpdateFullSolidPress
                moveq   #7,d3

SKButton_UpdateFullSolidPress:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   SKButton_TryFullSolidPressSound
                btst    #4,subtype(a0)
                bne.s   SKButton_DrawFullSolidIfVisible
                bclr    d3,(a3)
                bra.s   SKButton_DrawFullSolidIfVisible
; ---------------------------------------------------------------------------

; Play the press sound only when the entire trigger byte is zero
SKButton_TryFullSolidPressSound:
                tst.b   (a3)
                bne.s   SKButton_SetFullSolidTriggerAndFrame
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

SKButton_SetFullSolidTriggerAndFrame:
                bset    d3,(a3)
                move.b  #1,mapping_frame(a0)

SKButton_DrawFullSolidIfVisible:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKButton_UpdateNormalTopOnlyButton:
                tst.b   render_flags(a0)
                bpl.s   SKButton_CullAndDrawNormalTopOnlyButton
                move.w  #$10,d1
                move.w  #6,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                move.b  #0,mapping_frame(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                moveq   #0,d3
                btst    #6,subtype(a0)
                beq.s   SKButton_UpdateTopOnlyPress
                moveq   #7,d3

SKButton_UpdateTopOnlyPress:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   SKButton_TryTopOnlyPressSound
                btst    #4,subtype(a0)
                bne.s   SKButton_CullAndDrawNormalTopOnlyButton
                bclr    d3,(a3)
                bra.s   SKButton_CullAndDrawNormalTopOnlyButton
; ---------------------------------------------------------------------------

; Play the press sound only when the entire trigger byte is zero
SKButton_TryTopOnlyPressSound:
                tst.b   (a3)
                bne.s   SKButton_SetTopOnlyTriggerAndFrame
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

SKButton_SetTopOnlyTriggerAndFrame:
                bset    d3,(a3)
                move.b  #1,mapping_frame(a0)

SKButton_CullAndDrawNormalTopOnlyButton:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKButton_InitializeCompetitionButton:
                move.l  #Map_2PButton,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PArt_1,0,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.b  #$C,width_pixels(a0)
                move.w  #$200,priority(a0)
                addq.w  #4,y_pos(a0)
                move.l  #SKButton_UpdateCompetitionButton,(a0)

SKButton_UpdateCompetitionButton:
                move.w  #$13,d1
                move.w  #4,d2
                move.w  #5,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.b  #0,mapping_frame(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                moveq   #0,d3
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   SKButton_TryCompPressSound
                btst    #4,subtype(a0)
                bne.s   SKButton_DrawCompetitionButton
                bclr    d3,(a3)
                bra.s   SKButton_DrawCompetitionButton
; ---------------------------------------------------------------------------

; Play the press sound only when the entire trigger byte is zero
SKButton_TryCompPressSound:
                tst.b   (a3)
                bne.s   SKButton_SetCompTriggerAndFrame
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

SKButton_SetCompTriggerAndFrame:
                bset    d3,(a3)
                move.b  #1,mapping_frame(a0)

SKButton_DrawCompetitionButton:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_Button:
                include "src/objects/shared/buttons/mappings/button.s"
Map_LRZButton:
                include "src/objects/shared/zones/lrz/mappings/button.s"
; End of function Obj_Button
