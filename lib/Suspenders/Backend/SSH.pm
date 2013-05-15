package Suspenders::Backend::SSH;
use strict;
use warnings;
use utf8;
use Carp ();

sub new {
    my ($class, $host) = @_;
    Carp::croak("Missing mandatory parameter: host") unless $host;
    bless { host => $host }, $class;
}

sub as_string { "ssh @{[ $_[0]->{host} ]}" }

sub run {
    my ($self, $cmdline) = @_;
    return system('ssh', $self->{host}, $cmdline);
}

1;

