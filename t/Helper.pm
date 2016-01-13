package t::Helper;
use Mojo::Base -strict;
use Cwd ();
use File::Spec;
use Test::More ();

sub t {
  Test::More::plan(skip_all => $@) unless do File::Spec->catfile(qw(script mojopaste));
  Test::More::plan(skip_all => "$ENV{PASTE_DIR} was not created") unless -d $ENV{PASTE_DIR};
  return Test::Mojo->new;
}

sub import {
  my $caller = caller;

  $_->import for qw(strict warnings utf8);
  $ENV{PASTE_DIR} = Cwd::abs_path(File::Spec->catdir(qw(t paste)));

  eval <<"HERE" or die $@;
package $caller;
use Test::Mojo;
use Test::More;
1;
HERE
}
1;
