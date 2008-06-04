#!perl
package Mouse;
use strict;
use warnings;

our $VERSION = '0.01';

use Sub::Exporter;
use Carp 'confess';
use Scalar::Util 'blessed';

use Mouse::Attribute;
use Mouse::Class;
use Mouse::Object;

do {
    my $CALLER;

    my %exports = (
        meta => sub {
            my $meta = Mouse::Class->initialize($CALLER);
            return sub { $meta };
        },

        extends => sub {
            my $caller = $CALLER;
            return sub {
                $caller->meta->superclasses(@_);
            };
        },

        has => sub {
            return sub {
                my $package = caller;
                my $names = shift;
                $names = [$names] if !ref($names);

                for my $name (@$names) {
                    Mouse::Attribute->create($package, $name, @_);
                }
            };
        },

        confess => sub {
            return \&Carp::confess;
        },

        blessed => sub {
            return \&Scalar::Util::blessed;
        },
    );

    my $exporter = Sub::Exporter::build_exporter({
        exports => \%exports,
        groups  => { default => [':all'] },
    });

    sub import {
        $CALLER = caller;

        strict->import;
        warnings->import;

        no strict 'refs';
        @{ $CALLER . '::ISA' } = 'Mouse::Object';

        goto $exporter;
    }

    sub unimport {
        my $caller = caller;

        no strict 'refs';
        for my $keyword (keys %exports) {
            next if $keyword eq 'meta'; # we don't delete this one
            delete ${ $caller . '::' }{$keyword};
        }
    }
};

sub load_class {
    my $class = shift;

    (my $file = "$class.pm") =~ s{::}{/}g;

    eval { CORE::require($file) };
    confess "Could not load class ($class) because : $@"
        if $@
        && $@ !~ /^Can't locate .*? at /;

    return 1;
}

1;

__END__

=head1 NAME

Mouse - miniature Moose near the speed of light

=head1 VERSION

Version 0.01 released ???

=head1 SYNOPSIS

    package Point;
    use Mouse;

    has x => (
        is => 'rw',
    );

    has y => (
        is        => 'rw',
        default   => 0,
        predicate => 'has_y',
        clearer   => 'clear_y',
    );

=head1 DESCRIPTION

Moose.

=head1 INTERFACE

=head2 meta -> Mouse::Class

Returns this class' metaclass instance.

=head2 extends superclasses

Sets this class' superclasses.

=head2 has (name|names) => parameters

Adds an attribute (or if passed an arrayref of names, multiple attributes) to
this class.

=head2 confess error -> BOOM

L<Carp/confess> for your convenience.

=head2 blessed value -> ClassName | undef

L<Scalar::Util/blessed> for your convenience.

=head1 MISC

=head2 import

Importing Mouse will set your class' superclass list to L<Mouse::Object>.
You may use L</extends> to replace the superclass list.

=head2 unimport

Please unimport Mouse so that if someone calls one of the keywords (such as
L</extends>) it will break loudly instead breaking subtly.

=head1 FUNCTIONS

=head2 load_class Class::Name

This will load a given Class::Name> (or die if it's not loadable).
This function can be used in place of tricks like
C<eval "use $module"> or using C<require>.

=head1 AUTHOR

Shawn M Moore, C<< <sartak at gmail.com> >>

=head1 BUGS

No known bugs.

Please report any bugs through RT: email
C<bug-mouse at rt.cpan.org>, or browse
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Mouse>.

=head1 COPYRIGHT AND LICENSE

Copyright 2008 Shawn M Moore.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
