use ExtUtils::MakeMaker;

WriteMakefile
  ( NAME	 => 'Hash::Case'
  , VERSION_FROM => 'lib/Hash/Case.pm'
  , PREREQ_PM    =>
    { Test::More => 0.47
    }
  , AUTHOR       => 'Mark Overmeer'
  , ABSTRACT     => 'Play trics with hash keys'
  );
