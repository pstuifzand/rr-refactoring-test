
use lib 'lib';
use RR 'replace';

my $source = <<"SOURCE";
is_greater_than(x, 11) && is_smaller_than(x, 30) || is_bigger_than(x,1000) > 10;
10 > x;
x > 1 && x < 10-1;
x&1==1;
x&1+1;
x[n+1,10][test/2];
x[n];
SOURCE

$source = replace($source, 'is_smaller_than(:a,:b)', ':a < :b');
$source = replace($source, 'is_greater_than(:a,:b)', ':a > :b');
$source = replace($source, 'is_bigger_than(:a,:b)', ':a > :b');
$source = replace($source, ':a & :b', ':a | :b');
$source = replace($source, 'test/2', 'test/3');

print $source ."\n";

