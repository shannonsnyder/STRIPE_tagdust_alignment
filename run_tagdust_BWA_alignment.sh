#!/bin/bash

BWAdir=/scratch/ssnyde11/Dpul_Dobt_STRIPE-seq/fastq_data
GENOME_DIR=/home/ssnyde11/DpGENOME
GENOME_FILE=PA42.4.1.fasta
TAGDUST=/home/ssnyde11/genome_analysis/tagdust-2.33/src/tagdust
BWA=/packages/7x/bwakit/0.7.12/bwa.kit/bwa
RNAfile=/home/ssnyde11/DpGENOME/Dpul-rDNA.fa
fastqDir=/home/ssnyde11/scratch/Dpul_Dobt_STRIPE-seq/fastq_data
SAMTOOLS=/packages/7x/samtools/1.8/bin/samtools

Removing ribosomal RNA hits with tagdust:


Removing ribosomal RNA hits with tagdust:



THREADS=8

SAMPLE1=5_S5
SAMPLE2=11_S11
SAMPLE3=18_S18
SAMPLE4=12_S12
SAMPLE5=2_S2
SAMPLE6=10_S10
SAMPLE7=17_S17
SAMPLE8=7_S7

daphnia_rep1_R1=GSF2251-RTO_${SAMPLE1}_R1_001.fastq
daphnia_rep1_R2=GSF2251-RTO_${SAMPLE1}_R2_001.fastq
daphnia_rep2_R1=GSF2251-RTO_${SAMPLE2}_R1_001.fastq
daphnia_rep2_R2=GSF2251-RTO_${SAMPLE2}_R2_001.fastq
daphnia_rep3_R1=GSF2251-RTO_${SAMPLE3}_R1_001.fastq
daphnia_rep3_R2=GSF2251-RTO_${SAMPLE3}_R2_001.fastq
daphnia_rep4_R1=GSF2251-RTO_${SAMPLE4}_R1_001.fastq
daphnia_rep4_R2=GSF2251-RTO_${SAMPLE4}_R2_001.fastq
daphnia_rep5_R1=GSF2251-RTO_${SAMPLE5}_R1_001.fastq
daphnia_rep5_R2=GSF2251-RTO_${SAMPLE5}_R2_001.fastq
daphnia_rep6_R1=GSF2251-RTO_${SAMPLE6}_R1_001.fastq
daphnia_rep6_R2=GSF2251-RTO_${SAMPLE6}_R2_001.fastq
daphnia_rep7_R1=GSF2251-RTO_${SAMPLE7}_R1_001.fastq
daphnia_rep7_R2=GSF2251-RTO_${SAMPLE7}_R2_001.fastq
daphnia_rep8_R1=GSF2251-RTO_${SAMPLE8}_R1_001.fastq
daphnia_rep8_R2=GSF2251-RTO_${SAMPLE8}_R2_001.fastq

OP1=${SAMPLE1}_trno_tagdusted
OP2=${SAMPLE2}_trno_tagdusted
OP3=${SAMPLE3}_trno_tagdusted
OP4=${SAMPLE4}_trno_tagdusted

OP5=${SAMPLE5}_trno_tagdusted
OP6=${SAMPLE6}_trno_tagdusted
OP7=${SAMPLE7}_trno_tagdusted
OP8=${SAMPLE8}_trno_tagdusted

cd $fastqDir

#${TAGDUST} -ref ${RNAfile} -dust 97 -t ${THREADS} -fe 3 -1 R:N ${daphnia_rep1_R1} ${daphnia_rep1_R2} -o ${OP1}
#${TAGDUST} -ref ${RNAfile} -dust 97 -t ${THREADS} -fe 3 -1 R:N ${daphnia_rep2_R1} ${daphnia_rep2_R1} -o ${OP2}
#${TAGDUST} -ref ${RNAfile} -dust 97 -t ${THREADS} -fe 3 -1 R:N ${daphnia_rep3_R1} ${daphnia_rep3_R1} -o ${OP3}
#${TAGDUST} -ref ${RNAfile} -dust 97 -t ${THREADS} -fe 3 -1 R:N ${daphnia_rep4_R1} ${daphnia_rep4_R2} -o ${OP4}

#${TAGDUST} -ref ${RNAfile} -dust 97 -t ${THREADS} -fe 3 -1 R:N ${daphnia_rep5_R1} ${daphnia_rep5_R2} -o ${OP5}
#${TAGDUST} -ref ${RNAfile} -dust 97 -t ${THREADS} -fe 3 -1 R:N ${daphnia_rep6_R1} ${daphnia_rep6_R2} -o ${OP6}
#${TAGDUST} -ref ${RNAfile} -dust 97 -t ${THREADS} -fe 3 -1 R:N ${daphnia_rep7_R1} ${daphnia_rep7_R2} -o ${OP7}
#${TAGDUST} -ref ${RNAfile} -dust 97 -t ${THREADS} -fe 3 -1 R:N ${daphnia_rep8_R1} ${daphnia_rep8_R2} -o ${OP8}

cd ${BWAdir}

echo "Indexing the Daphnia genome using bwa ..."
echo "bwa index ${GENOME_DIR}/${GENOME_FILE}"
${BWA}  index ${GENOME_DIR}/${GENOME_FILE}

echo "Starting alignments ..."
for fq in *_trno_tagdusted_READ1.fq;
do

        echo "bwa aln -t ${THREADS} -n 3 ${GENOME_DIR}/${GENOME_FILE} -f $(basename ${fq} _trno_tagdusted_READ1.fq).sai ${fq} $(basename ${fq} _READ1.fq)_READ2.fq"
  	${BWA} aln -t ${THREADS} -n 3 ${GENOME_DIR}/${GENOME_FILE} -f $(basename ${fq} _trno_tagdusted_READ1.fq).sai ${fq} $(basename ${fq} _READ1.fq)_READ2.fq

	echo "$fq"

echo "${BWA} samse ${GENOME_DIR}/${GENOME_FILE} $(basename $fq .fq_trno_tagdusted.fq).sai $fq | ${SAMTOOLS} view -uS - | ${SAMTOOLS} sort -O BAM - > $(basename $fq .fq_trno_tagdusted.fq)_sorted.bam"
${BWA} samse ${GENOME_DIR}/${GENOME_FILE} $(basename $fq _trno_tagdusted_READ1.fq).sai $fq | ${SAMTOOLS} view -uS - | ${SAMTOOLS} sort -O BAM - > $(basename $fq _trno_tagdusted_READ1.fq)_sorted.bam

echo "samtools index -b $(basename $fq .fq_trno_tagdusted.fq)_sorted.bam "
${SAMTOOLS} index -b $(basename $fq .fq_trno_tagdusted.fq)_sorted.bam

#FILTERED_BAM=$(basename $fq _trno_tagdusted.fq)_filtered.bam
#.. post-alignment filtering for proper alignments and MAPQ >= 10:
#
echo "${SAMTOOLS} view -f 2 -q 10 -u ${SORTED_BAM} | ${SAMTOOLS} sort -O BAM -@ 10 - > $(basename $fq _trno_tagdusted.fq)_filtered.bam"
${SAMTOOLS} view -h -F 4 -q 10 -u $(basename $fq _trno_tagdusted_READ1.fq)_sorted.bam | ${SAMTOOLS} sort -O BAM -@ 8 - > $(basename $fq _trno_tagdusted_READ1.fq)_filtered.bam

echo "samtools index -b $(basename $fq .fq_trno_tagdusted.fq)_filtered.bam"
${SAMTOOLS} index -b $(basename $fq _trno_tagdusted_READ1.fq)_filtered.bam

done
