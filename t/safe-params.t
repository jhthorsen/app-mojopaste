use t::Helper;

my $t = t::Helper->t;
$t->get_ok("/?edit=../../Makefile.PL")->status_is(404)->content_unlike(qr{use ExtUtils::MakeMaker;});

done_testing;
