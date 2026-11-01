; Owner: game/level/zones/ssz/sk
; Responsibility: Sky Sanctuary camera transition, character motion, collapsing bridge actors and next-level handoff
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_57E96:
                cmpi.b  #4,routine(a0)
                bhi.s   loc_57EB0
                move.w  (Level_frame_counter).w,d0
                andi.w  #$F,d0
                bne.s   loc_57EB0
                moveq   #signextendB(sfx_BigRumble),d0
                jsr     (Play_SFX).l

loc_57EB0:
                moveq   #0,d0
                move.b  routine(a0),d0
                jmp     loc_57EBA(pc,d0.w)
; ---------------------------------------------------------------------------

loc_57EBA:
                bra.w   loc_57ECA
; ---------------------------------------------------------------------------
                bra.w   loc_57EDC
; ---------------------------------------------------------------------------
                bra.w   loc_57F18
; ---------------------------------------------------------------------------
                bra.w   loc_57F3E
; ---------------------------------------------------------------------------

loc_57ECA:
                subq.w  #1,$2E(a0)
                bne.w   locret_57FBE
                move.w  #4,$30(a0)
                addq.b  #4,routine(a0)

loc_57EDC:
                jsr     StepSsz1EscapeCameraDownward(pc)
                cmpi.w  #$600,(Camera_Y_pos).w
                blo.w   locret_57FBE
                jsr     DriveSsz1EscapeJumpInputsForPlayers(pc)
                cmpi.w  #$60C,(Camera_Y_pos).w
                blo.w   locret_57FBE
                lea     (HScroll_table+$E0).w,a1
                lea     word_577C6(pc),a5
                moveq   #($A/2)-1,d0

loc_57F02:
                move.l  (a5)+,(a1)+
                dbf     d0,loc_57F02
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                addq.b  #4,routine(a0)
                bra.w   locret_57FBE
; ---------------------------------------------------------------------------

loc_57F18:
                jsr     StepSsz1EscapeCameraDownward(pc)
                jsr     DriveSsz1EscapeJumpInputsForPlayers(pc)
                cmpi.w  #$640,(Camera_Y_pos).w
                blo.w   locret_57FBE
                move.w  #$10-1,$2E(a0)
                move.w  #8,$30(a0)
                clr.w   $32(a0)
                addq.b  #4,routine(a0)

loc_57F3E:
                tst.w   (Events_fg_4).w
                bpl.s   locret_57FBE
                tst.w   $2E(a0)
                beq.s   loc_57F5E
                subq.w  #1,$2E(a0)
                bne.s   locret_57FBE
                jsr     (AllocateObject).l
                bne.s   loc_57F5E
                move.l  #Obj_583BE,(a1)

loc_57F5E:
                cmpi.w  #$5C0,(Camera_Y_pos).w
                bhs.s   loc_57F7E
                jsr     UpdateSsz1EscapeSpiralForPlayers(pc)
                move.w  (Level_frame_counter).w,d0
                addq.w  #8,d0
                andi.w  #$F,d0
                bne.s   loc_57F7E
                moveq   #signextendB(sfx_DeathEggRiseLoud),d0
                jsr     (Play_SFX).l

loc_57F7E:
                move.w  #$500,d0
                moveq   #0,d1
                move.b  $30(a0),d1
                subq.w  #1,d1
                bcs.s   loc_57F94

loc_57F8C:
                subi.w  #$70,d0
                dbf     d1,loc_57F8C

loc_57F94:
                moveq   #0,d1
                move.b  $31(a0),d1
                sub.w   d1,d0
                move.w  (Camera_Y_pos).w,d1
                sub.w   d0,d1
                bcs.s   locret_57FBE
                cmpi.w  #2,d1
                bls.s   loc_57FAC
                moveq   #2,d1

loc_57FAC:
                sub.w   d1,(Camera_Y_pos).w
                cmpi.w  #$110,(Camera_Y_pos).w
                bhs.s   locret_57FBE
                move.w  #$110,(Camera_Y_pos).w

locret_57FBE:
                rts

; =============== S U B R O U T I N E =======================================

StepSsz1EscapeCameraDownward:
                cmpi.w  #$618,(Camera_Y_pos).w
                blo.s   loc_57FD2
                btst    #0,(Level_frame_counter+1).w
                beq.s   locret_57FE0
                bra.s   loc_57FDC
; ---------------------------------------------------------------------------

loc_57FD2:
                move.w  (Level_frame_counter).w,d0
                andi.w  #3,d0
                beq.s   locret_57FE0

loc_57FDC:
                addq.w  #1,(Camera_Y_pos).w

locret_57FE0:
                rts
; End of function StepSsz1EscapeCameraDownward

; =============== S U B R O U T I N E =======================================

DriveSsz1EscapeJumpInputsForPlayers:
                lea     (Player_1).w,a1
                lea     (Ctrl_1_logical).w,a2
                lea     $30(a0),a3
                bsr.s   DriveSsz1EscapeJumpInputAndHidePlayer
                tst.w   (Player_mode).w
                bne.s   locret_58046
                lea     (Player_2).w,a1
                lea     (Ctrl_2_logical).w,a2
                lea     $31(a0),a3
; End of function DriveSsz1EscapeJumpInputsForPlayers

; =============== S U B R O U T I N E =======================================

DriveSsz1EscapeJumpInputAndHidePlayer:
                tst.b   object_control(a1)
                bne.s   locret_58046
                tst.b   (a3)
                bmi.s   loc_58016
                subq.b  #1,(a3)
                bpl.s   locret_58046
                move.w  #(button_C_mask<<8)|button_C_mask,(a2)
                rts
; ---------------------------------------------------------------------------

loc_58016:
                tst.w   y_vel(a1)
                bmi.s   loc_58034
                move.w  #$7FFF,y_pos(a1)
                andi.b  #$FC,render_flags(a1)
                move.b  #3,object_control(a1)
                clr.b   anim(a1)
                bra.s   locret_58046
; ---------------------------------------------------------------------------

loc_58034:
                move.w  #$2800,d0
                cmpi.w  #$1A40,x_pos(a1)
                blo.s   loc_58044
                move.w  #$2400,d0

loc_58044:
                move.w  d0,(a2)

locret_58046:
                rts
; End of function DriveSsz1EscapeJumpInputAndHidePlayer

; =============== S U B R O U T I N E =======================================

UpdateSsz1EscapeSpiralForPlayers:
                lea     (Player_1).w,a1
                lea     $30(a0),a2
                moveq   #0,d3
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_5805C
                moveq   #-1,d3

loc_5805C:
                bsr.s   UpdateSsz1EscapeSpiralClimbAndLaunch
                tst.w   (Player_mode).w
                bne.s   locret_58046
                lea     (Player_2).w,a1
                lea     $32(a0),a2
                moveq   #-1,d3
; End of function UpdateSsz1EscapeSpiralForPlayers

; =============== S U B R O U T I N E =======================================

UpdateSsz1EscapeSpiralClimbAndLaunch:
                tst.w   4(a2)
                bne.w   loc_58192
                cmpi.w  #$910,(a2)
                bne.s   loc_580CC
                st      4(a2)
                move.b  #1,object_control(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                move.w  #$800,ground_vel(a1)
                move.w  #$400,x_vel(a1)
                move.w  #-$680,y_vel(a1)
                clr.w   2+x_pos(a1)
                clr.w   2+y_pos(a1)
                moveq   #signextendB(sfx_Jump),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

loc_580CC:
                moveq   #0,d0
                move.b  1(a2),d0
                addq.b  #1,d0
                cmpi.b  #$70,d0
                blo.s   loc_580E0
                subi.b  #$70,d0
                addq.b  #1,(a2)

loc_580E0:
                move.b  d0,1(a2)
                lea     byte_587B4(pc),a6
                move.b  (a6,d0.w),d0
                move.w  d0,d2
                andi.w  #drawing_mask,art_tile(a1)
                addi.b  #$40,d2
                bmi.s   loc_58100
                ori.w   #high_priority,art_tile(a1)

loc_58100:
                jsr     (GetSineCosine).l
                muls.w  #$4C00,d0
                swap    d0
                move.w  #$1A40,x_pos(a1)
                add.w   d0,x_pos(a1)
                muls.w  #$1C00,d1
                swap    d1
                subi.b  #$40,d2
                bpl.s   loc_58128
                neg.w   d1
                subi.w  #$38,d1

loc_58128:
                move.w  #$570,y_pos(a1)
                add.w   d1,y_pos(a1)
                lea     byte_58824(pc),a6
                moveq   #0,d0
                move.b  1(a2),d0
                move.b  (a6,d0.w),d0
                ext.w   d0
                sub.w   d0,y_pos(a1)
                moveq   #0,d0
                move.b  (a2),d0
                subq.w  #1,d0
                bcs.s   loc_58158

loc_5814E:
                subi.w  #$70,y_pos(a1)
                dbf     d0,loc_5814E

loc_58158:
                tst.w   d3
                beq.s   loc_58170
                addq.w  #4,y_pos(a1)
                move.w  #$100,priority(a1)
                tst.b   d2
                bmi.s   loc_58170
                move.w  #$80,priority(a1)

loc_58170:
                addi.w  #$A,d2
                andi.w  #$FF,d2
                move.w  d2,d0
                add.w   d2,d2
                add.w   d0,d2
                lsr.w   #6,d2
                lea     byte_587A8(pc),a2
                move.b  (a2,d2.w),d0
                move.b  d0,mapping_frame(a1)
                jmp     (Perform_Player_DPLC).l
; ---------------------------------------------------------------------------

loc_58192:
                tst.w   4(a2)
                bpl.s   loc_581D2
                move.w  x_vel(a1),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,x_pos(a1)
                move.w  y_vel(a1),d0
                addi.w  #$38,y_vel(a1)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a1)
                tst.w   y_vel(a1)
                bmi.s   locret_581F0
                move.b  #3,object_control(a1)
                clr.b   mapping_frame(a1)
                clr.b   anim(a1)
                move.w  #3*60,4(a2)
                bra.s   locret_581F0
; ---------------------------------------------------------------------------

loc_581D2:
                cmpa.w  #Player_1,a1
                bne.s   locret_581F0
                subq.w  #1,4(a2)
                bne.s   locret_581F0
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #$B00,d0
                jmp     (StartNewLevel).l
; ---------------------------------------------------------------------------

locret_581F0:
                rts
; End of function UpdateSsz1EscapeSpiralClimbAndLaunch

; ---------------------------------------------------------------------------

loc_581F2:
                move.l  #loc_5821E,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$1C,height_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZSpiralRamp,2,1),art_tile(a0)
                move.l  #Map_SSZCollapsingBridge,mappings(a0)
                move.b  #9,mapping_frame(a0)

loc_5821E:
                move.w  y_pos(a0),d0
                subi.w  #$24,d0
                cmp.w   (Player_1+y_pos).w,d0
                bhs.w   loc_583A0
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_58234:
                move.l  #loc_58260,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$18,height_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$20,2,1),art_tile(a0)
                move.l  #Map_SSZCollapsingBridge,mappings(a0)
                move.b  #6,mapping_frame(a0)

loc_58260:
                move.w  y_pos(a0),d0
                move.b  mapping_frame(a0),d1
                subq.b  #6,d1
                beq.s   loc_58288
                subq.b  #1,d1
                beq.s   loc_5827E
                subi.w  #$2C,d0
                cmp.w   (Player_1+y_pos).w,d0
                blo.s   loc_582A6
                bra.w   loc_583A0
; ---------------------------------------------------------------------------

loc_5827E:
                moveq   #-$20,d1
                moveq   #8,d2
                subi.w  #$24,d0
                bra.s   loc_58290
; ---------------------------------------------------------------------------

loc_58288:
                moveq   #-$40,d1
                moveq   #$10,d2
                subi.w  #$1C,d0

loc_58290:
                cmp.w   (Player_1+y_pos).w,d0
                blo.s   loc_582A6
                addq.b  #1,mapping_frame(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_582A6
                moveq   #8,d0
                bra.s   loc_5831E
; ---------------------------------------------------------------------------

loc_582A6:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_582AC:
                move.l  #loc_582D8,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$18,height_pixels(a0)
                move.w  #$200,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$20,2,0),art_tile(a0)
                move.l  #Map_SSZCollapsingBridge,mappings(a0)
                move.b  #$B,mapping_frame(a0)

loc_582D8:
                move.w  y_pos(a0),d0
                move.b  mapping_frame(a0),d1
                subi.b  #$B,d1
                beq.s   loc_58302
                subq.b  #1,d1
                beq.s   loc_582F8
                subi.w  #$2C,d0
                cmp.w   (Player_1+y_pos).w,d0
                blo.s   loc_5835A
                bra.w   loc_583A0
; ---------------------------------------------------------------------------

loc_582F8:
                moveq   #$20,d1
                moveq   #8,d2
                subi.w  #$24,d0
                bra.s   loc_5830A
; ---------------------------------------------------------------------------

loc_58302:
                moveq   #$40,d1
                moveq   #$10,d2
                subi.w  #$1C,d0

loc_5830A:
                cmp.w   (Player_1+y_pos).w,d0
                blo.s   loc_5835A
                addq.b  #1,mapping_frame(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_5835A
                moveq   #$D,d0

loc_5831E:
                move.l  #loc_583A6,(a1)
                move.b  #$84,render_flags(a1)
                move.b  #$10,height_pixels(a1)
                move.w  priority(a0),priority(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.l  mappings(a0),mappings(a1)
                move.b  d0,mapping_frame(a1)
                move.w  x_pos(a0),x_pos(a1)
                add.w   d1,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                add.w   d2,y_pos(a1)

loc_5835A:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_58360:
                move.l  #loc_5838C,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$1C,height_pixels(a0)
                move.w  #$100,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZSpiralRamp,2,1),art_tile(a0)
                move.l  #Map_SSZCollapsingBridge,mappings(a0)
                move.b  #$A,mapping_frame(a0)

loc_5838C:
                move.w  y_pos(a0),d0
                subi.w  #$24,d0
                cmp.w   (Player_1+y_pos).w,d0
                bhs.s   loc_583A0
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_583A0:
                move.l  #loc_583A6,(a0)

loc_583A6:
                tst.b   render_flags(a0)
                bmi.s   loc_583B2
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_583B2:
                jsr     (MoveSprite).l
                jmp     (Draw_Sprite).l
