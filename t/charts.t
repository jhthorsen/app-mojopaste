use warnings;
use strict;
use Test::More;
use Test::Mojo;
use Cwd ();

$ENV{PASTE_DIR} = 't/paste';
$ENV{PASTE_ENABLE_CHARTS} = 1;

plan skip_all => $@ unless do 'script/mojopaste';

my $t = Test::Mojo->new;
my ($content, $file, $json);

plan skip_all => "$ENV{PASTE_DIR} was not created" unless -d $ENV{PASTE_DIR};

$content = q([
  { "x": "2015-02-04 15:03", "a": 120, "b": 90 },
  { "x": "2015-03-14", "a": 75, "b": 65 },
  { "x": "2015-04", "a": 100, "b": 40 }
]);
$t->post_ok('/', form => { content => $content, p => 1 })->status_is(302);
$file = $t->tx->res->headers->location =~ m!/(\w+)$! ? $1 : 'nope';
$t->get_ok("/$file")->status_is(200)->element_exists(qq(a[href\$="/chart"]));

$t->get_ok("/$file/chart")->status_is(200)
  ->content_like(qr{jquery\.min\.js})
  ->content_like(qr{morris\.css})
  ->content_like(qr{morris\.min\.js})
  ->content_like(qr{raphael-min\.js})
  ->element_exists('div[id="chart"]');

$json = $t->tx->res->body =~ m!new Morris\.Line\(([^\)]+)\)! ? Mojo::JSON::decode_json($1) : undef;
is_deeply($json->{labels}, ['a', 'b'], 'default labels');
is_deeply($json->{ykeys}, ['a', 'b'], 'default ykeys');
is($json->{element}, 'chart', 'default element');
is($json->{xkey}, 'x', 'default xkey');

$content = q({
  "labels": ["Down", "Up"],
  "data": [
    { "x": "2015-02-04 15:03", "a": 120, "b": 90 },
    { "x": "2015-03-14", "a": 75, "b": 65 },
    { "x": "2015-04", "a": 100, "b": 40 }
  ]
});
$t->post_ok('/', form => { content => $content, p => 1 })->status_is(302);
$file = $t->tx->res->headers->location =~ m!/(\w+)$! ? $1 : 'nope';
$t->get_ok("/$file/chart")->status_is(200);

$json = $t->tx->res->body =~ m!new Morris\.Line\(([^\)]+)\)! ? Mojo::JSON::decode_json($1) : undef;
is_deeply($json->{labels}, ['Down', 'Up'], 'labels');
is_deeply($json->{ykeys}, ['a', 'b'], 'default ykeys');

if (eval 'require Text::CSV;1') {
  $content = <<"HERE";
Date,Down,Up
2015-02-04 15:03,120,90
2015-03-14,75,65
2015-04,100,40
HERE
  $t->post_ok('/', form => { content => $content, p => 1 })->status_is(302);
  $file = $t->tx->res->headers->location =~ m!/(\w+)$! ? $1 : 'nope';
  $t->get_ok("/$file/chart")->status_is(200);

  $json = $t->tx->res->body =~ m!new Morris\.Line\(([^\)]+)\)! ? Mojo::JSON::decode_json($1) : undef;
  is_deeply($json->{labels}, ['Down', 'Up'], 'csv labels');
  is_deeply($json->{ykeys}, ['Down', 'Up'], 'csv ykeys');
  is($json->{xkey}, 'Date', 'xkey');
}
else {
  skip 'Text::CSV is required', 1;
}

unlink glob("$ENV{PASTE_DIR}/*");

done_testing;
