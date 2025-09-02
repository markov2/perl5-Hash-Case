# This code is part of distribution Hash::Case.  Meta-POD processed with
# OODoc into POD and HTML manual-pages.  See README.md
# Copyright Mark Overmeer.  Licensed under the same terms as Perl itself.

package Hash::Case::Lower;
use base 'Hash::Case';

use strict;
use warnings;
use Carp   qw(croak);

=chapter NAME

Hash::Case::Lower - hash with enforced lower cased keys

=chapter SYNOPSIS

 use Hash::Case::Lower;
 tie my(%lchash), 'Hash::Case::Lower';
 $lchash{StraNGeKeY} = 3;
 print keys %lchash;  # strangekey

=chapter DESCRIPTION

Hash::Case::Lower extends M<Hash::Case>, which lets you play various
trics with hash keys. In this implementation, the fake hash is case
insensitive and the keys stored in lower-case.

=chapter METHODS

=section Constructors

=tie TIEHASH, 'Hash::Case::Lower', [$values,] %options

Define TIEHASH to have only lower-cased keys.  The hash is initialized with
the $values, specified as ARRAY (with key-value pairs) or HASH.
Currently, there are no %options defined.

=cut

sub init($)
{   my ($self, $args) = @_;

    $self->SUPER::native_init($args);

    croak "no options possible for ". __PACKAGE__
        if keys %$args;

    $self;
}

sub FETCH($)  { $_[0]->{lc $_[1]} }
sub STORE($$) { $_[0]->{lc $_[1]} = $_[2] }
sub EXISTS($) { exists $_[0]->{lc $_[1]} }
sub DELETE($) { delete $_[0]->{lc $_[1]} }

1;
