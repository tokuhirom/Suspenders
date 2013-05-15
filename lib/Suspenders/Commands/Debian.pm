package Suspenders::Commands::Debian;
use strict;
use warnings;
use utf8;
use parent qw(Suspenders::Commands::Base);
use String::ShellQuote qw(shell_quote);

sub installed {
    unshift @Suspenders::MSG, 'installed';
    $Suspenders::COMMAND = 'installed';
    sprintf 'dpkg -s %s', shell_quote($_[0]);
}

1;

