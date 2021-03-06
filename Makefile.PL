use ExtUtils::MakeMaker;

use 5.008;

WriteMakefile
  ( NAME	 => 'Hash::Case'
  , VERSION      => '1.06'
  , PREREQ_PM    =>
    { Test::More   => 0.47
    }
  , AUTHOR       => 'Mark Overmeer <markov@cpan.org>'
  , ABSTRACT     => 'Play trics with hash keys'
  , LICENSE      => 'perl_5'

  , META_MERGE =>
      { 'meta-spec' => { version => 2 }
      , resources  =>
          { repository =>
              { type => 'git'
              , url  => 'https://github.com/markov2/perl5-Hash-Case.git'
              , web  => 'https://github.com/markov2/perl5-Hash-Case'
              }
          , homepage => 'http://perl.overmeer.net/CPAN/'
          , license  => [ 'http://dev.perl.org/licenses/' ]
          }
      }
  );

sub MY::postamble { <<'__POSTAMBLE' }

# for DIST
RAWDIR          = ../public_html/hash-case/raw
DISTDIR         = ../public_html/hash-case/source
LICENSE         = perl

# for POD
FIRST_YEAR      = 2002
EMAIL           = markov@cpan.org
WEBSITE         = http://perl.overmeer.net/CPAN/

__POSTAMBLE

