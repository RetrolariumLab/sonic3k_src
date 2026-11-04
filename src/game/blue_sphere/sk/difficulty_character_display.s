; Owner: game/blue_sphere/sk
; Responsibility: Blue Sphere difficulty character selection, Sonic or Tails and Knuckles display actors and emerald resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Difficulty_Level_Sprites_Display:
                jsr     (AllocateObject).l
                bne.w   BSDifficulty_ActorAllocationReturn
                moveq   #0,d1
                move.b  (Blue_spheres_difficulty).w,d1
                subq.b  #1,d1
                lsl.w   #2,d1
                move.l  Difficulty_Sprites(pc,d1.w),(a1)

BSDifficulty_ActorAllocationReturn:
                rts
; End of function Difficulty_Level_Sprites_Display

; ---------------------------------------------------------------------------
Difficulty_Sprites:
                dc.l    Obj_Difficulty_Sonic
                dc.l    Obj_Difficulty_Tails
                dc.l    Obj_Difficulty_Knuckles
                dc.l    Obj_Difficulty_Eggman
                dc.l    Obj_Difficulty_MechaSonic
                dc.l    Obj_Difficulty_Ship
                dc.l    Obj_Difficulty_SpawnChickens
                dc.l    Obj_Difficulty_SpawnSquirrels
                dc.l    Obj_Difficulty_SpawnRabbits
                dc.l    Obj_Difficulty_MasterEmerald
                dc.l    Obj_Difficulty_SKLogo
                dc.l    Obj_Difficulty_SuperSonic
; ---------------------------------------------------------------------------

BSDifficulty_InitResultsNumberSprite:
                bsr.w   BlueSphere_InitNumericSprite
                move.l  #BSDifficulty_UpdateNumberVisibility,(a0)

BSDifficulty_UpdateNumberVisibility:
                cmpi.b  #12,(Blue_spheres_difficulty).w
                bne.s   BSDifficulty_DrawResultsNumber
                rts
; ---------------------------------------------------------------------------

BSDifficulty_DrawResultsNumber:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_Difficulty_Sonic:
                move.l  #Map_Sonic,mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_1,0,1),art_tile(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$120,y_pos(a0)
                bset    #0,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #$13,anim(a0)
                move.l  #BSDifficulty_CheckSuperSonicTransition,(a0)

BSDifficulty_CheckSuperSonicTransition:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   BSDifficulty_TickSuperPoseDelay
                move.l  #Map_SuperSonic,mappings(a0)
                move.b  #$1F,anim(a0)
                move.l  #BSDifficulty_TickSuperPoseDelay,(a0)
                move.w  #$14,$30(a0)

BSDifficulty_TickSuperPoseDelay:
                tst.b   (Super_palette_status).w
                bpl.s   BlueSphereDifficulty_AnimateAndDrawSonic
                subq.w  #1,$30(a0)
                bpl.s   BlueSphereDifficulty_AnimateAndDrawSonic
                move.b  #5,anim(a0)
                move.l  #BlueSphereDifficulty_AnimateAndDrawSonic,(a0)

BlueSphereDifficulty_AnimateAndDrawSonic:
                jsr     (Animate_Sonic).l
                jsr     (Sonic_Load_PLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_Difficulty_SuperSonic:
                move.b  #1,(Super_palette_status).w
                move.b  #$F,(Palette_timer).w
                move.b  #1,(Super_Sonic_Knux_flag).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_Difficulty_Tails:
                move.l  #Map_BSTailsPose,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Tails,1,1),art_tile(a0)
                move.w  #$FC,x_pos(a0)
                move.w  #$11B,y_pos(a0)
                bset    #0,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.l  #BlueSphereDifficulty_DrawStaticTailsPose,(a0)

BlueSphereDifficulty_DrawStaticTailsPose:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_BSTailsPose:
                include "src/game/blue_sphere/shared/mappings/tails_pose.s"
; ---------------------------------------------------------------------------

Obj_Difficulty_Knuckles:
                move.l  #Map_Knuckles,mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_2,1,1),art_tile(a0)
                move.w  #$138,x_pos(a0)
                move.w  #$118,y_pos(a0)
                move.w  #$80,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #$24,anim(a0)
                move.l  #BSDifficulty_UpdateKnucklesDisplay,(a0)

BSDifficulty_UpdateKnucklesDisplay:
                jsr     (Animate_Knuckles).l
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   $30(a0),d0
                beq.s   BlueSphereDifficulty_DrawKnucklesDisplay
                move.b  d0,$30(a0)
                move.w  #tiles_to_bytes(ArtTile_Player_2),d4
                jsr     (KnucklesQueueFramePatternsAtVRAMBase).l

BlueSphereDifficulty_DrawKnucklesDisplay:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_BSResultsEmerald:
                include "src/game/blue_sphere/shared/mappings/results_emerald.s"
; End of function Obj_Difficulty_Knuckles
