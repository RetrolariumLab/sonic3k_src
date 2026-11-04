; Owner: rendering/zones/aiz/s3
; Responsibility: Angel Island tile-animation decisions for the two acts
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

AnimateTiles_AIZ1:
                tst.b   (Boss_flag).w
                bne.s   S3AIZ1Tiles_UpdateReturn
                tst.b   (Dynamic_resize_routine).w
                bne.w   AnimateTiles_DoAniPLC

S3AIZ1Tiles_UpdateReturn:
                rts
; ---------------------------------------------------------------------------

AnimateTiles_AIZ2:
                tst.b   (Boss_flag).w
                bne.s   S3AIZ2Tiles_UpdateReturn
                cmpi.w  #$1C0,(Camera_X_pos).w
                bhs.w   AnimateTiles_DoAniPLC
                lea     (Anim_Counters).w,a3
                addq.w  #2,a2
                moveq   #0,d6
                bsr.w   AnimateTiles_DoAniPLC_Part2
                clr.l   (a3)
                clr.l   (a3)
                move.l  #ArtUnc_AniAIZ2_FirstTree,d1
                move.w  #tiles_to_bytes($0CA),d2
                move.w  #$230,d3
                jmp     (Add_To_DMA_Queue).l
; ---------------------------------------------------------------------------

S3AIZ2Tiles_UpdateReturn:
                rts
