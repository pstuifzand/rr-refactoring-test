
use lib 'lib';
use RR 'replace';

my $source = <<"SOURCE";
10 + power(10,2);
10 + 11;
10 + (12 + 11)
SOURCE

my $newsource = replace($source, '10 + :a', ':a + 10');
print $newsource ."\n";

