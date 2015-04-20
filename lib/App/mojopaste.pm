package App::mojopaste;

=head1 NAME

App::mojopaste - Pastebin application

=head1 VERSION

0.11

=head1 DESCRIPTION

Mojopaste is a pastebin application. There's about one million of these out
there, but if you have the need to run something internally at work or you
just fancy having your own pastebin, this is your application.

=head2 Text and code

The standard version of L<App::mojopaste> can take normal text as input,
store it as a text file on the server and render the content as either
plain text or prettified using L<Google prettify|https://code.google.com/p/google-code-prettify/>.
(Note: Maybe another prettifier will be used in future versions)

=head2 Charts

In addition to just supporting text, this application can also make charts
from the input data. To turn this feature on, you need to specify
"enable_charts" in the config or set the C<PASTE_ENABLE_CHARTS>
environment variable:

  $ PASTE_ENABLE_CHARTS=1 script/mojopaste daemon;

The input chart data can be given as JSON or CSV:

=over 4

=item * Raw morris.js arguments

Example:

  {
    "data": [
      { "x": "2015-02-04 15:03", "a": 120, "b": 90 },
      { "x": "2015-03-14", "a": 75, "b": 65 },
      { "x": "2015-04", "a": 100, "b": 40 }
    ],
    "xkey": "x",
    "ykeys": ["a", "b"],
    "labels": ["Series A", "Series B"]
  }

"xkey" default to "x".
"ykeys" default to the rest of the keys in the first element in "data",
excluding xkey.
"labels" default to "ykeys".

See L<http://morrisjs.github.io/morris.js/lines.html> for more details.

Note that by installing L<JSON.pm|JSON> the input format can be less strict,
allowing JavaScript notation instead of strict JSON.

=item * Just data

  [
    // comments are allowed
    # both "#" and "//" can be used anywhere, but on a line by itself
    { "x": "2015-02-04 15:03", "a": 120, "b": 90 },
    { "x": "2015-03-14", "a": 75, "b": 65 },
    { "x": "2015-04", "a": 100, "b": 40 }
  ]

This input format takes just an JSON array and will use that as "data".
The rest will use the default value rules from above.

=item * CSV data

CSV data is similar to L</Just data> above, except the first line is used as
"xkey,ykey1,ykey2,...". Example:

  # Can have comments in CSV input as well
  x,a,b
  2015-02-04 15:03,120,90
  2015-03-14,75,65
  2015-04,100,40

CSV input data require L<Text::CSV> to be installed.

=back

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
    paste_dir     => '/path/to/paste/dir',
    allow_robots  => 1, # default is 0
    enable_charts => 1, # default is 0
    hypnotoad => {
      listen => ['http://*:8080'],
    },
  }

"allow_robots" will disable javascript requirements and allow simple
scripts (robots) to use the pastebin without much knowledge.

"enable_charts" is for adding a button which can make a chart of the input
data using L<morris.js|http://morrisjs.github.io/morris.js>

Check out L<Mojo::Server::Hypnotoad> for more hypnotoad options.

=back

=head1 OTHER PASTEBINS

=over 4

=item * L<http://paste.scsys.co.uk>

=item * L<http://paste.ubuntu.com>

=item * L<http://pastebin.com>

=back

=cut

our $VERSION = '0.11';

=head1 AUTHOR

Jan Henning Thorsen - C<jhthorsen@cpan.org>

=cut

1;
