'''

Retrieve Genbank entries from the nucleotide database at NCBI.

-----------------------------------------------------------
(c) 2013 Allegra Via and Kristian Rother
    Licensed under the conditions of the Python License

    This code appears in section 20.4.3 of the book
    "Managing Biological Data with Python".
-----------------------------------------------------------

Modified by Gail Rosen for ECES640/490
'''

from Bio import Entrez
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
from Bio.Alphabet import generic_dna, generic_protein

Entrez.email = 'A.N.Other@example.com'
top_records=[]

# search sequences by a combination of keywords
handle = Entrez.esearch(db="nucleotide", term="cytochrome oxidase i AND viridiplantae[Organism] and 450:2000[Sequence Length]")
records = Entrez.read(handle)
top_records.append(records['IdList'][0])

handle1=Entrez.esearch(db="nucleotide", term="cytochrome oxidase i AND fungi[Organism] and 450:2000[Sequence Length]")
records = Entrez.read(handle1)
top_records.append(records['IdList'][0])

handle2=Entrez.esearch(db="nucleotide", term="cytochrome oxidase i AND animalia[Organism] and 450:2000[Sequence Length]")
records = Entrez.read(handle2)
top_records.append(records['IdList'][0])

# retrieve the sequences by their GI numbers
gi_list = ','.join(top_records)
print "These are the GI Numbers chosen: ",gi_list
handle = Entrez.efetch(db="nucleotide", id=gi_list, rettype="gb", retmode="xml")
my_genbank_records = Entrez.read(handle)
handle.close()


#print These are the organisms that it first found
print "My plant: ",my_genbank_records[0]['GBSeq_organism'],"and its accession number: ",my_genbank_records[0]['GBSeq_primary-accession']
print "My fungi: ",my_genbank_records[1]['GBSeq_organism'],"and its accession number: ",my_genbank_records[1]['GBSeq_primary-accession']
print "My animal: ",my_genbank_records[2]['GBSeq_organism'],"and its accession number: ",my_genbank_records[2]['GBSeq_primary-accession']


#Here is where we have to convert Genbank to FASTA
my_fasta_records=[]
for i in range(len(my_genbank_records)):
	my_fasta_records.append(SeqRecord(Seq(my_genbank_records[i]['GBSeq_sequence']),id=my_genbank_records[i]['GBSeq_primary-accession'],description=my_genbank_records[i]['GBSeq_definition']))

#This can output one file
one_file=open("my_seqs.fa","w")
SeqIO.write(my_fasta_records, one_file, "fasta")
one_file.close()


##### ALL THIS STUFF TO PRINT 3 FILES   ######
plant_prefix="_".join((my_genbank_records[0]['GBSeq_organism'],my_genbank_records[0]['GBSeq_primary-accession']))
fungi_prefix="_".join((my_genbank_records[1]['GBSeq_organism'],my_genbank_records[1]['GBSeq_primary-accession'],))
animal_prefix="_".join((my_genbank_records[2]['GBSeq_organism'],my_genbank_records[2]['GBSeq_primary-accession']))

print "My filenames are: ",plant_prefix,fungi_prefix,animal_prefix

output_plant=open(plant_prefix+'.fa',"w")
output_fungi=open(fungi_prefix+'.fa',"w")
output_animal=open(animal_prefix+'.fa',"w")

SeqIO.write(my_fasta_records[0], output_plant, "fasta")
SeqIO.write(my_fasta_records[1], output_fungi, "fasta")
SeqIO.write(my_fasta_records[2], output_animal, "fasta")

output_plant.close()
output_fungi.close()
output_animal.close()

####  END 3 FILES ####






