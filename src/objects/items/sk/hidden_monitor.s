; Owner: objects/items/sk
; Responsibility: Reveal hidden item monitors after triggers and initialize their contents
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HiddenMonitor:
                lea     ObjDat_HiddenMonitor(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #Obj_HiddenMonitorMain,(a0)
                move.b  #$F,y_radius(a0)
                move.b  #$F,x_radius(a0)
                move.b  #$46,collision_flags(a0)
                move.b  subtype(a0),anim(a0)            ; Backup object subtype
                rts
; ---------------------------------------------------------------------------

Obj_HiddenMonitorMain:
                move.w  (Signpost_addr).w,d0
                beq.s   SKHiddenMonitor_CullUnrevealed
                movea.w d0,a1
                cmpi.l  #Obj_EndSign,(a1)
                bne.s   SKHiddenMonitor_CullUnrevealed  ; If no signpost is active, branch
                btst    #0,$38(a1)
                beq.s   SKHiddenMonitor_CullUnrevealed  ; If signpost hasn't landed, branch
                lea     SKHiddenMonitor_SignTriggerRect(pc),a2
                move.w  x_pos(a0),d0
                move.w  x_pos(a1),d1
                add.w   (a2)+,d0
                cmp.w   d0,d1
                blo.s   SKHiddenMonitor_RejectAndCull
                add.w   (a2)+,d0
                cmp.w   d0,d1
                bhs.s   SKHiddenMonitor_RejectAndCull
                move.w  y_pos(a0),d0
                move.w  y_pos(a1),d1
                add.w   (a2)+,d0
                cmp.w   d0,d1
                blo.s   SKHiddenMonitor_RejectAndCull
                add.w   (a2)+,d0
                cmp.w   d0,d1
                blo.s   SKHiddenMonitor_RevealFromSign

SKHiddenMonitor_RejectAndCull:
                moveq   #signextendB(sfx_GroundSlide),d0  ; If signpost has landed
                jsr     (Play_SFX).l
                move.l  #Sprite_OnScreen_Test,(a0)

SKHiddenMonitor_CullUnrevealed:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

SKHiddenMonitor_RevealFromSign:
                bclr    #0,$38(a1)                      ; If signpost has landed and is in range
                move.l  #Obj_Monitor,(a0)               ; make this object a monitor
                move.b  #2,routine(a0)
                move.b  #4,$3C(a0)
                move.w  #-$500,y_vel(a0)
                moveq   #signextendB(sfx_BubbleAttack),d0
                jsr     (Play_SFX).l
                bclr    #0,render_flags(a0)
                beq.s   SKHiddenMonitor_DrawRevealedBox
                bset    #7,art_tile(a0)
                clr.b   status(a0)

SKHiddenMonitor_DrawRevealedBox:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
SKHiddenMonitor_SignTriggerRect:
                dc.w    -$E,   $1C,  -$80,   $C0
ObjDat_HiddenMonitor:
                dc.l    Map_Monitor
                dc.w    make_art_tile(ArtTile_Monitors,0,0)
                dc.w    $280
                dc.b    $E, $10,   0,   0
