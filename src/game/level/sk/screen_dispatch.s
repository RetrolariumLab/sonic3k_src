; Owner: game/level/sk
; Responsibility: Level screen and background setup, event dispatch and paired zone callback catalogs
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

LevelSetup:
                clr.b   (Background_collision_flag).w
                bclr    #7,(Disable_wall_grab).w
                clr.l   (Plane_double_update_flag).w
                clr.w   (Special_events_routine).w
                clr.l   (Level_repeat_offset).w
                clr.l   (Events_routine_fg).w
                clr.l   (Events_fg_4).w
                clr.w   (Screen_shake_flag).w
                clr.l   (Screen_shake_offset).w
                clr.l   (Plane_buffer_2_addr).w
                clr.l   (Glide_screen_shake).w
                clr.w   (HPZ_special_stage_completed).w
                clr.w   (_unkFAC0).w
                clr.w   (HPZ_current_special_stage).w
                clr.w   (Palette_fade_timer).w
                clr.l   (Events_bg+$00).w
                clr.l   (Events_bg+$04).w
                clr.l   (Events_bg+$08).w
                clr.l   (Events_bg+$0C).w
                move.w  #$FFF,(Screen_Y_wrap_value).w
                move.w  #$FF0,(Camera_Y_pos_mask).w
                move.w  #$7C,(Layout_row_index_mask).w
                move.w  (Camera_X_pos).w,(Camera_X_pos_copy).w
                move.w  (Camera_Y_pos).w,(Camera_Y_pos_copy).w
                lea     (Plane_buffer).w,a0
                lea     (Block_table).w,a2
                lea     (Level_layout_main).w,a3
                move.w  #VRAM_Plane_A_Name_Table,d7
                move.w  (Current_zone_and_act).w,d0
                ror.b   #2,d0
                lsr.w   #3,d0
                movea.l LevelSetupArray(pc,d0.w),a1
                jsr     (a1)
                addq.w  #2,a3
                move.w  #VRAM_Plane_B_Name_Table,d7
                move.w  (Current_zone_and_act).w,d0
                ror.b   #2,d0
                lsr.w   #3,d0
                movea.l LevelSetupArray+4(pc,d0.w),a1
                jsr     (a1)
                move.w  (Camera_Y_pos_copy).w,(V_scroll_value).w
                move.w  (Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w
                rts

; =============== S U B R O U T I N E =======================================

ScreenEvents:
                move.w  (Camera_X_pos).w,(Camera_X_pos_copy).w
                move.w  (Camera_Y_pos).w,(Camera_Y_pos_copy).w
                jsr     ShakeScreen_BG(pc)
                lea     (Plane_buffer).w,a0
                lea     (Block_table).w,a2
                lea     (Level_layout_main).w,a3
                move.w  #VRAM_Plane_A_Name_Table,d7
                move.w  (Current_zone_and_act).w,d0
                ror.b   #2,d0
                lsr.w   #3,d0
                movea.l LevelEventArray(pc,d0.w),a1
                jsr     (a1)
                addq.w  #2,a3
                move.w  #VRAM_Plane_B_Name_Table,d7
                move.w  (Current_zone_and_act).w,d0
                ror.b   #2,d0
                lsr.w   #3,d0
                movea.l LevelEventArray+4(pc,d0.w),a1
                jsr     (a1)
                move.w  (Camera_Y_pos_copy).w,(V_scroll_value).w
                move.w  (Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w
                rts
; End of function ScreenEvents

; ---------------------------------------------------------------------------
LevelSetupArray:    dc.l    AIZ1_ScreenInit, AIZ1_BackgroundInit
                dc.l    AIZ2_ScreenInit, AIZ2_BackgroundInit
LevelEventArray:    dc.l    AIZ1_ScreenEvent, AIZ1_BackgroundEvent
                dc.l    AIZ2_ScreenEvent, AIZ2_BackgroundEvent
                dc.l    HCZ1_ScreenInit, HCZ1_BackgroundInit
                dc.l    HCZ2_ScreenInit, HCZ2_BackgroundInit
                dc.l    HCZ1_ScreenEvent, HCZ1_BackgroundEvent
                dc.l    HCZ2_ScreenEvent, HCZ2_BackgroundEvent
                dc.l    MGZ1_ScreenInit, MGZ1_BackgroundInit
                dc.l    MGZ2_ScreenInit, MGZ2_BackgroundInit
                dc.l    MGZ1_ScreenEvent, MGZ1_BackgroundEvent
                dc.l    MGZ2_ScreenEvent, MGZ2_BackgroundEvent
                dc.l    CNZ1_ScreenInit, CNZ1_BackgroundInit
                dc.l    CNZ2_ScreenInit, CNZ2_BackgroundInit
                dc.l    CNZ1_ScreenEvent, CNZ1_BackgroundEvent
                dc.l    CNZ2_ScreenEvent, CNZ2_BackgroundEvent
                dc.l    FBZ1_ScreenInit, FBZ1_BackgroundInit
                dc.l    FBZ2_ScreenInit, FBZ2_BackgroundInit
                dc.l    FBZ1_ScreenEvent, FBZ1_BackgroundEvent
                dc.l    FBZ2_ScreenEvent, FBZ2_BackgroundEvent
                dc.l    ICZ1_ScreenInit, ICZ1_BackgroundInit
                dc.l    ICZ2_ScreenInit, ICZ2_BackgroundInit
                dc.l    ICZ1_ScreenEvent, ICZ1_BackgroundEvent
                dc.l    ICZ2_ScreenEvent, ICZ2_BackgroundEvent
                dc.l    LBZ1_ScreenInit, LBZ1_BackgroundInit
                dc.l    LBZ2_ScreenInit, LBZ2_BackgroundInit
                dc.l    LBZ1_ScreenEvent, LBZ1_BackgroundEvent
                dc.l    LBZ2_ScreenEvent, LBZ2_BackgroundEvent
                dc.l    MHZ1_ScreenInit, MHZ1_BackgroundInit
                dc.l    MHZ2_ScreenInit, MHZ2_BackgroundInit
                dc.l    MHZ1_ScreenEvent, MHZ1_BackgroundEvent
                dc.l    MHZ2_ScreenEvent, MHZ2_BackgroundEvent
                dc.l    SOZ1_ScreenInit, SOZ1_BackgroundInit
                dc.l    SOZ2_ScreenInit, SOZ2_BackgroundInit
                dc.l    SOZ1_ScreenEvent, SOZ1_BackgroundEvent
                dc.l    SOZ2_ScreenEvent, SOZ2_BackgroundEvent
                dc.l    LRZ1_ScreenInit, LRZ1_BackgroundInit
                dc.l    LRZ2_ScreenInit, LRZ2_BackgroundInit
                dc.l    LRZ1_ScreenEvent, LRZ1_BackgroundEvent
                dc.l    LRZ2_ScreenEvent, LRZ2_BackgroundEvent
                dc.l    SSZ1_ScreenInit, SSZ1_BackgroundInit
                dc.l    SSZ2_ScreenInit, SSZ2_BackgroundInit
                dc.l    SSZ1_ScreenEvent, SSZ1_BackgroundEvent
                dc.l    SSZ2_ScreenEvent, SSZ2_BackgroundEvent
                dc.l    DEZ1_ScreenInit, DEZ1_BackgroundInit
                dc.l    DEZ2_ScreenInit, DEZ2_BackgroundInit
                dc.l    DEZ1_ScreenEvent, DEZ1_BackgroundEvent
                dc.l    DEZ2_ScreenEvent, DEZ2_BackgroundEvent
                dc.l    DDZ_ScreenInit,  DDZ_BackgroundInit
                dc.l    DDZ_ScreenInit,  DDZ_BackgroundInit
                dc.l    DDZ_ScreenEvent, DDZ_BackgroundEvent
                dc.l    DDZ_ScreenEvent, DDZ_BackgroundEvent
                dc.l    Ending_ScreenInit, Ending_BackgroundInit
                dc.l    Ending_ScreenInit, Ending_BackgroundInit
                dc.l    Ending_ScreenEvent, Ending_BackgroundEvent
                dc.l    Ending_ScreenEvent, Ending_BackgroundEvent
                dc.l    Comp_ScreenInit, ALZ_BackgroundInit
                dc.l    Comp_ScreenInit, ALZ_BackgroundInit
                dc.l    Comp_ScreenEvent, ALZ_BackgroundEvent
                dc.l    Comp_ScreenEvent, ALZ_BackgroundEvent
                dc.l    Comp_ScreenInit, BPZ_BackgroundInit
                dc.l    Comp_ScreenInit, BPZ_BackgroundInit
                dc.l    Comp_ScreenEvent, BPZ_BackgroundEvent
                dc.l    Comp_ScreenEvent, BPZ_BackgroundEvent
                dc.l    Comp_ScreenInit, DPZ_BackgroundInit
                dc.l    Comp_ScreenInit, DPZ_BackgroundInit
                dc.l    Comp_ScreenEvent, DPZ_BackgroundEvent
                dc.l    Comp_ScreenEvent, DPZ_BackgroundEvent
                dc.l    Comp_ScreenInit, CGZ_BackgroundInit
                dc.l    Comp_ScreenInit, CGZ_BackgroundInit
                dc.l    CGZ_ScreenEvent, CGZ_BackgroundEvent
                dc.l    CGZ_ScreenEvent, CGZ_BackgroundEvent
                dc.l    Comp_ScreenInit, EMZ_BackgroundInit
                dc.l    Comp_ScreenInit, EMZ_BackgroundInit
                dc.l    Comp_ScreenEvent, EMZ_BackgroundEvent
                dc.l    Comp_ScreenEvent, EMZ_BackgroundEvent
                dc.l    Gumball_ScreenInit, Gumball_BackgroundInit
                dc.l    Gumball_ScreenInit, Gumball_BackgroundInit
                dc.l    Gumball_ScreenEvent, Gumball_BackgroundEvent
                dc.l    Gumball_ScreenEvent, Gumball_BackgroundEvent
                dc.l    Pachinko_ScreenInit, Pachinko_BackgroundInit
                dc.l    Pachinko_ScreenInit, Pachinko_BackgroundInit
                dc.l    Pachinko_ScreenEvent, Pachinko_BackgroundEvent
                dc.l    Pachinko_ScreenEvent, Pachinko_BackgroundEvent
                dc.l    Slots_ScreenInit, Slots_BackgroundInit
                dc.l    Slots_ScreenInit, Slots_BackgroundInit
                dc.l    Slots_ScreenEvent, Slots_BackgroundEvent
                dc.l    Slots_ScreenEvent, Slots_BackgroundEvent
                dc.l    LRZ3_ScreenInit, LRZ3_BackgroundInit
                dc.l    HPZ_ScreenInit,  HPZ_BackgroundInit
                dc.l    LRZ3_ScreenEvent, LRZ3_BackgroundEvent
                dc.l    HPZ_ScreenEvent, HPZ_BackgroundEvent
                dc.l    DEZ3_ScreenInit, DEZ3_BackgroundInit
                dc.l    HPZS_ScreenInit, HPZS_BackgroundInit
                dc.l    DEZ3_ScreenEvent, DEZ3_BackgroundEvent
                dc.l    HPZS_ScreenEvent, HPZS_BackgroundEvent
