package Suspenders::Backend::SSH;
use strict;
use warnings;
use utf8;
use Carp ();
use IPC::Run ();

sub new {
    my ($class, $host) = @_;
    Carp::croak("Missing mandatory parameter: host") unless $host;
    bless { host => $host }, $class;
}

sub as_string { "ssh @{[ $_[0]->{host} ]}" }

sub run {
    my ($self, $cmdline) = @_;
    my $retval = IPC::Run::run(['ssh', $self->{host}, $cmdline], \my $in, \my $out, '2>&1');
    if ($ENV{SUSPENDERS_VERBOSE}) {
        print STDERR "$out\n";
    }
    return $retval;
}

1;

