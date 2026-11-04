; Owner: objects/bosses/lrz/end_boss/sk
; Responsibility: Lava Reef end-boss battle controller, attacks, parent actors and stage completion progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZEndBoss:
                move.w  a0,(_unkFAA4).w
                move.l  #loc_797C6,(a0)
                lea     (ArtKosM_LRZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_LRZEndBoss),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_LRZ3PlatformDebris).l,a1
                move.w  #tiles_to_bytes(ArtTile_LRZ3PlatformDebris),d2
                jsr     (Queue_Kos_Module).l
                lea     (PLC_BossExplosion).l,a1
                jsr     (Load_PLC_Raw).l
                lea     Pal_LRZEndBoss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_797C6:
                btst    #0,(_unkFA88).w
                beq.w   locret_797F8
                move.b  #1,(Boss_flag).w
                move.l  #Obj_Wait,(a0)
                move.w  #2*60,$2E(a0)
                move.l  #loc_797EC,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_797EC:
                move.l  #loc_797FA,(a0)
                move.b  #mus_EndBoss,(Current_music+1).w

locret_797F8:
                rts
; ---------------------------------------------------------------------------

loc_797FA:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_79812(pc,d0.w),d1
                jsr     off_79812(pc,d1.w)
                bsr.w   LRZBoss_HandleSelfHitOrDefeat
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
off_79812:
                dc.w    loc_7981E-off_79812
                dc.w    loc_79858-off_79812
                dc.w    loc_798B8-off_79812
                dc.w    loc_7990A-off_79812
                dc.w    loc_79936-off_79812
                dc.w    loc_79958-off_79812
; ---------------------------------------------------------------------------

loc_7981E:
                lea     ObjDat_LRZEndBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  #$B10,x_pos(a0)
                move.w  #$640,y_pos(a0)
                move.b  #$E,collision_property(a0)
                move.w  #-$12,angle(a0)
                move.w  #-$580,y_vel(a0)
                moveq   #signextendB(sfx_BossMagma),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_7A18C(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_79858:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   locret_7986E
                move.w  #$600,d0
                cmp.w   y_pos(a0),d0
                bls.s   loc_79870

locret_7986E:
                rts
; ---------------------------------------------------------------------------

loc_79870:
                move.w  d0,y_pos(a0)
                move.b  #4,routine(a0)
                move.b  #3,$39(a0)
                move.w  #$7F,d0
                move.w  d0,$2E(a0)
                move.w  d0,$3A(a0)
                move.l  #loc_798C6,$34(a0)
                moveq   #1,d0
                btst    #0,render_flags(a0)
                bne.s   loc_798A0
                moveq   #-1,d0

loc_798A0:
                move.w  d0,(_unkFAA2).w
                move.w  d0,(Events_bg+$08).w
                jsr     (AllocateObject).l
                bne.s   locret_798B6
                move.l  #loc_79A54,(a1)

locret_798B6:
                rts
; ---------------------------------------------------------------------------

loc_798B8:
                addq.w  #1,(_unkFA84).w
                bsr.w   MatchLRZLavaRiderHeightFromWorldXSample
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_798C6:
                subq.b  #1,$39(a0)
                bmi.s   loc_798EA
                subi.w  #$10,$3A(a0)
                move.w  $3A(a0),$2E(a0)
                moveq   #signextendB(sfx_BossProjectile),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_7A19A(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_798EA:
                move.w  #$F7,$2E(a0)
                move.l  #loc_798FA,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_798FA:
                move.b  #6,routine(a0)
                clr.b   (Events_bg+$09).w
                clr.w   (_unkFA84).w
                rts
; ---------------------------------------------------------------------------

loc_7990A:
                bsr.w   MatchLRZLavaRiderHeightFromWorldXSample
                tst.w   (Events_bg+$0A).w
                bne.w   locret_797F8
                move.b  #8,routine(a0)
                clr.b   (_unkFAA3).w
                move.w  #$100,y_vel(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_79942,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_79936:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_79942:
                move.b  #$A,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_7995E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_79958:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7995E:
                move.b  #2,routine(a0)
                move.w  #-$580,y_vel(a0)
                move.w  #$A30,d1
                bchg    #0,render_flags(a0)
                beq.s   loc_7997A
                move.w  #$B10,d1

loc_7997A:
                move.w  d1,x_pos(a0)
                moveq   #signextendB(sfx_BossMagma),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_79988:
                subq.w  #1,$2E(a0)
                bmi.s   loc_79998
                addq.w  #1,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_79998:
                move.l  #loc_799E0,(a0)
                ori.b   #$30,$38(a0)
                bclr    #7,render_flags(a0)
                st      (_unkFAA8).w
                clr.b   (Boss_flag).w
                jsr     (AllocateObject).l
                bne.s   loc_799C6
                move.l  #Obj_EggCapsule,(a1)
                bset    #1,render_flags(a1)

loc_799C6:
                jsr     (AllocateObject).l
                bne.s   loc_799D4
                move.l  #loc_7A100,(a1)

loc_799D4:
                lea     (PLC_EggCapsule).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

loc_799E0:
                tst.b   (_unkFAA8).w
                bne.w   locret_797F8
                move.l  #locret_79A52,(a0)
                bset    #1,(_unkFA88).w
                jsr     (AllocateObject).l
                bne.s   loc_79A08
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_LRZ2,subtype(a1)

loc_79A08:
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                clr.w   (Ctrl_1_logical).w
                move.w  #$EC0,(Camera_stored_max_X_pos).w
                jsr     (AllocateObject).l
                bne.s   loc_79A30
                move.l  #Obj_IncLevEndXGradual,(a1)

loc_79A30:
                jsr     (AllocateObject).l
                bne.s   locret_79A50
                move.l  #Obj_StartNewLevel,(a1)
                move.b  #$2D,subtype(a1)
                move.w  #$FE8,x_pos(a1)
                move.w  #$5E0,y_pos(a1)

locret_79A50:
                rts
; ---------------------------------------------------------------------------

locret_79A52:
                rts
; ---------------------------------------------------------------------------

loc_79A54:
                move.l  #loc_79A70,(a0)
                move.w  #$9E0,d0
                tst.b   (_unkFAA3).w
                bmi.s   loc_79A68
                move.w  #$B60,d0

loc_79A68:
                move.w  d0,x_pos(a0)
                bsr.w   LRZBossStream_SpawnPlatform

loc_79A70:
                tst.b   (_unkFAA3).w
                beq.s   loc_79AA8
                movea.w $44(a0),a1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                bpl.s   loc_79A86
                neg.w   d0

loc_79A86:
                cmpi.w  #$80,d0
                blo.w   locret_797F8

; =============== S U B R O U T I N E =======================================

; Save the allocated slot for the next platform spacing test
LRZBossStream_SpawnPlatform:
                jsr     (AllocateObject).l
                bne.s   locret_79AA6
                move.l  #loc_79E5A,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  a1,$44(a0)

locret_79AA6:
                rts
; End of function LRZBossStream_SpawnPlatform

; ---------------------------------------------------------------------------

loc_79AA8:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_79AAE:
                lea     word_7A14C(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_79AC4,(a0)
                move.w  #-$800,y_vel(a0)

loc_79AC4:
                bsr.w   LRZBossShot_DeleteIfParentDefeated
                tst.w   y_vel(a0)
                bmi.s   loc_79B02
                move.l  #loc_79B22,(a0)
                move.w  #$100,priority(a0)
                moveq   #$40,d0
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                beq.s   loc_79AEC
                move.w  #$140,d0

loc_79AEC:
                move.w  d0,d1
                addi.w  #$9E0,d0
                move.w  d0,x_pos(a0)
                lsr.w   #1,d1
                lea     (HScroll_table+$100).w,a1
                adda.w  d1,a1
                move.w  a1,$44(a0)

loc_79B02:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   loc_79B16
                lea     ChildObjDat_7A1A8(pc),a2
                jsr     (CreateChild1_Normal).l

loc_79B16:
                jsr     (MoveSprite_LightGravity).l
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

loc_79B22:
                bsr.w   LRZBossShot_DeleteIfParentDefeated
                jsr     (MoveSprite_LightGravity).l
                movea.w $44(a0),a1
                moveq   #0,d0
                move.b  (a1),d0
                subi.w  #$30,d0
                neg.w   d0
                addi.w  #$612,d0
                cmp.w   y_pos(a0),d0
                bls.s   loc_79B4A
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

loc_79B4A:
                move.l  #loc_79B54,(a0)
                clr.w   y_vel(a0)

loc_79B54:
                bsr.w   LRZBossShot_DeleteIfParentDefeated
                tst.b   (_unkFAA3).w
                bne.s   loc_79B66
                tst.b   render_flags(a0)
                bpl.w   loc_79AA8

loc_79B66:
                bsr.w   SetLRZLavaRiderHorizontalStreamVelocity
                jsr     (MoveSprite2).l
                bsr.w   MatchLRZLavaRiderHeightFromWorldXSample
                bsr.w   loc_79EC4
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

loc_79B7E:
                lea     word_7A152(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_79B96,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

loc_79B96:
                jsr     (Refresh_ChildPosition).l
                lea     byte_7A1C7(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_79BAC:
                lea     word_7A158(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_79BCA,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.w  #$100,y_vel(a0)

loc_79BCA:
                lea     byte_7A1D8(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                addi.w  #-$10,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_79BE6:
                lea     word_7A15E(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_79BF6,(a0)

loc_79BF6:
                jsr     (Refresh_ChildPosition).l
                lea     byte_7A1C2(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_79C0C:
                lea     word_7A164(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_79C1C,(a0)

loc_79C1C:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                move.b  #$F,mapping_frame(a0)
                btst    #6,status(a1)
                beq.s   loc_79C3E
                move.b  #$10,mapping_frame(a0)
                bra.w   loc_79C4C
; ---------------------------------------------------------------------------

loc_79C3E:
                btst    #7,status(a1)
                beq.s   loc_79C4C
                move.b  #$11,mapping_frame(a0)

loc_79C4C:
                jmp     (Child_Draw_Sprite2).l
; End of function loc_79AA8
