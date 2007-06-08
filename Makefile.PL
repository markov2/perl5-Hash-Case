use ExtUtils::MakeMaker;

WriteMakefile
  ( NAME	 => 'Hash::Case'
  , VERSION      => '1.004'
  , PREREQ_PM    =>
    { Test::More => 0.47
    }
  , AUTHOR       => 'Mark Overmeer'
  , ABSTRACT     => 'Play trics with hash keys'
  );

sub MY::postamble { <<'__POSTAMBLE' }

# for DIST
RAWDIR          = ../public_html/hash-case/raw
DISTDIR         = ../public_html/hash-case/source
LICENSE         = artistic

# for POD
FIRST_YEAR      = 2002-2003,
EMAIL           = perl@overmeer.net
WEBSITE         = http://perl.overmeer.net/hash-case/

__POSTAMBLE

