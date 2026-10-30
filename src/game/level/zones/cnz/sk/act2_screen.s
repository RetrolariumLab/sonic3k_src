; Owner: game/level/zones/cnz/sk
; Responsibility: Carnival Night act-two screen control, background events and teleporter actor
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CNZ2_ScreenInit:
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

CNZ2_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                cmpi.w  #$4600,(Player_1+x_pos).w
                bhs.s   loc_52138                       ; If player is far enough to the right, skip ahead
                moveq   #0,d0
                cmpi.w  #$940,(Player_1+x_pos).w
                bhs.s   loc_5212E
                move.w  #$580,d0                        ; If player is still in old boss arena, set the level Y start to $580, otherwise, make it 0 like normal

loc_5212E:
                cmp.w   (Camera_min_Y_pos).w,d0
                beq.s   loc_52138
                move.w  d0,(Camera_min_Y_pos).w

loc_52138:
                tst.w   (Events_bg+$06).w
                beq.s   loc_52146
                clr.w   (Events_bg+$06).w
                jmp     Refresh_PlaneScreenDirect(pc)
; ---------------------------------------------------------------------------

loc_52146:
                move.w  (Events_routine_fg).w,d0
                jmp     CNZ2_ScreenEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

CNZ2_ScreenEvent_Index:
                bra.w   loc_5215A
; ---------------------------------------------------------------------------
                bra.w   loc_521D2
; ---------------------------------------------------------------------------
                bra.w   CNZ2SE_Normal
; ---------------------------------------------------------------------------

loc_5215A:
                cmpi.w  #3,(Player_mode).w
                beq.s   loc_5216C
                move.w  #8,(Events_routine_fg).w        ; If playing as Sonic/Tails, don't do any special screen events
                bra.w   CNZ2SE_Normal
; ---------------------------------------------------------------------------

loc_5216C:
                lea     (Player_1).w,a1                 ; Only do all this is Knuckles is playing
                cmpi.w  #$4880,x_pos(a1)
                blo.w   CNZ2SE_Normal                   ; If Knuckles is not past $4880 X, just play normally
                cmpi.w  #$B00,y_pos(a1)
                blo.s   CNZ2SE_Normal                   ; If Knuckles is not past $B00 Y, play normally
                jsr     (AllocateObject).l
                bne.s   loc_521BE
                move.l  #Obj_CNZTeleporter,(a1)
                jsr     (CreateNewSprite4).l
                bne.s   loc_521BE
                move.l  #Obj_EggCapsule,(a1)
                move.w  #$4980,x_pos(a1)
                move.w  #$A20,y_pos(a1)
                movem.l d7-a0/a2-a3,-(sp)
                lea     (PLC_EggCapsule).l,a1
                jsr     (Load_PLC_Raw).l
                movem.l (sp)+,d7-a0/a2-a3

loc_521BE:
                move.w  #$4750,(Camera_min_X_pos).w
                move.w  #$48E0,(Camera_max_X_pos).w
                clr.b   (End_of_level_flag).w
                addq.w  #4,(Events_routine_fg).w

loc_521D2:
                tst.b   (End_of_level_flag).w
                beq.s   CNZ2SE_Normal
                jsr     (AllocateObject).l
                bne.s   CNZ2SE_Normal
                move.l  #Obj_IncLevEndXGradual,(a1)
                move.w  #$49A0,(Camera_stored_max_X_pos).w
                lea     (a2),a6
                jsr     (Restore_LevelMusic).l
                lea     (a6),a2
                jsr     (Restore_PlayerControl).l
                addq.w  #4,(Events_routine_fg).w

CNZ2SE_Normal:
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

CNZ2_BackgroundInit:
                move.w  #8,(Events_routine_bg).w
                jsr     CNZ1_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                lea     CNZ1_BGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

CNZ2_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     CNZ2_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

CNZ2_BackgroundEvent_Index:
                bra.w   loc_52238
; ---------------------------------------------------------------------------
                bra.w   loc_52266
; ---------------------------------------------------------------------------
                bra.w   loc_5227C
; ---------------------------------------------------------------------------

loc_52238:
                moveq   #0,d1
                move.w  #$200,d2
                jsr     Draw_PlaneVertSingleBottomUp(pc)
                bpl.w   PlainDeformation
                jsr     CNZ1_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_5226A
; ---------------------------------------------------------------------------

loc_52266:
                jsr     CNZ1_Deform(pc)

loc_5226A:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertSingleBottomUp(pc)
                bpl.s   loc_52280
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_52280
; ---------------------------------------------------------------------------

loc_5227C:
                jsr     CNZ1_Deform(pc)

loc_52280:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                lea     CNZ1_BGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jsr     ApplyDeformation(pc)
                jmp     ShakeScreen_Setup(pc)
; ---------------------------------------------------------------------------

Obj_CNZTeleporter:
                lea     (Player_1).w,a1
                cmpi.w  #$4A38,x_pos(a1)
                blo.s   locret_522FE                    ; If Knuckles isn't in range, don't bother
                btst    #Status_InAir,status(a1)
                beq.s   loc_522C2
                move.w  #$4A40,d0
                cmp.w   x_pos(a1),d0
                bhi.s   locret_522FE
                move.w  d0,x_pos(a1)                    ; While jumping, don't allow Knuckles past this point (so he lands on the teleporter)

loc_522C2:
                clr.w   x_vel(a1)
                clr.w   ground_vel(a1)                  ; Stop Knuckles' momentum
                st      (Ctrl_1_locked).w               ; Turn off player control
                clr.w   (Ctrl_1_logical).w              ; Clear buttons
                lea     (ArtKosM_CNZTeleport).l,a1
                move.w  #tiles_to_bytes(ArtTile_CNZTeleport),d2
                jsr     (Queue_Kos_Module).l            ; Load teleporter graphics
                lea     (Normal_palette_line_2+$2).w,a1
                move.l  #$EEE0EC0,(a1)
                move.w  #$EA2,$E(a1)
                move.w  #$E80,$12(a1)                   ; Replace applicable palette entries
                move.l  #Obj_CNZTeleporterMain,(a0)

locret_522FE:
                rts
; ---------------------------------------------------------------------------

Obj_CNZTeleporterMain:
                tst.b   (Kos_modules_left).w
                bne.s   locret_52348                    ; Don't do anything while art is loading
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   locret_52348                    ; Wait till Knuckles is not in the air
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_52348
                move.w  a1,$3C(a0)
                move.l  #Obj_TeleporterBeam,(a1)
                move.w  a0,parent2(a1)
                move.w  #$4A40,d0
                move.w  d0,x_pos(a0)
                move.w  d0,x_pos(a1)
                move.w  #$A38,y_pos(a1)                 ; Set teleporter position/attributes
                moveq   #signextendB(sfx_Charging),d0
                jsr     (Play_SFX).l
                move.l  #loc_5234A,(a0)

locret_52348:
                rts
; ---------------------------------------------------------------------------

loc_5234A:
                lea     (Player_1).w,a1
                movea.w $3C(a0),a2
                cmpi.b  #8,$46(a2)
                blt.s   locret_523C8
                beq.s   loc_523B6                       ; Once beam has expanded halfway. On the first frame this happen, set player state
                cmpi.b  #$18,$46(a2)
                bhs.s   loc_5238E
                btst    #0,(Level_frame_counter+1).w
                beq.s   locret_523C8
                subq.w  #1,y_pos(a1)                    ; Raise player slightly
                btst    #1,(Level_frame_counter+1).w
                beq.s   locret_523C8
                moveq   #1,d1
                move.w  x_pos(a1),d0
                cmp.w   x_pos(a0),d0
                beq.s   locret_523C8
                bcs.s   loc_52388
                neg.w   d1

loc_52388:
                add.w   d1,x_pos(a1)                    ; Move player X towards center of beam X
                bra.s   locret_523C8
; ---------------------------------------------------------------------------

loc_5238E:
                move.l  #loc_523CA,(a0)                 ; When beam has expanded all the way
                move.b  #3,object_control(a1)           ; Stop player animation
                moveq   #0,d0
                move.w  d0,y_pos(a1)                    ; Make player disappear!
                move.b  d0,anim(a1)
                move.b  d0,mapping_frame(a1)
                moveq   #signextendB(sfx_Transporter),d0
                jsr     (Play_SFX).l
                st      (Scroll_lock).w
                bra.s   locret_523C8
; ---------------------------------------------------------------------------

loc_523B6:
                move.b  #1,object_control(a1)           ; Player under object control
                bset    #Status_Roll,status(a1)         ; Set to jumping state
                move.b  #2,anim(a1)                     ; Rolling animation

locret_523C8:
                rts
; ---------------------------------------------------------------------------

loc_523CA:
                subi.w  #$10,(Camera_Y_pos).w
                cmpi.w  #$780,(Camera_Y_pos).w
                bhs.s   locret_523EA
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #$500,d0                        ; Start Ice Cap
                jmp     (StartNewLevel).l
; ---------------------------------------------------------------------------

locret_523EA:
                rts
