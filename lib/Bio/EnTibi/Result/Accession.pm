use utf8;
package Bio::EnTibi::Result::Accession;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Bio::EnTibi::Result::Accession

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<accessions>

=cut

__PACKAGE__->table("accessions");

=head1 ACCESSORS

=head2 accession_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 label

  data_type: 'text'
  is_nullable: 1

=head2 botanical_variety

  data_type: 'text'
  is_nullable: 1

=head2 status

  data_type: 'text'
  is_nullable: 1

=head2 country

  data_type: 'text'
  is_nullable: 1

=head2 latitude

  data_type: 'real'
  is_nullable: 1

=head2 longitude

  data_type: 'real'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "accession_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "label",
  { data_type => "text", is_nullable => 1 },
  "botanical_variety",
  { data_type => "text", is_nullable => 1 },
  "status",
  { data_type => "text", is_nullable => 1 },
  "country",
  { data_type => "text", is_nullable => 1 },
  "latitude",
  { data_type => "real", is_nullable => 1 },
  "longitude",
  { data_type => "real", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</accession_id>

=back

=cut

__PACKAGE__->set_primary_key("accession_id");

=head1 RELATIONS

=head2 snps

Type: has_many

Related object: L<Bio::EnTibi::Result::Snp>

=cut

__PACKAGE__->has_many(
  "snps",
  "Bio::EnTibi::Result::Snp",
  { "foreign.accession_id" => "self.accession_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-09-21 12:36:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CUR1gWDHd+J2lmzIG+2dcw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
