#!/bin/bash                                                                                                                                                 
BWAdir=/home/ssnyde11/scratch/archive-GSF2320-20190717

module load fastqc/0.11.7

cd $BWAdir                                                                                                                                                 
echo "Starting fastqc job"                                                                                                                                 
for fq in GSF2320-*-rep?_S*_R?_001.fastq.gz                                                                                                                                  
do                                                                                                                                                        
fastqc $fq                                                                                                                                                 
done
