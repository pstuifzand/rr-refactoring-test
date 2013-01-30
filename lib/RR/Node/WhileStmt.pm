package RR::Node::WhileStmt;
use strict;
use parent 'RR::Node';

sub new {
    my ($class, $bool_expr, $block) = @_;
    return bless {expr =>$bool_expr,block=>$block}, $class;
}

sub expr {
    my $self = shift;
    return $self->{expr};
}

sub block {
    my $self = shift;
    return $self->{block};
}

sub serialize {
    my $self = shift;
    my $depth = shift;
    return 'while ('. $self->expr->serialize($depth) . ") {\n" . $self->block->serialize($depth+1). "\n}";
}

sub expr_match {
    my ($self, $ft, $matches) = @_;
    return $self->expr->match($ft->expr) && $self->block->match($ft->block);
}

sub recurse {
    my ($self, $ft, $tt, $matches) = @_;

    if ($self->match($ft, $matches)) {
        return $tt->replace($matches);
    }

    return ref($self)->new(
        $self->expr->recurse($ft,$tt,$matches),
        $self->block->recurse($ft, $tt, $matches),
    );
}

sub replace {
    my ($self, $matches) = @_;
    return RR::Node::WhileStmt->new(
        $self->expr->recurse($matches),
        $self->block->recurse($matches),
    );
}

1;
