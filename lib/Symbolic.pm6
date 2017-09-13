unit module Symbolic;

class Expression is export {
    has Expression @.args;

    method evaluate(--> Expression) {
        my @args = @!args».evaluate();
        if @args && any(@args Z[!===] @!args) {
            return self.new(:@args).evaluate();
        }
        return self;
    }
}

class Identifier is Expression is export {
    my Expression %table;

    has Str $.name handles <gist>;
    submethod BUILD(Str :$name) {
        %table{$!name = $name} //= self;
    }
    method evaluate(--> Expression) {
        return %table{self.name} || callsame;
    }
    method assign(Expression $value) {
        %table{$!name} = $value;
    }
}
