; Owner: audio/s3
; Responsibility: Original dac bank 2 allocation and checked private ROM resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; Dac Bank 2
; ---------------------------------------------------------------------------
DacBank2:       startDACBank

DAC_9B_Data:    include "src/audio/dac/shared/sample_9b.inc"
DAC_9C_Data:    include "src/audio/dac/s3/sample_9c.inc"
DAC_9D_Data:    include "src/audio/dac/s3/sample_9d.inc"
DAC_9E_Data:    include "src/audio/dac/s3/sample_9e.inc"
DAC_9F_Data:    include "src/audio/dac/s3/sample_9f.inc"
DAC_A0_Data:    include "src/audio/dac/s3/sample_a0.inc"
DAC_A1_Data:    include "src/audio/dac/s3/sample_a1.inc"
DAC_A2_Data:    include "src/audio/dac/s3/sample_a2.inc"
DAC_A3_Data:    include "src/audio/dac/s3/sample_a3.inc"
DAC_A4_Data:    include "src/audio/dac/s3/sample_a4.inc"
DAC_A5_Data:    include "src/audio/dac/s3/sample_a5.inc"
DAC_A6_Data:    include "src/audio/dac/s3/sample_a6.inc"
DAC_A7_Data:    include "src/audio/dac/s3/sample_a7.inc"
DAC_A8_Data:    include "src/audio/dac/s3/sample_a8.inc"
DAC_A9_Data:    include "src/audio/dac/s3/sample_a9.inc"
DAC_AA_Data:    include "src/audio/dac/s3/sample_aa.inc"

                finishBank
