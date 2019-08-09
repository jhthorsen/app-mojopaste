use lib '.';
use t::Helper;

my $t   = t::Helper->t;
my $raw = "// somefile.js\nvar foo = 123; // cool!\r\nvar toooooooo_long_for_title = 1234567890;\r\n";

$t->get_ok('/')->status_is(200)->text_is('title', 'Create new paste - Mojopaste')
  ->element_exists('form[method="post"][action="invalid"]', 'javascript is required')->element_exists('button');

$t->post_ok('/')->status_is(400)->element_exists('form[method="post"][action="invalid"]');
$t->post_ok('/', form => {paste => '', p => 1})->status_is(400, 'Need at least one character');

$t->post_ok('/', form => {paste => $raw, p => 1})->status_is(302)->header_like('Location', qr[^/\w{12}$]);

my ($id) = $t->tx->res->headers->location =~ m!/(\w+)$!;
$t->get_ok($t->tx->res->headers->location)->status_is(200)
  ->text_is('title', 'somefile.js var foo = 123; // cool! var toooooo - Mojopaste')->element_exists(qq(a[href="/"]))
  ->element_exists(qq(a[href="/$id.txt"]))->element_exists(qq(a[href="/?edit=$id"]))
  ->element_exists_not(qq(a[href\$="/chart"]))    # $ENV{PASTE_ENABLE_CHARTS} is not set
  ->element_exists('pre')->text_is('pre', $raw);

# $ENV{PASTE_ENABLE_CHARTS} is not set
$t->get_ok("/$id/chart")->status_is(404);
$t->get_ok("/$id")->status_is(200)->header_like('X-Plain-Text-URL', qr{:\d+/$id\.txt$})->element_exists('nav');
$t->get_ok("/$id?embed=text")->status_is(200)->element_exists_not('nav');
$t->get_ok("/$id.txt")->content_is($raw);
ok !$t->tx->res->headers->header('X-Plain-Text-URL'), 'no X-Plain-Text-URL';

$t->get_ok("/?edit=$id")->text_is('title', 'somefile.js var foo = 123; // cool! var to - Mojopaste edit')
  ->text_is('textarea', $raw);

require File::Path;
File::Path::remove_tree($ENV{PASTE_DIR}, {keep_root => 1});
done_testing;
