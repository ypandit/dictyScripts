
use strict;

package CodonUsage;

use Bio::Chado::Schema;
use Moose;
use MooseX::Attribute::Dependent;

has [qw/dsn user password/] => (
    is      => 'rw',
    isa     => 'Str',
    default => '',
    lazy    => 1,
);

has schema => (
    is      => 'ro',
    isa     => 'Bio::Chado::Schema',
    default => sub {
        my ($self) = @_;
        Bio::Chado::Schema->connect( $self->dsn, $self->user,
            $self->password, { LongReadLen => 2**25 } );
    },
    lazy       => 1,
    dependency => All [ 'dsn', 'user', 'password' ]

);

sub run {
    my ($self) = @_;
}

1;

package main;
