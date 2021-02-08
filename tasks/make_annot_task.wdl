#make_annot_task.wdl
task make_normal_annot {
    String? output_file_address
    String? work_directory
    String? out_file_name

    String? gene_set_file
    String gene_set_file_argument = if (gene_set_file != "") then "--gene-set-file ${gene_set_file}" else ""
    String? windowsize
    String windowsize_argument = if (windowsize != "") then "--windowsize ${windowsize}" else ""
    String? gene_coordinate_file
    String gene_coordinate_file_argument = if (gene_coordinate_file != "") then "--gene-coord-file ${gene_coordinate_file}" else ""
    String? bimfile
    String bimfile_argument = if (bimfile != "") then "--bimfile ${bimfile}" else ""
    String? no_merge
    String no_merge_argument = if (no_merge != "") then "--nomerge" else ""
    String? bedfile
    String bedfile_argument = if (bedfile != "") then "--bed-file ${bedfile}" else ""

    runtime {
        cpu:1
        memory:"10 GB"
        walltimeset:"1:00:00"
        docker:"leeliu14/ldsctest:1.0.3"

    }
    
    command <<<
    source activate ldsc
    cd ${work_directory}/ldsc

    ./make_annot.py \
    ${gene_set_file_argument} \
    ${gene_coordinate_file_argument} \
    ${windowsize_argument} \
    ${bimfile_argument} \
    ${no_merge_argument} \
    ${bedfile_argument} \
    --annot-file ${out_file_name}.annot.gz


    mv ${out_file_name}.annot.gz -t ${output_file_address}
    >>>

    output {
        String out = read_string(stdout())
        File out_annot_gz = "${output_file_address}/${out_file_name}.annot.gz"

    }

}


task make_thin_annot {
    String? output_file_address
    String? work_directory
    String? out_file_name 

    File bedfile
    String bedfile_argument = if (bedfile != "") then "--bed-file ${bedfile}" else ""
    File bimfile
    String bimfile_argument = if (bimfile != "") then "--bimfile ${bimfile}" else ""


    runtime {
        cpu:1
        memory:"10 GB"
        walltimeset:"1:00:00"
        docker:"leeliu14/ldsctest:1.0.3"

    }

    command <<<

    source activate ldsc
    cd ${work_directory}/ldsc

    ./make_annot.py \
    ${bedfile_argument} \
    ${bimfile_argument} \
    --annot-file ${out_file_name}.annot.gz


    mv ${out_file_name}.annot.gz -t ${output_file_address}

    >>>


    output {
        String out = read_string(stdout())
        File out_annot_gz = "${output_file_address}/${out_file_name}.annot.gz"

    }

}

task make_normal_annot_22 {
    String? output_file_address
    String? work_directory
    String? out_file_name

    String? gene_set_file_address
    String? gene_set_file_preflix
    String? gene_set_file_sufflix
    String? bimfile_address
    String? bimfile_preflix
    String? windowsize
    String windowsize_argument = if (windowsize != "") then "--windowsize ${windowsize}" else ""
    String? gene_coordinate_file
    String gene_coordinate_file_argument = if (gene_coordinate_file != "") then "--gene-coord-file ${gene_coordinate_file}" else ""
    String? no_merge
    String no_merge_argument = if (no_merge != "") then "--nomerge" else ""
    String? bedfile
    String bedfile_argument = if (bedfile != "") then "--bed-file ${bedfile}" else ""
    Int cell_types_number

    runtime {
        cpu:1
        memory:"10 GB"
        walltimeset:"1:00:00"
        docker:"leeliu14/ldsctest:1.0.3"

    }
    
    command <<<
    source activate ldsc
    cd ${work_directory}/ldsc

    for((i=1; i<=${cell_types_number}; i=i+1))
    do
        for((j=1; j<=22; j=j+1))
        do
        ./make_annot.py \
        --gene-set-file ${gene_set_file_address}/${gene_set_file_preflix}"$i"${gene_set_file_sufflix} \
        ${gene_coordinate_file_argument} \
        ${windowsize_argument} \
        --bimfile ${bimfile_address}/${bimfile_preflix}.$j.bim\
        ${no_merge_argument} \
        ${bedfile_argument} \
        --annot-file ${out_file_name}.$i.$j.annot.gz

        mv ${out_file_name}.$i.$j.annot.gz -t ${output_file_address}
        done
    done


    
    >>>

    output {
        String out = read_string(stdout())
        String out_annot_gz_address = "${output_file_address}"
        String out_annot_gz_preflix = "${out_file_name}"
        String out_annot_gz_sufflix = "annot.gz"
    }

}

task make_thin_annot_22 {
    String? output_file_address
    String? work_directory
    String? out_file_name 

    Int cell_types_number
    String bedfile_preflix
    String bedfile_address
    String bedfile_sufflix

    String? bimfile_address
    String? bimfile_preflix



    runtime {
        cpu:1
        memory:"10 GB"
        walltimeset:"1:00:00"
        docker:"leeliu14/ldsctest:1.0.3"

    }

    command <<<

    source activate ldsc
    cd ${work_directory}/ldsc
    
    for((i=1; i<=${cell_types_number}; i=i+1))
    do
        for((j=1; j<=22; j=j+1))
        do
        ./make_annot.py \
        --bed-file ${bedfile_address}/${bedfile_preflix}"$i"${bedfile_sufflix} \
        --bimfile ${bimfile_address}/${bimfile_preflix}.$j.bim \
        --annot-file ${out_file_name}.$i.$j.annot.gz

        mv ${out_file_name}.$i.$j.annot.gz -t ${output_file_address}
        done
    done


    >>>


    output {
        String out = read_string(stdout())
        String out_annot_gz_address = "${output_file_address}"
        String out_annot_gz_preflix = "${out_file_name}"
        String out_annot_gz_sufflix = "annot.gz"

    }

}


workflow test_make_thin_annot_22 {
    String? workflow_output_file_address
    String? workflow_working_directory
    String? name_of_output

    call make_thin_annot_22 {
        input: work_directory = workflow_working_directory,
        output_file_address = workflow_output_file_address,
        out_file_name = name_of_output

    }


}

#workflow test_make_normal_annot_22 {
#    String? workflow_output_file_address
#    String? workflow_working_directory
#    String? name_of_output
#
#    call make_normal_annot_22 {
#        input: work_directory = workflow_working_directory,
#        output_file_address = workflow_output_file_address,
#        out_file_name = name_of_output
#
#    }
#
#
#}

#workflow test_make_thin_annot {
#    String? workflow_output_file_address
#    String? workflow_working_directory
#    String? name_of_output
#    String? bimfile_input 
#    String? bedfile_input
#
#    call make_thin_annot {
#        input: work_directory = workflow_working_directory,
#        output_file_address = workflow_output_file_address,
#        out_file_name = name_of_output,
#        bimfile = bimfile_input,
#        bedfile = bedfile_input
#
#    }   
#
#}






#workflow test_make_normal_annot{
#    String? workflow_output_file_address
#    String? workflow_working_directory
#    String? name_of_output
#
#    String? gene_set_file_input
#    String? windowsize_parameter
#    String? gene_coordinate_file_input
#    String? bimfile_input
#    String? if_do_not_merge_bed_file
#    String? bedfile_input
#
#    call make_normal_annot {
#        input: work_directory = workflow_working_directory,
#        output_file_address = workflow_output_file_address,
#        out_file_name = name_of_output,
#        gene_set_file = gene_set_file_input,
#        gene_coordinate_file = gene_coordinate_file_input,
#        bimfile = bimfile_input,
#        bedfile = bedfile_input,
#        no_merge = if_do_not_merge_bed_file,
#        windowsize = windowsize_parameter
#    }
#
#
#
#}
