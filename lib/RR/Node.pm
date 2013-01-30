package RR::Node;
use strict;

use Data::Dumper;

sub match {
    my ($self, $b, $matches) = @_;

    if (ref($b) eq 'RR::Node::Tree') {
        return $b->match($self, $matches);
    }
    my $res = eval { $self->expr_match($b, $matches) };
    if ($@) {
        #warn "Failed: $@";
        return;
    }
    return $res;
}

sub op {
    return;
}

1;
