; Bank selection helpers, restart-vector assertions and cartridge pointer conversion
; Original driver statements retain their assembly order

                CPU     Z80
                listing purecode
NoteRest:       equ     080h
FirstCoordFlag: equ     0E0h
; ---------------------------------------------------------------------------
zID_PriorityList:   equ     0                           ; Earlier drivers had this; unused
zID_UniVoiceBank:   equ     2
zID_MusicPointers:  equ     4
zID_SFXPointers:    equ     6
zID_ModEnvPointers: equ     8
zID_VolEnvPointers: equ     0Ah
zID_SongLimit:      equ     0Ch                         ; Earlier drivers had this; unused
; ---------------------------------------------------------------------------

; ===========================================================================
; Macros
; ===========================================================================
bankswitch1     macro
                    ld      hl, zBankRegister
                    ld      (hl), a
                    rept    7
                    rrca
                    ld      (hl), a
                endm
                xor     a
                ld      (hl), a
                endm

bankswitch2     macro
                    ld      hl, zBankRegister
                    ld      (hl), a
                    rept    7
                    rra
                    ld      (hl), a
                endm
                xor     a
                ld      (hl), a
                endm

bankswitch3     macro
                    ld      b, 8

                    .bankloop:
                    ld      (zBankRegister), a
                    rrca
                    djnz    .bankloop
                    xor     a
                    ld      (zBankRegister), a
                endm

bankswitchToMusic   macro
                    ld      hl, zBankRegister
                    ld      a, (zSongBank)
                    ld      (hl), a
                    rept    7
                    rra
                    ld      (hl), a
                endm
                xor     a
                ld      (hl), a
                endm

bankswitchToMusicS3 macro
; Hardcoded to only support 4-bit bank values
                    ld      (hl), a
                    rept    3
                    rra
                    ld      (hl), a
                endm
                xor     a
                ld      d, 1
                ld      (hl), d
                ld      (hl), a
                ld      (hl), a
                ld      (hl), a
                ld      (hl), a
                endm

bankswitchToSFX macro
                    if      SonicDriverVer==3
                    ld      hl,zBankRegister
                    xor     a                           ; a = 0
                    ld      e,1                         ; e = 1
                    .cnt:   set 0
                    rept    9
    ; this is either ld (hl),a or ld (hl),e
                    db      (73h|((((SndBank)&(1<<(15+.cnt)))==0)<<2))
                    .cnt:   set (.cnt+1)
                endm
                else
                ld      a, zmake68kBank(SndBank)        ; Get SFX bank ID
                bankswitch2                             ; Bank switch to SFX
                endif
                endm

; Assembly macro to make a certain error message clearer should you happen to get it
rsttarget       macro   {INTLABEL}
                    if      ($&7)||($>38h)
                    fatal   "Function __LABEL__ is at 0\{$}h, but must be at a multiple of 8 bytes <= 38h to be used with the rst instruction."
                    endif
                    if      "__LABEL__"<>""
__LABEL__:      label   $
                    endif
                endm

; function to turn a 68k address into a word the Z80 can use to access it
zmake68kPtr:    function addr,zROMWindow+(addr&7FFFh)

; function to turn a 68k address into a bank byte
zmake68kBank:   function addr,(((addr&3F8000h)/zROMWindow))

                if      SonicDriverVer==3
zmakeSongBank:  function addr,zmake68kBank(addr)&0Fh    ; See bankswitchToMusicS3
                else
zmakeSongBank:  function addr,zmake68kBank(addr)
                endif
; ---------------------------------------------------------------------------
; ===========================================================================
; Entry Point
