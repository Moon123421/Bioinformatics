
Fasta_upper () 
{
	if [ $# -ne 1 ];then
		Help
		return 1
	fi
	local fasta=$1
	zless ${fasta} | awk '{if(index($A,">")!=0) print "\n"$A; else printf toupper($AF)}' | sed -n '1~!'p
}
Gap_check ()
{
	if [ $# -ne 1 ];then
		Help
		return 1
	fi
	local fasta=$1
	Fasta_upper ${fasta} | grep -v '>' |  sed -e 's/[ATGC]N/\nN/g' -e 's/N[ATGC]/N\n/g' | grep N |  awk '{sum+=length($1)}{count+=1} END{print "Sum\tCount\tAverage"}END{print sum"\t"count"\t"sum/count}'
}
Parsing_blast_txt ()
{
	if [ $# -ne 1 ];then
		Help
		return 1
	fi
	local txt=$1
	cat ${txt} | grep '^  <Iteration' -A 1 --no-group-separator | grep '<Hit_def>' | awk '{print $1,$2,$3,$4}' | sort | uniq -c | sort -rnk 1 | sed 's/<Hit_def>//g'
}
Fasta_length ()
{
	if [ $# -ne 1 ];then
		Help
		return 1
	fi	
	local fasta=$1
	zless ${fasta} | awk '{if(index($1,">")!=0) printf "\t"sum"\n"$1,sum=0 ; else sum+=length($1)} END{print "\t"sum}' | sed '/^\t$/d'
}
Fasta_rename ()
{
	if [ $# -ne 1 ];then
		Help
		return 1 
	fi
	local fasta=$1
	zless ${fasta} | awk 'BEGAN{Num==1}{if(index($AF,">")!=0){Num++ ; print ">contig"Num}else print }'
}
Extract_fasta ()
{
	if [ $# -ne 4 ];then
		Help
		return 1
	fi
	local fasta=$1
	local contig=$2
	local start=$3
	local end=$4
	Fasta_upper ${fasta} | grep --no-group-separator -A 1 ${contig} | head -n 2 | grep -v '>' | cut -c ${start}-${end}
}
Help ()
{
	echo "PATH ::: /*/Users/moonyt91/Bash_Functions/Bash_Functions.sh"
	echo -e "\e[32mUSAGE\e[0m"
	echo -e "\e[31m-list of function-\e[0m"
	echo "Fasta_upper [fasta/fasta.gz]"
	echo "Gap_check [fasta/fasta.gz]"
	echo "Parsing_blast_txt [*_nt_blast.txt]"
	echo "Fasta_length [fasta/fasta.gz]"
	echo "Fasta_rename [fasta/fasta.gz]"
	echo "Extract_fasta [fasta] [contig] [start] [end] --- 1-based"
}
