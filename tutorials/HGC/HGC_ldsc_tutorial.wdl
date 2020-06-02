#HGC_ldsc.wdl
#workflow for Heritability and Genetic Correlation
import "https://raw.githubusercontent.com/leebio14/ldsc_wdl_workflow/master/tasks/ldsc_all_task.wdl" as LDSC_HGC

workflow HGC_tutorial {

    String WORKFLOW_OUTPUT_FILE_ADDRESS 
    String WORKFLOW_WORKING_DIRECTORY

    String NAME_OF_LDSC_OUTPUT 

    #ldsc input
    Array[File] RG_FILES_INPUT

    String W_LD_CHR_FILE_ADDRESS 
    String REF_LD_CHR_FILE_ADDRESS

    String SAMP_PREV_PARAMETER
    String POP_PREV_PARAMETER

    String INTERCEPT_H2_PARAMETER
    String INTERCEPT_GENCOV_PARAMETER 
    String IF_REQUIRED_NO_INTERCEPT


        call LDSC_HGC.ldscrg as ldsc_HGC {
        input: rg_files = RG_FILES_INPUT,
        ref_ld_chr_address = REF_LD_CHR_FILE_ADDRESS,
        w_ld_chr_address = W_LD_CHR_FILE_ADDRESS,
        out_file_name = NAME_OF_LDSC_OUTPUT,
        output_file_address = WORKFLOW_OUTPUT_FILE_ADDRESS,
        work_directory = WORKFLOW_WORKING_DIRECTORY,
        samp_prev = SAMP_PREV_PARAMETER,
        pop_prev = POP_PREV_PARAMETER,
        intercept_h2 = INTERCEPT_H2_PARAMETER,
        intercept_gencov = INTERCEPT_GENCOV_PARAMETER,
        no_intercept = IF_REQUIRED_NO_INTERCEPT
    }





}