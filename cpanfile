requires 'perl', '5.008001';
requires 'String::ShellQuote';
requires 'parent';
requires 'Module::Functions', 'v2.1.2';
requires 'IPC::Run';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

