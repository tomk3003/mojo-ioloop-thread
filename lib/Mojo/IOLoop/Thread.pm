package Mojo::IOLoop::Thread;
use Mojo::Base -base;

our $VERSION = "0.01";

use threads;

use Scalar::Util qw(weaken);
use Mojo::IOLoop;

BEGIN {
    ## no critic ( PrivateSubs )
    Mojo::Base::_monkey_patch 'Mojo::IOLoop', subprocess => sub {
        my $thr = Mojo::IOLoop::Thread->new;
        weaken $thr->ioloop(Mojo::IOLoop::_instance(shift))->{ioloop};
        return $thr->run(@_);
    }
}

use Carp 'croak';
use Config;
use Storable;
use YAML qw(Dump);

has deserialize => sub { \&Storable::thaw };
has ioloop      => sub { Mojo::IOLoop->singleton };
has serialize   => sub { \&Storable::freeze };
has pid         => sub { $$ };

sub run {
  my ($self, $child, $parent) = @_;

  my($thr) = threads->create(
    {'exit' => 'thread_only'},
    sub {
      $self->ioloop->reset;
      my $results = eval { [$self->$child] } || [];
      return $@, $results;
    }
  );

  my($err, $results) = $thr->join();

  $self->$parent($err, @$results);

  return $self;
}

1;

__END__

=encoding utf-8

=head1 NAME

Mojo::IOLoop::Thread - Threaded Replacement for Mojo::IOLoop::subprocess

=head1 SYNOPSIS

    use Mojo::IOLoop::Thread;

=head1 DESCRIPTION

Mojo::IOLoop::Thread is ...

=head1 AUTHOR

Thomas Kratz E<lt>tomk@cpan.orgE<gt>

=head1 REPOSITORY

L<https://github.com/tomk3003/mojo-ioloop-thread>

=head1 COPYRIGHT

Copyright 2017 Thomas Kratz.

=head1 LICENSE

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=cut
