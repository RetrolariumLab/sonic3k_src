; Owner: memory/shared
; Responsibility: Master clocks, Z80 bus registers and Mega Drive hardware ports
; Source provenance and ranges: config/reconstruction/source_layout.json

                padding off
; ---------------------------------------------------------------------------
; Clock equates
; ---------------------------------------------------------------------------

Master_Clock:       equ     53693175
M68000_Clock:       equ     Master_Clock/7
Z80_Clock:          equ     Master_Clock/15
FM_Sample_Rate:     equ     M68000_Clock/(6*6*4)
PSG_Sample_Rate:    equ     Z80_Clock/16

; ---------------------------------------------------------------------------
; Address equates
; ---------------------------------------------------------------------------

; Z80 addresses
Z80_RAM:            equ     $A00000                     ; start of Z80 RAM
Z80_RAM_end:        equ     $A02000                     ; end of non-reserved Z80 RAM
Z80_bus_request:    equ     $A11100
Z80_reset:          equ     $A11200

SRAM_access_flag:   equ     $A130F1
Security_addr:      equ     $A14000
; ---------------------------------------------------------------------------

; I/O Area
HW_Version:             equ     $A10001
HW_Port_1_Data:         equ     $A10003
HW_Port_2_Data:         equ     $A10005
HW_Expansion_Data:      equ     $A10007
HW_Port_1_Control:      equ     $A10009
HW_Port_2_Control:      equ     $A1000B
HW_Expansion_Control:   equ     $A1000D
HW_Port_1_TxData:       equ     $A1000F
HW_Port_1_RxData:       equ     $A10011
HW_Port_1_SCtrl:        equ     $A10013
HW_Port_2_TxData:       equ     $A10015
HW_Port_2_RxData:       equ     $A10017
HW_Port_2_SCtrl:        equ     $A10019
HW_Expansion_TxData:    equ     $A1001B
HW_Expansion_RxData:    equ     $A1001D
HW_Expansion_SCtrl:     equ     $A1001F
; ---------------------------------------------------------------------------

; VDP addresses
VDP_data_port:      equ     $C00000
VDP_control_port:   equ     $C00004
PSG_input:          equ     $C00011
; ---------------------------------------------------------------------------

; RAM addresses
