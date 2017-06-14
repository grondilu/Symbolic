Symbolic calculus in Perl 6
===========================

This module is inspired from [Wolfram Language](http://www.wolfram.com/language/).

# Synopsis

    use Symbolic;

    # To enter raw symbols, use naked pairs
    .say for
        :x,
        :a + :b,
        :a**2,
        (:a+:b)*(:a-:b),

    # To force conversion into a Symbol object, use &prefix:<+>
    say +:x;

**THIS IS A WORK IN PROGRESS, DON'T EXPECT MUCH**

