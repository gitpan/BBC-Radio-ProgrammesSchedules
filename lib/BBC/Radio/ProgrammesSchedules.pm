package BBC::Radio::ProgrammesSchedules;

use strict; use warnings;

use overload q("") => \&as_string, fallback => 1;

use Carp;
use Readonly;
use Data::Dumper;
use LWP::UserAgent;
use HTTP::Request;

=head1 NAME

BBC::Radio::ProgrammesSchedules - Interface to BBC Radio programmes schedules.

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

Readonly my $BASE_URL => 'http://www.bbc.co.uk';
Readonly my $CHANNELS => 
{
    radio1             => 'Radio 1',
    '1xtra'            => '1Xtra',
    radio2             => 'Radio 2',
    radio3             => 'Radio 3',
    radio4             => 'Radio 4',
    radio4extra        => 'Radio 4 Extra',
    '5live'            => '5 Live',
    '5livesportsextra' => '5 Live sports extra',
    '6music'           => '6 Music',
    radio7             => 'Radio 7',
    aisannetwork       => 'Asian Network',
    worldservice       => 'World Service'
};

Readonly my $LOCATIONS =>
{
    radio1 => { england         => 'England',
                northernireland => 'Northern Ireland',
                scotland        => 'Scotland',
                wales           => 'Wales' },
    radio4 => { fm => 'FM',
                lw => 'LW' }
};

=head1 SYNOPSIS

Each week, nearly 35 million people listen to BBC Radio. The BBC offers a portfolio of services aimed
at offering listeners the highest quality programmes, whatever their interest or mood.

=head2 BBC Radio includes

=over 5

=item * Music radio on Radio 1, Radio 1Xtra, Radio 2, 6 Music and Asian Network.

=item * Speech, drama, analysis and the arts on Radio 4.

=item * Classical music and jazz on Radio 3.

=item * News and sport on 5 live and 5 live sports extra.

=item * Comedy, drama and children's programming on Radio 7

and many more.

=back

=head1 CONSTRUCTOR

The  module  provides  programmes  schedules for Radio 1, 1Xtra, Radio 2, Radio 3, Radio 4,
Radio  4  Extra,  5  Live,  5 Live Sports Extra, 6 Music,  Radio 7, Asian Network and World
Service.  The  constructor expects a reference to an anonymous hash as input parameter. For
most of the radio channels, the minimum it expects are channel name, year, month(1 for Jan,
2 for Feb and so on)  and day.  However  for channel  Radio 1, you also need to provide the
location  information. The possible values are england (England), northernireland (Norhtern
Ireland), scotland(Scotland) and wales(Wales). And for channel Radio 4, the possible values
are FM & LW.

    use strict; use warnings;
    use BBC::Radio::ProgrammesSchedules;

    my ($bbc);

    # BBC Radio 1
    $bbc = BBC::Radio::ProgrammesSchedules->new({
           channel  => 'radio1',
           location => 'london',
           yyyy     => 2011,
           mm       => 4,
           dd       => 4 });

    # BBC Radio 1Xtra
    $bbc = BBC::Radio::ProgrammesSchedules->new({
           channel => '1xtra',
           yyyy    => 2011,
           mm      => 4,
           dd      => 4 });

    # BBC Radio 2
    $bbc = BBC::Radio::ProgrammesSchedules->new({
           channel => 'radio2',
           yyyy    => 2011,
           mm      => 4,
           dd      => 4 });

    # BBC Radio 3
    $bbc = BBC::Radio::ProgrammesSchedules->new({
           channel => 'radio3',
           yyyy    => 2011,
           mm      => 4,
           dd      => 4 });

    # BBC Radio 4
    $bbc = BBC::Radio::ProgrammesSchedules->new({
          channel  => 'radio4',
           location => 'fm',
           yyyy     => 2011,
           mm       => 4,
           dd       => 4 });

    # BBC Radio 4 Extra
    $bbc = BBC::Radio::ProgrammesSchedules->new({
           channel => 'radio4extra',
           yyyy    => 2011,
           mm      => 4,
           dd      => 4 });

    # BBC 5 Live
    $bbc = BBC::Radio::ProgrammesSchedules->new({
           channel => '5live',
           yyyy    => 2011,
           mm      => 4,
           dd      => 4 });

    # BBC 5 Live Sports Extra
    $bbc = BBC::Radio::ProgrammesSchedules->new({
           channel => '5livesportsextra',
           yyyy    => 2011,
           mm      => 4,
           dd      => 4 });

    # BBC 6 Music
    $bbc = BBC::Radio::ProgrammesSchedules->new({
           channel => '6music',
           yyyy    => 2011,
           mm      => 4,
           dd      => 4 });

    # BBC Radio 7
    $bbc = BBC::Radio::ProgrammesSchedules->new({
           channel => 'radio7',
           yyyy    => 2011,
           mm      => 4,
           dd      => 4 });

    # BBC Asian Network
    $bbc = BBC::Radio::ProgrammesSchedules->new({
           channel => 'aisannetwork',
           yyyy    => 2011,
           mm      => 4,
           dd      => 4 });

    # BBC World Service
    $bbc = BBC::Radio::ProgrammesSchedules->new({
           channel => 'worldservice',
           yyyy    => 2011,
           mm      => 4,
           dd      => 4 });

=cut

sub new
{
    my $class = shift;
    my $param = shift;

    my $self  = {};
    $self->{listings} = _get_listings($param);
    bless $self, $class;
    return $self;
}

=head1 METHODS

=head2 get_listings()

Return the schedules listings as reference to an array of anonymous hash containing
start time, end time, short description and url to get more detail of each program.

    use strict; use warnings;
    use BBC::Radio::ProgrammesSchedules;

    my $bbc = BBC::Radio::ProgrammesSchedules->new({
              channel  => 'radio1',
              location => 'london',
              yyyy     => 2011,
              mm       => 4,
              dd       => 4 });
    my $listings = $bbc->get_listings();

=cut

sub get_listings
{
    my $self = shift;
    return $self->{listings};
}

=head2 as_string()

Returns listings in a human readable format.

    use strict; use warnings;
    use Date::Holidays::PAK;

    my $bbc = BBC::Radio::ProgrammesSchedules->new({
              channel  => 'radio1',
              location => 'london',
              yyyy     => 2011,
              mm       => 4,
              dd       => 4 });

    print $bbc->as_string();

    # or even simply
    print $bbc;

=cut

sub as_string
{
    my $self = shift;
    my ($listings);
    foreach (@{$self->{listings}})
    {
        $listings .= sprintf("  Start Time: %s\n", $_->{start_time});
        $listings .= sprintf("    End Time: %s\n", $_->{end_time});
        $listings .= sprintf("       Title: %s\n", $_->{title});
        $listings .= sprintf("         URL: %s\n", $_->{url});
        $listings .= "-------------------\n";
    }
    return $listings;
}

sub _get_listings
{
    my $param = shift;

    my $url   = sprintf("%s/%s/programmes/schedules", $BASE_URL, $param->{channel});
    $url .= '/'. $param->{location} 
        if (defined($param->{location}) && exists($LOCATIONS->{$param->{channel}}->{$param->{location}}));
    $url .= '/'. join("/", $param->{yyyy}, $param->{mm}, $param->{dd}, "ataglance");

    my $browser  = LWP::UserAgent->new();
    my $request  = HTTP::Request->new(GET=>$url);
    my $response = $browser->request($request);
    croak("ERROR: Couldn't connect to [$url].\n") 
        unless $response->is_success;

    my ($contents, $listings, $program, $count);
    $contents = $response->content;
    $count    = 0;

    foreach (split(/\n/,$contents))
    {
        chomp;
        s/^\s+//g;
        s/\s+$//g;
        next if /^$/;

        if (/\<span class=\"starttime\"\>(.*)\<\/span\>\<span class=\"endtime\"\>&#8211\;(.*)\<\/span\>/)
{
            my($hh,$mm) = split/\:/,$1,2;
            last if ($count > 3 && $hh == 0);
            $program->{start_time} = $1;
            $program->{end_time}   = $2;
        }
        elsif (/class=\"url\" href=\"(.*)\"\>/)
        {
            $program->{url} = $BASE_URL . $1;
        }
        elsif (/class\=\"title\"\>(.*)\<\/span\>/)
        {
            $program->{title} = $1;
            push @$listings, $program if ((defined $program) && scalar(keys %{$program}) == 4);
            $program = undef;
            $count++;
        }
    }

    return $listings;
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-bbc-radio-programmesschedules at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=BBC-Radio-ProgrammesSchedules>.  
I will be notified, and then you'll automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc BBC::Radio::ProgrammesSchedules

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=BBC-Radio-ProgrammesSchedules>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/BBC-Radio-ProgrammesSchedules>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/BBC-Radio-ProgrammesSchedules>

=item * Search CPAN

L<http://search.cpan.org/dist/BBC-Radio-ProgrammesSchedules/>

=back

=head1 ACKNOWLEDGEMENT

BBC::Radio::ProgrammesSchedules provides infornmation from BBC office website. The information should be used
as it is without any additional information. BBC remains the owner of the data. The terms and condition for
Personal and Non-business use can be found here http://www.bbc.co.uk/terms/personal.shtml.

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Mohammad S Anwar.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 DISCLAIMER

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut

1; # End of BBC::Radio::ProgrammesSchedules