

package Hash::Case::Preserve;
use base 'Hash::Case';

$VERSION = 1.003;

use strict;
use Carp;

=head1 NAME

Hash::Case::Preserve - hash with enforced lower cased keys

=head1 CLASS HIERARCHY

 Hash::Case::Preserve
 is a Hash::Case
 is a Tie::StdHash
 is a Tie::Hash

=head1 SYNOPSIS

 use Hash::Case::Preserve;
 tie my(%cphash), 'Hash::Case::Preserve';
 $cphash{StraNGeKeY} = 3;
 print keys %cphash;         # StraNGeKeY
 print $cphash{strangekey};  # 3
 print $cphash{STRANGEKEY};  # 3

=head1 DESCRIPTION

Hash::Case::Preserve extends Hash::Case, which lets you play various trics
with hash keys.  See L<Hash::Case> for the other implementations.

=head1 METHODS

=over 4

=cut

#-------------------------------------------

=item tie HASH, 'Hash::Case::Preserve', [VALUES,] OPTIONS

Define HASH to be case insensitive, but case preserving.
The hash is initialized with the VALUES, specified as ref-array or
ref-hash.

OPTIONS is a list of key/value pairs, which specify how the hash
must handle preservation.  Current options:

=over 4

=item * keep =E<gt> 'FIRST' | 'LAST'

Which casing is the prefered casing?  The FIRST appearance or the LAST.
Only stores will affect the casing, deletes will undo the definition.
Defaults to LAST, which is slightly faster.

=cut

sub init($)
{   my ($self, $args) = @_;

    $self->{HCP_data} = {};
    $self->{HCP_keys} = {};

    my $keep = $args->{keep} || 'LAST';
    if($keep eq 'LAST')     { $self->{HCP_update} = 1 }
    elsif($keep eq 'FIRST') { $self->{HCP_update} = 0 }
    else
    {   croak "Use 'FIRST' or 'LAST' with the option keep.\n";
    }

    $self->SUPER::native_init($args);
}

#-------------------------------------------

# Maintain two hashes within this object: one to store the values, and
# one to preserve the casing.  The main object also stores the options.
# The data is kept under lower cased keys.

sub FETCH($) { $_[0]->{HCP_data}{lc $_[1]} }

sub STORE($$)
{   my ($self, $key, $value) = @_;
    my $lckey = lc $key;

    $self->{HCP_keys}{$lckey} = $key
        if $self->{HCP_update} || !exists $self->{HCP_keys}{$lckey};

    $self->{HCP_data}{$lckey} = $value;
}

sub FIRSTKEY
{   my $self = shift;
    my $a = scalar keys %{$self->{HCP_keys}};
    $self->NEXTKEY;
}

sub NEXTKEY($)
{   my $self = shift;
    if(my ($k, $v) = each %{$self->{HCP_keys}})
    {    return wantarray ? ($v, $self->{HCP_data}{$k}) : $v;
    }
    else { return () }
}

sub EXISTS($) { exists $_[0]->{HCP_data}{lc $_[1]} }

sub DELETE($)
{   my $lckey = lc $_[1];
    delete $_[0]->{HCP_keys}{$lckey};
    delete $_[0]->{HCP_data}{$lckey};
}

sub CLEAR()
{   %{$_[0]->{HCP_data}} = ();
    %{$_[0]->{HCP_keys}} = ();
}

#-------------------------------------------

=back

=head1 SEE ALSO

L<Hash::Case>
L<Hash::Case::Lower>
L<Hash::Case::Upper>

=head1 AUTHOR

Mark Overmeer (F<mark@overmeer.net>).
All rights reserved.  This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=head1 VERSION

This code is beta, version 1.003

Copyright (c) 2002-2003 Mark Overmeer. All rights reserved.
This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
