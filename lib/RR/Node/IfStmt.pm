package RR::Node::IfStmt;
use strict;
use parent 'RR::Node';

sub new {
    my ($class, $bool_expr, $if_block) = @_;
    return bless {expr =>$bool_expr,if_block=>$if_block}, $class;
}

sub expr {
    my $self = shift;
    return $self->{expr};
}

sub if_block {
    my $self = shift;
    return $self->{if_block};
}

sub serialize {
    my $self = shift;
    my $depth = shift;
    return 'if ('. $self->expr->serialize($depth) . ") {\n" . $self->if_block->serialize($depth+1). "\n}";
}

sub expr_match {
    my ($self, $ft, $matches) = @_;
    if (ref($self) eq ref($ft) && ref($self) eq 'RR::Node::IfStmt') {
        return $self->expr->match($ft->expr, $matches) && $self->if_block->match($ft->if_block, $matches);
    }
    return;
}

sub recurse {
    my ($self, $ft, $tt, $matches) = @_;

    if ($self->match($ft, $matches)) {
        return $tt->replace($matches);
    }

    return RR::Node::IfStmt->new(
        $self->expr->recurse($ft, $tt, $matches),
        $self->if_block->recurse($ft, $tt, $matches),
    );
}

sub replace {
    my ($self, $matches) = @_;

    return RR::Node::IfStmt->new(
        $self->expr->replace($matches),
        $self->if_block->replace($matches),
    );
}

1;
