# $Id: Syslog.pm 446 2004-12-27 00:57:57Z sungo $
package POE::Component::Server::Syslog;

# Docs at the end.

use 5.006001;
use warnings;
use strict;

use POE;
use POE::Component::Server::Syslog::TCP;
use POE::Component::Server::Syslog::UDP;

our $VERSION = '1.16';

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
__END__

=pod

=head1 NAME

POE::Component::Server::Syslog - syslog services for POE

=head1 AUTHOR

Matt Cashner (sungo@cpan.org)

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

=head1 DATE

$Date: 2004-12-26 19:57:57 -0500 (Sun, 26 Dec 2004) $

=head1 REVISION

$Rev: 446 $

Note: This does not necessarily correspond to the distribution version number.

=head1 LICENSE

Copyright (c) 2003-2004, Matt Cashner. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

=over 4

=item * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

=item * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

=item * Neither the name of the Matt Cashner nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

=back

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

# sungo // vim: ts=4 sw=4 noexpandtab
