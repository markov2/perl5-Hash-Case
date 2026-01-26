#oodist: *** DO NOT USE THIS VERSION FOR PRODUCTION ***
#oodist: This file contains OODoc-style documentation which will get stripped
#oodist: during its release in the distribution.  You can use this file for
#oodist: testing, however the code of this development version may be broken!

package Hash::Case::Lower;
use base 'Hash::Case';

use strict;
use warnings;

use Carp   qw/croak/;

#--------------------
=chapter NAME

Hash::Case::Lower - hash with enforced lower cased keys

=chapter SYNOPSIS

  use Hash::Case::Lower;
  tie my(%lchash), 'Hash::Case::Lower';
  $lchash{StraNGeKeY} = 3;
  print keys %lchash;  # strangekey

=chapter DESCRIPTION

Hash::Case::Lower extends Hash::Case, which lets you play various
trics with hash keys. In this implementation, the fake hash is case
insensitive and the keys stored in lower-case.

=chapter METHODS

=section Constructors

=tie %hash, 'Hash::Case::Lower', [$values,] %options

Define C<%hash> to have only lower-cased keys.  The hash is initialized with
the $values, specified as ARRAY (with key-value PAIRS) or HASH.
Currently, there are no %options defined.

=cut

sub init($)
{	my ($self, $args) = @_;

	$self->SUPER::native_init($args);

	! keys %$args
		or croak "no options possible for ". __PACKAGE__;

	$self;
}

sub FETCH($)  { $_[0]->{lc $_[1]} }
sub STORE($$) { $_[0]->{lc $_[1]} = $_[2] }
sub EXISTS($) { exists $_[0]->{lc $_[1]} }
sub DELETE($) { delete $_[0]->{lc $_[1]} }

1;
