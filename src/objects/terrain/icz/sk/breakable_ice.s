; Owner: objects/terrain/icz/sk
; Responsibility: IceCap breakable wall and ice-block behavior, collision helpers and private construction data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZBreakableWall:
                lea     ObjDat_ICZBreakableWall(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_8A280,(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_8A280:
                moveq   #$2B,d1
                moveq   #$40,d2
                moveq   #$70,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   loc_8A2A0
                swap    d6
                andi.w  #1,d6
                bne.s   loc_8A2E2

loc_8A2A0:
                movea.w (_unkFAA4).w,a1
                cmpi.l  #Obj_ICZPathFollowPlatform_2,(a1)
                bne.s   loc_8A2DC
                move.w  x_pos(a1),d0
                move.w  y_pos(a1),d1
                and.w   (Screen_Y_wrap_value).w,d1
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                lea     word_8A2FC(pc),a2
                add.w   (a2)+,d2
                cmp.w   d2,d0
                blo.s   loc_8A2DC
                add.w   (a2)+,d2
                cmp.w   d2,d0
                bhs.s   loc_8A2DC
                add.w   (a2)+,d3
                cmp.w   d3,d1
                blo.s   loc_8A2DC
                add.w   (a2)+,d3
                cmp.w   d3,d1
                blo.s   loc_8A2E2

loc_8A2DC:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_8A2E2:
                lea     ChildObjDat_8A430(pc),a2
                jsr     CreateChild6_Simple(pc)
                jsr     Go_Delete_Sprite(pc)
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
word_8A2FC:
                dc.w    -$30,   $60,  -$40,   $80
; ---------------------------------------------------------------------------

loc_8A304:
                lea     ObjDat3_8A3FA(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_8A318,(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_8A318:
                movea.w parent3(a0),a1
                btst    #p1_standing_bit,status(a1)
                beq.s   loc_8A32A
                move.l  #MoveChkDel,(a0)

loc_8A32A:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_ICZIceBlock:
                jsr     (Obj_WaitOffscreen).l
                lea     ObjDat_ICZIceBlock(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_8A344,(a0)

loc_8A344:
                moveq   #$1B,d1
                moveq   #$10,d2
                moveq   #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

AcceptIczPlatformHorizontalVelocityInRange:
                cmpi.w  #-$C00,d0
                blt.s   locret_8A36A
                cmpi.w  #$C00,d0
                bgt.s   locret_8A36A
                move.w  d0,x_vel(a0)

locret_8A36A:
                rts
; End of function AcceptIczPlatformHorizontalVelocityInRange

; =============== S U B R O U T I N E =======================================

ApplyIczPlatformGravityWithinVelocityRange:
                move.w  y_vel(a0),d0
                addi.w  #$38,d0
                cmpi.w  #-$C00,d0
                blt.s   locret_8A384
                cmpi.w  #$C00,d0
                bgt.s   locret_8A384
                move.w  d0,y_vel(a0)

locret_8A384:
                rts
; End of function ApplyIczPlatformGravityWithinVelocityRange

; =============== S U B R O U T I N E =======================================

SetIczPlatformDepartureYVelocityFromAngle:
                move.b  angle(a0),d3
                lsr.b   #3,d3
                andi.w  #$E,d3
                move.w  x_vel(a0),d1
                bpl.s   loc_8A398
                neg.w   d1

loc_8A398:
                move.w  off_8A3A0(pc,d3.w),d0
                jmp     off_8A3A0(pc,d0.w)
; End of function SetIczPlatformDepartureYVelocityFromAngle

; ---------------------------------------------------------------------------
off_8A3A0:
                dc.w    loc_8A3B0-off_8A3A0
                dc.w    loc_8A3B6-off_8A3A0
                dc.w    loc_8A3BE-off_8A3A0
                dc.w    loc_8A3B6-off_8A3A0
                dc.w    loc_8A3B0-off_8A3A0
                dc.w    loc_8A3B6-off_8A3A0
                dc.w    loc_8A3BE-off_8A3A0
                dc.w    loc_8A3B6-off_8A3A0
; ---------------------------------------------------------------------------

loc_8A3B0:
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_8A3B6:
                lsr.w   #1,d1
                move.w  d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_8A3BE:
                move.w  d1,y_vel(a0)
                rts

; =============== S U B R O U T I N E =======================================

SetFastVerticalCameraForIczPlatformRider:
                clr.b   (Fast_V_scroll_flag).w
                tst.w   x_vel(a0)
                bne.s   loc_8A3D4
                tst.w   y_vel(a0)
                beq.s   locret_8A3E0

loc_8A3D4:
                btst    #p1_standing_bit,status(a0)
                beq.s   locret_8A3E0
                st      (Fast_V_scroll_flag).w

locret_8A3E0:
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
ObjDat3_8A3FA:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $10,  $C,   8,   0
ObjDat_ICZBreakableWall:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $20, $40,   6,   0
ObjDat3_8A412:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,1)
                dc.w    $80
                dc.b    8,   8, $23,   0
ObjDat3_8A41E:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZIntroSprites,2,1)
                dc.w    $80
                dc.b    $C,  $C, $1C,   0
ChildObjDat_8A42A:
                dc.w    6-1
                dc.l    loc_8A1D4
ChildObjDat_8A430:
                dc.w    9-1
                dc.l    loc_8A20C
ChildObjDat_8A436:
                dc.w    1-1
                dc.l    loc_8A304
                dc.b    -$10, $10
byte_8A43E:
                dc.b    2, $23, $13, $24, $14, $FC
byte_8A444:
                dc.b    2, $1C, $1D, $25, $26, $FC
                even
