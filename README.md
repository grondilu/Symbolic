Symbolic calculus in Perl 6
===========================

This module is inspired from [Wolfram Language](http://www.wolfram.com/language/).

# parsing infix expressions

    use Symbolic;
    say parse-infix "1+2";   # +[1, 2]
    say parse-infix "1+x^2";   # +[1, ^[x, 2]]

**THIS IS A WORK IN PROGRESS, DON'T EXPECT MUCH**



