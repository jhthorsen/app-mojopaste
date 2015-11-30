use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use Cwd ();

plan skip_all => 'TEST_DATABASE=postgresql://postgres@localhost' unless $ENV{TEST_DATABASE};

require DBIx::TempDB;
my $tmpdb = DBIx::TempDB->new($ENV{TEST_DATABASE}, drop_from_child => 1);

$ENV{PASTE_DB_URL} = $tmpdb->url;
do 'script/mojopaste' or die $@;

my $t   = Test::Mojo->new;
my $raw = "var foo = 'BLACK DOWN-POINTING TRIANGLE \x{3a3}'; # cool!";

$t->get_ok('/')->status_is(200);
$t->post_ok('/', form => {paste => $raw, p => 1})->status_is(302);

my ($id) = $t->tx->res->headers->location =~ m!/(\w+)$!;
$t->get_ok($t->tx->res->headers->location)->status_is(200);

$raw =~ s/\x{3a3}/Σ/;
$t->get_ok("/$id.txt")->content_is($raw);

done_testing;
