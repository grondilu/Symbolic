unit class Expression;
has Expression @.args;

method evaluate(--> Expression) {
    my @args = @!args».evaluate();
    if @args && any(@args Z[!===] @!args) {
        return self.new(:@args).evaluate();
    }
    return self;
}
