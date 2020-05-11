#CTSA_tutorial.wdl
import "/rdsgpfs/general/user/ll2319/home/LDSC_work/wdl_task/munge_stat.wdl" as MUNGE_STAT
import "/rdsgpfs/general/user/ll2319/home/LDSC_work/wdl_task/ldsc_all.wdl" as LDSC

workflow Cell_type_specific_analyses_tutorial {
    String? WORKFLOW_OUTPUT_FILE_ADDRESS
    String? WORKFLOW_WORKING_DIRECTORY
    String? NAME_OF_OUTPUT_MUNGE_STAT
    String? NAME_OF_OUTPUT_LDSC

    #input for munge_stat
    String FILE_NEED_SUMSTAT
    String ALLELES_FILE

    #input for ctsa
    String weight_file_address_and_flag
    String ref_ldscore_file_and_flag
    String cts_ref_ldscore_file_and_flag



    call MUNGE_STAT.preprocessing as ctsa_munge_stat {
        input: output_file_address = WORKFLOW_OUTPUT_FILE_ADDRESS,
        work_directory = WORKFLOW_WORKING_DIRECTORY,
        out_file_name = NAME_OF_OUTPUT_MUNGE_STAT,
        sumstatbodypart = FILE_NEED_SUMSTAT,
        alleles_need_to_merge = ALLELES_FILE

    }
    call LDSC.ldsc_ctsa as ctsa_ldsc {
        input: output_file_address = WORKFLOW_OUTPUT_FILE_ADDRESS,
        work_directory = WORKFLOW_WORKING_DIRECTORY,
        out_file_name = NAME_OF_OUTPUT_LDSC,
        h2_cts = ctsa_munge_stat.sumstat_out_file,
        w_ld_chr = weight_file_address_and_flag,
        ref_ld_chr = ref_ldscore_file_and_flag,
        ref_ld_chr_cts = cts_ref_ldscore_file_and_flag

    }


}
