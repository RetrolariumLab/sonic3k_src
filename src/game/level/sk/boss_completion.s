; Owner: game/level/sk
; Responsibility: Boss timer or score completion setup and player-character or zone-animal graphics loading dispatch
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

BossDefeated_StopTimer:
                clr.b   (Update_HUD_timer).w
; End of function BossDefeated_StopTimer

; =============== S U B R O U T I N E =======================================

BossDefeated:
                move.w  #$3F,$2E(a0)
                moveq   #100,d0
                jsr     (HUD_AddToScore).l
                bclr    #7,render_flags(a0)
                rts
; End of function BossDefeated

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
                dc.l    Knuckles_Load_PLC

; =============== S U B R O U T I N E =======================================

Player_Load_PLC2:
                move.l  a0,-(sp)
                movea.l a1,a0
                tst.l   (a0)
                beq.s   .skip
                moveq   #0,d0
                move.b  character_id(a0),d0
                lsl.w   #2,d0
                movea.l Player_Load_PLC_Index(pc,d0.w),a1
                jsr     (a1)

                .skip:
                movea.l (sp)+,a0
                rts
; End of function Player_Load_PLC2

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
                dc.w    PLC_Animals_MHZ-PLCLoad_Animals_Index
                dc.w    PLC_Animals_SOZ-PLCLoad_Animals_Index
                dc.w    PLC_Animals_LRZ-PLCLoad_Animals_Index
                dc.w    PLC_Animals_SSZ-PLCLoad_Animals_Index
                dc.w    PLC_Animals_DEZ-PLCLoad_Animals_Index
                dc.w    PLC_Animals_DDZ-PLCLoad_Animals_Index
                dc.w    PLC_Animals_LRZ3-PLCLoad_Animals_Index
                dc.w    PLC_Animals_LRZ3-PLCLoad_Animals_Index
                dc.w    PLC_Animals_LRZ3-PLCLoad_Animals_Index
                dc.w    PLC_Animals_LRZ3-PLCLoad_Animals_Index
                dc.w    PLC_Animals_LRZ3-PLCLoad_Animals_Index
                dc.w    PLC_Animals_LRZ3-PLCLoad_Animals_Index
                dc.w    PLC_Animals_LRZ3-PLCLoad_Animals_Index
                dc.w    PLC_Animals_LRZ3-PLCLoad_Animals_Index
                dc.w    PLC_Animals_LRZ3-PLCLoad_Animals_Index
                dc.w    PLC_Animals_LRZ3-PLCLoad_Animals_Index
                dc.w    PLC_Animals_LRZ3-PLCLoad_Animals_Index
