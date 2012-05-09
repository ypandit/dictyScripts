#!/usr/bin/perl
#===============================================================================
#
#         FILE: blast-filter.pl
#
#        USAGE: perl blast-filter.pl -i <blast-output-xml> -e <e-value> -o <output-file>
#
#  DESCRIPTION:
#
# REQUIREMENTS: Bio::SearchIO
#      CREATED: 03/28/2012 15:58:07
#===============================================================================

use strict;
use Getopt::Long;
use Bio::SearchIO;

my ( $help, $blast_xml, $eval, $out_file );

usage()
  if ( @ARGV < 1
    or !GetOptions( 'i=s' => \$blast_xml, 'e=s' => \$eval, 'o=s' => \$out_file )
    or defined $help );

my $FH;
if ( $out_file ne "" ) {
    $FH = IO::File->new( $out_file, "w" );
}
else {
    $FH = IO::Handle->new();
    $FH->fdopen( fileno(STDOUT), "w" );
}
filter( $blast_xml, $eval, $FH );

sub usage {
    print STDERR
"Usage:\tperl blast-filter.pl -i <blast-output-xml> -e <e-value> -o <output-file>\n";
    exit;
}

sub filter {
    my ( $xml, $e, $outF ) = @_;
    print STDERR "Input file - $xml\n";
    print STDERR "eValue threshold - $e\n";

    my $res = Bio::SearchIO->new( -format => 'blastxml', -file => $xml );
    while ( my $result = $res->next_result ) {    # One query at a time
        if ( $e ne "" ) {
            while ( my $hit = $result->next_hit )
            {    # Iterating 1-query -> All-targets
                if ( $hit->significance <= $e ) {
                    my $out =
                        $result->query_accession . " | "
                      . ( split /\|/, $result->query_description )[2] . " | "
                      . $hit->accession . " | "
                      . $hit->significance . "\n";
                    $outF->print(
                        ( split /\|/, $result->query_description )[2] . "\n" );
                    last;
                }
            }
        }
        else {
            $outF->print(
                ( split /\|/, $result->query_description )[2] . "\n" );
        }
    }
    $outF->close();
}
