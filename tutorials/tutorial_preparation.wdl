#tutorial_prepration.wdl
task tutorial_prepration {
    String? output_file_address
    String? work_directory
    String? input_file_address

    String name_of_HGC_tutorial_file
    String name_of_LDSE_tutorial_file
    String name_of_CTSA_tutorial_file
    String name_of_PH_file

    runtime {
        cpu: 1
        memory:"10 GB"
        walltimeset :"1:00:00"
        docker: "leeliu14/ldsctest:1.0.3"
    }

    command <<<

    #create files for different tutorial parts for inputs and outputs
    mkdir -p ${input_file_address}/{${name_of_HGC_tutorial_file}_input,${name_of_LDSE_tutorial_file}_input,${name_of_CTSA_tutorial_file}_input,${name_of_PH_file}_input}
    mkdir -p ${output_file_address}/{${name_of_HGC_tutorial_file}_output,${name_of_LDSE_tutorial_file}_output,${name_of_CTSA_tutorial_file}_output,${name_of_PH_file}_output}


    #pull ldsc for running tutorial
    #Cahoy_ctls need to be put under ldsc directory to run cell type specific analysis tutorial
    cd ${work_directory}
    git clone https://github.com/bulik/ldsc.git
    cd ldsc
    wget https://data.broadinstitute.org/alkesgroup/LDSCORE/LDSC_SEG_ldscores/Cahoy_1000Gv3_ldscores.tgz
    tar -xvzf Cahoy_1000Gv3_ldscores.tgz
    wget https://data.broadinstitute.org/alkesgroup/LDSCORE/eur_w_ld_chr.tar.bz2
    tar -jxvf eur_w_ld_chr.tar.bz2

    #please go to https://www.med.unc.edu/pgc/ download pgc.cross.bip.zip and pgc.cross.scz.zip to run analysis 

    cd ${input_file_address}/${name_of_HGC_tutorial_file}_input
    wget https://data.broadinstitute.org/alkesgroup/LDSCORE/w_hm3.snplist.bz2
    bunzip2 w_hm3.snplist.bz2


    cd ${input_file_address}/${name_of_LDSE_tutorial_file}_input
    wget https://data.broadinstitute.org/alkesgroup/LDSCORE/1kg_eur.tar.bz2
    wget https://data.broadinstitute.org/alkesgroup/LDSCORE/make_annot_sample_files/1000G.EUR.QC.22.bim
    wget https://data.broadinstitute.org/alkesgroup/LDSCORE/make_annot_sample_files/Brain_DPC_H3K27ac.bed
    wget https://data.broadinstitute.org/alkesgroup/LDSCORE/make_annot_sample_files/ENSG_coord.txt
    wget https://data.broadinstitute.org/alkesgroup/LDSCORE/make_annot_sample_files/GTEx_Cortex.GeneSet
    wget https://data.broadinstitute.org/alkesgroup/LDSCORE/1000G_Phase3_plinkfiles.tgz
    wget https://data.broadinstitute.org/alkesgroup/LDSCORE/hapmap3_snps.tgz
    tar -jxvf 1kg_eur.tar.bz2
    tar -xvzf 1000G_Phase3_plinkfiles.tgz
    tar -xvzf hapmap3_snps.tgz


    cd ${input_file_address}/${name_of_CTSA_tutorial_file}_input
   
    wget https://data.broadinstitute.org/alkesgroup/LDSCORE/1000G_Phase3_baseline_ldscores.tgz
    wget https://data.broadinstitute.org/alkesgroup/LDSCORE/weights_hm3_no_hla.tgz   
    tar -xvzf 1000G_Phase3_baseline_ldscores.tgz
    tar -xvzf weights_hm3_no_hla.tgz

    wget https://data.broadinstitute.org/alkesgroup/UKBB/body_BMIz.sumstats.gz
    wget https://data.broadinstitute.org/alkesgroup/LDSCORE/w_hm3.snplist.bz2
    bunzip2 w_hm3.snplist.bz2


    cd ${input_file_address}/${name_of_PH_file}_input
    wget http://portals.broadinstitute.org/collaboration/giant/images/b/b7/GIANT_BMI_Speliotes2010_publicrelease_HapMapCeuFreq.txt.gz
    wget https://data.broadinstitute.org/alkesgroup/LDSCORE/w_hm3.snplist.bz2
    gunzip GIANT_BMI_Speliotes2010_publicrelease_HapMapCeuFreq.txt.gz
    bunzip2 w_hm3.snplist.bz2

    wget https://data.broadinstitute.org/alkesgroup/LDSCORE/1000G_Phase1_baseline_ldscores.tgz
    wget https://data.broadinstitute.org/alkesgroup/LDSCORE/weights_hm3_no_hla.tgz
    wget https://data.broadinstitute.org/alkesgroup/LDSCORE/1000G_Phase1_frq.tgz

    tar -xvzf 1000G_Phase1_baseline_ldscores.tgz
    tar -xvzf weights_hm3_no_hla.tgz
    tar -xvzf 1000G_Phase1_frq.tgz





    
    >>>

    output {
        String out = read_string(stdout())
    }


}

workflow tutorial_prep {
    String? workflow_output_file_address
    String? workflow_working_directory
    String? workflow_input_file_address

    String? name_of_Heritability_and_Genetic_Correlation_tutorial_file
    String? name_of_LD_Score_Estimation_tutorial_file
    String? name_of_Cell_type_specific_analyses_tutorial_file
    String? name_of_Partitioned_Heritability_tutorial_file

    call tutorial_prepration {
        input: output_file_address = workflow_output_file_address,
        work_directory = workflow_working_directory,
        input_file_address = workflow_input_file_address,
        name_of_HGC_tutorial_file = name_of_Heritability_and_Genetic_Correlation_tutorial_file,
        name_of_LDSE_tutorial_file = name_of_LD_Score_Estimation_tutorial_file,
        name_of_CTSA_tutorial_file = name_of_Cell_type_specific_analyses_tutorial_file,
        name_of_PH_file = name_of_Partitioned_Heritability_tutorial_file


    }
}
