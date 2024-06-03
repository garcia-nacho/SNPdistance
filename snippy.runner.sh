#!/bin/bash

#!/bin/bash

cd ${1}
agent=${2}
case ${2} in 

   "GAS")
    ref="/home/docker/references/SASM4_Duke.fasta"
    ;;

   "SPNE")
    ref="/home/docker/references/TIGR4.fasta"
    ;;

   "MTB")
    ref="/home/docker/references/H37Rv.fasta"
    ;;

   "HINF")
    ref="/home/docker/references/RdKW20.fasta"
    ;;
    *)
    ref="UNK"
    ;;

esac
    
if [ ${ref} == "UNK" ]
then
    echo ""
    echo "Unkown agent."
    echo ""
    echo "Use one of the following:"
    echo ""
    echo "GAS: Streptococcus pyogenes Group A"
    echo "SPNE: Streptococcus pneumoniae"
    echo "MTB: Mycobacterium tuberculosis"
    echo "HINF: Haemophilus influenzae"
    echo ""

else

    echo  Agent ${agent}
    mkdir /Data/SnippyResults


    for dir in $(ls -d */)
    do

        cd ${dir}
        echo ${dir}
        
        R1=$(ls *R1*)
        R2=$(ls *R2*)
        
        snippy --cpus 6 --outdir /Data/SnippyResults/${dir%/} --ref ${ref} --R1 ${R1} --R2 ${R2}
        cd ..

    done
    cd /Data/SnippyResults/

    snippy-core --ref ${ref} --prefix SnippyResults $(ls -d *)
    snippy-clean_full_aln ./SnippyResults.full.aln > SnippyResults.full_clean.aln
    run_gubbins -p gubbins SnippyResults.full_clean.aln
    snp-sites -c gubbins.filtered_polymorphic_sites.fasta > Snippy_superclean.core.aln
    FastTree -gtr -nt Snippy_superclean.core.aln > ${agent}_Snippy.tree
    Rscript /home/docker/code/SNPdistance.R

fi




#Check agent in list


