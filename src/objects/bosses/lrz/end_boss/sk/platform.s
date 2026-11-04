; Owner: objects/bosses/lrz/end_boss/sk
; Responsibility: Lava Reef boss-scene moving platform, state dispatch and attached motion callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZ3Platform:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #2,d0
                jmp     LRZ3Platform_Index(pc,d0.w)
; ---------------------------------------------------------------------------

LRZ3Platform_Index:
                bra.w   loc_79C72
; ---------------------------------------------------------------------------
                bra.w   loc_79CCE
; ---------------------------------------------------------------------------
                bra.w   loc_79CCE
; ---------------------------------------------------------------------------
                bra.w   loc_79CDE
; ---------------------------------------------------------------------------
                bra.w   loc_79CF8
; ---------------------------------------------------------------------------

loc_79C72:
                bsr.w   IsLRZPlatformOriginInsideCameraViewport
                beq.w   locret_797F8
                move.l  #loc_79C9E,(a0)
                lea     ChildObjDat_7A1B0(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_79C9E
                addi.w  #$C0,y_pos(a1)
                move.b  subtype(a0),subtype(a1)
                move.w  #$37F,$2E(a1)

loc_79C9E:
                tst.w   (_unkFAA4).w
                bne.w   loc_79DB6
                subq.w  #1,$2E(a0)
                bpl.w   locret_797F8
                move.w  #$17F,$2E(a0)

; =============== S U B R O U T I N E =======================================

; Copy the placement subtype and initialize the lifetime to $4FF
LRZRisingPlatform_Spawn:
                lea     ChildObjDat_7A1B0(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   locret_79CCC
                move.b  subtype(a0),subtype(a1)
                move.w  #$4FF,$2E(a1)

locret_79CCC:
                rts
; End of function LRZRisingPlatform_Spawn

; ---------------------------------------------------------------------------

loc_79CCE:
                bsr.w   IsLRZPlatformOriginInsideCameraViewport
                beq.w   locret_797F8
                bsr.s   LRZRisingPlatform_Spawn
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_79CDE:
                lea     ObjDat3_7A16C(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_79CEE,(a0)

loc_79CEE:
                bsr.w   MoveLRZPlatformAndResolveTopSolidRiders
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------

loc_79CF8:
                lea     ObjDat3_7A178(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_79D08,(a0)

loc_79D08:
                lea     byte_7A1E9(pc),a1
                jsr     (Animate_RawNoSST).l
                moveq   #$2B,d1
                moveq   #$18,d2
                moveq   #$19,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------

loc_79D28:
                lea     ObjDat3_7A16C(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_79D44,(a0)
                move.w  #-$80,y_vel(a0)
                move.w  #$20,$3A(a0)

loc_79D44:
                subq.w  #1,$3A(a0)
                bmi.s   loc_79D52
                bsr.w   MoveLRZPlatformAndResolveTopSolidRiders
                bra.w   loc_79D82
; ---------------------------------------------------------------------------

loc_79D52:
                move.l  #loc_79D6E,(a0)
                move.w  #$180,priority(a0)
                move.w  #$80,y_vel(a0)
                lea     ChildObjDat_7A1B6(pc),a2
                jsr     (CreateChild6_Simple).l

loc_79D6E:
                bsr.w   MoveLRZPlatformAndResolveTopSolidRiders
                move.b  subtype(a0),d0
                cmpi.b  #1,d0
                beq.s   loc_79DB0
                subq.w  #1,$2E(a0)
                bmi.s   loc_79DB6

loc_79D82:
                tst.w   (_unkFAA4).w
                beq.s   loc_79DAA
                tst.b   render_flags(a0)
                bpl.s   loc_79DB6
                tst.b   d0
                bne.s   loc_79DAA
                tst.b   (_unkFAA9).w
                bne.s   loc_79DAA
                cmpi.w  #$612,y_pos(a0)
                bhi.s   loc_79DAA
                move.l  #loc_79DC2,(a0)
                st      (_unkFAA9).w

loc_79DAA:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_79DB0:
                tst.b   render_flags(a0)
                bmi.s   loc_79DAA

loc_79DB6:
                jsr     (Displace_PlayerOffObject).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_79DC2:
                bsr.w   MoveLRZPlatformAndResolveTopSolidRiders
                cmpi.w  #$612,y_pos(a0)
                blo.s   loc_79DAA
                move.l  #loc_79DEA,(a0)
                bset    #0,(_unkFA88).w
                clr.w   y_vel(a0)
                bset    #7,status(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_79DEA:
                bsr.w   LRZBossPlatform_TryShatter
                tst.b   (_unkFAA3).w
                bne.s   loc_79DFC
                tst.b   render_flags(a0)
                bpl.w   loc_79DB6

loc_79DFC:
                bsr.w   SetLRZLavaRiderHorizontalStreamVelocity
                bsr.w   MoveLRZPlatformAndResolveTopSolidRiders
                bsr.w   MatchLRZLavaRiderHeightFromWorldXSample
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------
; unused
                move.l  #loc_79E34,(a0)
                move.w  #$80,x_vel(a0)
                move.w  #$40,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_79E34:
                jsr     (Swing_UpAndDown).l
                cmpi.w  #$B60,x_pos(a0)
                blo.s   loc_79E50
                move.l  #loc_79E50,(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)

loc_79E50:
                bsr.w   MoveLRZPlatformAndResolveTopSolidRiders
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------

loc_79E5A:
                lea     ObjDat3_7A16C(pc),a1
                jsr     (SetUp_ObjAttributes).l
                lea     loc_79DEA(pc),a1
                move.l  a1,(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------

loc_79E6C:
                lea     word_7A184(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_79E7C,(a0)

loc_79E7C:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                lea     byte_7A1E5(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_79E9C:
                lea     SKLRZ3Scene_PlatformDebrisAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #Obj_FlickerMove,(a0)
                bsr.w   SeedLRZBossPlatformTenDebrisPieces
                jmp     (Draw_Sprite).l
