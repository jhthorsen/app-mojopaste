package App::mojopaste;

=head1 NAME

App::mojopaste - Pastebin application

=head1 VERSION

0.05

=head1 DESCRIPTION

Mojopaste is a pastebin application. There's about one million of these out
there. But if you have the need to run something internally at work or you
just fancy having your own pastebin, this is your application.

=head1 DEMO

You can try mojopaste here: L<http://p.thorsen.pm>.

=head1 INSTALLATION

Install system wide with cpanm:

  $ cpanm --sudo App::mojopaste

Don't have cpanm installed?

  $ curl -L http://cpanmin.us | perl - --sudo App::mojopaste
  $ wget http://cpanmin.us -O - | perl - --sudo App::mojopaste

=head1 SYNOPSIS

=over 4

=item * Simple single process daemon

  $ mojopaste daemon --listen http://*:8080

=item * Save paste to custom dir

  $ PASTE_DIR=/path/to/paste/dir mojopaste daemon --listen http://*:8080

=item * Using the UNIX optimized, preforking hypnotoad web server

  $ MOJO_CONFIG=/path/to/mojopaste.conf hypnotoad $(which mojopaste)

Example mojopaste.conf:

  {
    paste_dir => '/path/to/paste/dir',
    allow_robots => 1, # default is 0
    hypnotoad => {
      listen => ['http://*:8080'],
    },
  }

"allow_robots" will disable javascript requirements and allow simple
scripts (robots) to use the pastebin without much knowledge.

Check out L<Mojo::Server::Hypnotoad> for more hypnotoad options.

=back

=head1 OTHER PASTEBINS

=over 4

=item * L<http://paste.scsys.co.uk>

=item * L<http://paste.ubuntu.com>

=item * L<http://pastebin.com>

=back

=cut

our $VERSION = '0.05';

=head1 AUTHOR

Jan Henning Thorsen - C<jhthorsen@cpan.org>

=cut

1;
