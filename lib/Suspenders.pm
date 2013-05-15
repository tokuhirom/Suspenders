use 5.008001;
use strict;
use warnings;
package Suspenders;

package Suspenders::Backend::Exec;

sub new { bless {}, shift }

sub as_string { "exec" }

sub run {
    my ($self, $cmdline) = @_;
    return system($cmdline);
}

package Suspenders::Backend::SSH;

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

package Suspenders::Commands;
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

package Suspenders;
use parent qw(Exporter);

our $VERSION = "0.01";

our @EXPORT = qw( it should be file describe not contain backend_ssh );

our $STUFF;
our $NOT;
our $COMMAND;
our @ARGS;
our @MSG;
our $FAILED;
our $BACKEND = Suspenders::Backend::Exec->new();
our $BANNER;

BEGIN { $|++ };

sub backend_ssh($) {
    $BACKEND = Suspenders::Backend::SSH->new(@_);
}

sub describe {
    my ($stuff, $code) = @_;
    local $STUFF = $stuff;
    local $NOT = 0;
    local $COMMAND;

    unless ($BANNER++) {
        printf "  Remote:%s\n\n", $BACKEND->as_string();
    }

    printf("  $stuff\n");
    $code->();
    print("\n");

}

sub END {
    if ($FAILED) {
        print "not ok\n1..1\n";
    } else {
        print "ok\n1..1\n";
    }
}

sub it {
    unshift @MSG, 'it';

    my $cmd = $Suspenders::COMMAND
        or die "Invalid sequence";
    my $code = Suspenders::Commands->can($cmd)
        or die "Unknown command: '$cmd'";
    my $cmdline = $code->($Suspenders::STUFF, @Suspenders::ARGS);

    my $retval = $Suspenders::BACKEND->run($cmdline);

    my $succeeded = $Suspenders::NOT ? $retval != 0 : $retval == 0;
    my $msg = join(' ', @Suspenders::MSG);
    printf("    %s %s\n", $succeeded ? 'o' : 'x', $msg);
    $Suspenders::FAILED++ unless $succeeded;

    @MSG = ();
    $NOT = 0;
}

sub should($) {unshift @MSG, 'should'}

sub be($) { unshift @MSG, 'be' }

sub not($) { $NOT++; unshift @MSG, 'not'; }

sub contain($) {unshift @MSG, 'contain', @_; $COMMAND = 'check_file_contain'; @ARGS = @_; }
sub file()     {unshift @MSG, 'file', @_; $COMMAND = 'check_file'; @ARGS = @_; }

1;
__END__

=encoding utf-8

=head1 NAME

Suspenders - It's new $module

=head1 SYNOPSIS

    use Suspenders;

    describe '/etc/passwd' => sub {
        it should be file;
    };

=head1 DESCRIPTION

Suspenders is ...

=head1 TODO

    - more commands
    - ssh backend

        backend_ssh('www01.example.com');

=head1 LICENSE

Copyright (C) tokuhirom.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

tokuhirom E<lt>tokuhirom@gmail.comE<gt>

=cut

