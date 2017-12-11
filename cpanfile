requires 'perl', '5.008001';

on 'build' => sub {
    unless ($^O eq "MSWin32" || $^O eq "cygwin") {
        die "OS unsupported\n";
    }
};

on 'test' => sub {
    requires 'Test::More', '0.98';
};

