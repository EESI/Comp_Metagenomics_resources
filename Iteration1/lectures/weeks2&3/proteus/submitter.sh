#!/usr/bin/env bash 
#$ -S /bin/bash
#$ -cwd
#$ -M gcd34@drexel.edu
#$ -P nsftuesPrj 
#$ -q all.q@@intelhosts 

# boiler plate stuff here! set up the environment at we need to do our
# computation
. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa

module load gcc/4.8.1
module load qiime/gcc/64/1.8.0

###############################
## Change this path!!!!
data_fp=/home/gcd34/Git/ECES490-Sp2015/data
out_fp=/home/gcd34/Git/ECES490-Sp2015/proteus/output/

# 1) check out mapping file 
validate_mapping_file.py -m ${data_fp}/Fasting_Map.txt -o ${TMP}/mapping_output/ -v

# 2) split the libraries
split_libraries.py -m ${data_fp}/Fasting_Map.txt -f ${data_fp}/Fasting_Example.fna -q ${data_fp}/Fasting_Example.qual -o ${TMP}/split_library_output

# 3) pick otus  
pick_de_novo_otus.py -i ${TMP}/split_library_output/seqs.fna -o ${TMP}/otus

# 4) create a heat map of the OTU table 
make_otu_heatmap_html.py -i ${TMP}/otus/otu_table.biom -o ${TMP}/otus/OTU_Heatmap/

# 5) 
make_otu_network.py -m ${data_fp}/Fasting_Map.txt -i ${TMP}/otus/otu_table.biom -o ${TMP}/otus/OTU_Network

# 6) 
summarize_taxa_through_plots.py -i ${TMP}/otus/otu_table.biom -o ${TMP}/wf_taxa_summary -m ${data_fp}/Fasting_Map.txt

# 7)
echo "alpha_diversity:metrics shannon,PD_whole_tree,chao1,observed_species" > ${TMP}/alpha_params.txt
alpha_rarefaction.py -i ${TMP}/otus/otu_table.biom -m ${data_fp}/Fasting_Map.txt -o ${TMP}/wf_arare/ -p ${TMP}/alpha_params.txt -t ${TMP}/otus/rep_set.tre

# 8) 
beta_diversity_through_plots.py -i ${TMP}/otus/otu_table.biom -m ${data_fp}/Fasting_Map.txt -o ${TMP}/wf_bdiv_even146/ -t ${TMP}/otus/rep_set.tre -e 146

# 9) 
jackknifed_beta_diversity.py -i ${TMP}/otus/otu_table.biom -t ${TMP}/otus/rep_set.tre -m ${data_fp}/Fasting_Map.txt -o ${TMP}/wf_jack/ -e 110

# 10)
make_bootstrapped_tree.py -m ${TMP}/wf_jack/unweighted_unifrac/upgma_cmp/master_tree.tre -s ${TMP}/wf_jack/unweighted_unifrac/upgma_cmp/jackknife_support.txt -o ${TMP}/wf_jack/unweighted_unifrac/upgma_cmp/jackknife_named_nodes.pdf

# remember that we were writing to scratch space. we need to move the files 
# back to our home folder. 
mv ${TMP}/mapping_output/ ${out_fp}/mapping_output/
mv ${TMP}/split_library_output ${out_fp}/split_library_output/
mv ${TMP}/otus ${out_fp}/otus
mv ${TMP}/otus/OTU_Heatmap/ ${out_fp}/otus/OTU_Heatmap/
mv ${TMP}/otus/OTU_Network ${out_fp}/otus/OTU_Network
mv ${TMP}/wf_taxa_summary/ ${out_fp}/wf_taxa_summary/
mv ${TMP}/alpha_params.txt ${out_fp}/alpha_params.txt
mv ${TMP}/wf_arare ${out_fp}/wf_arare
mv ${TMP}/wf_bdiv_even146/ ${out_fp}/wf_bdiv_even146/
mv ${TMP}/wf_jack ${out_fp}/wf_jack
mv ${TMP}/wf_jack/unweighted_unifrac/upgma_cmp/jackknife_named_nodes.pdf ${out_fp}/wf_jack/unweighted_unifrac/upgma_cmp/jackknife_named_nodes.pdf

