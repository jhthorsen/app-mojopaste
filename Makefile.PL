use ExtUtils::MakeMaker;
WriteMakefile(
  NAME => 'App::mojopaste',
  ABSTRACT_FROM => 'lib/App/mojopaste.pm',
  VERSION_FROM => 'lib/App/mojopaste.pm',
  AUTHOR => 'Jan Henning Thorsen <jhthorsen@cpan.org>',
  LICENSE => 'perl',
  PREREQ_PM => {
    'Mojolicious' => '4.30',
  },
  BUILD_REQUIRES => {
    'Test::More' => '0.90',
  },
  META_MERGE => {
    resources => {
      license => 'http://dev.perl.org/licenses/',
      homepage => 'http://p.thorsen.pm',
      bugtracker => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-mojopaste',
      repository => 'https://github.com/jhthorsen/app-mojopaste',
    },
  },
  test => {
    TESTS => 't/*.t',
  },
  EXE_FILES => ['mojopaste'],
);
