package Suspenders;
use 5.012;
use strict;
use warnings;
use parent qw(Exporter);
use Test::More ();

our $VERSION = "0.01";

our @EXPORT = qw( it should be file describe not contain );

my $builder = Test::More->builder;

our $STUFF;
our $NOT;
our $COMMAND;
our @ARGS;
our @MSG;

sub describe {
    my ($stuff, $code) = @_;
    local $STUFF = $stuff;
    local $NOT = 0;
    local $COMMAND;
    Test::More::note("------------------------------------------\n$stuff");
    $code->();

}

sub it {
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    unshift @MSG, 'it';
    Suspenders::Backend::Exec->new()->run();
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

package Suspenders::Backend::Exec {
    use Moo;
    no Moo;

    sub run {
        my $cmd = $Suspenders::COMMAND
            or die "Invalid sequence";
        my $code = Suspenders::Commands->can($cmd)
            or die "Unknown command: '$cmd'";
        my $cmdline = $code->($STUFF, @ARGS);
        my $retval = system($cmdline);
        $builder->ok($Suspenders::NOT ? $retval != 0 : $retval == 0, join(' ', @Suspenders::MSG));
    }
}

package Suspenders::Commands {
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
}

package Suspenders::Contain {
    use Moo;
    has text => (is => 'ro');
    no Moo;

    sub test {
        my ($self, $stuff) = @_;
        return (index(Suspenders::Util::slurp($stuff), $self->text) >= 0, "'$stuff' should contain '@{[ $self->text ]}'");
    }
}

package Suspenders::File {
    use Moo;
    no Moo;

    sub test {
        my ($self, $stuff) = @_;
        return (-f $stuff, "'$stuff' should be file");
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

=head1 LICENSE

Copyright (C) tokuhirom.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

tokuhirom E<lt>tokuhirom@gmail.comE<gt>

=cut

