# This code is part of distribution Hash::Case.  Meta-POD processed with
# OODoc into POD and HTML manual-pages.  See README.md
# Copyright Mark Overmeer.  Licensed under the same terms as Perl itself.

package Hash::Case::Preserve;
use base 'Hash::Case';

use strict;
use warnings;

use Log::Report 'hash-case';

=chapter NAME

Hash::Case::Preserve - hash with enforced lower cased keys

=chapter SYNOPSIS

 use Hash::Case::Preserve;
 tie my(%cphash), 'Hash::Case::Preserve';
 $cphash{StraNGeKeY} = 3;
 print keys %cphash;         # StraNGeKeY
 print $cphash{strangekey};  # 3
 print $cphash{STRANGEKEY};  # 3

=chapter DESCRIPTION

Hash::Case::Preserve extends M<Hash::Case>, which lets you play
various trics with hash keys. This extension implements a fake
hash which is case-insentive. The keys are administered in the
casing as they were used: case-insensitive but case-preserving.

=chapter METHODS

=section Constructors

=tie tie HASH, 'Hash::Case::Preserve', [VALUES,] OPTIONS

Define HASH to be case insensitive, but case preserving.
The hash is initialized with the VALUES, specified as ref-array (passing
a list of key-value pairs) or ref-hash.

OPTIONS is a list of key/value pairs, which specify how the hash
must handle preservation.  Current options:

=option  keep 'FIRST' | 'LAST'
=default keep 'LAST'
Which casing is the preferred casing?  The FIRST appearance or the LAST.
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
    {   error "use 'FIRST' or 'LAST' with the option keep";
    }

    $self->SUPER::native_init($args);
}

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

1;
