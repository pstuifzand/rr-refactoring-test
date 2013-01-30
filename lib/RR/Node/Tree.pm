package RR::Node::Tree;
use strict;
use parent 'RR::Node';

sub new {
    my ($class, $var) = @_;
    return bless {var => $var}, $class;
}

sub var {
    my $self = shift;
    return $self->{var};
}

sub serialize {
    my $self = shift;
    return $self->{var};
}

sub expr_match {
    my ($self, $ft, $matches) = @_;
    $matches->{$self->var} = $ft;
    return 1;
}

sub recurse {
    my ($self, $ft, $tt, $matches) = @_;
    return $self;
}

sub replace {
    my ($self, $matches) = @_;
    return $matches->{$self->var};
}

1;
