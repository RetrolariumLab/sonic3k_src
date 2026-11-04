; Owner: objects/bonus/gumball/sk
; Responsibility: Gumball triangle bumper collision response, animation and score interaction
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_GumballTriangleBumper:
                lea     ObjDat3_613A4(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_60F3E,(a0)

loc_60F3E:
                tst.w   ((RAM_start+$2020)&$FFFFFF).l
                bpl.s   loc_60F8E
                moveq   #$D,d1
                moveq   #8,d2
                moveq   #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                btst    #$10,d6
                bne.s   loc_60F64
                btst    #p1_standing_bit,status(a0)
                beq.s   loc_60F72

loc_60F64:
                lea     (Player_1).w,a1
                bsr.w   SKGumballTriangle_LaunchAndClear
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_60F72:
                btst    #$11,d6
                bne.s   loc_60F80
                btst    #p2_standing_bit,status(a0)
                beq.s   loc_60F8E

loc_60F80:
                lea     (Player_2).w,a1
                bsr.w   SKGumballTriangle_LaunchAndClear
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_60F8E:
                jmp     (Draw_Sprite).l
; End of function Obj_GumballTriangleBumper
