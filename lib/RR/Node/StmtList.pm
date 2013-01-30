package RR::Node::StmtList;
use strict;
use parent 'RR::Node';

sub new {
    my ($class, $lines) = @_;
    return bless {lines => $lines},$class;
}

sub lines {
    my $self = shift;
    return @{$self->{lines}};
}

sub serialize {
    my $self = shift;
    return join(";\n", map {$_->serialize} $self->lines);
}

sub expr_match {
    my ($self, $other, $matches) = @_;

    my @s_lines = $self->lines;
    my @o_lines = $other->lines;

    if (@s_lines != @o_lines) {
        return;
    }

    for (0 .. @s_lines - 1) {
        if (!$s_lines[$_]->match($o_lines[$_], $matches)) {
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

    my @lines;

    for ($self->lines) {
        push @lines, $_->recurse($ft, $tt, $matches);
    }

    return RR::Node::StmtList->new(\@lines);
}

sub replace {
    my ($self, $ft, $tt, $matches) = @_;
    return $self->recurse($ft, $tt, $matches);
}

1;
