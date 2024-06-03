# SNP Finder for Bacterial Samples
Welcome to the SNP Finder for Bacterial Samples repository! 
This project is dedicated to the identification and analysis of Single Nucleotide Polymorphisms (SNPs) in bacterial genomic data.    
SNPs are critical markers used in various fields including evolutionary biology, epidemiology, and microbial genetics to understand genetic variations, track disease outbreaks, and study bacterial evolution.   

# Getting Started   
SNP distance finder is a docker based tool. 
You just need a mininum of three bacterial NGS samples (fastq files) and run the following command:

<code>docker run -it --rm -v $(pwd):/Data -e inputfolder=fastq -e agent=SPNE ghcr.io/garcia-nacho/snpdistance</code>   
Where <code>inputfolder</code> points to the folder where the subfolders containing the samples are and <code>agent</code> is the bacterial species that you want to compare.  
For the momment there are four avaiblabe bacterial species:  
*Streptococcus pneumoniae* <code>-e agent=SPNE</code>   
*Streptococcus pyogenes Group A* <code>-e agent=GAS</code>   
*Mycobacterium tuberculosis* <code>-e agent=MTB</code>   
*Haemophilus influenzae* <code>-e agent=HINF</code>
   
# Applications   
This tool is ideal for:   

Comparative genomic studies
Tracking bacterial evolution and phylogenetics
Investigating pathogen outbreaks and transmission patterns

# Contributions   
We welcome contributions from the community! If you have suggestions for new features, improvements, or have found a bug, please open an issue or submit a pull request.
