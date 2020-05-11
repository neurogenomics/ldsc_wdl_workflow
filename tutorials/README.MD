CTSA = Cell type specific analyses  
HGC = Heritability and Genetic Correlation  
LDSE = LD Score Estimation  
PH = Partitioned Heritability  

Before using this tutorial files, plz pull latest cromwell files from here: https://github.com/broadinstitute/cromwell/releases 

You can download and run "tutorial_preparation" part to prepare all files necessary for running this tutorial.  
#1 Before running .wdl files, download coordinate .wdl from task file :https://github.com/leebio14/ldsc_wdl_workflow/tree/master/tasks   
#2 Remember to change import "address" in order to make workflow recognize coordinate local task.wdl.  
#3 Remember to modify input and output files addaress in input_sample.json files in order to make wdl find correct address  
#4 For running HGC part, pgc.cross.bip.zip and pgc.cross.scz.zip files need to download from https://www.med.unc.edu/pgc/   

Command sample for running wdl  
module load java

java -Dconfig.file=YY.config -jar cromwell-XX.jar run ZZZ.wdl --inputs inputname.json

Config files for submitting through PBS and using singularity container seperately: https://github.com/leebio14/ldsc_wdl_workflow/tree/master/config

#If you don't need to submit your work to PBS or using docker image, you can run this command:
java -jar cromwell-XX.jar run ZZZ.wdl --inputs inputname.json


