use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile
  ( NAME	 => 'Hash::Case'
  , VERSION_FROM => 'Hash/Case.pm'
# , DIR          => [ 'Hash' ]
  , PMLIBDIRS    => [ 'Hash', 'Hash/Case' ]
  , AUTHOR       => 'Mark Overmeer'
  , ABSTRACT     => 'Play trics with hash keys'
  );
