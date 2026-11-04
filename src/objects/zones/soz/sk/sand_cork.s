; Owner: objects/zones/soz/sk
; Responsibility: Sand cork player contact, fracture, movement and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZSandCork:
                move.l  #Map_SOZSandCork,mappings(a0)
                move.w  #make_art_tile(ArtTile_SOZ2Extra+$E,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  #$C6,collision_flags(a0)
                move.w  respawn_addr(a0),d0
                beq.s   SKSOZSandCork_InitIntactContact
                movea.w d0,a2
                btst    #0,(a2)
                beq.s   SKSOZSandCork_InitIntactContact
                move.b  subtype(a0),d5
                andi.w  #$7F,d5
                lsl.w   #4,d5
                moveq   #0,d4
                move.w  y_pos(a0),d3
                add.w   d5,d3
                subi.w  #$90,d3

; The reload loop stops at zero remaining height. The live break loop includes that section
SKSOZSandCork_RestoreColumnSections:
                bsr.w   CreateSozSandColumnSection
                subi.w  #$100,d3
                subi.w  #$100,d5
                bhi.s   SKSOZSandCork_RestoreColumnSections
                move.w  respawn_addr(a0),respawn_addr(a1)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSOZSandCork_InitIntactContact:
                move.l  #SKSOZSandCork_ConsumeP1Contact,(a0)

SKSOZSandCork_ConsumeP1Contact:
                move.b  collision_property(a0),d0
                beq.w   SKSOZSandCork_TouchCullAndDraw
                lea     (Player_1).w,a1
                bclr    #0,collision_property(a0)
                beq.s   SKSOZSandCork_ConsumeP2Contact
                bsr.s   BreakSozSandCorkFromRollingContact

SKSOZSandCork_ConsumeP2Contact:
                lea     (Player_2).w,a1
                bclr    #1,collision_property(a0)
                beq.s   SKSOZSandCork_TouchCullAndDraw
                bsr.s   BreakSozSandCorkFromRollingContact

SKSOZSandCork_TouchCullAndDraw:
                jmp     (Sprite_CheckDeleteTouch3).l

; =============== S U B R O U T I N E =======================================

BreakSozSandCorkFromRollingContact:
                cmpi.b  #2,anim(a1)
                bne.w   SKSOZSandCork_BreakReturn
                neg.w   x_vel(a1)
                neg.w   y_vel(a1)
                move.b  subtype(a0),d4
                andi.w  #$7F,d4
                lsl.w   #4,d4
                move.w  d4,d5
                move.w  y_pos(a0),d3
                subi.w  #$90,d3

SKSOZSandCork_SpawnFallingColumnSections:
                bsr.w   CreateSozSandColumnSection
                subi.w  #$100,d3
                subi.w  #$100,d5
                bcc.s   SKSOZSandCork_SpawnFallingColumnSections
                move.w  respawn_addr(a0),respawn_addr(a1)
                lea     (SKSOZSandCork_FragmentVelocities).l,a4
                move.l  #SKSOZSandCork_MoveAndCullFragment,(a0)
                addq.b  #1,mapping_frame(a0)
                move.w  #0,priority(a0)
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                jsr     (BreakObjectToPieces2).l
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                move.w  respawn_addr(a0),d0
                beq.s   SKSOZSandCork_SignalForegroundBySubtype
                movea.w d0,a2
                bset    #0,(a2)

SKSOZSandCork_SignalForegroundBySubtype:
                tst.b   subtype(a0)
                bpl.s   SKSOZSandCork_SignalForegroundEvent5
                move.w  #-1,(Events_fg_4).w
                bra.s   SKSOZSandCork_ClearCollisionAndContacts
; ---------------------------------------------------------------------------

SKSOZSandCork_SignalForegroundEvent5:
                move.w  #-1,(Events_fg_5).w

SKSOZSandCork_ClearCollisionAndContacts:
                move.b  #0,collision_flags(a0)
                move.b  #0,collision_property(a0)

SKSOZSandCork_BreakReturn:
                rts
; End of function BreakSozSandCorkFromRollingContact

; ---------------------------------------------------------------------------

SKSOZSandCork_MoveAndCullFragment:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                cmpi.w  #$400,y_vel(a0)
                blt.s   SKSOZSandCork_DrawFragment
                tst.b   render_flags(a0)
                bpl.s   SKSOZSandCork_DeleteFragment

SKSOZSandCork_DrawFragment:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSOZSandCork_DeleteFragment:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

CreateSozSandColumnSection:
                jsr     (AllocateObject).l
                bne.w   SKSOZSandCork_ColumnAllocReturn
                move.l  #SKSOZSandCork_LowerColumn,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  d3,y_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.w  #$80,priority(a1)
                move.b  #$C,width_pixels(a1)
                move.b  #$80,height_pixels(a1)
                move.w  d4,$30(a1)
                move.b  #2,mapping_frame(a1)
                move.b  subtype(a0),subtype(a1)

SKSOZSandCork_ColumnAllocReturn:
                rts
; End of function CreateSozSandColumnSection

; ---------------------------------------------------------------------------

SKSOZSandCork_LowerColumn:
                tst.w   $30(a0)
                beq.s   SKSOZSandCork_TryPlayColumnSlideSound
                addq.w  #4,y_pos(a0)
                subq.w  #4,$30(a0)

; The sound timer reads the frame-counter address indexed by A0
SKSOZSandCork_TryPlayColumnSlideSound:
; Bug: Level_frame_counter should not be using a0, as a0 is the object's RAM!
                move.b  Level_frame_counter+1(a0),d0
                andi.b  #$F,d0
                bne.s   SKSOZSandCork_DrawColumnSection
                tst.b   render_flags(a0)
                bpl.s   SKSOZSandCork_DrawColumnSection
                moveq   #signextendB(sfx_SlideSkidQuiet),d0
                jsr     (Play_SFX).l

SKSOZSandCork_DrawColumnSection:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
SKSOZSandCork_FragmentVelocities:
                dc.w    -$200, -$200
                dc.w    $80, -$200
                dc.w    $200, -$200
                dc.w    -$1E0, -$1E0
                dc.w    $60, -$1E0
                dc.w    $1E0, -$1E0
Map_SOZSandCork:
                include "src/objects/shared/zones/soz/mappings/sand_cork.s"
