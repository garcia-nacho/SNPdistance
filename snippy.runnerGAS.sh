#!/bin/bash
cd ${1}
mkdir /Data/SnippyResults
for dir in $(ls -d */)
do

    cd ${dir}
    echo ${dir}
    
    R1=$(ls *R1*)
    R2=$(ls *R2*)
    
    snippy --cpus 5 --outdir /Data/SnippyResults/${dir%/} --ref /home/docker/references/SASM4_Duke.fasta --R1 ${R1} --R2 ${R2}
    cd ..

done
cd /Data/SnippyResults/

snippy-core --ref /home/docker/references/SASM4_Duke.fasta --prefix SnippyResults $(ls -d *)
snippy-clean_full_aln ./SnippyResults.full.aln > SnippyResults.full_clean.aln
run_gubbins -p gubbins SnippyResults.full_clean.aln
snp-sites -c gubbins.filtered_polymorphic_sites.fasta > Snippy_superclean.core.aln
FastTree -gtr -nt Snippy_superclean.core.aln > Snippy.tree
