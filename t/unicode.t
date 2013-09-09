use warnings;
use strict;
use utf8;
use Test::More;
use Test::Mojo;

$ENV{PASTE_DIR} = 't/paste';

plan skip_all => $@ unless eval { require 'mojopaste' };

my $t = Test::Mojo->new;
my $content = "BLACK DOWN-POINTING TRIANGLE \x{3a3}";
my @files;

plan skip_all => "$ENV{PASTE_DIR} was not created" unless -d $ENV{PASTE_DIR};

{
  $t->post_ok('/', form => { content => $content, p => 1 })->status_is(302);
  get_paste_files();
  $content =~ s/\x{3a3}/Σ/;
  $t->get_ok($t->tx->res->headers->location)->text_is('pre', $content);
  $t->get_ok("/$files[0]?raw=1")->content_is($content);
  unlink "$ENV{PASTE_DIR}/$_" for @files;
}

done_testing;

sub get_paste_files {
  opendir(my $DH, $ENV{PASTE_DIR});
  @files = grep { /^\w/ } readdir $DH;
}
