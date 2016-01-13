use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use Cwd ();

plan skip_all => $@ unless do 'script/mojopaste';

my $t = Test::Mojo->new;
my $id = substr Mojo::Util::md5_sum('nope'), 0, 12;

$t->get_ok("/$id")->status_is(404)->text_is('title', 'Could not find paste');
$t->get_ok("/?edit=$id")->status_is(404)->text_is('title', 'Could not find paste');

done_testing;
