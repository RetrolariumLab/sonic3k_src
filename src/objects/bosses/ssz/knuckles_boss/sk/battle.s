; Owner: objects/bosses/ssz/knuckles_boss/sk
; Responsibility: Knuckles Sky Sanctuary Mecha Sonic battle controller, super phase, attacks and coordinated progression
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SSZ2_Boss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SSZ2_Boss_Index(pc,d0.w),d1
                jsr     SSZ2_Boss_Index(pc,d1.w)
                lea     loc_7D39E(pc),a4
                bsr.w   HandleSSZMechaHitFlashOrTailDeathCallback
                bsr.w   SelectSSZMechaCollisionFromFrameOutsideHitRecovery
                lea     DPLCPtr_MechaSonic(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
SSZ2_Boss_Index:
                dc.w    loc_7BDBE-SSZ2_Boss_Index
                dc.w    loc_7BDBE-SSZ2_Boss_Index
                dc.w    loc_7BE0E-SSZ2_Boss_Index
                dc.w    loc_7BE42-SSZ2_Boss_Index
                dc.w    loc_7BE9C-SSZ2_Boss_Index
                dc.w    loc_7BF28-SSZ2_Boss_Index
                dc.w    loc_7BF5A-SSZ2_Boss_Index
                dc.w    loc_7BFA0-SSZ2_Boss_Index
                dc.w    loc_7C062-SSZ2_Boss_Index
                dc.w    loc_7C11C-SSZ2_Boss_Index
                dc.w    loc_7C144-SSZ2_Boss_Index
                dc.w    loc_7C11C-SSZ2_Boss_Index
                dc.w    loc_7C18C-SSZ2_Boss_Index
                dc.w    loc_7C1D8-SSZ2_Boss_Index
                dc.w    loc_7C1F2-SSZ2_Boss_Index
                dc.w    loc_7C144-SSZ2_Boss_Index
                dc.w    loc_7C250-SSZ2_Boss_Index
                dc.w    loc_7C2A4-SSZ2_Boss_Index
                dc.w    loc_7C2DC-SSZ2_Boss_Index
                dc.w    loc_7C302-SSZ2_Boss_Index
                dc.w    loc_7C328-SSZ2_Boss_Index
                dc.w    loc_7C37A-SSZ2_Boss_Index
                dc.w    loc_7C37A-SSZ2_Boss_Index
                dc.w    loc_7C3F8-SSZ2_Boss_Index
                dc.w    loc_7C430-SSZ2_Boss_Index
                dc.w    loc_7C458-SSZ2_Boss_Index
                dc.w    loc_7C49E-SSZ2_Boss_Index
                dc.w    loc_7C4E0-SSZ2_Boss_Index
                dc.w    loc_7C51C-SSZ2_Boss_Index
                dc.w    loc_7C55E-SSZ2_Boss_Index
                dc.w    loc_7C59A-SSZ2_Boss_Index
                dc.w    loc_7C630-SSZ2_Boss_Index
                dc.w    loc_7C64E-SSZ2_Boss_Index
                dc.w    loc_7C65C-SSZ2_Boss_Index
                dc.w    loc_7C684-SSZ2_Boss_Index
                dc.w    loc_7C6F0-SSZ2_Boss_Index
; ---------------------------------------------------------------------------

loc_7BDBE:
                moveq   #signextendB(sfx_MechaTransform),d0
                jsr     (Play_SFX_Continuous).l
                jsr     (Run_PalRotationScript).l
                bchg    #6,(_unkFAB8).w
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_7BDD8:
                move.b  #2,routine(a0)
                bset    #6,$38(a0)
                move.l  #loc_7BDF6,$34(a0)
                lea     byte_7D5FF(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_7BDF6:
                move.b  #4,routine(a0)
                clr.w   x_vel(a0)
                move.w  #-$480,y_vel(a0)
                bclr    #6,(_unkFAB8).w
                rts
; ---------------------------------------------------------------------------

loc_7BE0E:
                jsr     (Run_PalRotationScript).l
                jsr     (MoveSprite_LightGravity).l
                move.w  (_unkFAB0).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_7BE26
                rts
; ---------------------------------------------------------------------------

loc_7BE26:
                move.w  d0,y_pos(a0)
                move.b  #6,routine(a0)
                move.l  #loc_7BE4E,$34(a0)
                lea     byte_7D645(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_7BE42:
                jsr     (Run_PalRotationScript).l
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_7BE4E:
                move.b  #8,routine(a0)
                clr.b   $39(a0)
                bclr    #1,$38(a0)
                lea     word_7DA60(pc),a1
                bsr.w   InstallSingleGlobalPaletteRotationScript
                move.w  #$3F,$2E(a0)
                move.l  #loc_7BEA8,$34(a0)
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($80),d6

loc_7BE7E:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_7BE7E
                jsr     (AllocateObject).l
                bne.s   loc_7BE92
                move.l  #loc_7D09C,(a1)

loc_7BE92:
                moveq   #signextendB(sfx_SuperTransform),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_7BE9C:
                jsr     (Run_PalRotationScript).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7BEA8:
                cmpi.b  #2,collision_property(a0)
                bls.s   loc_7BF0C

loc_7BEB0:
                move.w  x_pos(a0),d0
                move.w  (_unkFA82).w,d1
                bclr    #0,render_flags(a0)
                cmp.w   (_unkFA88).w,d0
                bhs.s   loc_7BECE
                move.w  (_unkFA8E).w,d1
                bset    #0,render_flags(a0)

loc_7BECE:
                move.w  d1,$3C(a0)

loc_7BED2:
                move.b  #$A,routine(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$80,d0
                btst    #0,render_flags(a0)
                bne.s   loc_7BEEE
                neg.w   d0

loc_7BEEE:
                move.w  d0,$40(a0)
                lea     byte_7D652(pc),a1
                jsr     (Set_Raw_Animation).l
                bset    #6,$38(a0)
                lea     ChildObjDat_7D49A(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_7BF0C:
                move.b  #$3C,routine(a0)
                move.b  #8,mapping_frame(a0)
                move.w  #$80,$2E(a0)
                move.b  #5,$39(a0)
                bra.w   loc_7C34C
; ---------------------------------------------------------------------------

loc_7BF28:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelay).l
                move.w  x_vel(a0),d0
                add.w   $40(a0),d0
                move.w  d0,x_vel(a0)
                cmpi.w  #-$800,d0
                ble.s   loc_7BF52
                cmpi.w  #$800,d0
                bge.s   loc_7BF52
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_7BF52:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_7BF5A:
                jsr     (Run_PalRotationScript).l
                jsr     (MoveSprite2).l
                tst.w   x_vel(a0)
                bmi.s   loc_7BF7C
                move.w  $3C(a0),d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$38,d0
                blo.s   loc_7BF8C
                rts
; ---------------------------------------------------------------------------

loc_7BF7C:
                move.w  x_pos(a0),d0
                sub.w   $3C(a0),d0
                cmpi.w  #$38,d0
                blo.s   loc_7BF8C
                rts
; ---------------------------------------------------------------------------

loc_7BF8C:
                move.b  #$E,routine(a0)
                neg.w   $40(a0)
                lea     byte_7D626(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_7BFA0:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelayFlipX).l
                move.w  $40(a0),d0
                add.w   d0,x_vel(a0)
                jsr     (MoveSprite2).l
                move.w  $3C(a0),d0
                tst.w   x_vel(a0)
                bmi.s   loc_7BFCC
                cmp.w   x_pos(a0),d0
                bls.s   loc_7BFD4
                rts
; ---------------------------------------------------------------------------

loc_7BFCC:
                cmp.w   x_pos(a0),d0
                bhs.s   loc_7BFD4
                rts
; ---------------------------------------------------------------------------

loc_7BFD4:
                move.b  #$10,routine(a0)
                bclr    #6,$38(a0)
                btst    #1,$38(a0)
                bne.s   loc_7C008
                move.w  #7,$2E(a0)
                move.b  $39(a0),d0
                addq.b  #1,d0
                move.b  d0,$39(a0)
                cmpi.b  #2,d0
                bhs.s   loc_7C018

loc_7BFFE:
                move.l  #loc_7BEB0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7C008:
                move.w  #$1F,$2E(a0)
                move.l  #loc_7C06E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7C018:
                bsr.w   ClassifySSZPlayerHorizontalRegionWithCollapsedRightBins
                move.b  d2,child_dy(a0)
                move.w  x_pos(a0),d0
                cmp.w   (_unkFA88).w,d0
                blo.s   loc_7C02C
                not.b   d3

loc_7C02C:
                tst.b   d3
                bne.s   loc_7BFFE
                bset    #1,$38(a0)
                move.l  #loc_7BED2,$34(a0)
                move.b  byte_7C050-1(pc,d2.w),child_dx(a0)
                add.w   d2,d2
                movea.w word_7C056-2(pc,d2.w),a1
                move.w  (a1),$3C(a0)
                rts
; ---------------------------------------------------------------------------
byte_7C050:
                dc.b    4,   5,   6,   1,   2,   3
                even
word_7C056:
                dc.w    _unkFA8A, _unkFA8C, _unkFA8E
                dc.w    _unkFA82, _unkFA84, _unkFA86
; ---------------------------------------------------------------------------

loc_7C062:
                jsr     (Run_PalRotationScript).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7C06E:
                bsr.w   TestSSZPlayerRegionAgainstSelectedAttackList
                beq.s   loc_7C0B6
                move.b  #$12,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_7C12E,$34(a0)
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l
                lea     (Player_1).w,a1
                moveq   #0,d0
                move.w  x_pos(a1),d0
                moveq   #0,d1
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$B0,d1
                moveq   #3,d5
                jsr     (SetVelocityTowardPointByDominantAxis).l
                lea     byte_7D52A(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_7C0B6:
                jsr     (Random_Number).l
                andi.b  #3,d0
                bne.s   loc_7C104
                move.b  #$1C,routine(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.w  x_pos(a0),d0
                move.w  #-$80,d1
                cmp.w   (_unkFA88).w,d0
                bhs.s   loc_7C0E0
                neg.w   d1

loc_7C0E0:
                move.w  d1,$40(a0)
                moveq   #signextendB(sfx_MissileShoot),d0
                jsr     (Play_SFX).l
                lea     byte_7D652(pc),a1
                jsr     (Set_Raw_Animation).l
                bset    #6,$38(a0)
                lea     ChildObjDat_7D49A(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_7C104:
                move.b  #$28,routine(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                lea     byte_7D57C(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_7C11C:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7C12E:
                move.b  #$14,routine(a0)
                move.b  #$13,y_radius(a0)
                move.l  #loc_7C15C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7C144:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite2).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

loc_7C15C:
                move.b  #$16,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_7C17A,$34(a0)
                moveq   #signextendB(sfx_Crash),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_7C17A:
                move.b  #$18,routine(a0)
                clr.w   x_vel(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_7C18C:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite2).l
                move.w  (_unkFAB0).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_7C1AA
                rts
; ---------------------------------------------------------------------------

loc_7C1AA:
                move.b  #$1A,routine(a0)
                move.l  #loc_7C1E4,$34(a0)
                move.w  x_pos(a0),d0
                bclr    #0,render_flags(a0)
                cmp.w   (_unkFA88).w,d0
                bhs.s   loc_7C1CE
                bset    #0,render_flags(a0)

loc_7C1CE:
                lea     byte_7D538(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_7C1D8:
                jsr     (Run_PalRotationScript).l
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_7C1E4:
                clr.b   $39(a0)
                bclr    #1,$38(a0)
                bra.w   loc_7BEB0
; ---------------------------------------------------------------------------

loc_7C1F2:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelay).l
                move.w  $40(a0),d0
                add.w   d0,x_vel(a0)
                move.w  y_vel(a0),d0
                addi.w  #$80,d0
                move.w  d0,y_vel(a0)
                cmpi.w  #$800,d0
                blo.s   loc_7C22C
                move.b  #$1E,routine(a0)
                move.b  #$57,y_radius(a0)
                move.l  #loc_7C232,$34(a0)

loc_7C22C:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_7C232:
                move.b  #$20,routine(a0)
                move.b  #$1F,y_radius(a0)
                move.l  #loc_7C274,$34(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_7C250:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelay).l
                move.w  y_vel(a0),d0
                addi.w  #-$80,d0
                move.w  d0,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

loc_7C274:
                move.b  #$22,routine(a0)
                move.w  $40(a0),d0
                neg.w   d0
                asr.w   #1,d0
                move.w  d0,$40(a0)
                clr.w   y_vel(a0)
                move.l  #loc_7C2BE,$34(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                lea     byte_7D556(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_7C2A4:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelay).l
                move.w  $40(a0),d0
                add.w   d0,x_vel(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_7C2BE:
                move.b  #$24,routine(a0)
                bclr    #6,$38(a0)
                move.l  #loc_7C2E8,$34(a0)
                lea     byte_7D561(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_7C2DC:
                jsr     (Run_PalRotationScript).l
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_7C2E8:
                move.b  #$26,routine(a0)
                clr.w   x_vel(a0)
                move.w  #-$600,y_vel(a0)
                lea     byte_7D56C(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_7C302:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelayFlipX).l
                jsr     (MoveSprite_LightGravity).l
                move.w  (_unkFAB0).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_7C320
                rts
; ---------------------------------------------------------------------------

loc_7C320:
                move.w  d0,y_pos(a0)
                bra.w   loc_7C1E4
; ---------------------------------------------------------------------------

loc_7C328:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelayFlipX).l
                moveq   #$10,d1
                jsr     (MoveSprite_CustomGravity).l
                cmpi.w  #$100,y_vel(a0)
                bhs.s   loc_7C346
                rts
; ---------------------------------------------------------------------------

loc_7C346:
                move.b  #$2A,routine(a0)

loc_7C34C:
                move.w  #$100,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)
                move.b  #3,$39(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_7C39E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7C37A:
                jsr     (Run_PalRotationScript).l
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (Find_SonicTails).l
                jsr     (Change_FlipX).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7C39E:
                move.w  #$2F,$2E(a0)
                lea     ChildObjDat_7D4AE(pc),a2
                jsr     CreateChild1_Normal(pc)
                subq.b  #1,$39(a0)
                bpl.w   locret_7B448
                move.b  #8,subtype(a1)
                move.b  #$2C,routine(a0)
                move.l  #loc_7C3CA,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7C3CA:
                move.b  #$2E,routine(a0)
                move.b  #$1F,y_radius(a0)
                move.l  #loc_7C410,$34(a0)
                bclr    #7,$38(a0)
                lea     (word_7DB66).l,a1
                bsr.w   InstallSingleGlobalPaletteRotationScript
                lea     byte_7D508(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_7C3F8:
                jsr     (Run_PalRotationScript).l
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

loc_7C410:
                move.b  #$30,routine(a0)
                move.l  #loc_7C436,$34(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                lea     byte_7D510(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_7C430:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_7C436:
                move.b  #$32,routine(a0)
                clr.b   y_vel(a0)
                move.b  #$13,y_radius(a0)
                move.l  #loc_7C46A,$34(a0)
                move.l  #byte_7D519,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_7C458:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite_LightGravity).l
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

loc_7C46A:
                move.b  #$34,routine(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                bset    #0,render_flags(a0)
                move.w  #$400,d0
                move.w  x_pos(a0),d1
                cmp.w   (_unkFAB6).w,d1
                blo.s   loc_7C494
                bclr    #0,render_flags(a0)
                neg.w   d0

loc_7C494:
                move.w  d0,x_vel(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_7C49E:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite2).l
                move.w  (_unkFAB6).w,d0
                tst.w   x_vel(a0)
                bmi.s   loc_7C4BC
                cmp.w   x_pos(a0),d0
                bls.s   loc_7C4C4
                rts
; ---------------------------------------------------------------------------

loc_7C4BC:
                cmp.w   x_pos(a0),d0
                bhs.s   loc_7C4C4
                rts
; ---------------------------------------------------------------------------

loc_7C4C4:
                move.w  d0,x_pos(a0)
                move.b  #$36,routine(a0)
                move.b  #$1F,y_radius(a0)
                clr.w   x_vel(a0)
                move.w  #-$200,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_7C4E0:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite_LightGravity).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_7C4F8
                rts
; ---------------------------------------------------------------------------

loc_7C4F8:
                add.w   d1,y_pos(a0)
                move.b  #$38,routine(a0)
                move.l  #loc_7C522,$34(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                lea     byte_7D5C1(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_7C51C:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_7C522:
                move.b  #$3A,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.b  #$4B,y_radius(a0)
                move.l  #loc_7C578,$34(a0)
                bclr    #0,render_flags(a0)
                bne.s   loc_7C54E
                move.l  #byte_7D61A,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_7C54E:
                move.b  #$C,mapping_frame(a0)
                move.l  #byte_7D5D8,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_7C55E:
                jsr     (Animate_RawMultiDelay).l
                jsr     (MoveSprite_LightGravity).l
                tst.w   y_vel(a0)
                bmi.w   locret_7B448
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

loc_7C578:
                move.b  #0,routine(a0)
                move.l  #loc_7BDD8,$34(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                lea     byte_7D5B6(pc),a1
                jsr     Set_Raw_Animation(pc)
                bra.w   loc_7BB7C
; ---------------------------------------------------------------------------

loc_7C59A:
                jsr     (Run_PalRotationScript).l
                subq.w  #1,$2E(a0)
                bmi.s   loc_7C61A
                jsr     (Swing_UpAndDown_Count).l
                bne.s   loc_7C5EA
                jsr     (MoveSprite2).l
                jsr     (Find_SonicTails).l
                move.w  #-$100,d1
                btst    #0,render_flags(a0)
                beq.s   loc_7C5CA
                subq.w  #2,d0
                neg.w   d1

loc_7C5CA:
                tst.w   d0
                bne.s   loc_7C5D4
                move.w  d1,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_7C5D4:
                move.b  #$3E,routine(a0)
                move.l  #loc_7C646,$34(a0)
                lea     byte_7D636(pc),a1
                jmp     Set_Raw_Animation(pc)
; ---------------------------------------------------------------------------

loc_7C5EA:
                move.b  #$40,routine(a0)
                bclr    #7,$38(a0)
                move.w  #$100,d0
                btst    #0,render_flags(a0)
                bne.s   loc_7C604
                neg.w   d0

loc_7C604:
                move.w  d0,x_vel(a0)
                move.l  #loc_7C654,(Palette_rotation_custom).w
                lea     (word_7DC7E).l,a1
                bra.w   InstallSingleGlobalPaletteRotationScript
; ---------------------------------------------------------------------------

loc_7C61A:
                move.b  #$46,routine(a0)
                move.l  #loc_7C718,$34(a0)
                lea     byte_7D587(pc),a1
                jmp     Set_Raw_Animation(pc)
; ---------------------------------------------------------------------------

loc_7C630:
                jsr     (Run_PalRotationScript).l
                jsr     Animate_RawMultiDelayFlipX(pc)
                jsr     (Swing_UpAndDown).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_7C646:
                move.b  #$3C,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_7C64E:
                jmp     (Run_PalRotationScript).l
; ---------------------------------------------------------------------------

loc_7C654:
                move.b  #$42,routine(a0)
                rts
