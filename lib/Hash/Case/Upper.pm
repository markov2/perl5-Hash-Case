#oodist: *** DO NOT USE THIS VERSION FOR PRODUCTION ***
#oodist: This file contains OODoc-style documentation which will get stripped
#oodist: during its release in the distribution.  You can use this file for
#oodist: testing, however the code of this development version may be broken!

package Hash::Case::Upper;
use base 'Hash::Case';

use strict;
use warnings;

use Carp  qw/croak/;

#--------------------
=chapter NAME

Hash::Case::Upper - native hash with enforced lower cased keys

=chapter SYNOPSIS

  use Hash::Case::Upper;
  tie my(%uchash), 'Hash::Case::Upper';
  $uchash{StraNGeKeY} = 3;
  print keys %uchash;  # STRANGEKEY

=chapter DESCRIPTION

Hash::Case::Upper extends Hash::Case, which lets you play various
trics with hash keys. In this implementation, the fake hash is case
insensitive and the keys stored in upper-case.

=chapter METHODS

=section Constructors

=tie %hash, 'Hash::Case::Upper', [$values,] %options
Define C<%hash> to have only upper-cased keys.  The hash is
initialized with the $values, specified as ARRAY or
HASH.  Currently, there are no %options defined.
=cut

sub init($)
{	my ($self, $args) = @_;

	$self->SUPER::native_init($args);

	! keys %$args
		or croak "no options available for ". __PACKAGE__;

	$self;
}

sub FETCH($)  { $_[0]->{uc $_[1]} }
sub STORE($$) { $_[0]->{uc $_[1]} = $_[2] }
sub EXISTS($) { exists $_[0]->{uc $_[1]} }
sub DELETE($) { delete $_[0]->{uc $_[1]} }

1;
