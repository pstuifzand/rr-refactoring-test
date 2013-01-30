package RR::Node::Var;
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
    if (ref($self) eq ref($ft)) {
        return $self->{var} eq $ft->{var};
    }
    return;
}

sub replace {
    my $self = shift;
    return $self;
}

sub recurse {
    my ($self, $ft, $tt, $matches) = @_;
    if ($self->match($ft, $matches)) {
        return $tt->replace($matches);
    }
    return RR::Node::Var->new($self->var);
}

1;
