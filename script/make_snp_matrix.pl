#!/usr/bin/perl
use strict;
use warnings;
use Bio::EnTibi;
use Getopt::Long;
use Bio::Phylo::Util::Logger ':simple';

=pod

Makes a character state matrix from the SNP database, only adding SNPs that aren't entirely
invariant across the 360 genomes.

=cut

# process command line arguments
my $db = $ENV{'HOME'} . '/Dropbox/documents/projects/dropbox-projects/tomatogenome-en-tibi/data/snps.db';
my $id = 'En-Tibi';
my $verbosity = WARN;
GetOptions(
	'db=s'     => \$db,
	'id=s'     => \$id,
	'verbose+' => \$verbosity,
);

# instantiate services
my $schema = Bio::EnTibi->connect("dbi:SQLite:$db");
Bio::Phylo::Util::Logger->new( '-level' => $verbosity, '-class' => 'main' );

# instantiate the table
my %table; # key: acc ID, value: ARRAY
my $accessions = $schema->resultset('Accession');
while( my $acc = $accessions->next ) {
	my $acc_id = $acc->accession;
	$table{$acc_id} = [];
}

# start collecting snps
my $refsites = $schema->resultset('Refsite');
my @snp_ids; # ordered list of IDs
while( my $site = $refsites->next ) {

	# only interested in snps that are variant, i.e. have more than just En Tibi
	my ( $pos, $chromo ) = ( $site->position, $site->chromosome );
	my @snps = $schema->resultset('Snp')->search({ 'chromosome' => $chromo, 'position' => $pos })->all;
	DEBUG "C$chromo:$pos";
	if ( @snps > 1 ) {

		# generate snp ID, populate default values for everyone
		push @snp_ids, "snp.${chromo}.${pos}";
		push @{ $_ }, 0 for values %table;
		INFO "Adding SNP " . $snp_ids[-1] . ' with ' . scalar(@snps) . ' carriers';

		# replace default value with observed, where applicable
		for my $snp ( @snps ) {
			my $acc = $snp->{_column_data}->{accession};
			$table{$acc}->[-1] = 1;
		}
	}
}

# write table
print join("\t", 'snp', sort { $a cmp $b } keys %table ), "\n";
my $i = 0;
for my $snp ( @snp_ids ) {
	my @values = map { $table{$_}->[$i] } sort { $a cmp $b } keys %table;
	print join( "\t", $snp, @values ), "\n";
	$i++;
}