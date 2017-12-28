use lib '.';
use t::Helper;

$ENV{MOJO_CONFIG} = Cwd::abs_path('t/mojopaste.conf');
plan skip_all => 'Cannot read MOJO_CONFIG' unless -r $ENV{MOJO_CONFIG};
is(t::Helper->t->app->config('paste_dir'), 't/paste', 'read config');

done_testing;
