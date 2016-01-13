use t::Helper;

my $t = t::Helper->t;
my $id = substr Mojo::Util::md5_sum('nope'), 0, 12;

$t->get_ok("/$id")->status_is(404)->text_is('title', 'Could not find paste');
$t->get_ok("/?edit=$id")->status_is(404)->text_is('title', 'Could not find paste');

done_testing;
