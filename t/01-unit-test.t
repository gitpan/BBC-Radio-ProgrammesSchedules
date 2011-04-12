#!perl

use strict; use warnings;
use BBC::Radio::ProgrammesSchedules;
use Test::More tests => 9;

my ($bbc);

eval { $bbc = BBC::Radio::ProgrammesSchedules->new(channel => 'radio1'); };
like($@, qr/ERROR: Input param has to be a ref to HASH./);

eval { $bbc = BBC::Radio::ProgrammesSchedules->new({xyz => 'radio2'}); };
like($@, qr/ERROR: Missing key channel./);

eval { $bbc = BBC::Radio::ProgrammesSchedules->new({channel => 'radiox'}); };
like($@, qr/ERROR: Invalid value for channel./);

eval { $bbc = BBC::Radio::ProgrammesSchedules->new({channel => 'radio1'}); };
like($@, qr/ERROR: Invalid number of keys found in the input hash./);

eval { $bbc = BBC::Radio::ProgrammesSchedules->new({channel => 'radio4'}); };
like($@, qr/ERROR: Invalid number of keys found in the input hash./);

eval { $bbc = BBC::Radio::ProgrammesSchedules->new({channel => 'radio1', xyz => 1}); };
like($@, qr/ERROR: Missing key location./);

eval { $bbc = BBC::Radio::ProgrammesSchedules->new({channel => 'radio4', xyz => 1}); };
like($@, qr/ERROR: Missing key frequency./);

eval { $bbc = BBC::Radio::ProgrammesSchedules->new({channel => 'radio1', location => 1}); };
like($@, qr/ERROR: Invalid value for location./);

eval { $bbc = BBC::Radio::ProgrammesSchedules->new({channel => 'radio4', frequency => 1}); };
like($@, qr/ERROR: Invalid value for frequency./);