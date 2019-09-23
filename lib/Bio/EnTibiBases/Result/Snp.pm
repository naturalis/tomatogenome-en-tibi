use utf8;
package Bio::EnTibiBases::Result::Snp;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Bio::EnTibiBases::Result::Snp

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

=head2 altallele_hom

  data_type: 'text'
  is_nullable: 0

=head2 altallele_het

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "snp_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "refsite_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "accession_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "altallele_hom",
  { data_type => "text", is_nullable => 0 },
  "altallele_het",
  { data_type => "text", is_nullable => 0 },
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

Related object: L<Bio::EnTibiBases::Result::Accession>

=cut

__PACKAGE__->belongs_to(
  "accession",
  "Bio::EnTibiBases::Result::Accession",
  { accession_id => "accession_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 refsite

Type: belongs_to

Related object: L<Bio::EnTibiBases::Result::Refsite>

=cut

__PACKAGE__->belongs_to(
  "refsite",
  "Bio::EnTibiBases::Result::Refsite",
  { refsite_id => "refsite_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-09-23 14:45:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:X+2j/Epo2Fs07rAxAFpXsg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
