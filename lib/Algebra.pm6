# inspired from L<http://www.engr.mun.ca/~theo/Misc/exp_parsing.htm>
unit grammar Algebra;

rule TOP { ^^<e>$$ }
rule e { <t>+ % $<sep> = <[+-]> }
rule t { <f>+ % $<sep> = <[*/]> }
rule f { <p>[\^<f>]? }
rule p { <v> | \(<e>\) | <[-+]><t> }
rule v { <ident> | <number> }
rule number { <.integer><.fraction>? }
rule fraction { \.<.digit>+ }
rule integer { <[+-]>? 0 | <[1..9]><.digit>* }
