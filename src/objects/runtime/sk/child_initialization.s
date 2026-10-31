; Owner: objects/runtime/sk
; Responsibility: Child priority propagation and fixed-size word record copying
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Child_GetPriority:
                movea.w parent3(a0),a1
                bclr    #7,art_tile(a0)
                btst    #7,art_tile(a1)
                beq.s   loc_85A72
                bset    #7,art_tile(a0)

loc_85A72:
                move.w  priority(a1),priority(a0)
                rts
; End of function Child_GetPriority

; =============== S U B R O U T I N E =======================================

Child_GetPriorityOnce:
                movea.w parent3(a0),a1
                btst    #7,art_tile(a1)
                beq.s   locret_85A8E
                bset    #7,art_tile(a0)
                move.l  (sp),(a0)

locret_85A8E:
                rts
; End of function Child_GetPriorityOnce

; =============== S U B R O U T I N E =======================================

CopyWordData_7:
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+

CopyWordData_6:
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+

CopyWordData_5:
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+
; End of function CopyWordData_7

; =============== S U B R O U T I N E =======================================

CopyWordData_4:
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+
; End of function CopyWordData_4

; =============== S U B R O U T I N E =======================================

CopyWordData_3:
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+

CopyWordData_2:
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+
                movea.w (a1)+,a3
                move.w  (a2)+,(a3)+
                rts
; End of function CopyWordData_3
