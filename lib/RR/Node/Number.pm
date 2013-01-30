package RR::Node::Number;
use strict;
use parent 'RR::Node';

sub new {
    my ($class,$number) = @_;
    return bless {number => $number}, $class;
}

sub number {
    my $self = shift;
    return $self->{number};
}

sub serialize {
    my $self = shift;
    return $self->{number};
}

sub expr_match {
    my ($self, $ft, $matches) = @_;
    if (ref($self) eq ref($ft)) {
        return $self->number == $ft->number;
    }
    return;
}

sub recurse {
    my ($self, $ft, $tt, $matches) = @_;
    if ($self->match($ft, $matches)) {
        return $tt->replace($matches);
    }
    return RR::Node::Number->new($self->number);
}

sub replace {
    my ($self, $matches) = @_;
    return $self;
}

1;
