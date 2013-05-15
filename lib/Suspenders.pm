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

sub describe {
    my ($stuff, $code) = @_;
    local $STUFF = $stuff;
    $code->();
}

sub it {
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    my ($ret, $msg) = $_[0]->test($STUFF);
    $builder->ok($ret, $msg);
}

sub should($) { $_[0] }

sub be($) { $_[0] }

sub not($) { Suspenders::Not->new(orig => $_[0]) }

sub contain($) { Suspenders::Contain->new(text => shift) }

sub file() { Suspenders::File->new() }

package Suspenders::Util {
    sub slurp {
        my $fname = shift;
        open my $fh, '<', $fname
            or die "Cannot open $fname for reading: $!";
        do { local $/; <$fh> };
    }
}

package Suspenders::Not {
    use Moo;

    has orig => ( is => 'ro');

    no Moo;

    sub test {
        my ($self, $stuff) = @_;
        my ($ret, $msg) = $self->orig->test($stuff);
        $msg =~ s/ should / should not /;
        return (!$ret, $msg);
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

