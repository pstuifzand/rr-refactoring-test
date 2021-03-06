use lib 'lib';
use RR 'replace';

my $source = <<"SOURCE";
is_greater_than(x, 11) && is_smaller_than(x, 30) || is_greater_than(x,1000) > 10;
10 > x;
x > 1 && x < 10-1;
x&1==1;
x&1+1;
x=y=x[n];

if (x > 10) {
    if (y > 10) {
        x = 10;
    };
    if (x < y) {
        x = y;
    };
};
SOURCE

$source = replace($source, 'is_smaller_than(:a,:b)', ':a < :b');
$source = replace($source, 'is_greater_than(:a,:b)', ':a > :b');
$source = replace($source, ':a & :b', ':a | :b');
$source = replace($source, 'if (:a > 10) { :b }', 'if (:a > 99) { :b }');

print $source ."\n";

