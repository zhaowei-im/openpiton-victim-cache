// Copyright (c) 2015 Princeton University
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of Princeton University nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

// Wraps the EXU to tie unused signals when no scan chain is present

`include "define.vh"
`include "lsu.tmp.h"

module sparc_exu_wrap
(
    input                arst_l,
    input [63:0]         ffu_exu_rsr_data_m,
    input                grst_l,
    input                ifu_exu_addr_mask_d,
    input [2:0]          ifu_exu_aluop_d,
    input                ifu_exu_casa_d,
    input                ifu_exu_dbrinst_d,
    input                ifu_exu_disable_ce_e,
    input                ifu_exu_dontmv_regz0_e,
    input                ifu_exu_dontmv_regz1_e,
    input [7:0]          ifu_exu_ecc_mask,
    input                ifu_exu_enshift_d,
    input                ifu_exu_flushw_e,
    input                ifu_exu_ialign_d,
    input [31:0]         ifu_exu_imm_data_d,
    input                ifu_exu_inj_irferr,
    input                ifu_exu_inst_vld_e,
    input                ifu_exu_inst_vld_w,
    input                ifu_exu_invert_d,
    input                ifu_exu_kill_e,
    input [4:0]          ifu_exu_muldivop_d,
    input                ifu_exu_muls_d,
    input                ifu_exu_nceen_e,
    input [47:0]         ifu_exu_pc_d,
    input [63:0]         ifu_exu_pcver_e,
    input                ifu_exu_range_check_jlret_d,
    input                ifu_exu_range_check_other_d,
    input [4:0]          ifu_exu_rd_d,
    input                ifu_exu_rd_exusr_e,
    input                ifu_exu_rd_ffusr_e,
    input                ifu_exu_rd_ifusr_e,
    input                ifu_exu_ren1_s,
    input                ifu_exu_ren2_s,
    input                ifu_exu_ren3_s,
    input                ifu_exu_restore_d,
    input                ifu_exu_restored_e,
    input                ifu_exu_return_d,
    input [4:0]          ifu_exu_rs1_s,
    input                ifu_exu_rs1_vld_d,
    input [4:0]          ifu_exu_rs2_s,
    input                ifu_exu_rs2_vld_d,
    input [4:0]          ifu_exu_rs3_s,
    input                ifu_exu_rs3e_vld_d,
    input                ifu_exu_rs3o_vld_d,
    input                ifu_exu_save_d,
    input                ifu_exu_saved_e,
    input                ifu_exu_setcc_d,
    input                ifu_exu_sethi_inst_d,
    input [2:0]          ifu_exu_shiftop_d,
    input                ifu_exu_tagop_d,
    input                ifu_exu_tcc_e,
    input [1:0]          ifu_exu_tid_s2,
    input                ifu_exu_ttype_vld_m,
    input                ifu_exu_tv_d,
    input                ifu_exu_use_rsr_e_l,
    input                ifu_exu_usecin_d,
    input                ifu_exu_useimm_d,
    input                ifu_exu_wen_d,
    input                ifu_tlu_flush_m,
    input [6:0]          ifu_tlu_sraddr_d,
    input                ifu_tlu_wsr_inst_d,
    input [63:0]         lsu_exu_dfill_data_g,
    input                lsu_exu_dfill_vld_g,
    input                lsu_exu_flush_pipe_w,
    input                lsu_exu_ldst_miss_g2,
    input [63:0]         lsu_exu_ldxa_data_g,
    input                lsu_exu_ldxa_m,
    input [4:0]          lsu_exu_rd_m,
    input                lsu_exu_st_dtlb_perr_g,
    input [1:0]          lsu_exu_thr_m,
    input                mul_exu_ack,
    input [63:0]         mul_exu_data_g,
    input                rclk,
    input [1:0]          tlu_exu_agp,
    input                tlu_exu_agp_swap,
    input [1:0]          tlu_exu_agp_tid,
    input [7:0]          tlu_exu_ccr_m,
    input [2:0]          tlu_exu_cwp_m,
    input                tlu_exu_cwp_retry_m,
    input                tlu_exu_cwpccr_update_m,
    input                tlu_exu_pic_onebelow_m,
    input                tlu_exu_pic_twobelow_m,
    input                tlu_exu_priv_trap_m,
    input [63:0]         tlu_exu_rsr_data_m,
    output               exu_ffu_wsr_inst_e,
    output [47:0]        exu_ifu_brpc_e,
    output [7:0]         exu_ifu_cc_d,
    output               exu_ifu_ecc_ce_m,
    output               exu_ifu_ecc_ue_m,
    output [7:0]         exu_ifu_err_reg_m,
    output               exu_ifu_inj_ack,
    output [3:0]         exu_ifu_longop_done_g,
    output [3:0]         exu_ifu_oddwin_s,
    output               exu_ifu_regn_e,
    output               exu_ifu_regz_e,
    output               exu_ifu_spill_e,
    output               exu_ifu_va_oor_m,
    output [`L1D_ADDRESS_HI:3]        exu_lsu_early_va_e,
    output [47:0]        exu_lsu_ldst_va_e,
    output               exu_lsu_priority_trap_m,
    output [63:0]        exu_lsu_rs2_data_e,
    output [63:0]        exu_lsu_rs3_data_e,
    output [7:0]         exu_mmu_early_va_e,
    output               exu_mul_input_vld,
    output [63:0]        exu_mul_rs1_data,
    output [63:0]        exu_mul_rs2_data,
    output [7:0]         exu_tlu_ccr0_w,
    output [7:0]         exu_tlu_ccr1_w,
    output [7:0]         exu_tlu_ccr2_w,
    output [7:0]         exu_tlu_ccr3_w,
    output [2:0]         exu_tlu_cwp0_w,
    output [2:0]         exu_tlu_cwp1_w,
    output [2:0]         exu_tlu_cwp2_w,
    output [2:0]         exu_tlu_cwp3_w,
    output               exu_tlu_cwp_cmplt,
    output [1:0]         exu_tlu_cwp_cmplt_tid,
    output               exu_tlu_cwp_retry,
    output               exu_tlu_misalign_addr_jmpl_rtn_m,
    output               exu_tlu_spill,
    output               exu_tlu_spill_other,
    output [1:0]         exu_tlu_spill_tid,
    output [2:0]         exu_tlu_spill_wtype,
    output [8:0]         exu_tlu_ttype_m,
    output               exu_tlu_ttype_vld_m,
    output               exu_tlu_va_oor_jl_ret_m,
    output               exu_tlu_va_oor_m,
    output [63:0]        exu_tlu_wsr_data_m,
    output [7:0]         exu_ifu_err_synd_m,

    // jtag debug
    output wire [`CORE_JTAG_BUS_WIDTH-1:0] core_rtap_data,
    input wire rtap_core_val,
    input wire rtap_core_threadid_0,
    input wire [`JTAG_CORE_ID_WIDTH-1:0]  rtap_core_id,
    input wire [4:0] rtap_core_data_4_0
);

    sparc_exu exu   (
                 .short_si0              (1'bx),
                 .short_so0              (),
                 .short_si1              (1'bx),
                 .short_so1              (),
                 .si0                    (1'bx),
                 .so0                    (),
                 // reset stuff
                 .grst_l                (grst_l),
                 .arst_l                (arst_l),
                 .mul_exu_data_g        (mul_exu_data_g),
                 .ifu_tlu_wsr_inst_d    (ifu_tlu_wsr_inst_d),
                 //
                 .exu_tlu_ue_trap_m     (),
                 
                     /*AUTOINST*/
                 // Outputs
                 .exu_ffu_wsr_inst_e    (exu_ffu_wsr_inst_e),
                 .exu_ifu_brpc_e        (exu_ifu_brpc_e),
                 .exu_ifu_cc_d          (exu_ifu_cc_d),
                 .exu_ifu_ecc_ce_m      (exu_ifu_ecc_ce_m),
                 .exu_ifu_ecc_ue_m      (exu_ifu_ecc_ue_m),
                 .exu_ifu_err_reg_m     (exu_ifu_err_reg_m),
                 .exu_ifu_inj_ack       (exu_ifu_inj_ack),
                 .exu_ifu_longop_done_g (exu_ifu_longop_done_g),
                 .exu_ifu_oddwin_s      (exu_ifu_oddwin_s),
                 .exu_ifu_regn_e        (exu_ifu_regn_e),
                 .exu_ifu_regz_e        (exu_ifu_regz_e),
                 .exu_ifu_spill_e       (exu_ifu_spill_e),
                 .exu_ifu_va_oor_m      (exu_ifu_va_oor_m),
                 .exu_lsu_early_va_e    (exu_lsu_early_va_e),
                 .exu_lsu_ldst_va_e     (exu_lsu_ldst_va_e),
                 .exu_lsu_priority_trap_m(exu_lsu_priority_trap_m),
                 .exu_lsu_rs2_data_e    (exu_lsu_rs2_data_e),
                 .exu_lsu_rs3_data_e    (exu_lsu_rs3_data_e),
                 .exu_mmu_early_va_e    (exu_mmu_early_va_e),
                 .exu_mul_input_vld     (exu_mul_input_vld),
                 .exu_mul_rs1_data      (exu_mul_rs1_data),
                 .exu_mul_rs2_data      (exu_mul_rs2_data),
                 .exu_spu_rs3_data_e    (),
                 .exu_tlu_ccr0_w        (exu_tlu_ccr0_w),
                 .exu_tlu_ccr1_w        (exu_tlu_ccr1_w),
                 .exu_tlu_ccr2_w        (exu_tlu_ccr2_w),
                 .exu_tlu_ccr3_w        (exu_tlu_ccr3_w),
                 .exu_tlu_cwp0_w        (exu_tlu_cwp0_w),
                 .exu_tlu_cwp1_w        (exu_tlu_cwp1_w),
                 .exu_tlu_cwp2_w        (exu_tlu_cwp2_w),
                 .exu_tlu_cwp3_w        (exu_tlu_cwp3_w),
                 .exu_tlu_cwp_cmplt     (exu_tlu_cwp_cmplt),
                 .exu_tlu_cwp_cmplt_tid (exu_tlu_cwp_cmplt_tid),
                 .exu_tlu_cwp_retry     (exu_tlu_cwp_retry),
                 .exu_tlu_misalign_addr_jmpl_rtn_m(exu_tlu_misalign_addr_jmpl_rtn_m),
                 .exu_tlu_spill         (exu_tlu_spill),
                 .exu_tlu_spill_other   (exu_tlu_spill_other),
                 .exu_tlu_spill_tid     (exu_tlu_spill_tid),
                 .exu_tlu_spill_wtype   (exu_tlu_spill_wtype),
                 .exu_tlu_ttype_m       (exu_tlu_ttype_m),
                 .exu_tlu_ttype_vld_m   (exu_tlu_ttype_vld_m),
                 .exu_tlu_va_oor_jl_ret_m(exu_tlu_va_oor_jl_ret_m),
                 .exu_tlu_va_oor_m      (exu_tlu_va_oor_m),
                 .exu_tlu_wsr_data_m    (exu_tlu_wsr_data_m),
                 .exu_ifu_err_synd_m    (exu_ifu_err_synd_m),
                 // Inputs
                 .ffu_exu_rsr_data_m    (ffu_exu_rsr_data_m),
                 .ifu_exu_addr_mask_d   (ifu_exu_addr_mask_d),
                 .ifu_exu_aluop_d       (ifu_exu_aluop_d),
                 .ifu_exu_casa_d        (ifu_exu_casa_d),
                 .ifu_exu_dbrinst_d     (ifu_exu_dbrinst_d),
                 .ifu_exu_disable_ce_e  (ifu_exu_disable_ce_e),
                 .ifu_exu_dontmv_regz0_e(ifu_exu_dontmv_regz0_e),
                 .ifu_exu_dontmv_regz1_e(ifu_exu_dontmv_regz1_e),
                 .ifu_exu_ecc_mask      (ifu_exu_ecc_mask),
                 .ifu_exu_enshift_d     (ifu_exu_enshift_d),
                 .ifu_exu_flushw_e      (ifu_exu_flushw_e),
                 .ifu_exu_ialign_d      (ifu_exu_ialign_d),
                 .ifu_exu_imm_data_d    (ifu_exu_imm_data_d),
                 .ifu_exu_inj_irferr    (ifu_exu_inj_irferr),
                 .ifu_exu_inst_vld_e    (ifu_exu_inst_vld_e),
                 .ifu_exu_inst_vld_w    (ifu_exu_inst_vld_w),
                 .ifu_exu_invert_d      (ifu_exu_invert_d),
                 .ifu_exu_kill_e        (ifu_exu_kill_e),
                 .ifu_exu_muldivop_d    (ifu_exu_muldivop_d),
                 .ifu_exu_muls_d        (ifu_exu_muls_d),
                 .ifu_exu_nceen_e       (ifu_exu_nceen_e),
                 .ifu_exu_pc_d          (ifu_exu_pc_d),
                 .ifu_exu_pcver_e       (ifu_exu_pcver_e),
                 .ifu_exu_range_check_jlret_d(ifu_exu_range_check_jlret_d),
                 .ifu_exu_range_check_other_d(ifu_exu_range_check_other_d),
                 .ifu_exu_rd_d          (ifu_exu_rd_d),
                 .ifu_exu_rd_exusr_e    (ifu_exu_rd_exusr_e),
                 .ifu_exu_rd_ffusr_e    (ifu_exu_rd_ffusr_e),
                 .ifu_exu_rd_ifusr_e    (ifu_exu_rd_ifusr_e),
                 .ifu_exu_ren1_s        (ifu_exu_ren1_s),
                 .ifu_exu_ren2_s        (ifu_exu_ren2_s),
                 .ifu_exu_ren3_s        (ifu_exu_ren3_s),
                 .ifu_exu_restore_d     (ifu_exu_restore_d),
                 .ifu_exu_restored_e    (ifu_exu_restored_e),
                 .ifu_exu_return_d      (ifu_exu_return_d),
                 .ifu_exu_rs1_s         (ifu_exu_rs1_s),
                 .ifu_exu_rs1_vld_d     (ifu_exu_rs1_vld_d),
                 .ifu_exu_rs2_s         (ifu_exu_rs2_s),
                 .ifu_exu_rs2_vld_d     (ifu_exu_rs2_vld_d),
                 .ifu_exu_rs3_s         (ifu_exu_rs3_s),
                 .ifu_exu_rs3e_vld_d    (ifu_exu_rs3e_vld_d),
                 .ifu_exu_rs3o_vld_d    (ifu_exu_rs3o_vld_d),
                 .ifu_exu_save_d        (ifu_exu_save_d),
                 .ifu_exu_saved_e       (ifu_exu_saved_e),
                 .ifu_exu_setcc_d       (ifu_exu_setcc_d),
                 .ifu_exu_sethi_inst_d  (ifu_exu_sethi_inst_d),
                 .ifu_exu_shiftop_d     (ifu_exu_shiftop_d),
                 .ifu_exu_tagop_d       (ifu_exu_tagop_d),
                 .ifu_exu_tcc_e         (ifu_exu_tcc_e),
                 .ifu_exu_tid_s2        (ifu_exu_tid_s2),
                 .ifu_exu_ttype_vld_m   (ifu_exu_ttype_vld_m),
                 .ifu_exu_tv_d          (ifu_exu_tv_d),
                 .ifu_exu_use_rsr_e_l   (ifu_exu_use_rsr_e_l),
                 .ifu_exu_usecin_d      (ifu_exu_usecin_d),
                 .ifu_exu_useimm_d      (ifu_exu_useimm_d),
                 .ifu_exu_wen_d         (ifu_exu_wen_d),
                 .ifu_tlu_flush_m       (ifu_tlu_flush_m),
                 .ifu_tlu_sraddr_d      (ifu_tlu_sraddr_d),
                 .lsu_exu_dfill_data_g  (lsu_exu_dfill_data_g),
                 .lsu_exu_dfill_vld_g   (lsu_exu_dfill_vld_g),
                 .lsu_exu_flush_pipe_w  (lsu_exu_flush_pipe_w),
                 .lsu_exu_ldst_miss_g2  (lsu_exu_ldst_miss_g2),
                 .lsu_exu_ldxa_data_g   (lsu_exu_ldxa_data_g),
                 .lsu_exu_ldxa_m        (lsu_exu_ldxa_m),
                 .lsu_exu_rd_m          (lsu_exu_rd_m),
                 .lsu_exu_st_dtlb_perr_g(lsu_exu_st_dtlb_perr_g),
                 .lsu_exu_thr_m         (lsu_exu_thr_m),
                 .mul_exu_ack           (mul_exu_ack),
                 .rclk                  (rclk),
                 .se                    (1'b0),
                 .sehold                (1'b0),
                 .tlu_exu_agp           (tlu_exu_agp),
                 .tlu_exu_agp_swap      (tlu_exu_agp_swap),
                 .tlu_exu_agp_tid       (tlu_exu_agp_tid),
                 .tlu_exu_ccr_m         (tlu_exu_ccr_m),
                 .tlu_exu_cwp_m         (tlu_exu_cwp_m),
                 .tlu_exu_cwp_retry_m   (tlu_exu_cwp_retry_m),
                 .tlu_exu_cwpccr_update_m(tlu_exu_cwpccr_update_m),
                 .tlu_exu_pic_onebelow_m(tlu_exu_pic_onebelow_m),
                 .tlu_exu_pic_twobelow_m(tlu_exu_pic_twobelow_m),
                 .tlu_exu_priv_trap_m   (tlu_exu_priv_trap_m),
                 .tlu_exu_rsr_data_m    (tlu_exu_rsr_data_m),

                 .core_rtap_data          (core_rtap_data),
                 .rtap_core_val         (rtap_core_val),
                 .rtap_core_threadid         ({1'bx, rtap_core_threadid_0}),
                 .rtap_core_id         (rtap_core_id),
                 .rtap_core_data         ({{(`CORE_JTAG_BUS_WIDTH-5){1'bx}}, rtap_core_data_4_0})
                 );

endmodule
