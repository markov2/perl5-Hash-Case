#oodist: *** DO NOT USE THIS VERSION FOR PRODUCTION ***
#oodist: This file contains OODoc-style documentation which will get stripped
#oodist: during its release in the distribution.  You can use this file for
#oodist: testing, however the code of this development version may be broken!

package Hash::Case::Preserve;
use base 'Hash::Case';

use strict;
use warnings;

use Carp 'croak';

#--------------------
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

Hash::Case::Preserve extends Hash::Case, which lets you play
various trics with hash keys. This extension implements a fake
hash which is case-insentive. The keys are administered in the
casing as they were used: case-insensitive but case-preserving.

=chapter METHODS

=section Constructors

=tie %hash, 'Hash::Case::Preserve', [$values,] %options
Define C<%hash> to be case insensitive, but case preserving.
The hash is initialized with the $values, specified as ARRAY (passing
flat key-value pairs) or HASH.

=option  keep 'FIRST'|'LAST'
=default keep 'LAST'
Which casing is the preferred casing?  The FIRST appearance or the LAST.
Only stores will affect the casing, deletes will undo the definition.
Defaults to LAST, which is slightly faster.

=cut

sub init($)
{	my ($self, $args) = @_;

	$self->{HCP_data} = {};
	$self->{HCP_keys} = {};

	my $keep = $args->{keep} || 'LAST';
	   if($keep eq 'LAST')  { $self->{HCP_update} = 1 }
	elsif($keep eq 'FIRST') { $self->{HCP_update} = 0 }
	else
	{	croak "use 'FIRST' or 'LAST' with the option keep";
	}

	$self->SUPER::native_init($args);
}

# Maintain two hashes within this object: one to store the values, and
# one to preserve the casing.  The main object also stores the options.
# The data is kept under lower cased keys.

sub FETCH($) { $_[0]->{HCP_data}{lc $_[1]} }

sub STORE($$)
{	my ($self, $key, $value) = @_;
	my $lckey = lc $key;

	$self->{HCP_keys}{$lckey} = $key
		if $self->{HCP_update} || !exists $self->{HCP_keys}{$lckey};

	$self->{HCP_data}{$lckey} = $value;
}

sub FIRSTKEY
{	my $self = shift;
	my $a = scalar keys %{$self->{HCP_keys}};
	$self->NEXTKEY;
}

sub NEXTKEY($)
{	my $self = shift;
	if(my ($k, $v) = each %{$self->{HCP_keys}})
	{	return wantarray ? ($v, $self->{HCP_data}{$k}) : $v;
	}

	();
}

sub EXISTS($) { exists $_[0]->{HCP_data}{lc $_[1]} }

sub DELETE($)
{	my $lckey = lc $_[1];
	delete $_[0]->{HCP_keys}{$lckey};
	delete $_[0]->{HCP_data}{$lckey};
}

sub CLEAR()
{	%{$_[0]->{HCP_data}} = ();
	%{$_[0]->{HCP_keys}} = ();
}

1;
