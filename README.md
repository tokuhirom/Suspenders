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

# HOW CAN I ADD TESTING STUFF?

You can add any testing stuff by two steps.

- Add it to Suspenders::Commands::\*
- Add it to @EXPORTABLE\_COMMANDS in Suspenders.pm

# ENVIRONMENT VARIABLES

- SUSPENDERS\_VERBOSE

# TODO

    - more commands

# LICENSE

Copyright (C) tokuhirom.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

tokuhirom <tokuhirom@gmail.com>
