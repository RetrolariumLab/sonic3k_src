; Owner: audio/shared
; Responsibility: Audio bank boundaries, sample timing, bank-relative pointers and DAC metadata declarations
; Source provenance and ranges: config/reconstruction/source_layout.json
; Function to turn a sample rate into a djnz loop counter
pcmLoopCounterBase: function sampleRate,baseCycles, 1+(Z80_Clock/(sampleRate)-(baseCycles)+(13/2))/13
pcmLoopCounter:     function sampleRate, pcmLoopCounterBase(sampleRate,105)  ; 105 is the number of cycles zPlaySEGAPCM takes to deliver one sample
dpcmLoopCounter:    function sampleRate, pcmLoopCounterBase(sampleRate,303/2)  ; 303 is the number of cycles zPlayDigitalAudio takes to deliver two samples

little_endian:  function x,(x)<<8&$FF00|(x)>>8&$FF

; Function to make a little endian (z80) pointer
k68z80Pointer:  function addr,little_endian((addr#$8000)+$8000)

startBank       macro   {INTLABEL}
                    align   $8000
__LABEL__:      label   *
soundBankStart: set     __LABEL__
soundBankName:  set     "__LABEL__"
                endm

DebugSoundbanks:    set     0

finishBank      macro
                    if      * > soundBankStart + $8000
                    fatal   "soundBank \{soundBankName} must fit in $8000 bytes but was $\{*-soundBankStart}. Try moving something to the other bank."
                    elseif  (DebugSoundbanks<>0)&&(MOMPASS=1)
                    message "soundBank \{soundBankName} has $\{$8000+soundBankStart-*} bytes free at end."
                    endif
                endm

; Assembly macro to declare an entry in an offset table rooted at a bank
offsetBankTableEntry    macro   ptr
                    dc.ATTRIBUTE k68z80Pointer(ptr)
                endm

; Function magic for boolean arithmetic, because 'if' statements suffer from those annoying 'must be evaluable on first pass' errors
zero_if_false:  function boolean,value,value&(0-boolean)
zero_if_true:   function boolean,value,zero_if_false(~~boolean,value)
ternary:        function boolean,trueValue,falseValue,zero_if_false(boolean,trueValue)|zero_if_true(boolean,falseValue)

get_z80_bank:           function value,value-(value#$8000)
is_in_this_z80_bank:    function value,get_z80_bank(value)==get_z80_bank(*)

; Setup macro for DAC samples
DAC_Setup       macro   dacptr,sampleRateScale
                    if      "sampleRateScale"==""
                    DAC_Setup dacptr,1.0
                    else
                    dc.b    dpcmLoopCounter(int(dacptr.sample_rate*sampleRateScale))
; Your eyes are not deceiving you; DAC metadata does some truly bizarre things
; Basically, in Sonic 3, if the DAC sample is not in the same bank as this metadata,
; then the metadata will have blank pointers. An exception to this is when this is
; not the first metadata in the bank to reference the DAC sample, in which case it
; will point to the previous metadata instead. It makes absolutely no sense, but it
; must be recreated in order to produce a bit-perfect ROM
                    dc.w    zero_if_false((SonicDriverVer <> 3) || is_in_this_z80_bank(dacptr), little_endian(dacptr.size))
                    dc.w    ternary((SonicDriverVer <> 3) || is_in_this_z80_bank(dacptr), k68z80Pointer(dacptr), zero_if_false(is_in_this_z80_bank(dacptr.last_reference), k68z80Pointer(dacptr.last_reference)))
                    dacptr.last_reference: set *-2
                    endif
                endm

startDACBank    macro   {INTLABEL}
__LABEL__:      startBank
                    offsetBankTableEntry.w DAC_81_Setup
                    offsetBankTableEntry.w DAC_82_Setup
                    offsetBankTableEntry.w DAC_83_Setup
                    offsetBankTableEntry.w DAC_84_Setup
                    offsetBankTableEntry.w DAC_85_Setup
                    offsetBankTableEntry.w DAC_86_Setup
                    offsetBankTableEntry.w DAC_87_Setup
                    offsetBankTableEntry.w DAC_88_Setup
                    offsetBankTableEntry.w DAC_89_Setup
                    offsetBankTableEntry.w DAC_8A_Setup
                    offsetBankTableEntry.w DAC_8B_Setup
                    offsetBankTableEntry.w DAC_8C_Setup
                    offsetBankTableEntry.w DAC_8D_Setup
                    offsetBankTableEntry.w DAC_8E_Setup
                    offsetBankTableEntry.w DAC_8F_Setup
                    offsetBankTableEntry.w DAC_90_Setup
                    offsetBankTableEntry.w DAC_91_Setup
                    offsetBankTableEntry.w DAC_92_Setup
                    offsetBankTableEntry.w DAC_93_Setup
                    offsetBankTableEntry.w DAC_94_Setup
                    offsetBankTableEntry.w DAC_95_Setup
                    offsetBankTableEntry.w DAC_96_Setup
                    offsetBankTableEntry.w DAC_97_Setup
                    offsetBankTableEntry.w DAC_98_Setup
                    offsetBankTableEntry.w DAC_99_Setup
                    offsetBankTableEntry.w DAC_9A_Setup
                    offsetBankTableEntry.w DAC_9B_Setup
                    offsetBankTableEntry.w DAC_9C_Setup
                    offsetBankTableEntry.w DAC_9D_Setup
                    offsetBankTableEntry.w DAC_9E_Setup
                    offsetBankTableEntry.w DAC_9F_Setup
                    offsetBankTableEntry.w DAC_A0_Setup
                    offsetBankTableEntry.w DAC_A1_Setup
                    offsetBankTableEntry.w DAC_A2_Setup
                    offsetBankTableEntry.w DAC_A3_Setup
                    offsetBankTableEntry.w DAC_A4_Setup
                    offsetBankTableEntry.w DAC_A5_Setup
                    offsetBankTableEntry.w DAC_A6_Setup
                    offsetBankTableEntry.w DAC_A7_Setup
                    offsetBankTableEntry.w DAC_A8_Setup
                    offsetBankTableEntry.w DAC_A9_Setup
                    offsetBankTableEntry.w DAC_AA_Setup
                    offsetBankTableEntry.w DAC_AB_Setup
                    offsetBankTableEntry.w DAC_AC_Setup
                    offsetBankTableEntry.w DAC_AD_Setup
                    offsetBankTableEntry.w DAC_AE_Setup
                    offsetBankTableEntry.w DAC_AF_Setup
                    offsetBankTableEntry.w DAC_B0_Setup
                    offsetBankTableEntry.w DAC_B1_Setup
                    offsetBankTableEntry.w DAC_B2_Setup
                    offsetBankTableEntry.w DAC_B3_Setup
                    offsetBankTableEntry.w DAC_B4_Setup
                    offsetBankTableEntry.w DAC_B5_Setup
                    offsetBankTableEntry.w DAC_B6_Setup
                    offsetBankTableEntry.w DAC_B7_Setup
                    offsetBankTableEntry.w DAC_B8_B9_Setup
                    offsetBankTableEntry.w DAC_B8_B9_Setup
                    offsetBankTableEntry.w DAC_BA_Setup
                    offsetBankTableEntry.w DAC_BB_Setup
                    offsetBankTableEntry.w DAC_BC_Setup
                    offsetBankTableEntry.w DAC_BD_Setup
                    offsetBankTableEntry.w DAC_BE_Setup
                    offsetBankTableEntry.w DAC_BF_Setup
                    offsetBankTableEntry.w DAC_C0_Setup
                    offsetBankTableEntry.w DAC_C1_Setup
                    offsetBankTableEntry.w DAC_C2_Setup
                    offsetBankTableEntry.w DAC_C3_Setup
                    offsetBankTableEntry.w DAC_C4_Setup

; The first value is the sample's label,and the optional second value multiplies the sample rate
; A multiplier of 0.80 means that the sample will play a fifth slower
DAC_81_Setup:       DAC_Setup DAC_81_Data
DAC_82_Setup:       DAC_Setup DAC_82_83_84_85_Data
DAC_83_Setup:       DAC_Setup DAC_82_83_84_85_Data,0.80
DAC_84_Setup:       DAC_Setup DAC_82_83_84_85_Data,0.67
DAC_85_Setup:       DAC_Setup DAC_82_83_84_85_Data,0.58
DAC_86_Setup:       DAC_Setup DAC_86_Data
DAC_87_Setup:       DAC_Setup DAC_87_Data
DAC_88_Setup:       DAC_Setup DAC_88_Data
DAC_89_Setup:       DAC_Setup DAC_89_Data
DAC_8A_Setup:       DAC_Setup DAC_8A_8B_Data
DAC_8B_Setup:       DAC_Setup DAC_8A_8B_Data,0.82
DAC_8C_Setup:       DAC_Setup DAC_8C_Data
DAC_8D_Setup:       DAC_Setup DAC_8D_8E_Data
DAC_8E_Setup:       DAC_Setup DAC_8D_8E_Data,0.77
DAC_8F_Setup:       DAC_Setup DAC_8F_Data
DAC_90_Setup:       DAC_Setup DAC_90_91_92_93_Data
DAC_91_Setup:       DAC_Setup DAC_90_91_92_93_Data,0.78
DAC_92_Setup:       DAC_Setup DAC_90_91_92_93_Data,0.66
DAC_93_Setup:       DAC_Setup DAC_90_91_92_93_Data,0.56
DAC_94_Setup:       DAC_Setup DAC_94_95_96_97_Data
DAC_95_Setup:       DAC_Setup DAC_94_95_96_97_Data,0.79
DAC_96_Setup:       DAC_Setup DAC_94_95_96_97_Data,0.70
DAC_97_Setup:       DAC_Setup DAC_94_95_96_97_Data,0.58
DAC_98_Setup:       DAC_Setup DAC_98_99_9A_Data
DAC_99_Setup:       DAC_Setup DAC_98_99_9A_Data,0.73
DAC_9A_Setup:       DAC_Setup DAC_98_99_9A_Data,0.66
DAC_9B_Setup:       DAC_Setup DAC_9B_Data
DAC_A2_Setup:       DAC_Setup DAC_A2_Data
DAC_A3_Setup:       DAC_Setup DAC_A3_Data
DAC_A4_Setup:       DAC_Setup DAC_A4_Data
DAC_A5_Setup:       DAC_Setup DAC_A5_Data
DAC_A6_Setup:       DAC_Setup DAC_A6_Data
DAC_A7_Setup:       DAC_Setup DAC_A7_Data
DAC_A8_Setup:       DAC_Setup DAC_A8_Data
DAC_A9_Setup:       DAC_Setup DAC_A9_Data
DAC_AA_Setup:       DAC_Setup DAC_AA_Data
DAC_AB_Setup:       DAC_Setup DAC_AB_Data
DAC_AC_Setup:       DAC_Setup DAC_AC_Data
DAC_AD_Setup:       DAC_Setup DAC_AD_AE_Data
DAC_AE_Setup:       DAC_Setup DAC_AD_AE_Data,0.76
DAC_AF_Setup:       DAC_Setup DAC_AF_B0_Data
DAC_B0_Setup:       DAC_Setup DAC_AF_B0_Data,0.68
DAC_B1_Setup:       DAC_Setup DAC_B1_Data
DAC_B2_Setup:       DAC_Setup DAC_B2_B3_Data
DAC_B3_Setup:       DAC_Setup DAC_B2_B3_Data,0.76
DAC_B4_Setup:       DAC_Setup DAC_B4_C1_C2_C3_C4_Data
DAC_B5_Setup:       DAC_Setup DAC_B5_Data
DAC_B6_Setup:       DAC_Setup DAC_B6_Data
DAC_B7_Setup:       DAC_Setup DAC_B7_Data
DAC_B8_B9_Setup:    DAC_Setup DAC_B8_B9_Data
DAC_BA_Setup:       DAC_Setup DAC_BA_Data
DAC_BB_Setup:       DAC_Setup DAC_BB_Data
DAC_BC_Setup:       DAC_Setup DAC_BC_Data
DAC_BD_Setup:       DAC_Setup DAC_BD_Data
DAC_BE_Setup:       DAC_Setup DAC_BE_Data
DAC_BF_Setup:       DAC_Setup DAC_BF_Data
DAC_C0_Setup:       DAC_Setup DAC_C0_Data
DAC_C1_Setup:       DAC_Setup DAC_B4_C1_C2_C3_C4_Data,0.88
DAC_C2_Setup:       DAC_Setup DAC_B4_C1_C2_C3_C4_Data,0.82
DAC_C3_Setup:       DAC_Setup DAC_B4_C1_C2_C3_C4_Data,0.78
DAC_C4_Setup:       DAC_Setup DAC_B4_C1_C2_C3_C4_Data,1.04
DAC_9C_Setup:       DAC_Setup DAC_9C_Data
DAC_9D_Setup:       DAC_Setup DAC_9D_Data
DAC_9E_Setup:       DAC_Setup DAC_9E_Data
DAC_9F_Setup:       DAC_Setup DAC_9F_Data
DAC_A0_Setup:       DAC_Setup DAC_A0_Data
DAC_A1_Setup:       DAC_Setup DAC_A1_Data
                endm
