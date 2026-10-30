; Owner: game/level/zones/icz/sk
; Responsibility: IceCap act-one screen and background events, deformation, snow pile and teleporter actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

ICZ1_ScreenInit:
                tst.b   (Last_star_post_hit).w
                bne.s   loc_53648                       ; If not restarting from a lamppost
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_53648                       ; And we're Knuckles
                jsr     (AllocateObject).l
                bne.s   loc_53648
                move.l  #Obj_ICZTeleporter,(a1)         ; Make teleporter object, etc
                move.w  #$3640,(Player_1+x_pos).w
                move.w  #$660,(Player_1+y_pos).w
                move.w  #$35A0,d0
                move.w  d0,(Camera_X_pos_copy).w
                move.w  d0,(Camera_X_pos).w
                move.w  #$5FB,d0
                move.w  d0,(Camera_Y_pos_copy).w
                move.w  d0,(Camera_Y_pos).w

loc_53648:
                move.w  #$7FF,(Screen_Y_wrap_value).w
                move.w  #$7F0,(Camera_Y_pos_mask).w
                move.w  #$3C,(Layout_row_index_mask).w  ; We're in a looping level!
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

ICZ1_ScreenEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     ICZ1_ScreenEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

ICZ1_ScreenEvent_Index:
                bra.w   ICZ1SE_Init
; ---------------------------------------------------------------------------
                bra.w   ICZ1SE_WaitQuake
; ---------------------------------------------------------------------------
                bra.w   ICZ1SE_Normal
; ---------------------------------------------------------------------------
                bra.w   ICZ1SE_Normal
; ---------------------------------------------------------------------------
                bra.w   ICZ1SE_Normal
; ---------------------------------------------------------------------------
                bra.w   ICZ1SE_Normal
; ---------------------------------------------------------------------------

ICZ1SE_Init:
                tst.w   (Screen_shake_flag).w
                beq.s   loc_53696
                tst.b   (Ctrl_1_locked).w               ; If shaking due to hitting the wall, remove player control temporarily
                bne.s   loc_53696
                st      (Ctrl_1_locked).w
                clr.w   (Ctrl_1_logical).w

loc_53696:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_X_pos_copy).w
                bra.s   ICZ1SE_Normal
; ---------------------------------------------------------------------------

ICZ1SE_WaitQuake:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w

ICZ1SE_Normal:
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

ICZ1_BackgroundInit:
                lea     (a3),a1
                moveq   #8-1,d0

loc_536B0:
                move.w  (a1),$20(a1)                    ; Upper $400 of BG is mirrored in lower $400
                addq.w  #4,a1
                dbf     d0,loc_536B0
                move.w  (Camera_Y_pos_copy).w,(Events_fg_0).w
                move.w  (Camera_Y_pos_copy).w,(Events_fg_1).w  ; Camera BG Y is noted in two variables
                cmpi.w  #$3940,(Camera_X_pos).w
                bhs.s   loc_53704
                cmpi.w  #$3580,(Camera_X_pos).w
                blo.s   loc_536DC
                addi.w  #$2800,(Events_fg_1).w          ; If past $3580 X, adjust BG camera

loc_536DC:
                clr.w   (Events_bg+$16).w               ; No VScrolling when outside
                jsr     (ICZ1_SetIntroPal).l
                jsr     ICZ1_IntroDeform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                move.w  #$1880,d1
                jsr     Refresh_PlaneFull(pc)
                lea     (ICZ1_IntroBGDeformArray).l,a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

loc_53704:
                move.w  #$10,(Events_routine_bg).w      ; If past $3940 X, we're indoors already
                st      (Events_bg+$16).w               ; Go indoors
                jsr     (ICZ1_SetIndoorPal).l
                jsr     ICZ1_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                jsr     Refresh_PlaneFull(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

ICZ1_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     ICZ1_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

ICZ1_BackgroundEvent_Index:
                bra.w   ICZ1BGE_Intro
; ---------------------------------------------------------------------------
                bra.w   ICZ1BGE_SnowFall
; ---------------------------------------------------------------------------
                bra.w   ICZ1BGE_Refresh
; ---------------------------------------------------------------------------
                bra.w   ICZ1BGE_Refresh2
; ---------------------------------------------------------------------------
                bra.w   ICZ1BGE_Normal
; ---------------------------------------------------------------------------
                bra.w   ICZ1BGE_Transition
; ---------------------------------------------------------------------------

ICZ1BGE_Intro:
                tst.w   (Events_fg_5).w
                beq.s   loc_53780
                clr.w   (Events_fg_5).w                 ; If flag is set
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_5375C
                addq.w  #4,(Events_routine_bg).w        ; Just go to next BG event if playing as Knuckles
                bra.s   loc_53780
; ---------------------------------------------------------------------------

loc_5375C:
                jsr     (AllocateObject).l
                bne.s   loc_5376A
                move.l  #Obj_ICZ1BigSnowPile,(a1)

loc_5376A:
                clr.l   (Events_bg+$00).w
                clr.l   (Events_bg+$04).w               ; Clear offsets
                jsr     ICZ1_BigSnowFall(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_537BA
; ---------------------------------------------------------------------------

loc_53780:
                jsr     ICZ1_IntroDeform(pc)            ; Deformation is pretty standard during the intro portion
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                move.w  #$1880,d1
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                lea     (ICZ1_IntroBGDeformArray).l,a4
                lea     (HScroll_table).w,a5
                jsr     ApplyDeformation(pc)
                jmp     ShakeScreen_Setup(pc)
; ---------------------------------------------------------------------------

ICZ1BGE_SnowFall:
                tst.w   (Events_fg_5).w
                bne.s   loc_537C6
                cmpi.w  #3,(Player_mode).w
                beq.s   loc_53780                       ; If Knuckles, skip
                jsr     ICZ1_BigSnowFall(pc)

loc_537BA:
                jsr     DrawBGAsYouMove(pc)
                jsr     PlainDeformation(pc)
                jmp     ShakeScreen_Setup(pc)
; ---------------------------------------------------------------------------

loc_537C6:
                clr.w   (Events_fg_5).w
                move.w  #$2E0,(Draw_delayed_position).w  ; Set BG refresh position
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w

ICZ1BGE_Refresh:
                move.w  #$1880,d1
                move.w  #$200,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.w   PlainDeformation
                jsr     ICZ1_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_5380E
; ---------------------------------------------------------------------------

ICZ1BGE_Refresh2:
                jsr     ICZ1_Deform(pc)

loc_5380E:
                move.w  (Camera_X_pos_BG_copy).w,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.s   loc_5387E
                st      (Events_bg+$16).w               ; Go indoors
                jsr     (ICZ1_SetIndoorPal).l           ; Set indoor palette
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_5387E
; ---------------------------------------------------------------------------

ICZ1BGE_Normal:
                cmpi.w  #$6900,(Camera_X_pos).w
                blo.s   loc_5387A
                movem.l d7-a0/a2-a3,-(sp)
                lea     (ICZ2_128x128_Secondary_Kos).l,a1
                lea     (RAM_start+$A00).l,a2
                jsr     (Queue_Kos).l
                lea     (ICZ2_16x16_Secondary_Kos).l,a1
                lea     (Block_table+$408).w,a2
                jsr     (Queue_Kos).l
                lea     (ICZ2_8x8_Secondary_KosM).l,a1
                move.w  #tiles_to_bytes($122),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_20,d0
                jsr     (Load_PLC).l
                movem.l (sp)+,d7-a0/a2-a3
                addq.w  #4,(Events_routine_bg).w

loc_5387A:
                jsr     ICZ1_Deform(pc)

loc_5387E:
                jsr     DrawBGAsYouMove(pc)
                jmp     PlainDeformation(pc)
; ---------------------------------------------------------------------------

ICZ1BGE_Transition:
                tst.w   (Kos_decomp_queue_count).w
                bne.w   loc_53938
                move.w  #$501,(Current_zone_and_act).w
                clr.b   (Dynamic_resize_routine).w
                clr.b   (Object_load_routine).w
                clr.b   (Rings_manager_routine).w
                clr.b   (Boss_flag).w
                clr.b   (Respawn_table_keep).w
                jsr     Clear_Switches(pc)
                movem.l d7-a0/a2-a3,-(sp)
                jsr     (Load_Level).l
                jsr     (LoadSolids).l
                jsr     (CheckLevelForWater).l
                move.w  #$8014,(VDP_control_port).l     ; Turn on HInt since ICZ2 has water
                moveq   #PalID_ICZ2,d0
                jsr     (LoadPalette_Immediate).l
                movem.l (sp)+,d7-a0/a2-a3
                move.w  #$6880,d0
                move.w  #-$100,d1
                sub.w   d0,(Player_1+x_pos).w
                sub.w   d1,(Player_1+y_pos).w
                sub.w   d0,(Player_2+x_pos).w
                sub.w   d1,(Player_2+y_pos).w
                jsr     Offset_ObjectsDuringTransition(pc)
                jsr     Offset_SomeObjectsDuringTransition(pc)
                sub.w   d0,(Camera_X_pos).w
                sub.w   d1,(Camera_Y_pos).w
                sub.w   d0,(Camera_X_pos_copy).w
                sub.w   d1,(Camera_Y_pos_copy).w
                move.l  #$7000,d0
                move.l  d0,(Camera_min_X_pos).w
                move.l  #$B20,d0
                move.l  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                move.w  #$FFF,(Screen_Y_wrap_value).w
                move.w  #$FF0,(Camera_Y_pos_mask).w
                move.w  #$7C,(Layout_row_index_mask).w
                jsr     Reset_TileOffsetPositionActual(pc)
                clr.w   (Events_routine_bg).w

loc_53938:
                jsr     ICZ1_Deform(pc)
                jmp     PlainDeformation(pc)

; =============== S U B R O U T I N E =======================================

ICZ1_IntroDeform:
                lea     (Events_fg_0).w,a1
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  #$400,d2
                move.w  #$800,d3
                jsr     Adjust_BGDuringLoop(pc)
                move.w  (Events_fg_1).w,d0
                asr.w   #7,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                move.w  (Screen_shake_offset).w,d3
                sub.w   d3,d0
                swap    d0
                clr.w   d0
                asr.l   #5,d0
                move.l  d0,d1
                swap    d0
                add.w   d3,d0
                swap    d0
                lea     (HScroll_table).w,a1
                moveq   #0,d3
                moveq   #5-1,d2                         ; First five deformation speeds are constant
                bsr.s   sub_53996
                add.l   d1,d0
                move.l  d1,d2
                asr.l   #1,d2
                add.l   d2,d1
                move.l  $12(a1),d3
                addi.l  #$800,$12(a1)
                moveq   #9-1,d2                         ; Last 9 move slowly automatically
; End of function ICZ1_IntroDeform

; =============== S U B R O U T I N E =======================================

sub_53996:
                swap    d0
                move.w  d0,(a1)+
                swap    d0
                add.l   d1,d0
                add.l   d3,d1
                addi.l  #$800,d3
                dbf     d2,sub_53996
                rts
; End of function sub_53996

; =============== S U B R O U T I N E =======================================

ICZ1_BigSnowFall:
                cmpi.w  #-$12E,(Events_bg+$00).w
                ble.s   loc_539DE
                st      (Screen_shake_flag).w
                addi.l  #$2400,(Events_bg+$04).w
                move.l  (Events_bg+$04).w,d0
                sub.l   d0,(Events_bg+$00).w
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   loc_539F0
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l
                bra.s   loc_539F0
; ---------------------------------------------------------------------------

loc_539DE:
                tst.w   (Screen_shake_flag).w
                bpl.s   loc_539F0
                move.w  #4,(Screen_shake_flag).w
                move.w  #-$12E,(Events_bg+$00).w

loc_539F0:
                move.w  (Camera_Y_pos_copy).w,d0        ; Use portion of background to show snow object
                subi.w  #$460,d0
                add.w   (Events_bg+$00).w,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                subi.w  #$1D40,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                rts
; End of function ICZ1_BigSnowFall

; =============== S U B R O U T I N E =======================================

ICZ1_Deform:
                move.w  (Camera_Y_pos_copy).w,d0
                asr.w   #1,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w     ; BG moves up/down at half speed
                asr.w   #1,d0
                move.w  d0,(Events_bg+$12).w            ; Dynamic BG moves up/down at quarter speed
                move.w  (Camera_X_pos_copy).w,d0
                asr.w   #1,d0
                subi.w  #$1D80,d0
                move.w  d0,(Camera_X_pos_BG_copy).w     ; BG moves left/right at half speed
                asr.w   #1,d0
                move.w  d0,(Events_bg+$10).w            ; Dynamic BG moves left/right at quarter speed
                rts
; End of function ICZ1_Deform

; ---------------------------------------------------------------------------

Obj_ICZ1BigSnowPile:
                move.l  #loc_53A4C,(a0)
                move.b  #$80,height_pixels(a0)
                move.w  #$3880,x_pos(a0)
                bset    #7,status(a0)

loc_53A4C:
                cmpi.w  #8,(Events_routine_bg).w
                blo.s   loc_53A5A
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_53A5A:
                move.w  #$5E0,d0
                sub.w   (Events_bg+$00).w,d0            ; Shift Y position based on offset
                move.w  d0,y_pos(a0)
                move.w  #$94,d1
                lea     ICZ1_SnowpileSlopeDef(pc),a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped2).l
                cmpi.w  #$70E,y_pos(a0)
                bne.s   locret_53AD2
                tst.b   (Ctrl_1_locked).w
                beq.s   locret_53AD2
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)        ; Wait till player is standing on ground
                bne.s   locret_53AD2
                move.b  (Ctrl_1_pressed).w,d0
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d0  ; Wait until a jump button is pressed
                beq.s   locret_53AD2
                clr.b   (Ctrl_1_locked).w               ; When done, unlock player
                move.w  #-$600,y_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l                    ; Perform jumping on player object manually

locret_53AD2:
                rts
; ---------------------------------------------------------------------------

Obj_ICZTeleporter:
                jsr     (AllocateObjectAfterCurrent).l
                beq.s   loc_53ADE
                rts

loc_53ADE:
                move.l  #Obj_ICZTeleporterMain,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$20,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  #make_art_tile(ArtTile_ICZIntroSprites,1,0),art_tile(a0)
                move.l  #Map_ICZPlatforms,mappings(a0)  ; Attributes for teleporter platform in ICZ
                move.w  #$3640,x_pos(a0)
                move.w  #$670,y_pos(a0)                 ; Set position
                move.b  #$1A,mapping_frame(a0)
                move.w  (Player_1+y_pos).w,$3E(a0)      ; Knuckles Y position into $3E
                move.w  a1,$3C(a0)                      ; Child beam object into $3C
                move.l  #Obj_TeleporterBeamExpand,(a1)
                move.b  #$44,render_flags(a1)
                st      routine(a1)
                move.b  #$80,height_pixels(a1)
                move.b  #$18,width_pixels(a1)
                move.w  #$80,priority(a1)
                move.w  #make_art_tile(ArtTile_ICZTeleport-$12,1,0),art_tile(a1)
                move.l  #Map_SSZHPZTeleporter,mappings(a1)  ; Set attributes of beam object
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  #2,mainspr_childsprites(a1)
                move.w  y_pos(a0),$44(a1)               ; Lots of init stuff for the beam to work properly
                subi.w  #$80,$44(a1)
                move.b  #$18,$46(a1)
                move.w  a0,parent2(a1)                  ; Parent in $48
                lea     (Target_palette_line_2+$10).w,a1
                move.w  #$EA2,(a1)
                move.w  #$E80,4(a1)                     ; Slight change to palette
                lea     (Player_1).w,a1
                move.b  #1,object_control(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)         ; Knuckles is under object control, spinning animation, and jumping

Obj_ICZTeleporterMain:
                lea     (Player_1).w,a1
                move.l  #$20000,d0
                move.l  #$800,d1
                jsr     (Gradual_SwingOffset).l         ; Do gradual swing on Knuckles until he starts to reverse direction
                add.w   $3E(a0),d0
                move.w  d0,y_pos(a1)
                tst.l   $2E(a0)
                bmi.s   loc_53BFE
                clr.b   object_control(a1)              ; Return player control to Knuckles
                clr.b   anim(a1)
                move.l  #Obj_ICZTeleporterCheckDel,(a0)

Obj_ICZTeleporterCheckDel:
                cmpi.w  #$3780,(Camera_X_pos_copy).w
                blo.s   loc_53BEE
                lea     (Normal_palette_line_2+$10).w,a1  ; When player moves far enough to the right, restore palette and delete object
                move.w  #$2C,(a1)
                clr.w   4(a1)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_53BEE:
                moveq   #$23,d1                         ; Act as a solid object otherwise
                moveq   #$10,d2
                moveq   #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l

loc_53BFE:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
                dc.b    $61, $61
                dc.b    $61, $61
                dc.b    $60, $60
                dc.b    $60, $60
                dc.b    $5F, $5F
                dc.b    $5E, $5E
                dc.b    $5D, $5C
                dc.b    $5C, $5B
                dc.b    $5A, $59
                dc.b    $59, $58
                dc.b    $57, $57
ICZ1_SnowpileSlopeDef:
                dc.b    $56, $56
                dc.b    $55, $55
                dc.b    $54, $54
                dc.b    $53, $53
                dc.b    $52, $52
                dc.b    $51, $51
                dc.b    $51, $51
                dc.b    $50, $50
                dc.b    $50, $50
                dc.b    $4F, $4F
                dc.b    $4E, $4E
                dc.b    $4D, $4C
                dc.b    $4C, $4B
                dc.b    $4A, $49
                dc.b    $49, $48
                dc.b    $47, $47
                dc.b    $46, $46
                dc.b    $45, $45
                dc.b    $44, $44
                dc.b    $43, $43
                dc.b    $42, $42
                dc.b    $41, $41
                dc.b    $41, $41
                dc.b    $40, $40
                dc.b    $40, $40
                dc.b    $3F, $3F
                dc.b    $3E, $3E
                dc.b    $3D, $3C
                dc.b    $3C, $3B
                dc.b    $3A, $39
                dc.b    $39, $38
                dc.b    $37, $37
                dc.b    $36, $36
                dc.b    $35, $35
                dc.b    $34, $34
                dc.b    $33, $33
                dc.b    $32, $32
                dc.b    $31, $31
                dc.b    $31, $31
                dc.b    $30, $30
                dc.b    $30, $30
                dc.b    $2F, $2F
                dc.b    $2E, $2E
                dc.b    $2D, $2C
                dc.b    $2C, $2B
                dc.b    $2A, $29
                dc.b    $29, $28
                dc.b    $27, $27
                dc.b    $26, $26
                dc.b    $25, $25
                dc.b    $24, $24
                dc.b    $23, $23
                dc.b    $22, $22
                dc.b    $21, $21
                dc.b    $21, $21
                dc.b    $20, $20
                dc.b    $20, $20
                dc.b    $1F, $1F
                dc.b    $1E, $1E
                dc.b    $1D, $1C
                dc.b    $1C, $1B
                dc.b    $1A, $19
                dc.b    $19, $18
                dc.b    $17, $17
                dc.b    $16, $16
                dc.b    $15, $15
                dc.b    $14, $14
                dc.b    $13, $13
                dc.b    $12, $12
                dc.b    $11, $11
                dc.b    $11, $11
                dc.b    $10, $10
                dc.b    $10, $10
                dc.b    $F,  $F
                dc.b    $E,  $E
                dc.b    $D,  $C
                dc.b    $C,  $B
                dc.b    $A,   9
                dc.b    9,   8
                dc.b    7,   7
                dc.b    6,   6
                dc.b    5,   5
                dc.b    4,   4
                dc.b    3,   3
                dc.b    2,   2
