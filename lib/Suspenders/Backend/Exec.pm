package Suspenders::Backend::Exec;
use strict;
use warnings;
use utf8;

sub new { bless {}, shift }

sub as_string { "exec" }

sub run {
    my ($self, $cmdline) = @_;
    return system($cmdline);
}

1;

