
package Hash::Case;

use Tie::Hash;
@ISA = 'Tie::StdHash';

use strict;
use Carp;

=chapter NAME

Hash::Case - base class for hashes with key-casing requirements

=chapter SYNOPSIS

 use Hash::Case::Lower;
 tie my(%lchash), 'Hash::Case::Lower';
 $lchash{StraNGeKeY} = 3;
 print keys %lchash;  # strangekey

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

=tie tie HASH, TIE, [VALUES,] OPTIONS

Tie the HASH with the TIE package which extends L<Hash::Case>.  The OPTIONS
differ per implementation: read the manual page for the package you actually
use.  The VALUES is a reference to an array containing key-value pairs,
or a reference to a hash: they fill the initial hash.

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
{   my $class = shift;
    my $to    = @_ % 2 ? shift : undef;
    my %opts  = (@_, add => $to);
    (bless {}, $class)->init( \%opts );
}

# Used for case-insensitive hashes which do not need more than
# one hash.
sub native_init($)
{   my ($self, $args) = @_;
    my $add = delete $args->{add};

       if(!$add)               { ; }
    elsif(ref $add eq 'ARRAY') { $self->addPairs(@$add) }
    elsif(ref $add eq 'HASH')  { $self->addHashData($add)  }
    else { croak "Cannot initialize the native hash this way." }

    $self;
}

# Used for case-insensitive hashes which are implemented around
# an existing hash.
sub wrapper_init($)
{   my ($self, $args) = @_;
    my $add = delete $args->{add};

       if(!$add)               { ; }
    elsif(ref $add eq 'ARRAY') { $self->addPairs(@$add) }
    elsif(ref $add eq 'HASH')  { $self->setHash($add)  }
    else { croak "Cannot initialize a wrapping hash this way." }

    $self;
}

=method addPairs PAIRS

Specify an even length list of alternating key and value to be stored in
the hash.

=cut

sub addPairs(@)
{   my $self = shift;
    $self->STORE(shift, shift) while @_;
    $self;
}

=method addHashData HASH

Add the data of a hash (passed as reference) to the created tied hash.  The
existing values in the hash remain, the keys are adapted to the needs of the
the casing.

=cut

sub addHashData($)
{   my ($self, $data) = @_;
    while(my ($k, $v) = each %$data) { $self->STORE($k, $v) }
    $self;
}

=method setHash HASH

The functionality differs for native and wrapper hashes.  For native
hashes, this is the same as first clearing the hash, and then a call
to addHashData.  Wrapper hashes will use the hash you specify here
to store the data, and re-create the mapping hash.

=cut

sub setHash($)
{   my ($self, $hash) = @_;   # the native implementation is the default.
    %$self = %$hash;
    $self;
}

1;
