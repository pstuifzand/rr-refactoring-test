package RR::Node::UnaryOp;
use strict;
use parent 'RR::Node';

sub new {
    my ($class, $op, $left) = @_;
    return bless {op=>$op,l=>$left}, $class;
}
sub left {
    my $self = shift;
    return $self->{l};
}

sub op {
    my $self = shift;
    return $self->{op};
}

sub serialize {
    my $self = shift;
    return $self->op . $self->left->serialize;
}

sub expr_match {
    my ($self, $ft, $matches) = @_;

    return $self->op eq $ft->op
        && ($self->left->match($ft->left, $matches) || $self->left->match($ft->right, $matches));
}

sub recurse {
    my ($self, $ft, $tt, $matches) = @_;

    if ($self->match($ft, $matches)) {
        return $tt->replace($matches);
    }

    return RR::Node::UnaryOp->new(
        $self->op,
        $self->left->recurse($ft, $tt, $matches),
    );
}

sub replace {
    my ($self, $matches) = @_;
    return RR::Node::UnaryOp->new(
        $self->op,
        $self->left->replace($matches),
    );
}

1;
