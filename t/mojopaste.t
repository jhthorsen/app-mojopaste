use warnings;
use strict;
use Test::More;
use Test::Mojo;

$ENV{PASTE_DIR} = 't/paste';

plan skip_all => $@ unless eval { require 'mojopaste' };

my $t = Test::Mojo->new;
my $content = "var foo = 123; # cool!\n";
my @files;

plan skip_all => "$ENV{PASTE_DIR} was not created" unless -d $ENV{PASTE_DIR};

{
  $t->get_ok('/')
    ->status_is(200)
    ->element_exists('form[method="post"][action="/"]')
    ->element_exists('a.button')
    ->element_exists('a[href="https://metacpan.org/release/App-mojopaste"]')
    ->element_exists_not('button')
    ;

  $t->post_ok('/', form => {})->status_is(500);
  $t->post_ok('/', form => { p => 1 })
    ->status_is(400)
    ->element_exists('form[method="post"][action="/"]')
    ;

  $t->post_ok('/', form => { content => $content, p => 1 })
    ->status_is(302)
    ->header_like('Location', qr[^/\w{12}$])
    ;

  get_paste_files();
  is length $files[0], 12, 'file length is 12';
  is -s "$ENV{PASTE_DIR}/$files[0]", length $content, 'file was created';

  $t->get_ok($t->tx->res->headers->location)
    ->status_is(200)
    ->element_exists(qq(a[href="/"]))
    ->element_exists(qq(a[href="/$files[0]?raw=1"]))
    ->element_exists(qq(a[href="/?edit=$files[0]"]))
    ->element_exists('pre')
    ->text_is('pre', $content)
    ;

  $t->get_ok("/$files[0]?raw=1")->content_is($content);
  $content =~ s/\n$//;
  $t->get_ok("/?edit=$files[0]")->text_is('textarea', "$content\n");

  unlink "$ENV{PASTE_DIR}/$_" for @files;
}

done_testing;

sub get_paste_files {
  opendir(my $DH, $ENV{PASTE_DIR});
  @files = grep { /^\w/ } readdir $DH;
}
