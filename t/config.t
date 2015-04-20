use warnings;
use strict;
use Test::More;
use Test::Mojo;
use Cwd ();

$ENV{MOJO_CONFIG} = Cwd::abs_path('t/mojopaste.conf');

plan skip_all => 'Cannot read MOJO_CONFIG' unless -r $ENV{MOJO_CONFIG};
plan skip_all => $@ unless do 'script/mojopaste';

my $t = Test::Mojo->new;

is $t->app->config('paste_dir'), 't/paste', 'read config';

done_testing;
