# $Id: Makefile.PL 578 2005-11-20 22:52:08Z sungo $

use 5.006001;
use inc::Module::Install;

name            ('POE-Component-Server-Syslog');
author          ('Matt Cashner (sungo@pobox.com)');
version_from    ('VERSION');
abstract_from	('lib/POE/Component/Server/Syslog.pm');
license         ('bsd');
perl_version	('5.006001');

build_requires	('Test::More' => 0.47);
requires        ('POE' => 0.24);
requires	('POE::Driver::SysRW' => 0);
requires	('POE::Wheel::SocketFactory' => 0);
requires	('POE::Wheel::ReadWrite' => 0);
requires        ('Params::Validate');
requires        ('IO::Socket');
requires        ('IO::Socket::INET');
requires        ('Time::ParseDate');
requires        ('Test::More');
requires        ('Carp');

sign            (1);

WriteAll();
