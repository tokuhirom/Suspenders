package Suspenders::Backend::Exec;
use strict;
use warnings;
use utf8;
use IPC::Run ();
use Config;

sub new { bless {}, shift }

sub as_string { "exec" }

sub run {
    my ($self, $cmdline) = @_;
    my $retval = IPC::Run::run([$Config{sh}, '-c', $cmdline], \my $in, \my $out, '2>&1');
    if ($ENV{SUSPENDERS_VERBOSE}) {
        print STDERR "$out\n";
    }
    return $retval;
}

1;

