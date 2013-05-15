# NAME

Suspenders - Server spec checker

# SYNOPSIS

    use Suspenders;

    describe '/etc/passwd' => sub {
        it should be file;
        it should contain 'www-data';
    };

# DESCRIPTION

Suspenders is ...

# TODO

    - more commands

# LICENSE

Copyright (C) tokuhirom.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

tokuhirom <tokuhirom@gmail.com>
