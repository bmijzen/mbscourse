#create script that reads from a folder of BAM files, and creates a folder with BigWig files

# create conda env
source /scratch/bmijzen_B/mamba/etc/profile.d/conda.sh
conda create -n bam2bigwig deeptools samtools --yes
conda activate bam2bigwig

#create variables in and ouput dir
output_dir=$2
mkdir -p  $output_dir
cd $output_dir
input_dir=$1
cp -r $input_dir/* $output_dir
input_files=$(ls *.bam)

#convert all bam files into bigwig using sam and deeptools

for input in ${input_files[@]}; do
	nosuff=${input%.*}
	output=$output_dir/$(basename $nosuff).bw
	nice samtools index -b $input
	nice bamCoverage -b $input -o $output \
	>> log.txt 2>&1
	echo $input >> log.txt
	rm $input.bai
	rm $input
done
Echo Barend Mijzen
