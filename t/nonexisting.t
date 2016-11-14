BEGIN { $ENV{PASTE_ENABLE_CHARTS} = 1 }
use lib '.';
use t::Helper;

my $t = t::Helper->t;
my $id = substr Mojo::Util::md5_sum('nope'), 0, 12;

for my $p ("/$id", "/?edit=$id", "/$id/chart") {
  $t->get_ok($p)->status_is(404)->text_is('title', 'Could not find paste')->content_like(qr{Could not find paste});
}

done_testing;
