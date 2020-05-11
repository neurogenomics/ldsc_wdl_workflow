#PH_tutorial.wdl
import "/rdsgpfs/general/user/ll2319/home/LDSC_work/wdl_task/munge_stat.wdl" as MUNGE_STAT
import "/rdsgpfs/general/user/ll2319/home/LDSC_work/wdl_task/ldsc_all.wdl" as LDSC
workflow Partitioned_Heritability_tutorial {
    String? WORKFLOW_OUTPUT_FILE_ADDRESS
    String? WORKFLOW_WORKING_DIRECTORY
    String? NAME_OF_OUTPUT_MUNGE_STAT
    String? NAME_OF_OUTPUT_LDSC

    #input for munge_stat
    String FILE_NEED_SUMSTAT
    String ALLELES_FILE
    String IF_A1_IS_INCREASING_ALLELE

    String weight_file_address_and_flag
    Array[String] ref_ldscore_file_and_flag
    String frq_file_and_flag
    String if_overlap_annot
    String if_print_coefficients
    String if_print_delet_vals 

    call MUNGE_STAT.preprocessing as ph_munge_stat {
        input: output_file_address = WORKFLOW_OUTPUT_FILE_ADDRESS,
        work_directory = WORKFLOW_WORKING_DIRECTORY,
        out_file_name = NAME_OF_OUTPUT_MUNGE_STAT,
        sumstatbodypart = FILE_NEED_SUMSTAT,
        alleles_need_to_merge = ALLELES_FILE,
        A1_increasing_allele = IF_A1_IS_INCREASING_ALLELE

    }




    call LDSC.ldsc_ph_from_continuous_annot as ph_ldsc {
        input: output_file_address = WORKFLOW_OUTPUT_FILE_ADDRESS,
        work_directory = WORKFLOW_WORKING_DIRECTORY,
        out_file_name = NAME_OF_OUTPUT_LDSC,
        h2 = ph_munge_stat.sumstat_out_file,
        ref_ld_chr_files = ref_ldscore_file_and_flag,
        frqfile_chr = frq_file_and_flag,
        w_ld_chr = weight_file_address_and_flag,
        overlap_annot = if_overlap_annot,
        print_coefficients = if_print_coefficients,
        print_delet_vals = if_print_delet_vals
    }


}