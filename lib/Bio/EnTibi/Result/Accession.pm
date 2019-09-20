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

=head2 accession

  data_type: 'text'
  is_nullable: 0

=head2 variety

  data_type: 'text'
  is_nullable: 1

=head2 category

  data_type: 'text'
  is_nullable: 1

=head2 origin

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
  "accession",
  { data_type => "text", is_nullable => 0 },
  "variety",
  { data_type => "text", is_nullable => 1 },
  "category",
  { data_type => "text", is_nullable => 1 },
  "origin",
  { data_type => "text", is_nullable => 1 },
  "latitude",
  { data_type => "real", is_nullable => 1 },
  "longitude",
  { data_type => "real", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</accession>

=back

=cut

__PACKAGE__->set_primary_key("accession");


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-09-20 12:02:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JJIEjUgzAisIY0uBX7MHlA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
