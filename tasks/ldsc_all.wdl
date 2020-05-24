#ldsc_all.wdl
task ldscrg {
    String? output_file_address
    String? work_directory
    String? out_file_name

    Array[File] rg_files


    String ref_ld_chr_address
    String ref_ld_chr_argument = if (ref_ld_chr_address != "") then "--ref-ld-chr ${ref_ld_chr_address}" else ""

    String w_ld_chr_address
    String w_ld_chr_argument = if (w_ld_chr_address != "") then "--w-ld-chr ${w_ld_chr_address}" else ""

    String? samp_prev
    String samp_prev_argument = if (samp_prev != "") then "--samp-prev ${samp_prev}" else ""
    String? pop_prev
    String pop_prev_argument = if (pop_prev != "") then "--pop-prev ${pop_prev}" else ""

    String? intercept_h2
    String intercept_h2_argument = if (intercept_h2 != "") then "--intercept-h2 ${intercept_h2}" else ""

    String? intercept_gencov
    String intercept_genvoc_argument = if (intercept_gencov != "") then "--intercept-gencov ${intercept_gencov}" else ""

    String? no_intercept
    String no_intercept_argument = if (no_intercept != "") then "--no-intercept" else ""



    runtime {
        cpu:1
        memory:"10 GB"
        walltimeset:"1:00:00"
        docker:"leeliu14/ldsctest:1.0.3"

    }

    command<<<
    source activate ldsc
    cd ${work_directory}/ldsc

    ./ldsc.py \
    --rg ${sep = "," rg_files} \
    ${ref_ld_chr_argument} \
    ${w_ld_chr_argument} \
    ${samp_prev_argument} \
    ${pop_prev_argument} \
    ${intercept_h2_argument} \
    ${intercept_genvoc_argument} \
    ${no_intercept_argument} \
    --out ${out_file_name}

    mv ${out_file_name}.log -t ${output_file_address}

    >>>

    output {
        String out = read_string(stdout())
        File out_log = "${output_file_address}/${out_file_name}.log"
    }

}





task ld_score_estimation{
    String? output_file_address
    String? work_directory
    String? out_file_name

    String? bfile
    String bfile_argument = "--bfile ${bfile}" 
    String? estimate_l2
    String l2_argument = if (estimate_l2 != "") then "--l2" else ""
    String ld_wind_setting
    String ld_wind_sufflix
    Boolean detect_ld_wind_setting = if (ld_wind_setting != "") then true else false
    Boolean detect_ld_wind_sufflix = if (ld_wind_sufflix != "") then true else false
    String ld_wind_argument = if (detect_ld_wind_setting && detect_ld_wind_sufflix == true) then "--ld-wind-${ld_wind_sufflix} ${ld_wind_setting}" else ""

    runtime {
        cpu:1
        memory:"10 GB"
        walltimeset:"1:00:00"
        docker:"leeliu14/ldsctest:1.0.3"

    }    


    command<<<
    source activate ldsc
    cd ${work_directory}/ldsc

    ./ldsc.py \
    ${bfile_argument} \
    ${l2_argument} \
    ${ld_wind_argument} \
    --out ${out_file_name}

    mv ${out_file_name}.log ${out_file_name}.l2.M_5_50 ${out_file_name}.l2.M ${out_file_name}.l2.ldscore.gz -t ${output_file_address}


    >>>

    output {
        String out = read_string(stdout())
        File out_log = "${output_file_address}/${out_file_name}.log"
        File out_annot_l2_M_5_50 = "${output_file_address}/${out_file_name}.l2.M_5_50"
        File out_annot_l2_M = "${output_file_address}/${out_file_name}.l2.M"
        File out_annot_ldscore = "${output_file_address}/${out_file_name}.l2.ldscore.gz"
    }

    
}


task partritioned_ld_score {
    String? output_file_address
    String? work_directory
    String? out_file_name

    String? bfile
    String bfile_argument = "--bfile ${bfile}" 
    String? estimate_l2
    String l2_argument = if (estimate_l2 != "") then "--l2" else ""
    String ld_wind_setting
    String ld_wind_sufflix
    Boolean detect_ld_wind_setting = if (ld_wind_setting != "") then true else false
    Boolean detect_ld_wind_sufflix = if (ld_wind_sufflix != "") then true else false
    String ld_wind_argument = if (detect_ld_wind_setting && detect_ld_wind_sufflix == true) then "--ld-wind-${ld_wind_sufflix} ${ld_wind_setting}" else ""

    String annot
    String annot_argument = if (annot != "") then "--annot ${annot}" else ""

    String thin_annot
    String thin_annot_argument = if (thin_annot != "") then "--thin-annot" else ""

    String print_snps
    String print_snps_argument = if (print_snps != "") then "--print-snps ${print_snps}" else ""



    runtime {
        cpu:1
        memory:"10 GB"
        walltimeset:"1:00:00"
        docker:"leeliu14/ldsctest:1.0.3"

    }    

    command <<<
    source activate ldsc
    cd ${work_directory}/ldsc

    ./ldsc.py \
    ${l2_argument} \
    ${bfile_argument} \
    ${ld_wind_argument} \
    ${annot_argument} \
    ${thin_annot_argument} \
    --out ${out_file_name} \
    ${print_snps_argument} \

    mv ${out_file_name}.log ${out_file_name}.l2.M_5_50 ${out_file_name}.l2.M ${out_file_name}.l2.ldscore.gz -t ${output_file_address}
    

    >>>

    output {
        String out = read_string(stdout())
        File out_log = "${output_file_address}/${out_file_name}.log"
        File out_annot_l2_M_5_50 = "${output_file_address}/${out_file_name}.l2.M_5_50"
        File out_annot_l2_M = "${output_file_address}/${out_file_name}.l2.M"
        File out_annot_ldscore = "${output_file_address}/${out_file_name}.l2.ldscore.gz"
    }



}






task ldsc_ctsa {
    String? output_file_address
    String? work_directory
    String? out_file_name

    String h2_cts
    String h2_cts_argument = if (h2_cts != "") then "--h2-cts ${h2_cts}" else ""
    String w_ld_chr
    String w_ld_chr_argument = if (w_ld_chr != "") then "--w-ld-chr ${w_ld_chr}" else ""
    String ref_ld_chr_cts
    String ref_ld_chr_cts_argument = if (ref_ld_chr_cts !="") then "--ref-ld-chr-cts ${ref_ld_chr_cts}" else ""
    String ref_ld_chr
    String ref_ld_chr_argument = if (ref_ld_chr != "") then "--ref-ld-chr ${ref_ld_chr}" else ""
    String? frqfile_chr
    String frqfile_chr_argument = if (frqfile_chr != "") then "--frqfile-chr ${frqfile_chr}" else ""
    String? overlap_annot
    String overlap_annot_argument = if (overlap_annot != "") then "--overlap-annot" else ""
    String? print_coefficients
    String print_coefficients_argument = if (print_coefficients != "") then "--print-coefficients" else ""

    runtime {
        cpu: 1
        memory:"10 GB"
        walltimeset :"1:00:00"
        docker: "leeliu14/ldsctest:1.0.3"
    }



    command <<<
    source activate ldsc
    cd ${work_directory}/ldsc

    ./ldsc.py \
    ${h2_cts_argument} \
    ${ref_ld_chr_argument} \
    ${ref_ld_chr_cts_argument} \
    ${w_ld_chr_argument} \
    ${frqfile_chr_argument} \
    ${overlap_annot_argument} \
    ${print_coefficients_argument} \
    --out ${out_file_name} 

    mv ${out_file_name}.log  ${out_file_name}.cell_type_results.txt -t ${output_file_address}



    >>>
    output {
        String out = read_string(stdout())
        File out_log = "${output_file_address}/${out_file_name}.log"
        File ldsc_out_result = "${output_file_address}/${out_file_name}.cell_type_results.txt"

    }



}





task ldsc_ph_from_continuous_annot {
    String? output_file_address
    String? work_directory
    String? out_file_name

    Array[String] ref_ld_chr_files

    String? h2
    String h2_argument = if (h2 != "") then "--h2 ${h2}" else ""
    String? frqfile_chr
    String frqfile_chr_argument = if (frqfile_chr != "") then "--frqfile-chr ${frqfile_chr}" else ""
    String? w_ld_chr
    String w_ld_chr_argument = if (w_ld_chr != "") then "--w-ld-chr ${w_ld_chr}" else ""
    String? overlap_annot
    String overlap_annot_argument = if (overlap_annot != "") then "--overlap-annot" else ""
    String? print_coefficients
    String print_coefficients_argument = if (print_coefficients != "") then "--print-coefficients" else ""
    String? print_delet_vals
    String print_delet_vals_argument = if (print_delet_vals != "") then "--print-delete-vals" else ""

    runtime {
        cpu: 1
        memory:"10 GB"
        walltimeset :"1:00:00"
        docker: "leeliu14/ldsctest:1.0.3"
    }




    command <<<
    source activate ldsc
    cd ${work_directory}/ldsc

    ./ldsc.py \
    ${h2_argument} \
    --ref-ld-chr ${sep = "," ref_ld_chr_files} \
    ${frqfile_chr_argument} \
    ${w_ld_chr_argument} \
    ${overlap_annot_argument} \
    ${print_coefficients_argument} \
    ${print_delet_vals_argument} \
    --out ${out_file_name}

    mv ${out_file_name}.log  ${out_file_name}.results -t ${output_file_address}

    >>>

    output {
        String out = read_string(stdout())
        File out_log = "${output_file_address}/${out_file_name}.log"
        File ldsc_ph_out_result = "${output_file_address}/${out_file_name}.results"
                
    }

}

workflow test_ldsc_ph_from_continuous_annot {
    String workflow_output_file_address
    String workflow_working_directory
    String name_of_output
    String summstat_file
    String weight_file_address_and_flag
    Array[String] ref_ldscore_file_and_flag

    String frq_file_and_flag
    String if_overlap_annot
    String if_print_coefficients
    String if_print_delet_vals

    call ldsc_ph_from_continuous_annot {
        input: output_file_address = workflow_output_file_address,
        work_directory = workflow_working_directory,
        out_file_name = name_of_output,
        h2 = summstat_file,
        ref_ld_chr_files = ref_ldscore_file_and_flag,
        frqfile_chr = frq_file_and_flag,
        w_ld_chr = weight_file_address_and_flag,
        overlap_annot = if_overlap_annot,
        print_coefficients = if_print_coefficients,
        print_delet_vals = if_print_delet_vals
    }


}







#workflow test_ctsa {
#    String workflow_output_file_address
#    String workflow_working_directory
#    String name_of_output
#    String cts_summstat_file
#    String weight_file_address_and_flag
#    String ref_ldscore_file_and_flag
#    String cts_ref_ldscore_file_and_flag
#
#    call ldsc_ctsa {
#        input:output_file_address = workflow_output_file_address,
#        work_directory = workflow_working_directory,
#        out_file_name = name_of_output,
#        h2_cts = cts_summstat_file,
#        w_ld_chr = weight_file_address_and_flag,
#        ref_ld_chr = ref_ldscore_file_and_flag,
#        ref_ld_chr_cts = cts_ref_ldscore_file_and_flag
#
#    }
#
#}











#workflow test_partritioned_ld_score{
#    String workflow_output_file_address
#    String workflow_working_directory
#    String name_of_output
#    String Plink_format_file_input
#    String if_estimate_l2
#    String ld_wind_setting_parameter
#    String ld_wind_sufflix_parameter
#    String if_annot_is_thin_annot
#    String filename_preflix_for_annot_file
#    String only_print_ldscore_for_the_SNPs_list
#
#    call partritioned_ld_score {
#        input:work_directory = workflow_working_directory,
#        output_file_address = workflow_output_file_address,
#        out_file_name = name_of_output,
#        bfile = Plink_format_file_input,
#        estimate_l2 = if_estimate_l2,
#        ld_wind_setting = ld_wind_setting_parameter,
#        ld_wind_sufflix = ld_wind_sufflix_parameter,
#        thin_annot = if_annot_is_thin_annot,
#        annot = filename_preflix_for_annot_file,
#        print_snps = only_print_ldscore_for_the_SNPs_list
#    }
#
#
#
#
#}






#workflow test_LD_score_estimation {
#    String workflow_output_file_address
#    String workflow_working_directory
#    String name_of_output
#    String? input_file_with_Plink_format
#    String if_estimate_l2
#    String ld_wind_setting_parameter
#    String ld_wind_sufflix_parameter
#
#
#    call ld_score_estimation {
#        input: work_directory = workflow_working_directory,
#        output_file_address = workflow_output_file_address,
#        out_file_name = name_of_output,
#        bfile= input_file_with_Plink_format,
#        estimate_l2 = if_estimate_l2,
#        ld_wind_setting = ld_wind_setting_parameter,
#        ld_wind_sufflix = ld_wind_sufflix_parameter
#
#    }
#
#}










#test ldsc_regression_task
#workflow test {
#    String workflow_output_file_address
#    String workflow_working_directory
#    String name_of_output
#
#    Array[File] rg_files_input 
#
#
#
#    String w_ld_chr_file_address
#    String ref_ld_chr_file_address
#
#    String samp_prev_parameter
#    String pop_prev_parameter
#
#    String intercept_h2_parameter
#    String intercept_gencov_parameter
#    String if_required_no_intercept
#    
#
#    
#    call ldscrg {
#        input: rg_files = rg_files_input,
#        ref_ld_chr_address = ref_ld_chr_file_address,
#        w_ld_chr_address = w_ld_chr_file_address,
#        out_file_name = name_of_output,
#        output_file_address = workflow_output_file_address,
#        work_directory = workflow_working_directory,
#        samp_prev = samp_prev_parameter,
#        pop_prev = pop_prev_parameter,
#        intercept_h2 = intercept_h2_parameter,
#        intercept_gencov = intercept_gencov_parameter,
#        no_intercept = if_required_no_intercept
#
#
#    }
#}

