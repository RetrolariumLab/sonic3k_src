; Owner: objects/terrain/icz/s3
; Responsibility: IceCap breakable wall and ice-block behavior, collision helpers and private construction data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZBreakableWall:
                lea     ObjDat_ICZBreakableWall(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_57AA6,(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_57AA6:
                moveq   #$2B,d1
                moveq   #$40,d2
                moveq   #$70,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                movea.w (_unkFAA4).w,a1
                cmpi.l  #Obj_ICZPathFollowPlatform_2,(a1)
                bne.s   loc_57AF2
                move.w  x_pos(a1),d0
                move.w  y_pos(a1),d1
                and.w   (Screen_Y_wrap_value).w,d1
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                lea     word_57B12(pc),a2
                add.w   (a2)+,d2
                cmp.w   d2,d0
                blo.s   loc_57AF2
                add.w   (a2)+,d2
                cmp.w   d2,d0
                bhs.s   loc_57AF2
                add.w   (a2)+,d3
                cmp.w   d3,d1
                blo.s   loc_57AF2
                add.w   (a2)+,d3
                cmp.w   d3,d1
                blo.s   loc_57AF8

loc_57AF2:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_57AF8:
                lea     ChildObjDat_57C3A(pc),a2
                jsr     CreateChild6_Simple(pc)
                jsr     Go_Delete_Sprite(pc)
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
word_57B12:
                dc.w    -$30,   $60,  -$40,   $80
; ---------------------------------------------------------------------------

loc_57B1A:
                lea     ObjDat3_57C04(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_57B2E,(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_57B2E:
                movea.w parent3(a0),a1
                btst    #p1_standing_bit,status(a1)
                beq.s   loc_57B40
                move.l  #MoveChkDel,(a0)

loc_57B40:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_ICZIceBlock:
                jsr     (Obj_WaitOffscreen).l
                lea     ObjDat_ICZIceBlock(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_57B5A,(a0)

loc_57B5A:
                moveq   #$1B,d1
                moveq   #$10,d2
                moveq   #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

AcceptIczPlatformHorizontalVelocityInRange:
                cmpi.w  #-$C00,d0
                blt.s   locret_57B80
                cmpi.w  #$C00,d0
                bgt.s   locret_57B80
                move.w  d0,x_vel(a0)

locret_57B80:
                rts
; End of function AcceptIczPlatformHorizontalVelocityInRange

; =============== S U B R O U T I N E =======================================

ApplyIczPlatformGravityWithinVelocityRange:
                move.w  y_vel(a0),d0
                addi.w  #$38,d0
                cmpi.w  #-$C00,d0
                blt.s   locret_57B9A
                cmpi.w  #$C00,d0
                bgt.s   locret_57B9A
                move.w  d0,y_vel(a0)

locret_57B9A:
                rts
; End of function ApplyIczPlatformGravityWithinVelocityRange

; =============== S U B R O U T I N E =======================================

SetIczPlatformDepartureYVelocityFromAngle:
                move.b  angle(a0),d3
                lsr.b   #3,d3
                andi.w  #$E,d3
                move.w  x_vel(a0),d1
                bpl.s   loc_57BAE
                neg.w   d1

loc_57BAE:
                move.w  off_57BB6(pc,d3.w),d0
                jmp     off_57BB6(pc,d0.w)
; End of function SetIczPlatformDepartureYVelocityFromAngle

; ---------------------------------------------------------------------------
off_57BB6:
                dc.w    loc_57BC6-off_57BB6
                dc.w    loc_57BCC-off_57BB6
                dc.w    loc_57BD4-off_57BB6
                dc.w    loc_57BCC-off_57BB6
                dc.w    loc_57BC6-off_57BB6
                dc.w    loc_57BCC-off_57BB6
                dc.w    loc_57BD4-off_57BB6
                dc.w    loc_57BCC-off_57BB6
; ---------------------------------------------------------------------------

loc_57BC6:
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_57BCC:
                lsr.w   #1,d1
                move.w  d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_57BD4:
                move.w  d1,y_vel(a0)
                rts

; =============== S U B R O U T I N E =======================================

SetFastVerticalCameraForIczPlatformRider:
                clr.b   (Fast_V_scroll_flag).w
                btst    #p1_standing_bit,status(a0)
                beq.s   locret_57BEA
                st      (Fast_V_scroll_flag).w

locret_57BEA:
                rts
; End of function SetFastVerticalCameraForIczPlatformRider

; ---------------------------------------------------------------------------
ObjDat_ICZPathFollowPlatform:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $20, $14,   0,   0
ObjDat_ICZIceBlock:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,0)
                dc.w    $280
                dc.b    $10, $10, $1E,   0
ObjDat3_57C04:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $10,  $C,   8,   0
ObjDat_ICZBreakableWall:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $20, $40,   6,   0
ObjDat3_57C1C:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,1)
                dc.w    $80
                dc.b    8,   8, $23,   0
ObjDat3_57C28:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZIntroSprites,2,1)
                dc.w    $80
                dc.b    $C,  $C, $1C,   0
ChildObjDat_57C34:
                dc.w    6-1
                dc.l    loc_579FA
ChildObjDat_57C3A:
                dc.w    9-1
                dc.l    loc_57A32
ChildObjDat_57C40:
                dc.w    1-1
                dc.l    loc_57B1A
                dc.b    -$10, $10
byte_57C48:
                dc.b    2, $23, $13, $24, $14, $FC
byte_57C4E:
                dc.b    2, $1C, $1D, $25, $26, $FC
                even
