; Owner: audio/shared
; Responsibility: Licensed driver-local FM instrument parameter and voice record definition helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ===========================================================================
; Created by Flamewing, based on S1SMPS2ASM version 1.1 by Marc Gordon (AKA Cinossu)
; ===========================================================================
; Permission to use, copy, modify, and/or distribute this software for any
; purpose with or without fee is hereby granted
;
; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
; OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE
; ===========================================================================

; Driver-local instrument helpers retained from SMPS2ASM
; Song and SFX streams are private ROM-extracted assets
SourceDriver:   equ     3
SourceSMPS2ASM: equ     0

smpsVcFeedback  macro   val
vcFeedback:     eval    val
                endm

; Voices - Algorithm
smpsVcAlgorithm macro   val
vcAlgorithm:    eval    val
                endm

smpsVcUnusedBits    macro   val,d1r1,d1r2,d1r3,d1r4
vcUnusedBits:       eval    val
                    if      ("d1r1"<>"")&&("d1r2"<>"")&&("d1r3"<>"")&&("d1r4"<>"")
                    eval    vcD1R1Unk,d1r1<<5
                    eval    vcD1R2Unk,d1r2<<5
                    eval    vcD1R3Unk,d1r3<<5
                    eval    vcD1R4Unk,d1r4<<5
                    else
                    eval    vcD1R1Unk,0
                    eval    vcD1R2Unk,0
                    eval    vcD1R3Unk,0
                    eval    vcD1R4Unk,0
                    endif
                endm

; Voices - Detune
smpsVcDetune    macro   op1,op2,op3,op4
                    eval    vcDT1,op1
                    eval    vcDT2,op2
                    eval    vcDT3,op3
                    eval    vcDT4,op4
                endm

; Voices - Coarse-Frequency
smpsVcCoarseFreq    macro   op1,op2,op3,op4
                    eval    vcCF1,op1
                    eval    vcCF2,op2
                    eval    vcCF3,op3
                    eval    vcCF4,op4
                endm

; Voices - Rate Scale
smpsVcRateScale macro   op1,op2,op3,op4
                    eval    vcRS1,op1
                    eval    vcRS2,op2
                    eval    vcRS3,op3
                    eval    vcRS4,op4
                endm

; Voices - Attack Rate
smpsVcAttackRate    macro   op1,op2,op3,op4
                    eval    vcAR1,op1
                    eval    vcAR2,op2
                    eval    vcAR3,op3
                    eval    vcAR4,op4
                endm

; Voices - Amplitude Modulation
; The original SMPS2ASM erroneously assumed the 6th and 7th bits
; were the Amplitude Modulation
; According to several docs, however, it's actually the high bit
smpsVcAmpMod    macro   op1,op2,op3,op4
                    if      SourceSMPS2ASM==0
                    eval    vcAM1,op1<<5
                    eval    vcAM2,op2<<5
                    eval    vcAM3,op3<<5
                    eval    vcAM4,op4<<5
                    else
                    eval    vcAM1,op1<<7
                    eval    vcAM2,op2<<7
                    eval    vcAM3,op3<<7
                    eval    vcAM4,op4<<7
                    endif
                endm

; Voices - First Decay Rate
smpsVcDecayRate1    macro   op1,op2,op3,op4
                    eval    vcD1R1,op1
                    eval    vcD1R2,op2
                    eval    vcD1R3,op3
                    eval    vcD1R4,op4
                endm

; Voices - Second Decay Rate
smpsVcDecayRate2    macro   op1,op2,op3,op4
                    eval    vcD2R1,op1
                    eval    vcD2R2,op2
                    eval    vcD2R3,op3
                    eval    vcD2R4,op4
                endm

; Voices - Decay Level
smpsVcDecayLevel    macro   op1,op2,op3,op4
                    eval    vcDL1,op1
                    eval    vcDL2,op2
                    eval    vcDL3,op3
                    eval    vcDL4,op4
                endm

; Voices - Release Rate
smpsVcReleaseRate   macro   op1,op2,op3,op4
                    eval    vcRR1,op1
                    eval    vcRR2,op2
                    eval    vcRR3,op3
                    eval    vcRR4,op4
                endm

smpsNotZ80:     function cpu,(cpu<>128)&&(cpu<>32988)

smpsDcb         macro
                    if      smpsNotZ80(MOMCPU)
                    dc.b    ALLARGS
                    else
                    db      ALLARGS
                    endif
                endm

; Voices - Total Level
; The original SMPS2ASM decides TL high bits automatically,
; but later versions leave it up to the user
; Alternatively, if we're converting an SMPS 68k song to SMPS Z80,
; then we *want* the TL bits to match the algorithm, because SMPS 68k
; prefers the algorithm over the TL bits, ignoring the latter, while
; SMPS Z80 does the opposite
; Unfortunately, there's nothing we can do if we're trying to convert
; an SMPS Z80 song to SMPS 68k. It will ignore the bits no matter
; what we do, so we just print a warning
smpsVcTotalLevel    macro   op1,op2,op3,op4
                    eval    vcTL1,op1
                    eval    vcTL2,op2
                    eval    vcTL3,op3
                    eval    vcTL4,op4
                    smpsDcb (vcUnusedBits<<6)+(vcFeedback<<3)+vcAlgorithm
; 0     1     2     3     4     5     6     7
; %1000,%1000,%1000,%1000,%1010,%1110,%1110,%1111
                    if      SourceSMPS2ASM==0
                    eval    vcTLMask4,((vcAlgorithm==7)<<7)
                    eval    vcTLMask3,((vcAlgorithm>=4)<<7)
                    eval    vcTLMask2,((vcAlgorithm>=5)<<7)
                    eval    vcTLMask1,128
                    else
                    eval    vcTLMask4,0
                    eval    vcTLMask3,0
                    eval    vcTLMask2,0
                    eval    vcTLMask1,0
                    endif

                    if      (SonicDriverVer>=3)&&(SourceDriver<3)
                    eval    vcTLMask4,((vcAlgorithm==7)<<7)
                    eval    vcTLMask3,((vcAlgorithm>=4)<<7)
                    eval    vcTLMask2,((vcAlgorithm>=5)<<7)
                    eval    vcTLMask1,128
                    eval    vcTL1,vcTL1&127
                    eval    vcTL2,vcTL2&127
                    eval    vcTL3,vcTL3&127
                    eval    vcTL4,vcTL4&127
                    elseif  (SonicDriverVer<3)&&(SourceDriver>=3)&&((((vcTL1|vcTLMask1)&128)<>128)||(((vcTL2|vcTLMask2)&128)<>((vcAlgorithm>=5)<<7))||(((vcTL3|vcTLMask3)&128)<>((vcAlgorithm>=4)<<7))||(((vcTL4|vcTLMask4)&128)<>((vcAlgorithm==7)<<7)))
                    if      MOMPASS=1
                    message "Voice at 0x\{*} has TL bits that do not match its algorithm setting. This voice will not work in S1/S2 drivers."
                    endif
                    endif

                    if      SonicDriverVer==2
                    smpsDcb (vcDT4<<4)+vcCF4       ,(vcDT2<<4)+vcCF2       ,(vcDT3<<4)+vcCF3       ,(vcDT1<<4)+vcCF1
                    smpsDcb (vcRS4<<6)+vcAR4       ,(vcRS2<<6)+vcAR2       ,(vcRS3<<6)+vcAR3       ,(vcRS1<<6)+vcAR1
                    smpsDcb vcAM4|vcD1R4|vcD1R4Unk ,vcAM2|vcD1R2|vcD1R2Unk ,vcAM3|vcD1R3|vcD1R3Unk ,vcAM1|vcD1R1|vcD1R1Unk
                    smpsDcb vcD2R4                 ,vcD2R2                 ,vcD2R3                 ,vcD2R1
                    smpsDcb (vcDL4<<4)+vcRR4       ,(vcDL2<<4)+vcRR2       ,(vcDL3<<4)+vcRR3       ,(vcDL1<<4)+vcRR1
                    smpsDcb vcTL4|vcTLMask4        ,vcTL2|vcTLMask2        ,vcTL3|vcTLMask3        ,vcTL1|vcTLMask1
                    else
                    smpsDcb (vcDT4<<4)+vcCF4       ,(vcDT3<<4)+vcCF3       ,(vcDT2<<4)+vcCF2       ,(vcDT1<<4)+vcCF1
                    smpsDcb (vcRS4<<6)+vcAR4       ,(vcRS3<<6)+vcAR3       ,(vcRS2<<6)+vcAR2       ,(vcRS1<<6)+vcAR1
                    smpsDcb vcAM4|vcD1R4|vcD1R4Unk ,vcAM3|vcD1R3|vcD1R3Unk ,vcAM2|vcD1R2|vcD1R2Unk ,vcAM1|vcD1R1|vcD1R1Unk
                    smpsDcb vcD2R4                 ,vcD2R3                 ,vcD2R2                 ,vcD2R1
                    smpsDcb (vcDL4<<4)+vcRR4       ,(vcDL3<<4)+vcRR3       ,(vcDL2<<4)+vcRR2       ,(vcDL1<<4)+vcRR1
                    smpsDcb vcTL4|vcTLMask4        ,vcTL3|vcTLMask3        ,vcTL2|vcTLMask2        ,vcTL1|vcTLMask1
                    endif
                endm
