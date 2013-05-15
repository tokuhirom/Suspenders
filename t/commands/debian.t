use strict;
use warnings;
use utf8;
use Suspenders;

unless (-f '/etc/debian_version') {
    skip_all 'This test requires debian linux';
}

commands 'Debian';

describe 'httpd' => sub {
    it should not be installed;
};

describe 'coreutils' => sub {
    it should be installed;
};
