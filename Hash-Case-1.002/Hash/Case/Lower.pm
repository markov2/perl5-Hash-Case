
package Hash::Case::Lower;
use base 'Hash::Case';

$VERSION = 1.002;

use strict;
use Carp;

=head1 NAME

Hash::Case::Lower - hash with enforced lower cased keys

=head1 CLASS HIERARCHY

 Hash::Case::Lower
 is a Hash::Case
 is a Tie::StdHash
 is a Tie::Hash

=head1 SYNOPSIS

 use Hash::Case::Lower;
 tie my(%lchash), 'Hash::Case::Lower';
 $lchash{StraNGeKeY} = 3;
 print keys %lchash;  # strangekey

=head1 DESCRIPTION

Hash::Case::Lower extends Hash::Case, which lets you play various trics
with hash keys.  See L<Hash::Case> for the other implementations.

=head1 METHODS

=over 4

=cut

#-------------------------------------------

=item tie HASH, 'Hash::Case::Lower', [VALUES,] OPTIONS

Define HASH to have only lower cased keys.  The hash is
initialized with the VALUES, specified as ref-array or
ref-hash.  Currently, there are no OPTIONS defined.

=cut

sub init($)
{   my ($self, $args) = @_;

    $self->SUPER::init($args);

    croak "No options defined for ".__PACKAGE__
        if keys %$args;

    $self;
}

#-------------------------------------------

sub FETCH($)  { $_[0]->{lc $_[1]} }
sub STORE($$) { $_[0]->{lc $_[1]} = $_[2] }
sub EXISTS($) { exists $_[0]->{lc $_[1]} }
sub DELETE($) { delete $_[0]->{lc $_[1]} }

#-------------------------------------------

=back

=head1 SEE ALSO

L<Hash::Case>
L<Hash::Case::Upper>
L<Hash::Case::Preserve>

=head1 AUTHOR

Mark Overmeer (F<mark@overmeer.net>).
All rights reserved.  This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=head1 VERSION

This code is beta, version 1.002

Copyright (c) 2002 Mark Overmeer. All rights reserved.
This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
