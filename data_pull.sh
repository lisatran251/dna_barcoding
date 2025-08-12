# Replace with your SRP ID
PROJECT_ID=PRJNA857875

# Get metadata
esearch -db sra -query $PROJECT_ID | efetch -format runinfo > runinfo.csv

# Extract SRR IDs
cut -d',' -f1 runinfo.csv | grep SRR > srr_list.txt

# Download and convert
cat srr_list.txt | xargs -n 1 prefetch
cat srr_list.txt | xargs -n 1 fasterq-dump --split-files --threads 4

mkdir data
gzip *.fastq
mv *fastq.gz data