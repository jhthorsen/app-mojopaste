use lib '.';
use t::Helper;

my $t = t::Helper->t;
$t->get_ok('/')->status_is(200)->text_is('title', 'Create new paste - Mojopaste')
  ->element_exists('nav .brand[href="/"]')->element_exists('nav .brand img[src="/images/logo.png"]')
  ->text_is('nav .brand span', 'Mojopaste');

$t->app->defaults(brand_link => 'https://example.com');
$t->app->defaults(brand_logo => 'https://example.com/logo/mybrand.png');
$t->app->defaults(brand_name => 'Example');
$t->get_ok('/')->status_is(200)->text_is('title', 'Create new paste - Example')
  ->element_exists('nav .brand[href="https://example.com"]')
  ->element_exists('nav .brand img[src="https://example.com/logo/mybrand.png"]')->text_is('nav .brand span', 'Example');

$t->app->defaults(brand_link => 'https://example.com');
$t->app->defaults(brand_logo => '');
$t->app->defaults(brand_name => '');
$t->get_ok('/')->status_is(200)->text_is('title', 'Create new paste - Mojopaste')
  ->element_exists('nav .brand[href="https://example.com"]')->element_exists_not('nav .brand img')
  ->element_exists_not('nav .brand span');

done_testing;
