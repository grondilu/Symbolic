use Algebra;

use Test;

plan *;

ok Algebra.parse($_), $_ for
<1 12 2 pi -x +x 1+2 1+2+3 2*2 3*(2+1)
(1+1)*2
(1+1)*2*3
>;

# vim: ft=perl6
