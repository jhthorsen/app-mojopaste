use warnings;
use strict;
use Test::More;
use Test::Mojo;

$ENV{MOJO_CONFIG} = 't/mojopaste.conf';

plan skip_all => 'Cannot read MOJO_CONFIG' unless -r $ENV{MOJO_CONFIG};
plan skip_all => $@ unless eval { require 'mojopaste' };

my $t = Test::Mojo->new;

is $t->app->config('paste_dir'), 't/paste', 'read config';

done_testing;
