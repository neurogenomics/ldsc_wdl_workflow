#HGC_munge_stat.wdl
#workflow for Heritability and Genetic Correlation
import "https://raw.githubusercontent.com/leebio14/ldsc_wdl_workflow/master/tasks/munge_stat.wdl" as MUNGE_STAT

workflow HGC_tutorial {
#scz and bip common arguments
    String WORKFLOW_OUTPUT_FILE_ADDRESS 
    String WORKFLOW_WORKING_DIRECTORY 
    String ALLELES_FILE 

#munge stat scz seperate input
    String FILE_NEED_SUMSTAT_SCZ
    String SUMSTAT_RESULT_NAME_SCZ
    String? SAMPLE_SIZE_PARAMETER_SCZ

#munge stat bip seperate input
    String FILE_NEED_SUMSTAT_BIP
    String SUMSTAT_RESULT_NAME_BIP
    String? SAMPLE_SIZE_PARAMETER_BIP

    

#Arguments that are not necessary in this workflow    
 

    call MUNGE_STAT.preprocessing as munge_stat_HGC_bip {
        input: sumstatbodypart = FILE_NEED_SUMSTAT_BIP, 
        alleles_need_to_merge = ALLELES_FILE, 
        out_file_name = SUMSTAT_RESULT_NAME_BIP,
        output_file_address = WORKFLOW_OUTPUT_FILE_ADDRESS,
        work_directory = WORKFLOW_WORKING_DIRECTORY,
        sample_size = SAMPLE_SIZE_PARAMETER_BIP
    }

    call MUNGE_STAT.preprocessing as munge_stat_HGC_scz {
        input: sumstatbodypart = FILE_NEED_SUMSTAT_SCZ, 
        alleles_need_to_merge = ALLELES_FILE, 
        out_file_name = SUMSTAT_RESULT_NAME_SCZ,
        output_file_address = WORKFLOW_OUTPUT_FILE_ADDRESS,
        work_directory = WORKFLOW_WORKING_DIRECTORY,
        sample_size = SAMPLE_SIZE_PARAMETER_SCZ
    }



}



