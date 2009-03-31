# $Id: Syslog.pm 579 2005-11-20 22:52:26Z sungo $
package POE::Filter::Syslog;

use warnings;
use strict;

use POE;
use Time::ParseDate;

our $VERSION = '1.16';

our $SYSLOG_REGEXP = q|
^<(\d+)>                       # priority -- 1
	(?:
		(\S{3})\s+(\d+)        # month day -- 2, 3
		\s
		(\d+):(\d+):(\d+)      # time  -- 4, 5, 6
	)?
	\s*
	(.*)                       # text  --  7
$
|;

sub new {
	return bless {
		buffer => '',
	}, shift;
}

sub get_one_start {
	my $self = shift;
	my $input = shift;
	$self->{buffer} .= join("",@$input);
}

sub get {
	my $self = shift;
	my $incoming = shift;
	return [] unless $incoming and @$incoming;
	my $stream = join ("", @$incoming);

	my @found;
	if($stream and length $stream) {

		while ( $stream =~ s/$SYSLOG_REGEXP//sx ) {
			my $time = $2 && parsedate("$2 $3 $4:$5:$6");
			$time ||= time();

			my $msg  = {
				time     => $time,
				pri      => $1,
				facility => int($1/8),
				severity => int($1%8),
				msg      => $7,
			};
			push @found, $msg;
		}
	}
	return \@found;
}


sub get_one {
	my $self = shift;
	my $found = 0;
	if($self->{buffer} and length $self->{buffer}) {
		if ( $self->{buffer} =~ s/$SYSLOG_REGEXP//sx ) {
			my $time = $2 && parsedate("$2 $3 $4:$5:$6");
			my $msg  = {
				time     => $time,
				pri      => $1,
				facility => int($1/8),
				severity => int($1%8),
				msg      => $7,
			};
			$found = $msg;
		}
	}
	if($found) {
		return [ $found ];
	} else {
		return [];
	}
}

sub put {} # XXX

1;
__END__

=pod

=head1 NAME

POE::Filter::Syslog - syslog parser

=head1 AUTHOR

Matt Cashner (sungo@cpan.org)

=head1 SYNOPSIS

  my $filter = POE::Filter::Syslog->new();
  $filter->get_one_start($buffer);
  while( my $record = $filter->get_one() ) {

  }

=head1 DESCRIPTION

This module follows the POE::Filter specification. Actually, it
technically supports both the older specification (C<get>) and the newer
specification (C<get_one>). If, at some point, POE deprecates the older
specification, this module will drop support for it. As such, only use
of the newer specification is recommended.

=head1 CONSTRUCTOR

=over

=item new

Creates a new filter object.

=back

=head1 METHODS

=over

=item get

=item get_one_start

=item get_one

C<get_one> returns a list of records with the following fields:

=over 4

=item * time

The time of the datagram (as specified by the datagram itself)

=item * pri

The priority of message.

=item * facility

The "facility" number decoded from the pri.

=item * severity

The "severity" number decoded from the pri.

=item * host

The host that sent the message.

=item * msg

The message itself. This often includes a process name, pid number, and
user name.

=back

=back

=head1 BUGS / CAVEATS

=over

=item * C<put> is not supported yet.

=back

=head1 DATE

$Date: 2005-11-20 17:52:26 -0500 (Sun, 20 Nov 2005) $

=head1 REVISION

$Rev: 579 $

Note: This does not necessarily correspond to the distribution version number.

=head1 LICENSE

Copyright (c) 2003-2005, Matt Cashner. All rights reserved.

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
