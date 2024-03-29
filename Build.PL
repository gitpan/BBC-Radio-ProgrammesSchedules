use strict;use warnings;
use Module::Build;

my $builder = Module::Build->new(
    sign              => 1,
    module_name       => 'BBC::Radio::ProgrammesSchedules',
    license           => 'perl',
    dist_author       => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    dist_version_from => 'lib/BBC/Radio/ProgrammesSchedules.pm',
    add_to_cleanup    => [ 'BBC-Radio-ProgrammesSchedules-*' ],
    build_requires    => {
        'Test::More'      => 0,
        'Readonly'        => 0,
        'HTML::Entities'  => 0,
        'Time::localtime' => '1.02',
        'HTTP::Request'   => '1.40',
        'LWP::UserAgent'  => '2.33',
    },
);

$builder->create_build_script();