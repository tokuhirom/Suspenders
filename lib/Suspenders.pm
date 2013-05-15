use 5.008001;
use strict;
use warnings;

package Suspenders;
use parent qw(Exporter);
use Module::Functions;
use Suspenders::Backend::Exec;
use Suspenders::Commands::Base;

our $VERSION = "0.01";

our $STUFF;
our $NOT;
our $COMMAND;
our @ARGS;
our @MSG;
our $FAILED;
our $BACKEND;
our $BANNER;
our $COMMANDS;

BEGIN { $|++ };

sub backend_ssh($) {
    require Suspenders::Backend::SSH;
    $BACKEND = Suspenders::Backend::SSH->new(@_);
}

sub describe {
    my ($stuff, $code) = @_;
    local $STUFF = $stuff;
    local $NOT = 0;
    local $COMMAND;
    $BACKEND ||= Suspenders::Backend::Exec->new();
    $COMMANDS ||= Suspenders::Commands::Base->new();

    unless ($BANNER++) {
        printf "  Remote:%s\n\n", $BACKEND->as_string();
    }

    printf("  $stuff\n");
    $code->();
    print("\n");

}

sub END {
    if ($FAILED || $?!=0) {
        print "not ok\n1..1\n";
    } else {
        print "ok\n1..1\n";
    }
}

sub it {
    unshift @MSG, 'it';

    my $cmd = $COMMAND
        or die "Invalid sequence";
    my $code = $COMMANDS->can($cmd)
        or die "Unknown command: '$cmd'";
    my $cmdline = $code->($STUFF, @ARGS);

    my $retval = $BACKEND->run($cmdline);

    my $succeeded = $NOT ? $retval != 0 : $retval == 0;
    my $msg = join(' ', @MSG);
    printf("    %s %s\n", $succeeded ? 'o' : 'x', $msg);
    $FAILED++ unless $succeeded;

    @MSG = ();
    $NOT = 0;
}

sub should($) {unshift @MSG, 'should'}

sub be($) { unshift @MSG, 'be' }

sub not($) { $NOT++; unshift @MSG, 'not'; }

for my $command (qw(contain file installed)) {
    no strict 'refs';
    *{__PACKAGE__ . '::' . $command} = sub {
        unshift @MSG, $command, @_;
        $COMMAND = $command;
        @ARGS = @_;
    }
}

sub commands {
    my $c = shift;
      $c = $c =~ s/^\+// ? $c : "Suspenders::Commands::$c";
    unless (eval "require $c; 1;") {
        die "Cannot load $c: $@";
    }
    $COMMANDS = $c->new;
}

our @EXPORT = get_public_functions();

1;
__END__

=encoding utf-8

=head1 NAME

Suspenders - Server spec checker

=head1 SYNOPSIS

    use Suspenders;

    describe '/etc/passwd' => sub {
        it should be file;
        it should contain 'www-data';
    };

=head1 DESCRIPTION

Suspenders is ...

=head1 TODO

    - more commands

=head1 LICENSE

Copyright (C) tokuhirom.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

tokuhirom E<lt>tokuhirom@gmail.comE<gt>

=cut

