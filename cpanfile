# You can install this projct with curl -L http://cpanmin.us | perl - https://github.com/jhthorsen/app-mojopaste/archive/master.tar.gz
requires "Mojolicious" => "6.00";

recommends "JSON::Syck" => "1.20";
recommends "Text::CSV"  => "1.30";

test_requires "Test::More" => "0.88";
