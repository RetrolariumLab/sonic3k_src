; Owner: objects/ending/sk
; Responsibility: Ending cloud generator, seeded velocity or position selection and individual cloud movement
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

EndCloud_InitFieldPaletteAndArt:
                move.l  #EndCloud_TickCadenceAndTrySpawn,(a0)
                move.l  (V_int_run_count).w,(RNG_seed).w
                lea     (Pal_FBZCloud).l,a1
                lea     (Normal_palette).w,a2
                cmpi.w  #3,(Player_mode).w
                beq.s   EndingCloudField_PreparePaletteCopyCount
                lea     (Normal_palette_line_2).w,a2

EndingCloudField_PreparePaletteCopyCount:
                moveq   #bytesToLcnt($10),d0

EndingCloudField_CopyPaletteAndQueueArt:
                move.l  (a1)+,(a2)+
                dbf     d0,EndingCloudField_CopyPaletteAndQueueArt
                lea     (ArtKosM_FBZCloud).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_Cloud),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

EndCloud_TickCadenceAndTrySpawn:
                tst.b   (EndingCloudSpawnFrameMask).w
                beq.w   EndingChild_DeleteCurrentActor
                move.b  (V_int_run_count+3).w,d0
                and.b   (EndingCloudSpawnFrameMask).w,d0
                bne.w   EndingCloudField_ReturnFromSpawnAttempt
                addq.b  #1,$39(a0)
                jsr     (AllocateObject).l
                bne.w   EndingCloudField_ReturnFromSpawnAttempt
                jsr     (Random_Number).l
                move.l  #EndingCloud_InitializeMappingAndPalette,(a1)
                move.b  d0,subtype(a1)
                move.w  (EndingCloudHorizontalBaseVelocity).w,d2
                beq.s   EndCloud_ComputeRandomYVelocity
                move.w  d0,d1
                andi.w  #$3F,d1
                tst.w   d2
                bpl.s   EndCloud_StoreRandomXVelocity
                neg.w   d1

EndCloud_StoreRandomXVelocity:
                add.w   d2,d1
                move.w  d1,x_vel(a1)

EndCloud_ComputeRandomYVelocity:
                move.w  (EndingCloudVerticalBaseVelocity).w,d3
                beq.s   EndCloud_SelectSpawnEdgeAxis
                move.l  d0,d1
                swap    d1
                andi.w  #$3F,d1
                tst.w   d3
                bpl.s   EndCloud_StoreRandomYVelocity
                neg.w   d1

EndCloud_StoreRandomYVelocity:
                add.w   d3,d1
                move.w  d1,y_vel(a1)

EndCloud_SelectSpawnEdgeAxis:
                tst.w   d2
                beq.s   EndingCloudField_SelectVerticalEdgeY
                tst.w   d3
                beq.s   EndingCloudField_SelectHorizontalEdgeX
                btst    #0,$39(a0)
                bne.s   EndingCloudField_SelectVerticalEdgeY

EndingCloudField_SelectHorizontalEdgeX:
                move.w  #$50,d1
                tst.w   d2
                bpl.s   EndCloud_SetHorizontalEdgePosition
                move.w  #$1F0,d1

EndCloud_SetHorizontalEdgePosition:
                move.w  d1,x_pos(a1)
                move.w  d0,d1
                andi.w  #$FF,d1
                addi.w  #$80,d1
                move.w  d1,y_pos(a1)
                bra.w   EndCloud_SelectFrameByRandomSign
; ---------------------------------------------------------------------------

EndingCloudField_SelectVerticalEdgeY:
                move.w  #$60,d1
                tst.w   d3
                bpl.s   EndingCloudField_FoldRandomVerticalEdgeX
                move.w  #$180,d1

EndingCloudField_FoldRandomVerticalEdgeX:
                move.w  d1,y_pos(a1)
                move.w  d0,d1
                andi.w  #$1FF,d1
                move.w  d1,d2
                subi.w  #$160,d2
                bcs.s   EndingCloudField_StoreVerticalEdgeX
                add.w   d2,d2
                addi.w  #$10,d2
                move.w  d2,d1

EndingCloudField_StoreVerticalEdgeX:
                addi.w  #$70,d1
                move.w  d1,x_pos(a1)

EndCloud_SelectFrameByRandomSign:
                moveq   #1,d1
                tst.w   d0
                bpl.s   EndingCloudField_StoreSpawnedCloudFrame
                moveq   #3,d1

EndingCloudField_StoreSpawnedCloudFrame:
                move.b  d1,mapping_frame(a1)

EndingCloudField_ReturnFromSpawnAttempt:
                rts
; ---------------------------------------------------------------------------

EndingCloud_InitializeMappingAndPalette:
                move.l  #EndCloud_MoveXWithBaseVelocity,(a0)
                move.l  #Map_FBZ2Preboss,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Cloud,0,0),art_tile(a0)
                cmpi.w  #3,(Player_mode).w
                beq.s   EndingCloud_SetBoundsAndPriority
                move.w  #make_art_tile(ArtTile_Ending_Cloud,1,0),art_tile(a0)

EndingCloud_SetBoundsAndPriority:
                move.w  #$300,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$10,height_pixels(a0)

EndCloud_MoveXWithBaseVelocity:
                move.w  (EndingCloudHorizontalBaseVelocity).w,d0
                beq.s   EndCloud_MoveYWithBaseVelocity
                move.w  x_vel(a0),d1
                add.w   d0,d1
                ext.l   d1
                lsl.l   #8,d1
                add.l   d1,x_pos(a0)

EndCloud_MoveYWithBaseVelocity:
                move.w  (EndingCloudVerticalBaseVelocity).w,d2
                beq.s   EndCloud_CullOutsideScreenWindow
                move.w  y_vel(a0),d3
                add.w   d2,d3
                ext.l   d3
                lsl.l   #8,d3
                add.l   d3,y_pos(a0)

EndCloud_CullOutsideScreenWindow:
                cmpi.w  #$200,x_pos(a0)
                bhs.w   EndingChild_DeleteCurrentActor
                cmpi.w  #$200,y_pos(a0)
                bhs.w   EndingChild_DeleteCurrentActor
                jmp     (Draw_Sprite).l
