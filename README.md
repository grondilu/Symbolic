Symbolic calculus in Perl 6
===========================

This modules exports two classes, `Expression`
and `Identifier`.  The latter inherits
from the latter.  It evals by looking up its
own name in a symbolic table.

`Expression` is directly inspired from
the underlying mechanism behind the core mechanism of the
[Wolfram language](https://en.wikipedia.org/wiki/Wolfram_Language).

See notably the
[standard evaluation procedure](http://reference.wolfram.com/language/tutorial/TheStandardEvaluationProcedure.html).

# Synopsis

    use Symbolic;

    class Operation is Expression {
        method gist {
            self.args.map(-> $arg {
                self.OpWithLowerPrecedence
                .map(-> $C { $arg ~~ $C })
                .any ?? "({$arg.gist})" !! $arg.gist
            })
            .join(self.symbol)
        }
        multi method multiply($) { Operation }
        multi method add($) { Operation }
    }
    class Multiplication is Operation {...}
    class Addition is Operation {...}
    class Variable is Identifier {
        multi method multiply($) { Operation }
        multi method add($) { Operation }
    }

    class Addition {
        method OpWithLowerPrecedence { [] }
        method symbol { '+' }
        method evaluate() {
            self.args[0].add(|self.args[1..*]) || callsame
        }
        multi method multiply(Variable $m) {
            Addition.new(
                :args(
                    self.args.map(
                        { Multiplication.new(:args($_, $m)) }
                    )
                )
            )
        }
    }
    class Multiplication {
        method OpWithLowerPrecedence { [Addition, ] }
        method symbol { '*' }
        method evaluate() {
            self.args[0].multiply(self.args[1]) || callsame
        }
    }

    given Multiplication.new(
        :args(
            Addition.new(
                :args(
                    Variable.new(:name("a")),
                    Variable.new(:name("b"))
                )
            ),
            Variable.new(:name("c"))
        )
    ) {
        .say;              # (a+b)*c
        say .evaluate();   # a*c+b*c
    }

