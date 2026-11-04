; Owner: objects/zones/aiz/sk
; Responsibility: Angel Island collapsing log bridge timing, log and fire fragments and shared bridge mappings
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_AIZCollapsingLogBridge:
                move.b  subtype(a0),d0
                bmi.w   SKCollapseLog_InitFireBridge
                move.b  d0,$36(a0)
                addi.b  #$30,d0
                move.b  d0,$35(a0)
                move.b  #8,$37(a0)
                move.l  #Map_AIZCollapsingLogBridge,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,0),art_tile(a0)
                move.b  #$5A,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.b  #4,render_flags(a0)             ; oddly, this is not an ori like the child sprites, however it doesn't matter in normal gameplay as this object only faces one direction
                move.w  #$200,priority(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKCollapseLog_StartStandingBridge
                move.l  #SKCollapseLog_CullOrDrawBridge,(a1)
                move.l  #Map_AIZCollapsingLogBridge,mappings(a1)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.b  #$5A,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.w  #$200,priority(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                bset    #6,render_flags(a1)
                move.w  #6,mainspr_childsprites(a1)
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                subi.w  #$4B,d3
                lea     sub2_x_pos(a1),a2
                move.w  mainspr_childsprites(a1),d6
                subq.w  #1,d6
                move.w  #1,4(a2)

SKCollapseLog_WriteLogChildPositions:
                move.w  d3,(a2)+
                move.w  d2,(a2)+
                addq.w  #2,a2
                addi.w  #$1E,d3
                dbf     d6,SKCollapseLog_WriteLogChildPositions
                move.w  #2,-2(a2)
                move.w  a1,$3C(a0)

SKCollapseLog_StartStandingBridge:
                move.l  #SKCollapseLog_TrySplitStandingBridge,(a0)
                bra.w   SKCollapseLog_TrySplitStandingBridge
; ---------------------------------------------------------------------------

SKCollapseLog_InitFireBridge:
                andi.b  #$7F,d0
                move.b  d0,$36(a0)
                addi.b  #$30,d0
                move.b  d0,$35(a0)
                move.b  #8,$37(a0)
                move.l  #Map_AIZDrawBridgeFire,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,1),art_tile(a0)
                move.b  #$60,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.b  #4,render_flags(a0)             ; oddly, this is not an ori like the child sprites, however it doesn't matter in normal gameplay as this object only faces one direction
                move.w  #$200,priority(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKCollapseLog_StartGlobalFireBridge
                move.l  #SKCollapseLog_CullOrDrawBridge,(a1)
                move.l  #Map_AIZDrawBridgeFire,mappings(a1)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,1),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.b  #$60,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.w  #$200,priority(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                bset    #6,render_flags(a1)
                move.w  #6,mainspr_childsprites(a1)
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                subi.w  #$50,d3
                lea     sub2_x_pos(a1),a2
                move.w  mainspr_childsprites(a1),d6
                subq.w  #1,d6
                move.w  #1,4(a2)

SKCollapseLog_WriteFireChildPositions:
                move.w  d3,(a2)+
                move.w  d2,(a2)+
                addq.w  #2,a2
                addi.w  #$20,d3
                dbf     d6,SKCollapseLog_WriteFireChildPositions
                move.w  #2,-2(a2)
                move.w  a1,$3C(a0)

SKCollapseLog_StartGlobalFireBridge:
                move.l  #SKCollapseLog_TrySplitFireBridge,(a0)
                bra.w   SKCollapseLog_TrySplitFireBridge
; ---------------------------------------------------------------------------

SKCollapseLog_TrySplitStandingBridge:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   SKCollapseLog_CheckLogTopSolid
                move.b  $35(a0),$34(a0)
                move.b  $36(a0),d2
                move.b  $37(a0),d3
                move.l  #SKCollapseLog_TickBridgeCollapse,(a0)
                move.l  #SKCollapseLog_WaitLogFragment,d4
                bsr.w   SplitAizCollapsingBridgeSprites

SKCollapseLog_CheckLogTopSolid:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #0,d3
                move.b  height_pixels(a0),d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

SKCollapseLog_CullOrDrawBridge:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKCollapseLog_WaitLogFragment:
                tst.b   $34(a0)
                beq.s   SKCollapseLog_FallLogFragment
                subq.b  #1,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKCollapseLog_FallLogFragment:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bpl.s   SKCollapseLog_DeleteLogFragment
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKCollapseLog_DeleteLogFragment:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKCollapseLog_TrySplitFireBridge:
                tst.b   (_unkFAA2).w
                beq.s   SKCollapseLog_CheckFireTopSolid
                move.b  $35(a0),$34(a0)
                move.b  $36(a0),d2
                move.b  $37(a0),d3
                move.l  #SKCollapseLog_TickBridgeCollapse,(a0)
                move.l  #SKCollapseLog_WaitFireFragment,d4
                bsr.w   SplitAizCollapsingBridgeSprites

SKCollapseLog_CheckFireTopSolid:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #0,d3
                move.b  height_pixels(a0),d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

SKCollapseLog_WaitFireFragment:
                tst.b   $34(a0)
                beq.s   SKCollapseLog_AnimateFireFragment
                subq.b  #1,$34(a0)
                bne.s   SKCollapseLog_DrawWaitingFireFragment
                move.b  #3,mapping_frame(a0)

SKCollapseLog_DrawWaitingFireFragment:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKCollapseLog_AnimateFireFragment:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKCollapseLog_FallFireFragment
                move.b  #3,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #8,mapping_frame(a0)
                blo.s   SKCollapseLog_FallFireFragment
                move.b  #3,mapping_frame(a0)

SKCollapseLog_FallFireFragment:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bpl.s   SKCollapseLog_DeleteFireFragment
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKCollapseLog_DeleteFireFragment:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKCollapseLog_TickBridgeCollapse:
                subq.b  #1,$34(a0)
                bne.s   SKCollapseLog_CheckRidersForRelease
                move.l  #SKDrawbridge_TickFinalRiderDelay,(a0)

SKCollapseLog_CheckRidersForRelease:
                move.b  $34(a0),d3
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   ReleasePlayerFromCollapsingAizLogSegment
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.s   ReleasePlayerFromCollapsingAizLogSegment
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

ReleasePlayerFromCollapsingAizLogSegment:
                btst    d6,status(a0)
                beq.s   SKCollapseLog_RiderReleaseReturn
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   SKCollapseLog_ReleaseBridgeRider
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKCollapseLog_ReleaseBridgeRider
                cmp.w   d2,d0
                bhs.s   SKCollapseLog_ReleaseBridgeRider
                btst    #0,status(a0)
                beq.s   SKCollapseLog_CheckRiderSegmentDeadline
                neg.w   d0
                add.w   d2,d0

SKCollapseLog_CheckRiderSegmentDeadline:
                lsr.w   #5,d0
                add.w   d0,d0
                add.w   d0,d0
                add.w   d0,d0
                add.b   $36(a0),d0
                move.b  $35(a0),d2
                sub.b   d0,d2
                cmp.b   d2,d3
                bhi.s   SKCollapseLog_RiderReleaseReturn

SKCollapseLog_ReleaseBridgeRider:
                bclr    d6,status(a0)
                bclr    #Status_OnObj,status(a1)
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,prev_anim(a1)

SKCollapseLog_RiderReleaseReturn:
                rts
; End of function ReleasePlayerFromCollapsingAizLogSegment

; =============== S U B R O U T I N E =======================================

SplitAizCollapsingBridgeSprites:
                movea.w $3C(a0),a3
                lea     sub2_x_pos(a3),a2
                move.w  mainspr_childsprites(a3),d6
                subq.w  #1,d6
                bclr    #6,render_flags(a3)
                movea.l a3,a1
                bra.s   SKCollapseLog_InitFragmentFromChild
; ---------------------------------------------------------------------------

SKCollapseLog_TryNextFragment:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKCollapseLog_ClearChildCoordsAndSound

SKCollapseLog_InitFragmentFromChild:
                move.l  d4,(a1)
                move.l  mappings(a3),mappings(a1)
                move.b  render_flags(a3),render_flags(a1)
                move.w  art_tile(a3),art_tile(a1)
                move.w  priority(a3),priority(a1)
                move.b  width_pixels(a3),width_pixels(a1)
                move.b  height_pixels(a3),height_pixels(a1)
                move.w  (a2)+,x_pos(a1)
                move.w  (a2)+,y_pos(a1)
                move.w  (a2)+,d0
                move.b  d0,mapping_frame(a1)
                move.b  d2,$34(a1)
                add.b   d3,d2
                dbf     d6,SKCollapseLog_TryNextFragment

; Clear the embedded X and Y words reused by the root's velocity fields
SKCollapseLog_ClearChildCoordsAndSound:
                move.w  #0,sub2_x_pos(a3)
                move.w  #0,sub2_y_pos(a3)
                moveq   #signextendB(sfx_Collapse),d0
                jmp     (Play_SFX).l
; End of function SplitAizCollapsingBridgeSprites

; ---------------------------------------------------------------------------
Map_AIZCollapsingLogBridge:
                include "src/objects/shared/zones/aiz/mappings/collapsing_log_bridge.s"
Map_AIZDrawBridgeFire:
                include "src/objects/shared/zones/aiz/mappings/draw_bridge_fire.s"
