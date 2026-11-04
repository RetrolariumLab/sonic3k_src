; Owner: objects/cutscenes/hpz/sk
; Responsibility: Hidden Palace scene platforms, collisions, displacement and timed display callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

HPZScenePlatform_InitFixedPosition:
                lea     SKHpzEscape_PlatformAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #HPZScenePlatform_ResolveSolidAndBreak,(a0)
                move.w  #$17F0,x_pos(a0)
                move.w  #$660,y_pos(a0)

HPZScenePlatform_ResolveSolidAndBreak:
                moveq   #$1B,d1
                moveq   #$20,d2
                moveq   #$20,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                tst.b   (ZoneEventLatchOrBossReleaseSignal).w
                beq.s   HPZScenePlatform_DrawAfterSolidCheck
                lea     SKSceneData_HPZPlatformFragmentChildren(pc),a2
                jsr     (CreateChild6_Simple).l
                jsr     (Go_Delete_Sprite).l

HPZScenePlatform_DrawAfterSolidCheck:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
; unused
                dc.w    -$18,   $30,  -$20,   $40
; ---------------------------------------------------------------------------

HPZScenePlatform_InitFragmentAndScatter:
                lea     SKSceneData_HPZPlatformFragmentPartAttrs(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #HPZScenePlatform_ApplyGravityIfVisible,(a0)
                bset    #7,render_flags(a0)
                bra.w   SKScene_HPZSeedPlatformFragment
; ---------------------------------------------------------------------------

HPZScenePlatform_ApplyGravityIfVisible:
                tst.b   render_flags(a0)
                bpl.s   HPZScenePlatform_ReleaseRidersAndDelete
                jsr     (MoveSprite_LightGravity).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HPZScenePlatform_ReleaseRidersAndDelete:
                jsr     (Displace_PlayerOffObject).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

HPZScenePlatform_InitDizzyStarsLifetime:
                lea     SKHpzKnuckles_DizzyStarsAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #HPZScenePlatform_TickDizzyStarsAnim,(a0)
                move.w  #$63,$2E(a0)
                tst.b   subtype(a0)
                beq.w   SKAIZScene_SharedSceneReturn
                move.l  #Wait_Draw,(a0)
                bra.w   HPZScenePlatform_ShowFinalStarsAndDelete
; ---------------------------------------------------------------------------

HPZScenePlatform_TickDizzyStarsAnim:
                subq.w  #1,$2E(a0)
                bmi.s   HPZScenePlatform_PauseDizzyStarsHidden
                lea     SKHpzKnuckles_DizzyStarsFrameLoop(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

HPZScenePlatform_PauseDizzyStarsHidden:
                move.l  #Wait_Draw,(a0)
                clr.b   mapping_frame(a0)
                move.w  #$3F,$2E(a0)
                move.l  #HPZScenePlatform_ShowFinalStarsAndDelete,$34(a0)
                rts
; ---------------------------------------------------------------------------

HPZScenePlatform_ShowFinalStarsAndDelete:
                move.b  #5,mapping_frame(a0)
                move.w  #$B,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
