; Owner: audio/s3
; Responsibility: Original dac bank 3 allocation and checked private ROM resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; Dac Bank 3
; ---------------------------------------------------------------------------
DacBank3:       startDACBank

DAC_AB_Data:                include "src/audio/dac/s3/sample_ab.s"
DAC_AC_Data:                include "src/audio/dac/s3/sample_ac.s"
DAC_AD_AE_Data:             include "src/audio/dac/s3/sample_ad_ae.s"
DAC_AF_B0_Data:             include "src/audio/dac/s3/sample_af_b0.s"
DAC_Unused_Data:            include "src/audio/dac/s3/unused_sample.s"
DAC_B1_Data:                include "src/audio/dac/s3/sample_b1.s"
DAC_B2_B3_Data:             include "src/audio/dac/s3/sample_b2_b3.s"
DAC_B4_C1_C2_C3_C4_Data:    include "src/audio/dac/s3/sample_b4c1_c4.s"
DAC_B5_Data:                include "src/audio/dac/s3/sample_b5.s"
DAC_B6_Data:                include "src/audio/dac/s3/sample_b6.s"
DAC_B7_Data:                include "src/audio/dac/s3/sample_b7.s"
DAC_B8_B9_Data:             include "src/audio/dac/s3/sample_b8_b9.s"
DAC_BA_Data:                include "src/audio/dac/s3/sample_ba.s"
DAC_BB_Data:                include "src/audio/dac/s3/sample_bb.s"
DAC_BC_Data:                include "src/audio/dac/s3/sample_bc.s"
DAC_BD_Data:                include "src/audio/dac/s3/sample_bd.s"
DAC_BE_Data:                include "src/audio/dac/s3/sample_be.s"
DAC_BF_Data:                include "src/audio/dac/s3/sample_bf.s"
DAC_C0_Data:                include "src/audio/dac/s3/sample_c0.s"

                finishBank
