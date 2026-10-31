; Owner: objects/bosses/cnz/miniboss/sk
; Responsibility: Carnival Night miniboss battle controller, top actor and block explosion state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZMiniboss:
                move.w  #$31E0,d0
                cmp.w   (Camera_X_pos).w,d0             ; Wait for Player to get in range
                bls.s   loc_6D9A8
                rts
; ---------------------------------------------------------------------------

loc_6D9A8:
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w  ; X end to FFFA92
                move.w  #$1C0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_min_X_pos).w         ; Set X start
                addi.w  #$80,d0
                move.w  d0,(Camera_max_X_pos).w         ; Set X end
                move.w  #$2B8,(Camera_max_Y_pos).w
                move.w  #$2B8,(Camera_target_max_Y_pos).w  ; Set Y end
                move.l  #Obj_Wait,(a0)
                move.w  #2*60,$2E(a0)                   ; Wait for 2 seconds
                move.l  #Obj_CNZMinibossGo,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l                  ; Fade out music
                move.b  #1,(Boss_flag).w                ; Lock screen
                moveq   #PLCID_5D,d0
                jsr     (Load_PLC).l                    ; Load CNZ Miniboss PLC
                lea     Pal_CNZMiniboss(pc),a1          ; Load CNZ Miniboss palette
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

Obj_CNZMinibossGo:
                move.l  #Obj_CNZMinibossStart,(a0)
                moveq   #signextendB(mus_Miniboss),d0
                jsr     (Play_Music).l                  ; Play miniboss music
                move.b  #mus_Miniboss,(Current_music+1).w
                jsr     (AllocateObject).l
                bne.s   locret_6DA22
                move.l  #Obj_CNZMinibossScrollControl,(a1)

locret_6DA22:
                rts
; ---------------------------------------------------------------------------

Obj_CNZMinibossStart:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CNZMiniboss_Index(pc,d0.w),d1
                jsr     CNZMiniboss_Index(pc,d1.w)
                bsr.w   CNZMiniboss_MoveDown
                jsr     (Run_PalRotationScript).l
                bsr.w   CNZMiniboss_CheckPlayerHit
                bsr.w   CNZMiniboss_CheckTopHit
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
CNZMiniboss_Index:
                dc.w    Obj_CNZMinibossInit-CNZMiniboss_Index
                dc.w    Obj_CNZMinibossLower-CNZMiniboss_Index
                dc.w    Obj_CNZMinibossMove-CNZMiniboss_Index
                dc.w    Obj_CNZMinibossMove-CNZMiniboss_Index
                dc.w    Obj_CNZMinibossOpening-CNZMiniboss_Index
                dc.w    Obj_CNZMinibossWaitHit-CNZMiniboss_Index
                dc.w    Obj_CNZMinibossClosing-CNZMiniboss_Index
                dc.w    Obj_CNZMinibossLower2-CNZMiniboss_Index
; ---------------------------------------------------------------------------

Obj_CNZMinibossInit:
                lea     ObjDat_CNZMiniboss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #6,collision_property(a0)       ; 6 hits (for some reason)
                move.b  #4,$45(a0)
                bset    #3,$38(a0)
                move.w  #$80,y_vel(a0)                  ; Initial vertical speed
                move.w  #$11F,$2E(a0)                   ; Wait amount
                move.l  #Obj_CNZMinibossGo2,$34(a0)
                lea     Child1_CNZMinibossMakeTop(pc),a2  ; Make the little top
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

Obj_CNZMinibossLower:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

Obj_CNZMinibossGo2:
                move.b  #4,routine(a0)
                clr.w   y_vel(a0)
                bset    #1,$38(a0)
                move.w  #$90,$2E(a0)
                move.l  #Obj_CNZMinibossGo3,$34(a0)
                bra.w   SetUp_CNZMinibossSwing
; ---------------------------------------------------------------------------

Obj_CNZMinibossMove:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

Obj_CNZMinibossGo3:
                move.w  #$100,x_vel(a0)
                move.w  #$9F,$2E(a0)

Obj_CNZMinibossCloseGo:
                move.b  #6,routine(a0)
                move.l  #Obj_CNZMinibossChangeDir,$34(a0)
                bclr    #3,$38(a0)
                lea     (PalSPtr_CNZMinibossNormal).l,a1
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                move.l  #CNZMiniboss_MakeTimedSparks,(Palette_rotation_custom).w
                rts
; ---------------------------------------------------------------------------

Obj_CNZMinibossChangeDir:
                neg.w   x_vel(a0)
                move.w  #$13F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

Obj_CNZMinibossOpening:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

Obj_CNZMinibossOpenGo:
                move.b  #$A,routine(a0)
                move.l  #Obj_CNZMinibossChangeDir,$34(a0)
                bset    #6,$38(a0)                      ; Set Open state
                move.b  #$7F,$3B(a0)
                lea     Child1_CNZCoilOpenSparks(pc),a2  ; Create spark objects for coil
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

Obj_CNZMinibossWaitHit:
                btst    #6,status(a0)
                bne.s   loc_6DB4E
                rts
; ---------------------------------------------------------------------------

loc_6DB4E:
                move.b  #$C,routine(a0)
                bclr    #6,$38(a0)
                move.l  #AniRaw_CNZMinibossClosing,$30(a0)
                move.l  #Obj_CNZMinibossCloseGo,$34(a0)
                rts
; ---------------------------------------------------------------------------

Obj_CNZMinibossClosing:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

Obj_CNZMinibossLower2:
                addq.w  #1,y_pos(a0)
                subq.b  #1,$43(a0)
                bmi.s   loc_6DB7E
                rts
; ---------------------------------------------------------------------------

loc_6DB7E:
                move.b  $42(a0),routine(a0)
                rts
; ---------------------------------------------------------------------------

Obj_CNZMinibossEnd:
                move.l  #Obj_Wait,(a0)
                st      (_unkFAA8).w                    ; Set end of level flag
                bset    #4,$38(a0)
                move.l  #Obj_CNZMinibossEndGo,$34(a0)
                lea     Child6_CNZMinibossMakeDebris(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------
; unused
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

Obj_CNZMinibossEndGo:
                move.l  #Obj_EndSignControlAwaitStart,(a0)
                clr.b   (Boss_flag).w                   ; Unlock level
                jsr     (AfterBoss_Cleanup).l
                lea     (PLC_EndSignStuff).l,a1         ; Get ready to start act 2 after sign finishes
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

Obj_CNZMinibossTop:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CNZMinibossTop_Index(pc,d0.w),d1
                jsr     CNZMinibossTop_Index(pc,d1.w)
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
CNZMinibossTop_Index:
                dc.w    Obj_CNZMinibossTopInit-CNZMinibossTop_Index
                dc.w    Obj_CNZMinibossTopWait-CNZMinibossTop_Index
                dc.w    Obj_CNZMinibossTopWait2-CNZMinibossTop_Index
                dc.w    Obj_CNZMinibossTopMain-CNZMinibossTop_Index
; ---------------------------------------------------------------------------

Obj_CNZMinibossTopInit:
                lea     ObjDat3_CNZMinibossTop(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.b  #$10,x_radius(a0)
                move.b  #8,y_radius(a0)
                rts
; ---------------------------------------------------------------------------

Obj_CNZMinibossTopWait:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   loc_6DC10                       ; Wait for signal from main boss
                jmp     (Refresh_ChildPosition).l
; ---------------------------------------------------------------------------

loc_6DC10:
                move.b  #4,routine(a0)
                move.l  #AniRaw_CNZMinibossTop,$30(a0)
                move.l  #Obj_CNZMinibossTopGo,$34(a0)
                rts
; ---------------------------------------------------------------------------

Obj_CNZMinibossTopWait2:
                jsr     (Refresh_ChildPosition).l
                jmp     (Animate_RawGetFaster).l
; ---------------------------------------------------------------------------

Obj_CNZMinibossTopGo:
                move.b  #6,routine(a0)
                move.l  #AniRaw_CNZMinibossTop2,$30(a0)
                move.w  #$200,x_vel(a0)
                move.w  #$200,y_vel(a0)                 ; Set initial speed of top
                rts
; ---------------------------------------------------------------------------

Obj_CNZMinibossTopMain:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.w   loc_6DDD2                       ; If parent has been destroyed, destroy this object
                move.w  x_pos(a0),-(sp)
                jsr     (MoveSprite2).l
                moveq   #$13,d1
                moveq   #$C,d2
                moveq   #8,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                jsr     (Animate_Raw).l
                tst.w   x_vel(a0)
                bmi.s   loc_6DCB0
                moveq   #$10,d3                         ; If moving to the right
                jsr     (ObjCheckRightWallDist).l
                tst.w   d1
                bmi.w   loc_6DD4C                       ; Reverse direction if block is hit from side
                move.w  x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$3380,d0
                bhs.w   loc_6DD8E                       ; Reverse direction if edge of screen is hit
                move.w  y_pos(a0),d1
                bsr.w   CNZMinibossTop_CheckHitBase
                bne.w   loc_6DD8E                       ; Reverse direction if miniboss base was hit
                bra.w   loc_6DCDA
; ---------------------------------------------------------------------------

loc_6DCB0:
                moveq   #-$10,d3                        ; If moving to the left
                jsr     (ObjCheckLeftWallDist).l
                tst.w   d1
                bmi.w   loc_6DD4C                       ; Reverse direction if wall was hit
                move.w  x_pos(a0),d0
                subi.w  #$10,d0
                cmpi.w  #$3200,d0
                blo.w   loc_6DD8E                       ; Reverse direction if edge of screen is hit
                move.w  y_pos(a0),d1
                bsr.w   CNZMinibossTop_CheckHitBase
                bne.w   loc_6DD8E                       ; Reverse direction if miniboss base was hit

loc_6DCDA:
                bsr.w   CNZMinibossTop_CheckPlayerBounce
                bne.w   loc_6DDCC                       ; If bounce was detected, reverse direction
                tst.w   y_vel(a0)
                bmi.s   loc_6DD1E
                jsr     (ObjCheckFloorDist).l           ; If moving downward, check for hitting the blocks
                tst.w   d1
                bmi.w   loc_6DD94                       ; If hit, reverse direction
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                addq.w  #8,d1
                move.w  (Camera_Y_pos).w,d2
                addi.w  #$E0,d2
                cmp.w   d2,d1
                bhs.w   loc_6DDCC                       ; If bottom of screen was hit, bounce
                cmpi.w  #$380,d1
                bhi.w   loc_6DDCC                       ; Maximum lower bound is $380
                bsr.w   CNZMinibossTop_CheckHitBase
                bne.w   loc_6DDCC                       ; If base was hit, bounce
                rts
; ---------------------------------------------------------------------------

loc_6DD1E:
                jsr     (ObjCheckCeilingDist).l         ; If moving upward, check for hitting the blocks from below
                tst.w   d1
                bmi.s   loc_6DD94                       ; If hit, reverse direction
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                subq.w  #8,d1
                cmp.w   (Camera_Y_pos).w,d1
                bls.w   loc_6DDCC                       ; If top of screen was hit, bounce
                cmpi.w  #$240,d1
                bls.w   loc_6DDCC                       ; Maximum upper bound is $240
                bsr.w   CNZMinibossTop_CheckHitBase
                bne.w   loc_6DDCC                       ; If base was hit, bounce
                rts
; ---------------------------------------------------------------------------

loc_6DD4C:
                lea     Child1_CNZBounceEffect(pc),a2
                jsr     (CreateChild1_Normal).l
                bne.s   loc_6DD64
                tst.w   x_vel(a0)
                bmi.s   loc_6DD64
                bset    #0,render_flags(a1)

loc_6DD64:
                moveq   #$10,d0
                neg.w   x_vel(a0)                       ; Change direction
                bmi.s   loc_6DD6E
                neg.w   d0

loc_6DD6E:
                add.w   x_pos(a0),d0
                cmpi.w  #$3200,d0
                bls.s   locret_6DD8C
                cmpi.w  #$3380,d0
                bhs.s   locret_6DD8C                    ; If the walls were hit somehow, don't do anything
                move.w  d0,(Events_bg+$00).w
                move.w  y_pos(a0),(Events_bg+$02).w     ; Move X/Y positions into special variables for removing the blocks from the level layout
                bsr.w   CNZMiniboss_BlockExplosion

locret_6DD8C:
                rts
; ---------------------------------------------------------------------------

loc_6DD8E:
                neg.w   x_vel(a0)                       ; Simple direction switch
                rts
; ---------------------------------------------------------------------------

loc_6DD94:
                move.w  x_pos(a0),d0
                moveq   #8,d1
                neg.w   y_vel(a0)
                bmi.s   loc_6DDA2
                neg.w   d1

loc_6DDA2:
                add.w   y_pos(a0),d1
                cmpi.w  #$3200,d0
                bls.s   locret_6DD8C
                cmpi.w  #$3380,d0
                bhs.s   locret_6DD8C
                cmpi.w  #$300,d1
                blo.s   locret_6DD8C
                cmpi.w  #$3380,d1
                bhs.s   locret_6DD8C
                move.w  d0,(Events_bg+$00).w            ; Move X/Y positions into special variables see above
                move.w  d1,(Events_bg+$02).w
                bsr.w   CNZMiniboss_BlockExplosion
                rts
; ---------------------------------------------------------------------------

loc_6DDCC:
                neg.w   y_vel(a0)                       ; Simple direction switch
                rts
; ---------------------------------------------------------------------------

loc_6DDD2:
                lea     Child1_CNZMinibossExplosion(pc),a2
                jsr     (CreateChild1_Normal).l
                move.b  #6,subtype(a1)
                clr.b   collision_flags(a0)
                jsr     (Displace_PlayerOffObject).l
                jmp     (Go_Delete_Sprite).l

; =============== S U B R O U T I N E =======================================

CNZMiniboss_BlockExplosion:
                lea     Child1_CNZMinibossExplosion(pc),a2
                jsr     (CreateChild1_Normal).l
                bne.s   locret_6DE24
                move.b  #6,subtype(a1)
                move.w  (Events_bg+$00).w,d0
                andi.w  #$FFE0,d0
                addi.w  #$10,d0
                move.w  d0,x_pos(a1)
                move.w  (Events_bg+$02).w,d0
                andi.w  #$FFE0,d0
                addi.w  #$10,d0
                move.w  d0,y_pos(a1)

locret_6DE24:
                rts
; End of function CNZMiniboss_BlockExplosion
