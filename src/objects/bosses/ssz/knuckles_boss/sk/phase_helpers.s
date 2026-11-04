; Owner: objects/bosses/ssz/knuckles_boss/sk
; Responsibility: Knuckles Mecha Sonic phase transitions, child motion and private movement or response helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_7C65C:
                jsr     (MoveSprite_LightGravity).l
                cmpi.w  #$400,y_vel(a0)
                bge.s   loc_7C66C
                rts
; ---------------------------------------------------------------------------

loc_7C66C:
                move.b  #$44,routine(a0)
                lea     (MechaSonic_RestoreSuperPaletteScript).l,a1

; =============== S U B R O U T I N E =======================================

InstallSingleGlobalPaletteRotationScript:
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                rts
; End of function InstallSingleGlobalPaletteRotationScript

; ---------------------------------------------------------------------------

loc_7C684:
                jsr     (Run_PalRotationScript).l
                bclr    #7,$38(a0)
                cmpi.l  #MechaSonic_RestoreSuperPaletteScript.header,(Palette_rotation_data+4).w
                beq.s   loc_7C6A0
                bset    #7,$38(a0)

loc_7C6A0:
                move.w  y_vel(a0),d0
                addi.w  #-$40,d0
                cmpi.w  #-$400,d0
                blt.s   loc_7C6B2
                move.w  d0,y_vel(a0)

loc_7C6B2:
                jsr     (MoveSprite2).l
                move.w  (_unkFAB0).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_7C6C4
                rts
; ---------------------------------------------------------------------------

loc_7C6C4:
                move.w  d0,y_pos(a0)
                move.b  #$3C,routine(a0)
                move.b  #6,$39(a0)
                move.w  #$100,d0
                move.w  d0,$3E(a0)
                neg.w   d0
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bset    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_7C6F0:
                jsr     (Run_PalRotationScript).l
                jsr     Animate_RawMultiDelay(pc)
                beq.w   SSZMechaBattleAndChildren_SharedReturn
                cmpi.b  #8,anim_frame(a0)
                bne.w   SSZMechaBattleAndChildren_SharedReturn
                moveq   #signextendB(sfx_BossProjectile),d0
                jsr     (Play_SFX).l
                lea     SSZMecha_RadialBurstChild(pc),a2
                jmp     CreateChild6_Simple(pc)
; ---------------------------------------------------------------------------

loc_7C718:
                move.b  #$3C,routine(a0)
                move.w  #$7F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_7C726:
                lea     SSZSuperMechaRadialProjectile_Attributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_7C738,(a0)
                bsr.w   SSZSuperMechaShot_InitEightWayVel

loc_7C738:
                jsr     (MoveSprite2).l
                jmp     (Sprite_CheckDeleteTouchXY).l
; ---------------------------------------------------------------------------

loc_7C744:
                lea     SSZMechaLaser_Attributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_7C756,(a0)
                bsr.w   SSZMechaLaser_SelectAnimAndCallback

loc_7C756:
                jsr     Animate_Raw(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------

loc_7C764:
                move.l  #loc_7C77A,(a0)
                moveq   #signextendB(sfx_BossLaser),d0
                jsr     (Play_SFX).l
                moveq   #2,d5
                jmp     (SKAimVelocity_LoadP1Position).l
; ---------------------------------------------------------------------------

loc_7C77A:
                lea     SSZMechaLaser_FlightUniformRawAnimation(pc),a1
                jsr     Animate_RawNoSST(pc)
                jsr     (MoveSprite2).l
                jmp     (Sprite_CheckDeleteTouchXY).l
; ---------------------------------------------------------------------------

loc_7C78E:
                lea     SSZMechaActiveEffect_Attributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_7C79C,(a0)

loc_7C79C:
                lea     SSZMechaActiveEffect_UniformRawAnimation(pc),a1
                jsr     Animate_RawNoSST(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #6,$38(a1)
                beq.w   loc_7C8F8
                cmpi.b  #$12,mapping_frame(a1)
                bne.w   SSZMechaBattleAndChildren_SharedReturn
                btst    #0,(V_int_run_count+3).w
                lea     SSZMechaActiveParticle_SimpleChildRecord(pc),a2
                jsr     CreateChild6_Simple(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7C7D4:
                lea     SSZMechaActiveParticle_PartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_7C80A,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                jsr     (Random_Number).l
                andi.w  #$1F,d0
                subi.w  #$F,d0
                add.w   d0,x_pos(a0)
                swap    d0
                andi.w  #$1F,d0
                subi.w  #$F,d0
                add.w   d0,y_pos(a0)

loc_7C80A:
                lea     SSZMecha_ActiveParticleDeleteAnim(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7C818:
                lea     SSZMechaMasterEmerald_Attributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  (Camera_max_X_pos).w,d0
                addi.w  #$100,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$A8,d0
                move.w  d0,y_pos(a0)
                move.l  #loc_7C864,(a0)
                lea     (Collected_emeralds_array).w,a1
                moveq   #3,d0
                moveq   #7-1,d1

loc_7C846:
                cmp.b   (a1)+,d0
                bne.s   locret_7C854
                dbf     d1,loc_7C846
                move.l  #loc_7C856,(a0)

locret_7C854:
                rts
; ---------------------------------------------------------------------------

loc_7C856:
                lea     SSZMasterEmeraldColorCycle_IndexedScript(pc),a1
                lea     (Normal_palette_line_3+$1C).w,a2
                jsr     (Run_PalRotationScript2).l

loc_7C864:
                move.b  #0,mapping_frame(a0)
                btst    #6,(_unkFAB8).w
                beq.s   loc_7C878
                move.b  #1,mapping_frame(a0)

loc_7C878:
                tst.b   (_unkFAA2).w
                bne.w   loc_7C8F8
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7C886:
                lea     SSZMechaSignalEffect_Attributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                movea.w parent3(a0),a1
                btst    #2,render_flags(a1)
                bne.s   loc_7C8A0
                bclr    #2,render_flags(a0)

loc_7C8A0:
                move.l  #loc_7C8BA,(a0)
                move.l  #SSZMecha_ParentReleaseSignalAnim,$30(a0)
                move.l  #loc_7C8C4,$34(a0)
                jsr     Refresh_ChildPositionAdjusted(pc)

loc_7C8BA:
                jsr     Animate_RawMultiDelay(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7C8C4:
                move.l  #loc_7C8D6,(a0)
                movea.w parent3(a0),a1
                bclr    #6,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_7C8D6:
                move.b  #-7,child_dx(a0)
                move.b  #3,child_dy(a0)
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                cmpi.b  #$E,mapping_frame(a1)
                bne.s   loc_7C8F8
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7C8F8:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_7C8FE:
                addq.b  #4,subtype(a0)

loc_7C902:
                lea     SSZMechaRollingTrail_Attributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_7C91C,(a0)
                bsr.w   SSZMechaTrail_InitOffsetsAndPriority
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l

loc_7C91C:
                lea     SSZMechaRollingTrail_RawAnimation(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_7C942
                btst    #2,$38(a1)
                beq.s   loc_7C942
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7C942:
                jmp     (Go_Delete_Sprite).l
