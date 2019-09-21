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

=head2 refsite_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 chromosome

  data_type: 'integer'
  is_nullable: 0

=head2 position

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "refsite_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "chromosome",
  { data_type => "integer", is_nullable => 0 },
  "position",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</refsite_id>

=back

=cut

__PACKAGE__->set_primary_key("refsite_id");

=head1 RELATIONS

=head2 snps

Type: has_many

Related object: L<Bio::EnTibi::Result::Snp>

=cut

__PACKAGE__->has_many(
  "snps",
  "Bio::EnTibi::Result::Snp",
  { "foreign.refsite_id" => "self.refsite_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-09-21 12:36:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AUW8Zr6pCtK67+SnsQ9kGA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
