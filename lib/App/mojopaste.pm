package App::mojopaste;

=head1 NAME

App::mojopaste - Pastebin application

=head1 VERSION

0.01

=head1 DESCRIPTION

Mojopaste is a pastebin application. There's about one million of these out
there. But if you have the need to run something internally at work or you
just fancy having your own pastebin, this is your application.

=head2 Demo

You can try mojopaste out here: L<http://p.thorsen.pm>.

=head2 Other pastebins

=over 4

=item * L<http://paste.scsys.co.uk>

=item * L<http://paste.ubuntu.com>

=item * L<http://pastebin.com>

=back

=head1 SYNOPSIS

  $ mojopaste
  $ MOJO_CONFIG=/path/to/mojopaste.conf hypnotoad $(which mojopaste)
  $ PASTE_DIR=/path/to/paste/dir mojopaste daemon --listen http://*:8080
  $ morbo $(which mojopast) --listen http://*:8080

=head2 Example mojopaste.conf

  {
    paste_dir => '/path/to/paste/dir',
    hypnotoad => {
      listen => ['http://*:8080'],
    },
  }

=head1 DEMO

=cut

our $VERSION = '0.01';

=head1 AUTHOR

Jan Henning Thorsen - C<jhthorsen@cpan.org>

=cut

1;
