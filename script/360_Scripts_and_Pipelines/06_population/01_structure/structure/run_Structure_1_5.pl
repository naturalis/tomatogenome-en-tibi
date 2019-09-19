#!/usr/bin/perl

die  "perl $0  <add_ref_list> <individual> <snp_number> <run>\n" unless ($#ARGV==2);

my $add_ref_list=shift;
my $individual=shift;
my $snp_number=shift;

$run ||=1;
$snp_number ||=1000;

my $USePosition= "all.snp" ;

my $OutDir=`pwd`;
chomp $OutDir;



my $BinDir="/ifs1/ST_PLANT/USER/zengpeng/Cucumber_final/04_final_snp/Structure/bin";


#`perl $BinDir/all_cov.pl   $add_ref_list  $USePosition`;

for (my $i=1;$i<=5;$i++){
	my  $out_Dir="$OutDir/structure_$i";
	mkdir  $out_Dir unless (-d $out_Dir);
	`cd $out_Dir\n`;
	`perl $BinDir/rand_small_position.pl $OutDir/$USePosition  $out_Dir/$USePosition  $snp_number`;
#	`rm $out_Dir/$USePosition`;
#	`ln -s $OutDir/$USePosition  $out_Dir/$USePosition`;
	my  $location_num=`wc -l $out_Dir/$USePosition  | cut  -f 1 -d " " | tr -d '\n' `;
	my $sample_num=`wc -l $individual | cut  -f 1 -d " " | tr -d '\n'`;

	`perl $BinDir/get_structure_input.pl     $out_Dir/$USePosition  $individual $out_Dir/Input.file`;
	`perl  $BinDir/new_mainparams.pl    -output  $out_Dir    -input  $BinDir   -loca   $location_num   -sample $sample_num`;
	`sh   $BinDir/Start.sh     $out_Dir  $i   `;
	`cd $OutDir`;
}
