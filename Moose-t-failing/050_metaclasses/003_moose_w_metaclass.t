#!/usr/bin/perl
# This is automatically generated by author/import-moose-test.pl.
# DO NOT EDIT THIS FILE. ANY CHANGES WILL BE LOST!!!
use t::lib::MooseCompat;

use strict;
use warnings;

use Test::More;
$TODO = q{Mouse is not yet completed};
use Test::Exception;


=pod

This test demonstrates that Mouse will respect
a metaclass previously set with the metaclass
pragma.

It also checks an error condition where that
metaclass must be a Mouse::Meta::Class subclass
in order to work.

=cut


{
    package Foo::Meta;
    use strict;
    use warnings;

    use base 'Mouse::Meta::Class';

    package Foo;
    use strict;
    use warnings;
    use metaclass 'Foo::Meta';
    ::use_ok('Mouse');
}

isa_ok(Foo->meta, 'Foo::Meta');

{
    package Bar::Meta;
    use strict;
    use warnings;

    use base 'Mouse::Meta::Class';

    package Bar;
    use strict;
    use warnings;
    use metaclass 'Bar::Meta';
    eval 'use Mouse;';
    ::ok($@, '... could not load moose without correct metaclass');
    ::like($@,
        qr/^Bar already has a metaclass, but it does not inherit Mouse::Meta::Class/,
        '... got the right error too');
}

done_testing;
