package RR;
use strict;
use Marpa::R2 2.042000;
use Data::Dumper;

use base 'Exporter';
our @EXPORT_OK = qw/replace/;

sub new {
    my ($class) = @_;

    my $self = bless {}, $class;

    $self->{grammar} = Marpa::R2::Scanless::G->new(
        {
            action_object  => 'RR::Actions',
            default_action => 'do_first_arg',
            source         => \(<<'END_OF_SOURCE'),

:start         ::= script

script         ::= expression+                       action => do_stmt_list separator => semicolon proper => 0

expression     ::= number                            action => do_num
                 | variable                          action => do_var
                 | tree_var                          action => do_tree_var
                 | '!' expression                    action => do_not assoc => left
                 | '(' expression ')'                assoc => group action => do_arg1
                 | expression '(' args ')'           action => do_func
                 | expression '[' args ']'           action => do_array
                || expression '&' expression         action => do_expr
                 | expression '|' expression         action => do_expr
                || expression '*' expression         action => do_expr
                 | expression '/' expression         action => do_expr
                 | expression '%' expression         action => do_expr
                || expression '+' expression         action => do_expr
                 | expression '-' expression         action => do_expr
                || expression '<' expression         action => do_expr
                 | expression '>' expression         action => do_expr
                 | expression '<=' expression        action => do_expr
                 | expression '>=' expression        action => do_expr
                 | expression '==' expression        action => do_expr
                 | expression '!=' expression        action => do_expr
                || expression '||' expression        action => do_expr
                || expression '&&' expression        action => do_expr

args           ::= expression*                       action => do_list separator => comma 

comma          ~ ','
semicolon      ~ ';'
number         ~ [\d]+
tree_var       ~ ':' tree_var_1
variable       ~ [_a-z]+
tree_var_1     ~ [_a-z]+

:discard       ~ whitespace
whitespace     ~ [\s]+
END_OF_SOURCE

        }
    );
    return $self;
}

sub parse {
    my ($self, $string) = @_;
    my $re = Marpa::R2::Scanless::R->new( { grammar => $self->{grammar} } );
    $re->read(\$string);
    my $value_ref = $re->value();
    return ${$value_ref};
}

sub parse_rr {
    my ($string) = @_;
    my $parser = RR->new();
    return $parser->parse($string);
}

sub replace {
    my ($source, $from, $to) = @_;
    my $st = parse_rr($source);
    my $ft = parse_rr($from);
    my $tt = parse_rr($to);
    my %matches;
    my $tree = $st->recurse($ft, $tt, \%matches);
    return serialize($tree);
}

sub serialize {
    my ($tree) = @_;
    return $tree->serialize;
}

package RR::Actions;
use strict;
use Data::Dumper;

use RR::Node::Number;
use RR::Node::Var;
use RR::Node::TVar;
use RR::Node::Tree;
use RR::Node::Op;
use RR::Node::UnaryOp;
use RR::Node::Call;
use RR::Node::Array;
use RR::Node::StmtList;

sub new {
    my ($class) = @_;
    return bless {}, $class;
}

sub do_first_arg {
    shift;
    return $_[0];
}

sub do_num {
    shift;
    return RR::Node::Number->new($_[0]);
}

sub do_var {
    shift;
    return RR::Node::Var->new($_[0]);
}

sub do_tree_var {
    shift;
    return RR::Node::Tree->new($_[0]);
}

sub do_expr {
    shift;
    return RR::Node::Op->new($_[1], $_[0], $_[2]);
}

sub do_stmt_list {
    shift;
    if (@_ == 1) {
        return $_[0];
    }
    return RR::Node::StmtList->new(\@_);
}

sub do_list {
    shift;
    return \@_;
}

sub do_null {
    return undef;
}

sub do_join {
    shift;
    return join '', @_;
}

sub do_func {
    shift;
    return RR::Node::Call->new($_[0], $_[2]);
}

sub do_array {
    shift;
    return RR::Node::Array->new($_[0], $_[2]);
}

sub do_arg1 {
    shift;
    return $_[1];
}

sub do_not {
    shift;
    return RR::Node::UnaryOp->new($_[0], $_[1]);
}


1;
