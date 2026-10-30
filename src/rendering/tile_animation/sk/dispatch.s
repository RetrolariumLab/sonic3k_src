; Owner: rendering/tile_animation/sk
; Responsibility: Zone tile-animation dispatch, paired function and script indices and null handler
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Animate_Tiles:
                moveq   #0,d0
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #5,d0
                andi.w  #$FC,d0
                move.w  Offs_AniPLC(pc,d0.w),d1
                lea     Offs_AniFunc(pc,d1.w),a2
                move.w  Offs_AniFunc(pc,d0.w),d0
                jmp     Offs_AniFunc(pc,d0.w)
; End of function Animate_Tiles

; ---------------------------------------------------------------------------
; unused
                rts
; ---------------------------------------------------------------------------
Offs_AniFunc:   dc.w    AnimateTiles_AIZ1-Offs_AniFunc
Offs_AniPLC:    dc.w    AniPLC_AIZ1-Offs_AniFunc
                dc.w    AnimateTiles_AIZ2-Offs_AniFunc
                dc.w    AniPLC_AIZ2-Offs_AniFunc
                dc.w    AnimateTiles_HCZ1-Offs_AniFunc
                dc.w    AniPLC_HCZ1-Offs_AniFunc
                dc.w    AnimateTiles_HCZ2-Offs_AniFunc
                dc.w    AniPLC_HCZ2-Offs_AniFunc
                dc.w    AnimateTiles_MGZ-Offs_AniFunc
                dc.w    AniPLC_MGZ-Offs_AniFunc
                dc.w    AnimateTiles_MGZ-Offs_AniFunc
                dc.w    AniPLC_MGZ-Offs_AniFunc
                dc.w    AnimateTiles_CNZ-Offs_AniFunc
                dc.w    AniPLC_CNZ-Offs_AniFunc
                dc.w    AnimateTiles_CNZ-Offs_AniFunc
                dc.w    AniPLC_CNZ-Offs_AniFunc
                dc.w    AnimateTiles_DoAniPLC-Offs_AniFunc
                dc.w    AniPLC_FBZ1-Offs_AniFunc
                dc.w    AnimateTiles_DoAniPLC-Offs_AniFunc
                dc.w    AniPLC_FBZ2-Offs_AniFunc
                dc.w    AnimateTiles_ICZ-Offs_AniFunc
                dc.w    AniPLC_ICZ-Offs_AniFunc
                dc.w    AnimateTiles_ICZ-Offs_AniFunc
                dc.w    AniPLC_ICZ-Offs_AniFunc
                dc.w    AnimateTiles_LBZ1-Offs_AniFunc
                dc.w    AniPLC_LBZ1-Offs_AniFunc
                dc.w    AnimateTiles_LBZ2-Offs_AniFunc
                dc.w    AniPLC_LBZ2-Offs_AniFunc
                dc.w    AnimateTiles_MHZ-Offs_AniFunc
                dc.w    AniPLC_MHZ-Offs_AniFunc
                dc.w    AnimateTiles_MHZ-Offs_AniFunc
                dc.w    AniPLC_MHZ-Offs_AniFunc
                dc.w    AnimateTiles_SOZ1-Offs_AniFunc
                dc.w    AniPLC_LRZ1-Offs_AniFunc
                dc.w    AnimateTiles_SOZ2-Offs_AniFunc
                dc.w    AniPLC_LRZ1-Offs_AniFunc
                dc.w    AnimateTiles_LRZ1-Offs_AniFunc
                dc.w    AniPLC_LRZ1-Offs_AniFunc
                dc.w    AnimateTiles_LRZ2-Offs_AniFunc
                dc.w    AniPLC_LRZ2-Offs_AniFunc
                dc.w    AnimateTiles_DoAniPLC-Offs_AniFunc
                dc.w    AniPLC_SSZ-Offs_AniFunc
                dc.w    AnimateTiles_NULL-Offs_AniFunc
                dc.w    AniPLC_SSZ-Offs_AniFunc
                dc.w    AnimateTiles_DoAniPLC-Offs_AniFunc
                dc.w    AniPLC_DEZ-Offs_AniFunc
                dc.w    AnimateTiles_DoAniPLC-Offs_AniFunc
                dc.w    AniPLC_DEZ-Offs_AniFunc
                dc.w    AnimateTiles_NULL-Offs_AniFunc
                dc.w    AniPLC_ALZ-Offs_AniFunc
                dc.w    AnimateTiles_NULL-Offs_AniFunc
                dc.w    AniPLC_ALZ-Offs_AniFunc
                dc.w    AnimateTiles_NULL-Offs_AniFunc
                dc.w    AniPLC_ALZ-Offs_AniFunc
                dc.w    AnimateTiles_NULL-Offs_AniFunc
                dc.w    AniPLC_ALZ-Offs_AniFunc
                dc.w    AnimateTiles_DoAniPLC-Offs_AniFunc
                dc.w    AniPLC_ALZ-Offs_AniFunc
                dc.w    AnimateTiles_DoAniPLC-Offs_AniFunc
                dc.w    AniPLC_ALZ-Offs_AniFunc
                dc.w    AnimateTiles_DoAniPLC-Offs_AniFunc
                dc.w    AniPLC_BPZ-Offs_AniFunc
                dc.w    AnimateTiles_DoAniPLC-Offs_AniFunc
                dc.w    AniPLC_BPZ-Offs_AniFunc
                dc.w    AnimateTiles_DPZ-Offs_AniFunc
                dc.w    AniPLC_DPZ-Offs_AniFunc
                dc.w    AnimateTiles_DPZ-Offs_AniFunc
                dc.w    AniPLC_DPZ-Offs_AniFunc
                dc.w    AnimateTiles_NULL-Offs_AniFunc
                dc.w    AniPLC_NULL-Offs_AniFunc
                dc.w    AnimateTiles_NULL-Offs_AniFunc
                dc.w    AniPLC_NULL-Offs_AniFunc
                dc.w    AnimateTiles_NULL-Offs_AniFunc
                dc.w    AniPLC_NULL-Offs_AniFunc
                dc.w    AnimateTiles_NULL-Offs_AniFunc
                dc.w    AniPLC_NULL-Offs_AniFunc
                dc.w    AnimateTiles_Gumball-Offs_AniFunc
                dc.w    AniPLC_NULL-Offs_AniFunc
                dc.w    AnimateTiles_Gumball-Offs_AniFunc
                dc.w    AniPLC_NULL-Offs_AniFunc
                dc.w    AnimateTiles_Pachinko-Offs_AniFunc
                dc.w    AniPLC_Pachinko-Offs_AniFunc
                dc.w    AnimateTiles_Pachinko-Offs_AniFunc
                dc.w    AniPLC_Pachinko-Offs_AniFunc
                dc.w    AnimateTiles_NULL-Offs_AniFunc
                dc.w    AniPLC_NULL-Offs_AniFunc
                dc.w    AnimateTiles_NULL-Offs_AniFunc
                dc.w    AniPLC_NULL-Offs_AniFunc
                dc.w    AnimateTiles_LRZ3-Offs_AniFunc
                dc.w    AniPLC_NULL-Offs_AniFunc
                dc.w    AnimateTiles_DoAniPLC-Offs_AniFunc
                dc.w    AniPLC_HPZ-Offs_AniFunc
                dc.w    AnimateTiles_NULL-Offs_AniFunc
                dc.w    AnimateTiles_NULL3-Offs_AniFunc
                dc.w    AnimateTiles_DoAniPLC-Offs_AniFunc
                dc.w    AniPLC_HPZ-Offs_AniFunc
; ---------------------------------------------------------------------------

AnimateTiles_NULL:
                rts
