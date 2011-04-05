use strict;use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'BBC::Radio::ProgrammesSchedules',
    AUTHOR        => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    VERSION_FROM  => 'lib/BBC/Radio/ProgrammesSchedules.pm',
    ABSTRACT_FROM => 'lib/BBC/Radio/ProgrammesSchedules.pm',
    dist          => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean         => { FILES => 'BBC-Radio-ProgrammesSchedules-*' },
    PREREQ_PM     => {
        'Test::More'      => 0,
        'Readonly'        => 0,
        'HTML::Entities'  => 0,
        'Time::localtime' => '1.02',
        'HTTP::Request'   => '1.40',
        'LWP::UserAgent'  => '2.33',
    },
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
);