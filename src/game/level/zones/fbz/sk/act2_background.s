; Owner: game/level/zones/fbz/sk
; Responsibility: Flying Battery act-two background events, end-boss event actors, pillars and clouds
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

FBZ2_BackgroundInit:
                jsr     (AllocateObject).l
                bne.s   loc_52FB6
                move.l  #Obj_FBZOutdoorBGMotion,(a1)

loc_52FB6:
                cmpi.w  #$2C40,(Camera_X_pos).w
                blo.s   loc_53002
                move.w  #$10,(Events_routine_bg).w      ; If in boss event area, set BG event
                move.w  (a3),d0
                move.w  d0,$70(a3)                      ; Copy top BG line to bottom BG line (I guess so the scrolling doesn't garble the screen?)
                move.w  d0,$74(a3)
                move.w  d0,$78(a3)
                move.w  d0,$7C(a3)
                st      (Screen_shake_flag).w           ; Start shaking
                move.w  #VRAM_Plane_A_Name_Table,d7
                jsr     FBZ2_CloudDeform(pc)            ; Deform the cloud sprites
                jsr     Reset_TileOffsetPositionEff(pc)
                jsr     Refresh_PlaneFull(pc)
                jsr     PlainDeformation_Flipped(pc)    ; Reverse deformation
                jsr     Get_BGActualEffectiveDiff(pc)
                move.w  (Camera_Y_pos_BG_copy).w,(V_scroll_value).w
                move.w  (Camera_Y_pos_copy).w,(V_scroll_value_BG).w
                addq.w  #4,sp
                rts
; ---------------------------------------------------------------------------

loc_53002:
                jsr     FBZ_Deform(pc)                  ; Normal play
                jsr     Reset_TileOffsetPositionEff(pc)
                moveq   #0,d1
                jsr     Refresh_PlaneFull(pc)
                lea     FBZ_InBGDeformArray(pc),a4
                lea     (HScroll_table).w,a5
                jmp     ApplyDeformation(pc)
; ---------------------------------------------------------------------------

FBZ2_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     FBZ2_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

FBZ2_BackgroundEvent_Index:
                bra.w   FBZ2BGE_Init
; ---------------------------------------------------------------------------
                bra.w   FBZ2BGE_Normal
; ---------------------------------------------------------------------------
                bra.w   FBZ2BGE_ChangeTopDown
; ---------------------------------------------------------------------------
                bra.w   FBZ2BGE_ChangeBottomUp
; ---------------------------------------------------------------------------
                bra.w   FBZ2BGE_BossEvent
; ---------------------------------------------------------------------------

FBZ2BGE_ChangeTopDown:
                jsr     FBZ2_CheckBGChange(pc)

loc_5303C:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                tst.w   (Events_bg+$04).w
                beq.s   loc_5304E
                move.w  #$200,d1
                moveq   #0,d2

loc_5304E:
                jsr     Draw_PlaneVertTopDown(pc)
                bpl.s   loc_530BA
                move.w  #4,(Events_routine_bg).w
                bra.s   loc_530BA
; ---------------------------------------------------------------------------

FBZ2BGE_ChangeBottomUp:
                jsr     FBZ2_CheckBGChange(pc)

loc_53060:
                moveq   #0,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                tst.w   (Events_bg+$04).w
                beq.s   loc_53072
                move.w  #$200,d1
                moveq   #0,d2

loc_53072:
                jsr     Draw_PlaneVertSingleBottomUp(pc)
                bpl.s   loc_530BA
                move.w  #4,(Events_routine_bg).w
                bra.s   loc_530BA
; ---------------------------------------------------------------------------

FBZ2BGE_Init:
                move.w  (a3),d0
                move.w  d0,$70(a3)
                move.w  d0,$74(a3)
                move.w  d0,$78(a3)
                move.w  d0,$7C(a3)                      ; Copy BG lines
                addq.w  #4,(Events_routine_bg).w        ; Next BG Event

FBZ2BGE_Normal:
                tst.w   (Events_routine_fg).w
                beq.s   loc_530AC
                jsr     FBZ2_CloudDeform(pc)            ; If boss event has started
                jsr     Reset_TileOffsetPositionEff(pc)
                move.w  #$10,(Events_routine_bg).w
                bra.s   loc_530F0
; ---------------------------------------------------------------------------

loc_530AC:
                cmpi.b  #6,(Player_1+routine).w
                blo.s   loc_530B6                       ; Don't change BG if dying
                rts
; ---------------------------------------------------------------------------

loc_530B6:
                jsr     FBZ2_CheckBGChange(pc)

loc_530BA:
                move.w  (Events_bg+$04).w,d1
                beq.s   loc_530C4
                move.w  #$200,d1

loc_530C4:
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #$20,d6
                jsr     Draw_TileRow(pc)
                lea     FBZ_InBGDeformArray(pc),a4
                tst.w   (Events_bg+$04).w
                beq.s   loc_530E0
                lea     FBZ_OutBGDeformArray(pc),a4

loc_530E0:
                lea     (HScroll_table).w,a5
                jsr     ApplyDeformation(pc)
                jmp     ShakeScreen_Setup(pc)
; ---------------------------------------------------------------------------

FBZ2BGE_BossEvent:
                jsr     FBZ2_CloudDeform(pc)

loc_530F0:
                move.w  #VRAM_Plane_A_Name_Table,d7
                jsr     DrawBGAsYouMove(pc)             ; Draw BG on plane A
                jsr     PlainDeformation_Flipped(pc)
                jsr     Get_BGActualEffectiveDiff(pc)
                jsr     ShakeScreen_Setup(pc)
                move.w  (Camera_Y_pos_BG_copy).w,(V_scroll_value).w
                move.w  (Camera_Y_pos_copy).w,(V_scroll_value_BG).w
                addq.w  #4,sp
                tst.w   (Events_bg+$06).w
                beq.s   locret_5318A
                clr.w   (Events_bg+$06).w               ; If boss has been loaded
                move.w  (_unkEE9C).w,d0
                clr.w   (_unkEE9C).w                    ; Get final Y offset and clear it
                btst    #Status_InAir,(Player_1+status).w
                beq.s   loc_53134
                add.w   d0,(Player_1+y_pos).w           ; If player is not on ground, adjust his Y position properly
                add.w   d0,(Player_2+y_pos).w

loc_53134:
                add.w   d0,(Camera_Y_pos).w
                add.w   d0,(Camera_Y_pos_copy).w
                add.w   d0,(Camera_min_Y_pos).w
                add.w   d0,(Camera_max_Y_pos).w         ; Add offset to camera Ys
                move.w  (Camera_max_Y_pos).w,(Camera_target_max_Y_pos).w
                move.w  (_unkEE98).w,d0
                clr.w   (_unkEE98).w
                sub.w   d0,(Player_1+x_pos).w
                sub.w   d0,(Player_2+x_pos).w           ; Adjust X position of players
                sub.w   d0,(Camera_X_pos).w
                sub.w   d0,(Camera_X_pos_copy).w
                sub.w   d0,(Camera_min_X_pos).w
                sub.w   d0,(Camera_max_X_pos).w         ; and of cameras
                movea.w (Level_layout_main+$2C).w,a1    ; $580 Y of FG
                lea     $5C(a1),a1                      ; $2D00 X of FG
                move.w  (Level_layout_header).w,d0
                subi.w  #$14,d0
                moveq   #4-1,d1

loc_5317C:
                moveq   #$14-1,d2

loc_5317E:
                clr.b   (a1)+                           ; Clear large area of FG, probably erasing the copied FG area from the layout mod
                dbf     d2,loc_5317E
                adda.w  d0,a1
                dbf     d1,loc_5317C

locret_5318A:
                rts

; =============== S U B R O U T I N E =======================================

FBZ2_CloudDeform:
                move.w  (Camera_Y_pos_copy).w,d0
                subi.w  #$300,d0
                add.w   (_unkEE9C).w,d0                 ; Add camera BG Y to Y event offset
                move.w  d0,(Camera_Y_pos_BG_copy).w     ; Make that the effective Y
                move.w  (Camera_X_pos_copy).w,d0
                subi.w  #$2600,d0
                sub.w   (_unkEE98).w,d0
                move.w  d0,(Camera_X_pos_BG_copy).w     ; Do the same with the X values
                lea     (HScroll_table).w,a1
                lea     FBZ2_CloudDeformIndex(pc),a5
                move.w  (Camera_X_pos_BG_copy).w,d0
                swap    d0
                clr.w   d0
                asr.l   #4,d0
                move.l  d0,d1
                asr.l   #2,d1
                move.l  (HScroll_table+$1FC).w,d2
                asr.l   #3,d2
                addi.l  #$8000,(HScroll_table+$1FC).w   ; Perform cloud movement
                moveq   #$A-1,d3

loc_531D2:
                move.w  (a5)+,d4
                add.l   d2,d0
                swap    d0
                move.w  d0,(a1,d4.w)                    ; Set up cloud speeds
                swap    d0
                add.l   d1,d0
                dbf     d3,loc_531D2
                lea     (HScroll_table).w,a1
                lea     (FBZ_cloud_addr).w,a5
                move.w  (Camera_Y_pos_BG_copy).w,d0
                move.w  (Screen_shake_offset).w,d1
                sub.w   d1,d0
                asr.w   #1,d0
                add.w   d1,d0
                neg.w   d0
                add.w   (Events_bg+$08).w,d0            ; Get effective Y, add BG motion offset to it
                moveq   #$A-1,d1

loc_53202:
                move.w  (a5)+,d2
                beq.s   loc_5322E
                movea.w d2,a6                           ; Load cloud address
                move.w  $30(a6),d3                      ; Get Y position
                add.w   d0,d3                           ; Add offset
                andi.w  #$FF,d3
                addi.w  #$74,d3
                move.w  d3,$14(a6)                      ; Load to actual Y
                move.w  (a1)+,d3
                neg.w   d3
                add.w   $2E(a6),d3
                andi.w  #$1FF,d3
                addi.w  #$54,d3
                move.w  d3,$10(a6)                      ; Do the same to the X

loc_5322E:
                dbf     d1,loc_53202
                rts
; End of function FBZ2_CloudDeform

; =============== S U B R O U T I N E =======================================

FBZ2_CheckBGChange:
                move.w  (Player_1+x_pos).w,d0
                move.w  (Player_1+y_pos).w,d1
                move.w  (Events_bg+$00).w,d2            ; You know how this goes by now
                jmp     FBZ2_CheckBGChange_Index(pc,d2.w)
; End of function FBZ1_CheckBGChange

; ---------------------------------------------------------------------------

FBZ2_CheckBGChange_Index:
                bra.w   FBZ_Deform
; ---------------------------------------------------------------------------
                tst.w   (Events_bg+$04).w
                bne.s   loc_53258
                cmpi.w  #$A40,d1
                blo.w   FBZ_Deform
                bra.s   loc_5326A
; ---------------------------------------------------------------------------

loc_53258:
                cmpi.w  #$A40,d1
                bhi.w   FBZ_Deform
                clr.w   (Events_bg+$04).w
                moveq   #8,d0
                moveq   #0,d6
                bra.s   loc_5327A
; ---------------------------------------------------------------------------

loc_5326A:
                st      (Events_bg+$04).w
                moveq   #$C,d0
                move.w  #$F0,d6
                lea     Pal_FBZBGOutdoors(pc),a1
                bra.s   loc_5327E
; ---------------------------------------------------------------------------

loc_5327A:
                lea     Pal_FBZBGIndoors(pc),a1

loc_5327E:
                lea     (Normal_palette_line_4+$4).w,a5
                move.l  (a1)+,(a5)+
                move.l  (a1)+,(a5)+
                move.l  (a1)+,(a5)+
                move.l  (a1)+,(a5)+
                move.w  d0,(Events_routine_bg).w
                jsr     FBZ_Deform(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                add.w   d6,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,sp
                cmpi.w  #8,(Events_routine_bg).w
                beq.w   loc_5303C
                bra.w   loc_53060
; ---------------------------------------------------------------------------

Obj_FBZEndBossEventControl:
                move.l  #loc_532E0,(a0)
                move.b  #$11,height_pixels(a0)
                bset    #7,status(a0)
                move.w  #$32B8,(Camera_max_X_pos).w     ; Set $32B8 as the X end
                move.w  #$3C,d0
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_532DC
                addq.w  #4,d0

loc_532DC:
                move.w  d0,(Camera_min_Y_pos).w         ; Set level Y start depending on whether Tails is playing or not. I guess this is because Tails' center point is slightly lower than Sonic's

loc_532E0:
                cmpi.w  #$2E80,(Player_1+x_pos).w
                blo.w   loc_533A4
                move.l  #loc_532F0,(a0)                 ; If Sonic has passed $2E80 X, start moving the BG

loc_532F0:
                st      (Background_collision_flag).w   ; Set BG collision on
                addi.l  #$A000,(_unkEE9C).w
                addi.l  #$7800,(_unkEE98).w             ; Move the extra BG camera by a set amount
                cmpi.w  #$5D0,(_unkEE9C).w
                blo.s   loc_5333A
                move.w  #$5D0,(_unkEE9C).w              ; When BG has reached end point
                move.w  #$45C,(_unkEE98).w
                clr.b   (Background_collision_flag).w   ; Stop BG collision
                move.l  #loc_53322,(a0)

loc_53322:
                move.w  (Camera_min_Y_pos).w,d0
                cmp.w   (Camera_Y_pos).w,d0
                bne.s   loc_5333A
                move.w  d0,(Camera_max_Y_pos).w         ; Lock screen when camera has scrolled as high as possible
                move.w  d0,(Camera_target_max_Y_pos).w
                move.l  #loc_5333A,(a0)

loc_5333A:
                cmpi.w  #$280,(Player_1+y_pos).w
                bhs.s   loc_53348
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w  ; If player is above $280 Y then lock screen X as you move

loc_53348:
                move.w  (Camera_min_Y_pos).w,d0
                cmp.w   (Camera_max_Y_pos).w,d0
                bne.s   loc_533A4
                move.w  (Camera_max_X_pos).w,d0
                cmp.w   (Camera_min_X_pos).w,d0
                bne.s   loc_533A4
                move.w  #$F0,(Draw_delayed_position).w  ; When the screen is completely locked, start proper Screen Events
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_fg).w        ; Next screen event
                move.l  #loc_53372,(a0)

loc_53372:
                cmpi.w  #$C,(Events_routine_fg).w
                bne.s   loc_533A4
                jsr     (AllocateObject).l
                bne.s   loc_53388                       ; When screen event has finished, load the boss
                move.l  #Obj_FBZEndBoss,(a1)

loc_53388:
                clr.w   (Screen_shake_flag).w           ; Stop shaking
                st      (Events_bg+$06).w               ; Set variable when boss has loaded
                move.w  #$31C0,d0
                move.w  #$31C0,d4
                move.w  #$690,d1
                move.l  #loc_533A4,(a0)
                bra.s   loc_533B8
; ---------------------------------------------------------------------------

loc_533A4:
                move.w  x_pos(a0),d4
                move.w  #$31C0,d0
                add.w   (_unkEE98).w,d0
                move.w  #$690,d1
                sub.w   (_unkEE9C).w,d1

loc_533B8:
                move.w  d0,x_pos(a0)
                move.w  d1,y_pos(a0)
                move.w  #$4C0,d1
                moveq   #$11,d2
                moveq   #$11,d3
                jmp     (SolidObjectTop).l
; ---------------------------------------------------------------------------

Obj_FBZBossPillar:
                move.l  #Obj_FBZBossPillarMain,(a0)
                move.b  #$44,render_flags(a0)           ; Set up boss pillar object
                move.b  #$FF,height_pixels(a0)
                move.b  #$20,width_pixels(a0)
                move.w  #$300,priority(a0)
                move.w  #make_art_tile(ArtTile_FBZBossPillar,2,1),art_tile(a0)
                move.l  #Map_FBZ2Preboss,mappings(a0)
                move.w  #2,mainspr_childsprites(a0)     ; 2 sprites

Obj_FBZBossPillarMain:
                move.w  #$2DE0,d4
                add.w   (_unkEE98).w,d4
                move.w  d4,x_pos(a0)                    ; Move pillar to proper X area
                move.w  d4,d0
                move.w  d4,d1
                subi.w  #$200,d0
                tst.w   $30(a0)
                beq.s   loc_5341E
                addi.w  #$28,d1

loc_5341E:
                move.w  #$580,d5
                sub.w   (_unkEE9C).w,d5                 ; Get proper Y offset
                move.w  d5,d2
                move.w  d5,d3
                addi.w  #$80,d2
                addi.w  #$100,d3
                clr.w   $30(a0)
                lea     (Player_1).w,a1
                bsr.s   FBZBossPillar_CheckPlayerPos
                lea     (Player_2).w,a1
                bsr.s   FBZBossPillar_CheckPlayerPos
                tst.w   $30(a0)
                beq.s   loc_53456
                cmpi.w  #$40,$2E(a0)                    ; If player is in range, increase pillar offset
                bhs.s   loc_5346A
                addq.w  #8,$2E(a0)
                bra.s   loc_5346A
; ---------------------------------------------------------------------------

loc_53456:
                tst.w   $2E(a0)
                beq.s   loc_5346A
                subq.w  #8,$2E(a0)                      ; If player is not in range, decrease pillar offset
                bne.s   loc_5346A
                moveq   #signextendB(sfx_SpikeBalls),d0  ; Play sound only when pillar hits ground
                jsr     (Play_SFX).l

loc_5346A:
                sub.w   $2E(a0),d5
                move.w  d5,y_pos(a0)                    ; Subtract Y from offset and place it in sprite Y
                lea     sub2_x_pos(a0),a1
                addi.w  #$80,d5
                moveq   #1,d0

loc_5347C:
                move.w  d4,(a1)
                move.w  d5,sub2_y_pos-sub2_x_pos(a1)
                subi.w  #$100,d5                        ; Set the sprite positions of each pillar sprite
                addq.w  #6,a1
                dbf     d0,loc_5347C
                moveq   #$2B,d1
                move.w  #$100,d2
                move.w  #$100,d3
                jsr     (SolidObjectFull).l             ; Make it solid
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

FBZBossPillar_CheckPlayerPos:
                move.w  x_pos(a1),d6
                cmp.w   d0,d6
                blt.s   .return
                cmp.w   d1,d6
                bhs.s   .return
                move.w  y_pos(a1),d6
                cmp.w   d2,d6
                blo.s   .return
                cmp.w   d3,d6
                bhs.s   .return
                tst.b   $2E(a1)
                bmi.s   .return
                st      $30(a0)

                .return:
                rts
; End of function FBZBossPillar_CheckPlayerPos

; ---------------------------------------------------------------------------

Obj_FBZCloud:
                move.l  #Draw_Sprite,(a0)
                move.b  #$40,render_flags(a0)           ; Multisprite routine
                move.b  #$C,height_pixels(a0)
                move.b  #$2C,width_pixels(a0)
                move.w  #$380,priority(a0)
                move.w  #make_art_tile(ArtTile_FBZCloud,3,0),art_tile(a0)
                move.l  #Map_FBZ2Preboss,mappings(a0)
                move.w  $2E(a0),d0
                add.w   d0,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                lea     FBZCloud_PositionFrameData(pc),a1
                adda.w  d0,a1
                move.w  (a1)+,$2E(a0)
                move.w  (a1)+,$30(a0)
                move.w  (a1),d0
                move.b  d0,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_FBZ2Preboss:
                include "src/objects/shared/zones/fbz/act2/mappings/preboss.s"
FBZ2_CloudDeformIndex:
                dc.w    4
                dc.w    $E
                dc.w    8
                dc.w    $10
                dc.w    2
                dc.w    $C
                dc.w    6
                dc.w    $12
                dc.w    $A
                dc.w    0
FBZCloud_PositionFrameData:
                dc.w    $1E0,   $EC,     1
                dc.w    $144,   $C8,     2
                dc.w    $60,   $B4,     3
                dc.w    $C4,   $A0,     2
                dc.w    $140,   $84,     1
                dc.w    $1A0,   $6C,     3
                dc.w    $F0,   $54,     1
                dc.w    $160,   $3C,     3
                dc.w    $7C,   $28,     2
                dc.w    $20,    $C,     1
