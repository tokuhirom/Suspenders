use strict;
use warnings;
use utf8;
use Test::More;
use Suspenders;

describe 'cpanfile' => sub {
    it should be file;
    it should contain 'Test::More';
    it should not contain 'Acme::Dot';
};

describe 'no-file' => sub {
    it should not be file;
};

done_testing;

