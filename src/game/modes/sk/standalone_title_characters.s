; Owner: game/modes/sk
; Responsibility: Standalone title character landing, scenery, banner and hand animation state machines
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
Pal_SKTitle_Sonic:
                binclude "data/General/Title/Palettes/SK Sonic.bin"
                even
Pal_SKTitle_SegaBG:
                binclude "data/General/Title/Palettes/SK Sega and BG.bin"
                even
Pal_SKTitle_Knux:
                binclude "data/General/Title/Palettes/SK Knuckles.bin"
                even
; ---------------------------------------------------------------------------

Obj_SKTitle_SonicFall:
                move.l  #Map_SKTitle_SonicFall,mappings(a0)
                move.w  #make_art_tile(ArtTile_SKTitle_SonicFall,0,0),art_tile(a0)
                move.w  #$E8,x_pos(a0)
                move.w  #$16,y_pos(a0)                  ; Set position of falling Sonic sprite
                move.w  #$80,priority(a0)
                move.b  #$68,width_pixels(a0)
                move.b  #$70,height_pixels(a0)          ; Set effective size of sprite
                move.l  #Obj_SKTitle_SonicFallMain,(a0)

Obj_SKTitle_SonicFallMain:
                cmpi.w  #$F0,y_pos(a0)
                beq.s   SKSoloTitle_GateSonicFallScrollByPhase
                addq.w  #1,y_pos(a0)                    ; Slowly move Sonic downwards

SKSoloTitle_GateSonicFallScrollByPhase:
                cmpi.w  #3,(Events_routine_fg).w
                bne.s   SKSoloTitle_QueueFallingSonic   ; Wait until the proper phase of the title sequence
                ori.w   #high_priority,art_tile(a0)     ; Modify the priority of the sprite
                cmpi.w  #$E0,(Camera_Y_pos).w
                bhs.s   SKSoloTitle_UploadLandingMapAtE0  ; If the foreground Y is past $E0, branch
                addq.w  #8,(Camera_Y_pos).w             ; Otherwise scroll foreground by 8 pixels
                cmpi.w  #$C8,(Camera_Y_pos).w
                bne.s   SKSoloTitle_StreamStandingFrameRow
                lea     (ArtKosM_SonicLand).l,a1        ; Once foreground has hit C8 Y
                move.w  #tiles_to_bytes(ArtTile_SKTitle_SonicKnuxStand+$380),d2
                jsr     (Queue_Kos_Module).l            ; Queue the landing frames into VRAM

SKSoloTitle_StreamStandingFrameRow:
                lea     (RAM_start+$8580).w,a1          ; First frame data (Knuckles only)
                move.l  #vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE),d0
                move.w  (Camera_Y_pos).w,d1
                bsr.w   Copy_Map_Line_To_VRAM           ; Since the nametable is only 32 tiles high, we can't copy the first foreground mapping frame for Sonic and Knuckles wholesale
        ; We set up each line of mappings data every time the screen scrolls down further

SKSoloTitle_QueueFallingSonic:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSoloTitle_UploadLandingMapAtE0:
                bne.s   SKSoloTitle_AdvanceLandingScrollTo100
                move    #$2700,sr                       ; Only do this when screen scrolling has his E0 Y
                lea     (RAM_start+$8E40).w,a1          ; Second frame data (Sonic lands)
                move.l  #vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE),d0
                moveq   #40-1,d1
                moveq   #28-1,d2
                jsr     (Plane_Map_To_VRAM).l           ; Copy the frame data
                move    #$2300,sr
                move.b  #6,anim_frame_timer(a0)         ; Set up an internal timer

SKSoloTitle_AdvanceLandingScrollTo100:
                cmpi.w  #$100,(Camera_Y_pos).w
                beq.s   SKSoloTitle_InstallTimedLandingMapState  ; When screen has hit $100 Y, branch
                addq.w  #8,(Camera_Y_pos).w
                rts
; ---------------------------------------------------------------------------

SKSoloTitle_InstallTimedLandingMapState:
                move.l  #Obj_SKTitle_SonicFallLand,(a0)

Obj_SKTitle_SonicFallLand:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKSoloTitle_LandingMapUpdateReturn
                move    #$2700,sr
                lea     (Block_table+$700).w,a1         ; Get third mapping frame (Sonic starting to stand)
                move.l  #vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE),d0
                moveq   #40-1,d1
                moveq   #28-1,d2
                jsr     (Plane_Map_To_VRAM).l
                move    #$2300,sr
                move.b  #4,anim_frame_timer(a0)
                move.l  #Obj_SKTitle_SonicFallLand_2,(a0)

SKSoloTitle_LandingMapUpdateReturn:
                rts
; ---------------------------------------------------------------------------

Obj_SKTitle_SonicFallLand_2:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   Obj_SKTitle_SonicFallEnd

; =============== S U B R O U T I N E =======================================

Obj_SKTitle_SonicFallFinish:
                move    #$2700,sr
                lea     (Block_table+$FC0).w,a1         ; Get last mapping frame (Sonic and Knuckles standing properly)
                move.l  #vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE),d0
                moveq   #40-1,d1
                moveq   #28-1,d2
                jsr     (Plane_Map_To_VRAM).l
                move    #$2300,sr
                lea     (ArtKosM_SKTitle_Banner).l,a1
                move.w  #tiles_to_bytes(ArtTile_SKTitle_Banner),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_SKTitle_Menu).l,a1
                move.w  #tiles_to_bytes(ArtTile_SKTitle_Menu),d2
                jsr     (Queue_Kos_Module).l            ; Set up the banner and menu graphics to replace the landing graphics
                move.l  #Obj_SKTitle_Banner,(Dynamic_object_RAM).w
                move.b  #30,(Dynamic_object_RAM+anim_frame_timer).w  ; $24 of object set to 30
                move.l  #Obj_SKTitle_SonicFallEnd,(a0)  ; Disable object

Obj_SKTitle_SonicFallEnd:
                rts
; End of function Obj_SKTitle_SonicFallFinish

; ---------------------------------------------------------------------------

Obj_SKTitle_DeathEgg:
                move.l  #Map_SKTitle_DeathEgg,mappings(a0)
                move.w  #make_art_tile(ArtTile_SKTitle_DeathEgg,2,0),art_tile(a0)
                move.w  #$140,x_pos(a0)
                move.w  #$B0,y_pos(a0)
                move.w  #$180,priority(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$40,height_pixels(a0)
                move.l  #Obj_SKTitle_DeathEggMain,(a0)

Obj_SKTitle_DeathEggMain:
                cmpi.w  #$F0,y_pos(a0)
                beq.s   SKSoloTitle_SaveDeathEggBaseAndShake  ; If Death Egg has reached volcano, branch
                addi.l  #$8000,y_pos(a0)                ; Move Death Egg sprite downward
                cmpi.w  #$100,(Camera_Y_pos_P2).w
                beq.s   SKSoloTitle_QueueDescendingDeathEgg
                addq.w  #1,(Camera_Y_pos_P2).w          ; Scroll screen downwards
                lea     (Chunk_table+$7CC0).l,a1
                move.l  #vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0
                move.w  (Camera_Y_pos_P2).w,d1
                bsr.w   Copy_Map_Line_To_VRAM           ; Update second nametable with background mappings as the screen scrolls down

SKSoloTitle_QueueDescendingDeathEgg:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSoloTitle_SaveDeathEggBaseAndShake:
                move.l  x_pos(a0),$2E(a0)
                move.l  y_pos(a0),$32(a0)               ; Backup position values
                move.w  #$8000,(Camera_Y_pos_P2+2).w
                move.w  #$22,(Events_bg+$00).w
                move.w  #1,(Events_routine_fg).w
                move.w  #$1E,(Screen_shake_flag).w
                move.l  #Obj_SKTitle_DeathEggShake,(a0)

Obj_SKTitle_DeathEggShake:
                bsr.w   SKTitle_ScreenShake
                cmpi.w  #$100,(Camera_Y_pos_P2).w
                beq.s   SKSoloTitle_ProjectDeathEggWithShake
                subi.l  #$8000,$32(a0)                  ; Move Death Egg backwards to keep up with scroll
                addi.l  #$8000,(Camera_Y_pos_P2).w
                lea     (Chunk_table+$7CC0).l,a1
                move.l  #vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0
                move.w  (Camera_Y_pos_P2).w,d1
                bsr.w   Copy_Map_Line_To_VRAM           ; Continue drawing mapping lines

SKSoloTitle_ProjectDeathEggWithShake:
                move.w  $2E(a0),d0
                move.w  $32(a0),d1
                tst.w   (Screen_shake_flag).w
                beq.s   SKSoloTitle_StoreAndQueueDeathEgg
                sub.w   (Camera_X_pos_P2_copy).w,d0
                sub.w   (Camera_Y_pos_P2_copy).w,d1     ; Shake Death Egg along with screen

SKSoloTitle_StoreAndQueueDeathEgg:
                move.w  d0,x_pos(a0)
                move.w  d1,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_SKTitle_Mountain:
                move.l  #Map_SKTitle_Mountain,mappings(a0)  ; The top of the mountain is a sprite so it can cover the Death Egg
                move.w  #make_art_tile(ArtTile_SKTitle_Mountain,3,0),art_tile(a0)
                move.w  #$100,priority(a0)
                move.b  #$30,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.l  #Obj_SKTitle_MountainMain,(a0)

Obj_SKTitle_MountainMain:
                move.w  #$140,d0
                move.w  #$1A8,d1
                sub.w   (Camera_X_pos_P2).w,d0
                sub.w   (Camera_Y_pos_P2).w,d1
                tst.w   (Screen_shake_flag).w
                beq.s   SKSoloTitle_StoreMountainWithShake
                sub.w   (Camera_X_pos_P2_copy).w,d0
                sub.w   (Camera_Y_pos_P2_copy).w,d1

SKSoloTitle_StoreMountainWithShake:
                move.w  d0,x_pos(a0)
                move.w  d1,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_SKTitle_Banner:
                subq.b  #1,anim_frame_timer(a0)
                beq.s   SKSoloTitle_InitBannerAfterDelay  ; Wait for the timer to finish
                rts
; ---------------------------------------------------------------------------

SKSoloTitle_InitBannerAfterDelay:
                move.l  #Map_SKTitle_Banner,mappings(a0)
                move.w  #make_art_tile(ArtTile_SKTitle_Banner,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #$7C,width_pixels(a0)
                move.b  #$28,height_pixels(a0)          ; Set up sprite size and priority
                move.w  #$120,x_pos(a0)
                move.w  #$180,y_pos(a0)                 ; Position sprite below the screen
                move.w  #$400,y_vel(a0)                 ; Set up Y velocity
                move.l  #-$600000,$30(a0)               ; Set up Y position offset
                move.l  #Obj_SKTitle_BannerMain,(a0)

Obj_SKTitle_BannerMain:
                move.b  $34(a0),d2
                move.w  y_vel(a0),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,$30(a0)                      ; Add velocity to Y offset
                move.w  $30(a0),d0
                move.b  #0,$34(a0)                      ; Set direction toggle flag
                move.w  #$40,d1
                cmpi.w  #0,d0
                blt.s   SKSoloTitle_BannerUpdateBounce  ; If offset is negative, branch
                bne.s   SKSoloTitle_BannerSelectNegativeAccel  ; If offset is positive and nonzero, branch
                cmpi.w  #-$5B,y_vel(a0)
                bne.s   SKSoloTitle_BannerSelectNegativeAccel  ; Branch if the velocity isn't small enough
                move.l  #Obj_SKTitle_BannerDisplay,(a0)
                move.l  #Obj_SKTitle_Icon,(Dynamic_object_RAM+(object_size*2)).w
                move.l  #Obj_SKTitle_Icon2,(Dynamic_object_RAM+(object_size*3)).w
                move.l  #Obj_SKTitle_TM,(Dynamic_object_RAM+(object_size*4)).w
                move.l  #Obj_SKTitle_Copyright,(Dynamic_object_RAM+(object_size*5)).w  ; Set up menu items and the like
                bra.s   SKSoloTitle_BannerProjectBounceOffset
; ---------------------------------------------------------------------------

SKSoloTitle_BannerSelectNegativeAccel:
                move.b  #-1,$34(a0)                     ; This is all to perform the bobbing motion into place
                move.w  #-$40,d1

; Halve the velocity when it changes direction
SKSoloTitle_BannerUpdateBounce:
                add.w   d1,y_vel(a0)
                cmp.b   $34(a0),d2
                beq.s   SKSoloTitle_BannerProjectBounceOffset
                asr     y_vel(a0)

SKSoloTitle_BannerProjectBounceOffset:
                move.w  $30(a0),d0
                neg.w   d0
                addi.w  #$118,d0
                move.w  d0,y_pos(a0)

Obj_SKTitle_BannerDisplay:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

Obj_SKTitle_HandAnim:
                move.l  #RAM_start+$4800,d1
                move.w  #tiles_to_bytes(ArtTile_SKTitle_SonicKnuxStand+1),d2
                move.w  #$30,d3
                jsr     (Add_To_DMA_Queue).l
                move.l  #RAM_start+$4E40,d1
                move.w  #tiles_to_bytes(ArtTile_SKTitle_SonicKnuxStand+4),d2
                move.w  #$290,d3
                jsr     (Add_To_DMA_Queue).l            ; Load the correct initial art
                move.b  #3*60,$30(a0)
                move.l  #Obj_SKTitle_HandAnimMain,(a0)

Obj_SKTitle_HandAnimMain:
                lea     (SKTitle_AnimSmile).l,a1
                lea     $30(a0),a2
                bsr.w   SKTitle_AnimateHands
                bmi.s   SKSoloTitle_AdvanceSonicFingerArt
                lea     (RAM_start+$4800).l,a1
                lea     (a1,d0.w),a1
                move.l  a1,d1
                move.w  #tiles_to_bytes(ArtTile_SKTitle_SonicKnuxStand+1),d2
                move.w  #$30,d3
                jsr     (Add_To_DMA_Queue).l

SKSoloTitle_AdvanceSonicFingerArt:
                lea     (SKTitle_AnimFinger).l,a1
                lea     $32(a0),a2
                bsr.w   SKTitle_AnimateHands
                bmi.s   SKSoloTitle_AdvanceKnucklesHandArt1
                lea     (RAM_start+$4920).l,a1
                lea     (a1,d0.w),a1
                move.l  a1,d1
                move.w  #tiles_to_bytes(ArtTile_SKTitle_SonicKnuxStand+4),d2
                move.w  #$290,d3
                jsr     (Add_To_DMA_Queue).l

SKSoloTitle_AdvanceKnucklesHandArt1:
                lea     (SKTitle_AnimKnuckle1).l,a1
                lea     $34(a0),a2
                bsr.w   SKTitle_AnimateHands
                bmi.s   SKSoloTitle_AdvanceKnucklesHandArt2
                lea     (RAM_start+$5880).l,a1
                lea     (a1,d0.w),a1
                move.l  a1,d1
                move.w  #tiles_to_bytes(ArtTile_SKTitle_SonicKnuxStand+$2D),d2
                move.w  #$2F0,d3
                jsr     (Add_To_DMA_Queue).l

SKSoloTitle_AdvanceKnucklesHandArt2:
                lea     (SKTitle_AnimKnuckle2).l,a1
                lea     $36(a0),a2
                bsr.w   SKTitle_AnimateHands
                bmi.s   SKSoloTitle_HandArtUpdateReturn
                lea     (RAM_start+$6A20).l,a1
                lea     (a1,d0.w),a1
                move.l  a1,d1
                move.w  #tiles_to_bytes(ArtTile_SKTitle_SonicKnuxStand+$5C),d2
                move.w  #$140,d3
                jsr     (Add_To_DMA_Queue).l

SKSoloTitle_HandArtUpdateReturn:
                rts
; End of function Obj_SKTitle_HandAnim

; =============== S U B R O U T I N E =======================================

SKTitle_AnimateHands:
                subq.b  #1,(a2)
                bcc.s   SKSoloTitle_HandFrameNoUpdate
                move.b  (a1),(a2)
                moveq   #0,d1
                move.b  1(a2),d1
                move.b  1(a1,d1.w),d0
                bmi.s   SKSoloTitle_RestartHandSeqOnMinusOne

SKSoloTitle_AdvanceHandFrameAndGetOffset:
                addq.b  #1,1(a2)
                ext.w   d0
                lsl.w   #5,d0
                rts
; ---------------------------------------------------------------------------

SKSoloTitle_HandFrameNoUpdate:
                moveq   #-1,d0
                rts
; ---------------------------------------------------------------------------

SKSoloTitle_RestartHandSeqOnMinusOne:
                addq.b  #1,d0
                bne.s   SKSoloTitle_RewindHandSeqOnMinusTwo
                move.b  #0,1(a2)
                move.b  1(a1),d0
                bra.s   SKSoloTitle_AdvanceHandFrameAndGetOffset
; ---------------------------------------------------------------------------

SKSoloTitle_RewindHandSeqOnMinusTwo:
                addq.b  #1,d0
                bne.s   SKSoloTitle_HandFrameNoUpdate
                move.b  2(a1,d1.w),d0
                sub.b   d0,1(a2)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   SKSoloTitle_AdvanceHandFrameAndGetOffset
; End of function sub_5A50
