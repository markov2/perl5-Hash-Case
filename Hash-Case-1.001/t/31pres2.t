#!/usr/bin/perl -w

# Test case-preserving hash, where the first appearance is kept.

use strict;
use Test;

use lib qw/. t/;

BEGIN {plan tests => 37}

use Hash::Case::Preserve;

my %h;

tie %h, 'Hash::Case::Preserve', keep => 'FIRST';
ok(keys %h == 0);

$h{ABC} = 3;
ok($h{ABC} == 3);
ok($h{abc} == 3);
ok($h{AbC} == 3);
ok(keys %h == 1);

my @h = keys %h;
ok(@h==1);
ok($h[0] eq 'ABC');   # first STORE

$h{abc} = 6;
ok(keys %h == 1);
ok($h{ABC} == 6);
ok((keys %h)[0] eq 'ABC');

$h{ABC} = 3;
ok(keys %h == 1);
ok($h{ABC} == 3);
ok((keys %h)[0] eq 'ABC');

$h{dEf} = 4;
ok($h{def} == 4);
ok($h{dEf} == 4);
ok(keys %h == 2);

my (@k, @v);
while(my ($k, $v) = each %h)
{   push @k, $k;
    push @v, $v;
}

ok(@k==2);
@k = sort @k;
ok($k[0] eq 'ABC');
ok($k[1] eq 'dEf');

ok(@v==2);
@v = sort {$a <=> $b} @v;
ok($v[0] == 3);
ok($v[1] == 4);

ok(exists $h{ABC});
ok(delete $h{ABC} == 3);
ok(keys %h == 1);

%h = ();
ok(keys %h == 0);
ok(tied %h);

my %a;
tie %a, 'Hash::Case::Preserve', [ AbC => 3, dEf => 4 ], keep => 'FIRST';
ok(tied %a);
ok(keys %a==2);
ok(defined $a{abc});
ok($a{ABC} == 3);
ok($a{DeF} == 4);

my %b;
tie %b, 'Hash::Case::Preserve', { AbC => 3, dEf => 4 }, keep => 'FIRST';
ok(tied %b);
ok(keys %b==2);
ok(defined $b{abc});
ok($b{ABC} == 3);
ok($b{DeF} == 4);
