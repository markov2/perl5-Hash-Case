#oodist: *** DO NOT USE THIS VERSION FOR PRODUCTION ***
#oodist: This file contains OODoc-style documentation which will get stripped
#oodist: during its release in the distribution.  You can use this file for
#oodist: testing, however the code of this development version may be broken!

package Hash::Case;

use Tie::Hash;  # Tie::StdHash is a hidden package inside this :-(
use base 'Tie::StdHash';

use warnings;
use strict;

use Carp       qw/croak/;

#--------------------
=chapter NAME

Hash::Case - base class for hashes with key-casing requirements

=chapter SYNOPSIS

  use Hash::Case::Lower;
  tie my(%lchash), 'Hash::Case::Lower';
  $lchash{StraNGeKeY} = 3;
  print keys %lchash;  # strangekey

  (tied %lchash)->addPairs(key => value, ...);
  (tied %lchash)->addHashData(\%data);
  (tied %lchash)->setHash(\%replacement);

=chapter DESCRIPTION

Hash::Case is the base class for various classes which tie special
treatment for the casing of keys.  Be aware of the differences in
implementation: C<Lower> and C<Upper> are tied native hashes:
these hashes have no need for hidden fields or other assisting
data structured.  A case C<Preserve> hash will actually create
three hashes.

The following strategies are implemented:

=over 4

=item * Hash::Case::Lower (native hash)
Keys are always considered lower case. The internals of this
module translate any incoming key to lower case before it is used.

=item * Hash::Case::Upper (native hash)
Like the ::Lower, but then all keys are always translated into
upper case.  This module can be of use for some databases, which
do translate everything to capitals as well.  To avoid confusion,
you may want to have you own internal Perl hash do this as well.

=item * Hash::Case::Preserve
The actual casing is ignored, but not forgotten.

=back

=chapter METHODS

=section Constructors

=tie %hash, $class, [$values,] %options
Tie the C<%hash> with the $class (package which extends L<Hash::Case>).
The %options differ per implementation: read the manual page for the
package you actually use.  The optional $values is a reference to an ARRAY
(containing key-value PAIRS) or a HASH: they fill-in the initial C<%hash>.

=examples

  my %x;
  tie %x, 'Hash::Case::Lower';
  $x{Upper} = 3;
  print keys %x;       # 'upper'

  my @y = (ABC => 3, DeF => 4);
  tie %x, 'Hash::Case::Lower', \@y;
  print keys %x;       # 'abc' 'def'

  my %z = (ABC => 3, DeF => 4);
  tie %x, 'Hash::Case::Lower', \%z;
=cut

sub TIEHASH(@)
{	my $class = shift;
	my $to    = @_ % 2 ? shift : undef;
	my %opts  = (@_, add => $to);
	(bless {}, $class)->init( \%opts );
}

# Used for case-insensitive hashes which do not need more than
# one hash.
sub native_init($)
{	my ($self, $args) = @_;
	my $add = delete $args->{add};

	   if(!$add)               { ; }
	elsif(ref $add eq 'ARRAY') { $self->addPairs(@$add) }
	elsif(ref $add eq 'HASH')  { $self->addHashData($add)  }
	else { croak "cannot initialize the native hash this way" }

	$self;
}

# Used for case-insensitive hashes which are implemented around
# an existing hash.
sub wrapper_init($)
{	my ($self, $args) = @_;
	my $add = delete $args->{add};

	   if(!$add)               { ; }
	elsif(ref $add eq 'ARRAY') { $self->addPairs(@$add) }
	elsif(ref $add eq 'HASH')  { $self->setHash($add)  }
	else { croak "cannot initialize a wrapping hash this way" }

	$self;
}

#-----------
=section Hidden object access
Besides all the usual HASH actions which are implemented for the tied
C<%hash>, you can also call methods on the C<tied()> object.

=method addPairs @pairs
Specify an even length list of alternating key and value to be stored in
the hash.
=cut

sub addPairs(@)
{	my $self = shift;
	$self->STORE(shift, shift) while @_;
	$self;
}

=method addHashData \%data
Add the %data to the created tied hash.  The existing values in the hash
remain, the keys are adapted to the needs of the the casing.
=cut

sub addHashData($)
{	my ($self, $data) = @_;
	while(my ($k, $v) = each %$data) { $self->STORE($k, $v) }
	$self;
}

=method setHash \%data
The functionality differs for native and wrapper hashes.  For native
hashes, this is the same as first clearing the hash, and then a call
to M<addHashData()>.  Wrapper hashes will use the hash you specify here
to store the data, and re-create the mapping hash.
=cut

sub setHash($)
{	my ($self, $hash) = @_;   # the native implementation is the default.
	%$self = %$hash;
	$self;
}

1;
