use warnings;
use strict;
use utf8;
use Test::More;
use Test::Mojo;

$ENV{PASTE_DIR} = 't/paste';

plan skip_all => 'Cannot write to paste dir' unless -w $ENV{PASTE_DIR};
plan skip_all => $@ unless do 'script/mojopaste';

my $t       = Test::Mojo->new;
my $content = "BLACK DOWN-POINTING TRIANGLE \x{3a3}";

plan skip_all => "$ENV{PASTE_DIR} was not created" unless -d $ENV{PASTE_DIR};

$t->post_ok('/', form => {content => $content, p => 1})->status_is(302);
my ($id) = $t->tx->res->headers->location =~ m!/(\w+)$!;
$content =~ s/\x{3a3}/Σ/;
$t->get_ok($t->tx->res->headers->location)->text_is('pre', $content);
$t->get_ok("/$id?raw=1")->content_is($content);

require File::Path;
File::Path::remove_tree($ENV{PASTE_DIR}, {keep_root => 1});
done_testing;
