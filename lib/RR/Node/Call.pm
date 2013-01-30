package RR::Node::Call;
use strict;
use parent 'RR::Node';

sub new {
    my ($class, $name, $args) = @_;
    my $self = {
        name => $name,
        args => $args || [],
    };
    return bless $self, $class;
}

sub name {
    my $self = shift;
    return $self->{name};
}

sub args {
    my $self = shift;
    return @{$self->{args}};
}

sub serialize {
    my $self = shift;
    return $self->name->serialize . '(' . join(', ', map { $_->serialize } $self->args) . ')';
}

sub expr_match {
    my ($self, $ft, $matches) = @_;

    if (!$self->name->match($ft->name, $matches)) {
        return;
    }

    my @a_args = $self->args;
    my @b_args = $ft->args;

    if (@a_args != @b_args) {
        return;
    }

    for (0 .. @a_args-1) {
        if (!$a_args[$_]->match($b_args[$_], $matches)) {
            return;
        }
    }

    return 1;
}

sub recurse {
    my ($self, $ft, $tt, $matches) = @_;

    if ($self->match($ft, $matches)) {
        return $tt->replace($matches);
    }

    return RR::Node::Call->new(
        $self->name->recurse($ft, $tt, $matches),
        [ map { $_->recurse($ft, $tt, $matches) } $self->args ]
    );
}

sub replace {
    my ($self, $matches) = @_;
    return RR::Node::Call->new(
        $self->name->replace($matches),
        [ map { $_->replace($matches) } $self->args ]
    );
}

1;
