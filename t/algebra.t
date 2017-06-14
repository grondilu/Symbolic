use Symbolic;

use Test;
plan *;

# Stringification
is (+:a).Str, 'a';
is (:a + :b).Str, 'Plus[a,b]';
is (:a * :b).Str, 'Times[a,b]';
is (:a*(:b+:c)).Str, 'Times[a,Plus[b,c]]';
is (:a**:x).Str,   'Power[a,x]';

# vim: ft=perl6
