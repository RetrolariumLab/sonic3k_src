; Owner: objects/zones/lrz/sk
; Responsibility: Horizontal button contact, pushing and trigger response
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZButtonHorizontal:
                move.l  #Map_LRZButtonHorizontal,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZMisc,3,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                tst.b   (Current_act).w
                beq.s   SKLRZHorizButton_InitUpdate
                move.l  #Map_LRZButtonHorizontal2,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZ2Misc,1,0),art_tile(a0)

SKLRZHorizButton_InitUpdate:
                move.l  #SKLRZHorizButton_CheckSolidAndBindFlag,(a0)

SKLRZHorizButton_CheckSolidAndBindFlag:
                move.w  #$10,d1
                move.w  #$F,d2
                move.w  #$10,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.b  #0,mapping_frame(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                moveq   #0,d3
                btst    #6,subtype(a0)
                beq.s   SKLRZHorizButton_CheckSideContact
                moveq   #7,d3

SKLRZHorizButton_CheckSideContact:
                swap    d6
                andi.w  #3,d6
                bne.s   SKLRZHorizButton_TryPlaySwitchSound
                btst    #4,subtype(a0)
                bne.s   SKLRZHorizButton_DrawButton
                bclr    d3,(a3)
                bra.s   SKLRZHorizButton_DrawButton
; ---------------------------------------------------------------------------

; Play the sound only if the entire trigger byte was clear
SKLRZHorizButton_TryPlaySwitchSound:
                tst.b   (a3)
                bne.s   SKLRZHorizButton_SetTriggerAndFrame
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

SKLRZHorizButton_SetTriggerAndFrame:
                bset    d3,(a3)
                move.b  #1,mapping_frame(a0)

SKLRZHorizButton_DrawButton:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_LRZButtonHorizontal:
                include "src/objects/shared/zones/lrz/mappings/button_horizontal.s"
; End of function Obj_LRZButtonHorizontal
