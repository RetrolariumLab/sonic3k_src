; Owner: objects/bonus/gumball/sk
; Responsibility: Gumball triangle bumper collision response, animation and score interaction
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_GumballTriangleBumper:
                lea     SKGumball_TriangleBumperAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKGumball_GateTriangleOnCooldown,(a0)

SKGumball_GateTriangleOnCooldown:
                tst.w   ((RAM_start+$2020)&$FFFFFF).l
                bpl.s   SKGumball_DrawTriangleBumper
                moveq   #$D,d1
                moveq   #8,d2
                moveq   #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                btst    #$10,d6
                bne.s   SKGumball_LaunchP1AndDeleteTriangle
                btst    #p1_standing_bit,status(a0)
                beq.s   SKGumball_CheckTriangleP2Contact

SKGumball_LaunchP1AndDeleteTriangle:
                lea     (Player_1).w,a1
                bsr.w   SKGumballTriangle_LaunchAndClear
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKGumball_CheckTriangleP2Contact:
                btst    #$11,d6
                bne.s   SKGumball_LaunchP2AndDeleteTriangle
                btst    #p2_standing_bit,status(a0)
                beq.s   SKGumball_DrawTriangleBumper

SKGumball_LaunchP2AndDeleteTriangle:
                lea     (Player_2).w,a1
                bsr.w   SKGumballTriangle_LaunchAndClear
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKGumball_DrawTriangleBumper:
                jmp     (Draw_Sprite).l
; End of function Obj_GumballTriangleBumper
