unit grammar Algebra;
rule TOP     { ^^ <Exp> $$ }
rule Exp     { <Sum> }
rule Sum     { <Product>+ % <[+-]> }
rule Product { <[+-]>?<Power>+   % <[*/]> }
rule Power   { <Value> ** 1..2 % '**'    }
rule Value   { <Symbol> | '('<Exp>')' }
token Symbol { <ident> | <digit>+ }
