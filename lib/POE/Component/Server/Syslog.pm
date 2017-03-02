# $Id: Syslog.pm 446 2004-12-27 00:57:57Z sungo $
package POE::Component::Server::Syslog;

#ABSTRACT: syslog services for POE

# Docs at the end.

use 5.006001;
use warnings;
use strict;

use POE;
use POE::Component::Server::Syslog::TCP;
use POE::Component::Server::Syslog::UDP;

sub spawn {
	my $class = shift;
	my %args = @_;
	my $type = delete $args{Type};

	my $s;
	if($type) {
		if($type eq 'tcp') {
			$s = POE::Component::Server::Syslog::TCP->spawn(
				%args,
			);
		} elsif ($type eq 'udp') {
			$s = POE::Component::Server::Syslog::UDP->spawn(
				%args,
			);
		} else {
			return undef;
		}
	} else {
		$s = POE::Component::Server::Syslog::UDP->spawn(
			%args,
		);
	}
	return $s;
}

1;

=pod

=head1 SYNOPSIS

    POE::Component::Server::Syslog->spawn(
        Type        => 'udp', # or 'tcp'
        BindAddress => '127.0.0.1',
        BindPort    => '514',
        InputState  => \&input,
    );

    sub input {
        my $message = $_[ARG0];
        # .. do stuff ..
    }

=head1 DESCRIPTION

This component provides very simple syslog services for POE.

=head1 METHODS

=head2 spawn()

Spawns a new listener. Requires one argument, C<Type>, which defines the
subclass to be invoked. This value can be either 'tcp' or 'udp'.  All
other arguments are passed on to the subclass' constructor. See
L<POE::Component::Server::Syslog::TCP> and
L<POE::Component::Server::Syslog::UDP> for specific documentation.  For
backward compatibility, C<Type> defaults to udp.

=cut

# sungo // vim: ts=4 sw=4 noexpandtab
