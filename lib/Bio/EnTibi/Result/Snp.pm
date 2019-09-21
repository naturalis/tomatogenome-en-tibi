use utf8;
package Bio::EnTibi::Result::Snp;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Bio::EnTibi::Result::Snp

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<snps>

=cut

__PACKAGE__->table("snps");

=head1 ACCESSORS

=head2 snp_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 refsite_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 accession_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 altallele

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "snp_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "refsite_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "accession_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "altallele",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</snp_id>

=back

=cut

__PACKAGE__->set_primary_key("snp_id");

=head1 RELATIONS

=head2 accession

Type: belongs_to

Related object: L<Bio::EnTibi::Result::Accession>

=cut

__PACKAGE__->belongs_to(
  "accession",
  "Bio::EnTibi::Result::Accession",
  { accession_id => "accession_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 refsite

Type: belongs_to

Related object: L<Bio::EnTibi::Result::Refsite>

=cut

__PACKAGE__->belongs_to(
  "refsite",
  "Bio::EnTibi::Result::Refsite",
  { refsite_id => "refsite_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-09-21 12:36:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kR+t4iCLs0y3bXDG7nUn6A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
