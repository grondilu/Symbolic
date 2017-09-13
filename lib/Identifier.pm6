use Expression;
unit class Identifier is Expression;
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
