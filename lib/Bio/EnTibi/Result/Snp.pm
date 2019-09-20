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

=head2 chromosome

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 position

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 altallele

  data_type: 'text'
  is_nullable: 0

=head2 accession

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "chromosome",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "position",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "altallele",
  { data_type => "text", is_nullable => 0 },
  "accession",
  { data_type => "text", is_foreign_key => 1, is_nullable => 1 },
);

=head1 RELATIONS

=head2 accession

Type: belongs_to

Related object: L<Bio::EnTibi::Result::Refsite>

=cut

__PACKAGE__->belongs_to(
  "accession",
  "Bio::EnTibi::Result::Refsite",
  { accession => "accession" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 chromosome

Type: belongs_to

Related object: L<Bio::EnTibi::Result::Refsite>

=cut

__PACKAGE__->belongs_to(
  "chromosome",
  "Bio::EnTibi::Result::Refsite",
  { chromosome => "chromosome" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 position

Type: belongs_to

Related object: L<Bio::EnTibi::Result::Refsite>

=cut

__PACKAGE__->belongs_to(
  "position",
  "Bio::EnTibi::Result::Refsite",
  { position => "position" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-09-20 12:02:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XVEyZmZtGbP48REU6/WgrA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
