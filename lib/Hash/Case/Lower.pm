package Hash::Case::Lower;
use base 'Hash::Case';

use strict;
use Carp;

=chapter NAME

Hash::Case::Lower - hash with enforced lower cased keys

=chapter SYNOPSIS

 use Hash::Case::Lower;
 tie my(%lchash), 'Hash::Case::Lower';
 $lchash{StraNGeKeY} = 3;
 print keys %lchash;  # strangekey

=chapter DESCRIPTION

Hash::Case::Lower extends Hash::Case, which lets you play various trics
with hash keys.  See L<Hash::Case> for the other implementations.

=chapter METHODS

=tie tie HASH, 'Hash::Case::Lower', [VALUES,] OPTIONS

Define HASH to have only lower cased keys.  The hash is
initialized with the VALUES, specified as ref-array or
ref-hash.  Currently, there are no OPTIONS defined.

=cut

sub init($)
{   my ($self, $args) = @_;

    $self->SUPER::native_init($args);

    croak "No options possible for ".__PACKAGE__
        if keys %$args;

    $self;
}

sub FETCH($)  { $_[0]->{lc $_[1]} }
sub STORE($$) { $_[0]->{lc $_[1]} = $_[2] }
sub EXISTS($) { exists $_[0]->{lc $_[1]} }
sub DELETE($) { delete $_[0]->{lc $_[1]} }

1;
