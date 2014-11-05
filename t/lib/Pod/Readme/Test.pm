package Pod::Readme::Test;

use Exporter::Lite;
use IO::String;
use Test::Most;

our $out;
our $io = IO::String->new($out);
our $prf;

our @EXPORT = qw/ $prf $out $io filter_lines reset_out /;

sub filter_lines {
    my @lines = @_;
    foreach my $line (@lines) {
        note $line if $line =~ /^=(?:\w+)/;
        $prf->filter_line($line . "\n");
    }
}

sub reset_out {
    $io->close;
    $out = '';
    $io->open($out);
}

1;
