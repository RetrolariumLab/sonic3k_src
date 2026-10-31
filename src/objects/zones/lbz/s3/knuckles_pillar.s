; Owner: objects/zones/lbz/s3
; Responsibility: Launch Base Knuckles cutscene pillar creation, motion and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZKnuxPillar:
                lea     ObjDat_LBZKnuxPillar(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #1,render_flags(a0)
                beq.s   loc_4543C
                bset    #7,art_tile(a0)

loc_4543C:
                bclr    #0,render_flags(a0)
                beq.s   loc_4544A
                move.w  #0,priority(a0)

loc_4544A:
                move.l  #loc_45450,(a0)

loc_45450:
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_LBZKnuxPillar:
                include "src/objects/shared/zones/lbz/mappings/knuckles_pillar.s"
; End of function Obj_LBZKnuxPillar
