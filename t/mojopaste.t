use warnings;
use strict;
use Test::More;
use Test::Mojo;
use Cwd ();

$ENV{PASTE_DIR} = 't/paste';

plan skip_all => $@ unless do 'script/mojopaste';

my $t       = Test::Mojo->new;
my $content = "var foo = 123; # cool!\n";

plan skip_all => "$ENV{PASTE_DIR} was not created" unless -d $ENV{PASTE_DIR};

$t->get_ok('/')->status_is(200)->element_exists('form[method="post"][action="invalid"]', 'javascript is required')
  ->element_exists('button')->element_exists('a[href="https://metacpan.org/pod/App::mojopaste#DESCRIPTION"]');

$t->post_ok('/')->status_is(400)->element_exists('form[method="post"][action="invalid"]');

$t->post_ok('/', form => {content => $content, p => 1})->status_is(302)->header_like('Location', qr[^/\w{12}$]);

my ($id) = $t->tx->res->headers->location =~ m!/(\w+)$!;
$t->get_ok($t->tx->res->headers->location)->status_is(200)->element_exists(qq(a[href="/"]))
  ->element_exists(qq(a[href="/$id.txt"]))->element_exists(qq(a[href="/?edit=$id"]))
  ->element_exists_not(qq(a[href\$="/chart"]))    # $ENV{PASTE_ENABLE_CHARTS} is not set
  ->element_exists('pre')->text_is('pre', $content);

# $ENV{PASTE_ENABLE_CHARTS} is not set
$t->get_ok("/$id/chart")->status_is(404);

$t->get_ok("/$id.txt")->content_is($content);

$content =~ s/\n$//;
$t->get_ok("/?edit=$id")->text_is('textarea', "$content\n");

require File::Path;
File::Path::remove_tree($ENV{PASTE_DIR}, {keep_root => 1});
done_testing;
