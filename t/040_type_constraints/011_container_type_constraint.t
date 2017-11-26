#!/usr/bin/perl
# This is automatically generated by author/import-moose-test.pl.
# DO NOT EDIT THIS FILE. ANY CHANGES WILL BE LOST!!!
use lib "t/lib";
use MooseCompat;

use strict;
use warnings;

use Test::More;
use Test::Exception;

BEGIN {
    use_ok('Mouse::Util::TypeConstraints');
    use_ok('Mouse::Meta::TypeConstraint');
}

# Array of Ints

my $array_of_ints = Mouse::Meta::TypeConstraint->new(
    name           => 'ArrayRef[Int]',
    parent         => find_type_constraint('ArrayRef'),
    type_parameter => find_type_constraint('Int'),
);
isa_ok($array_of_ints, 'Mouse::Meta::TypeConstraint');
isa_ok($array_of_ints, 'Mouse::Meta::TypeConstraint');

ok($array_of_ints->check([ 1, 2, 3, 4 ]), '... [ 1, 2, 3, 4 ] passed successfully');
ok(!$array_of_ints->check([qw/foo bar baz/]), '... [qw/foo bar baz/] failed successfully');
ok(!$array_of_ints->check([ 1, 2, 3, qw/foo bar/]), '... [ 1, 2, 3, qw/foo bar/] failed successfully');

ok(!$array_of_ints->check(1), '... 1 failed successfully');
ok(!$array_of_ints->check({}), '... {} failed successfully');
ok(!$array_of_ints->check(sub { () }), '... sub { () } failed successfully');

# Hash of Ints

my $hash_of_ints = Mouse::Meta::TypeConstraint->new(
    name           => 'HashRef[Int]',
    parent         => find_type_constraint('HashRef'),
    type_parameter => find_type_constraint('Int'),
);
isa_ok($hash_of_ints, 'Mouse::Meta::TypeConstraint');
isa_ok($hash_of_ints, 'Mouse::Meta::TypeConstraint');

ok($hash_of_ints->check({ one => 1, two => 2, three => 3 }), '... { one => 1, two => 2, three => 3 } passed successfully');
ok(!$hash_of_ints->check({ 1 => 'one', 2 => 'two', 3 => 'three' }), '... { 1 => one, 2 => two, 3 => three } failed successfully');
ok(!$hash_of_ints->check({ 1 => 'one', 2 => 'two', three => 3 }), '... { 1 => one, 2 => two, three => 3 } failed successfully');

ok(!$hash_of_ints->check(1), '... 1 failed successfully');
ok(!$hash_of_ints->check([]), '... [] failed successfully');
ok(!$hash_of_ints->check(sub { () }), '... sub { () } failed successfully');

# Array of Array of Ints

my $array_of_array_of_ints = Mouse::Meta::TypeConstraint->new(
    name           => 'ArrayRef[ArrayRef[Int]]',
    parent         => find_type_constraint('ArrayRef'),
    type_parameter => $array_of_ints,
);
isa_ok($array_of_array_of_ints, 'Mouse::Meta::TypeConstraint');
isa_ok($array_of_array_of_ints, 'Mouse::Meta::TypeConstraint');

ok($array_of_array_of_ints->check(
    [[ 1, 2, 3 ], [ 4, 5, 6 ]]
), '... [[ 1, 2, 3 ], [ 4, 5, 6 ]] passed successfully');
ok(!$array_of_array_of_ints->check(
    [[ 1, 2, 3 ], [ qw/foo bar/ ]]
), '... [[ 1, 2, 3 ], [ qw/foo bar/ ]] failed successfully');

{
    my $anon_type = Mouse::Util::TypeConstraints::find_or_parse_type_constraint('ArrayRef[Foo]');
    isa_ok( $anon_type, 'Mouse::Meta::TypeConstraint' );

    my $param_type = $anon_type->type_parameter;
    isa_ok( $param_type, 'Mouse::Meta::TypeConstraint' );
}

done_testing;
