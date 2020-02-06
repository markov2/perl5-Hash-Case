# This code is part of distribution Hash::Case.  Meta-POD processed with
# OODoc into POD and HTML manual-pages.  See README.md
# Copyright Mark Overmeer.  Licensed under the same terms as Perl itself.

package Hash::Case::Upper;
use base 'Hash::Case';

use strict;
use warnings;
use Carp  qw(croak);

=chapter NAME

Hash::Case::Upper - native hash with enforced lower cased keys

=chapter SYNOPSIS

 use Hash::Case::Upper;
 tie my(%uchash), 'Hash::Case::Upper';
 $uchash{StraNGeKeY} = 3;
 print keys %uchash;  # STRANGEKEY

=chapter DESCRIPTION

Hash::Case::Upper extends M<Hash::Case>, which lets you play various
trics with hash keys. In this implementation, the fake hash is case
insensitive and the keys stored in upper-case.

=chapter METHODS

=section Constructors

=tie tie HASH, 'Hash::Case::Upper', [VALUES,] OPTIONS

Define HASH to have only upper cased keys.  The hash is
initialized with the VALUES, specified as ref-array or
ref-hash.  Currently, there are no OPTIONS defined.

=cut

sub init($)
{   my ($self, $args) = @_;

    $self->SUPER::native_init($args);

    croak "no options available for ". __PACKAGE__
        if keys %$args;

    $self;
}

sub FETCH($)  { $_[0]->{uc $_[1]} }
sub STORE($$) { $_[0]->{uc $_[1]} = $_[2] }
sub EXISTS($) { exists $_[0]->{uc $_[1]} }
sub DELETE($) { delete $_[0]->{uc $_[1]} }

1;
