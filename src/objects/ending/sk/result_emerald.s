; Owner: objects/ending/sk
; Responsibility: Result Master Emerald display, private placement, palette fade and graphics load
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

EndResultEmerald_InitPlacementAndArt:
                lea     EndingResultEmerald_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #2,render_flags(a0)
                move.l  #EndingResultEmerald_Draw,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     EndingResultEmerald_PlacementPairs(pc,d0.w),a1
                move.w  (a1)+,x_pos(a0)
                move.w  (a1)+,y_pos(a0)
                lea     (Pal_EndingMasterEmerald).l,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($20),d6

EndResultEmerald_CopyPaletteAndTryFadeIn:
                move.l  (a1)+,(a2)+
                dbf     d6,EndResultEmerald_CopyPaletteAndTryFadeIn
                jsr     (AllocateObject).l
                bne.s   EndingResultEmerald_QueueArt
                move.w  a1,$44(a0)
                move.l  #Obj_FadeSelectedFromBlack,(a1)
                moveq   #5,d0
                move.w  d0,$3A(a1)
                move.w  d0,$2E(a1)
                move.w  #$F,$3C(a1)
                move.w  #Normal_palette,$30(a1)
                move.w  #Target_palette,$32(a1)

EndingResultEmerald_QueueArt:
                lea     (ArtKosM_EndingMasterEmerald).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_MasterEmerald),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------
EndingResultEmerald_PlacementPairs:
                dc.w    $120,  $100
                dc.w    $130,   $F4
; ---------------------------------------------------------------------------

EndingResultEmerald_Draw:
                jmp     (Draw_Sprite).l
; End of function EndResultEmerald_InitPlacementAndArt
