; Owner: game/special_stage/sk
; Responsibility: Stage icons, moving instruction cues and the primary character state machine with player frame-loading support
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SStage_8DF8:
                move.b  #$80,width_pixels(a0)
                move.b  #$80,height_pixels(a0)
                move.w  #0,priority(a0)
                move.l  #Map_SSIcons,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_Icons,2,1),art_tile(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$94,y_pos(a0)
                move.l  #loc_8E2A,(a0)

loc_8E2A:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_SSIcons:
                include "src/game/special_stage/shared/mappings/icons.s"
; ---------------------------------------------------------------------------

Obj_SStage_8E40:
                jsr     (AllocateObjectAfterCurrent_SpecialStage).l
                bne.w   loc_8E5C
                move.l  #loc_8E5C,(a1)
                bset    #0,status(a1)
                move.b  #1,mapping_frame(a1)

loc_8E5C:
                move.b  #$80,width_pixels(a0)
                move.b  #$80,height_pixels(a0)
                move.w  #0,priority(a0)
                move.l  #Map_GetBlueSpheres,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_GetBlueSpheres,1,1),art_tile(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$E8,y_pos(a0)
                move.w  #3*60,$32(a0)
                move.l  #loc_8E94,(a0)

loc_8E94:
                tst.w   $32(a0)
                beq.s   loc_8EA4
                subq.w  #1,$32(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8EA4:
                cmpi.w  #$C0,$30(a0)
                blo.s   loc_8ECA
                move.l  #loc_8EEC,(a0)
                addq.b  #2,mapping_frame(a0)
                tst.w   (Special_stage_velocity).w
                bne.s   loc_8ED0
                move.b  #1,(Special_stage_advancing).w
                move.b  #1,(Special_stage_started).w
                bra.s   loc_8ED0
; ---------------------------------------------------------------------------

loc_8ECA:
                addi.w  #$10,$30(a0)

loc_8ED0:
                move.w  $30(a0),d0
                btst    #0,status(a0)
                bne.s   loc_8EDE
                neg.w   d0

loc_8EDE:
                addi.w  #$120,d0
                move.w  d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8EEC:
                tst.w   (Special_stage_rings_left).w
                beq.s   loc_8EF4
                rts
; ---------------------------------------------------------------------------

loc_8EF4:
                subi.w  #$10,$30(a0)
                bne.s   loc_8F08
                move.l  #loc_8F24,(a0)
                move.w  #180,$32(a0)

loc_8F08:
                move.w  $30(a0),d0
                btst    #0,status(a0)
                bne.s   loc_8F16
                neg.w   d0

loc_8F16:
                addi.w  #$120,d0
                move.w  d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8F24:
                tst.w   $32(a0)
                beq.s   loc_8F34
                subq.w  #1,$32(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8F34:
                cmpi.w  #$C0,$30(a0)
                bhs.s   loc_8F42
                addi.w  #$10,$30(a0)

loc_8F42:
                move.w  $30(a0),d0
                btst    #0,status(a0)
                bne.s   loc_8F50
                neg.w   d0

loc_8F50:
                addi.w  #$120,d0
                move.w  d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_GetBlueSpheres:
                include "src/game/special_stage/shared/mappings/get_blue_spheres.s"
; ---------------------------------------------------------------------------

Obj_SStage_8FAA:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$200,priority(a0)
                move.l  #Map_SStageSonic,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_Player1,0,1),art_tile(a0)
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_8FFA
                move.l  #Map_SStageTails,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_Player2,1,1),art_tile(a0)
                jsr     (AllocateObjectAfterCurrent_SpecialStage).l
                bne.w   loc_8FFA
                move.l  #Obj_SStage_9444,(a1)
                move.w  a0,$3E(a1)

loc_8FFA:
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_9010
                move.l  #Map_SStageKnuckles,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_Player1,0,1),art_tile(a0)

loc_9010:
                move.w  #$A0,$30(a0)
                move.w  #$70,$32(a0)
                move.w  #0,$34(a0)
                move.w  #$F800,$36(a0)
                move.w  #0,$38(a0)
                bsr.w   SStage_UpdateProjectionScalars
                move.b  #$FF,$3A(a0)
                move.l  #loc_903E,(a0)

loc_903E:
                tst.w   (Special_stage_rate_timer).w
                beq.s   loc_907E
                subq.w  #1,(Special_stage_rate_timer).w
                bne.s   loc_907E
                move.w  #30*60,(Special_stage_rate_timer).w
                tst.b   (Blue_spheres_stage_flag).w
                beq.s   loc_905C
                move.w  #45*60,(Special_stage_rate_timer).w

loc_905C:
                cmpi.w  #$2000,(Special_stage_rate).w
                beq.s   loc_907E
                addi.w  #$400,(Special_stage_rate).w
                move.b  (Special_stage_rate).w,d0
                subi.b  #$20,d0
                neg.b   d0
                add.b   d0,d0
                addq.b  #8,d0
                jsr     (Change_Music_Tempo).l

loc_907E:
                bsr.w   SStage_UpdatePlayerGridMotion
                moveq   #$C,d0
                move.w  (Special_stage_velocity).w,d1
                beq.s   loc_90A8
                asr.w   #5,d1
                add.w   d1,anim_frame_timer(a0)
                moveq   #0,d0
                move.b  anim_frame_timer(a0),d0
                bpl.s   loc_909E
                addi.b  #$C,d0
                bra.s   loc_90A8
; ---------------------------------------------------------------------------

loc_909E:
                cmpi.b  #$C,d0
                blo.s   loc_90A8
                subi.b  #$C,d0

loc_90A8:
                move.b  d0,anim_frame_timer(a0)
                lea     (byte_91E8).l,a1
                tst.b   (Special_stage_jumping).w
                bpl.s   loc_90CC
                lea     (byte_91F6).l,a1
                move.w  (Special_stage_velocity).w,d1
                bne.s   loc_90CC
                move.b  (Level_frame_counter+1).w,d0
                andi.w  #3,d0

loc_90CC:
                move.b  (a1,d0.w),mapping_frame(a0)
                tst.b   (Special_stage_clear_routine).w
                bne.s   loc_90EE
                move.w  (Ctrl_1).w,d0
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   loc_90EE
                tst.b   (Special_stage_jumping).w
                bmi.s   loc_90EE
                move.b  #1,(Special_stage_jumping).w

loc_90EE:
                move.b  (Special_stage_angle).w,d0
                andi.b  #$3F,d0
                bne.w   loc_9152
                cmpi.b  #1,(Special_stage_jumping).w
                bne.s   loc_911E
                move.l  #-$100000,$40(a0)
                move.b  #$80,(Special_stage_jumping).w
                move.b  #0,(Special_stage_turning).w
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l

loc_911E:
                tst.b   (Special_stage_jumping).w
                bpl.s   loc_9152
                move.l  $3C(a0),d0
                add.l   $40(a0),d0
                bmi.s   loc_9138
                moveq   #0,d0
                move.l  d0,$40(a0)
                move.b  d0,(Special_stage_jumping).w

loc_9138:
                move.w  (Special_stage_rate).w,d1
                ext.l   d1
                lsl.l   #4,d1
                add.l   d1,$40(a0)
                move.l  d0,$3C(a0)
                swap    d0
                addi.w  #-$800,d0
                move.w  d0,$36(a0)

loc_9152:
                bsr.w   SStage_UpdateProjectionScalars
                bsr.w   SStage_ProjectCharacterCoordinates
                jsr     (Draw_Sprite).l
                lea     (PLC_SStageSonic).l,a2
                move.l  #ArtUnc_SStageSonic,d6
                move.w  #tiles_to_bytes(ArtTile_SStage_Player1),d4
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_918A
                lea     (PLC_SStageTails).l,a2
                move.l  #ArtUnc_SStageTails,d6
                move.w  #tiles_to_bytes(ArtTile_SStage_Player2),d4
                bra.s   SStage_PLCLoad_91A2
; ---------------------------------------------------------------------------

loc_918A:
                cmpi.w  #3,(Player_mode).w
                bne.s   SStage_PLCLoad_91A2
                lea     (PLC_SStageKnuckles).l,a2
                move.l  #ArtUnc_SStageKnuckles,d6
                move.w  #tiles_to_bytes(ArtTile_SStage_Player1),d4

SStage_PLCLoad_91A2:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   $3A(a0),d0
                beq.s   locret_91E6
                move.b  d0,$3A(a0)
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   locret_91E6

loc_91BE:
                moveq   #0,d1
                move.w  (a2)+,d1
                move.w  d1,d3
                lsr.w   #8,d3
                andi.w  #$F0,d3
                addi.w  #$10,d3
                andi.w  #$FFF,d1
                lsl.l   #5,d1
                add.l   d6,d1
                move.w  d4,d2
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                dbf     d5,loc_91BE

locret_91E6:
                rts
; ---------------------------------------------------------------------------
byte_91E8:
                dc.b    2,   6,   7,   8,   7,   6,   2,   3,   4,   5,   4,   3,   1,   0
byte_91F6:
                dc.b    9,  $B,  $A,  $B,   9,  $B,  $A,  $B,   9,  $B,  $A,  $B,  $B,   0
byte_9204:
                dc.b    9,  $A,  $B,   9,  $A,  $B,   9,  $A,  $B,   9,  $A,  $B,  $B,   0
                even
; ---------------------------------------------------------------------------
