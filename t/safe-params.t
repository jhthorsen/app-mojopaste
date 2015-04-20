use warnings;
use strict;
use Test::More;
use Test::Mojo;
use Cwd ();

$ENV{PASTE_DIR} = Cwd::abs_path('t/paste');

plan skip_all => $@ unless do 'script/mojopaste';

my $t = Test::Mojo->new;

plan skip_all => "$ENV{PASTE_DIR} was not created" unless -d $ENV{PASTE_DIR};

$t->get_ok("/?edit=../../Makefile.PL")->status_is(500)->content_unlike(qr{use ExtUtils::MakeMaker;});

done_testing;
