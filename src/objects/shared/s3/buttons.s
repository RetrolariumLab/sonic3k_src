; Owner: objects/shared/s3
; Responsibility: Shared button collision, trigger state and zone or competition mapping variants
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_Button:
                tst.w   (Competition_mode).w
                bne.w   S3Button_InitializeCompetitionButton
                move.l  #Map_Button,mappings(a0)
                move.w  #make_art_tile(ArtTile_GrayButton,0,0),art_tile(a0)
                cmpi.b  #1,(Current_zone).w
                bne.s   S3Button_SelectCNZMappingOverride
                move.l  #Map_HCZButton,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZButton,1,0),art_tile(a0)

S3Button_SelectCNZMappingOverride:
                cmpi.b  #3,(Current_zone).w
                bne.s   S3Button_InitNormalGeometry
                move.l  #Map_CNZButton,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc+$C9,2,0),art_tile(a0)

S3Button_InitNormalGeometry:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$200,priority(a0)
                addq.w  #4,y_pos(a0)
                btst    #5,subtype(a0)
                beq.s   S3Button_InstallNormalFullSolidHandler
                move.l  #S3Button_UpdateNormalTopOnlyButton,(a0)
                bra.w   S3Button_UpdateNormalTopOnlyButton
; ---------------------------------------------------------------------------

S3Button_InstallNormalFullSolidHandler:
                move.l  #S3Button_UpdateNormalFullSolidButton,(a0)

S3Button_UpdateNormalFullSolidButton:
                tst.b   render_flags(a0)
                bpl.s   S3Button_DrawFullSolidIfVisible
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
                beq.s   S3Button_UpdateFullSolidPress
                moveq   #7,d3

S3Button_UpdateFullSolidPress:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   S3Button_TryFullSolidPressSound
                btst    #4,subtype(a0)
                bne.s   S3Button_DrawFullSolidIfVisible
                bclr    d3,(a3)
                bra.s   S3Button_DrawFullSolidIfVisible
; ---------------------------------------------------------------------------

; Play the press sound only when the entire trigger byte is zero
S3Button_TryFullSolidPressSound:
                tst.b   (a3)
                bne.s   S3Button_SetFullSolidTriggerAndFrame
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

S3Button_SetFullSolidTriggerAndFrame:
                bset    d3,(a3)
                move.b  #1,mapping_frame(a0)

S3Button_DrawFullSolidIfVisible:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

S3Button_UpdateNormalTopOnlyButton:
                tst.b   render_flags(a0)
                bpl.s   S3Button_CullAndDrawNormalTopOnlyButton
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
                beq.s   S3Button_UpdateTopOnlyPress
                moveq   #7,d3

S3Button_UpdateTopOnlyPress:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   S3Button_TryTopOnlyPressSound
                btst    #4,subtype(a0)
                bne.s   S3Button_CullAndDrawNormalTopOnlyButton
                bclr    d3,(a3)
                bra.s   S3Button_CullAndDrawNormalTopOnlyButton
; ---------------------------------------------------------------------------

; Play the press sound only when the entire trigger byte is zero
S3Button_TryTopOnlyPressSound:
                tst.b   (a3)
                bne.s   S3Button_SetTopOnlyTriggerAndFrame
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

S3Button_SetTopOnlyTriggerAndFrame:
                bset    d3,(a3)
                move.b  #1,mapping_frame(a0)

S3Button_CullAndDrawNormalTopOnlyButton:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

S3Button_InitializeCompetitionButton:
                move.l  #Map_2PButton,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PArt_1,0,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.b  #$C,width_pixels(a0)
                move.w  #$200,priority(a0)
                addq.w  #4,y_pos(a0)
                move.l  #S3Button_UpdateCompetitionButton,(a0)

S3Button_UpdateCompetitionButton:
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
                bne.s   S3Button_TryCompPressSound
                btst    #4,subtype(a0)
                bne.s   S3Button_DrawCompetitionButton
                bclr    d3,(a3)
                bra.s   S3Button_DrawCompetitionButton
; ---------------------------------------------------------------------------

; Play the press sound only when the entire trigger byte is zero
S3Button_TryCompPressSound:
                tst.b   (a3)
                bne.s   S3Button_SetCompTriggerAndFrame
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

S3Button_SetCompTriggerAndFrame:
                bset    d3,(a3)
                move.b  #1,mapping_frame(a0)

S3Button_DrawCompetitionButton:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_Button:
                include "src/objects/shared/buttons/mappings/button.s"
; Map_Button2:
Map_HCZButton:
                include "src/objects/shared/zones/hcz/mappings/button.s"
Map_CNZButton:
                include "src/objects/shared/zones/cnz/mappings/button.s"
Map_2PButton:
                include "src/game/competition/shared/mappings/competition_button.s"
; End of function Obj_Button
