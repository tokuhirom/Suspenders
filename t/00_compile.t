use strict;
use warnings;
use utf8;
use Test::More;

for (qw(
    Suspenders::Backend::Exec
    Suspenders::Backend::SSH
)) {
    eval "require $_";
    ok(!$@, $_) or diag $@;
}

done_testing;

