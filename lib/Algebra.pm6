use Symbolic;
unit module Algebra;
class RealVariable is Identifier is export {
    method Str { self.name }
}
constant ZERO = RealVariable.new(:name("0"));
constant ONE = RealVariable.new(:name("1"));
constant MINUS_ONE = RealVariable.new(:name("-1"));

class MultiVector is Expression is export {
    proto method add     (MultiVector $ --> MultiVector) {*}
    proto method subtract(MultiVector $ --> MultiVector) {*}
    proto method multiply(MultiVector $ --> MultiVector) {*}
    proto method divide  (MultiVector $ --> MultiVector) {*}
    proto method cdot    (MultiVector $ --> MultiVector) {*}
    proto method wedge   (MultiVector $ --> MultiVector) {*}
    proto method power   (MultiVector $ --> MultiVector) {*}

    multi method cdot    ($m)                  { MultiVector }
    multi method wedge   ($m)                  { MultiVector }
}

class Number is MultiVector does Real {
    multi method add     ($m where * == 0)     { $m;   }
    multi method add     ($  where * == 0: $m) { $m;   }
    multi method subtract($m where * == 0)     { $m;   }
    multi method multiply($m where * == 1)     { $m;   }
    multi method multiply($  where * == 0)     { ZERO; }
    multi method multiply($  where * == 1: $m) { $m;   }
    multi method divide  ($m where * == 1)     { $m;   }
}
class Fraction is Number is export {
    has Rat $.rat handles <Bridge nude Str>;
    multi method new(Rat $rat) { self.new :$rat }
}
class Integer is Fraction is export {
    multi method new(Int $n) {
        self.new: :rat($n.Rat);
    }
}

ZERO.assign(Integer.new(0));
ONE.assign(Integer.new(1));
MINUS_ONE.assign(Integer.new(-1));

