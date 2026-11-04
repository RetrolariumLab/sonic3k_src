; Owner: objects/zones/dez/sk
; Responsibility: Gravity swap trigger detection and player gravity transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZGravitySwap:
                move.w  #$20,$30(a0)
                move.w  x_pos(a0),d1
                lea     (Player_1).w,a1
                cmp.w   x_pos(a1),d1
                bhs.s   SKDEZGravSwap_InitP1Crossing
                move.b  #1,$32(a0)

SKDEZGravSwap_InitP1Crossing:
                move.l  #SKDEZGravSwap_UpdateP1Crossing,(a0)

SKDEZGravSwap_UpdateP1Crossing:
                move.w  x_pos(a0),d1
                lea     $32(a0),a2
                lea     (Player_1).w,a1
                bsr.s   SetDezGravityOnPlayerCrossing
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

SetDezGravityOnPlayerCrossing:
                tst.b   (a2)+
                bne.w   SKDEZGravSwap_LatchLeftAndSetGravity
                cmp.w   x_pos(a1),d1
                bhi.s   SKDEZGravSwap_CrossingReturn
                move.b  #1,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $30(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.s   SKDEZGravSwap_CrossingReturn
                cmp.w   d3,d4
                bge.s   SKDEZGravSwap_CrossingReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKDEZGravSwap_CrossingReturn
                move.b  #0,(Reverse_gravity_flag).w
                btst    #0,render_flags(a0)
                bne.s   SKDEZGravSwap_CrossingReturn
                move.b  #1,(Reverse_gravity_flag).w

SKDEZGravSwap_CrossingReturn:
                rts
; ---------------------------------------------------------------------------

SKDEZGravSwap_LatchLeftAndSetGravity:
                cmp.w   x_pos(a1),d1
                bls.s   SKDEZGravSwap_CrossingReturn
                move.b  #0,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $30(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.s   SKDEZGravSwap_CrossingReturn
                cmp.w   d3,d4
                bge.s   SKDEZGravSwap_CrossingReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKDEZGravSwap_CrossingReturn
                move.b  #0,(Reverse_gravity_flag).w
                btst    #0,render_flags(a0)
                beq.s   SKDEZGravSwap_CrossingReturn
                move.b  #1,(Reverse_gravity_flag).w
                rts
; End of function SetDezGravityOnPlayerCrossing
