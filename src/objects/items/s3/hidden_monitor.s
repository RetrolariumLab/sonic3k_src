; Owner: objects/items/s3
; Responsibility: Reveal a hidden item monitor after its trigger and spawn its monitor contents
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
                movea.w (Signpost_addr).w,a1
                cmpi.l  #Obj_EndSign,(a1)
                bne.s   S3HiddenMonitor_CullUnrevealed  ; If no signpost is active, branch
                btst    #0,$38(a1)
                beq.s   S3HiddenMonitor_CullUnrevealed  ; If signpost hasn't landed, branch
                lea     S3HiddenMonitor_SignTriggerRect(pc),a2
                move.w  x_pos(a0),d0
                move.w  x_pos(a1),d1
                add.w   (a2)+,d0
                cmp.w   d0,d1
                blo.s   S3HiddenMonitor_RejectAndCull
                add.w   (a2)+,d0
                cmp.w   d0,d1
                bhs.s   S3HiddenMonitor_RejectAndCull
                move.w  y_pos(a0),d0
                move.w  y_pos(a1),d1
                add.w   (a2)+,d0
                cmp.w   d0,d1
                blo.s   S3HiddenMonitor_RejectAndCull
                add.w   (a2)+,d0
                cmp.w   d0,d1
                blo.s   S3HiddenMonitor_RevealFromSign

S3HiddenMonitor_RejectAndCull:
                moveq   #signextendB(sfx_GroundSlide),d0  ; If signpost has landed
                jsr     (Play_SFX).l
                move.l  #Sprite_OnScreen_Test,(a0)

S3HiddenMonitor_CullUnrevealed:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

S3HiddenMonitor_RevealFromSign:
                bclr    #0,$38(a1)                      ; If signpost has landed and is in range
                move.l  #Obj_Monitor,(a0)               ; make this object a monitor
                move.b  #2,routine(a0)
                move.b  #4,$3C(a0)
                move.w  #-$500,y_vel(a0)
                moveq   #signextendB(sfx_BubbleAttack),d0
                jsr     (Play_SFX).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
S3HiddenMonitor_SignTriggerRect:
                dc.w    -$E,   $1C,  -$80,   $C0
ObjDat_HiddenMonitor:
                dc.l    Map_Monitor
                dc.w    make_art_tile(ArtTile_Monitors,0,0)
                dc.w    $180
                dc.b    $E, $10,   0,   0
