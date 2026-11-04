; Owner: rendering/zones/lrz/sk
; Responsibility: Lava Reef foreground rock sprite selection, projection and private sprite piece data
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Draw_LRZ_Special_Rock_Sprites:
                moveq   #0,d0
                move.b  (LRZ_rocks_routine).w,d0
                move.w  Draw_LRZ_Special_Rock_Sprites_Index(pc,d0.w),d0
                jmp     Draw_LRZ_Special_Rock_Sprites_Index(pc,d0.w)
; ---------------------------------------------------------------------------
Draw_LRZ_Special_Rock_Sprites_Index:
                dc.w    SKLRZRocks_SelectActPlacementList-Draw_LRZ_Special_Rock_Sprites_Index
                dc.w    SKLRZRocks_UpdateWindow-Draw_LRZ_Special_Rock_Sprites_Index
; ---------------------------------------------------------------------------

SKLRZRocks_SelectActPlacementList:
                addq.b  #2,(LRZ_rocks_routine).w
                lea     (LRZ1_Rock_Placement).l,a1
                tst.b   (Current_act).w
                beq.s   SKLRZRocks_CalcInitialLeftLimit
                lea     (LRZ2_Rock_Placement).l,a1

SKLRZRocks_CalcInitialLeftLimit:
                move.w  (Camera_X_pos).w,d4
                subq.w  #8,d4
                bhi.s   SKLRZRocks_FindInitialFront
                moveq   #1,d4
                bra.s   SKLRZRocks_FindInitialFront
; ---------------------------------------------------------------------------

SKLRZRocks_NextInitialFrontRecord:
                addq.l  #6,a1

SKLRZRocks_FindInitialFront:
                cmp.w   2(a1),d4
                bhi.s   SKLRZRocks_NextInitialFrontRecord
                move.l  a1,(LRZ_rocks_addr_front).w
                addi.w  #$150,d4
                bra.s   SKLRZRocks_FindInitialBack
; ---------------------------------------------------------------------------

SKLRZRocks_NextInitialBackRecord:
                addq.l  #6,a1

SKLRZRocks_FindInitialBack:
                cmp.w   2(a1),d4
                bhi.s   SKLRZRocks_NextInitialBackRecord
                move.l  a1,(LRZ_rocks_addr_back).w
                rts
; ---------------------------------------------------------------------------

SKLRZRocks_UpdateWindow:
                movea.l (LRZ_rocks_addr_front).w,a1
                move.w  (Camera_X_pos).w,d4
                subq.w  #8,d4
                bhi.s   SKLRZRocks_ScanFrontForward
                moveq   #1,d4
                bra.s   SKLRZRocks_ScanFrontForward
; ---------------------------------------------------------------------------

SKLRZRocks_AdvanceFrontCursor:
                addq.l  #6,a1

SKLRZRocks_ScanFrontForward:
                cmp.w   2(a1),d4
                bhi.s   SKLRZRocks_AdvanceFrontCursor
                bra.s   SKLRZRocks_StoreFrontAndSetRightLimit
; ---------------------------------------------------------------------------

SKLRZRocks_RetreatFrontCursor:
                subq.l  #6,a1

SKLRZRocks_StoreFrontAndSetRightLimit:
                cmp.w   -4(a1),d4
                bls.s   SKLRZRocks_RetreatFrontCursor
                move.l  a1,(LRZ_rocks_addr_front).w
                movea.l (LRZ_rocks_addr_back).w,a2
                addi.w  #$150,d4
                bra.s   SKLRZRocks_ScanBackForward
; ---------------------------------------------------------------------------

SKLRZRocks_AdvanceBackCursor:
                addq.l  #6,a2

SKLRZRocks_ScanBackForward:
                cmp.w   2(a2),d4
                bhi.s   SKLRZRocks_AdvanceBackCursor
                bra.s   SKLRZRocks_StoreExclusiveBack
; ---------------------------------------------------------------------------

SKLRZRocks_RetreatBackCursor:
                subq.l  #6,a2

SKLRZRocks_StoreExclusiveBack:
                cmp.w   -4(a2),d4
                bls.s   SKLRZRocks_RetreatBackCursor
                move.l  a2,(LRZ_rocks_addr_back).w
                rts
; End of function Draw_LRZ_Special_Rock_Sprites

; =============== S U B R O U T I N E =======================================

RenderLRZForegroundRockPieces:
                movea.l (LRZ_rocks_addr_front).w,a0
                move.l  (LRZ_rocks_addr_back).w,d2
                sub.l   a0,d2
                beq.s   SKLRZRocks_RockWindowReturn
                lea     LRZ_Rock_SpriteData(pc),a1
                move.w  #120,d3
                move.w  4(a3),d4
                move.w  #240,d5

SKLRZRocks_ProjectAndWriteRockSprite:
                move.w  4(a0),d1
                sub.w   d4,d1
                addq.w  #8,d1
                cmp.w   d5,d1
                bhs.s   SKLRZRocks_NextVisibleRock
                add.w   d3,d1
                move.w  2(a0),d0
                sub.w   (a3),d0
                addi.w  #128,d0
                move.w  (a0),d6
                lsl.w   #3,d6
                lea     (a1,d6.w),a2
                add.w   (a2)+,d1
                move.w  d1,(a6)+
                move.w  (a2)+,d6
                move.b  d6,(a6)
                addq.w  #2,a6
                move.w  (a2)+,(a6)+
                add.w   (a2)+,d0
                move.w  d0,(a6)+
                subq.w  #1,d7

SKLRZRocks_NextVisibleRock:
                addq.l  #6,a0
                subq.w  #6,d2
                bne.s   SKLRZRocks_ProjectAndWriteRockSprite

SKLRZRocks_RockWindowReturn:
                rts
; End of function RenderLRZForegroundRockPieces

; ---------------------------------------------------------------------------
LRZ_Rock_SpriteData:
                binclude "data/Levels/LRZ/Misc/Rock Sprite Attribute Data.bin"
                even
