package Suspenders::Commands::Base;
use strict;
use warnings;
use utf8;

use String::ShellQuote;

sub new { bless {}, shift }

sub file {
    # "test -f %1"
    "test -f @{[ shell_quote shift ]}";
}

sub contain {
    sprintf('grep -q %s %s',
        quotemeta $_[1],
        shell_quote $_[0], # file name
    );
}

1;

