; Owner: objects/shared/s3
; Responsibility: Sinking mud contact, player depth control and movement response
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SinkingMud:
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                move.b  d0,width_pixels(a0)
                move.w  y_pos(a0),$30(a0)
                move.b  #$30,$38(a0)
                move.b  #$30,$3A(a0)
                bset    #7,status(a0)
                move.l  #S3SinkingMud_UpdateCompP1Depth,(a0)
                tst.w   (Competition_mode).w
                bne.w   S3SinkingMud_UpdateCompP1Depth
                move.l  #S3SinkingMud_UpdateNormalP1Depth,(a0)

S3SinkingMud_UpdateNormalP1Depth:
                tst.w   (Debug_placement_mode).w
                bne.w   S3SinkingMud_CullNormalMudWithoutDrawing
                lea     (Player_1).w,a1
                btst    #p1_standing_bit,status(a0)
                bne.s   S3SinkingMud_DrainNormalP1OrKill
                cmpi.b  #$30,$38(a0)
                bhs.s   S3SinkingMud_CopyNormalP1Depth
                addq.b  #2,$38(a0)

S3SinkingMud_CopyNormalP1Depth:
                btst    #Status_OnObj,status(a1)
                beq.s   S3SinkingMud_CollideNormalP1AndCheckP2
                movea.w interact(a1),a2
                cmpi.l  #S3SinkingMud_UpdateNormalP1Depth,(a2)
                bne.s   S3SinkingMud_CollideNormalP1AndCheckP2
                move.b  $38(a2),$38(a0)
                bra.s   S3SinkingMud_CollideNormalP1AndCheckP2
; ---------------------------------------------------------------------------

S3SinkingMud_DrainNormalP1OrKill:
                tst.b   $38(a0)
                beq.s   S3SinkingMud_ResetNormalP1BeforeKill
                subq.b  #1,$38(a0)

S3SinkingMud_CollideNormalP1AndCheckP2:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #0,d3
                move.b  $38(a0),d3
                moveq   #p1_standing_bit,d6
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop_1P).l
                lea     (Player_2).w,a1
                btst    #p2_standing_bit,status(a0)
                bne.s   S3SinkingMud_DrainNormalP2OrKill
                cmpi.b  #$30,$3A(a0)
                bhs.s   S3SinkingMud_CopyNormalP2Depth
                addq.b  #2,$3A(a0)

S3SinkingMud_CopyNormalP2Depth:
                btst    #Status_OnObj,status(a1)
                beq.s   S3SinkingMud_CollideNormalP2
                movea.w interact(a1),a2
                cmpi.l  #S3SinkingMud_UpdateNormalP1Depth,(a2)
                bne.s   S3SinkingMud_CollideNormalP2
                move.b  $3A(a2),$3A(a0)
                bra.s   S3SinkingMud_CollideNormalP2
; ---------------------------------------------------------------------------

S3SinkingMud_DrainNormalP2OrKill:
                tst.b   $3A(a0)
                beq.s   S3SinkingMud_ResetNormalP2BeforeKill
                subq.b  #1,$3A(a0)

S3SinkingMud_CollideNormalP2:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #0,d3
                move.b  $3A(a0),d3
                moveq   #p2_standing_bit,d6
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop_1P).l

S3SinkingMud_CullNormalMudWithoutDrawing:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

S3SinkingMud_ResetNormalP1BeforeKill:
                move.b  #$30,$38(a0)
                bra.s   S3SinkingMud_KillNormalRider
; ---------------------------------------------------------------------------

S3SinkingMud_ResetNormalP2BeforeKill:
                move.b  #$30,$3A(a0)

; The original code masks status with the complement of the incoming d1 byte
S3SinkingMud_KillNormalRider:
                not.b   d1
                and.b   d1,status(a0)
                move.l  a0,-(sp)
                movea.l a0,a2
                movea.l a1,a0
                jsr     (Kill_Character).l
                movea.l (sp)+,a0
                rts
; ---------------------------------------------------------------------------

S3SinkingMud_UpdateCompP1Depth:
                tst.w   (Debug_placement_mode).w
                bne.w   S3SinkingMud_CompUpdateReturn
                lea     (Player_1).w,a1
                btst    #p1_standing_bit,status(a0)
                bne.s   S3SinkingMud_DrainCompP1OrKill
                cmpi.b  #$30,$38(a0)
                bhs.s   S3SinkingMud_CopyCompP1Depth
                addq.b  #2,$38(a0)

; Copy only from a contacted object running the normal mud handler
S3SinkingMud_CopyCompP1Depth:
                btst    #Status_OnObj,status(a1)
                beq.s   S3SinkingMud_CollideCompP1AtHalfHeight
                movea.w interact(a1),a2
                cmpi.l  #S3SinkingMud_UpdateNormalP1Depth,(a2)
                bne.s   S3SinkingMud_CollideCompP1AtHalfHeight
                move.b  $38(a2),$38(a0)
                bra.s   S3SinkingMud_CollideCompP1AtHalfHeight
; ---------------------------------------------------------------------------

S3SinkingMud_DrainCompP1OrKill:
                tst.b   $38(a0)
                beq.s   S3SinkingMud_ResetCompP1BeforeKill
                subq.b  #1,$38(a0)

S3SinkingMud_CollideCompP1AtHalfHeight:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #0,d3
                move.b  $38(a0),d3
                lsr.w   #1,d3
                moveq   #p1_standing_bit,d6
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop_1P).l
                lea     (Player_2).w,a1
                btst    #p2_standing_bit,status(a0)
                bne.s   S3SinkingMud_DrainCompP2OrKill
                cmpi.b  #$30,$3A(a0)
                bhs.s   S3SinkingMud_CopyCompP2Depth
                addq.b  #2,$3A(a0)

; Copy only from a contacted object running the normal mud handler
S3SinkingMud_CopyCompP2Depth:
                btst    #Status_OnObj,status(a1)
                beq.s   S3SinkingMud_CollideCompP2AtHalfHeight
                movea.w interact(a1),a2
                cmpi.l  #S3SinkingMud_UpdateNormalP1Depth,(a2)
                bne.s   S3SinkingMud_CollideCompP2AtHalfHeight
                move.b  $3A(a2),$3A(a0)
                bra.s   S3SinkingMud_CollideCompP2AtHalfHeight
; ---------------------------------------------------------------------------

S3SinkingMud_DrainCompP2OrKill:
                tst.b   $3A(a0)
                beq.s   S3SinkingMud_ResetCompP2BeforeKill
                subq.b  #1,$3A(a0)

S3SinkingMud_CollideCompP2AtHalfHeight:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #0,d3
                move.b  $3A(a0),d3
                lsr.w   #1,d3
                moveq   #p2_standing_bit,d6
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop_1P).l

S3SinkingMud_CompUpdateReturn:
                rts
; ---------------------------------------------------------------------------

S3SinkingMud_ResetCompP1BeforeKill:
                move.b  #$30,$38(a0)
                bra.s   S3SinkingMud_KillCompRider
; ---------------------------------------------------------------------------

S3SinkingMud_ResetCompP2BeforeKill:
                move.b  #$30,$3A(a0)

; The original code masks status with the complement of the incoming d1 byte
S3SinkingMud_KillCompRider:
                not.b   d1
                and.b   d1,status(a0)
                move.l  a0,-(sp)
                movea.l a0,a2
                movea.l a1,a0
                jsr     (Kill_Character).l
                movea.l (sp)+,a0
                rts
