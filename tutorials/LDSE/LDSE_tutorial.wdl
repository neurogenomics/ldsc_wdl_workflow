#LDSE_tutorial.wdl

import "/rds/general/user/ll2319/home/LDSC_work/wdl_task/make_annot_task.wdl" as MAKE_ANNOT
import "/rds/general/user/ll2319/home/LDSC_work/wdl_task/ldsc_all.wdl" as LDSC

workflow LD_Score_est_tutorial {
    String? workflow_output_file_address
    String? workflow_working_directory
    String? name_of_output

    String? bimfile_input 
    String? bedfile_input

    String Plink_format_file_input
    String if_estimate_l2
    String ld_wind_setting_parameter
    String ld_wind_sufflix_parameter
    String if_annot_is_thin_annot
    String only_print_ldscore_for_the_SNPs_list

    call MAKE_ANNOT.make_thin_annot as annot_thin {
        input: work_directory = workflow_working_directory,
        output_file_address = workflow_output_file_address,
        out_file_name = name_of_output,
        bimfile = bimfile_input,
        bedfile = bedfile_input
    }

    call LDSC.partritioned_ld_score as ldsc_pld {
        input: work_directory = workflow_working_directory,
        output_file_address = workflow_output_file_address,
        out_file_name = name_of_output,
        bfile = Plink_format_file_input,
        estimate_l2 = if_estimate_l2,
        ld_wind_setting = ld_wind_setting_parameter,
        ld_wind_sufflix = ld_wind_sufflix_parameter,
        thin_annot = if_annot_is_thin_annot,
        annot = annot_thin.out_annot_gz,
        print_snps = only_print_ldscore_for_the_SNPs_list

    }
}

