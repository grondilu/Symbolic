unit module Symbolic;

my subset Identifier of Str where /^^<+ident+[-+*/^]>$$/;
my %symbol-table;

our role Expression is export {
    has ($.head, $.part);
    method length { self.part.elems }
    method fullForm { "{$!head.fullForm}[{$!part».fullForm.join(',')}]" }
    method CALL-ME { $!head()(|$!part».()) }
    method gist { self.fullForm }
}

our class Symbol does Expression is export {
    has Identifier $.name;
    method fullForm { self.name.gist }
    method head { self }
    method part {}
    method CALL-ME { %symbol-table{self.name} // self }
}

our role RawObject does Expression is export {
    method fullForm { self.value.gist }
    method head { self }
    method part {}
    #| From Wolfram's Mathematica documentation,
    #| tutorial on Evaluation:
    #| "If the expression is a raw object (e.g., Integer, String, etc.), leave
    #| it unchanged."
    method CALL-ME { self }
}

our class Integer does RawObject is export { has Int $.value }
our class String  does RawObject is export { has Str $.value }

our sub clear(Identifier $symbol) { %symbol-table{$symbol} :delete }

our sub parse(Str $expression) {
    grammar {
        rule TOP { ^ <root=.expression> $ }
        rule expression { <head=.symbol> <call>* }
        rule call { \[ <part=.expression>+ % \, \] }
        token symbol { <ident> | <number> }
        token number { <.integer><.fraction>? }
        token fraction { \.<.digit>+ }
        token integer { <[+-]>? 0 | <[1..9]><.digit>+ }
    }.parse:
    $expression,
    actions => class {
        method TOP($/) {  make $<root>.made }
        method expression($/) {
            make
            reduce {
                Expression.new:
                :head($^a),
                :part(my @ = map *.made, $^b<part>)
            }, $<head>.made, |$<call>;
        }
        method symbol($/) {
            make $<number> ??
            Integer.new(:value(+$/)) !!
            Symbol.new(:name(~$/))
        }
    }
}

our sub parse-infix(Str $expression) is export {
    use Algebra;
    Algebra.parse: $expression,
    actions => class {
        method TOP($/) { make $<e>.made }
        method e($/) {
            my @signs = $<sep>».Str;
            make reduce {
                Expression.new:
                head => Symbol.new(:name(@signs.shift)),
                part => (my @ = $^a, $^b)
            },
            $<t>».made;
        }
        method t($/) {
            my @signs = $<sep>».Str;
            make reduce {
                Expression.new:
                head => Symbol.new(:name(@signs.shift)),
                part => (my @ = $^a, $^b)
            },
            $<f>».made;
        }
        method f($/) {
            my $p = $<p>.made;
            make !$<f> ?? $p !!
            Expression.new:
            head => Symbol.new(:name<^>),
            part => (my @ = $p, $<f>.made)
        }
        method p($/) {
            make
            $<e> ?? $<e>.made !!
            $<v> ?? $<v>.made !!
            $<t> ?? Expression.new(
                head => Symbol.new(:name<->),
                part => (my @ = $<t>.made)
            ) !! die "unexpected case"
        }
        method v($/) {
            make $<ident> ?? Symbol.new(:name(~$/)) !!
            $<number> ?? Integer.new(:value(+$/)) !!
            die "unexpected case"
        }
    }
}

