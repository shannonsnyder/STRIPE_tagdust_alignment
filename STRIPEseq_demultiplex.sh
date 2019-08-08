#!/bin/bash

### Please enter info below. Test files are added by default ###
fastqDir=/home/ssnyde11/scratch/Dpul_Dobt_fastqs
barcodes=/home/ssnyde11/scratch/STRIPE_demult_test/RAMPAGE_barcodes_example.txt
nMismatch=1 #number of mismatches tolerated between barcode and sequence (as long as they are unique)/home/ssnyde11/scratch/Dpul_Dobt_fastq
#################

echo "Demultiplexing your fastq using the " $barcodes "file."

cd $fastqDir

fastq-multx -m $nMismatch -B $barcodes -b Undetermined_S0_R1_001.fastq Undetermined_S0_R2_001.fastq -o fastq_undetermined.R1.%.fastq fastq_undetermined.R2.%.fastq

echo "Demultiplexing is complete!"

echo "Unmatched reads are moved into /demultiplexed_unmatched directory."

mkdir demultiplexed_unmatched
mv *.R?.unmatched.fastq demultiplexed_unmatched

echo "Moving succesffully demultiplexed reads to /demultiplexed_matched directory. Unmatched reads were moved into /demultiplexed_unmatched directory."

mkdir demultiplexed_matched

mv *.R?.*.fastq demultiplexed_matched

echo "Job complete!"





