package RR::Node::Op;
use strict;
use parent 'RR::Node';
use Carp;

sub new {
    my ($class, $op, $left, $right) = @_;
    confess "op == undef" if !defined $op;
    confess "left == undef" if !defined $left;
    confess "right == undef" if !defined $right;
    return bless {op =>$op,l=>$left,r=>$right}, $class;
}

sub left {
    my $self = shift;
    return $self->{l};
}

sub right {
    my $self = shift;
    return $self->{r};
}

sub op {
    my $self = shift;
    return $self->{op};
}

sub serialize {
    my $self = shift;
    my $depth = shift;
    return '('. $self->left->serialize . ' ' . $self->op . ' ' . $self->right->serialize .')';
}

sub expr_match {
    my ($self, $ft, $matches) = @_;

    return $self->op eq $ft->op
        && (($self->left->match($ft->left, $matches) && $self->right->match($ft->right, $matches))
            ||
            ($self->left->match($ft->right, $matches) && $self->right->match($ft->left, $matches)));
}

sub recurse {
    my ($self, $ft, $tt, $matches) = @_;

    if ($self->match($ft, $matches)) {
        return $tt->replace($matches);
    }

    return RR::Node::Op->new(
        $self->op,
        $self->left->recurse($ft, $tt, $matches),
        $self->right->recurse($ft, $tt, $matches),
    );
}

sub replace {
    my ($self, $matches) = @_;
    return RR::Node::Op->new(
        $self->op,
        $self->left->replace($matches),
        $self->right->replace($matches),
    );
}

1;
