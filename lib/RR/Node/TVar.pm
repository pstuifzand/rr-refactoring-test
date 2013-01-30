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
    return 1;
    #return $self->var eq $ft->var;
    #$matches->{$self->var} = $ft;
    #return 1;
}

sub recurse {
    my ($self, $ft, $tt, $matches) = @_;
    return $tt->replace($matches);
}

sub replace {
    my ($self, $matches) = @_;
    if (exists $matches->{$self->var}) {
        return $matches->{$self->var};
    }
    return $self;
}

1;
