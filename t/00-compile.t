
use Test::More tests => 4;
BEGIN { 
	use_ok('POE::Filter::Syslog');
	use_ok('POE::Component::Server::Syslog');
	use_ok('POE::Component::Server::Syslog::UDP');
	use_ok('POE::Component::Server::Syslog::TCP');
}
