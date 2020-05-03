#ldsc_mungestat.wdl
task preprocessing {
    String output_file_address
    String work_directory


    File sumstatbodypart
    String sumstat_argument = if (sumstatbodypart != "") then "--sumstats ${sumstatbodypart}" else ""
    File alleles_need_to_merge
    String alleles_argument = if (alleles_need_to_merge != "") then "--merge-alleles ${alleles_need_to_merge}" else "--no-alleles" 
    String out_file_name

    String? sample_size
    String N_argument = if (sample_size != "") then "--N ${sample_size}" else ""
    String? number_of_cases
    String N_cas_argument = if (number_of_cases != "") then "--N-cas ${number_of_cases}" else ""
    String? number_of_controls 
    String? N_con_argument = if (number_of_controls != "") then "--N-con ${number_of_controls}" else ""

    String? min_info
    String min_info_argument = if (min_info != "") then "--info-min" else ""
    String? min_maf
    String min_maf_argument = if (min_maf != "") then "--maf-min" else ""
    String? minimum_N
    String n_min_argument = if (minimum_N != "") then "--n-min" else ""

    String? chunk_size
    String chunksize_argument = if (chunk_size != "") then "--N ${chunk_size}" else ""
    String? name_of_SNP_column
    String snp_argument = if (name_of_SNP_column != "") then "--snp ${name_of_SNP_column}" else ""
    String? name_of_N_column 
    String N_COL_argument = if (name_of_N_column != "") then "--N-col ${name_of_N_column}" else ""

    String? name_of_cas_column
    String N_CAS_COL_argument = if (name_of_cas_column != "") then "--N-cas-col ${name_of_cas_column}" else ""
    String? name_of_controls_column
    String N_CON_COL_argument = if (name_of_controls_column != "") then "--N-con-col ${name_of_controls_column}" else ""
    String? name_of_A1_column
    String A1_argument = if (name_of_A1_column != "") then "--a1 ${name_of_A1_column}" else ""

    String? name_of_A2_column
    String A2_argument = if (name_of_A2_column != "") then "--a2 ${name_of_A2_column}" else ""
    String? name_of_p_value_column
    String P_argument = if (name_of_p_value_column != "") then "--p ${name_of_p_value_column}" else ""
    String? name_of_FRQ_or_MAF_column 
    String FRQ_argument = if (name_of_FRQ_or_MAF_column != "") then "--frq ${name_of_FRQ_or_MAF_column}" else ""

    String? name_of_signed_sumstat_column
    String signed_sumstat_argument = if (name_of_signed_sumstat_column != "") then "--signed-sumstats ${name_of_signed_sumstat_column}" else ""
    String? name_of_INFO_column
    String INFO_argument = if (name_of_INFO_column != "") then "--info ${name_of_INFO_column}" else ""
    String? comma_seperate_INFO_list
    String INFO_LIST_argument = if (comma_seperate_INFO_list != "") then "--info-list ${comma_seperate_INFO_list}" else ""

    String? name_of_NSTUDY_column
    String NSTUDY_argument = if (name_of_NSTUDY_column != "") then "--nstudy ${name_of_NSTUDY_column}" else ""
    String? minimum_of_studies
    String NSTUDY_MIN_argument = if (minimum_of_studies != "") then "--nstudy-min" else ""
    String? ignore_comma_seperated_list 
    String IGNORE_argument = if (ignore_comma_seperated_list != "") then "--ignore" else ""
    String? A1_increasing_allele
    String a1_inc_argument = if (A1_increasing_allele != "") then "--a1-inc" else ""
    String? keep_maf
    String keep_maf_argument = if (keep_maf != "") then "--keep-maf" else ""

    runtime {
        cpu: 1
        memory:"10 GB"
        walltimeset :"1:00:00"
        docker: "leeliu14/ldsctest:1.0.3"
    }



    command<<<
        source activate ldsc
        unset LD_PRELOAD
        cd ${work_directory}
        git clone https://github.com/bulik/ldsc.git
        cd ldsc
        

        ./munge_sumstats.py \
        ${sumstat_argument} \
        ${alleles_argument} \
        ${N_argument} \
        ${N_cas_argument} \
        ${N_con_argument} \
        ${min_info_argument} \
        ${min_maf_argument} \
        ${n_min_argument} \
        ${chunksize_argument} \
        ${snp_argument} \
        ${N_COL_argument} \
        ${N_CAS_COL_argument} \
        ${N_CON_COL_argument} \
        ${A1_argument} \
        ${A2_argument} \
        ${P_argument} \
        ${FRQ_argument} \
        ${signed_sumstat_argument} \
        ${INFO_argument} \
        ${INFO_LIST_argument} \
        ${NSTUDY_argument} \
        ${NSTUDY_MIN_argument} \
        ${IGNORE_argument} \
        ${a1_inc_argument} \
        ${keep_maf_argument} \
        --out ${out_file_name} 

        mv ${out_file_name}.log ${out_file_name}.sumstats.gz -t ${output_file_address}

    >>>

    output {
        File out_log = "${output_file_address}/${out_file_name}.log"
        File sumstat_out_file = "${output_file_address}/${out_file_name}.sumstats.gz"
    }

}

workflow test{
    String workflow_output_file_address
    String workflow_working_directory 

    File file_need_sumstat
    File alleles_file
    String sumstat_result_name

    String? sample_size_parameter
    String? number_of_cases_parameter
    String? number_of_controls_parameter
    String? use_min_info
    String? use_min_maf
    String? use_min_N
    String? use_chunksize
    String? indicate_name_of_snp_column
    String? indicate_name_of_N_column
    String? indicate_name_of_cases_column
    String? indicate_name_of_controls_column
    String? indicate_name_of_A1_column
    String? indicate_name_of_A2_column
    String? indicate_name_of_P_value_column
    String? indicate_name_of_FRQ_or_MAF_column
    String? indicate_name_of_signed_sum_stat_column
    String? indicate_name_of_INFO_column
    String? indicate_name_comma_seperated_INFO_list
    String? indicate_name_of_NSTUDY_column
    String? use_minimum_NSTUDIES
    String? if_ignore_comma_seperated_list
    String? if_A1_is_increasing_allele
    String? if_keep_MAF_column




    call preprocessing {
        input: sumstatbodypart = file_need_sumstat, 
        alleles_need_to_merge = alleles_file, 
        out_file_name = sumstat_result_name,
        output_file_address = workflow_output_file_address,
        work_directory = workflow_working_directory,
        sample_size = sample_size_parameter,
        number_of_cases = number_of_cases_parameter,
        number_of_controls = number_of_controls_parameter,
        min_info = use_min_info,
        min_maf = use_min_maf,
        minimum_N = use_min_N,
        chunk_size = use_chunksize,
        name_of_SNP_column = indicate_name_of_snp_column,
        name_of_N_column = indicate_name_of_N_column,
        name_of_cas_column = indicate_name_of_cases_column,
        name_of_controls_column = indicate_name_of_controls_column,
        name_of_A1_column = indicate_name_of_A1_column,
        name_of_A2_column = indicate_name_of_A2_column,
        name_of_p_value_column = indicate_name_of_P_value_column,
        name_of_FRQ_or_MAF_column = indicate_name_of_FRQ_or_MAF_column,
        name_of_signed_sumstat_column = indicate_name_of_signed_sum_stat_column,
        name_of_INFO_column = indicate_name_of_INFO_column,
        comma_seperate_INFO_list = indicate_name_comma_seperated_INFO_list,
        name_of_NSTUDY_column = indicate_name_of_NSTUDY_column,
        minimum_of_studies = use_minimum_NSTUDIES,
        ignore_comma_seperated_list = if_ignore_comma_seperated_list,
        A1_increasing_allele = if_A1_is_increasing_allele,
        keep_maf = if_keep_MAF_column              
    }
    

}