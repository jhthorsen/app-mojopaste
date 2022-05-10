use lib '.';
use t::Helper;

my $t   = t::Helper->t;
my $raw = "// somefile.js\nvar foo = 123; // cool!\r\nvar toooooooo_long_for_title = 1234567890;\r\n";
#
$t->get_ok('/')->status_is(200)->text_is('title', 'Create new paste - Mojopaste')
  ->element_exists('form[method="post"][action="invalid"]', 'javascript is required')
  ->element_exists('input[type="file"][name="upload"]#file_upload');

$t->post_ok( '/', form => { upload => [ {
    content        => $raw,
    filename       => 'foo.js',
    'Content-Type' => 'text/plain; encoding=utf-8'
} ] })->status_is(302)->header_like( 'Location', qr[^/\w{12}$] );

my ($id) = $t->tx->res->headers->location =~ m!/(\w+)$!;
$t->get_ok($t->tx->res->headers->location)->status_is(200)
  ->text_is('title', 'somefile.js var foo = 123; // cool! var toooooo - Mojopaste')
  ->element_exists(qq(a[href="/"]))
  ->element_exists(qq(a[href="/$id.txt"]))->element_exists(qq(a[href="/?edit=$id"]))
  ->element_exists('pre')->text_is('pre', $raw);

$raw = "Not actually an image.";

$t->post_ok( '/', form => { upload => [ {
    content        => $raw,
    filename       => 'foo bar.jpg',
    'Content-Type' => 'image/jpeg'
} ] })->status_is(302)->header_like( 'Location', qr[^/\w{12}$] );

($id) = $t->tx->res->headers->location =~ m!/(\w+)$!;
$t->get_ok($t->tx->res->headers->location)->status_is(200)
  ->text_is('title', 'foo bar.jpg - Mojopaste')
  ->element_exists(qq(a[href="/"]))
  ->element_exists(qq(a[href="/$id?raw=1"]))
  ->element_exists_not(qq(a[href="/$id.txt"]))
  ->element_exists_not(qq(a[href="/?edit=$id"]))
  ->element_exists('div.prettyprint')
  ->text_is('div.prettyprint', 'Non textual paste, .');

$t->get_ok( $t->tx->req->url->query(raw => 1) )->status_is(200)
  ->header_is('Content-Type', 'image/jpeg')
  ->header_is('Content-Disposition', 'inline; filename="foo%20bar.jpg"')
  ->content_is($raw);

require File::Path;
File::Path::remove_tree($ENV{PASTE_DIR}, {keep_root => 1});
done_testing;

