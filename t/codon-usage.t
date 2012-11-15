
use Test::More qw/no_plan/;
use Test::Moose;

BEGIN { require_ok('CodonUsage.pl'); }

my $test_cu = CodonUsage->new;
has_attribute_ok( $test_cu, $_, "..has $_ attribute" )
    for qw/dsn user password schema/;
can_ok( $test_cu, 'run' );
