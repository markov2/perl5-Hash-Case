#!/usr/bin/env perl

# Test case-preserving hash, where the last appearance is kept.

use strict;
use warnings;

use Test::More;

BEGIN {plan tests => 37}

use Hash::Case::Preserve;

my %h;

tie %h, 'Hash::Case::Preserve', keep => 'LAST';
cmp_ok(keys %h, '==',  0);

$h{ABC} = 3;
cmp_ok($h{ABC}, '==',  3);
cmp_ok($h{abc}, '==',  3);
cmp_ok($h{AbC}, '==',  3);
cmp_ok(keys %h, '==',  1);

my @h = keys %h;
cmp_ok(@h, '==',  1);
is($h[0], 'ABC');   # last STORE

$h{abc} = 6;
cmp_ok(keys %h, '==',  1);
cmp_ok($h{ABC}, '==',  6);
is((keys %h)[0], 'abc');

$h{ABC} = 3;
cmp_ok(keys %h, '==',  1);
cmp_ok($h{ABC}, '==',  3);
is((keys %h)[0], 'ABC');

$h{dEf} = 4;
cmp_ok($h{def}, '==',  4);
cmp_ok($h{dEf}, '==',  4);
cmp_ok(keys %h, '==',  2);

my (@k, @v);
while(my ($k, $v) = each %h)
{   push @k, $k;
    push @v, $v;
}

cmp_ok(@k, '==',  2);
@k = sort @k;
is($k[0], 'ABC');
is($k[1], 'dEf');

cmp_ok(@v, '==',  2);
@v = sort {$a <=> $b} @v;
cmp_ok($v[0], '==',  3);
cmp_ok($v[1], '==',  4);

ok(exists $h{ABC});
cmp_ok(delete $h{ABC}, '==',  3);
cmp_ok(keys %h, '==',  1);

%h = ();
cmp_ok(keys %h, '==',  0);
ok(tied %h);

my %a;
tie %a, 'Hash::Case::Preserve', [ AbC => 3, dEf => 4 ], keep => 'LAST';
ok(tied %a);
cmp_ok(keys %a, '==',  2);
ok(defined $a{abc});
cmp_ok($a{ABC}, '==',  3);
cmp_ok($a{DeF}, '==',  4);

my %b;
tie %b, 'Hash::Case::Preserve', { AbC => 3, dEf => 4 }, keep => 'LAST';
ok(tied %b);
cmp_ok(keys %b, '==',  2);
ok(defined $b{abc});
cmp_ok($b{ABC}, '==',  3);
cmp_ok($b{DeF}, '==',  4);
