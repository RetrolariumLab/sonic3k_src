; Owner: objects/bosses/fbz/end_boss/sk
; Responsibility: Flying Battery boss exit door collision and departure actor
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZExitDoor:
                lea     ObjDat_FBZExitDoor(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_70C3C,(a0)

loc_70C3C:
                jsr     (Check_PlayerCollision).l
                bne.s   loc_70C4A
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_70C4A:
                move.l  #loc_70C66,(a0)
                move.w  #$800,x_vel(a0)
                lea     (Player_1).w,a1
                subq.w  #8,x_pos(a1)
                moveq   #signextendB(sfx_FloorThump),d0
                jsr     (Play_SFX).l

loc_70C66:
                jsr     (MoveSprite_LightGravity).l
                jmp     (Draw_Sprite).l
; End of function Obj_FBZExitDoor
