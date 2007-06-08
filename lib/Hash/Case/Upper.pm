
package Hash::Case::Upper;
use base 'Hash::Case';

use Carp;
use strict;

=chapter NAME

Hash::Case::Upper - native hash with enforced lower cased keys

=chapter SYNOPSIS

 use Hash::Case::Upper;
 tie my(%uchash), 'Hash::Case::Upper';
 $uchash{StraNGeKeY} = 3;
 print keys %uchash;  # STRANGEKEY

=chapter DESCRIPTION

C<Hash::Case::Upper> extends M<Hash::Case>, which lets you play various trics
with hash keys.  See M<Hash::Case> for the other implementations.

=chapter METHODS

=tie tie HASH, 'Hash::Case::Upper', [VALUES,] OPTIONS

Define HASH to have only upper cased keys.  The hash is
initialized with the VALUES, specified as ref-array or
ref-hash.  Currently, there are no OPTIONS defined.

=cut

sub init($)
{   my ($self, $args) = @_;

    $self->SUPER::native_init($args);

    croak "No options available for ".__PACKAGE__
        if keys %$args;

    $self;
}

sub FETCH($)  { $_[0]->{uc $_[1]} }
sub STORE($$) { $_[0]->{uc $_[1]} = $_[2] }
sub EXISTS($) { exists $_[0]->{uc $_[1]} }
sub DELETE($) { delete $_[0]->{uc $_[1]} }

1;
