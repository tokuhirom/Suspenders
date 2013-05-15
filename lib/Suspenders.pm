use 5.008001;
use strict;
use warnings;
package Suspenders;

package Suspenders::Backend::Exec;

sub new { bless {}, shift }

sub run {
    my $cmd = $Suspenders::COMMAND
        or die "Invalid sequence";
    my $code = Suspenders::Commands->can($cmd)
        or die "Unknown command: '$cmd'";
    my $cmdline = $code->($Suspenders::STUFF, @Suspenders::ARGS);
    my $retval = system($cmdline);
    my $succeeded = $Suspenders::NOT ? $retval != 0 : $retval == 0;
    my $msg = join(' ', @Suspenders::MSG);
    printf("    %s %s\n", $succeeded ? 'o' : 'x', $msg);
    $Suspenders::FAILED++ unless $succeeded;
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

our @EXPORT = qw( it should be file describe not contain );

our $STUFF;
our $NOT;
our $COMMAND;
our @ARGS;
our @MSG;
our $FAILED;
our $BACKEND = Suspenders::Backend::Exec->new();
BEGIN { $|++ };

sub describe {
    my ($stuff, $code) = @_;
    local $STUFF = $stuff;
    local $NOT = 0;
    local $COMMAND;
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
    $Suspenders::BACKEND->run();
    @MSG = ();
    $NOT = 0;
}

sub should($) {unshift @MSG, 'should'}

sub be($) { unshift @MSG, 'be' }

sub not($) { $NOT++; unshift @MSG, 'not'; }

sub contain($) {unshift @MSG, 'contain', @_; $COMMAND = 'check_file_contain'; @ARGS = @_; }
sub file()     {unshift @MSG, 'file', @_; $COMMAND = 'check_file'; @ARGS = @_; }

package Suspenders::Util {
    sub slurp {
        my $fname = shift;
        open my $fh, '<', $fname
            or die "Cannot open $fname for reading: $!";
        do { local $/; <$fh> };
    }
}

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

