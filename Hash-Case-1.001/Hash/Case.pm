
package Hash::Case;

use Tie::Hash;
@ISA = 'Tie::StdHash';

use strict;
use Carp;

our $VERSION = 1.001;

=head1 NAME

Hash::Case - base class for hashes with key-casing requirements

=head1 CLASS HIERARCHY

 Hash::Case
 is a Tie::StdHash
 is a Tie::Hash

=head1 SYNOPSIS

 use Hash::Case::Lower;
 tie my(%lchash), 'Hash::Case::Lower';
 $lchash{StraNGeKeY} = 3;
 print keys %lchash;  # strangekey

=head1 DESCRIPTION

Hash::Case is the base class for various classes which tie special
treatment for the casing of keys.  The following strategies are
implemented:

=over 4

=item * Hash::Case::Lower

Keys are always considered lower case. The internals of this
module translate any incoming key to lower case before it is used.

=item * Hash::Case::Upper

Like the ::Lower, but then all keys are always translated into
upper case.  This module can be of use for some databases, which
do translate everything to capitals as well.  To avoid confusion,
you may want to have you own internal Perl hash do this as well.

=item * Hash::Case::Preserve

The actual casing is ignored, but not forgotten.

=back

=head1 METHODS

=over 4

=cut

#-------------------------------------------

=item tie HASH, TIE, [VALUES,] OPTIONS

Tie the HASH with the TIE package which extends L<Hash::Case>.  The OPTIONS
differ per implementation: read the manual page for the package you actually
use.  The VALUES is a reference to an array containing key-value pairs,
or a reference to a hash: they fill the initial hash.

Examples:

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
    my %opts  = @_;
    my $self  = (bless {}, $class)->init( \%opts );

    if(!defined $to)          { ;}
    elsif(ref $to eq 'ARRAY') { $self->STORE(splice @$to, 0, 2) while @$to }
    elsif(ref $to eq 'HASH')
    {   while(my ($k, $v) = each %$to)
        {   $self->STORE($k, $v);
        }
    }
    else { croak "Cannot initialize the hash this way." }

    $self;
}

#-------------------------------------------

=head1 SEE ALSO

L<Hash::Case::Lower>
L<Hash::Case::Upper>
L<Hash::Case::Preserve>

=head1 AUTHOR

Mark Overmeer (F<mailbox@overmeer.net>).
All rights reserved.  This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=head1 VERSION

This code is beta, version 1.001

Copyright (c) 2002 Mark Overmeer. All rights reserved.
This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
