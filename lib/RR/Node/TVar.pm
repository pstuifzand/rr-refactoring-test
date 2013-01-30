package RR::Node::TVar;
use strict;
use parent 'RR::Node';

sub new {
    my ($class,$var) = @_;
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

    if ($self->var eq $ft->var) {
        return $tt;
    }

    return $self;
}

sub replace {
    my ($self, $matches) = @_;
    return $matches->{$self->var};
}

1;
