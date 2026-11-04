; Owner: rendering/s3
; Responsibility: Two-times pixel scaling, single-tile scaling and left or right pixel expansion helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Scale_2x:
                move.w  d1,d2
                andi.w  #1,d2
                addq.w  #1,d2
                lsl.w   #6,d2
                swap    d2
                move.w  d1,d3
                lsr.w   #1,d3
                addq.w  #1,d3
                lsl.w   #6,d3
                swap    d3
                bsr.w   Scale2x_ExpandSpriteTileGroup
                btst    #1,d0
                beq.w   locret_432D8
                btst    #1,d1
                bne.s   S3Scale2x_ExpandSecondGroup
                movea.l a3,a5

S3Scale2x_ExpandSecondGroup:
                movea.l a5,a2
; End of function Scale_2x

; =============== S U B R O U T I N E =======================================

Scale2x_ExpandSpriteTileGroup:
                movea.l a2,a4
                swap    d2
                lea     (a2,d2.w),a3
                swap    d2
                move.w  d1,d5
                andi.w  #1,d5
                bsr.w   Scale2x_SingleTile
                btst    #1,d1
                beq.s   S3Scale2x_CheckAdjacentColumn
                swap    d2
                move.w  d2,d4
                swap    d2
                add.w   d4,d4
                move.w  d0,d3
                andi.w  #1,d3
                lsl.w   d3,d4
                adda.w  d4,a4
                move.w  d1,d5
                lsr.w   #1,d5
                swap    d3
                lea     (a4,d3.w),a5
                swap    d3
                bsr.w   Scale2x_SingleTile2

S3Scale2x_CheckAdjacentColumn:
                btst    #0,d0
                bne.s   S3Scale2x_ExpandAdjacentColumn
                btst    #1,d0
                beq.s   S3Scale2x_ReturnAfterSelectedTileGroups

S3Scale2x_ExpandAdjacentColumn:
                swap    d2
                lea     (a2,d2.w),a2
                lea     (a2,d2.w),a3
                swap    d2
                move.w  d1,d5
                andi.w  #1,d5
                bsr.w   Scale2x_SingleTile
                btst    #1,d1
                beq.s   S3Scale2x_ReturnAfterSelectedTileGroups
                move.w  d1,d5
                lsr.w   #1,d5
                swap    d3
                lea     (a4,d3.w),a4
                lea     (a4,d3.w),a5
                swap    d3
                bsr.w   Scale2x_SingleTile2

S3Scale2x_ReturnAfterSelectedTileGroups:
                rts
; End of function Scale2x_ExpandSpriteTileGroup

; =============== S U B R O U T I N E =======================================

Scale2x_SingleTile:
                moveq   #8-1,d6

                .loop:
                bsr.w   Scale_2x_LeftPixels
                addq.w  #4,a2
                bsr.w   Scale_2x_RightPixels
                addq.w  #4,a3
                dbf     d6,.loop
                dbf     d5,Scale2x_SingleTile
                rts
; End of function Scale2x_SingleTile

; =============== S U B R O U T I N E =======================================

Scale2x_SingleTile2:
                moveq   #8-1,d6

                .loop:
                bsr.w   Scale_2x_LeftPixels2
                addq.w  #4,a4
                bsr.w   Scale_2x_RightPixels2
                addq.w  #4,a5
                dbf     d6,.loop
                dbf     d5,Scale2x_SingleTile2
                rts
; End of function Scale2x_SingleTile2

; =============== S U B R O U T I N E =======================================

Scale_2x_LeftPixels:
                bsr.w   S3Scale2x_ExpandByteLeft

S3Scale2x_ExpandByteLeft:
                move.b  (a1)+,d2
                move.b  d2,d3
                andi.b  #$F0,d2
                move.b  d2,d4
                lsr.b   #4,d4
                or.b    d2,d4
                move.b  d4,(a2)+
                move.b  d4,3(a2)
                andi.b  #$F,d3
                move.b  d3,d4
                lsl.b   #4,d4
                or.b    d3,d4
                move.b  d4,(a2)+
                move.b  d4,3(a2)
                rts
; End of function Scale_2x_LeftPixels

; =============== S U B R O U T I N E =======================================

Scale_2x_RightPixels:
                bsr.w   S3Scale2x_ExpandByteRight

S3Scale2x_ExpandByteRight:
                move.b  (a1)+,d2
                move.b  d2,d3
                andi.b  #$F0,d2
                move.b  d2,d4
                lsr.b   #4,d4
                or.b    d2,d4
                move.b  d4,(a3)+
                move.b  d4,3(a3)
                andi.b  #$F,d3
                move.b  d3,d4
                lsl.b   #4,d4
                or.b    d3,d4
                move.b  d4,(a3)+
                move.b  d4,3(a3)
                rts
; End of function Scale_2x_RightPixels

; =============== S U B R O U T I N E =======================================

Scale_2x_LeftPixels2:
                bsr.w   S3Scale2x_ExpandByteLeftGroup2

S3Scale2x_ExpandByteLeftGroup2:
                move.b  (a1)+,d2
                move.b  d2,d3
                andi.b  #$F0,d2
                move.b  d2,d4
                lsr.b   #4,d4
                or.b    d2,d4
                move.b  d4,(a4)+
                move.b  d4,3(a4)
                andi.b  #$F,d3
                move.b  d3,d4
                lsl.b   #4,d4
                or.b    d3,d4
                move.b  d4,(a4)+
                move.b  d4,3(a4)
                rts
; End of function Scale_2x_LeftPixels2

; =============== S U B R O U T I N E =======================================

Scale_2x_RightPixels2:
                bsr.w   S3Scale2x_ExpandByteRightGroup2

S3Scale2x_ExpandByteRightGroup2:
                move.b  (a1)+,d2
                move.b  d2,d3
                andi.b  #$F0,d2
                move.b  d2,d4
                lsr.b   #4,d4
                or.b    d2,d4
                move.b  d4,(a5)+
                move.b  d4,3(a5)
                andi.b  #$F,d3
                move.b  d3,d4
                lsl.b   #4,d4
                or.b    d3,d4
                move.b  d4,(a5)+
                move.b  d4,3(a5)
                rts
; End of function Scale_2x_RightPixels2
