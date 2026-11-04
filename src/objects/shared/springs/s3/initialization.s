; Owner: objects/shared/springs/s3
; Responsibility: Spring orientation, art and competition variant selection with launch strength tables
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Obj_Spring:
                move.l  #Map_Spring,mappings(a0)
                move.w  #make_art_tile(ArtTile_SpikesSprings+$10,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$200,priority(a0)
                move.w  x_pos(a0),$32(a0)
                move.w  y_pos(a0),$34(a0)
                move.b  subtype(a0),d0
                lsr.w   #3,d0
                andi.w  #$E,d0
                move.w  Spring_Index(pc,d0.w),d0
                jmp     Spring_Index(pc,d0.w)
; End of function Obj_Spring

; ---------------------------------------------------------------------------
Spring_Index:
                dc.w    Spring_Up-Spring_Index
                dc.w    Spring_Horizontal-Spring_Index
                dc.w    Spring_Down-Spring_Index
                dc.w    Spring_UpDiag-Spring_Index
                dc.w    Spring_DownDiag-Spring_Index

; =============== S U B R O U T I N E =======================================

InitCompetitionRetractingSpring:
                move.l  #Map_Spring,mappings(a0)
                move.w  #make_art_tile(ArtTile_SpikesSprings+$10,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$200,priority(a0)
                move.w  x_pos(a0),$32(a0)
                move.w  y_pos(a0),$34(a0)
                move.b  subtype(a0),d0
                lsr.w   #3,d0
                andi.w  #$E,d0
                move.w  S3Spring_RetractingOrientationOffsets(pc,d0.w),d0
                jsr     S3Spring_RetractingOrientationOffsets(pc,d0.w)
                move.w  #-$800,$30(a0)
                rts
; End of function InitCompetitionRetractingSpring

; ---------------------------------------------------------------------------
S3Spring_RetractingOrientationOffsets:
                dc.w    Spring_Up-S3Spring_RetractingOrientationOffsets
                dc.w    Spring_Horizontal-S3Spring_RetractingOrientationOffsets
                dc.w    Spring_Down-S3Spring_RetractingOrientationOffsets
                dc.w    Spring_Horizontal-S3Spring_RetractingOrientationOffsets
                dc.w    Spring_Up-S3Spring_RetractingOrientationOffsets
                dc.w    Spring_Down-S3Spring_RetractingOrientationOffsets
                dc.w    Spring_Up-S3Spring_RetractingOrientationOffsets
                dc.w    Spring_Down-S3Spring_RetractingOrientationOffsets
; ---------------------------------------------------------------------------

Spring_Horizontal:
                move.b  #2,anim(a0)
                move.b  #3,mapping_frame(a0)
                move.w  #make_art_tile(ArtTile_SpikesSprings+$20,0,0),art_tile(a0)
                move.b  #8,width_pixels(a0)
                move.l  #Obj_Spring_Horizontal,(a0)
                tst.w   (Competition_mode).w
                beq.w   Spring_Common
                move.l  #Map_2PSpring,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PArt_1,0,0),art_tile(a0)
                move.l  #Obj_2PSpring_Horizontal,(a0)
                bra.w   Spring_Common
; ---------------------------------------------------------------------------

Spring_Down:
                move.b  #6,mapping_frame(a0)
                bset    #1,status(a0)
                move.l  #Obj_Spring_Down,(a0)
                tst.w   (Competition_mode).w
                beq.w   Spring_Common
                move.l  #Obj_2PSpring_Down,(a0)
                move.l  #Map_2PSpring,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PArt_2,0,0),art_tile(a0)
                bra.w   Spring_Common
; ---------------------------------------------------------------------------

Spring_UpDiag:
                move.b  #4,anim(a0)
                move.b  #7,mapping_frame(a0)
                move.w  #make_art_tile(ArtTile_DiagonalSpring,0,0),art_tile(a0)
                cmpi.b  #2,(Current_zone).w
                bne.s   S3Spring_InstallUpDiagonalHandler
                move.w  #make_art_tile(ArtTile_MGZMHZDiagonalSpring,0,0),art_tile(a0)

S3Spring_InstallUpDiagonalHandler:
                move.l  #Obj_Spring_UpDiag,(a0)
                bra.s   Spring_Common
; ---------------------------------------------------------------------------

Spring_DownDiag:
                move.b  #4,anim(a0)
                move.b  #$A,mapping_frame(a0)
                move.w  #make_art_tile(ArtTile_DiagonalSpring,0,0),art_tile(a0)
                cmpi.b  #2,(Current_zone).w
                bne.s   S3Spring_InstallDownDiagonalHandler
                move.w  #make_art_tile(ArtTile_MGZMHZDiagonalSpring,0,0),art_tile(a0)

S3Spring_InstallDownDiagonalHandler:
                bset    #1,status(a0)
                move.l  #Obj_Spring_DownDiag,(a0)
                bra.s   Spring_Common
; ---------------------------------------------------------------------------

Spring_Up:
                move.l  #Obj_Spring_Up,(a0)
                tst.w   (Competition_mode).w
                beq.s   Spring_Common
                move.l  #Obj_2PSpring_Up,(a0)
                move.l  #Map_2PSpring,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PArt_2,0,0),art_tile(a0)
                cmpi.b  #$12,(Current_zone).w
                bne.s   Spring_Common
                ori.w   #high_priority,art_tile(a0)

Spring_Common:
                move.b  subtype(a0),d0
                andi.w  #2,d0
                move.w  S3Spring_LaunchStrengthWords(pc,d0.w),$30(a0)
                btst    #1,d0
                beq.s   S3Spring_InitReturn
                move.l  #Map_Spring2,mappings(a0)
                tst.w   (Competition_mode).w
                beq.s   S3Spring_InitReturn
                move.l  #Map_Spring3,mappings(a0)

S3Spring_InitReturn:
                rts
; ---------------------------------------------------------------------------
S3Spring_LaunchStrengthWords:
                dc.w    -$1000
                dc.w    -$A00
