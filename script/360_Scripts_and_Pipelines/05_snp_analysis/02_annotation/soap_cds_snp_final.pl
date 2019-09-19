#!/usr/bin/perl

=head1 Name

yanhuang_soap_cds_snp_final.pl  -- caculate synonymous and nonsynonymous SNP rate

=head1 Description

read the cds.gff, snp.tab, hs.fa file, generate yanhuang cds file, and the snp information file.

=head1 Version

  Author: Fan Wei, fanw@genomics.org.cn
  Version: 1.0,  Date: 2006-12-6
  Note:modify for rice only

=head1 Usage

  --verbose   output running progress information to screen  
  --help      output help information to screen  

=head1 Exmple

  perl ../bin/yanhuang_soap_cds_snp.pl ./yanhuang_soap.snp.chr22 ./refGene.txt.filter.gff.nr.gff.correct.gff.chr22  ./chr22.fa 

=cut

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname); 
use Data::Dumper;
use File::Path;  ## function " mkpath" and "rmtree" deal with directory

##get options from command line into variables and set default values
my ($Verbose,$Help,$Outdir);
GetOptions(
    "outdir:s"=>\$Outdir,
    "verbose"=>\$Verbose,
    "help"=>\$Help
);
$Outdir ||= "./";
die `pod2text $0` if (@ARGV == 0 || $Help);

my $snp_file = shift;
my $refGene_file = shift;
my $hs_file = shift;


$Outdir =~ s/\/$//;
my $snp_file_basename = basename($snp_file);
my $output_info_file = "$Outdir/$snp_file_basename.info";
#my $output_ref_cds_file = "$Outdir/$snp_file_basename.ref.cds";
my $output_yh_cds_file = "$Outdir/$snp_file_basename.cds";
my $output_axt_file = "$Outdir/$snp_file_basename.axt";

my %SNP; ##store SNP data
my %CDS; ##store gene data
my %iupac = (
    "M" => "AC",
    "R" => "AG",
    "W" => "AT",
    "Y" => "CT",
    "S" => "CG",
    "K" => "GT",
    "-" => "--",
    "A" => "AA",
    "T" => "TT",
    "G" => "GG",
    "C" => "CC",
    "N" => "NN",
);


my %CODE = (
    'GCA' => 'A', 'GCC' => 'A', 'GCG' => 'A', 'GCT' => 'A',                               # Alanine
    'TGC' => 'C', 'TGT' => 'C',                                                           # Cysteine
    'GAC' => 'D', 'GAT' => 'D',                                                           # Aspartic Acid
    'GAA' => 'E', 'GAG' => 'E',                                                           # Glutamic Acid
    'TTC' => 'F', 'TTT' => 'F',                                                           # Phenylalanine
    'GGA' => 'G', 'GGC' => 'G', 'GGG' => 'G', 'GGT' => 'G',                               # Glycine
    'CAC' => 'H', 'CAT' => 'H',                                                           # Histidine
    'ATA' => 'I', 'ATC' => 'I', 'ATT' => 'I',                                             # Isoleucine
    'AAA' => 'K', 'AAG' => 'K',                                                           # Lysine
    'CTA' => 'L', 'CTC' => 'L', 'CTG' => 'L', 'CTT' => 'L', 'TTA' => 'L', 'TTG' => 'L',   # Leucine
    'ATG' => 'M',                                                                         # Methionine
    'AAC' => 'N', 'AAT' => 'N',                                                           # Asparagine
    'CCA' => 'P', 'CCC' => 'P', 'CCG' => 'P', 'CCT' => 'P',                               # Proline
    'CAA' => 'Q', 'CAG' => 'Q',                                                           # Glutamine
    'CGA' => 'R', 'CGC' => 'R', 'CGG' => 'R', 'CGT' => 'R', 'AGA' => 'R', 'AGG' => 'R',   # Arginine
    'TCA' => 'S', 'TCC' => 'S', 'TCG' => 'S', 'TCT' => 'S', 'AGC' => 'S', 'AGT' => 'S',   # Serine
    'ACA' => 'T', 'ACC' => 'T', 'ACG' => 'T', 'ACT' => 'T',                               # Threonine
    'GTA' => 'V', 'GTC' => 'V', 'GTG' => 'V', 'GTT' => 'V',                               # Valine
    'TGG' => 'W',                                                                         # Tryptophan
    'TAC' => 'Y', 'TAT' => 'Y',                                                           # Tyrosine
    'TAA' => 'U', 'TAG' => 'U', 'TGA' => 'U'                                              # Stop
);

my %Abbrev = (
    'A' => [ 'A' ],
    'C' => [ 'C' ],
    'G' => [ 'G' ],
    'T' => [ 'T' ],
    'M' => [ 'A', 'C' ],
    'R' => [ 'A', 'G' ],
    'W' => [ 'A', 'T' ],
    'S' => [ 'C', 'G' ],
    'Y' => [ 'C', 'T' ],
    'K' => [ 'G', 'T' ],
    'V' => [ 'A', 'C', 'G' ],
    'H' => [ 'A', 'C', 'T' ],
    'D' => [ 'A', 'G', 'T' ],
    'B' => [ 'C', 'G', 'T' ],
    'X' => [ 'A', 'C', 'G', 'T' ],  
    'N' => [ 'A', 'C', 'G', 'T' ]
);

## chromosome01    51      T       4543    3.453115        T       A       49      1       3       16.68   1587    3285 
my %capui = ("AC","M", "CA","M", "GT","K", "TG","K", "CT","Y", "TC","Y", "AG","R", "GA","R", "AT","W", "TA","W", "CG","S", "GC","S");
open(IN,$snp_file) || die "can't open the $snp_file\n";
while(<IN>){
    chomp;
    my @temp=split;
    my $chr = $temp[0];
    my $pos = $temp[1];
    my $ref_type = $temp[2];
    #my $yh_type = $capui{"$temp[5]$temp[8]"};

    my $genotype=join(" ",@temp[2..$#temp]);
    my @tmp = split(/\s+/,$genotype);
    my @trans = map {$iupac{$_}} @tmp;
    my $line = join("", @trans);
    my %count = ("A", 0, "T", 0, "G", 0, "C", 0,);
    $count{"A"} = $line=~ s/A/A/g;
    $count{"T"} = $line=~ s/T/T/g;
    $count{"G"} = $line=~ s/G/G/g;
    $count{"C"} = $line=~ s/C/C/g;
    my  @key_sort = sort { $count{$b} <=> $count{$a} } keys %count;
    my $aa="$key_sort[0]$key_sort[1]";
    my $yh_type = $capui{"$aa"};
#   print"$temp[5] $temp[6] $yh_type\n";
    $SNP{$chr}{$pos} = [$ref_type,$yh_type];
}
close(IN);

warn "read snp_file done" if($Verbose);
#print Dumper \%SNP;

# chr1    mRNA    rep_CDS 177642  179462  .       +       0       seq_id "AK070557";locus_id "Os01g0103100"
open(REF,$refGene_file) || die"can't open the $refGene_file\n";
while(<REF>){
    chomp;
    my @temp=split(/\t/);
    # my $chr_tem=$temp[0];
    # my $num = $1 if($chr_tem=~/(\d+)/);
    #    print "@temp\n";exit;
    my $chr=$temp[0];
#        if($num<10){$chr="Gm$num";}
    #       else{$chr="Gm$num";}
    my $type=$temp[2];
    my $start=$temp[3];
    my $end=$temp[4];
    my $strand=$temp[6];

    next unless ($type =~ "CDS");
    my $ID;
    # $ID = "Glyma".$1 if ($temp[8]=~/Glyma(\S+)\.(\d)\;/);

    $ID = $1 if ($temp[8]=~/Parent=(\S+)\;/);
#        if ($temp[11] =~ /GenePrediction/){


#               $ID = $1 if ($temp[8]=~/Glyma"(\S+)"\;/);
    #              $ID = $1 if ($temp[8]=~/ID="(\S+)"\;/);
    #     print "$ID\t$chr\t$type\t$start\t$end\t\n";exit;
    # }
    #else{
    #       $ID = $1 if ($temp[8]=~/Glyma"(\S+)"\./);
    #print "$ID\t$chr\t$type\t$start\t$end\t\n";exit;

    # }
    push @{$CDS{$chr}{$ID}}, [$start,$end,$strand];
    #print "{$CDS{$chr}{$ID}}\n";exit;
}
close(REF);

warn "read refGene done" if($Verbose);
##print Dumper \%CDS;


open INFO, ">".$output_info_file || die "fail $output_info_file";
#open REFCDS, ">".$output_ref_cds_file || die "fail $output_ref_cds_file";
open YHCDS, ">".$output_yh_cds_file || die "fail $output_yh_cds_file";
open AXT, ">".$output_axt_file || die "fail $output_axt_file";
#  print INFO  "chr_id\tposition\tref_base<->soy_base\tsnp_status\tstrand\tAnnotation_type\tGene_id\tFeature_type\tcodon_phase\tcodon_mutate\taa_mutate\tsynonymous\tnonsynonymous\n";
##read human genome file, we must first get correct codon
##the phase method can't work near the splicing site
##the input must be correct gene models
open(IN, $hs_file) || die ("can not open $hs_file\n");
$/=">"; <IN>; $/="\n";
while (<IN>) {
    my $chr = $1 if(/^(\S+)/);
    $/=">";
    my $seq = <IN>;
    chomp $seq;
    $seq=~s/\s//g;
    $seq=~s/\n//g;
    $seq = uc($seq); ## all upper case
    $/="\n";

    warn "read hs $chr done" if($Verbose);

    next if(!exists $SNP{$chr} || !exists $CDS{$chr});

    my $chr_snp_p = $SNP{$chr};
    my $chr_cds_p = $CDS{$chr};

    my ($output_info,$output_refcds,$output_yhcds,$output_axt);

    foreach my $gene_id (keys %$chr_cds_p) {
        my $gene_p = $chr_cds_p->{$gene_id};
        my $strand = $gene_p->[0][2];
        my $gene_cds_str;
        my $gene_cds_len = 0;
        my $mRNA_pos = 1;
        my $is_cds_mutated = 0;
        my $ref_cds_str;
        my $axt_cds_str; ##if meet het-two SNP, only keep one by random

        ##先把完整的cds序列做出来，都整成在正链上的形式（如在负链，则取反向互补）
        if ($strand eq "+")
        {
            for (my $i=0; $i<@$gene_p; $i++) { ##loop for each exon
                my $cds_p = $gene_p->[$i];
                $gene_cds_str .= substr($seq,$cds_p->[0]-1,$cds_p->[1]-$cds_p->[0]+1);
            }
        }   
        elsif ($strand eq "-")
        {
            for (my $i=@$gene_p-1; $i >= 0; $i--)
            {
                my $cds_p = $gene_p->[$i];
                $gene_cds_str .= substr($seq,$cds_p->[0]-1,$cds_p->[1]-$cds_p->[0]+1);
            }
        }
        $gene_cds_len = length($gene_cds_str);
        Complement_Reverse(\$gene_cds_str) if ($strand eq "-");
        $ref_cds_str = $gene_cds_str;
        $axt_cds_str = $gene_cds_str;
        if ($strand eq "+")
        {
            for (my $i=0; $i<@$gene_p; $i++) { ##loop for each exon
                my $cds_p = $gene_p->[$i];
                for (my $j=$cds_p->[0]; $j<=$cds_p->[1]; $j++) { ##loop for each base
                    if (exists $chr_snp_p->{$j}) {
                        $is_cds_mutated = 1;
                        my $ref_base = substr($seq,$j-1,1);
                        warn "ref_base error on $chr:$j, please check: $ref_base $chr_snp_p->{$j}[0]" if($ref_base ne $chr_snp_p->{$j}[0]);

                        ##都先转换成正链形式然后再进行计算
                        my $yh_base = $chr_snp_p->{$j}[1];
                        my $yh_base_minus = $yh_base;
                        $yh_base_minus =~ tr/AGCTagctMRWSYK/TCGAtcgaKYWSRM/;
                        my $ref_base_minus = $ref_base;
                        $ref_base_minus =~ tr/AGCTagctMRWSYK/TCGAtcgaKYWSRM/;
                        my $this_mRNA_pos = ($strand eq "+") ? $mRNA_pos : ($gene_cds_len - $mRNA_pos + 1);
                        my $this_yh_base = ($strand eq "+") ? $yh_base : $yh_base_minus;
                        my $this_ref_base = ($strand eq "+") ? $ref_base : $ref_base_minus;

                        substr($gene_cds_str,$this_mRNA_pos-1,1) = $this_yh_base;
#print"this_yh_base: $this_yh_base";exit;
                        substr($axt_cds_str,$this_mRNA_pos-1,1) = different_base($this_ref_base,$this_yh_base);
                        my $snp_status = hom_het($ref_base,$yh_base);

                        ##chr10   104221044    A<->R   Het-one + Gene    NM_024789        CDS    729:2       GTA<->GTG;      V<->V;  0.5     0
                        $output_info .= "$chr\t$j\t$ref_base<->$yh_base\t$snp_status\t$strand\tGene\t";

                        my ($codon_num,$phase_num) = codon_phase($this_mRNA_pos);
                        my $codon_phase_str = "$this_mRNA_pos:$phase_num";
                        my $ref_codon = substr($ref_cds_str,$this_mRNA_pos-$phase_num-1,3);
                        my $yh_codon = substr($gene_cds_str,$this_mRNA_pos-$phase_num-1,3);

                        warn "$yh_codon has N, please check\n" if($yh_codon =~ /N/);

                        ##get the yanhuang two codons
                        my ($yh_codon1,$yh_codon2);
                        ($yh_codon1,$yh_codon2)= convert_codon($yh_codon,$ref_codon,$phase_num) if($snp_status =~ /Het/);
                        $yh_codon1 = $yh_codon2 = $yh_codon if($snp_status =~ /Hom/);

                        ##caculate the synonymous and nonsynonymous SNP number
                        my ($synonymous,$nonsynonymous) = (0,0);
                        my ($codon_mutate_str,$aa_mutate_str);
                        if ($ref_codon ne $yh_codon1) {
                            if ($CODE{$ref_codon} eq $CODE{$yh_codon1}) {
                                $synonymous += 0.5;
                            }else{
                                $nonsynonymous += 0.5;
                            }
                            $codon_mutate_str .= "$ref_codon<->$yh_codon1;";
                            $aa_mutate_str .= "$CODE{$ref_codon}<->$CODE{$yh_codon1};";
                        }
                        if ($ref_codon ne $yh_codon2) {
                            if ($CODE{$ref_codon} eq $CODE{$yh_codon2}) {
                                $synonymous += 0.5;
                            }else{
                                $nonsynonymous += 0.5;
                            }
                            $codon_mutate_str .= "$ref_codon<->$yh_codon2;" if($yh_codon2 ne $yh_codon1);
                            $aa_mutate_str .= "$CODE{$ref_codon}<->$CODE{$yh_codon2};" if($yh_codon2 ne $yh_codon1);
                        }

                        $output_info .= "$gene_id\tCDS\t$codon_phase_str\t$codon_mutate_str\t$aa_mutate_str\t$synonymous\t$nonsynonymous\n";
                    }

                    $mRNA_pos++; ##postion on strand + 
                }			
            }
        }
        elsif ($strand eq "-")
        {
            for (my $i= @$gene_p -1; $i >= 0; $i--) {
#		for (my $i=0; $i<@$gene_p; $i++) { ##loop for each exon
                my $cds_p = $gene_p->[$i];
                for (my $j=$cds_p->[0]; $j<=$cds_p->[1]; $j++) { ##loop for each base
                    if (exists $chr_snp_p->{$j}) {
                        $is_cds_mutated = 1;
                        my $ref_base = substr($seq,$j-1,1);
                        warn "ref_base error on $chr:$j, please check: $ref_base $chr_snp_p->{$j}[0]" if($ref_base ne $chr_snp_p->{$j}[0]);

                        ##都先转换成正链形式然后再进行计算
                        my $yh_base = $chr_snp_p->{$j}[1];
                        my $yh_base_minus = $yh_base;
                        $yh_base_minus =~ tr/AGCTagctMRWSYK/TCGAtcgaKYWSRM/;
                        my $ref_base_minus = $ref_base;
                        $ref_base_minus =~ tr/AGCTagctMRWSYK/TCGAtcgaKYWSRM/;
                        my $this_mRNA_pos = ($strand eq "+") ? $mRNA_pos : ($gene_cds_len - $mRNA_pos + 1);
                        my $this_yh_base = ($strand eq "+") ? $yh_base : $yh_base_minus;
                        my $this_ref_base = ($strand eq "+") ? $ref_base : $ref_base_minus;

                        substr($gene_cds_str,$this_mRNA_pos-1,1) = $this_yh_base;
#print"this_yh_base: $this_yh_base";exit;
                        substr($axt_cds_str,$this_mRNA_pos-1,1) = different_base($this_ref_base,$this_yh_base);
                        my $snp_status = hom_het($ref_base,$yh_base);

                        ##chr10   104221044    A<->R   Het-one + Gene    NM_024789        CDS    729:2       GTA<->GTG;      V<->V;  0.5     0
                        $output_info .= "$chr\t$j\t$ref_base<->$yh_base\t$snp_status\t$strand\tGene\t";

                        my ($codon_num,$phase_num) = codon_phase($this_mRNA_pos);
                        my $codon_phase_str = "$this_mRNA_pos:$phase_num";
                        my $ref_codon = substr($ref_cds_str,$this_mRNA_pos-$phase_num-1,3);
                        my $yh_codon = substr($gene_cds_str,$this_mRNA_pos-$phase_num-1,3);

                        warn "$yh_codon has N, please check\n" if($yh_codon =~ /N/);

                        ##get the yanhuang two codons
                        my ($yh_codon1,$yh_codon2);
                        ($yh_codon1,$yh_codon2)= convert_codon($yh_codon,$ref_codon,$phase_num) if($snp_status =~ /Het/);
                        $yh_codon1 = $yh_codon2 = $yh_codon if($snp_status =~ /Hom/);

                        ##caculate the synonymous and nonsynonymous SNP number
                        my ($synonymous,$nonsynonymous) = (0,0);
                        my ($codon_mutate_str,$aa_mutate_str);
                        if ($ref_codon ne $yh_codon1) {
                            if ($CODE{$ref_codon} eq $CODE{$yh_codon1}) {
                                $synonymous += 0.5;
                            }else{
                                $nonsynonymous += 0.5;
                            }
                            $codon_mutate_str .= "$ref_codon<->$yh_codon1;";
                            $aa_mutate_str .= "$CODE{$ref_codon}<->$CODE{$yh_codon1};";
                        }
                        if ($ref_codon ne $yh_codon2) {
                            if ($CODE{$ref_codon} eq $CODE{$yh_codon2}) {
                                $synonymous += 0.5;
                            }else{
                                $nonsynonymous += 0.5;
                            }
                            $codon_mutate_str .= "$ref_codon<->$yh_codon2;" if($yh_codon2 ne $yh_codon1);
                            $aa_mutate_str .= "$CODE{$ref_codon}<->$CODE{$yh_codon2};" if($yh_codon2 ne $yh_codon1);
                        }

                        $output_info .= "$gene_id\tCDS\t$codon_phase_str\t$codon_mutate_str\t$aa_mutate_str\t$synonymous\t$nonsynonymous\n";
                    }
                    $mRNA_pos++; ##postion on strand + 
                }			
            }
        }
        ##在输出结果中取消了is_matated判断，将全部基因都输出
        $output_axt .="$gene_id\_ref&$gene_id\_soy\n".$ref_cds_str."\n".$axt_cds_str."\n\n" ;

        Display_seq(\$ref_cds_str);
#		$output_refcds .= ">$gene_id\n".$ref_cds_str;

        Display_seq(\$gene_cds_str);
        $output_yhcds .= ">$gene_id\n".$gene_cds_str;
        ##warn "SNP caculation for $gene_id done" if($Verbose);
    }

    warn "SNP caculation for $chr done" if($Verbose);
    print INFO $output_info;
#	print REFCDS $output_refcds;
    print YHCDS $output_yhcds;
    print AXT $output_axt;

}
close(IN);


close INFO;
#close REFCDS;
close YHCDS;
close AXT;

##convert complex codon into explict codons
#############################################
sub convert_codon{
    my $codon = shift;
    my $ref_codon = shift;
    my $phase = shift;
    my @all;

    my $base = substr($codon,$phase,1);
    foreach my $replace (@{$Abbrev{$base}}) {
        my $new_codon = $ref_codon;
        substr($new_codon,$phase,1) = $replace;
        push @all,$new_codon;
    }

    return @all;
}



##caculate codon and phase
#############################################
sub codon_phase {
    my $pos = shift;

    my $phase = ($pos-1)%3;
    my $codon = ($pos-1-$phase)/3 + 1;

    ##print "$codon,$phase,,\n";
    return ($codon,$phase);

}



sub different_base {
    my ($ref,$yh) = @_;
    my $base;
#print"$yh";exit;
    if ($yh =~ /[ACGT]/) {
        $base = $yh;
    }elsif($yh =~ /[MRWSYK]/){
        $base = $Abbrev{$yh}[0] if($Abbrev{$yh}[0] ne $ref);
        $base = $Abbrev{$yh}[1] if($Abbrev{$yh}[1] ne $ref);

    }else{
#print"$yh";exit;
        die "different_base unknown complex character, please check the snp data";
    }
    ##print "$ref,$yh,$base;\n";
    return $base;
}

##get the status of a snp
#############################################
sub hom_het {
    my ($ref,$yh) = @_;

    return "same" if($ref eq $yh);

    my $status;


    if ($yh =~ /[ACGT]/) {
        $status = "Hom";
    }elsif($yh =~ /[MRWSYK]/){
        if ($Abbrev{$yh}[0] ne $ref && $Abbrev{$yh}[1] ne $ref) {
            $status = "Het-two";
        }else{
            $status = "Het-one";
        }
    }else{
        die "hom_het unknown complex character, please check the snp data";
    }

    return $status;
}

#display a sequence in specified number on each line
#usage: disp_seq(\$string,$num_line);
#		disp_seq(\$string);
#############################################
sub Display_seq{
    my $seq_p=shift;
    my $num_line=(@_) ? shift : 50; ##set the number of charcters in each line
    my $disp;

    $$seq_p =~ s/\s//g;
    for (my $i=0; $i<length($$seq_p); $i+=$num_line) {
        $disp .= substr($$seq_p,$i,$num_line)."\n";
    }
    $$seq_p = ($disp) ?  $disp : "\n";
}
#############################################


##complement and reverse the given sequence
#usage: Complement_Reverse(\$seq);
#############################################
sub Complement_Reverse{
    my $seq_p=shift;
    if (ref($seq_p) eq 'SCALAR') { ##deal with sequence
        $$seq_p=~tr/AGCTagctMRWSYK/TCGAtcgaKYWSRM/;
        $$seq_p=reverse($$seq_p);  
    }
}
#############################################

