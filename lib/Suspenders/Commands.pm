package Suspenders::Commands;
use strict;
use warnings;
use utf8;

use String::ShellQuote;

sub check_file {
    # "test -f %1"
    "test -f @{[ shell_quote shift ]}";
}

sub check_file_contain {
    sprintf('grep -q %s %s',
        quotemeta $_[1],
        shell_quote $_[0], # file name
    );
}

1;

