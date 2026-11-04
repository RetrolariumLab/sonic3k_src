; Owner: objects/ending/sk
; Responsibility: Eggman and EggRobo ending eyecatch state machines, attached effects and palette or graphics preparation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

EndingEggmanEyecatch_Initialize:
                lea     EndingEggmanEyecatch_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #EndVillain_AnimateEggmanAndCheckExit,(a0)
                bclr    #2,render_flags(a0)
                move.w  #$110,x_pos(a0)
                move.w  #$F0,y_pos(a0)
                move.w  #$4AF,$2E(a0)
                lea     (Pal_EndingEyecatchEggman).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

EndVillain_CopyEggmanPaletteAndLoadArt:
                move.l  (a1)+,(a2)+
                dbf     d6,EndVillain_CopyEggmanPaletteAndLoadArt
                bsr.w   Ending_TrySpawnLine2Fade
                lea     (ArtKosM_RobotnikSmug).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_EyecatchEggman),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

EndVillain_AnimateEggmanAndCheckExit:
                lea     EndingEggmanEyecatch_RawAnimation(pc),a1
                jsr     (Animate_RawNoSST).l
                bra.w   EndBanner_DrawUntilStartOrTimeout
; ---------------------------------------------------------------------------

EndVillain_DispatchEggRoboAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  EndingEggRoboEyecatch_StateOffsets(pc,d0.w),d1
                jsr     EndingEggRoboEyecatch_StateOffsets(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
EndingEggRoboEyecatch_StateOffsets:
                dc.w    EndingEggRoboEyecatch_Initialize-EndingEggRoboEyecatch_StateOffsets
                dc.w    EndVillain_WaitForDetailSignal-EndingEggRoboEyecatch_StateOffsets
                dc.w    EndVillain_RaiseEggRoboFor32Updates-EndingEggRoboEyecatch_StateOffsets
                dc.w    EndVillain_AnimateEggRoboAndCheckExit-EndingEggRoboEyecatch_StateOffsets
; ---------------------------------------------------------------------------

EndingEggRoboEyecatch_Initialize:
                lea     EndingEggRoboEyecatch_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #2,render_flags(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$108,y_pos(a0)
                move.w  #$EF,$2E(a0)
                lea     (Pal_EndingEyecatchEggRobo).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

EndVillain_CopyEggRoboPalAndSpawnDetails:
                move.l  (a1)+,(a2)+
                dbf     d6,EndVillain_CopyEggRoboPalAndSpawnDetails
                bsr.w   Ending_TrySpawnLine2Fade
                lea     EndingEggRoboEyecatch_DetailChildRecords(pc),a2
                jsr     (CreateChild1_Normal).l
                jsr     (AllocateObject).l
                bne.s   EndingEggRoboEyecatch_QueueArt
                move.w  a1,parent3(a1)
                move.l  #SpriteMask_InitializeMappingsAndSubtype,(a1)
                move.w  #$120,x_pos(a1)
                move.w  #$124,y_pos(a1)
                move.b  #$8A,subtype(a1)

EndingEggRoboEyecatch_QueueArt:
                lea     (ArtKosM_EggRoboSKEnding).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_EyecatchEggRobo),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

EndVillain_WaitForDetailSignal:
                btst    #2,$38(a0)
                beq.s   EndVillain_DetailSignalWaitReturn
                move.b  #4,routine(a0)
                move.w  #$1F,$2E(a0)

EndVillain_DetailSignalWaitReturn:
                rts
; ---------------------------------------------------------------------------

EndVillain_RaiseEggRoboFor32Updates:
                subq.w  #1,y_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.s   EndVillain_EggRoboRiseReturn
                move.b  #6,routine(a0)
                move.w  #$4AF,$2E(a0)

EndVillain_EggRoboRiseReturn:
                rts
; ---------------------------------------------------------------------------

EndVillain_AnimateEggRoboAndCheckExit:
                lea     EndingEggRoboEyecatch_RawAnimation(pc),a1
                jsr     (Animate_RawNoSST).l
                bra.w   EndBanner_DrawUntilStartOrTimeout
; ---------------------------------------------------------------------------

EndingEggRoboFixedDetail_Initialize:
                lea     EndData_EggRoboFixedDetailPartAttrs(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Draw_Sprite,(a0)
                bclr    #2,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

EndVillain_InitSignalDetailDelay:
                lea     EndData_EggRoboSignalDetailPartAttrs(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                bclr    #2,render_flags(a0)
                move.l  #EndVillain_TickDelayBeforeAnim,(a0)
                move.w  #(2*60)-1,$2E(a0)

EndVillain_TickDelayBeforeAnim:
                subq.w  #1,$2E(a0)
                bpl.s   EndVillain_SignalDetailDelayReturn
                move.l  #EndVillain_AnimateDetailUntilCallback,(a0)
                move.l  #EndVillain_SignalParentAndBeginFollow,$34(a0)

EndVillain_SignalDetailDelayReturn:
                rts
; ---------------------------------------------------------------------------

EndVillain_AnimateDetailUntilCallback:
                lea     EndData_EggRoboSignalDetailAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndVillain_SignalParentAndBeginFollow:
                move.l  #EndVillain_SelectOffsetFromParentFrame,(a0)
                movea.w parent3(a0),a1
                bset    #2,$38(a1)
                rts
; ---------------------------------------------------------------------------

EndVillain_SelectOffsetFromParentFrame:
                move.b  #-$14,child_dy(a0)
                movea.w parent3(a0),a1
                tst.b   mapping_frame(a1)
                beq.s   EndingEggRoboSignalDetail_FollowAndDraw
                move.b  #-$13,child_dy(a0)

EndingEggRoboSignalDetail_FollowAndDraw:
                jsr     (Refresh_ChildPosition).l
                jmp     (Draw_Sprite).l
