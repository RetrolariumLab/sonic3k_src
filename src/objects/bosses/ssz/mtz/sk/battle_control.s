; Owner: objects/bosses/ssz/mtz/sk
; Responsibility: Sky Sanctuary Metropolis-style boss controller, attack progression and initial coordinated actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SSZMTZBoss:
                move.l  #Obj_Wait,(a0)
                move.b  #1,(Boss_flag).w
                move.w  #$1F,$2E(a0)
                move.l  #loc_7A712,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                jsr     (AllocateObject).l
                bne.s   loc_7A6DC
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_EndBoss,subtype(a1)

loc_7A6DC:
                clr.w   (_unkFA88).w
                moveq   #PLCID_7B,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_SSZMTZOrbs).l,a1
                move.w  #tiles_to_bytes(ArtTile_SSZMTZOrbs),d2
                jsr     (Queue_Kos_Module).l
                lea     (Normal_palette_line_2).w,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_7A702:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_7A702
                lea     Pal_SSZMTZOrbs(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_7A712:
                move.l  #loc_7A71A,(a0)

locret_7A718:
                rts
; ---------------------------------------------------------------------------

loc_7A71A:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_7A728(pc,d0.w),d1
                jmp     off_7A728(pc,d1.w)
; ---------------------------------------------------------------------------
off_7A728:
                dc.w    loc_7A72C-off_7A728
                dc.w    loc_7A7E2-off_7A728
; ---------------------------------------------------------------------------

loc_7A72C:
                move.l  #Map_RobotnikShip,mappings(a0)
                move.w  #make_art_tile(ArtTile_RobotnikShip,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$180,priority(a0)
                move.w  #$1700,x_pos(a0)
                move.w  #$300,y_pos(a0)
                move.b  #$A,mapping_frame(a0)
                addq.b  #2,routine(a0)
                move.b  #$11,collision_flags(a0)
                move.b  #8,collision_property(a0)
                move.b  #7,$3C(a0)
                move.w  x_pos(a0),(SSZ_MTZ_boss_X_pos).w
                move.w  y_pos(a0),(SSZ_MTZ_boss_Y_pos).w
                move.w  #0,(SSZ_MTZ_boss_X_vel).w
                move.w  #$100,(SSZ_MTZ_boss_Y_vel).w
                move.b  #$20,width_pixels(a0)
                clr.b   $2E(a0)
                clr.b   $30(a0)
                move.b  #$40,$1D(a0)
                move.b  #$27,$38(a0)
                move.b  #$27,$3A(a0)
                lea     (Child1_MakeMechaHead).l,a2
                jsr     (CreateChild1_Normal).l
                jsr     (AllocateObject).l
                bne.s   loc_7A7C4
                move.l  #loc_7AD8A,(a1)
                move.l  a0,$34(a1)

loc_7A7C4:
                lea     (_unkFA82).w,a2
                move.b  #$10,(a2)+
                move.b  #0,(a2)+
                move.b  #3,(a2)+
                move.b  #0,(a2)+
                move.b  #1,(a2)+
                move.b  #0,(a2)+
                rts
; ---------------------------------------------------------------------------

loc_7A7E2:
                moveq   #0,d0
                move.b  $26(a0),d0
                move.w  off_7A7F0(pc,d0.w),d1
                jmp     off_7A7F0(pc,d1.w)
; ---------------------------------------------------------------------------
off_7A7F0:
                dc.w    loc_7A800-off_7A7F0
                dc.w    loc_7A874-off_7A7F0
                dc.w    loc_7A8F4-off_7A7F0
                dc.w    loc_7A93C-off_7A7F0
                dc.w    loc_7A95A-off_7A7F0
                dc.w    loc_7A98A-off_7A7F0
                dc.w    loc_7A9D4-off_7A7F0
                dc.w    loc_7AA44-off_7A7F0
; ---------------------------------------------------------------------------

loc_7A800:
                bsr.w   Boss_MoveObject
                move.w  (SSZ_MTZ_boss_Y_pos).w,$14(a0)
                cmpi.w  #$420,(SSZ_MTZ_boss_Y_pos).w
                blo.s   loc_7A84A
                addq.b  #2,$26(a0)
                move.w  #0,(SSZ_MTZ_boss_Y_vel).w
                move.w  #-$100,(SSZ_MTZ_boss_X_vel).w
                bclr    #7,$2E(a0)
                bclr    #0,render_flags(a0)
                move.w  (Player_1+x_pos).w,d0
                cmp.w   (SSZ_MTZ_boss_X_pos).w,d0
                blo.s   loc_7A84A
                move.w  #$100,(SSZ_MTZ_boss_X_vel).w
                bset    #7,$2E(a0)
                bset    #0,render_flags(a0)

loc_7A84A:
                bsr.w   SSZMTZBoss_CheckHitOrbRelease
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

ApplySSZMTZBossFourPixelSineBob:
                move.b  $1D(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #6,d0
                add.w   (SSZ_MTZ_boss_Y_pos).w,d0
                move.w  d0,y_pos(a0)
                addq.b  #4,$1D(a0)
                rts
; End of function ApplySSZMTZBossFourPixelSineBob

; ---------------------------------------------------------------------------

loc_7A874:
                bsr.w   Boss_MoveObject
                btst    #7,$2E(a0)
                bne.s   loc_7A8AE
                cmpi.w  #$1680,(SSZ_MTZ_boss_X_pos).w
                bhs.s   loc_7A8DA
                bchg    #7,$2E(a0)
                move.w  #$100,(SSZ_MTZ_boss_X_vel).w
                bset    #0,render_flags(a0)
                bset    #6,$2E(a0)
                beq.s   loc_7A8DA
                addq.b  #2,$26(a0)
                move.w  #-$100,(SSZ_MTZ_boss_Y_vel).w
                bra.s   loc_7A8DA
; ---------------------------------------------------------------------------

loc_7A8AE:
                cmpi.w  #$1780,(SSZ_MTZ_boss_X_pos).w
                blo.s   loc_7A8DA
                bchg    #7,$2E(a0)
                move.w  #-$100,(SSZ_MTZ_boss_X_vel).w
                bclr    #0,render_flags(a0)
                bset    #6,$2E(a0)
                beq.s   loc_7A8DA
                addq.b  #2,$26(a0)
                move.w  #-$100,(SSZ_MTZ_boss_Y_vel).w

loc_7A8DA:
                move.w  (SSZ_MTZ_boss_X_pos).w,x_pos(a0)
                bsr.w   ApplySSZMTZBossFourPixelSineBob

loc_7A8E4:
                bsr.w   SSZMTZBoss_CheckHitOrbRelease
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7A8F4:
                bsr.w   Boss_MoveObject
                cmpi.w  #$3F0,(SSZ_MTZ_boss_Y_pos).w
                bhs.s   loc_7A906
                move.w  #0,(SSZ_MTZ_boss_Y_vel).w

loc_7A906:
                btst    #7,$2E(a0)
                bne.s   loc_7A91E
                cmpi.w  #$1700,(SSZ_MTZ_boss_X_pos).w
                bhs.s   loc_7A92C
                move.w  #0,(SSZ_MTZ_boss_X_vel).w
                bra.s   loc_7A92C
; ---------------------------------------------------------------------------

loc_7A91E:
                cmpi.w  #$1700,(SSZ_MTZ_boss_X_pos).w
                blo.s   loc_7A92C
                move.w  #0,(SSZ_MTZ_boss_X_vel).w

loc_7A92C:
                move.w  (SSZ_MTZ_boss_X_vel).w,d0
                or.w    (SSZ_MTZ_boss_Y_vel).w,d0
                bne.s   loc_7A93A
                addq.b  #2,$26(a0)

loc_7A93A:
                bra.s   loc_7A8DA
; ---------------------------------------------------------------------------

loc_7A93C:
                cmpi.b  #$68,$38(a0)
                bhs.s   loc_7A94E
                addq.b  #1,$38(a0)
                addq.b  #1,$3A(a0)
                bra.s   loc_7A958
; ---------------------------------------------------------------------------

loc_7A94E:
                subq.b  #1,$3A(a0)
                bne.s   loc_7A958
                addq.b  #2,$26(a0)

loc_7A958:
                bra.s   loc_7A8DA
; ---------------------------------------------------------------------------

loc_7A95A:
                cmpi.b  #$27,$38(a0)
                blo.s   loc_7A968
                subq.b  #1,$38(a0)
                bra.s   loc_7A986
; ---------------------------------------------------------------------------

loc_7A968:
                addq.b  #1,$3A(a0)
                cmpi.b  #$27,$3A(a0)
                blo.s   loc_7A986
                move.w  #$100,(SSZ_MTZ_boss_Y_vel).w
                move.b  #0,$26(a0)
                bclr    #6,$2E(a0)

loc_7A986:
                bra.w   loc_7A8DA
; ---------------------------------------------------------------------------

loc_7A98A:
                tst.b   $3A(a0)
                beq.s   loc_7A996
                subq.b  #1,$3A(a0)
                bra.s   loc_7A99C
; ---------------------------------------------------------------------------

loc_7A996:
                move.b  #-1,$3B(a0)

loc_7A99C:
                cmpi.b  #$27,$38(a0)
                blo.s   loc_7A9A8
                subq.b  #1,$38(a0)

loc_7A9A8:
                bsr.w   Boss_MoveObject
                cmpi.w  #$3B0,(SSZ_MTZ_boss_Y_pos).w
                bhs.s   loc_7A9BA
                move.w  #0,(SSZ_MTZ_boss_Y_vel).w

loc_7A9BA:
                tst.b   $30(a0)
                bne.s   loc_7A9D0
                tst.b   $3B(a0)
                beq.s   loc_7A9CC
                move.b  #$80,$3B(a0)

loc_7A9CC:
                addq.b  #2,$26(a0)

loc_7A9D0:
                bra.w   loc_7A8DA
; ---------------------------------------------------------------------------

loc_7A9D4:
                tst.b   $3C(a0)
                beq.s   loc_7AA02
                tst.b   $3B(a0)
                bne.s   loc_7AA40
                cmpi.b  #$27,$3A(a0)
                bhs.s   loc_7A9EE
                addq.b  #1,$3A(a0)
                bra.s   loc_7AA40
; ---------------------------------------------------------------------------

loc_7A9EE:
                move.w  #$100,(SSZ_MTZ_boss_Y_vel).w
                move.b  #0,$26(a0)
                bclr    #6,$2E(a0)
                bra.s   loc_7AA40
; ---------------------------------------------------------------------------

loc_7AA02:
                move.w  #-$180,(SSZ_MTZ_boss_Y_vel).w
                move.w  #-$100,(SSZ_MTZ_boss_X_vel).w
                bclr    #0,render_flags(a0)
                btst    #7,$2E(a0)
                beq.s   loc_7AA28
                move.w  #$100,(SSZ_MTZ_boss_X_vel).w
                bset    #0,render_flags(a0)

loc_7AA28:
                move.b  #$E,$26(a0)
                move.b  #0,$32(a0)
                bclr    #6,$2E(a0)
                move.b  #0,$33(a0)

loc_7AA40:
                bra.w   loc_7A8DA
; ---------------------------------------------------------------------------

loc_7AA44:
                tst.b   $33(a0)
                beq.s   loc_7AA52
                subq.b  #1,$33(a0)
                bra.w   loc_7A8E4
; ---------------------------------------------------------------------------

loc_7AA52:
                moveq   #0,d0
                move.b  $32(a0),d0
                move.w  off_7AA60(pc,d0.w),d1
                jmp     off_7AA60(pc,d1.w)
; ---------------------------------------------------------------------------
off_7AA60:
                dc.w    loc_7AA66-off_7AA60
                dc.w    loc_7AACE-off_7AA60
                dc.w    loc_7AB1A-off_7AA60
; ---------------------------------------------------------------------------

loc_7AA66:
                bsr.w   Boss_MoveObject
                cmpi.w  #$3B0,(SSZ_MTZ_boss_Y_pos).w
                bhs.s   loc_7AA78
                move.w  #0,(SSZ_MTZ_boss_Y_vel).w

loc_7AA78:
                btst    #7,$2E(a0)
                bne.s   loc_7AAA6
                cmpi.w  #$16A0,(SSZ_MTZ_boss_X_pos).w
                bhs.s   loc_7AACA
                addq.b  #2,$32(a0)
                move.w  #$180,(SSZ_MTZ_boss_Y_vel).w
                move.b  #3,$31(a0)
                move.w  #$1E,(SSZ_MTZ_boss_laser_timer).w
                bset    #0,render_flags(a0)
                bra.s   loc_7AACA
; ---------------------------------------------------------------------------

loc_7AAA6:
                cmpi.w  #$1760,(SSZ_MTZ_boss_X_pos).w
                blo.s   loc_7AACA
                addq.b  #2,$32(a0)
                move.w  #$180,(SSZ_MTZ_boss_Y_vel).w
                move.b  #3,$31(a0)
                move.w  #$1E,(SSZ_MTZ_boss_laser_timer).w
                bclr    #0,render_flags(a0)

loc_7AACA:
                bra.w   loc_7A8DA
; ---------------------------------------------------------------------------

loc_7AACE:
                bsr.w   Boss_MoveObject
                cmpi.w  #$420,(SSZ_MTZ_boss_Y_pos).w
                blo.s   loc_7AAEC
                move.w  #-$180,(SSZ_MTZ_boss_Y_vel).w
                addq.b  #2,$32(a0)
                bchg    #7,$2E(a0)
                bra.s   loc_7AB12
; ---------------------------------------------------------------------------

loc_7AAEC:
                btst    #7,$2E(a0)
                bne.s   loc_7AB04
                cmpi.w  #$1680,(SSZ_MTZ_boss_X_pos).w
                bhs.s   loc_7AB12
                move.w  #0,(SSZ_MTZ_boss_X_vel).w
                bra.s   loc_7AB12
; ---------------------------------------------------------------------------

loc_7AB04:
                cmpi.w  #$1780,(SSZ_MTZ_boss_X_pos).w
                blo.s   loc_7AB12
                move.w  #0,(SSZ_MTZ_boss_X_vel).w

loc_7AB12:
                bsr.w   TickSSZMTZBossLaserPairBurst
                bra.w   loc_7A8DA
; ---------------------------------------------------------------------------

loc_7AB1A:
                bsr.w   Boss_MoveObject
                cmpi.w  #$3F0,(SSZ_MTZ_boss_Y_pos).w
                bhs.s   loc_7AB3A
                move.w  #$100,(SSZ_MTZ_boss_X_vel).w
                btst    #7,$2E(a0)
                bne.s   loc_7AB3A
                move.w  #-$100,(SSZ_MTZ_boss_X_vel).w

loc_7AB3A:
                cmpi.w  #$3B0,(SSZ_MTZ_boss_Y_pos).w
                bhs.s   loc_7AB4E
                move.w  #0,(SSZ_MTZ_boss_Y_vel).w
                move.b  #0,$32(a0)

loc_7AB4E:
                bsr.w   TickSSZMTZBossLaserPairBurst
                bra.w   loc_7A8DA
