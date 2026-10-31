; Owner: audio/sk
; Responsibility: Original dac bank allocation and checked private ROM resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; ===========================================================================
; DAC Banks
; ===========================================================================
; DAC Bank 1
; ---------------------------------------------------------------------------
DacBank1:       startDACBank

DAC_86_Data:            include "src/audio/dac/shared/sample_86.inc"
DAC_81_Data:            include "src/audio/dac/shared/sample_81.inc"
DAC_82_83_84_85_Data:   include "src/audio/dac/shared/sample_82_85.inc"
DAC_94_95_96_97_Data:   include "src/audio/dac/shared/sample_94_97.inc"
DAC_90_91_92_93_Data:   include "src/audio/dac/shared/sample_90_93.inc"
DAC_88_Data:            include "src/audio/dac/shared/sample_88.inc"
DAC_8A_8B_Data:         include "src/audio/dac/shared/sample_8a_8b.inc"
DAC_8C_Data:            include "src/audio/dac/shared/sample_8c.inc"
DAC_8D_8E_Data:         include "src/audio/dac/shared/sample_8d_8e.inc"
DAC_87_Data:            include "src/audio/dac/shared/sample_87.inc"
DAC_8F_Data:            include "src/audio/dac/shared/sample_8f.inc"
DAC_89_Data:            include "src/audio/dac/shared/sample_89.inc"
DAC_98_99_9A_Data:      include "src/audio/dac/shared/sample_98_9a.inc"
DAC_9B_Data:            include "src/audio/dac/shared/sample_9b.inc"
DAC_B2_B3_Data:         include "src/audio/dac/sk/sample_b2_b3.inc"

                finishBank

                align   $10
