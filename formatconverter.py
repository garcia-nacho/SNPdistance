from Bio import SeqIO

records = SeqIO.parse("Snippy_superclean.core.aln", "fasta")
count = SeqIO.write(records, "Snippy_superclean.core.phy", "phylip")