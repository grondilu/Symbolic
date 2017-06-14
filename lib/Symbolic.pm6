unit module Symbolic;

my subset Identifier of Str where /^^<ident>$$/;
my %symbol-table;

our role Expression is export {
    method head {...}
    method part(--> Array) {...}
    method length { self.part.elems }
    #method TeXForm {...}
    #method MathMLForm {...}
    method CALL-ME { self.head()(|self.part».()) }
}

our class Symbol does Expression is export {
    has Identifier $.name handles <Str>;
    method head { self }
    method part {}
    method CALL-ME { %symbol-table{self.name} // self }
}

our role RawObject does Expression is export {
    method head { self }
    method part {}
    #| From Wolfram's Mathematica documentation,
    #| tutorial on Evaluation:
    #| "If the expression is a raw object (e.g., Integer, String, etc.), leave
    #| it unchanged."
    method CALL-ME { self }
}

our class Number does RawObject is export { has Real $.value handles <Str> }
our class String does RawObject is export { has Str $.value handles <Str> }

our sub clear(Identifier $symbol) { %symbol-table{$symbol} :delete }

our subset NakedPair of Pair is export where { .value === True }

multi prefix:<+>(NakedPair $x --> Symbol) is export {
    Symbol.new: name => $x.key;
}

class BinaryExpression does Expression {
    has Str $.name;
    has ($.left, $.right);
    method head { Symbol.new: :$!name }
    method part { [ $!left, $!right ] }
    method Str { "{self.head}[{self.part.join(',')}]" }
}

#multi infix:<+>(Real $value, NakedPair $b --> Expression) is export {
#    BinaryExpression.new: :name<Plus>, :left(Number.new: :$value), :right(+$b)
#}
#multi infix:<+>(NakedPair $a, Real $value --> Expression) is export {
#    BinaryExpression.new: :name<Plus>, :left(+$a), :right(Number.new: :$value)
#}
multi infix:<+>(NakedPair $a, NakedPair $b --> Expression) is export {
    BinaryExpression.new: :name<Plus>, :left(+$a), :right(+$b)
}
multi infix:<+>(NakedPair $a, Expression $right --> Expression) is export {
    BinaryExpression.new: :name<Plus>, :left(+$a), :$right
}
multi infix:<+>(Expression $left, NakedPair $b --> Expression) is export {
    BinaryExpression.new: :name<Plus>, :$left, :right(+$b)
}
multi infix:<+>(Expression $left, Expression $right --> Expression) is export {
    BinaryExpression.new: :name<Plus>, :$left, :$right
}

multi infix:<*>(NakedPair $a, NakedPair $b --> Expression) is export {
    BinaryExpression.new: :name<Times>, :left(+$a), :right(+$b)
}
multi infix:<*>(NakedPair $a, Expression $right --> Expression) is export {
    BinaryExpression.new: :name<Times>, :left(+$a), :$right
}
multi infix:<*>(Expression $left, NakedPair $b --> Expression) is export {
    BinaryExpression.new: :name<Times>, :$left, :right(+$b)
}
multi infix:<*>(Expression $left, Expression $right --> Expression) is export {
    BinaryExpression.new: :name<Times>, :$left, :$right
}


multi infix:<**>(NakedPair $a, NakedPair $b --> Expression) is export {
    BinaryExpression.new: :name<Power>, :left(+$a), :right(+$b)
}
multi infix:<**>(NakedPair $a, Expression $right --> Expression) is export {
    BinaryExpression.new: :name<Power>, :left(+$a), :$right
}
multi infix:<**>(Expression $left, NakedPair $b --> Expression) is export {
    BinaryExpression.new: :name<Power>, :$left, :right(+$b)
}
multi infix:<**>(Expression $left, Expression $right --> Expression) is export {
    BinaryExpression.new: :name<Power>, :$left, :$right
}



