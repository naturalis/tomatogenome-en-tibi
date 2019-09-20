use utf8;
package Bio::EnTibi::Result::Refsite;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Bio::EnTibi::Result::Refsite

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<refsites>

=cut

__PACKAGE__->table("refsites");

=head1 ACCESSORS

=head2 chromosome

  data_type: 'integer'
  is_nullable: 0

=head2 position

  data_type: 'integer'
  is_nullable: 0

=head2 refallele

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "chromosome",
  { data_type => "integer", is_nullable => 0 },
  "position",
  { data_type => "integer", is_nullable => 0 },
  "refallele",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</chromosome>

=item * L</position>

=back

=cut

__PACKAGE__->set_primary_key("chromosome", "position");

=head1 RELATIONS

=head2 snps_accessions

Type: has_many

Related object: L<Bio::EnTibi::Result::Snp>

=cut

__PACKAGE__->has_many(
  "snps_accessions",
  "Bio::EnTibi::Result::Snp",
  { "foreign.accession" => "self.accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 snps_chromosomes

Type: has_many

Related object: L<Bio::EnTibi::Result::Snp>

=cut

__PACKAGE__->has_many(
  "snps_chromosomes",
  "Bio::EnTibi::Result::Snp",
  { "foreign.chromosome" => "self.chromosome" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 snps_positions

Type: has_many

Related object: L<Bio::EnTibi::Result::Snp>

=cut

__PACKAGE__->has_many(
  "snps_positions",
  "Bio::EnTibi::Result::Snp",
  { "foreign.position" => "self.position" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-09-20 12:02:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jGoPXeIXp2rKzxgNSM6mdA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
