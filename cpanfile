requires 'perl', '5.008001';
requires 'Mojolicious', '7.35';
requires 'YAML';

on 'test' => sub {
    requires 'Test::More', '0.98';
};
