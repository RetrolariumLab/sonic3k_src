; Owner: rendering/s3
; Responsibility: Player-character graphics dispatch and zone-specific animal or explosion graphics loading
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Player_Load_PLC:
                move.l  a0,-(sp)
                lea     (Player_1).w,a0
                moveq   #0,d0
                move.b  character_id(a0),d0
                lsl.w   #2,d0
                movea.l Player_Load_PLC_Index(pc,d0.w),a1
                jsr     (a1)
                movea.l (sp)+,a0
                rts
; End of function Player_Load_PLC

; ---------------------------------------------------------------------------
Player_Load_PLC_Index:
                dc.l    Sonic_Load_PLC
                dc.l    Tails_Load_PLC

; =============== S U B R O U T I N E =======================================

PLCLoad_AnimalsAndExplosion:
                lea     PLC_Explosion(pc),a1
                jsr     (Load_PLC_Raw).l
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                add.w   d0,d0
                move.w  PLCLoad_Animals_Index(pc,d0.w),d0
                lea     PLCLoad_Animals_Index(pc,d0.w),a1
                jmp     (Load_PLC_Raw).l
; End of function PLCLoad_AnimalsAndExplosion

; ---------------------------------------------------------------------------
PLCLoad_Animals_Index:
                dc.w    PLC_Animals_AIZ-PLCLoad_Animals_Index
                dc.w    PLC_Animals_HCZ-PLCLoad_Animals_Index
                dc.w    PLC_Animals_MGZ-PLCLoad_Animals_Index
                dc.w    PLC_Animals_CNZ-PLCLoad_Animals_Index
                dc.w    PLC_Animals_FBZ-PLCLoad_Animals_Index
                dc.w    PLC_Animals_ICZ-PLCLoad_Animals_Index
                dc.w    PLC_Animals_LBZ-PLCLoad_Animals_Index
