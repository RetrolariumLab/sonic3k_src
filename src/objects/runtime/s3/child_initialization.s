; Owner: objects/runtime/s3
; Responsibility: Child sprite priority propagation and fixed-size word record copying
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Child_GetPriority:
                movea.w parent3(a0),a1
                bclr    #7,art_tile(a0)
                btst    #7,art_tile(a1)
                beq.s   S3Child_CopyParentDrawPriority
                bset    #7,art_tile(a0)

S3Child_CopyParentDrawPriority:
                move.w  priority(a1),priority(a0)
                rts
; End of function Child_GetPriority

; =============== S U B R O U T I N E =======================================

Child_GetPriorityOnce:
                movea.w parent3(a0),a1
                btst    #7,art_tile(a1)
                beq.s   S3Child_GetPriorityOnceReturn
                bset    #7,art_tile(a0)
                move.l  (sp),(a0)

S3Child_GetPriorityOnceReturn:
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
